PRAGMA foreign_keys = ON;


-- Q3) Aggregation + GROUP BY:
-- Question: For each department, what is the total number of
-- enrolled students and the average credits per course?

SELECT
  d.dept_name,
  COUNT(DISTINCT e.student_id) AS total_enrolled_students,
  ROUND(AVG(c.credits), 2)     AS avg_credits_per_course
FROM departments d
LEFT JOIN courses c   ON c.dept_id = d.dept_id
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_enrolled_students DESC, d.dept_name;


