PRAGMA foreign_keys = ON;

-- Q5) Data transformation with CASE:
-- Question: How can we categorize students’ letter grades into
-- performance groups (Excellent, Good, Average, or Incomplete)?
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