from pydantic import BaseModel, Field

class UserBase(BaseModel):
    phoneNumber: str = Field(..., alias='phoneNumber')

class UserCreate(UserBase):
    password: str
    username: str | None = None

class UserResponse(UserBase):
    id: int
    username: str | None = None

    class Config:
        orm_mode = True
        allow_population_by_field_name = True

class UserLogin(UserBase):
    password: str

class UpdateUsername(BaseModel):
    userId: int = Field(..., alias='userId')
    username: str

class Token(BaseModel):
    token: str

class PhoneNumberCheckRequest(BaseModel):
    phoneNumber: str = Field(..., alias='phoneNumber')

class PhoneNumberCheckResponse(BaseModel):
    registered: bool