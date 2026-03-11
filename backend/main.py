from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # tighten this down in production
    allow_methods=["*"],
    allow_headers=["*"],
)

sample: list[dict] = [
    {
        "BAC": 0.04 ,
        "date": "March 1, 2026"
    },
    {
        "BAC": 0.04 ,
        "date": "March 1, 2026"
    }
]




@app.get("/")
def home():
    return{
        "message": "Hello World!"
    }

@app.get("/api/posts")
def get_posts():
    return sample
