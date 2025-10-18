PRAGMA foreign_keys = ON;

------------------------------------------------------------
-- Q2) Basics (SELECT, FROM, WHERE, ORDER BY):
-- Question: Which students major in Statistical Science and
-- started in or after 2023, sorted alphabetically by name?
------------------------------------------------------------
SELECT s.student_id, s.student_name, s.start_year, d.dept_name
FROM students s
JOIN departments d ON d.dept_id = s.major_dept
WHERE d.dept_name = 'Statistical Science'
  AND s.start_year >= 2023
ORDER BY s.student_name;