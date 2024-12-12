CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    birth_date DATE,
    age INT,
    enrollment_year INT
);

CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER
);

INSERT INTO courses (course_name, credit_hours)
VALUES
('History', 3), ('Philosophy', 2), ('Economics', 4), ('Astronomy', 3), 
('Sociology', 3), ('Psychology', 2), ('Art', 3), ('Data Analyst', 5), 
('Artificial Intelligence', 4), ('Mathematics', 3), ('Physics', 4);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
(2, 7, 4), (3, 6, 5), (5, 9, 3), (7, 8, 5), (1, 10, 4), (4, 3, 3),
(6, 5, 4), (8, 4, 3), (9, 2, 5), (10, 1, 4), (2, 9, 5), (3, 8, 4),
(4, 7, 3), (1, 6, 5), (5, 10, 4), (7, 3, 3), (6, 2, 4), (8, 1, 5),
(9, 5, 3), (10, 4, 4), (2, 8, 3), (3, 7, 4), (4, 6, 5), (1, 9, 3),
(5, 2, 4), (7, 10, 5), (6, 3, 4), (8, 5, 3), (9, 8, 5), (10, 7, 4);

SELECT first_name, last_name, birth_date FROM students;

SELECT s.first_name, s.last_name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'M';

SELECT s.first_name, s.last_name, AVG(e.grade) AS avg_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING AVG(e.grade) < 4;

SELECT DISTINCT s.first_name, s.last_name, c.course_name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT first_name, last_name 
FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);

SELECT c.course_name, COUNT(e.student_id) 
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

SELECT c.course_name 
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name 
ORDER BY COUNT(e.student_id) DESC 
LIMIT 1;

SELECT first_name, last_name 
FROM students
ORDER BY last_name;

SELECT s.first_name, s.last_name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.enrollment_year > 2015 AND c.course_name = 'Mathematics';

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

UPDATE enrollments
SET grade = 3
WHERE grade = 4;

DELETE FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);

INSERT INTO students (first_name, last_name, birth_date, age, enrollment_year)
VALUES ('Sanjar', 'Abdufattokhov', '2005-04-10', 20, 2024);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES (
    (SELECT student_id FROM students WHERE first_name = 'Sanjar' AND last_name = 'Abdufattokhov'), 1, 5
);

SELECT 
    s.first_name, 
    s.last_name, 
    COUNT(e.course_id) AS total_courses
FROM 
    students s
JOIN 
    enrollments e ON s.student_id = e.student_id
GROUP BY 
    s.student_id, s.first_name, s.last_name
HAVING 
    COUNT(e.course_id) > (
        SELECT 
            AVG(course_count) 
        FROM (
            SELECT 
                COUNT(course_id) AS course_count
            FROM 
                enrollments
            GROUP BY 
                student_id
        ) AS avg_courses
    );
