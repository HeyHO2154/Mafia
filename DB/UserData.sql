DROP DATABASE minsseam_test;

DROP DATABASE IF EXISTS hsj;
CREATE DATABASE hsj;

USE hsj;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    point INT DEFAULT 0
);

DELETE FROM users;
INSERT INTO users (user_id, password, point) VALUES ('test', '1234', 1094);
INSERT INTO users (user_id, password, point) VALUES ('asdf', '1234', 384);
INSERT INTO users (user_id, password, point) VALUES ('wow', '1234', 527);
SELECT * FROM users;
#UPDATE users SET point = 1094 WHERE id = '3';
