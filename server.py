from flask import Flask, jsonify
import os
import logging
import main  # Importing the main module for processing

app = Flask(__name__)

@app.route('/')
def index():
    # Trigger the main processing function and return a status message
    try:
        main.main()  # Runs the main function from main.py
        return "UpTonight application is running and processed successfully"
    except Exception as e:
        logging.error("Error occurred during processing: %s", e)
        return jsonify({"error": "An error occurred during processing"}), 500

if __name__ == "__main__":
    # Set the port and host for Fly.io requirements
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
