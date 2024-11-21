# Lab #2: Working with Queries and Modifying Data in PostgreSQL

## Objective of the work

Learn to use advanced SQL queries, including:

- Joining tables (`JOIN`)
- Subqueries
- Modifying data (`INSERT`, `UPDATE`, `DELETE`)
- Grouping and sorting data (`GROUP BY`, `ORDER BY`)

## Tasks

### 1. Creating additional tables

Add the following tables to the university database:

#### Table `courses`

| Column         | Data Type    | Description                    |
|----------------|--------------|--------------------------------|
| `course_id`    | SERIAL       | Unique id course (PRIMARY KEY) |
| `course_name`  | VARCHAR(100) | Course name                    |
| `credit_hours` | INTEGER      | Number of credits              |

#### Table `enrollments`

| Column          | Data Type | Description                    |
|-----------------|-----------|--------------------------------|
| `enrollment_id` | SERIAL    | Unique id course (PRIMARY KEY) |
| `student_id`    | INTEGER   | Student id (FOREIGN KEY)       |
| `course_id`     | INTEGER   | Course id (FOREIGN KEY)        |
| `grade`         | INTEGER   | Student's assessment           |



### 2. Filling with data

- **Table `courses`:** Add 10 rows (eg "Mathematics", "History", "Physics", etc.).
- **Table `enrollments`:** Add 30 rows linking students to courses and assigning grades.

---

### 3. Practical tasks

#### 3.1. Queries

- Display all students with their first name, last name, and date of birth.
- Find all students enrolled in the `Mathematics` course.
- Display all students with a GPA lower than 4.

#### 3.2. Joining data (`JOIN`)

- List students along with the names of the courses they are enrolled in.
- Find students who are not enrolled in any courses.

#### 3.3. Grouping and Aggregates

- Count the number of students enrolled in each course.
- Find the course with the most students.

#### 3.4. Filtering and Sorting

- List students sorted by last name.
- Find all students enrolled after 2015 and enrolled in the `History` course.

#### 3.5. Working with Subqueries

- Find students enrolled in more courses than the average number of courses per student.
- List the names of courses enrolled by students with the lowest average grade.

#### 3.6. Modifying Data

- Update the grade of all students with a current grade of 4 to 3.
- Remove all students who are not enrolled in any courses.
- Add a new student and enroll him in two courses.

### 4. Additional task (optional)

Write a query to calculate the average score of all students for each course and output the results in the following format:

- Course name
- Average score

---

## Expected results

1. **SQL script** Uploaded to GitHub(create Pull Request) and Hemis(in Word format you need send link your repository).
2. **Defense** Defense of completed lab work #2.

---
