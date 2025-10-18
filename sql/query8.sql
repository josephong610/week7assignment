PRAGMA foreign_keys = ON;

------------------------------------------------------------
-- Q8) String/Date functions:
-- Question: For each instructor, what year were they hired and
-- how many years have they been teaching as of 2025?
------------------------------------------------------------
SELECT
  i.instr_name,
  d.dept_name,
  SUBSTR(i.hire_date, 1, 4)            AS hire_year,
  (2025 - CAST(SUBSTR(i.hire_date, 1, 4) AS INTEGER)) AS years_teaching_as_of_2025
FROM instructors i
JOIN departments d ON d.dept_id = i.dept_id
ORDER BY years_teaching_as_of_2025 DESC, i.instr_name;
