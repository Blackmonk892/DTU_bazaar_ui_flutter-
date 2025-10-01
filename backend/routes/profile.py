from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordBearer
from database import SessionLocal
from auth import decode_token
from models import Profile
from schemas import ProfileRead, ProfileUpdate

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl = "login")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/me/profile", response_model= ProfileRead)
def read_profile(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    user = decode_token(token, db)
    if not user.profile:
        profile = Profile(user_id = user.id)
        db.add(profile)
        db.commit()
        db.refresh(profile)
    return user.profile

@router.put("/me/profile", response_model=ProfileRead)
def update_profile(
    profile_in: ProfileUpdate,
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
):
    
    user = decode_token(token, db)
    profile = user.profile
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    
    profile.name = profile_in.name
    profile.phone = profile_in.phone
    profile.instagram = profile_in.instagram
    db.commit()
    db.refresh(profile)
    return profile