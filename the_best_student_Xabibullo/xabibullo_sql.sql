-- Kurslar jadvali
CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

-- Talabalar ro'yxati jadvali
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES student(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER
);

-- Kurslar uchun yangi ma'lumotlar
INSERT INTO courses (course_name, credit_hours) 
VALUES 
    ('Algebra', 3), 
    ('World History', 4), 
    ('Astronomy', 3), 
    ('Organic Chemistry', 4), 
    ('Microbiology', 3), 
    ('Creative Writing', 2), 
    ('Data Structures', 3), 
    ('Ethics', 2), 
    ('Finance', 3), 
    ('Sociology', 2);

-- Ro'yxatdan o'tgan talabalar uchun yangi yozuvlar
INSERT INTO enrollments (student_id, course_id, grade) 
VALUES 
    (1, 1, 4), (1, 2, 5), (1, 3, 3),
    (2, 2, 4), (2, 4, 5), (2, 6, 3),
    (3, 3, 3), (3, 5, 5), (3, 7, 4),
    (4, 8, 4), (4, 1, 3), (4, 6, 5),
    (5, 7, 3), (5, 9, 5), (5, 10, 4),
    (6, 1, 4), (6, 3, 5), (6, 8, 3),
    (7, 2, 3), (7, 4, 4), (7, 9, 5),
    (8, 6, 4), (8, 8, 5), (8, 10, 3),
    (9, 3, 5), (9, 7, 3), (9, 10, 4),
    (10, 4, 4), (10, 5, 5), (10, 9, 3);

-- Talabalar haqida ma'lumotni ko'rsatish
SELECT first_name, last_name, birthdate 
FROM student;

-- Matematika kursiga yozilgan talabalar
SELECT s.first_name, s.last_name 
FROM student s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Algebra';

-- Bahosi 4 dan past bo'lgan talabalar
SELECT s.first_name, s.last_name 
FROM student s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade < 4;

-- Talabalar va ularning kurslari
SELECT s.first_name, s.last_name, c.course_name 
FROM student s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Kurslarga yozilmagan talabalar
SELECT s.first_name, s.last_name 
FROM student s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- Har bir kursga yozilgan talabalar soni
SELECT c.course_name, COUNT(e.student_id) AS student_count 
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Eng ko'p talaba yozilgan kurs
SELECT c.course_name 
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY COUNT(e.student_id) DESC
LIMIT 1;

-- Talabalarni familiya bo'yicha tartiblash
SELECT first_name, last_name 
FROM students
ORDER BY last_name;

-- 2015-yildan keyin tug'ilgan va tarix kursiga yozilgan talabalar
SELECT s.first_name, s.last_name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'World History' AND s.birthdate > '2015-01-01';

-- O'rtacha kursdan ko'proq kursga yozilgan talabalar
SELECT s.first_name, s.last_name 
FROM students s
WHERE (SELECT COUNT(e.course_id) 
       FROM enrollments e 
       WHERE e.student_id = s.student_id) > 
      (SELECT AVG(course_count) 
       FROM (SELECT COUNT(e.course_id) AS course_count 
             FROM enrollments e 
             GROUP BY e.student_id) subquery);

-- Eng past bahoga ega talaba olgan kurs
SELECT c.course_name 
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN (
    SELECT student_id, AVG(grade) AS avg_grade 
    FROM enrollments 
    GROUP BY student_id 
    ORDER BY avg_grade ASC 
    LIMIT 1
) subquery ON e.student_id = subquery.student_id;

-- Bahosi 4 bo'lgan yozuvlarni 3 ga o'zgartirish
UPDATE enrollments 
SET grade = 3 
WHERE grade = 4;

-- Ro'yxatdan o'tmagan talabalarni o'chirish
DELETE FROM students 
WHERE student_id NOT IN (SELECT DISTINCT student_id FROM enrollments);

-- Yangi talaba qo'shish
INSERT INTO students (first_name, last_name, birthdate) 
VALUES ('John', 'Doe', '2003-05-15');

-- Yangi talabaning yozuvlari
INSERT INTO enrollments (student_id, course_id, grade) 
VALUES 
    ((SELECT MAX(student_id) FROM students), 1, 4),
    ((SELECT MAX(student_id) FROM students), 2, 5);

-- Kurslarning o'rtacha bahosi
SELECT c.course_name, AVG(e.grade) AS average_score 
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;
