DROP DATABASE IF EXISTS cs201_final_project_db;
CREATE DATABASE cs201_final_project_db;

USE cs201_final_project_db;

CREATE TABLE housing(
	housing_id INT(3) PRIMARY KEY AUTO_INCREMENT,
    housing_name varchar(80) NOT NULL
);

INSERT INTO housing(housing_name) 
VALUES('Parkside Apartments'), ('McCarthy'), ('Webb Tower'), ('Flor Tower'), ('Cale and Irani'), ('Off-campus');
CREATE TABLE major(
	major_id INT(3) PRIMARY KEY AUTO_INCREMENT,
	major_name varchar(40) NOT NULL
);

CREATE TABLE user(
    user_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    email varchar(45) NOT NULL UNIQUE,
    screen_name varchar(45) NOT NULL,
    password varchar(45) NOT NULL,
    major_id INT(3) NOT NULL,
    housing_id INT(3) NOT NULL,
    availability_string varchar(336) NULL,
    FOREIGN KEY (major_id) REFERENCES major(major_id),
    FOREIGN KEY (housing_id) REFERENCES housing(housing_id)
);
INSERT INTO user(email, screen_name, password, major_id, housing_id, availability_string) VALUES
	('zhehaolu@usc.edu', 'Tony Lyu', 'password1', 1, 1, '001101000000100101110011101000000111010010111111011110100110001110110010101100111010101011111110000010011000110010101001011110110101000001000011101110011001000001111000100101011001000000001001000101001001001100111100011000100011001111001010001010000000001011010011100010100010100001011110101000001010010101100111001111001111010001011000'),
    ('zhehaolu2@usc.edu', 'Tony Lyu2', 'password2', 2, 2, '001110011110000000111001111001101101010101001101111110111000011000111011001101110010010010011101011100001110010110110001000011111101001110100100010010101011001111100110110010111110000110000101001001100000101010011100010110011011101110010111101000000100001011000110101100111010001011010010111010110110101101011101100111111101111000101111'),
    ('husophia@usc.edu', 'Sophia Hu', 'password3', 1, 5, '011101000110100101110010001000100110110010101011011011101100101011111010101110111000111011001110100110111010110010101001011110110101000001000011101110011001000001111000100101011001000000001001000101001001001100111100011000100011001111001010001010100110001011010011100010100010101001010110101000001011110101100111001011001111010001011010'), 
	('weiyuyu@usc.edu', 'Wayne Yu', 'password3', 5, 1, '001101001011101101011010101001010101110010100110011011101110101010010110100110101011111011001110100010111001110110101001011011111101000001001011101010011001000001101000100101011001001000001101010001001001001100111100011000100011001101001010101010101010101011011110101110100010100101011011111001001010010101100111001111001111010101111011'),
	('adamdill@usc.edu', 'Adam Dillard', 'password3', 5, 3, '111101000110110101011010001011000111010010111011011100110110101111110110101100101111101011101010010011011010100011101001011010110101001001010011101100011001001001011000101101011001001000101001000101001001001100111100011000110001001101001010001010110010101011010011101010100110100001011110101001001010010001000111001011001111010001011001'),
	('ankurras@usc.edu', 'Ankur Rastogi', 'password3', 3, 6, '11000000111001011110111010000001110100101111110111101001100000001100101111001110101010111100101100110111001100101010110110111101100000010100111111100110010000011110001001010110010010100010010101010000010011001110010110001000110011110010100010101000101010110100110001101001101010010000101010010101010010101100101000111011111010100010000'),
	('kongp@usc.edu', 'Patrick Kong', 'password3', 1, 3, '001101000000100101000011101000100111010010111011011110100110001111110111101100011010101011111111110010011010110010101001011010110001001001010111101110011001001011111100100101011001000001001011101101001001001100111101011010101001101111001010001010100010111111010010101011100010101001010110101100101010110101101111101101001011010101111011'),
	('jeffrey.miller@usc.edu', 'Jeffrey Miller', 'password3', 1, 6, '111101010001111100110011101000100011110110100111111111110110101110110011101111111011101111111110010011111010011010101001011110110101000100000000111110011001011111111111100101111000000000000001000101011101101111111111111000100011001111101011001110101011111111010011100000100000000001011111111000001010010101111111111111111111010000011000'),
	('zifanshi@usc.edu', 'Zifan Shi','password3', 1, 1, '111111100110111100000000000000000111110011111111111111100110001100000010101111111110111011101100000011011000111010101001010110000101001001001011111110111001001001111100100101011001000010011011000111011011011101110100001111111111111111001010101111110010101011010011101111100111101101111100001001011111011111111111001111001111010101111101'),
	('aabidi@usc.edu', 'Alina Abidi', 'password3', 1, 6, '111101010010110100110011101010111111010010111111011110111111101000000010101111111110101011111111111010000000111011101011011111111111100101011111100000000001000011111100100100011101100011001111000000001101111101111100111010101011011111101110011110000000101111010011101011111011101001011111101101101011111111111111111001001101010101111111'),
	('peijialu@usc.edu', 'Peija Lu', 'password3', 1, 1, '001101000000100100101011101001010111010110110101011101010101011111111111111100000010101011111110000010011000111010101101011110110101000000101011100101011001000101111001010101011001010000010101000010101001011100101010011010100011001111001010010110101010101010110011101010100010100010111110100101001001010101010111001111001111010010111001'),
	('shindler@usc.edu', 'Michael Shindler', 'password3', 1, 1, '111111001000100101110011101000000111010010111111011110100110001110110010101100111010101011111110000010011000110010101011011111110111000101100011011110111001001001111010100101011001000010001001000101001001001100111100011000100011001111001010001010100010101011010011100010100010110001011110101001001011011111100111110111001111010001011001'),
	('aaroncot@usc.edu', 'Aaron Cote', 'password3', 1, 1, '001101001101100101110011101000000111010010111111011110100110001110110010101100111010111011101110000010011000110010101001011100110101100011001011001110111001000101111001100101011001000001001001001101001001001100111100011000100011001111001010001010100010101011010011100010100010100001111110101000001010011101100101111111101111011001011001'),
	('sbatista@usc.edu', 'Sandra Batista', 'password3', 1, 2, '001111100000100101110011101000101111010010111111011110100110001110110010101100111011101011101110000010011000110010101001011010111101010011001011100110011000001001111001100101011001000100001001010101001001001100111100011000100011001111001010001010100010101011010011100010100010100001011110101000011110010101111111111110001111110001011001'),
	('goodney@usc.edu', 'Andrew Goodney', 'password3', 1, 4, '111111000000000101110110111010110111011110110001011110101110011110010110101100111010101011101100010111011000110010101001011110110101001001001011001010111001011001011111100101001001001100001001000111001011001100111101001000101011001101001010001010101010111011010111101010100110100001111100101000101010010101100111001011001101010101111110');

CREATE TABLE gen_interests(
	interest_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    interest_name varchar(45) NOT NULL
);

INSERT INTO gen_interests(interest_name) VALUES ('Football'), ('League of Legends'), ('Counter-Strike'), ('Music'), ('Movies'), ('Homework');

CREATE TABLE user_interests(
	user_id INT(11) NOT NULL,
    interest_id INT(11) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (interest_id) REFERENCES gen_interests(interest_id)
);
INSERT INTO user_interests(user_id, interest_id) VALUES (1, 3), (1, 1), (2,1), (2,2);

CREATE TABLE extracurriculars(
	extracurricular_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    extracurricular_name varchar(80) NOT NULL
);
INSERT INTO extracurriculars(extracurricular_name) VALUES ('CAIS++'), ('Scope'), ('LavaLab'), ('Code The Change');

CREATE TABLE user_extracurriculars(
	user_id INT(11) NOT NULL,
    extracurricular_id INT(11) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (extracurricular_id) REFERENCES extracurriculars(extracurricular_id)
);

INSERT INTO user_extracurriculars(user_id, extracurricular_id) 
VALUES (1,1), (1,2), (1,3), (2,4), (2,1);

CREATE TABLE courses(
	course_id INT(6) PRIMARY KEY AUTO_INCREMENT,
	course_prefix varchar(4) NOT NULL,
    course_number INT(4) NOT NULL,
    course_name varchar(50) NOT NULL
);
    
CREATE TABLE user_courses(
	user_id INT(11) NOT NULL,
    course_id INT(6) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO user_courses(user_id, course_id) 
VALUES (1,1), (1,3), (2,3), (2,2), (2,4),(3,3),(3,4), (4,1), (4,2), (4,3), (4,4), (5,1), (5,5),(6,6), (6,1), (7,1), (7,3),(8,3);

CREATE TABLE blocks(
	block_id INT(13) PRIMARY KEY AUTO_INCREMENT,
    blocking_user_id INT(11) NOT NULL,
    blocked_user_id INT(11) NOT NULL,
    block_status TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (blocking_user_id) REFERENCES user(user_id),
    FOREIGN KEY (blocked_user_id) REFERENCES user(user_id)
);

INSERT INTO blocks (blocking_user_id,blocked_user_id,block_status)
VALUES (1,8,1), (1,2,1), (15,14,1), (12,13,1);

CREATE TABLE chat_messages(
	message_id INT(18) PRIMARY KEY AUTO_INCREMENT,
    sending_user_id INT(11) NOT NULL,
    receiving_user_id INT(11) NOT NULL,
    message_time DATETIME NOT NULL,
    message_body TEXT NOT NULL,
    FOREIGN KEY (sending_user_id) REFERENCES user(user_id),
    FOREIGN KEY (receiving_user_id) REFERENCES user(user_id)
);
