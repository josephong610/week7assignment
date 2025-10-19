PRAGMA foreign_keys = ON;

-- Q7) CTE + window function:
-- Question: Using a CTE, who are the top three students in each
-- department ranked by GPA?
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