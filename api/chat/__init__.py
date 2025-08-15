import os
import json
import azure.functions as func
from google import genai

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        # 入力取得
        req_body = req.get_json()
        prompt = req_body.get("prompt", "")

        if not prompt:
            return func.HttpResponse(
                json.dumps({"error": "prompt is required"}),
                status_code=400,
                mimetype="application/json"
            )

        # APIキー取得
        api_key = os.environ.get("GOOGLE_API_KEY")
        if not api_key:
            return func.HttpResponse(
                json.dumps({"error": "API key not set"}),
                status_code=500,
                mimetype="application/json"
            )

        # クライアント生成
        client = genai.Client(api_key=api_key)

        # 生成呼び出し
        response = client.models.generate_content(
            model="gemini-2.5-flash",
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
