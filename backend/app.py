# from flask import Flask, jsonify, request
# from flask_cors import CORS
# from flask import Flask, send_from_directory
# import os
# from werkzeug.utils import secure_filename
# import football_crud
# import socket
# from db_config import get_connection
# app = Flask(__name__)
# CORS(app)

# BASE_DIR = os.path.abspath(os.path.dirname(__file__))
# IMAGE_FOLDER = os.path.join(BASE_DIR, 'assets', 'images')

# UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), 'assets', 'images')
# os.makedirs(UPLOAD_FOLDER, exist_ok=True)  # สร้างโฟลเดอร์ถ้ายังไม่มี

# app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# @app.route('/add_news', methods=['POST'])
# def add_news():
#     data = request.form
#     image = request.files.get('image')

#     filename = None
#     if image:
#         filename = secure_filename(image.filename)
#         image_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
#         try:
#             image.save(image_path)
#         except Exception as e:
#             return jsonify({'error': f'Failed to save image: {str(e)}'}), 500

#     conn = get_connection()
#     cursor = conn.cursor()
#     cursor.execute("""
#         INSERT INTO news (title, sport_type, description, source, contact_phone, contact_email, image, publish_date, verify)
#         VALUES (%s, %s, %s, %s, %s, %s, %s, NOW(), FALSE)
#     """, (
#         data.get('title'),
#         data.get('sport_type'),
#         data.get('description'),
#         data.get('source'),
#         data.get('contact_phone'),
#         data.get('contact_email'),
#         filename
#     ))
#     conn.commit()
#     cursor.close()
#     conn.close()

#     return jsonify({'message': 'News added successfully'})




# @app.route('/matches', methods=['GET'])
# def get_matches():
#     return jsonify(football_crud.get_all_matches())

# @app.route('/matches/<int:match_id>', methods=['GET'])
# def get_match(match_id):
#     match = football_crud.get_match_by_id(match_id)
#     return jsonify(match) if match else ('Match not found', 404)

# @app.route('/matches', methods=['POST'])
# def create_match():
#     football_crud.create_match(request.json)
#     return jsonify({'message': 'Match created'}), 201

# @app.route('/matches/<int:match_id>', methods=['PUT'])
# def update_match(match_id):
#     football_crud.update_match(match_id, request.json)
#     return jsonify({'message': 'Match updated'})

# @app.route('/matches/<int:match_id>', methods=['DELETE'])
# def delete_match(match_id):
#     football_crud.delete_match(match_id)
#     return jsonify({'message': 'Match deleted'})

# @app.route('/standings', methods=['GET'])
# def get_standings():
#     return jsonify(football_crud.get_all_standings())

# @app.route('/news', methods=['GET'])
# def get_news():
#     return jsonify(football_crud.get_all_news())

# @app.route('/images/<path:filename>')
# def serve_image(filename):
#     return send_from_directory(IMAGE_FOLDER, filename)





# if __name__ == '__main__':
#     hostname = socket.gethostname()
#     local_ip = socket.gethostbyname(hostname)

#     print(f"\n Flask is running! Open in browser:")
#     print(f"    http://{local_ip}:5000/\n")

#     app.run(debug=True, host='0.0.0.0', port=5000)



from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS
import os
import socket
from werkzeug.utils import secure_filename
from db_config import get_connection
import football_crud

app = Flask(__name__)
CORS(app)

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
IMAGE_FOLDER = os.path.join(BASE_DIR, 'assets', 'images')
UPLOAD_FOLDER = IMAGE_FOLDER
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


@app.route('/add_news', methods=['POST'])
def add_news():
    data = request.form
    image = request.files.get('image')

    filename = None
    if image:
        filename = secure_filename(image.filename)
        image_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        try:
            image.save(image_path)
        except Exception as e:
            return jsonify({'error': f'Failed to save image: {str(e)}'}), 500

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO news (title, sport_type, description, source, contact_phone, contact_email, image, publish_date, verify)
        VALUES (%s, %s, %s, %s, %s, %s, %s, NOW(), FALSE)
    """, (
        data.get('title'),
        data.get('sport_type'),
        data.get('description'),
        data.get('source'),
        data.get('contact_phone'),
        data.get('contact_email'),
        filename
    ))
    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({'message': 'News added successfully'})


@app.route('/register', methods=['POST'])
def register():
    data = request.get_json() or request.form
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    if not name or not email or not password:
        return jsonify({'error': 'Missing required fields'}), 400

    success = football_crud.register_user(name, email, password)
    if not success:
        return jsonify({'error': 'Email already exists'}), 409

    return jsonify({'message': 'User registered successfully'})


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json() or request.form
    email = data.get('email')
    password = data.get('password')

    user = football_crud.get_user_by_email_and_password(email, password)
    if not user:
        return jsonify({'error': 'Invalid email or password'}), 401

    return jsonify({'user': {
        'id': user['id'],
        'username': user['username'],
        'email': user['email'],
        'avatar': user['avatar']
    }})


@app.route('/get_user/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = football_crud.get_user_by_id(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404
    return jsonify({'data': user})


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