PRAGMA foreign_keys = ON;

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
