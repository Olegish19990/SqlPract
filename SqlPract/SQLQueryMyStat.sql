CREATE TABLE subjects (
    id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    title nvarchar(128) NOT NULL,
    deleted_at datetime NULL
);

CREATE TABLE groups (
    id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    title nvarchar(128) NOT NULL,
    status tinyint DEFAULT(1) NOT NULL
);


CREATE TABLE students 
(
	id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	first_name nvarchar(50) NOT NULL,
    last_name nvarchar(50) NOT NULL,
    email varchar(50) UNIQUE NOT NULL,
	group_id int NOT NULL,
	deleted_at datetime DEFAULT(NULL) NULL,
	CONSTRAINT FK_student_group FOREIGN KEY (group_id) REFERENCES groups(id)
	
)
CREATE TABLE teachers (
    id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    first_name nvarchar(50) NOT NULL,
    last_name nvarchar(50) NOT NULL,
    email varchar(50) UNIQUE NOT NULL
);

CREATE TABLE classrooms (
    id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    number smallint NOT NULL,
    title nvarchar(50) NULL
);

CREATE TABLE schedule_items (
    id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    number tinyint NOT NULL,
    item_start time NOT NULL,
    item_end time NOT NULL,
    status tinyint DEFAULT(1) NOT NULL
);




--- Homework
CREATE TABLE homeworks (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    homework_theme NVARCHAR(150) NOT NULL,
    description_homework NVARCHAR(450) NULL,
    task_file VARBINARY(MAX) NOT NULL,
    created_at DATETIME DEFAULT(GETDATE()),
    deadline DATETIME NOT NULL,
    subject_homework_id INT NOT NULL,
    teacher_id INT NOT NULL,
	
    CONSTRAINT FK_homeworks_subject FOREIGN KEY (subject_homework_id) REFERENCES subjects(id),
    CONSTRAINT FK_homeworks_teacher FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

CREATE TABLE completed_homeworks (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    homework_id INT NOT NULL,
    student_id INT NOT NULL,
    solution_file VARBINARY(MAX) NOT NULL,
    upload_date DATETIME DEFAULT(GETDATE()),
    comment NVARCHAR(250) NULL,
    CONSTRAINT FK_completed_homeworks_homework FOREIGN KEY (homework_id) REFERENCES homeworks(id),
    CONSTRAINT FK_completed_homeworks_student FOREIGN KEY (student_id) REFERENCES students(id)
);

CREATE TABLE homeworks_grades (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    completed_homework_id INT NOT NULL,
    grade INT CHECK (grade BETWEEN 1 AND 12) NOT NULL,
    graded_at DATETIME DEFAULT(GETDATE()) NOT NULL,
    comment NVARCHAR(250) NULL,
    CONSTRAINT FK_homeworks_grades_completed_homework FOREIGN KEY (completed_homework_id) REFERENCES completed_homeworks(id)
);




CREATE TABLE pairs (
    id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    pair_date date NOT NULL,
	pair_theme nvarchar(150) NOT NULL,
    is_online bit DEFAULT(1) NOT NULL,
    schedule_item_id int NOT NULL,
    subject_id int NOT NULL,
    group_id int NOT NULL,
    teacher_id int NOT NULL,
    classroom_id int NULL,
	homework_id int NULL,
    CONSTRAINT FK_pairs_schedule_item FOREIGN KEY (schedule_item_id) REFERENCES schedule_items (id),
    CONSTRAINT FK_pairs_subject FOREIGN KEY (subject_id) REFERENCES subjects (id),
    CONSTRAINT FK_pairs_group FOREIGN KEY (group_id) REFERENCES groups (id),
    CONSTRAINT FK_pairs_teacher FOREIGN KEY (teacher_id) REFERENCES teachers (id),
    CONSTRAINT FK_pairs_classroom FOREIGN KEY (classroom_id) REFERENCES classrooms (id),
	CONSTRAINT FK_pairs_homework FOREIGN KEY (homework_id) REFERENCES homeworks (id)
);

CREATE TABLE pair_records
(
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    pair_id INT NOT NULL,  -- —сылка на конкретную пару из таблицы pairs
    CONSTRAINT FK_pair_records_pair FOREIGN KEY (pair_id) REFERENCES pairs(id)  -- —в€зь с таблицей pairs
);


CREATE TABLE students_records
(
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    student_id INT NOT NULL,
    student_status NVARCHAR(20) NOT NULL CHECK (student_status IN ('отсутствует', 'опоздал', 'присутствует')),
    grade INT CHECK (grade BETWEEN 1 AND 12) NULL,
    comment NVARCHAR(250) NULL,
    pair_record_id INT NOT NULL,  
    CONSTRAINT FK_student_records_student FOREIGN KEY (student_id) REFERENCES students(id),
    CONSTRAINT FK_pair_record FOREIGN KEY (pair_record_id) REFERENCES pair_records(id) 
);



CREATE TABLE subjects_teachers (
    subject_id int NOT NULL,
    teacher_id int NOT NULL,

    CONSTRAINT PK_subjects_teachers PRIMARY KEY (subject_id, teacher_id),

    CONSTRAINT FK_subjects_teachers_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
    CONSTRAINT FK_subjects_teachers_teacher FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);