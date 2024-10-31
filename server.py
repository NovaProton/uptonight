from flask import Flask
import main  # Assuming main.py contains the main processing logic

app = Flask(__name__)

@app.route('/')
def index():
    return "UpTonight application is running"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
