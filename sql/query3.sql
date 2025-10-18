-- ================================
-- queries.sql  (SQLite)
-- ================================
PRAGMA foreign_keys = ON;

------------------------------------------------------------
-- Q1) CREATE TABLE + INSERT:
--    Build a table of high-performing students (GPA ≥ 3.7)
--    GPA is computed from letter grades in enrollments.
------------------------------------------------------------
DROP TABLE IF EXISTS high_performers;

-- Create the table with an explicit schema
CREATE TABLE high_performers (
  student_id   INTEGER PRIMARY KEY,
  student_name TEXT NOT NULL,
  gpa          REAL NOT NULL
);

-- Insert rows meeting the GPA threshold
INSERT INTO high_performers (student_id, student_name, gpa)
WITH numeric_grades AS (
  SELECT
    e.student_id,
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

-- Quick peek
-- SELECT * FROM high_performers ORDER BY gpa DESC;


------------------------------------------------------------
-- Q2) Basics (SELECT, FROM, WHERE, ORDER BY):
--    Students majoring in Statistical Science (dept = 1)
--    starting in or after 2023, sorted by name.
------------------------------------------------------------
SELECT s.student_id, s.student_name, s.start_year, d.dept_name
FROM students s
JOIN departments d ON d.dept_id = s.major_dept
WHERE d.dept_name = 'Statistical Science'
  AND s.start_year >= 2023
ORDER BY s.student_name;


------------------------------------------------------------
-- Q3) Aggregation + GROUP BY:
--    For each department:
--      - total distinct enrolled students
--      - average credits per course
------------------------------------------------------------
SELECT
  d.dept_name,
  COUNT(DISTINCT e.student_id) AS total_enrolled_students,
  ROUND(AVG(c.credits), 2)     AS avg_credits_per_course
FROM departments d
LEFT JOIN courses c   ON c.dept_id = d.dept_id
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_enrolled_students DESC, d.dept_name;


------------------------------------------------------------
-- Q4) INNER JOIN + LEFT JOIN:
--    List all students and their enrolled courses (title,
--    instructor) including students with no enrollments.
------------------------------------------------------------
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


------------------------------------------------------------
-- Q5) Data transformation with CASE:
--    Categorize each enrollment’s grade.
--      Excellent: A, A-
--      Good:      B+
--      Average:   B
--      Incomplete/Null: 'Incomplete'
------------------------------------------------------------
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
  END AS grade_bucket
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses  c ON c.course_id  = e.course_id
ORDER BY grade_bucket DESC, s.student_name;


------------------------------------------------------------
-- Q6) Window functions (RANK over PARTITION BY):
--    Rank students by GPA within each department.
------------------------------------------------------------
WITH numeric_grades AS (
  SELECT
    e.student_id,
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
JOIN students s   USING (student_id)
JOIN departments d ON d.dept_id = s.major_dept
ORDER BY d.dept_name, dept_gpa_rank;


------------------------------------------------------------
-- Q7) CTE + window function:
--    Top 3 students by GPA in each department.
------------------------------------------------------------
WITH numeric_grades AS (
  SELECT
    e.student_id,
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
  JOIN students s   USING (student_id)
  JOIN departments d ON d.dept_id = s.major_dept
)
SELECT dept_name, student_name, gpa, rn AS dept_rank
FROM ranked
WHERE rn <= 3
ORDER BY dept_name, dept_rank;


------------------------------------------------------------
-- Q8) String/Date functions:
--    For each instructor, show hire year and years teaching
--    as of 2025.
------------------------------------------------------------
SELECT
  i.instr_name,
  d.dept_name,
  SUBSTR(i.hire_date, 1, 4)            AS hire_year,
  (2025 - CAST(SUBSTR(i.hire_date, 1, 4) AS INTEGER)) AS years_teaching_as_of_2025
FROM instructors i
JOIN departments d ON d.dept_id = i.dept_id
ORDER BY years_teaching_as_of_2025 DESC, i.instr_name;


------------------------------------------------------------
-- Q9) Set operations (UNION / INTERSECT / EXCEPT):
--    Students taking Data Engineering OR Database Systems,
--    but NOT both. (Symmetric difference)
------------------------------------------------------------
-- A = students in 'Data Engineering'
WITH A AS (
  SELECT DISTINCT s.student_id, s.student_name
  FROM enrollments e
  JOIN courses c   ON c.course_id = e.course_id
  JOIN students s  ON s.student_id = e.student_id
  WHERE c.course_title = 'Data Engineering'
),
-- B = students in 'Database Systems'
B AS (
  SELECT DISTINCT s.student_id, s.student_name
  FROM enrollments e
  JOIN courses c   ON c.course_id = e.course_id
  JOIN students s  ON s.student_id = e.student_id
  WHERE c.course_title = 'Database Systems'
)
-- (A ∪ B) \ (A ∩ B)
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


------------------------------------------------------------
-- Q10) Handle NULLs with COALESCE:
--     Show student, course, and grade; replace NULL grades
--     with 'In Progress'.
------------------------------------------------------------
SELECT
  s.student_name,
  c.course_code,
  c.course_title,
  COALESCE(e.grade, 'In Progress') AS grade_display
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses  c ON c.course_id  = e.course_id
ORDER BY s.student_name, c.course_code;
