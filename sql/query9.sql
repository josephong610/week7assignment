PRAGMA foreign_keys = ON;

-- Q9) Set operations (UNION / INTERSECT / EXCEPT):
-- Question: Which students are taking Data Engineering or Database
-- Systems but not both?
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