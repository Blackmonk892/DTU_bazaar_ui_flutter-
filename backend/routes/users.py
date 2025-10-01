from fastapi import APIRouter,Depends,HTTPException
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from schemas import UserCreate,Token
from models import User
from database import SessionLocal
from auth import (
    hash_password,verify_password,create_access_token,get_user_by_email,decode_token
)

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/register", response_model=Token)
def register(user:UserCreate,db: Session = Depends(get_db)):
    if get_user_by_email(db,user.email):
        raise HTTPException(status_code=400, detail="Email already registered")
    new_user = User(email=user.email,hashed_password=hash_password(user.password))
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    token = create_access_token({"sub": new_user.email})
    return {"access_token": token, "token_type": "bearer"}


@router.post("/login",response_model=Token)
def login(user:UserCreate,db:Session = Depends(get_db)):
    db_user = get_user_by_email(db,user.email)
    if not db_user or not verify_password(user.password, db_user.hashed_password):
        raise HTTPException(status_code=401,detail="Invalid credentials")
    
    token = create_access_token({"sub": db_user.email})
    return {"access_token": token, "token_type": "bearer"}

@router.get("/me")
def read_me(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    user = decode_token(token, db)
    return {"email": user.email}