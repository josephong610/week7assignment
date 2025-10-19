PRAGMA foreign_keys = ON;

-- Q6) Window functions (RANK over PARTITION BY):
-- Question: How can we rank students by GPA within each department?
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