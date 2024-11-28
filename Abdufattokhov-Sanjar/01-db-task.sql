CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER
);

INSERT INTO courses (course_name, credit_hours)
VALUES
('Tarix', 3), ('Falsafa', 2), ('Iqtisodiyot', 4), ('Astronomiya', 3), 
('Sotsiologiya', 3), ('Psixologiya', 2), ('San’at', 3), ('Web Dasturlash', 5), 
('Sun’iy Intellekt', 4), ('Blockchain', 3), ('Fizika', 4);

-- Insert data into the enrollments table
INSERT INTO enrollments (student_id, course_id, grade)
VALUES
(1, 6, 5), (2, 1, 4), (3, 1, 3), (1, 2, 5), (4, 2, 4), (5, 2, 3),
(6, 3, 4), (7, 3, 5), (8, 3, 3), (2, 4, 3), (9, 4, 4), (10, 4, 5),
(3, 5, 5), (1, 5, 4), (2, 5, 3), (8, 6, 5), (6, 6, 4), (7, 6, 3),
(3, 7, 5), (9, 7, 4), (10, 7, 3), (1, 8, 5), (4, 8, 4), (5, 8, 3),
(6, 9, 5), (2, 9, 4), (8, 9, 3), (7, 10, 5), (10, 10, 4), (3, 10, 3);

-- 3.1.1: Display all students with their first name, last name, and date of birth
SELECT first_name, last_name, birthdate FROM students;

-- 3.1.2: Find all students enrolled in the "Tarix" course
SELECT s.first_name, s.last_name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Tarix';

-- 3.1.3: Display all students with a GPA lower than 4
SELECT s.first_name, s.last_name, AVG(e.grade) AS ortacha_bahosi
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING AVG(e.grade) < 4;

-- 3.2.1: List students along with the names of the courses they are enrolled in
SELECT DISTINCT s.first_name, s.last_name, c.course_name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 3.2.2: Find students who are not enrolled in any courses
SELECT first_name, last_name 
FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);

-- 3.3.1: Count the number of students enrolled in each course
SELECT c.course_name, COUNT(e.student_id) 
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- 3.3.2: Find the course with the most students
SELECT c.course_name 
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name 
ORDER BY COUNT(e.student_id) DESC 
LIMIT 1;

-- 3.4.1: List students sorted by last name
SELECT first_name, last_name 
FROM students
ORDER BY last_name;

-- 3.4.2: Find all students enrolled after 2015 and enrolled in the "Tarix" course
SELECT s.first_name, s.last_name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.enrollment_year > 2015 AND c.course_name = 'Tarix';

-- 3.5: Find the courses taken by the student with the lowest average grade
SELECT c.course_name 
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
WHERE e.student_id = (
    SELECT e.student_id 
    FROM enrollments e 
    GROUP BY e.student_id 
    ORDER BY AVG(e.grade) ASC 
    LIMIT 1
);

-- 3.6.1: Update all grades of 4 to 3
UPDATE enrollments
SET grade = 3
WHERE grade = 4;

-- 3.6.2: Delete students who are not enrolled in any courses
DELETE FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);

-- 3.6.3: Add a new student and enroll them in a course
INSERT INTO students (first_name, last_name, birthdate)
VALUES ('Javohir', 'Tuychiev', '2004-11-25');

INSERT INTO enrollments (student_id, course_id, grade)
VALUES (
    (SELECT student_id FROM students WHERE first_name = 'Vera' AND last_name = 'Negaeva'),
    1,
    5
);
