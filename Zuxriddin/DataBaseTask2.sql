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


INSERT INTO courses (course_name, credit_hours) VALUES
    ('Introduction to SQL', 3),
    ('Advanced Databases', 4),
    ('Web Development Basics', 3),
    ('Machine Learning', 4),
    ('Data Structures', 3),
    ('Cloud Computing', 2),
    ('Cybersecurity Basics', 3),
    ('Mobile App Development', 3),
    ('Artificial Intelligence', 4),
    ('Networking Essentials', 2);


INSERT INTO enrollments (student_id, course_id, grade) VALUES
    (4, 2, 4), (7, 5, 3), (1, 8, 5), (5, 1, 2), (10, 3, 4),
    (2, 7, 3), (15, 10, 4), (20, 6, 5), (13, 9, 2), (11, 4, 3),
    (14, 2, 4), (19, 5, 5), (17, 8, 3), (8, 10, 4), (16, 7, 5),
    (1, 1, 2), (2, 3, 3), (15, 6, 4), (10, 9, 2), (5, 4, 5),
    (4, 7, 3), (13, 10, 5), (8, 6, 2), (19, 9, 4), (14, 2, 5),
    (11, 8, 3), (17, 4, 2), (20, 1, 5), (7, 5, 4), (16, 3, 3);


SELECT first_name, last_name, birthdate
FROM students;


SELECT 
    students.first_name AS name, 
    courses.course_name AS course
FROM 
    students
JOIN 
    enrollments ON students.student_id = enrollments.student_id
JOIN 
    courses ON courses.course_id = enrollments.course_id
WHERE 
    courses.course_name = 'Advanced Databases';


SELECT 
    students.first_name, 
    AVG(enrollments.grade) AS GPA
FROM 
    students
JOIN 
    enrollments ON students.student_id = enrollments.student_id
GROUP BY 
    students.first_name
HAVING 
    AVG(enrollments.grade) < 4;


SELECT 
    s.first_name, 
    s.last_name, 
    c.course_name
FROM 
    students s
JOIN 
    enrollments e ON s.student_id = e.student_id
JOIN 
    courses c ON c.course_id = e.course_id;


SELECT 
    s.first_name, 
    s.last_name
FROM 
    students s
LEFT JOIN 
    enrollments e ON s.student_id = e.student_id
WHERE 
    e.enrollment_id IS NULL;


SELECT 
    c.course_name, 
    COUNT(e.student_id) AS student_count
FROM 
    courses c
JOIN 
    enrollments e ON c.course_id = e.course_id
GROUP BY 
    c.course_name;


SELECT 
    c.course_name, 
    COUNT(e.student_id) AS student_count
FROM 
    courses c
JOIN 
    enrollments e ON c.course_id = e.course_id
GROUP BY 
    c.course_name
ORDER BY 
    student_count DESC
LIMIT 1;


SELECT 
    last_name, 
    first_name
FROM 
    students
ORDER BY 
    last_name;


SELECT 
    s.first_name, 
    s.last_name
FROM 
    students s
JOIN 
    enrollments e ON s.student_id = e.student_id
JOIN 
    courses c ON e.course_id = c.course_id
WHERE 
    s.enrollment_year > 2015 
    AND c.course_name = 'History';


SELECT 
    s.first_name, 
    s.last_name
FROM 
    students s
WHERE 
    (SELECT COUNT(e.course_id) 
     FROM enrollments e 
     WHERE e.student_id = s.student_id) > 
    (SELECT AVG(course_count) 
     FROM (SELECT COUNT(e.course_id) AS course_count 
           FROM enrollments e 
           GROUP BY e.student_id) subquery);


SELECT 
    c.course_name
FROM 
    courses c
JOIN 
    enrollments e ON c.course_id = e.course_id
JOIN 
    (SELECT 
         student_id, 
         AVG(grade) AS avg_grade
     FROM 
         enrollments
     GROUP BY 
         student_id
     ORDER BY 
         avg_grade ASC
     LIMIT 1) subquery ON e.student_id = subquery.student_id;


UPDATE enrollments
SET grade = 3
WHERE grade = 4;


DELETE FROM students
WHERE student_id NOT IN (
    SELECT DISTINCT student_id
    FROM enrollments
);


INSERT INTO students (first_name, last_name, birthdate, enrollment_year) 
VALUES 
    ('Bob', 'Salmon', '2001-12-23', 2011);

INSERT INTO enrollments (student_id, course_id, grade) 
VALUES 
    ((SELECT MAX(student_id) FROM students), 2, 5);

INSERT INTO students (first_name, last_name, birthdate, enrollment_year) 
VALUES 
    ('Andrew', 'Taylor', '2003-02-03', 2009);

INSERT INTO enrollments (student_id, course_id, grade) 
VALUES 
    ((SELECT MAX(student_id) FROM students), 9, 4);


SELECT 
    c.course_name, 
    AVG(e.grade) AS average_score
FROM 
    courses c
JOIN 
    enrollments e ON c.course_id = e.course_id
GROUP BY 
    c.course_name;
