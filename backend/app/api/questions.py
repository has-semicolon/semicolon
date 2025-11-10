from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from ..core.database import get_db
from ..core.dependencies import get_current_active_user
from ..crud import (
    create_question,
    get_answers_by_question,
    get_question,
    get_questions,
    increment_question_views,
    update_question,
)
from ..models import User
from ..schemas import Answer, Question, QuestionCreate, QuestionUpdate

router = APIRouter()


@router.get("/", response_model=List[Question])
def read_questions(
    skip: int = 0,
    limit: int = Query(default=100, le=100),
    db: Session = Depends(get_db),
):
    questions = get_questions(db, skip=skip, limit=limit)
    return questions


@router.post("/", response_model=Question)
def create_question_endpoint(
    question: QuestionCreate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    return create_question(db=db, question=question, author_id=current_user.id)


@router.get("/{question_id}", response_model=Question)
def read_question(question_id: int, db: Session = Depends(get_db)):
    db_question = get_question(db, question_id=question_id)
    if db_question is None:
        raise HTTPException(status_code=404, detail="Question not found")

    # Increment views
    increment_question_views(db, question_id)

    return db_question


@router.put("/{question_id}", response_model=Question)
def update_question_endpoint(
    question_id: int,
    question_update: QuestionUpdate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    db_question = get_question(db, question_id=question_id)
    if db_question is None:
        raise HTTPException(status_code=404, detail="Question not found")

    if db_question.author_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")

    return update_question(
        db=db, question_id=question_id, question_update=question_update
    )


@router.get("/{question_id}/answers", response_model=List[Answer])
def read_question_answers(question_id: int, db: Session = Depends(get_db)):
    db_question = get_question(db, question_id=question_id)
    if db_question is None:
        raise HTTPException(status_code=404, detail="Question not found")

    return get_answers_by_question(db, question_id=question_id)
