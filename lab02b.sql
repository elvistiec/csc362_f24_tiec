-- Create the database (dropping the previous version if necessary 
DROP DATABASE IF EXISTS school;

CREATE DATABASE school;

USE school;

-- create instructors table
CREATE TABLE Instructors
(
    PRIMARY KEY (instructor_id),
    instructor_id   INT AUTO_INCREMENT,
    instructor_name_last   VARCHAR(50),
    instructor_name_first  VARCHAR(50),
    instructor_campus_phone VARCHAR(50)
);

-- filling in data
INSERT INTO Instructors (instructor_name_last, instructor_name_first, instructor_campus_phone)
VALUES ('Bailey', 'William', '111-222-3333'),
('Bradshaw', 'Michael', '222-333-4444'),
('Toth', 'Dave', '333-444-5555'),
('Faye', 'Jean', '444-555-6666');

-- display data
SELECT * FROM Instructors;