import json
from flask import Flask, request, jsonify
import google.generativeai as genai
import re  # Import the regular expression module
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

API_KEY = "AIzaSyCX5dXv2A8cuUn11G5GZEDM50yw_xiEZR0"  # Replace with your actual API key
if API_KEY:
    genai.configure(api_key=API_KEY)

def generate_mcq_gemini(topic, num_questions=5):
    prompt = f"""
    Generate {num_questions} multiple-choice questions on the topic '{topic}'.
    Return the output strictly in valid JSON format as follows:
    {{
        "questions": [
            {{
                "question": "Your question here?",
                "options": ["Option A", "Option B", "Option C", "Option D"],
                "answer": "Correct option"
            }},
            ...
        ]
    }}
    Ensure the response is a valid JSON object. Do not include any additional text outside of the json block. Do not add any markdown code blocks.
    """

    model = genai.GenerativeModel("gemini-1.5-pro")
    response = model.generate_content(prompt)

    print("Raw API Response:", response.text)

    if not response.text.strip():
        return {"error": "Gemini API returned an empty response"}

    # Remove markdown code block
    json_string = re.search(r'```json\s*({.*})\s*```', response.text, re.DOTALL)
    if json_string:
        json_string = json_string.group(1)
    else:
        # if the json block is not found, attempt to parse the entire string.
        json_string = response.text.strip()

    try:
        mcq_data = json.loads(json_string)
        return mcq_data.get("questions", [])
    except json.JSONDecodeError as e:
        return {"error": f"Failed to parse response: {str(e)}"}

@app.route("/generate_mcq", methods=["POST"])
def generate_mcq_api():
    data = request.json
    topic = data.get("topic", "general knowledge")
    num_questions = data.get("num_questions", 5)

    mcq_data = {
        "topic": topic,
        "questions": generate_mcq_gemini(topic, num_questions)
    }

    return jsonify(mcq_data)

if __name__ == "__main__":
    app.run(debug=True,port=9000)