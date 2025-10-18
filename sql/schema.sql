PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS students;

-- 1) departments
CREATE TABLE departments (
  dept_id      INTEGER PRIMARY KEY,
  dept_name    TEXT NOT NULL UNIQUE
);

-- 2) instructors
CREATE TABLE instructors (
  instr_id     INTEGER PRIMARY KEY,
  instr_name   TEXT NOT NULL,
  hire_date    TEXT NOT NULL,
  dept_id      INTEGER NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 3) students
CREATE TABLE students (
  student_id   INTEGER PRIMARY KEY,
  student_name TEXT NOT NULL,
  start_year   INTEGER NOT NULL CHECK (start_year BETWEEN 2019 AND 2025),
  major_dept   INTEGER NOT NULL,
  FOREIGN KEY (major_dept) REFERENCES departments(dept_id)
);

-- 4) courses
CREATE TABLE courses (
  course_id    INTEGER PRIMARY KEY,
  course_code  TEXT NOT NULL UNIQUE,
  course_title TEXT NOT NULL,
  credits      INTEGER NOT NULL CHECK (credits BETWEEN 1 AND 5),
  dept_id      INTEGER NOT NULL,
  instr_id     INTEGER NOT NULL,
  term         TEXT NOT NULL CHECK (term IN ('2024F','2025S','2025F')),
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
  FOREIGN KEY (instr_id) REFERENCES instructors(instr_id)
);

-- 5) enrollments (bridge table for many-to-many)
CREATE TABLE enrollments (
  enroll_id    INTEGER PRIMARY KEY,
  student_id   INTEGER NOT NULL,
  course_id    INTEGER NOT NULL,
  grade        TEXT,
  enrolled_on  TEXT NOT NULL,
  UNIQUE (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id)  REFERENCES courses(course_id)
);
