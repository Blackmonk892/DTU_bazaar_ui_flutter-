from fastapi import FastAPI
from models import Base
from database import engine
import models, crud
from sqlalchemy.orm import Session
from database import engine, SessionLocal
from contextlib import asynccontextmanager
from routes import users, profile,crud_endpoints
from fastapi.middleware.cors import CORSMiddleware


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup tasks
    db: Session = SessionLocal()
    crud.delete_old_sold_products(db)
    db.close()
    yield

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


Base.metadata.create_all(bind = engine)

app.include_router(users.router, tags = ["users"])
app.include_router(profile.router, tags=["profile"])
app.include_router(crud_endpoints.router,  tags=["CRUD"])
