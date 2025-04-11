from flask import Flask, jsonify, request
from flask_cors import CORS
from flask import Flask, send_from_directory
import os

import football_crud
import socket

app = Flask(__name__)
CORS(app)

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
IMAGE_FOLDER = os.path.join(BASE_DIR, 'assets', 'images')

@app.route('/matches', methods=['GET'])
def get_matches():
    return jsonify(football_crud.get_all_matches())

@app.route('/matches/<int:match_id>', methods=['GET'])
def get_match(match_id):
    match = football_crud.get_match_by_id(match_id)
    return jsonify(match) if match else ('Match not found', 404)

@app.route('/matches', methods=['POST'])
def create_match():
    football_crud.create_match(request.json)
    return jsonify({'message': 'Match created'}), 201

@app.route('/matches/<int:match_id>', methods=['PUT'])
def update_match(match_id):
    football_crud.update_match(match_id, request.json)
    return jsonify({'message': 'Match updated'})

@app.route('/matches/<int:match_id>', methods=['DELETE'])
def delete_match(match_id):
    football_crud.delete_match(match_id)
    return jsonify({'message': 'Match deleted'})

@app.route('/standings', methods=['GET'])
def get_standings():
    return jsonify(football_crud.get_all_standings())

@app.route('/news', methods=['GET'])
def get_news():
    return jsonify(football_crud.get_all_news())

@app.route('/images/<path:filename>')
def serve_image(filename):
    return send_from_directory(IMAGE_FOLDER, filename)
if __name__ == '__main__':
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)

    print(f"\n Flask is running! Open in browser:")
    print(f"    http://{local_ip}:5000/\n")

    app.run(debug=True, host='0.0.0.0', port=5000)