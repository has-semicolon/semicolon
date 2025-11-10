from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..core.database import get_db
from ..core.dependencies import get_current_active_user
from ..crud import create_answer, delete_answer, get_question, update_answer
from ..models import User
from ..schemas import Answer, AnswerCreate, AnswerUpdate

router = APIRouter()


@router.post("/", response_model=Answer)
def create_answer_endpoint(
    answer: AnswerCreate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    # Check if question exists
    db_question = get_question(db, question_id=answer.question_id)
    if db_question is None:
        raise HTTPException(status_code=404, detail="Question not found")

    return create_answer(db=db, answer=answer, author_id=current_user.id)


@router.put("/{answer_id}", response_model=Answer)
def update_answer_endpoint(
    answer_id: int,
    answer_update: AnswerUpdate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    db_answer = db.query(Answer).filter(Answer.id == answer_id).first()
    if db_answer is None:
        raise HTTPException(status_code=404, detail="Answer not found")

    if db_answer.author_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")

    return update_answer(db=db, answer_id=answer_id, answer_update=answer_update)


@router.delete("/{answer_id}")
def delete_answer_endpoint(
    answer_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    db_answer = db.query(Answer).filter(Answer.id == answer_id).first()
    if db_answer is None:
        raise HTTPException(status_code=404, detail="Answer not found")

    if db_answer.author_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")

    success = delete_answer(db=db, answer_id=answer_id)
    if not success:
        raise HTTPException(status_code=400, detail="Failed to delete answer")

    return {"message": "Answer deleted successfully"}
