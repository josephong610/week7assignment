PRAGMA foreign_keys = ON;

-- Q1) CREATE TABLE + INSERT:
-- Question: How can we create a new table of high-performing
-- students (GPA ≥ 3.7) based on their grades, and insert data into it?

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
SELECT * FROM high_performers ORDER BY gpa DESC;


