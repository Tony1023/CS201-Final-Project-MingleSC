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
	major_name varchar(200) NOT NULL
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

CREATE TABLE courses(
	course_id INT(6) PRIMARY KEY AUTO_INCREMENT,
	course_prefix varchar(4) NOT NULL,
    course_number INT(4) NOT NULL,
    course_name varchar(200) NOT NULL
);
    
CREATE TABLE user_courses(
	user_id INT(11) NOT NULL,
    course_id INT(6) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE blocks(
	block_id INT(13) PRIMARY KEY AUTO_INCREMENT,
    blocking_user_id INT(11) NOT NULL,
    blocked_user_id INT(11) NOT NULL,
    block_status TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (blocking_user_id) REFERENCES user(user_id),
    FOREIGN KEY (blocked_user_id) REFERENCES user(user_id)
);

CREATE TABLE chat_messages(
	message_id INT(18) PRIMARY KEY AUTO_INCREMENT,
    sending_user_id INT(11) NOT NULL,
    receiving_user_id INT(11) NOT NULL,
    message_time DATETIME NOT NULL,
    message_body TEXT NOT NULL,
    FOREIGN KEY (sending_user_id) REFERENCES user(user_id),
    FOREIGN KEY (receiving_user_id) REFERENCES user(user_id)
);
