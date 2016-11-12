CREATE DATABASE School_System;
USE School_System; 


CREATE TABLE Schools (
	id INT PRIMARY KEY AUTO_INCREMENT, 
	name VARCHAR(30),
	address VARCHAR(100),  
	mission VARCHAR(120), 
	vision VARCHAR(120), 
	language VARCHAR(20), 
	general_info VARCHAR(120), 
	fees INT, 
	type VARCHAR(20), 
	CHECK (type = 'national' OR type = 'international'), 
	min_grade INT, 
	max_grade INT, 
	email VARCHAR(50), 
	elementary BOOLEAN AS (min_grade == 1 AND max_grade >= 6) , 
	middle BOOLEAN AS (min_grade <= 7 AND max_grade >= 9), 
	high BOOLEAN AS (min_grade <= 10 AND max_grade == 12)
);  


CREATE TABLE Phone_School (
	PRIMARY KEY (school_id, phone),
	phone VARCHAR(15), 
	school_id INT,
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE 
	
); 

CREATE TABLE Supplies (
	PRIMARY KEY (name, school_id, grade),
	name VARCHAR(15), 
	school_id INT, 
	grade INT,
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE
); 


CREATE TABLE Clubs (
	PRIMARY KEY (name, school_id), 
	name VARCHAR(20), 
	school_id INT,
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE
); 

CREATE TABLE Students (
	PRIMARY KEY (ssn), 
	ssn INT, 
	school_id INT, 
	first_name VARCHAR(20),
	last_name VARCHAR(20), 
	username VARCHAR(20),
	password VARCHAR(20), 
	gender VARCHAR(10), 
	birthdate date, 
	age INT AS (YEAR('2016-1-1') - YEAR(birthdate)), 
	grade INT, 
	level VARCHAR(15), 
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE SET NULL 
); 

CREATE TABLE Parents (
	PRIMARY KEY (username), 
	username VARCHAR(20), 
	first_name VARCHAR(20), 
	last_name VARCHAR(20), 
	email VARCHAR(20), 
	address VARCHAR(120), 
	home_phone VARCHAR(15)
); 

CREATE TABLE Mobiles_Of_Parents (
	PRIMARY KEY (mobile, username), 
	username VARCHAR(20), 
	mobile VARCHAR(15), 
	FOREIGN KEY (username) REFERENCES Parents(username) ON DELETE CASCADE
);  

CREATE TABLE Parents_Of_Students (
	PRIMARY KEY (parent_username, child_ssn), 
	parent_username VARCHAR(20), 
	child_ssn INT, 
	FOREIGN KEY (child_ssn) REFERENCES Students(ssn), 
	FOREIGN KEY (parent_username) REFERENCES Parents(username)
); 

CREATE TABLE Club_Member_Student (
	PRIMARY KEY (student_ssn, school_id, club_name), 
	student_ssn INT, 
	school_id INT, 
	club_name VARCHAR(20), 
	FOREIGN KEY (club_name, school_id) REFERENCES Clubs(name, school_id) ON DELETE CASCADE, 
	FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE
);

CREATE TABLE Parent_Review_School (
	PRIMARY KEY (school_id, parent_username), 
	school_id INT, 
	parent_username VARCHAR(20), 
	review VARCHAR(200), 
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE, 
	FOREIGN KEY (parent_username) REFERENCES Parents(username) ON DELETE CASCADE 
); 
CREATE TABLE School_Apply_Student(
 	PRIMARY KEY (school_id, student_ssn), 
 	school_id INT,
 	student_ssn INT,
 	parent_username VARCHAR(20), 
 	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE, 
 	FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE, 
 	FOREIGN KEY (parent_username) REFERENCES Parents(username) ON DELETE SET NULL 
); 


CREATE TABLE Employees (
	PRIMARY KEY(id), 
	id INT AUTO_INCREMENT, 
	school_id INT DEFAULT NULL, 
	first_name VARCHAR(20), 
	middle_name VARCHAR(20), 
	last_name VARCHAR(20), 
	username VARCHAR(20), 
	password VARCHAR(20), 
	email VARCHAR(50), 
	gender VARCHAR(10), 
	address VARCHAR(40), 
	birthdate DATE, 
	salary INT, 
	start_date DATE NOT NULL, 
	age INT AS (YEAR('2016-1-1') - YEAR(birthdate)), 
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE SET NULL
); 

create table Adminstrators (
		id int PRIMARY KEY, 
		FOREIGN KEY (id) REFERENCES Employees(id) ON DELETE CASCADE
	);

create table Teachers 
	(
		id int PRIMARY KEY,
		start_date DATETIME,
		exp_years int,
		age int AS (YEAR('2016-11-9') - YEAR(start_date)),
		FOREIGN KEY (id) REFERENCES Employees(id) ON DELETE CASCADE
	);

create table Teachers_Supervising_Teachers
	(
		supervisor_id int,
		teacher_id int,
		PRIMARY KEY (supervisor_id, teacher_id),
		FOREIGN KEY (supervisor_id) REFERENCES Teachers(id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

create table Activities
	(	
		PRIMARY KEY (activity_datetime, location),
		activity_datetime datetime,
		location varchar(100),
		equipment varchar(100),
		description varchar(500),
		type varchar(40),
		admin_id int,
		teacher_id int,
		FOREIGN KEY (admin_id) REFERENCES Adminstrators(id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

create table Activities_JoinedBy_Students
	(	
		PRIMARY KEY (student_ssn, activity_datetime, location),
		student_ssn int,
		activity_datetime datetime,
		location varchar(100),
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE,
		FOREIGN KEY (activity_datetime, location) REFERENCES Activities(activity_datetime, location) ON DELETE CASCADE
	);

create table Announcements
	(	
		PRIMARY KEY (title, announcement_date),
		title varchar(50),
		announcement_date date,
		type varchar(50),
		descriptoin varchar(500),
		admin_id int,
		FOREIGN KEY (admin_id) REFERENCES Adminstrators(id) ON DELETE SET NULL
	);

create table Courses
	(
		PRIMARY KEY (code),
		code int,
		name varchar(50),
		description varchar(250),
		grade int, 
		level VARCHAR(20), 
		CHECK (level = 'elementary' or level = 'middle' or level = 'high')
		
	);

create table Courses_Prerequisite_Courses
	(
		PRIMARY KEY (pre_code, code),
		pre_code int,
		code int,
		FOREIGN KEY (pre_code) REFERENCES Courses(code) ON DELETE CASCADE,
		FOREIGN KEY (code) REFERENCES Courses(code) ON DELETE CASCADE
	);

create table Courses_TaughtIn_Schools
	(
		PRIMARY KEY (course_code, school_id),
		course_code int,
		school_id int,
		FOREIGN KEY (course_code) REFERENCES Courses(code) ON DELETE CASCADE,
		FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE
	);

create table Parents_Rate_Teachers
	(
		PRIMARY KEY (parent_username, teacher_id),
		parent_username varchar (20),
		teacher_id int,
		rating int,
		FOREIGN KEY (parent_username) REFERENCES Parents(username) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

create table Questions
	(
		PRIMARY KEY (q_id),
		q_id int,
		content varchar(250),
		student_ssn int,
		course_code int,
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE SET NULL,
		FOREIGN KEY (course_code) REFERENCES Courses(code) ON DELETE CASCADE
	);

create table Answers
	(
		PRIMARY KEY (answer_sub_id, q_id),
		answer_sub_id int,
		q_id int,
		answer varchar(250),
		teacher_id int,
		
		FOREIGN KEY (q_id) REFERENCES Questions(q_id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE SET NULL
	);

create table Courses_TaughtTo_Students_By_Teachers
	(
		PRIMARY KEY (course_code, student_ssn),
		course_code int,
		student_ssn int,
		teacher_id int,
		FOREIGN KEY (course_code) REFERENCES Courses(code) ON DELETE CASCADE,
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

create table Assignments
	(
		PRIMARY KEY (assignment_number, course_code, school_id),
		assignment_number int,
		course_code int,
		school_id int,
		post_date date,
		due_date date,
		contenet varchar(1000),
		teacher_id int,
		FOREIGN KEY (course_code) REFERENCES Courses(code) ON DELETE CASCADE,
		FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

create table Solutions
	(
		PRIMARY KEY (student_ssn, assignment_number, course_code, school_id),
		student_ssn int,
		assignment_number int,
		course_code int,
		school_id int,
		solution varchar(500),
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE,
		FOREIGN KEY (assignment_number, course_code, school_id) REFERENCES Assignments(assignment_number, course_code, school_id) ON DELETE CASCADE
	);

create table Teachers_Grade_Solutions
	(
		PRIMARY KEY (student_ssn, assignment_number, course_code, school_id),
		student_ssn int,
		assignment_number int,
		course_code int,
		school_id int,
		grade int,
		teacher_id int,
		FOREIGN KEY (student_ssn, assignment_number, course_code, school_id) REFERENCES Solutions (student_ssn, assignment_number, course_code, school_id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE	
	);

create table Reports
	(
		report_date date,
		student_ssn int,
		teacher_id int,
		comment varchar(500),
		PRIMARY KEY (report_date, student_ssn, teacher_id),
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

create table Parents_View_Reports
	(
		parent_username varchar(20),
		report_date date,
		student_ssn int,
		teacher_id int,
		PRIMARY KEY (parent_username, report_date, student_ssn, teacher_id),
		FOREIGN KEY (parent_username) REFERENCES Parents(username) ON DELETE CASCADE,
		FOREIGN KEY (report_date, student_ssn, teacher_id) REFERENCES Reports(report_date, student_ssn, teacher_id) ON DELETE CASCADE
	);

create table Parents_Reply_Reports
	(
		parent_username varchar(20),
		report_date date,
		student_ssn int,
		teacher_id int,
		content varchar(250),
		PRIMARY KEY (parent_username, report_date, student_ssn, teacher_id),
		FOREIGN KEY (parent_username) REFERENCES Parents(username) ON DELETE CASCADE,
		FOREIGN KEY (report_date, student_ssn, teacher_id) REFERENCES Reports(report_date, student_ssn, teacher_id) ON DELETE CASCADE
	);

