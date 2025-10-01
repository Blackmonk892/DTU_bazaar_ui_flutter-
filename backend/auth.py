
from sqlalchemy.orm import Session
from jose import jwt, JWTError
from passlib.context import CryptContext
from datetime import datetime, timedelta, timezone
from fastapi import HTTPException
from models import User

SECRET_KEY = "LF-TX8Q9LjZALtGp3lxaw873wUdkutBzeMbl3r3Epc6rTOgeDeV5PWE6UnXgEYtosG-fjG194zf82ApWzQ0qLg"
ALGORITHM = "HS256"
ACESS_TOKEN_EXPPIRE_MINUTES = 45



pwd_context = CryptContext(schemes =["bcrypt"], deprecated = "auto")


def hash_password(password:str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password,hashed_password)

def create_access_token(data: dict, expires_delta:timedelta = None) -> str:
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + (expires_delta or timedelta(minutes = 15))
    to_encode.update({"exp":expire})
    return jwt.encode(to_encode,SECRET_KEY,algorithm=ALGORITHM)

def get_user_by_email(db:Session,email:str):
    return db.query(User).filter(User.email == email).first()

def decode_token(token:str,db:Session):
    try:
        payload = jwt.decode(token,SECRET_KEY,algorithms=ALGORITHM)
        email = payload.get("sub")
        if not email:
             raise HTTPException(status_code=401, detail="Invalid token")
        user = get_user_by_email(db,email)
        if user is None:
            raise  HTTPException(status_code=401, detail="User not found")
        return user
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
        
