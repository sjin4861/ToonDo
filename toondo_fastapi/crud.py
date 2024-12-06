from sqlalchemy.orm import Session
from models import User
from schemas import UserCreate
from utils import get_password_hash

def get_user_by_phone_number(db: Session, phone_number: str):
    return db.query(User).filter(User.phone_number == phone_number).first()

def create_user(db: Session, user: UserCreate) -> User:
    hashed_password = get_password_hash(user.password)
    new_user = User(
        phone_number=user.phoneNumber,
        password=hashed_password,
        username=user.username or "default_username"
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

def get_user_by_id(db: Session, user_id: int):
    return db.query(User).filter(User.id == user_id).first()

def get_user_by_phone_number(db: Session, phone_number: str):
    return db.query(User).filter(User.phone_number == phone_number).first()