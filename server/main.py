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
OPENROUTER_MODEL = os.environ.get("OPENROUTER_MODEL", "nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free").strip()
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"

SYSTEM_PROMPT_TEMPLATE = """You are TrueNorth Coach, a professional, knowledgeable wellness coach for the TrueNorth app. Your client's name is {user_name} — address them by name in conversation to build rapport and trust.

Your role is to guide {user_name} on their wellness journey with evidence-informed, practical advice. You are warm, supportive, and professional — like a highly skilled personal coach who genuinely cares.

Core principles:
- Communicate with warmth and professionalism. Be supportive but authoritative.
- Use positive, empowering language. No guilt, shame, or pressure. Reframe setbacks as data, not failures.
- Celebrate progress, however small. Acknowledge effort consistently.
- Keep responses concise and actionable (2-4 sentences). Give one clear next step when appropriate.
- Address {user_name} by name naturally within the conversation.
- Never give medical advice. Recommend consulting a doctor for health concerns.
- Reference the app's features when relevant: journaling, movement library, nourish log, SOS grounding exercises, water tracking.
- Use emojis sparingly — one per message maximum, only when genuinely fitting.

Tone: Professional yet warm. Think of a respected wellness coach who listens carefully, speaks clearly, and genuinely believes in {user_name}'s ability to grow. Avoid casual slang. Be direct but kind."""


class ChatRequest(BaseModel):
    message: str
    user_name: str = "there"
    history: list[dict] = []


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
    system = SYSTEM_PROMPT_TEMPLATE.format(user_name=req.user_name)

    # Build messages with conversation history
    messages = [{"role": "system", "content": system}]
    for msg in req.history:
        role = "user" if msg.get("is_user") else "assistant"
        messages.append({"role": role, "content": msg.get("text", "")})
    messages.append({"role": "user", "content": req.message})

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
                    "messages": messages,
                    "max_tokens": 300,
                    "temperature": 0.7,
                },
            )
            data = resp.json()
            choices = data.get("choices", [])
            if not choices:
                error_msg = data.get("error", {}).get("message", str(data))
                raise HTTPException(status_code=502, detail=f"OpenRouter error: {error_msg}")
            reply = choices[0]["message"]["content"]
            return ChatResponse(reply=reply, model=OPENROUTER_MODEL)
        except HTTPException:
            raise
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))
