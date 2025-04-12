# from db_config import get_connection
# import datetime

# def serialize(matches):
#     for match in matches:
#         for key, val in match.items():
#             if isinstance(val, (datetime.date, datetime.time, datetime.timedelta)):
#                 match[key] = str(val)
#     return matches


# def get_all_matches():
#     conn = get_connection()
#     cursor = conn.cursor(dictionary=True)
#     cursor.execute("""
#         SELECT
#             m.id,
#             l.name AS league_name,
#             th.name AS team_home_name,
#             th.logo AS team_home_logo,
#             ta.name AS team_away_name,
#             ta.logo AS team_away_logo,
#             m.score_home,
#             m.score_away,
#             m.match_date,
#             m.match_time,
#             m.status,
#             m.week
#         FROM matches m
#         JOIN teams th ON m.team_home = th.id
#         JOIN teams ta ON m.team_away = ta.id
#         JOIN leagues l ON m.league_id = l.id
#     """)
#     matches = cursor.fetchall()
#     conn.close()
#     return serialize(matches)
# def get_match_by_id(match_id):
#     conn = get_connection()
#     cursor = conn.cursor(dictionary=True)
#     cursor.execute("SELECT * FROM matches WHERE id=%s", (match_id,))
#     match = cursor.fetchone()
#     conn.close()
#     return serialize([match])[0] if match else None

# def create_match(match_data):
#     conn = get_connection()
#     cursor = conn.cursor()
#     cursor.execute("""
#     INSERT INTO matches (league_id, team_home, team_away, score_home, score_away, match_date, match_time, status, week)
#     VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
#     """, (
#         match_data['league_id'], match_data['team_home'], match_data['team_away'],
#         match_data['score_home'], match_data['score_away'],
#         match_data['match_date'], match_data['match_time'], match_data['status'], match_data['week']
#     ))
#     conn.commit()
#     conn.close()

# def update_match(match_id, match_data):
#     conn = get_connection()
#     cursor = conn.cursor()
#     cursor.execute("""
#     UPDATE matches SET league_id=%s, team_home=%s, team_away=%s, score_home=%s,
#     score_away=%s, match_date=%s, match_time=%s, status=%s, week=%s WHERE id=%s
#     """, (
#         match_data['league_id'], match_data['team_home'], match_data['team_away'],
#         match_data['score_home'], match_data['score_away'],
#         match_data['match_date'], match_data['match_time'], match_data['status'], match_data['week'], match_id
#     ))
#     conn.commit()
#     conn.close()

# def delete_match(match_id):
#     conn = get_connection()
#     cursor = conn.cursor()
#     cursor.execute("DELETE FROM matches WHERE id = %s", (match_id,))
#     conn.commit()
#     conn.close()

# def get_all_standings():
#     conn = get_connection()
#     cursor = conn.cursor(dictionary=True)
#     cursor.execute("""
#         SELECT
#             s.*, 
#             t.name AS team_name, 
#             t.logo AS team_logo
#         FROM standings s
#         JOIN teams t ON s.team_id = t.id
#         ORDER BY s.position ASC
#     """)
#     standings = cursor.fetchall()
#     conn.close()
#     return standings

# def get_all_news():
#     conn = get_connection()
#     cursor = conn.cursor(dictionary=True)
#     cursor.execute("SELECT * FROM news WHERE verify = TRUE ORDER BY publish_date DESC")
#     news = cursor.fetchall()
#     conn.close()
#     return news


from db_config import get_connection
import datetime

def serialize(matches):
    for match in matches:
        for key, val in match.items():
            if isinstance(val, (datetime.date, datetime.time, datetime.timedelta)):
                match[key] = str(val)
    return matches


def get_all_matches():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            m.id,
            l.name AS league_name,
            th.name AS team_home_name,
            th.logo AS team_home_logo,
            ta.name AS team_away_name,
            ta.logo AS team_away_logo,
            m.score_home,
            m.score_away,
            m.match_date,
            m.match_time,
            m.status,
            m.week
        FROM matches m
        JOIN teams th ON m.team_home = th.id
        JOIN teams ta ON m.team_away = ta.id
        JOIN leagues l ON m.league_id = l.id
    """)
    matches = cursor.fetchall()
    conn.close()
    return serialize(matches)
def get_match_by_id(match_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM matches WHERE id=%s", (match_id,))
    match = cursor.fetchone()
    conn.close()
    return serialize([match])[0] if match else None

def create_match(match_data):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
    INSERT INTO matches (league_id, team_home, team_away, score_home, score_away, match_date, match_time, status, week)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (
        match_data['league_id'], match_data['team_home'], match_data['team_away'],
        match_data['score_home'], match_data['score_away'],
        match_data['match_date'], match_data['match_time'], match_data['status'], match_data['week']
    ))
    conn.commit()
    conn.close()

def update_match(match_id, match_data):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
    UPDATE matches SET league_id=%s, team_home=%s, team_away=%s, score_home=%s,
    score_away=%s, match_date=%s, match_time=%s, status=%s, week=%s WHERE id=%s
    """, (
        match_data['league_id'], match_data['team_home'], match_data['team_away'],
        match_data['score_home'], match_data['score_away'],
        match_data['match_date'], match_data['match_time'], match_data['status'], match_data['week'], match_id
    ))
    conn.commit()
    conn.close()

def delete_match(match_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM matches WHERE id = %s", (match_id,))
    conn.commit()
    conn.close()

def get_all_standings():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            s.*, 
            t.name AS team_name, 
            t.logo AS team_logo
        FROM standings s
        JOIN teams t ON s.team_id = t.id
        ORDER BY s.position ASC
    """)
    standings = cursor.fetchall()
    conn.close()
    return standings

def get_all_news():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM news WHERE verify = TRUE ORDER BY publish_date DESC")
    news = cursor.fetchall()
    conn.close()
    return news


def get_user_by_email_and_password(email, password):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE email = %s AND password_hash = %s", (email, password))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    return user

def get_user_by_id(user_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, username, email, avatar FROM users WHERE id = %s", (user_id,))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    return user

def register_user(name, email, password, avatar='default_avatar.png'):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
    if cursor.fetchone():
        return False  # Email already exists
    cursor.execute("INSERT INTO users (username, email, password_hash, avatar) VALUES (%s, %s, %s, %s)",
                   (name, email, password, avatar))
    conn.commit()
    cursor.close()
    conn.close()
    return True

