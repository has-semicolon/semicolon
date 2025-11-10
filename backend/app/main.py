from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .api import answers, auth, questions, users
from .core.config import settings
from .core.database import Base, engine

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="Semicolon Developer Forum API",
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
)

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix=f"{settings.API_V1_STR}/auth", tags=["auth"])
app.include_router(
    questions.router, prefix=f"{settings.API_V1_STR}/questions", tags=["questions"]
)
app.include_router(
    answers.router, prefix=f"{settings.API_V1_STR}/answers", tags=["answers"]
)
app.include_router(users.router, prefix=f"{settings.API_V1_STR}/users", tags=["users"])


@app.get("/")
async def root():
    return {"message": "Semicolon Developer Forum API"}


@app.get("/health")
async def health_check():
    return {"status": "healthy"}
