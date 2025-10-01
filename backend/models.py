from sqlalchemy import Column, Integer, String, ForeignKey, Boolean, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from datetime import datetime, timezone

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
   
    
    profile = relationship("Profile", uselist=False, back_populates="user")
    selling_history = relationship("Product", back_populates="seller")
    buying_history = relationship("CartItem", back_populates="buyer")



class Profile(Base):
    __tablename__ = "profiles"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True)
    
    name = Column(String, default="")
    phone = Column(String, default="")
    instagram = Column(String, default="")
    
    user = relationship("User", back_populates="profile")



class Product(Base):  
    __tablename__ = "products"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable = False)
    description = Column(String, nullable = False)
    price = Column(Integer, nullable = False)
    is_sold = Column(Boolean, default=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    phone = Column(String, default = "")
    instagram = Column(String, default= "")
    upi = Column(String, default = "")

    seller_id = Column(Integer, ForeignKey("users.id"))
    seller = relationship("User", back_populates="selling_history")

    images = relationship("ProductImage", back_populates="product", cascade="all, delete")

class ProductImage(Base):
    __tablename__ = "product_images"

    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"))
    image_data = Column(String)  # store as base64 string or image URL if using S3/local

    product = relationship("Product", back_populates="images")


class CartItem(Base):
    __tablename__ = "cart_items"
    
    id = Column(Integer, primary_key=True)
    buyer_id = Column(Integer, ForeignKey("users.id"))
    product_id = Column(Integer, ForeignKey("products.id"))
    timestamp = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    
    buyer = relationship("User", back_populates="buying_history")
    product = relationship("Product")
