import os
import json
import azure.functions as func
from google import genai

# 環境変数からGemini APIキーを取得
GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY")

# Geminiクライアント初期化
client = genai.Client(api_key=GEMINI_API_KEY)

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        # リクエストのJSONを取得
        req_body = req.get_json()
        prompt = req_body.get("prompt", "")

        if not prompt:
            return func.HttpResponse(
                json.dumps({"error": "prompt is required"}),
                status_code=400,
                mimetype="application/json"
            )

        # Geminiに問い合わせ
        response = client.models.generate_content(
            model="gemini-2.0-flash",
            contents=prompt
        )

        return func.HttpResponse(
            json.dumps({"reply": response.text}),
            mimetype="application/json"
        )

    except Exception as e:
        return func.HttpResponse(
            json.dumps({"error": str(e)}),
            status_code=500,
            mimetype="application/json"
        )
