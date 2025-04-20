-- ⚽ FULL FOOTBALL DATABASE SETUP
DROP DATABASE IF EXISTS football;
CREATE DATABASE football;
USE football;

-- leagues
CREATE TABLE leagues (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  country VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO leagues (id, name, country) VALUES
(1, 'Premier League', 'England'),
(2, 'La Liga', 'Spain');

-- teams
CREATE TABLE teams (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  logo TEXT,
  league_id INT,
  FOREIGN KEY (league_id) REFERENCES leagues(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO teams (id, name, logo, league_id) VALUES
(1, 'Real Madrid', 'real_madrid.png', 2),
(2, 'Liverpool', 'liverpool.png', 1),
(3, 'Man City', 'mancity.png', 1),
(4, 'Man U', 'manu.png', 1),
(5, 'Arsenal', 'arsenal.png', 1),
(6, 'Leeds United', 'leeds.png', 1),
(7, 'Tottenham', 'tottenham.png', 1),
(8, 'Brighton', 'brighton.png', 1);

-- users
CREATE TABLE users (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  avatar TEXT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO users VALUES
(1, 'Admin User', 'admin@example.com', '12345', 'profile.jpg', '2025-04-12 08:26:06'),
(2, 'lnwTrue', '1@gmail.com', '12345', 'profile.jpg', '2025-04-12 09:10:58'),
(4, 'man', 'man@gmail.com', '12345', 'default_avatar.png', '2025-04-15 13:59:10'),
(5, 'q', 'q', '12345', 'default_avatar.png', '2025-04-15 17:27:05'),
(6, 'test', 'test@gmail.com', '123456', 'default_avatar.png', '2025-04-15 17:40:34'),
(7, 'testing', 'testing@gmail.com', '123456', 'default_avatar.png', '2025-04-15 17:50:14'),
(8, 'sirman', 'sirman@gmail.com', '123456', 'default_avatar.png', '2025-04-15 19:01:36'),
(11, '12456', '455@234.com', '333377373', 'default_avatar.png', '2025-04-15 19:13:47'),
(13, 'tttt', 'ttt@gmail.com', '123456', 'default_avatar.png', '2025-04-17 08:12:47'),
(14, 'Rausch', 'markchs01@gmail.com', '192837', '1000002402.jpg', '2025-04-17 08:13:33');

-- players
CREATE TABLE players (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  team_id INT,
  photo TEXT,
  height DOUBLE,
  weight DOUBLE,
  age INT,
  biography TEXT,
  games INT DEFAULT 0,
  minutes INT DEFAULT 0,
  goals INT DEFAULT 0,
  assists INT DEFAULT 0,
  FOREIGN KEY (team_id) REFERENCES teams(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO players VALUES
(1, 'Kylian Mbappé', 1, 'mbappe.png', 1.78, 75, 26, 'Kylian Mbappé is a French footballer playing for Real Madrid.', 41, 1284, 28, 3);

-- matches
CREATE TABLE matches (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  league_id INT,
  team_home INT,
  team_away INT,
  score_home INT DEFAULT 0,
  score_away INT DEFAULT 0,
  match_date DATE,
  match_time TIME,
  status VARCHAR(50),
  week INT,
  FOREIGN KEY (league_id) REFERENCES leagues(id),
  FOREIGN KEY (team_home) REFERENCES teams(id),
  FOREIGN KEY (team_away) REFERENCES teams(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO matches VALUES
(1, 1, 1, 2, 3, 0, '2025-04-20', '21:30:00', 'live', 10),
(2, 1, 3, 2, 0, 0, '2025-04-19', '23:30:00', 'live', 10),
(3, 1, 3, 4, 4, 3, '2025-03-27', '21:30:00', 'finished', 7),
(4, 1, 3, 2, 4, 0, '2025-04-19', '23:45:00', 'notstart', 10),
(5, 1, 2, 4, 1, 0, '2025-04-17', '21:30:00', 'finished', 10);

-- match_goals
CREATE TABLE match_goals (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  match_id INT NOT NULL,
  team_id INT NOT NULL,
  player_id INT NOT NULL,
  goal_time VARCHAR(10),
  FOREIGN KEY (match_id) REFERENCES matches(id),
  FOREIGN KEY (team_id) REFERENCES teams(id),
  FOREIGN KEY (player_id) REFERENCES players(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO match_goals VALUES
(10, 1, 1, 1, '14'),
(11, 1, 1, 1, '66'),
(12, 1, 1, 1, '79');

-- match_statistics
CREATE TABLE match_statistics (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  match_id INT,
  team_id INT,
  shots INT,
  shots_on_target INT,
  ball_possession INT,
  passes INT,
  pass_accuracy INT,
  fouls INT,
  yellow_cards INT,
  red_cards INT,
  offsides INT,
  corners INT,
  FOREIGN KEY (match_id) REFERENCES matches(id),
  FOREIGN KEY (team_id) REFERENCES teams(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO match_statistics VALUES
(1, 1, 1, 11, 7, 69, 610, 89, 7, 0, 0, 1, 3),
(2, 1, 2, 7, 2, 31, 532, 90, 13, 1, 0, 5, 2),
(3, 2, 2, 11, 4, 20, 50, 80, 3, 1, 0, 3, 4),
(4, 2, 1, 21, 4, 20, 21, 90, 5, 2, 0, 7, 3);

-- standings
CREATE TABLE standings (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  league_id INT,
  team_id INT,
  matches_played INT DEFAULT 0,
  wins INT DEFAULT 0,
  draws INT DEFAULT 0,
  losses INT DEFAULT 0,
  goals_for INT DEFAULT 0,
  goals_against INT DEFAULT 0,
  goal_difference INT DEFAULT 0,
  points INT DEFAULT 0,
  position INT,
  FOREIGN KEY (league_id) REFERENCES leagues(id),
  FOREIGN KEY (team_id) REFERENCES teams(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO standings VALUES
(1, 1, 1, 10, 8, 1, 1, 25, 5, 20, 25, 1),
(2, 1, 5, 3, 3, 0, 0, 10, 1, 9, 9, 1),
(3, 1, 3, 3, 2, 1, 0, 7, 2, 5, 7, 2),
(4, 1, 6, 3, 2, 1, 0, 6, 3, 3, 7, 3),
(5, 1, 7, 3, 1, 2, 0, 5, 3, 2, 5, 4),
(6, 1, 8, 3, 1, 1, 1, 4, 3, 1, 4, 5);

-- news
CREATE TABLE news (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  sport_type VARCHAR(255),
  source VARCHAR(255),
  image TEXT,
  publish_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  contact_phone VARCHAR(50),
  contact_email VARCHAR(100),
  verify TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO news VALUES
(1, '2022 UEFA Champions League Final', 'Real Madrid beat Liverpool 1-0 in the Champions League Final.', 'Football', 'UEFA', 'final.jpg', '2022-05-07 17:00:00', '123-456-7890', 'uefa@news.com', 1),
(2, 'ตารางคะแนนพรีเมียร์ลีก, การแข่งขัน, โปรแกรมพรีเมียร์ลีก', 'อัปเดตล่าสุดของพรีเมียร์ลีก อังกฤษ พร้อมตารางคะแนน', 'ฟุตบอล', 'Thairath', 'table.jpg', '2022-11-11 17:00:00', '089-888-8888', 'sports@thairath.co.th', 1),
(3, 'อัปเดตนักเตะขาดเจ็บพรีเมียร์ลีก', 'ใครบาดเจ็บบ้างจากนัดล่าสุด', 'ฟุตบอล', 'Goal', 'injury.jpg', '2022-11-11 17:00:00', '090-999-9999', 'report@goal.com', 1),
(13, 'การมีนำน้องหมาเข้าร่วม การแตะฟุตบอลอาชีพ', NULL, NULL, NULL, '1000000033.jpg', '2025-04-14 16:45:14', NULL, NULL, 1),
(16, 'ข่าวลือ', NULL, NULL, '', '1000017368.jpg', '2025-04-15 19:02:50', NULL, NULL, 0);
