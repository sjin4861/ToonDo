from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

from database import SessionLocal, engine
from models import Base, User
from schemas import PhoneNumberCheckRequest, PhoneNumberCheckResponse, UserCreate, UserResponse, UserLogin, UpdateUsername, Token
from crud import get_user_by_phone_number, create_user, get_user_by_id
from utils import verify_password, create_access_token, ACCESS_TOKEN_EXPIRE_MINUTES, JWTError, jwt, SECRET_KEY, ALGORITHM

Base.metadata.create_all(bind=engine)

app = FastAPI()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl='users/login')

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Exception for Credentials
credentials_exception = HTTPException(
    status_code=status.HTTP_401_UNAUTHORIZED,
    detail='Could not validate credentials',
    headers={'WWW-Authenticate': 'Bearer'},
)

# Get Current User
async def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get('sub')
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    user = get_user_by_id(db, user_id=int(user_id))
    if user is None:
        raise credentials_exception
    return user

# Routes

@app.post('/users/signup', response_model=UserResponse)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = get_user_by_phone_number(db, phone_number=user.phoneNumber)
    if db_user:
        raise HTTPException(status_code=400, detail='Phone number already registered')
    new_user = create_user(db=db, user=user)
    return UserResponse(
        id=new_user.id,
        phoneNumber=new_user.phone_number,
        username=new_user.username
    )

@app.post('/users/login', response_model=Token)
def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = get_user_by_phone_number(db, phone_number=user.phoneNumber)
    if not db_user:
        raise HTTPException(status_code=400, detail='Invalid credentials')
    if not verify_password(user.password, db_user.password):
        raise HTTPException(status_code=400, detail='Invalid credentials')
    access_token = create_access_token(
        data={'sub': str(db_user.id)},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    return Token(token=access_token)

@app.put('/users/update-my')
def update_username(update_data: UpdateUsername, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if current_user.id != update_data.userId:
        raise HTTPException(status_code=403, detail='Not authorized')
    current_user.username = update_data.username
    db.commit()
    db.refresh(current_user)
    return {'message': 'Nickname updated successfully'}

@app.post('/users/check-phone-number', response_model=PhoneNumberCheckResponse)
def check_phone_number(
    request: PhoneNumberCheckRequest,
    db: Session = Depends(get_db)
):
    db_user = get_user_by_phone_number(db, phone_number=request.phoneNumber)
    if db_user:
        return PhoneNumberCheckResponse(registered=True)
    else:
        return PhoneNumberCheckResponse(registered=False)