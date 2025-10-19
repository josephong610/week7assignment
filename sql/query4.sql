PRAGMA foreign_keys = ON;

-- Q4) INNER JOIN + LEFT JOIN:
-- Question: List all students and their enrolled courses, showing
-- course titles and instructors — including students with no enrollments.

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
