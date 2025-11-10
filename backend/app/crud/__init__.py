from typing import List, Optional

from sqlalchemy.orm import Session

from ..core.security import get_password_hash, verify_password
from ..models import Answer, Question, Tag, User
from ..schemas import (
    AnswerCreate,
    AnswerUpdate,
    QuestionCreate,
    QuestionUpdate,
    UserCreate,
    UserUpdate,
)


# User CRUD
def get_user(db: Session, user_id: int) -> Optional[User]:
    return db.query(User).filter(User.id == user_id).first()


def get_user_by_email(db: Session, email: str) -> Optional[User]:
    return db.query(User).filter(User.email == email).first()


def get_user_by_username(db: Session, username: str) -> Optional[User]:
    return db.query(User).filter(User.username == username).first()


def create_user(db: Session, user: UserCreate) -> User:
    hashed_password = get_password_hash(user.password)
    db_user = User(
        email=user.email,
        username=user.username,
        hashed_password=hashed_password,
        full_name=user.full_name,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def authenticate_user(db: Session, username: str, password: str) -> Optional[User]:
    user = get_user_by_username(db, username)
    if not user:
        return None
    if not verify_password(password, user.hashed_password):
        return None
    return user


# Question CRUD
def get_questions(db: Session, skip: int = 0, limit: int = 100) -> List[Question]:
    return db.query(Question).offset(skip).limit(limit).all()


def get_question(db: Session, question_id: int) -> Optional[Question]:
    return db.query(Question).filter(Question.id == question_id).first()


def create_question(db: Session, question: QuestionCreate, author_id: int) -> Question:
    db_question = Question(**question.dict(), author_id=author_id)
    db.add(db_question)
    db.commit()
    db.refresh(db_question)
    return db_question


def update_question(
    db: Session, question_id: int, question_update: QuestionUpdate
) -> Optional[Question]:
    db_question = db.query(Question).filter(Question.id == question_id).first()
    if db_question:
        update_data = question_update.dict(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_question, key, value)
        db.commit()
        db.refresh(db_question)
    return db_question


def increment_question_views(db: Session, question_id: int):
    db_question = db.query(Question).filter(Question.id == question_id).first()
    if db_question:
        db_question.views += 1
        db.commit()


# Answer CRUD
def get_answers_by_question(db: Session, question_id: int) -> List[Answer]:
    return db.query(Answer).filter(Answer.question_id == question_id).all()


def create_answer(db: Session, answer: AnswerCreate, author_id: int) -> Answer:
    db_answer = Answer(**answer.dict(), author_id=author_id)
    db.add(db_answer)
    db.commit()
    db.refresh(db_answer)
    return db_answer


def update_answer(
    db: Session, answer_id: int, answer_update: AnswerUpdate
) -> Optional[Answer]:
    db_answer = db.query(Answer).filter(Answer.id == answer_id).first()
    if db_answer:
        update_data = answer_update.dict(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_answer, key, value)
        db.commit()
        db.refresh(db_answer)
    return db_answer


def delete_answer(db: Session, answer_id: int) -> bool:
    db_answer = db.query(Answer).filter(Answer.id == answer_id).first()
    if db_answer:
        db.delete(db_answer)
        db.commit()
        return True
    return False
