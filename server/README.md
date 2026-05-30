# TrueNorth AI Coach — Backend Server
# Deploy on Render.com via GitHub

.
└── server/
    ├── main.py           # FastAPI app — AI chat endpoint
    ├── requirements.txt  # Python dependencies
    ├── Dockerfile        # Container setup for Render
    └── render.yaml       # Render.com config

## Local Development

```bash
cd server
pip install -r requirements.txt

# Set your OpenRouter key
export OPENROUTER_API_KEY="sk-or-v1-xxxxxxxx"
or
export OPENROUTER_API_KEY="your-api-key-here"

# Run the server
uvicorn main:app --reload --port 8000
```

## API Endpoints

### POST /chat
Send a message to the AI coach.

```json
{
  "message": "I'm feeling tired today",
  "user_name": "George"
}
```

Response:
```json
{
  "response": "Hey George! 💪...",
  "model": "deepseek/deepseek-v4-flash-free"
}
```

### GET /health
Health check. Returns `{"status": "ok"}`.

## Deploy to Render.com

1. Push this repo to GitHub
2. On Render.com → New Web Service → Connect your repo
3. Set:
   - **Runtime**: Docker
   - **Service Name**: truenorth-coach
   - **Environment Variables**:
     - `OPENROUTER_API_KEY` = your OpenRouter key
     - `MODEL` = deepseek/deepseek-v4-flash-free (or any model)
4. Click **Create** — Render auto-builds and deploys

Your app will be live at `https://truenorth-coach.onrender.com`

## Updating the Flutter App

Once deployed, update `lib/services/ai_coach_service.dart`:
- Change `_baseUrl` from `https://openrouter.ai/api/v1/chat/completions`
- To `https://truenorth-coach.onrender.com/chat`
