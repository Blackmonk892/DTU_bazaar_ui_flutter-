from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime

# -------------------
# AUTH
# -------------------
class UserCreate(BaseModel):
    email: EmailStr
    password: str


class Token(BaseModel):
    access_token: str
    token_type: str


# -------------------
# PROFILE
# -------------------
class ProfileBase(BaseModel):
    name: str = Field("", example="Kabir Thapad")
    phone: str = Field("", example="92374 26783")
    instagram: str = Field("", example="@kabirthapadfr")


class ProfileCreate(ProfileBase):
    pass


class ProfileRead(ProfileBase):
    pass


class ProfileUpdate(ProfileBase):
    pass


# -------------------
# USER
# -------------------
class UserBase(BaseModel):
    email: EmailStr


class UserOut(UserBase):
    id: int
    profile: Optional[ProfileRead]

    class Config:
        from_attributes = True


# -------------------
# PRODUCT IMAGE
# -------------------
class ProductImageOut(BaseModel):
    id: int
    image_data: str

    class Config:
        from_attributes = True


# -------------------
# PRODUCTS
# -------------------
class ProductCreate(BaseModel):
    title: str
    description: str
    price: int
    phone: Optional[str] = ""
    instagram: Optional[str] = ""
    upi: Optional[str] = ""


class ProductOut(BaseModel):
    id: int
    title: str
    description: str
    price: int
    is_sold: bool
    created_at: datetime
    phone: str
    instagram: str
    upi: str
    images: List[ProductImageOut] = []

    class Config:
        from_attributes = True


# -------------------
# CART
# -------------------
class CartItemOut(BaseModel):
    id: int
    product: ProductOut
    timestamp: datetime

    class Config:
        from_attributes = True
