from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordBearer
from typing import List
from crud import get_current_user
import models, schemas, crud
from auth import decode_token
from utils import get_db
from schemas import ProductCreate

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


@router.post("/products/")
def post_product(
    product: ProductCreate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return crud.create_product(db=db, product=product, seller_id=current_user.id)


@router.post("/products/{product_id}/images")
def upload_image(
    product_id: int,
    image: dict,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return crud.add_product_image(db=db, product_id=product_id, image_data=image["image_data"])


@router.get("/search/", response_model=List[schemas.ProductOut])
def search_products(query: str = "", db: Session = Depends(get_db)):
    return crud.get_available_products(db, query)


@router.post("/buy/")
def buy_product(
    product_id: int,
    buyer_id: int,
    db: Session = Depends(get_db)
):
    return crud.add_to_cart(db, buyer_id, product_id)


@router.post("/product/sold/")
def sell_confirm(
    product_id: int,
    db: Session = Depends(get_db)
):
    return crud.mark_product_sold(db, product_id)


@router.get("/mycart/", response_model=List[schemas.CartItemOut])
def get_cart(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return crud.get_cart_items_for_user(db, current_user.id)


@router.get("/me/history")
def get_user_history(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    user = decode_token(token, db)
    selling = crud.get_user_selling_history(db, user.id)
    buying = crud.get_user_buying_history(db, user.id)

    return {
        "selling": selling,
        "buying": buying,
    }

