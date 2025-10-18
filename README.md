# Week 7 Assignment

---

## Database Overview

**Database:** `guidebook.db`  
**Tables:** `departments`, `instructors`, `students`, `courses`, `enrollments`

Each table is linked using **foreign keys**, and together they simulate a small university environment where students enroll in courses taught by instructors across multiple departments.

---

## Table Descriptions and Sample Data

Below is a quick reference for each table, its purpose, and an example of what a few rows of data look like.

### `departments`
Stores all academic departments available in the university.

| dept_id | dept_name |
|----------|-------------------------------|
| 1 | Statistical Science |
| 2 | Computer Science |
| 3 | Economics |
| 4 | Electrical & Computer Engineering |
| 5 | Mathematics |

**Primary Key:** `dept_id`

---

### `instructors`
Stores information about instructors, including which department they belong to and their hire dates.

| instr_id | instr_name | hire_date | dept_id |
|-----------|-------------|------------|----------|
| 10 | Dr. Li | 2016-08-15 | 1 |
| 11 | Dr. Patel | 2018-01-10 | 2 |
| 12 | Dr. Chen | 2020-07-01 | 1 |
| 13 | Dr. Alvarez | 2015-09-01 | 3 |
| 14 | Dr. Kim | 2019-03-20 | 4 |

**Primary Key:** `instr_id`  
**Foreign Key:** `dept_id → departments.dept_id`

---

### `students`
Stores data about students, their major department, and the year they started.

| student_id | student_name | start_year | major_dept |
|-------------|---------------|-------------|-------------|
| 100 | Alex Rivera | 2024 | 1 |
| 101 | Jordan Lee | 2023 | 2 |
| 102 | Sam Patel | 2022 | 1 |
| 103 | Morgan Chen | 2025 | 3 |
| 104 | Taylor Brooks | 2024 | 4 |

**Primary Key:** `student_id`  
**Foreign Key:** `major_dept → departments.dept_id`

---

### `courses`
Contains all courses, their department, the instructor teaching them, and which academic term they are offered.

| course_id | course_code | course_title | credits | dept_id | instr_id | term |
|------------|--------------|---------------|----------|----------|-----------|------|
| 200 | STA-602 | Modern Regression | 3 | 1 | 10 | 2024F |
| 201 | STA-610 | Hierarchical Models | 3 | 1 | 12 | 2024F |
| 202 | CS-571 | Data Engineering | 3 | 2 | 11 | 2024F |
| 203 | ECE-685 | Machine Learning | 3 | 4 | 14 | 2024F |
| 204 | ECON-501 | Microeconomic Theory | 3 | 3 | 13 | 2024F |

**Primary Key:** `course_id`  
**Foreign Keys:**  
- `dept_id → departments.dept_id`  
- `instr_id → instructors.instr_id`

---

### `enrollments`
A many-to-many relationship table connecting `students` and `courses`, with grade information for each student-course pair.

| enroll_id | student_id | course_id | grade | enrolled_on |
|------------|-------------|------------|-------|--------------|
| 1000 | 100 | 200 | A | 2024-08-21 |
| 1001 | 100 | 202 | A- | 2024-08-22 |
| 1002 | 101 | 202 | B+ | 2024-08-22 |
| 1003 | 101 | 204 | A | 2024-08-23 |
| 1004 | 102 | 200 | B | 2024-08-21 |

**Primary Key:** `enroll_id`  
**Foreign Keys:**  
- `student_id → students.student_id`  
- `course_id → courses.course_id`  
**Unique Constraint:** `(student_id, course_id)`

---

## Query Documentation

Below are the 10 SQL questions and their associated queries.  
Each section includes a title, short description, and the SQL statement.  
You can add your **query outputs or screenshots** beneath each code block.

---

### 1. Create a Table of High-Performing Students
**Goal:** Create a new table that stores students who achieved a GPA of **3.7 or higher** based on their course grades.

```sql
CREATE TABLE high_performers (...);

INSERT INTO high_performers (student_id, student_name, gpa)
WITH numeric_grades AS (
  SELECT e.student_id,
         CASE e.grade
           WHEN 'A'  THEN 4.0
           WHEN 'A-' THEN 3.7
           WHEN 'B+' THEN 3.3
           WHEN 'B'  THEN 3.0
           ELSE NULL
         END AS g
  FROM enrollments e
),
gpa_by_student AS (
  SELECT student_id, ROUND(AVG(g), 2) AS gpa
  FROM numeric_grades
  WHERE g IS NOT NULL
  GROUP BY student_id
)
SELECT s.student_id, s.student_name, g.gpa
FROM gpa_by_student g
JOIN students s USING (student_id)
WHERE g.gpa >= 3.7
ORDER BY g.gpa DESC;
```

**Output:** *(add screenshot or query results here)*

---

### 2. Filter and Sort Statistical Science Students
**Goal:** Retrieve all students majoring in *Statistical Science* who started in or after **2023**, sorted alphabetically.

```sql
SELECT s.student_id, s.student_name, s.start_year, d.dept_name
FROM students s
JOIN departments d ON d.dept_id = s.major_dept
WHERE d.dept_name = 'Statistical Science'
  AND s.start_year >= 2023
ORDER BY s.student_name;
```

**Output:**

---

### 3. Aggregate Students and Course Credits by Department
**Goal:** Find, for each department, the **total number of enrolled students** and the **average course credit load**.

```sql
SELECT
  d.dept_name,
  COUNT(DISTINCT e.student_id) AS total_enrolled_students,
  ROUND(AVG(c.credits), 2)     AS avg_credits_per_course
FROM departments d
LEFT JOIN courses c   ON c.dept_id = d.dept_id
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_enrolled_students DESC, d.dept_name;
```

**Output:**

---

### 4. Display Students with Their Courses and Instructors
**Goal:** Show all students and the courses they’re enrolled in, along with their instructors — including students with **no enrollments**.

```sql
SELECT
  s.student_name,
  c.course_code,
  c.course_title,
  i.instr_name AS instructor,
  e.grade
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
LEFT JOIN courses c     ON c.course_id = e.course_id
LEFT JOIN instructors i ON i.instr_id  = c.instr_id
ORDER BY s.student_name, c.course_code;
```

**Output:**

---

### 5. Categorize Grades Using CASE
**Goal:** Classify grades into categories such as *Excellent*, *Good*, *Average*, and *Incomplete*.

```sql
SELECT
  s.student_name,
  c.course_code,
  c.course_title,
  e.grade,
  CASE
    WHEN e.grade IN ('A','A-') THEN 'Excellent'
    WHEN e.grade = 'B+'        THEN 'Good'
    WHEN e.grade = 'B'         THEN 'Average'
    WHEN e.grade IS NULL       THEN 'Incomplete'
    ELSE 'Other'
  END AS grade_category
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses  c ON c.course_id  = e.course_id
ORDER BY grade_category DESC, s.student_name;
```

**Output:**

---

### 6. Rank Students by GPA Within Each Department
**Goal:** Calculate each student’s GPA and assign them a **rank within their department** using `RANK()` and `PARTITION BY`.

```sql
WITH numeric_grades AS (
  SELECT e.student_id,
         CASE e.grade
           WHEN 'A'  THEN 4.0
           WHEN 'A-' THEN 3.7
           WHEN 'B+' THEN 3.3
           WHEN 'B'  THEN 3.0
           ELSE NULL
         END AS g
  FROM enrollments e
),
gpa_by_student AS (
  SELECT student_id, ROUND(AVG(g), 2) AS gpa
  FROM numeric_grades
  WHERE g IS NOT NULL
  GROUP BY student_id
)
SELECT
  d.dept_name,
  s.student_name,
  g.gpa,
  RANK() OVER (PARTITION BY d.dept_id ORDER BY g.gpa DESC) AS dept_gpa_rank
FROM gpa_by_student g
JOIN students s USING (student_id)
JOIN departments d ON d.dept_id = s.major_dept
ORDER BY d.dept_name, dept_gpa_rank;
```

**Output:**

---

### 7. Find the Top 3 Students Per Department (CTE)
**Goal:** Use a **CTE** and `ROW_NUMBER()` to find the **top 3 students** by GPA in each department.

```sql
WITH numeric_grades AS (
  SELECT e.student_id,
         CASE e.grade
           WHEN 'A'  THEN 4.0
           WHEN 'A-' THEN 3.7
           WHEN 'B+' THEN 3.3
           WHEN 'B'  THEN 3.0
           ELSE NULL
         END AS g
  FROM enrollments e
),
gpa_by_student AS (
  SELECT student_id, ROUND(AVG(g), 2) AS gpa
  FROM numeric_grades
  WHERE g IS NOT NULL
  GROUP BY student_id
),
ranked AS (
  SELECT
    d.dept_name,
    s.student_name,
    g.gpa,
    ROW_NUMBER() OVER (PARTITION BY d.dept_id ORDER BY g.gpa DESC, s.student_name) AS rn
  FROM gpa_by_student g
  JOIN students s USING (student_id)
  JOIN departments d ON d.dept_id = s.major_dept
)
SELECT dept_name, student_name, gpa, rn AS dept_rank
FROM ranked
WHERE rn <= 3
ORDER BY dept_name, dept_rank;
```

**Output:**

---

### 8. Analyze Instructor Tenure Using Date Functions
**Goal:** Extract the **year** from each instructor’s hire date and calculate how many **years they’ve been teaching** as of 2025.

```sql
SELECT
  i.instr_name,
  d.dept_name,
  SUBSTR(i.hire_date, 1, 4) AS hire_year,
  (2025 - CAST(SUBSTR(i.hire_date, 1, 4) AS INTEGER)) AS years_teaching
FROM instructors i
JOIN departments d ON d.dept_id = i.dept_id
ORDER BY years_teaching DESC, i.instr_name;
```

**Output:**

---

### 9. Compare Students Using Set Operations
**Goal:** Identify students who are enrolled in *Data Engineering* or *Database Systems*, but **not both**.

```sql
WITH A AS (
  SELECT DISTINCT s.student_id, s.student_name
  FROM enrollments e
  JOIN courses c ON c.course_id = e.course_id
  JOIN students s ON s.student_id = e.student_id
  WHERE c.course_title = 'Data Engineering'
),
B AS (
  SELECT DISTINCT s.student_id, s.student_name
  FROM enrollments e
  JOIN courses c ON c.course_id = e.course_id
  JOIN students s ON s.student_id = e.student_id
  WHERE c.course_title = 'Database Systems'
)
SELECT student_id, student_name FROM (
  SELECT * FROM A
  UNION
  SELECT * FROM B
)
EXCEPT
SELECT student_id, student_name FROM (
  SELECT * FROM A
  INTERSECT
  SELECT * FROM B
)
ORDER BY student_name;
```

**Output:**

---

### 10. Replace Missing Grades Using COALESCE
**Goal:** Show all student enrollments and replace **NULL** grades with `"In Progress"` for ongoing courses.

```sql
SELECT
  s.student_name,
  c.course_code,
  c.course_title,
  COALESCE(e.grade, 'In Progress') AS displayed_grade
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses  c ON c.course_id  = e.course_id
ORDER BY s.student_name, c.course_code;
```

**Output:**

---

## Summary of SQL Concepts Demonstrated

| SQL Concept | Example Queries |
|--------------|----------------|
| `CREATE TABLE`, `INSERT` | Q1 |
| `SELECT`, `FROM`, `WHERE`, `ORDER BY` | Q2 |
| `GROUP BY`, `COUNT`, `AVG`, `HAVING` | Q3 |
| `INNER JOIN`, `LEFT JOIN` | Q4 |
| `CASE WHEN` for data transformation | Q5 |
| `RANK()` and `PARTITION BY` | Q6 |
| `CTE` with `ROW_NUMBER()` | Q7 |
| String/Date functions | Q8 |
| `UNION`, `EXCEPT` | Q9 |
| `COALESCE()` for null handling | Q10 |

---

### Running queries
- Run each query in SQLite using:
  ```bash
  sqlite3 db/guidebook.db < sql/queries.sql
  ```
- Capture screenshots of your results for each section and paste them below each “📊 Output” placeholder.
- Commit all `.sql` and `.md` files to your GitHub repo for submission.

---
