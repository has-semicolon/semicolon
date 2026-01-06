"""PostgreSQL 데이터베이스 내용 조회"""
from app.core.database import SessionLocal
from app.models import User, Question, Answer
from sqlalchemy import func

def view_database():
    db = SessionLocal()
    try:
        # 사용자 목록
        users = db.query(User).all()
        print("=" * 80)
        print("사용자 (Users)")
        print("=" * 80)
        for user in users:
            print(f"ID: {user.id} | Username: {user.username} | Email: {user.email} | Created: {user.created_at}")
        
        print("\n" + "=" * 80)
        print("질문 (Questions)")
        print("=" * 80)
        questions = db.query(Question).order_by(Question.id.desc()).all()
        for q in questions:
            print(f"ID: {q.id}")
            print(f"  제목: {q.title}")
            print(f"  내용: {q.content[:50]}...")
            print(f"  작성자: {q.author.username}")
            print(f"  생성일: {q.created_at}")
            print(f"  조회수: {q.views} | 해결됨: {q.is_solved}")
            print(f"  답변 수: {len(q.answers)}")
            print("-" * 80)
        
        print("\n" + "=" * 80)
        print("답변 (Answers)")
        print("=" * 80)
        answers = db.query(Answer).all()
        if answers:
            for ans in answers:
                print(f"ID: {ans.id}")
                print(f"  내용: {ans.content[:50]}...")
                print(f"  작성자: {ans.author.username}")
                print(f"  질문 ID: {ans.question_id}")
                print(f"  생성일: {ans.created_at}")
                print("-" * 80)
        else:
            print("아직 답변이 없습니다.")
        
        print("\n" + "=" * 80)
        print("통계 (Statistics)")
        print("=" * 80)
        total_users = db.query(func.count(User.id)).scalar()
        total_questions = db.query(func.count(Question.id)).scalar()
        total_answers = db.query(func.count(Answer.id)).scalar()
        print(f"총 사용자: {total_users}")
        print(f"총 질문: {total_questions}")
        print(f"총 답변: {total_answers}")
        
    finally:
        db.close()

if __name__ == "__main__":
    view_database()
