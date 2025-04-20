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


def get_match_statistics_with_goals(match_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # ข้อมูลสถิติ
    cursor.execute(""" SELECT * FROM match_statistics WHERE match_id = %s """, (match_id,))
    stats = cursor.fetchall()

    home_stats = next((s for s in stats if s['team_id'] == 1), {})  # สมมุติ home team_id = 1
    away_stats = next((s for s in stats if s['team_id'] == 2), {})

    # ข้อมูลทีม
    cursor.execute("""
        SELECT m.score_home, m.score_away, t1.name as team_home, t2.name as team_away,
               t1.logo as logo_home, t2.logo as logo_away
        FROM matches m
        JOIN teams t1 ON m.team_home = t1.id
        JOIN teams t2 ON m.team_away = t2.id
        WHERE m.id = %s
    """, (match_id,))
    match = cursor.fetchone()

    # ข้อมูลผู้ทำประตู
    cursor.execute("""
        SELECT p.id as player_id, p.name, g.goal_time, p.team_id
        FROM match_goals g
        JOIN players p ON g.player_id = p.id
        WHERE g.match_id = %s
        ORDER BY g.goal_time ASC
    """, (match_id,))
    goals = cursor.fetchall()

    conn.close()

    # ✅ return เป็น object (dict) แทน string
    home_goals = [
        {
            "text": f"{g['name']} {g['goal_time']}'",
            "player_id": g["player_id"]
        }
        for g in goals if g['team_id'] == 1
    ]

    away_goals = [
        {
            "text": f"{g['name']} {g['goal_time']}'",
            "player_id": g["player_id"]
        }
        for g in goals if g['team_id'] == 2
    ]

    return {
        "score_home": match["score_home"],
        "score_away": match["score_away"],
        "team_home": match["team_home"],
        "team_away": match["team_away"],
        "logo_home": match["logo_home"],
        "logo_away": match["logo_away"],
        "home": home_stats,
        "away": away_stats,
        "home_goals": home_goals,
        "away_goals": away_goals,
    }

