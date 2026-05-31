import os
import httpx
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="TrueNorth AI Coach API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

OPENROUTER_API_KEY = os.environ.get("OPENROUTER_API_KEY", "").strip()
OPENROUTER_MODEL = os.environ.get("OPENROUTER_MODEL", "deepseek/deepseek-v4-flash-free").strip()
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"

SYSTEM_PROMPT = """You are TrueNorth Coach, a warm, empathetic wellness coach for an app called TrueNorth. Your users are people on a weight loss and wellness journey — primarily plus-size men and women who want shame-free support.

Core principles:
- NEVER shame, guilt, or pressure. No "cheat days" or "bad foods."
- Celebrate small wins. Progress over perfection.
- Be warm, supportive, and practical.
- Suggest small, achievable steps.
- If someone is struggling, offer kindness first, advice second.
- Keep responses concise (2-4 sentences) and encouraging.
- Never give medical advice. Suggest consulting a doctor for medical concerns.
- Use the app's features: journaling, movement library, nourish log, SOS grounding.
- Address the user by their name occasionally to keep it personal.

Tone: Warm, supportive, like a kind friend who believes in you completely. Use casual language, occasional emojis. Make the user feel seen and capable."""


class ChatRequest(BaseModel):
    message: str
    user_name: str = "there"


class ChatResponse(BaseModel):
    reply: str
    model: str


@app.get("/")
async def root():
    return {"status": "ok", "service": "TrueNorth AI Coach", "model": OPENROUTER_MODEL}


@app.get("/health")
async def health():
    return {"status": "healthy", "key_configured": bool(OPENROUTER_API_KEY)}


@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest):
    if not OPENROUTER_API_KEY:
        raise HTTPException(status_code=500, detail="OpenRouter API key not configured on server")

    # Inject user name into system prompt
    system = SYSTEM_PROMPT.replace("the user", req.user_name)

    async with httpx.AsyncClient(timeout=30) as client:
        try:
            resp = await client.post(
                OPENROUTER_URL,
                headers={
                    "Authorization": f"Bearer {OPENROUTER_API_KEY}",
                    "Content-Type": "application/json",
                    "HTTP-Referer": "https://truenorth-app.com",
                    "X-Title": "TrueNorth Wellness",
                },
                json={
                    "model": OPENROUTER_MODEL,
                    "messages": [
                        {"role": "system", "content": system},
                        {"role": "user", "content": req.message},
                    ],
                    "max_tokens": 300,
                    "temperature": 0.7,
                },
            )
            data = resp.json()
            # Safely extract the reply
            choices = data.get("choices", [])
            if not choices:
                error_msg = data.get("error", {}).get("message", str(data))
                raise HTTPException(status_code=502, detail=f"OpenRouter returned no choices: {error_msg}")
            reply = choices[0]["message"]["content"]
            return ChatResponse(reply=reply, model=OPENROUTER_MODEL)
        except HTTPException:
            raise
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))
