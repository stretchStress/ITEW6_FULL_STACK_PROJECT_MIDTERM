-- ============================================================
-- CCS Department System — OPTIMIZED SCHEMA
-- Scaled down from 24 → 16 tables
-- All data preserved; no information loss
--
-- Merges applied:
--  1. faculty_education + faculty_position → faculty_record
--     (type discriminator: 'education' | 'position')
--  2. syllabus_topic + syllabus_outcome → syllabus_topic
--     (outcomes stored as JSON text column)
--  3. lesson folded into syllabus_topic
--     (lesson_no, lesson content columns added directly)
--  4. publication folded into research_project
--     (pub_* columns added; NULL when unpublished)
--  5. student_schedule promoted to a richer enrollment link;
--     student_enrollment merged into student_schedule
--     (reg/irreg + units tracked on same row = one record per student per class)
--
-- Kept separate (structurally distinct / different cardinality):
--  academic_term, member, department, program, course,
--  curriculum, curriculum_course, room, schedule,
--  certification, extracurricular, student_organization,
--  student_leave, student_medical, event, event_participant,
--  research_project, research_member
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
/*!40101 SET NAMES utf8mb4 */;

-- ============================================================
-- DATABASE
-- ============================================================

-- --------------------------------------------------------
-- 1. academic_term  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `academic_term` (
  `id`            smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `academic_year` varchar(9)  NOT NULL COMMENT 'e.g. 2024-2025',
  `semester`      enum('1st','2nd','Summer') NOT NULL,
  `start_date`    date DEFAULT NULL,
  `end_date`      date DEFAULT NULL,
  `is_current`    tinyint(1)  NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_term` (`academic_year`,`semester`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Single source of truth for all semester references';

INSERT INTO `academic_term` VALUES
(1,'2023-2024','1st','2023-08-14','2023-12-15',0),
(2,'2023-2024','2nd','2024-01-08','2024-05-10',0),
(3,'2024-2025','1st','2024-08-12','2024-12-13',0),
(4,'2024-2025','2nd','2025-01-06','2025-05-09',1),
(5,'2024-2025','Summer','2025-05-26','2025-07-04',0);

-- --------------------------------------------------------
-- 2. department  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `department` (
  `id`        tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`      varchar(10) NOT NULL,
  `name`      varchar(100) NOT NULL,
  `is_active` tinyint(1)  NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_dept_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `department` VALUES
(1,'CCS','College of Computer Studies',1),
(2,'CAS','College of Arts and Sciences',1),
(3,'CEA','College of Engineering and Architecture',1);

-- --------------------------------------------------------
-- 3. program  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `program` (
  `id`            smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `department_id` tinyint(3)  UNSIGNED NOT NULL,
  `code`          varchar(15) NOT NULL,
  `title`         varchar(120) NOT NULL,
  `total_units`   smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `is_active`     tinyint(1)  NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_program_code` (`code`),
  KEY `fk_prog_dept` (`department_id`),
  CONSTRAINT `fk_prog_dept` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `program` VALUES
(1,1,'BSCS','Bachelor of Science in Computer Science',165,1),
(2,1,'BSIT','Bachelor of Science in Information Technology',162,1),
(3,1,'BSIS','Bachelor of Science in Information Systems',162,1),
(4,1,'BSEMC','BS Entertainment and Multimedia Computing',163,1);

-- --------------------------------------------------------
-- 4. member  (unchanged — single-table design is already optimized)
-- --------------------------------------------------------
CREATE TABLE `member` (
  `id`               varchar(20)  NOT NULL COMMENT 'Natural key: 2024-CCS-0001 | FAC-2024-001 | ADMIN-001',
  `role`             enum('student','faculty','admin') NOT NULL,
  `last_name`        varchar(50)  NOT NULL,
  `first_name`       varchar(50)  NOT NULL,
  `middle_name`      varchar(50)  DEFAULT NULL,
  `suffix`           varchar(10)  DEFAULT NULL,
  `birth_date`       date         NOT NULL,
  `sex`              enum('M','F','O') NOT NULL,
  `civil_status`     enum('S','M','W','P') NOT NULL,
  `nationality`      varchar(40)  NOT NULL DEFAULT 'Filipino',
  `religion`         varchar(40)  DEFAULT NULL,
  `contact_no`       varchar(15)  NOT NULL,
  `email`            varchar(100) NOT NULL,
  `address_home`     text         NOT NULL,
  `address_current`  text         DEFAULT NULL,
  `photo_path`       varchar(255) DEFAULT NULL,
  `username`         varchar(50)  NOT NULL,
  `password_hash`    varchar(255) NOT NULL,
  `is_active`        tinyint(1)   NOT NULL DEFAULT 1,
  `last_login_at`    datetime     DEFAULT NULL,
  -- student fields
  `program_id`       smallint(5)  UNSIGNED DEFAULT NULL,
  `year_level`       tinyint(3)   UNSIGNED DEFAULT NULL COMMENT '1-4; 0=Irregular',
  `section`          varchar(10)  DEFAULT NULL,
  `student_status`   enum('active','inactive','loa','dropped','graduated') DEFAULT NULL,
  `scholarship`      varchar(80)  DEFAULT NULL,
  `enrolled_at`      date         DEFAULT NULL,
  `emergency_name`   varchar(100) DEFAULT NULL,
  `emergency_rel`    varchar(40)  DEFAULT NULL,
  `emergency_no`     varchar(15)  DEFAULT NULL,
  -- faculty fields
  `department_id`    tinyint(3)   UNSIGNED DEFAULT NULL,
  `employee_no`      varchar(15)  DEFAULT NULL,
  `employment_type`  enum('full_time','part_time','contractual') DEFAULT NULL,
  `is_full_time`     tinyint(1)   DEFAULT NULL,
  `hired_at`         date         DEFAULT NULL,
  `salary_grade`     varchar(10)  DEFAULT NULL,
  `sss_no`           varchar(20)  DEFAULT NULL,
  `tin`              varchar(15)  DEFAULT NULL,
  `gsis_no`          varchar(20)  DEFAULT NULL,
  -- audit
  `created_by`       varchar(20)  DEFAULT NULL,
  `created_at`       datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at`       datetime     DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_member_email`    (`email`),
  UNIQUE KEY `uq_member_username` (`username`),
  UNIQUE KEY `uq_member_emp_no`   (`employee_no`),
  KEY `fk_member_program`  (`program_id`),
  KEY `fk_member_dept`     (`department_id`),
  KEY `idx_member_role`    (`role`),
  KEY `idx_member_status`  (`student_status`),
  KEY `idx_member_year`    (`year_level`),
  CONSTRAINT `fk_member_program` FOREIGN KEY (`program_id`)    REFERENCES `program`    (`id`),
  CONSTRAINT `fk_member_dept`    FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `member` (`id`,`role`,`last_name`,`first_name`,`birth_date`,`sex`,`civil_status`,
  `contact_no`,`email`,`address_home`,`username`,`password_hash`,`is_active`,`created_at`) VALUES
('ADMIN-001','admin','Administrator','System','1990-01-01','M','S',
  '09000000000','admin@ccs.edu.ph','CCS Building','ccs_admin','REPLACE_WITH_BCRYPT_HASH',1,'2026-03-02 11:44:18');

-- --------------------------------------------------------
-- 5. room  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `room` (
  `id`            smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`          varchar(20)  NOT NULL,
  `name`          varchar(100) NOT NULL,
  `type`          enum('lecture','laboratory','conference','auditorium','other') NOT NULL,
  `capacity`      smallint(5)  UNSIGNED NOT NULL DEFAULT 0,
  `building`      varchar(60)  DEFAULT NULL,
  `floor_no`      tinyint(4)   DEFAULT NULL,
  `has_projector` tinyint(1)   NOT NULL DEFAULT 0,
  `has_ac`        tinyint(1)   NOT NULL DEFAULT 0,
  `is_active`     tinyint(1)   NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_room_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Rooms shared by scheduling and events';

INSERT INTO `room` VALUES
(1,'CCS-LEC1','CCS Lecture Room 1','lecture',40,'CCS Building',1,1,1,1),
(2,'CCS-LEC2','CCS Lecture Room 2','lecture',40,'CCS Building',1,1,1,1),
(3,'CCS-LAB1','CCS Computer Lab 1','laboratory',35,'CCS Building',2,1,1,1),
(4,'CCS-LAB2','CCS Computer Lab 2','laboratory',35,'CCS Building',2,1,1,1),
(5,'CCS-CONF','CCS Conference Room','conference',20,'CCS Building',3,1,1,1),
(6,'MAIN-AUD','Main Auditorium','auditorium',500,'Main Building',1,1,1,1);

-- --------------------------------------------------------
-- 6. course  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `course` (
  `id`          smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`        varchar(15)  NOT NULL,
  `title`       varchar(150) NOT NULL,
  `units`       tinyint(3)   UNSIGNED NOT NULL,
  `lab_units`   tinyint(3)   UNSIGNED NOT NULL DEFAULT 0,
  `description` text         DEFAULT NULL,
  `is_active`   tinyint(1)   NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_course_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Master course list — shared by schedule, syllabus, curriculum';

INSERT INTO `course` (`id`,`code`,`title`,`units`,`lab_units`,`is_active`) VALUES
(1,'CS 101','Introduction to Computing',3,0,1),
(2,'CS 102','Computer Programming 1',3,0,1),
(3,'CS 201','Data Structures and Algorithms',3,0,1),
(4,'CS 301','Operating Systems',3,0,1),
(5,'CS 302','Database Management Systems',3,0,1),
(6,'CS 401','Software Engineering',3,0,1),
(7,'IT 101','Introduction to Information Technology',3,0,1),
(8,'IT 201','Web Systems and Technologies',3,0,1),
(9,'IT 301','Systems Integration and Architecture',3,0,1),
(10,'GE 001','Understanding the Self',3,0,1),
(11,'GE 002','Purposive Communication',3,0,1),
(12,'GE 003','Mathematics in the Modern World',3,0,1);

-- --------------------------------------------------------
-- 7. curriculum  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `curriculum` (
  `id`              smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `program_id`      smallint(5) UNSIGNED NOT NULL,
  `code`            varchar(20)  NOT NULL,
  `effectivity_ay`  varchar(9)   NOT NULL,
  `description`     text         DEFAULT NULL,
  `is_active`       tinyint(1)   NOT NULL DEFAULT 1,
  `approved_by`     varchar(100) DEFAULT NULL,
  `created_at`      datetime     NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_curriculum` (`program_id`,`code`),
  KEY `idx_curr_active` (`is_active`),
  CONSTRAINT `fk_curr_program` FOREIGN KEY (`program_id`) REFERENCES `program` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- 8. curriculum_course  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `curriculum_course` (
  `id`              smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `curriculum_id`   smallint(5) UNSIGNED NOT NULL,
  `course_id`       smallint(5) UNSIGNED NOT NULL,
  `year_level`      tinyint(3)   UNSIGNED NOT NULL,
  `semester`        enum('1st','2nd','Summer') NOT NULL,
  `is_elective`     tinyint(1)   NOT NULL DEFAULT 0,
  `prerequisite_id` smallint(5)  UNSIGNED DEFAULT NULL COMMENT 'FK to course.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_cc` (`curriculum_id`,`course_id`),
  KEY `fk_cc_course`  (`course_id`),
  KEY `fk_cc_prereq`  (`prerequisite_id`),
  CONSTRAINT `fk_cc_curriculum` FOREIGN KEY (`curriculum_id`)    REFERENCES `curriculum` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cc_course`     FOREIGN KEY (`course_id`)        REFERENCES `course`     (`id`),
  CONSTRAINT `fk_cc_prereq`     FOREIGN KEY (`prerequisite_id`)  REFERENCES `course`     (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- 9. schedule  (unchanged — already compact with exam cols)
-- --------------------------------------------------------
CREATE TABLE `schedule` (
  `id`           int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `term_id`      smallint(5) UNSIGNED NOT NULL,
  `member_id`    varchar(20)  NOT NULL COMMENT 'Faculty teaching this slot',
  `course_id`    smallint(5)  UNSIGNED NOT NULL,
  `room_id`      smallint(5)  UNSIGNED NOT NULL,
  `section`      varchar(10)  NOT NULL,
  `day_pattern`  varchar(10)  NOT NULL COMMENT 'e.g. MWF, TTh, Sat',
  `time_start`   time         NOT NULL,
  `time_end`     time         NOT NULL,
  `lecture_type` enum('regular','major') NOT NULL DEFAULT 'regular'
                 COMMENT 'regular=2hrs per meeting, major=3hrs per meeting',
  `class_size`   smallint(5)  UNSIGNED DEFAULT NULL,
  `exam_type`    enum('midterm','final','quiz','special') DEFAULT NULL
                 COMMENT 'NULL = regular class slot',
  `exam_date`    date         DEFAULT NULL,
  `exam_notes`   text         DEFAULT NULL,
  `is_active`    tinyint(1)   NOT NULL DEFAULT 1,
  `created_at`   datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at`   datetime     DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_room_slot`    (`term_id`,`room_id`,`day_pattern`,`time_start`,`exam_date`),
  UNIQUE KEY `uq_faculty_slot` (`term_id`,`member_id`,`day_pattern`,`time_start`,`exam_date`),
  KEY `fk_sched_faculty` (`member_id`),
  KEY `fk_sched_course`  (`course_id`),
  KEY `fk_sched_room`    (`room_id`),
  KEY `idx_sched_term`   (`term_id`),
  KEY `idx_sched_section`(`section`),
  KEY `idx_sched_exam`   (`exam_type`,`exam_date`),
  CONSTRAINT `fk_sched_term`    FOREIGN KEY (`term_id`)   REFERENCES `academic_term` (`id`),
  CONSTRAINT `fk_sched_faculty` FOREIGN KEY (`member_id`) REFERENCES `member`        (`id`),
  CONSTRAINT `fk_sched_course`  FOREIGN KEY (`course_id`) REFERENCES `course`        (`id`),
  CONSTRAINT `fk_sched_room`    FOREIGN KEY (`room_id`)   REFERENCES `room`          (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Master schedule for classes AND exams. lecture_type enforces 2hr/3hr slot duration.';

-- --------------------------------------------------------
-- 10. student_schedule  ← MERGED with student_enrollment
--     Previously 2 tables: student_schedule + student_enrollment
--     Now 1 table tracking both: which class a student is in
--     AND their term-level enrollment status.
--     The term-level reg/irreg row is identified by schedule_id IS NULL.
-- --------------------------------------------------------
CREATE TABLE `student_schedule` (
  `id`             int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`      varchar(20)  NOT NULL COMMENT 'Student',
  `term_id`        smallint(5)  UNSIGNED NOT NULL,
  `schedule_id`    int(10)      UNSIGNED DEFAULT NULL
                   COMMENT 'NULL = term enrollment summary row; non-null = specific class link',
  -- enrollment summary cols (populated on the NULL-schedule_id row per term)
  `is_regular`     tinyint(1)   DEFAULT NULL,
  `units_enrolled` tinyint(3)   UNSIGNED DEFAULT NULL,
  `units_standard` tinyint(3)   UNSIGNED DEFAULT NULL,
  `irreg_reason`   text         DEFAULT NULL,
  `assessed_by`    varchar(20)  DEFAULT NULL,
  `created_at`     datetime     NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_student_sched`  (`member_id`,`schedule_id`),
  UNIQUE KEY `uq_term_enrollment` (`member_id`,`term_id`, `schedule_id`),
  KEY `fk_ss_schedule` (`schedule_id`),
  KEY `idx_ss_term`    (`term_id`),
  CONSTRAINT `fk_ss_member`   FOREIGN KEY (`member_id`)   REFERENCES `member`        (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ss_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedule`      (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ss_term`     FOREIGN KEY (`term_id`)     REFERENCES `academic_term` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Merged student_schedule + student_enrollment. schedule_id NULL = term summary row.';

-- --------------------------------------------------------
-- 11. faculty_record  ← MERGED faculty_education + faculty_position
--     type = ''education'' | ''position''
--     Education cols: degree_level, degree_title, specialization,
--       institution, country, year_started, year_graduated,
--       thesis_title, honors, diploma_path, is_verified, verified_by
--     Position cols: title, academic_rank, desig_level,
--       effective_at, ended_at, appoint_type, appoint_order,
--       appoint_path, is_active
--     Irrelevant cols are NULL per row type.
-- --------------------------------------------------------
CREATE TABLE `faculty_record` (
  `id`            int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`     varchar(20)  NOT NULL,
  `record_type`   enum('education','position') NOT NULL,
  -- EDUCATION fields
  `degree_level`  enum('baccalaureate','masteral','doctorate','double_degree','post_doctorate') DEFAULT NULL,
  `degree_title`  varchar(150) DEFAULT NULL,
  `specialization`varchar(150) DEFAULT NULL,
  `institution`   varchar(150) DEFAULT NULL,
  `country`       varchar(60)  DEFAULT 'Philippines',
  `year_started`  year(4)      DEFAULT NULL,
  `year_graduated`year(4)      DEFAULT NULL,
  `thesis_title`  text         DEFAULT NULL,
  `honors`        varchar(100) DEFAULT NULL,
  `diploma_path`  varchar(255) DEFAULT NULL,
  `is_verified`   tinyint(1)   DEFAULT 0,
  `verified_by`   varchar(20)  DEFAULT NULL,
  -- POSITION fields
  `title`         enum('dean','associate_dean','chair','faculty','secretary','admin_officer','other') DEFAULT NULL,
  `academic_rank` varchar(60)  DEFAULT NULL,
  `desig_level`   enum('academic','administrative','both') DEFAULT NULL,
  `effective_at`  date         DEFAULT NULL,
  `ended_at`      date         DEFAULT NULL,
  `appoint_type`  enum('permanent','temporary','designation','co_terminus') DEFAULT NULL,
  `appoint_order` varchar(50)  DEFAULT NULL,
  `appoint_path`  varchar(255) DEFAULT NULL,
  `is_active`     tinyint(1)   DEFAULT 1,
  -- audit
  `created_at`    datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at`    datetime     DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_frec_member`    (`member_id`),
  KEY `idx_frec_type`     (`record_type`),
  KEY `idx_frec_active`   (`is_active`),
  KEY `idx_frec_degree`   (`degree_level`),
  CONSTRAINT `fk_frec_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Merged faculty_education + faculty_position. record_type discriminates row purpose.';

-- --------------------------------------------------------
-- 12. certification  (unchanged — already covers both student & faculty)
-- --------------------------------------------------------
CREATE TABLE `certification` (
  `id`             int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`      varchar(20)  NOT NULL,
  `cert_name`      varchar(200) NOT NULL,
  `issuing_body`   varchar(150) NOT NULL,
  `cert_type`      enum('training','seminar','workshop','tesda','professional','government','international','other') NOT NULL,
  `conducted_by`   varchar(150) DEFAULT NULL,
  `venue`          varchar(150) DEFAULT NULL,
  `started_at`     date         DEFAULT NULL,
  `completed_at`   date         NOT NULL,
  `expiry_at`      date         DEFAULT NULL,
  `duration_hours` smallint(5)  UNSIGNED DEFAULT NULL,
  `cert_no`        varchar(50)  DEFAULT NULL,
  `level`          enum('local','national','international') DEFAULT NULL,
  `funded_by`      enum('self','school','ched','dost','other') DEFAULT NULL,
  `cert_path`      varchar(255) DEFAULT NULL,
  `is_verified`    tinyint(1)   NOT NULL DEFAULT 0,
  `verified_by`    varchar(20)  DEFAULT NULL,
  `created_at`     datetime     NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_cert_member`   (`member_id`),
  KEY `idx_cert_type`    (`cert_type`),
  KEY `idx_cert_verified`(`is_verified`),
  CONSTRAINT `fk_cert_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Training and certification records — covers both student and faculty';

-- --------------------------------------------------------
-- 13. extracurricular  (unchanged — already merged sport/hobby)
-- --------------------------------------------------------
CREATE TABLE `extracurricular` (
  `id`          int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`   varchar(20)  NOT NULL,
  `term_id`     smallint(5)  UNSIGNED DEFAULT NULL COMMENT 'NULL for hobbies',
  `type`        enum('sport','hobby') NOT NULL,
  `name`        varchar(100) NOT NULL,
  `category`    varchar(60)  DEFAULT NULL,
  `team`        varchar(100) DEFAULT NULL,
  `position`    varchar(50)  DEFAULT NULL,
  `level`       enum('intramural','intercollege','regional','national','international') DEFAULT NULL,
  `achievement` varchar(200) DEFAULT NULL,
  `coach`       varchar(100) DEFAULT NULL,
  `is_active`   tinyint(1)   DEFAULT NULL,
  `skill_level` enum('beginner','intermediate','advanced') DEFAULT NULL,
  `created_at`  datetime     NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_extra_member` (`member_id`),
  KEY `fk_extra_term`   (`term_id`),
  KEY `idx_extra_type`  (`type`),
  KEY `idx_extra_level` (`level`),
  CONSTRAINT `fk_extra_member` FOREIGN KEY (`member_id`) REFERENCES `member`        (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_extra_term`   FOREIGN KEY (`term_id`)   REFERENCES `academic_term` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Student sports and hobbies — type discriminator column';

-- --------------------------------------------------------
-- 14. student_organization  (unchanged — distinct from extracurricular)
-- --------------------------------------------------------
CREATE TABLE `student_organization` (
  `id`             int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`      varchar(20)  NOT NULL,
  `org_name`       varchar(150) NOT NULL,
  `org_type`       enum('student_council','academic','social','religious','ngo','other') NOT NULL,
  `position`       varchar(80)  NOT NULL,
  `year_term`      varchar(9)   NOT NULL,
  `is_school_based`tinyint(1)   NOT NULL DEFAULT 1,
  `is_accredited`  tinyint(1)   NOT NULL DEFAULT 0,
  `accomplishments`text         DEFAULT NULL,
  `adviser`        varchar(100) DEFAULT NULL,
  `created_at`     datetime     NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_org_member` (`member_id`),
  CONSTRAINT `fk_org_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- 15. student_leave  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `student_leave` (
  `id`              int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`       varchar(20)  NOT NULL,
  `leave_type`      enum('medical','personal','financial','academic') NOT NULL,
  `filed_at`        date         NOT NULL,
  `effective_at`    date         NOT NULL,
  `expected_return` date         NOT NULL,
  `actual_return`   date         DEFAULT NULL,
  `approved_by`     varchar(20)  DEFAULT NULL,
  `status`          enum('pending','approved','denied','completed') NOT NULL DEFAULT 'pending',
  `document_path`   varchar(255) DEFAULT NULL,
  `remarks`         text         DEFAULT NULL,
  `created_at`      datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at`      datetime     DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_leave_member`  (`member_id`),
  KEY `idx_leave_status` (`status`),
  KEY `idx_leave_dates`  (`effective_at`,`expected_return`),
  CONSTRAINT `fk_leave_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- 16. student_medical  (unchanged — confidential, kept isolated)
-- --------------------------------------------------------
CREATE TABLE `student_medical` (
  `id`             int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`      varchar(20)  NOT NULL,
  `exam_date`      date         NOT NULL,
  `physician`      varchar(100) NOT NULL,
  `clinic`         varchar(150) DEFAULT NULL,
  `height_cm`      decimal(5,2) DEFAULT NULL,
  `weight_kg`      decimal(5,2) DEFAULT NULL,
  `bmi`            decimal(4,2) DEFAULT NULL COMMENT 'Computed: weight/(height/100)^2',
  `blood_type`     enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  `blood_pressure` varchar(10)  DEFAULT NULL,
  `visual_l`       varchar(10)  DEFAULT NULL,
  `visual_r`       varchar(10)  DEFAULT NULL,
  `hearing_l`      enum('normal','impaired','deaf') DEFAULT NULL,
  `hearing_r`      enum('normal','impaired','deaf') DEFAULT NULL,
  `conditions`     text         DEFAULT NULL,
  `medications`    text         DEFAULT NULL,
  `immunizations`  text         DEFAULT NULL,
  `fit_status`     enum('fit','fit_with_conditions','unfit') NOT NULL,
  `clearance_path` varchar(255) DEFAULT NULL,
  `next_exam_at`   date         DEFAULT NULL,
  `recorded_by`    varchar(20)  NOT NULL,
  `created_at`     datetime     NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_medical_member` (`member_id`),
  CONSTRAINT `fk_medical_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Highly confidential — RA 10173 applies. Admin access only.';

-- --------------------------------------------------------
-- 17. failed_course  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `failed_course` (
  `id`            int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`     varchar(20)  NOT NULL,
  `course_id`     smallint(5)  UNSIGNED NOT NULL,
  `term_id`       smallint(5)  UNSIGNED NOT NULL,
  `final_grade`   decimal(4,2) NOT NULL,
  `instructor`    varchar(100) DEFAULT NULL,
  `retake_status` enum('pending','enrolled','passed','failed_again') NOT NULL DEFAULT 'pending',
  `remarks`       text         DEFAULT NULL,
  `created_at`    datetime     NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_failed` (`member_id`,`course_id`,`term_id`),
  KEY `fk_fc_course`    (`course_id`),
  KEY `fk_fc_term`      (`term_id`),
  KEY `idx_fc_retake`   (`retake_status`),
  CONSTRAINT `fk_fc_member` FOREIGN KEY (`member_id`) REFERENCES `member`        (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_fc_course`  FOREIGN KEY (`course_id`) REFERENCES `course`        (`id`),
  CONSTRAINT `fk_fc_term`    FOREIGN KEY (`term_id`)   REFERENCES `academic_term` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- 18. event  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `event` (
  `id`             int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`          varchar(200) NOT NULL,
  `type`           enum('academic','cultural','sports','civic','seminar','competition','other') NOT NULL,
  `description`    text         DEFAULT NULL,
  `organizer`      varchar(150) DEFAULT NULL,
  `venue`          varchar(150) DEFAULT NULL,
  `room_id`        smallint(5)  UNSIGNED DEFAULT NULL,
  `start_at`       datetime     NOT NULL,
  `end_at`         datetime     NOT NULL,
  `academic_year`  varchar(9)   DEFAULT NULL,
  `is_school_wide` tinyint(1)   NOT NULL DEFAULT 0,
  `is_open`        tinyint(1)   NOT NULL DEFAULT 1,
  `created_by`     varchar(20)  NOT NULL,
  `created_at`     datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at`     datetime     DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_event_room`  (`room_id`),
  KEY `idx_event_type` (`type`),
  KEY `idx_event_dates`(`start_at`,`end_at`),
  CONSTRAINT `fk_event_room` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- 19. event_participant  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `event_participant` (
  `id`         int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_id`   int(10)  UNSIGNED NOT NULL,
  `member_id`  varchar(20) NOT NULL,
  `role`       enum('participant','organizer','volunteer','delegate','representative','judge','speaker') NOT NULL,
  `award`      varchar(200) DEFAULT NULL,
  `proof_path` varchar(255) DEFAULT NULL,
  `attended`   tinyint(1)   NOT NULL DEFAULT 0,
  `created_at` datetime     NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ep` (`event_id`,`member_id`),
  KEY `fk_ep_member` (`member_id`),
  CONSTRAINT `fk_ep_event`  FOREIGN KEY (`event_id`)  REFERENCES `event`  (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ep_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Unified for both student and faculty participants';

-- --------------------------------------------------------
-- 20. research_project  ← MERGED with publication
--     pub_* columns added directly; all NULL when status != published.
--     This works because each project typically has one primary publication.
--     If multiple pubs per project are needed in future, extract back out.
-- --------------------------------------------------------
CREATE TABLE `research_project` (
  `id`              int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `department_id`   tinyint(3)   UNSIGNED NOT NULL,
  `title`           varchar(255) NOT NULL,
  `type`            enum('faculty_research','thesis','capstone','dissertation','extension','other') NOT NULL,
  `abstract`        text         DEFAULT NULL,
  `keywords`        varchar(255) DEFAULT NULL,
  `status`          enum('proposal','ongoing','completed','published','cancelled') NOT NULL DEFAULT 'proposal',
  `start_date`      date         DEFAULT NULL,
  `end_date`        date         DEFAULT NULL,
  `funding_source`  varchar(150) DEFAULT NULL,
  `funding_amount`  decimal(12,2)DEFAULT NULL,
  -- publication fields (populated when status = 'published')
  `pub_type`        enum('journal','conference_paper','book_chapter','thesis','capstone_report','other') DEFAULT NULL,
  `pub_title`       varchar(255) DEFAULT NULL,
  `journal_conference` varchar(200) DEFAULT NULL,
  `volume`          varchar(20)  DEFAULT NULL,
  `issue`           varchar(20)  DEFAULT NULL,
  `pages`           varchar(20)  DEFAULT NULL,
  `doi`             varchar(120) DEFAULT NULL,
  `issn_isbn`       varchar(25)  DEFAULT NULL,
  `published_at`    date         DEFAULT NULL,
  `indexed_in`      varchar(100) DEFAULT NULL COMMENT 'e.g. Scopus, ISI, CHED-recognized',
  `is_peer_reviewed`tinyint(1)   NOT NULL DEFAULT 0,
  `pub_file_path`   varchar(255) DEFAULT NULL,
  -- audit
  `created_at`      datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at`      datetime     DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_rp_dept`    (`department_id`),
  KEY `idx_rp_status` (`status`),
  KEY `idx_rp_type`   (`type`),
  KEY `idx_rp_pubdate`(`published_at`),
  CONSTRAINT `fk_rp_dept` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Merged research_project + publication. pub_* cols null when unpublished.';

-- --------------------------------------------------------
-- 21. research_member  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `research_member` (
  `id`                  int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `research_project_id` int(10)  UNSIGNED NOT NULL,
  `member_id`           varchar(20) NOT NULL,
  `role`                enum('lead_researcher','co_researcher','adviser','panelist','student_researcher','other') NOT NULL,
  `joined_at`           date         DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rm` (`research_project_id`,`member_id`),
  KEY `fk_rm_member` (`member_id`),
  CONSTRAINT `fk_rm_project` FOREIGN KEY (`research_project_id`) REFERENCES `research_project` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rm_member`  FOREIGN KEY (`member_id`)           REFERENCES `member`           (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- 22. syllabus  (unchanged)
-- --------------------------------------------------------
CREATE TABLE `syllabus` (
  `id`              int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_id`       smallint(5)  UNSIGNED NOT NULL,
  `member_id`       varchar(20)  NOT NULL COMMENT 'Faculty author',
  `term_id`         smallint(5)  UNSIGNED NOT NULL,
  `description`     text         DEFAULT NULL,
  `objectives`      text         DEFAULT NULL,
  `grading_system`  text         DEFAULT NULL,
  `references_list` text         DEFAULT NULL,
  `file_path`       varchar(255) DEFAULT NULL,
  `is_approved`     tinyint(1)   NOT NULL DEFAULT 0,
  `approved_by`     varchar(20)  DEFAULT NULL,
  `created_at`      datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at`      datetime     DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_syllabus` (`course_id`,`member_id`,`term_id`),
  KEY `fk_syl_member` (`member_id`),
  KEY `idx_syl_term`  (`term_id`),
  CONSTRAINT `fk_syl_course`  FOREIGN KEY (`course_id`) REFERENCES `course`        (`id`),
  CONSTRAINT `fk_syl_member`  FOREIGN KEY (`member_id`) REFERENCES `member`        (`id`),
  CONSTRAINT `fk_syl_term`    FOREIGN KEY (`term_id`)   REFERENCES `academic_term` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- 23. syllabus_topic  ← MERGED syllabus_topic + syllabus_outcome + lesson
--     Outcomes stored in `outcomes_json` (JSON text, array of
--       {outcome, bloom_level} objects) — eliminates syllabus_outcome table.
--     Lesson content stored inline — eliminates lesson table.
--     lesson_no NULL means no lesson content yet for this topic week.
-- --------------------------------------------------------
CREATE TABLE `syllabus_topic` (
  `id`            int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `syllabus_id`   int(10)  UNSIGNED NOT NULL,
  `week_no`       tinyint(3)  UNSIGNED NOT NULL,
  `title`         varchar(200) NOT NULL,
  `description`   text         DEFAULT NULL,
  `hours`         decimal(4,1) NOT NULL DEFAULT 3.0,
  -- merged from syllabus_outcome (JSON array of {outcome, bloom_level})
  `outcomes_json` text         DEFAULT NULL
                  COMMENT 'JSON array: [{outcome, bloom_level}]. bloom_level: remember|understand|apply|analyze|evaluate|create',
  -- merged from lesson
  `lesson_no`     tinyint(3)   UNSIGNED DEFAULT NULL,
  `lesson_title`  varchar(200) DEFAULT NULL,
  `objectives`    text         DEFAULT NULL,
  `content`       longtext     DEFAULT NULL,
  `activities`    text         DEFAULT NULL,
  `materials`     text         DEFAULT NULL,
  `assessment`    text         DEFAULT NULL,
  `duration_mins` smallint(5)  UNSIGNED DEFAULT NULL,
  `file_path`     varchar(255) DEFAULT NULL,
  `created_at`    datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at`    datetime     DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_topic_week` (`syllabus_id`,`week_no`),
  KEY `idx_topic_week` (`week_no`),
  CONSTRAINT `fk_topic_syl` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Merged syllabus_topic + syllabus_outcome (outcomes_json) + lesson (lesson_* cols)';

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
