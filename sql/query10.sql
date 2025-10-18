PRAGMA foreign_keys = ON;

------------------------------------------------------------
-- Q10) Handle NULLs with COALESCE:
-- Question: How can we show all student grades, but replace
-- NULL values with the text 'In Progress'?
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
