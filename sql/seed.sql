-- Making sure foreign key constraints are enforced
PRAGMA foreign_keys = ON;

-- DEPARTMENTS
INSERT OR IGNORE INTO departments (dept_id, dept_name) VALUES
(1,'Statistical Science'),
(2,'Computer Science'),
(3,'Economics'),
(4,'Electrical & Computer Engineering'),
(5,'Mathematics'),
(6,'Physics'),
(7,'Biology'),
(8,'Public Policy');

-- INSTRUCTORS
INSERT OR IGNORE INTO instructors (instr_id, instr_name, hire_date, dept_id) VALUES
(10,'Dr. Li','2016-08-15',1),
(11,'Dr. Patel','2018-01-10',2),
(12,'Dr. Chen','2020-07-01',1),
(13,'Dr. Alvarez','2015-09-01',3),
(14,'Dr. Kim','2019-03-20',4),
(15,'Dr. Singh','2017-02-05',1),
(16,'Dr. Gomez','2014-11-12',2),
(17,'Dr. Oneill','2021-05-03',3),
(18,'Dr. Rivera','2013-06-18',4),
(19,'Dr. Martin','2012-09-09',5);


-- STUDENTS
INSERT OR IGNORE INTO students (student_id, student_name, start_year, major_dept) VALUES
(100,'Alex Rivera',2024,1),
(101,'Jordan Lee',2023,2),
(102,'Sam Patel',2022,1),
(103,'Morgan Chen',2025,3),
(104,'Taylor Brooks',2024,4),
(105,'Riley Zhang',2023,1),
(106,'Casey Nguyen',2024,2),
(107,'Jamie Park',2025,1),
(108,'Avery Johnson',2022,5),
(109,'Quinn Davis',2021,6),
(110,'Peyton Morales',2020,7),
(111,'Drew Thompson',2019,8),
(112,'Skyler Adams',2025,2),
(113,'Harper Scott',2023,3),
(114,'Rowan Bennett',2024,4),
(115,'Charlie Morgan',2022,1);

-- COURSES
INSERT OR IGNORE INTO courses (course_id, course_code, course_title, credits, dept_id, instr_id, term) VALUES
(200,'STA-602','Modern Regression',3,1,10,'2024F'),
(201,'STA-610','Hierarchical Models',3,1,12,'2024F'),
(202,'CS-571','Data Engineering',3,2,11,'2024F'),
(203,'ECE-685','Machine Learning',3,4,14,'2024F'),
(204,'ECON-501','Microeconomic Theory',3,3,13,'2024F'),
(205,'STA-602-2025S','Modern Regression',3,1,10,'2025S'),
(206,'CS-580','Database Systems',3,2,11,'2025S'),
(207,'MATH-510','Statistical Theory I',3,5,19,'2024F'),
(208,'PHYS-520','Computational Physics',4,6,16,'2025S'),
(209,'BIO-530','Bioinformatics',3,7,15,'2025F'),
(210,'PPOL-540','Policy Analytics',3,8,13,'2025F'),
(211,'STA-615','Bayesian Methods',3,1,12,'2025S'),
(212,'CS-585','Advanced Databases',3,2,16,'2025F'),
(213,'ECE-690','Deep Learning Systems',4,4,18,'2025F');

-- ENROLLMENTS
INSERT OR IGNORE INTO enrollments (enroll_id, student_id, course_id, grade, enrolled_on) VALUES
(1000,100,200,'A','2024-08-21'),
(1001,100,202,'A-','2024-08-22'),
(1002,101,202,'B+','2024-08-22'),
(1003,101,204,'A','2024-08-23'),
(1004,102,200,'B','2024-08-21'),
(1005,102,201,'A-','2024-08-22'),
(1006,103,204,NULL,'2024-08-25'),
(1007,104,203,'B+','2024-08-21'),
(1008,105,200,'A','2024-08-21'),
(1009,105,201,'A','2024-08-22'),
(1010,106,202,'B','2024-08-22'),
(1011,106,206,NULL,'2025-01-14'),
(1012,107,205,NULL,'2025-01-14'),
(1013,100,206,NULL,'2025-01-14'),
(1014,108,207,'A-','2024-08-26'),
(1015,109,208,'B+','2025-01-15'),
(1016,110,209,NULL,'2025-09-01'),
(1017,111,210,'A','2025-09-03'),
(1018,112,212,NULL,'2025-09-04'),
(1019,113,204,'B','2024-08-26'),
(1020,114,213,NULL,'2025-09-05'),
(1021,115,211,'A-','2025-01-16'),
(1022,108,200,'B+','2024-08-26'),
(1023,109,202,'A','2024-08-27'),
(1024,110,203,'B','2024-08-27'),
(1025,111,205,NULL,'2025-01-17'),
(1026,112,206,NULL,'2025-01-18'),
(1027,113,212,NULL,'2025-09-06');
