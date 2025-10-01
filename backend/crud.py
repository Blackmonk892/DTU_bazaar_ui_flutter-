from sqlalchemy.orm import Session
from datetime import datetime, timezone,timedelta
import models, schemas
from fastapi import Depends,HTTPException,status
from utils import get_db
from auth import decode_token
from jose.exceptions import JWTError
from fastapi.security import OAuth2PasswordBearer
from models import CartItem,Product



oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    try:
        user = decode_token(token, db)
        return user
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

# -------------------- PRODUCT LOGIC --------------------

def create_product(
        db:Session,
        product:schemas.ProductCreate,
        seller_id: int
):
    db_product = models.Product(
        title=product.title,
        description=product.description,
        price=product.price,
        phone=product.phone,
        instagram=product.instagram,
        upi=product.upi,
        seller_id=seller_id

    )
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return db_product


def add_product_image(
        db:Session,
        product_id: int,
        image_data: str
):
    db_image = models.ProductImage(
        product_id = product_id,
        image_data = image_data
    )
    db.add(db_image)
    db.commit()
    db.refresh(db_image)
    return db_image

def get_available_products(db:Session, search:str = ""):
    return (
        db.query(models.Product)
        .filter(models.product.is_sold == False)
        .filter(models.Product.title.ilike(f"%{search}%"))
        .all()
    )


# -------------------- CART LOGIC (BUYING) ------------------

def add_to_cart(db:Session, buyer_id: int, product_id: int):
    existing = (
        db.query(models.CartItem)
        .filter_by(buyer_id = buyer_id, product_id = product_id)
        .first()
    )
    if existing:
        return existing
    
    cart_item = models.CartItem(buyer_id = buyer_id, product_id = product_id)
    db.add(cart_item)
    db.commit()
    db.refresh()
    return cart_item


def get_cart_items_for_user(db:Session, user_id: int):
    return db.query(models.CartItem).filter_by(buyer_id=user_id).all()

# -------------------- MARKING & DELETION ------------------

def mark_product_sold(db: Session, product_id: int):
    product = db.query(models.Product).filter(models.Product.id == product_id).first()

    if product:
        product.is_sold = True
        product.created_at = datetime.now(timezone.utc)
        db.commit()
        db.refresh(product)
    return product


def delete_old_sold_products(db: Session):
    threshold = datetime.now(timezone.utc) - timedelta(days=5)
    old_products = (
        db.query(models.Product)
        .filter(models.Product.is_sold == True)
        .filter(models.Product.created_at < threshold)
        .all()
    )
    for product in old_products:
        db.delete(product)
    db.commit()
    return {"deleted_count": len(old_products)}


def get_user_selling_history(db: Session, user_id: int):
    products = db.query(Product).filter(Product.seller_id == user_id).all()
    return [
        {
            "title": p.title,
            "status": "Sold" if p.is_sold else "Available",
            "imageUrl": p.images[0].image_data if p.images else "",
        }
        for p in products
    ]


def get_user_buying_history(db: Session, user_id: int):
    cart_items = (
        db.query(CartItem)
        .filter(CartItem.buyer_id == user_id)
        .join(Product)
        .all()
    )
    return [
        {
            "title": ci.product.title,
            "seller": ci.product.seller.profile.name if ci.product.seller.profile else "Unknown",
            "imageUrl": ci.product.images[0].image_data if ci.product.images else "",
        }
        for ci in cart_items
    ]