-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 02, 2026 at 04:45 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ccs`
--

-- --------------------------------------------------------

--
-- Table structure for table `academic_term`
--

CREATE TABLE `academic_term` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `academic_year` varchar(9) NOT NULL COMMENT 'e.g. 2024-2025',
  `semester` enum('1st','2nd','Summer') NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Single source of truth for all semester references';

--
-- Dumping data for table `academic_term`
--

INSERT INTO `academic_term` (`id`, `academic_year`, `semester`, `start_date`, `end_date`, `is_current`) VALUES
(1, '2023-2024', '1st', '2023-08-14', '2023-12-15', 0),
(2, '2023-2024', '2nd', '2024-01-08', '2024-05-10', 0),
(3, '2024-2025', '1st', '2024-08-12', '2024-12-13', 0),
(4, '2024-2025', '2nd', '2025-01-06', '2025-05-09', 1),
(5, '2024-2025', 'Summer', '2025-05-26', '2025-07-04', 0);

-- --------------------------------------------------------

--
-- Table structure for table `certification`
--

CREATE TABLE `certification` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `cert_name` varchar(200) NOT NULL,
  `issuing_body` varchar(150) NOT NULL,
  `cert_type` enum('training','seminar','workshop','tesda','professional','government','international','other') NOT NULL,
  `conducted_by` varchar(150) DEFAULT NULL,
  `venue` varchar(150) DEFAULT NULL,
  `started_at` date DEFAULT NULL,
  `completed_at` date NOT NULL,
  `expiry_at` date DEFAULT NULL,
  `duration_hours` smallint(5) UNSIGNED DEFAULT NULL,
  `cert_no` varchar(50) DEFAULT NULL,
  `level` enum('local','national','international') DEFAULT NULL,
  `funded_by` enum('self','school','ched','dost','other') DEFAULT NULL,
  `cert_path` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_by` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Training and certification records — covers both student and faculty';

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `code` varchar(15) NOT NULL COMMENT 'e.g. CS 101',
  `title` varchar(150) NOT NULL,
  `units` tinyint(3) UNSIGNED NOT NULL,
  `lab_units` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master course list — shared by schedule, syllabus, curriculum';

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`id`, `code`, `title`, `units`, `lab_units`, `description`, `is_active`) VALUES
(1, 'CS 101', 'Introduction to Computing', 3, 0, NULL, 1),
(2, 'CS 102', 'Computer Programming 1', 3, 0, NULL, 1),
(3, 'CS 201', 'Data Structures and Algorithms', 3, 0, NULL, 1),
(4, 'CS 301', 'Operating Systems', 3, 0, NULL, 1),
(5, 'CS 302', 'Database Management Systems', 3, 0, NULL, 1),
(6, 'CS 401', 'Software Engineering', 3, 0, NULL, 1),
(7, 'IT 101', 'Introduction to Information Technology', 3, 0, NULL, 1),
(8, 'IT 201', 'Web Systems and Technologies', 3, 0, NULL, 1),
(9, 'IT 301', 'Systems Integration and Architecture', 3, 0, NULL, 1),
(10, 'GE 001', 'Understanding the Self', 3, 0, NULL, 1),
(11, 'GE 002', 'Purposive Communication', 3, 0, NULL, 1),
(12, 'GE 003', 'Mathematics in the Modern World', 3, 0, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `curriculum`
--

CREATE TABLE `curriculum` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `program_id` smallint(5) UNSIGNED NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'e.g. BSCS-2022',
  `effectivity_ay` varchar(9) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `approved_by` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `curriculum_course`
--

CREATE TABLE `curriculum_course` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `curriculum_id` smallint(5) UNSIGNED NOT NULL,
  `course_id` smallint(5) UNSIGNED NOT NULL,
  `year_level` tinyint(3) UNSIGNED NOT NULL,
  `semester` enum('1st','2nd','Summer') NOT NULL,
  `is_elective` tinyint(1) NOT NULL DEFAULT 0,
  `prerequisite_id` smallint(5) UNSIGNED DEFAULT NULL COMMENT 'FK to course.id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `code` varchar(10) NOT NULL COMMENT 'e.g. CCS, CAS',
  `name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`id`, `code`, `name`, `is_active`) VALUES
(1, 'CCS', 'College of Computer Studies', 1),
(2, 'CAS', 'College of Arts and Sciences', 1),
(3, 'CEA', 'College of Engineering and Architecture', 1);

-- --------------------------------------------------------

--
-- Table structure for table `event`
--

CREATE TABLE `event` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `type` enum('academic','cultural','sports','civic','seminar','competition','other') NOT NULL,
  `description` text DEFAULT NULL,
  `organizer` varchar(150) DEFAULT NULL,
  `venue` varchar(150) DEFAULT NULL,
  `room_id` smallint(5) UNSIGNED DEFAULT NULL COMMENT 'Set if held in a tracked room',
  `start_at` datetime NOT NULL,
  `end_at` datetime NOT NULL,
  `academic_year` varchar(9) DEFAULT NULL,
  `is_school_wide` tinyint(1) NOT NULL DEFAULT 0,
  `is_open` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` varchar(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `event_participant`
--

CREATE TABLE `event_participant` (
  `id` int(10) UNSIGNED NOT NULL,
  `event_id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `role` enum('participant','organizer','volunteer','delegate','representative','judge','speaker') NOT NULL,
  `award` varchar(200) DEFAULT NULL,
  `proof_path` varchar(255) DEFAULT NULL,
  `attended` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Unified for both student and faculty participants — no dual-FK needed';

-- --------------------------------------------------------

--
-- Table structure for table `extracurricular`
--

CREATE TABLE `extracurricular` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `term_id` smallint(5) UNSIGNED DEFAULT NULL COMMENT 'NULL for hobbies',
  `type` enum('sport','hobby') NOT NULL,
  `name` varchar(100) NOT NULL,
  `category` varchar(60) DEFAULT NULL COMMENT 'sport category or hobby category',
  `team` varchar(100) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `level` enum('intramural','intercollege','regional','national','international') DEFAULT NULL,
  `achievement` varchar(200) DEFAULT NULL,
  `coach` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `skill_level` enum('beginner','intermediate','advanced') DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Student sports and hobbies — type discriminator column';

-- --------------------------------------------------------

--
-- Table structure for table `faculty_education`
--

CREATE TABLE `faculty_education` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `degree_level` enum('baccalaureate','masteral','doctorate','double_degree','post_doctorate') NOT NULL,
  `degree_title` varchar(150) NOT NULL,
  `specialization` varchar(150) NOT NULL,
  `institution` varchar(150) NOT NULL,
  `country` varchar(60) NOT NULL DEFAULT 'Philippines',
  `year_started` year(4) NOT NULL,
  `year_graduated` year(4) DEFAULT NULL,
  `thesis_title` text DEFAULT NULL,
  `honors` varchar(100) DEFAULT NULL,
  `diploma_path` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_by` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faculty_position`
--

CREATE TABLE `faculty_position` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `title` enum('dean','associate_dean','chair','faculty','secretary','admin_officer','other') NOT NULL,
  `academic_rank` varchar(60) DEFAULT NULL,
  `desig_level` enum('academic','administrative','both') DEFAULT NULL,
  `effective_at` date NOT NULL,
  `ended_at` date DEFAULT NULL,
  `appoint_type` enum('permanent','temporary','designation','co_terminus') NOT NULL,
  `appoint_order` varchar(50) DEFAULT NULL,
  `appoint_path` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_course`
--

CREATE TABLE `failed_course` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `course_id` smallint(5) UNSIGNED NOT NULL,
  `term_id` smallint(5) UNSIGNED NOT NULL,
  `final_grade` decimal(4,2) NOT NULL,
  `instructor` varchar(100) DEFAULT NULL,
  `retake_status` enum('pending','enrolled','passed','failed_again') NOT NULL DEFAULT 'pending',
  `remarks` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lesson`
--

CREATE TABLE `lesson` (
  `id` int(10) UNSIGNED NOT NULL,
  `topic_id` int(10) UNSIGNED NOT NULL,
  `lesson_no` tinyint(3) UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `objectives` text DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `activities` text DEFAULT NULL,
  `materials` text DEFAULT NULL,
  `assessment` text DEFAULT NULL,
  `duration_mins` smallint(5) UNSIGNED DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `id` varchar(20) NOT NULL COMMENT 'Natural key: 2024-CCS-0001 (student) | FAC-2024-001 (faculty) | ADMIN-001',
  `role` enum('student','faculty','admin') NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `birth_date` date NOT NULL,
  `sex` enum('M','F','O') NOT NULL COMMENT 'M=Male F=Female O=Other',
  `civil_status` enum('S','M','W','P') NOT NULL COMMENT 'S=Single M=Married W=Widowed P=Separated',
  `nationality` varchar(40) NOT NULL DEFAULT 'Filipino',
  `religion` varchar(40) DEFAULT NULL,
  `contact_no` varchar(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `address_home` text NOT NULL,
  `address_current` text DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login_at` datetime DEFAULT NULL,
  `program_id` smallint(5) UNSIGNED DEFAULT NULL,
  `year_level` tinyint(3) UNSIGNED DEFAULT NULL COMMENT '1-4; 0=Irregular',
  `section` varchar(10) DEFAULT NULL,
  `student_status` enum('active','inactive','loa','dropped','graduated') DEFAULT NULL,
  `scholarship` varchar(80) DEFAULT NULL,
  `enrolled_at` date DEFAULT NULL,
  `emergency_name` varchar(100) DEFAULT NULL,
  `emergency_rel` varchar(40) DEFAULT NULL,
  `emergency_no` varchar(15) DEFAULT NULL,
  `department_id` tinyint(3) UNSIGNED DEFAULT NULL,
  `employee_no` varchar(15) DEFAULT NULL,
  `employment_type` enum('full_time','part_time','contractual') DEFAULT NULL,
  `is_full_time` tinyint(1) DEFAULT NULL,
  `hired_at` date DEFAULT NULL,
  `salary_grade` varchar(10) DEFAULT NULL,
  `sss_no` varchar(20) DEFAULT NULL,
  `tin` varchar(15) DEFAULT NULL,
  `gsis_no` varchar(20) DEFAULT NULL,
  `created_by` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`id`, `role`, `last_name`, `first_name`, `middle_name`, `suffix`, `birth_date`, `sex`, `civil_status`, `nationality`, `religion`, `contact_no`, `email`, `address_home`, `address_current`, `photo_path`, `username`, `password_hash`, `is_active`, `last_login_at`, `program_id`, `year_level`, `section`, `student_status`, `scholarship`, `enrolled_at`, `emergency_name`, `emergency_rel`, `emergency_no`, `department_id`, `employee_no`, `employment_type`, `is_full_time`, `hired_at`, `salary_grade`, `sss_no`, `tin`, `gsis_no`, `created_by`, `created_at`, `updated_at`) VALUES
('ADMIN-001', 'admin', 'Administrator', 'System', NULL, NULL, '1990-01-01', 'M', 'S', 'Filipino', NULL, '09000000000', 'admin@ccs.edu.ph', 'CCS Building', NULL, NULL, 'ccs_admin', 'REPLACE_WITH_BCRYPT_HASH', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-02 11:44:18', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `program`
--

CREATE TABLE `program` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `department_id` tinyint(3) UNSIGNED NOT NULL,
  `code` varchar(15) NOT NULL COMMENT 'e.g. BSCS',
  `title` varchar(120) NOT NULL,
  `total_units` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `program`
--

INSERT INTO `program` (`id`, `department_id`, `code`, `title`, `total_units`, `is_active`) VALUES
(1, 1, 'BSCS', 'Bachelor of Science in Computer Science', 165, 1),
(2, 1, 'BSIT', 'Bachelor of Science in Information Technology', 162, 1),
(3, 1, 'BSIS', 'Bachelor of Science in Information Systems', 162, 1),
(4, 1, 'BSEMC', 'BS Entertainment and Multimedia Computing', 163, 1);

-- --------------------------------------------------------

--
-- Table structure for table `publication`
--

CREATE TABLE `publication` (
  `id` int(10) UNSIGNED NOT NULL,
  `research_project_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `pub_type` enum('journal','conference_paper','book_chapter','thesis','capstone_report','other') NOT NULL,
  `journal_conference` varchar(200) DEFAULT NULL,
  `volume` varchar(20) DEFAULT NULL,
  `issue` varchar(20) DEFAULT NULL,
  `pages` varchar(20) DEFAULT NULL,
  `doi` varchar(120) DEFAULT NULL,
  `issn_isbn` varchar(25) DEFAULT NULL,
  `published_at` date DEFAULT NULL,
  `indexed_in` varchar(100) DEFAULT NULL COMMENT 'e.g. Scopus, ISI, CHED-recognized',
  `is_peer_reviewed` tinyint(1) NOT NULL DEFAULT 0,
  `file_path` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `research_member`
--

CREATE TABLE `research_member` (
  `id` int(10) UNSIGNED NOT NULL,
  `research_project_id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `role` enum('lead_researcher','co_researcher','adviser','panelist','student_researcher','other') NOT NULL,
  `joined_at` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `research_project`
--

CREATE TABLE `research_project` (
  `id` int(10) UNSIGNED NOT NULL,
  `department_id` tinyint(3) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `type` enum('faculty_research','thesis','capstone','dissertation','extension','other') NOT NULL,
  `abstract` text DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `status` enum('proposal','ongoing','completed','published','cancelled') NOT NULL DEFAULT 'proposal',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `funding_source` varchar(150) DEFAULT NULL,
  `funding_amount` decimal(12,2) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'e.g. CCS-LAB1',
  `name` varchar(100) NOT NULL,
  `type` enum('lecture','laboratory','conference','auditorium','other') NOT NULL,
  `capacity` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `building` varchar(60) DEFAULT NULL,
  `floor_no` tinyint(4) DEFAULT NULL,
  `has_projector` tinyint(1) NOT NULL DEFAULT 0,
  `has_ac` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Rooms used by both scheduling and events';

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`id`, `code`, `name`, `type`, `capacity`, `building`, `floor_no`, `has_projector`, `has_ac`, `is_active`) VALUES
(1, 'CCS-LEC1', 'CCS Lecture Room 1', 'lecture', 40, 'CCS Building', 1, 1, 1, 1),
(2, 'CCS-LEC2', 'CCS Lecture Room 2', 'lecture', 40, 'CCS Building', 1, 1, 1, 1),
(3, 'CCS-LAB1', 'CCS Computer Lab 1', 'laboratory', 35, 'CCS Building', 2, 1, 1, 1),
(4, 'CCS-LAB2', 'CCS Computer Lab 2', 'laboratory', 35, 'CCS Building', 2, 1, 1, 1),
(5, 'CCS-CONF', 'CCS Conference Room', 'conference', 20, 'CCS Building', 3, 1, 1, 1),
(6, 'MAIN-AUD', 'Main Auditorium', 'auditorium', 500, 'Main Building', 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `schedule`
--

CREATE TABLE `schedule` (
  `id` int(10) UNSIGNED NOT NULL,
  `term_id` smallint(5) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL COMMENT 'Faculty teaching this slot',
  `course_id` smallint(5) UNSIGNED NOT NULL,
  `room_id` smallint(5) UNSIGNED NOT NULL,
  `section` varchar(10) NOT NULL,
  `day_pattern` varchar(10) NOT NULL COMMENT 'e.g. MWF, TTh, Sat',
  `time_start` time NOT NULL,
  `time_end` time NOT NULL,
  `class_size` smallint(5) UNSIGNED DEFAULT NULL,
  `exam_type` enum('midterm','final','quiz','special') DEFAULT NULL,
  `exam_date` date DEFAULT NULL,
  `exam_notes` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Master schedule for classes AND exams. exam_type NULL = regular class.';

-- --------------------------------------------------------

--
-- Table structure for table `student_enrollment`
--

CREATE TABLE `student_enrollment` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `term_id` smallint(5) UNSIGNED NOT NULL,
  `is_regular` tinyint(1) NOT NULL DEFAULT 1,
  `units_enrolled` tinyint(3) UNSIGNED NOT NULL,
  `units_standard` tinyint(3) UNSIGNED DEFAULT NULL,
  `irreg_reason` text DEFAULT NULL,
  `assessed_by` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Regular/irregular status per student per term';

-- --------------------------------------------------------

--
-- Table structure for table `student_leave`
--

CREATE TABLE `student_leave` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `leave_type` enum('medical','personal','financial','academic') NOT NULL,
  `filed_at` date NOT NULL,
  `effective_at` date NOT NULL,
  `expected_return` date NOT NULL,
  `actual_return` date DEFAULT NULL,
  `approved_by` varchar(20) DEFAULT NULL,
  `status` enum('pending','approved','denied','completed') NOT NULL DEFAULT 'pending',
  `document_path` varchar(255) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_medical`
--

CREATE TABLE `student_medical` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `exam_date` date NOT NULL,
  `physician` varchar(100) NOT NULL,
  `clinic` varchar(150) DEFAULT NULL,
  `height_cm` decimal(5,2) DEFAULT NULL,
  `weight_kg` decimal(5,2) DEFAULT NULL,
  `bmi` decimal(4,2) DEFAULT NULL COMMENT 'Computed: weight/(height/100)^2',
  `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  `blood_pressure` varchar(10) DEFAULT NULL,
  `visual_l` varchar(10) DEFAULT NULL,
  `visual_r` varchar(10) DEFAULT NULL,
  `hearing_l` enum('normal','impaired','deaf') DEFAULT NULL,
  `hearing_r` enum('normal','impaired','deaf') DEFAULT NULL,
  `conditions` text DEFAULT NULL,
  `medications` text DEFAULT NULL,
  `immunizations` text DEFAULT NULL,
  `fit_status` enum('fit','fit_with_conditions','unfit') NOT NULL,
  `clearance_path` varchar(255) DEFAULT NULL,
  `next_exam_at` date DEFAULT NULL,
  `recorded_by` varchar(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Highly confidential — RA 10173 applies. Admin access only.';

-- --------------------------------------------------------

--
-- Table structure for table `student_organization`
--

CREATE TABLE `student_organization` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `org_name` varchar(150) NOT NULL,
  `org_type` enum('student_council','academic','social','religious','ngo','other') NOT NULL,
  `position` varchar(80) NOT NULL,
  `year_term` varchar(9) NOT NULL COMMENT 'e.g. 2024-2025',
  `is_school_based` tinyint(1) NOT NULL DEFAULT 1,
  `is_accredited` tinyint(1) NOT NULL DEFAULT 0,
  `accomplishments` text DEFAULT NULL,
  `adviser` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Organization membership — too structurally distinct from sport/hobby to merge';

-- --------------------------------------------------------

--
-- Table structure for table `student_schedule`
--

CREATE TABLE `student_schedule` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL COMMENT 'Student',
  `schedule_id` int(10) UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `syllabus`
--

CREATE TABLE `syllabus` (
  `id` int(10) UNSIGNED NOT NULL,
  `course_id` smallint(5) UNSIGNED NOT NULL,
  `member_id` varchar(20) NOT NULL COMMENT 'Faculty author',
  `term_id` smallint(5) UNSIGNED NOT NULL,
  `description` text DEFAULT NULL,
  `objectives` text DEFAULT NULL,
  `grading_system` text DEFAULT NULL COMMENT 'Breakdown e.g. Exams 40%, Projects 30%',
  `references_list` text DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `is_approved` tinyint(1) NOT NULL DEFAULT 0,
  `approved_by` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `syllabus_outcome`
--

CREATE TABLE `syllabus_outcome` (
  `id` int(10) UNSIGNED NOT NULL,
  `topic_id` int(10) UNSIGNED NOT NULL,
  `outcome` varchar(255) NOT NULL,
  `bloom_level` enum('remember','understand','apply','analyze','evaluate','create') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `syllabus_topic`
--

CREATE TABLE `syllabus_topic` (
  `id` int(10) UNSIGNED NOT NULL,
  `syllabus_id` int(10) UNSIGNED NOT NULL,
  `week_no` tinyint(3) UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `hours` decimal(4,1) NOT NULL DEFAULT 3.0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academic_term`
--
ALTER TABLE `academic_term`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_term` (`academic_year`,`semester`);

--
-- Indexes for table `certification`
--
ALTER TABLE `certification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cert_member` (`member_id`),
  ADD KEY `idx_cert_type` (`cert_type`),
  ADD KEY `idx_cert_verified` (`is_verified`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_course_code` (`code`);

--
-- Indexes for table `curriculum`
--
ALTER TABLE `curriculum`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_curriculum` (`program_id`,`code`),
  ADD KEY `idx_curr_active` (`is_active`);

--
-- Indexes for table `curriculum_course`
--
ALTER TABLE `curriculum_course`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cc` (`curriculum_id`,`course_id`),
  ADD KEY `fk_cc_course` (`course_id`),
  ADD KEY `fk_cc_prereq` (`prerequisite_id`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_dept_code` (`code`);

--
-- Indexes for table `event`
--
ALTER TABLE `event`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_event_room` (`room_id`),
  ADD KEY `idx_event_type` (`type`),
  ADD KEY `idx_event_dates` (`start_at`,`end_at`);

--
-- Indexes for table `event_participant`
--
ALTER TABLE `event_participant`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ep` (`event_id`,`member_id`),
  ADD KEY `fk_ep_member` (`member_id`);

--
-- Indexes for table `extracurricular`
--
ALTER TABLE `extracurricular`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_extra_member` (`member_id`),
  ADD KEY `fk_extra_term` (`term_id`),
  ADD KEY `idx_extra_type` (`type`),
  ADD KEY `idx_extra_level` (`level`);

--
-- Indexes for table `faculty_education`
--
ALTER TABLE `faculty_education`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_edu_member` (`member_id`),
  ADD KEY `idx_edu_degree` (`degree_level`);

--
-- Indexes for table `faculty_position`
--
ALTER TABLE `faculty_position`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pos_member` (`member_id`),
  ADD KEY `idx_pos_active` (`is_active`);

--
-- Indexes for table `failed_course`
--
ALTER TABLE `failed_course`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_failed` (`member_id`,`course_id`,`term_id`),
  ADD KEY `fk_fc_course` (`course_id`),
  ADD KEY `fk_fc_term` (`term_id`),
  ADD KEY `idx_fc_retake` (`retake_status`);

--
-- Indexes for table `lesson`
--
ALTER TABLE `lesson`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_lesson` (`topic_id`,`lesson_no`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_member_email` (`email`),
  ADD UNIQUE KEY `uq_member_username` (`username`),
  ADD UNIQUE KEY `uq_member_emp_no` (`employee_no`),
  ADD KEY `fk_member_program` (`program_id`),
  ADD KEY `fk_member_dept` (`department_id`),
  ADD KEY `idx_member_role` (`role`),
  ADD KEY `idx_member_status` (`student_status`),
  ADD KEY `idx_member_year` (`year_level`);

--
-- Indexes for table `program`
--
ALTER TABLE `program`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_program_code` (`code`),
  ADD KEY `fk_prog_dept` (`department_id`);

--
-- Indexes for table `publication`
--
ALTER TABLE `publication`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pub_project` (`research_project_id`),
  ADD KEY `idx_pub_date` (`published_at`);

--
-- Indexes for table `research_member`
--
ALTER TABLE `research_member`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_rm` (`research_project_id`,`member_id`),
  ADD KEY `fk_rm_member` (`member_id`);

--
-- Indexes for table `research_project`
--
ALTER TABLE `research_project`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rp_dept` (`department_id`),
  ADD KEY `idx_rp_status` (`status`),
  ADD KEY `idx_rp_type` (`type`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_room_code` (`code`);

--
-- Indexes for table `schedule`
--
ALTER TABLE `schedule`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_room_slot` (`term_id`,`room_id`,`day_pattern`,`time_start`,`exam_date`),
  ADD UNIQUE KEY `uq_faculty_slot` (`term_id`,`member_id`,`day_pattern`,`time_start`,`exam_date`),
  ADD KEY `fk_sched_faculty` (`member_id`),
  ADD KEY `fk_sched_course` (`course_id`),
  ADD KEY `fk_sched_room` (`room_id`),
  ADD KEY `idx_sched_term` (`term_id`),
  ADD KEY `idx_sched_section` (`section`),
  ADD KEY `idx_sched_exam` (`exam_type`,`exam_date`);

--
-- Indexes for table `student_enrollment`
--
ALTER TABLE `student_enrollment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_enrollment` (`member_id`,`term_id`),
  ADD KEY `idx_enroll_term` (`term_id`);

--
-- Indexes for table `student_leave`
--
ALTER TABLE `student_leave`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_leave_member` (`member_id`),
  ADD KEY `idx_leave_status` (`status`),
  ADD KEY `idx_leave_dates` (`effective_at`,`expected_return`);

--
-- Indexes for table `student_medical`
--
ALTER TABLE `student_medical`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_medical_member` (`member_id`);

--
-- Indexes for table `student_organization`
--
ALTER TABLE `student_organization`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_org_member` (`member_id`);

--
-- Indexes for table `student_schedule`
--
ALTER TABLE `student_schedule`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_student_sched` (`member_id`,`schedule_id`),
  ADD KEY `fk_ss_schedule` (`schedule_id`);

--
-- Indexes for table `syllabus`
--
ALTER TABLE `syllabus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_syllabus` (`course_id`,`member_id`,`term_id`),
  ADD KEY `fk_syl_member` (`member_id`),
  ADD KEY `idx_syl_term` (`term_id`);

--
-- Indexes for table `syllabus_outcome`
--
ALTER TABLE `syllabus_outcome`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_outcome_topic` (`topic_id`);

--
-- Indexes for table `syllabus_topic`
--
ALTER TABLE `syllabus_topic`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_topic_week` (`syllabus_id`,`week_no`),
  ADD KEY `idx_topic_week` (`week_no`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academic_term`
--
ALTER TABLE `academic_term`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `certification`
--
ALTER TABLE `certification`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `curriculum`
--
ALTER TABLE `curriculum`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `curriculum_course`
--
ALTER TABLE `curriculum_course`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `event`
--
ALTER TABLE `event`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event_participant`
--
ALTER TABLE `event_participant`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `extracurricular`
--
ALTER TABLE `extracurricular`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faculty_education`
--
ALTER TABLE `faculty_education`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faculty_position`
--
ALTER TABLE `faculty_position`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_course`
--
ALTER TABLE `failed_course`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lesson`
--
ALTER TABLE `lesson`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `program`
--
ALTER TABLE `program`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `publication`
--
ALTER TABLE `publication`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `research_member`
--
ALTER TABLE `research_member`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `research_project`
--
ALTER TABLE `research_project`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `schedule`
--
ALTER TABLE `schedule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_enrollment`
--
ALTER TABLE `student_enrollment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_leave`
--
ALTER TABLE `student_leave`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_medical`
--
ALTER TABLE `student_medical`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_organization`
--
ALTER TABLE `student_organization`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_schedule`
--
ALTER TABLE `student_schedule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `syllabus`
--
ALTER TABLE `syllabus`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `syllabus_outcome`
--
ALTER TABLE `syllabus_outcome`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `syllabus_topic`
--
ALTER TABLE `syllabus_topic`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `certification`
--
ALTER TABLE `certification`
  ADD CONSTRAINT `fk_cert_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `curriculum`
--
ALTER TABLE `curriculum`
  ADD CONSTRAINT `fk_curr_program` FOREIGN KEY (`program_id`) REFERENCES `program` (`id`);

--
-- Constraints for table `curriculum_course`
--
ALTER TABLE `curriculum_course`
  ADD CONSTRAINT `fk_cc_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  ADD CONSTRAINT `fk_cc_curriculum` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cc_prereq` FOREIGN KEY (`prerequisite_id`) REFERENCES `course` (`id`);

--
-- Constraints for table `event`
--
ALTER TABLE `event`
  ADD CONSTRAINT `fk_event_room` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`);

--
-- Constraints for table `event_participant`
--
ALTER TABLE `event_participant`
  ADD CONSTRAINT `fk_ep_event` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ep_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `extracurricular`
--
ALTER TABLE `extracurricular`
  ADD CONSTRAINT `fk_extra_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_extra_term` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`id`);

--
-- Constraints for table `faculty_education`
--
ALTER TABLE `faculty_education`
  ADD CONSTRAINT `fk_edu_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `faculty_position`
--
ALTER TABLE `faculty_position`
  ADD CONSTRAINT `fk_pos_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `failed_course`
--
ALTER TABLE `failed_course`
  ADD CONSTRAINT `fk_fc_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  ADD CONSTRAINT `fk_fc_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_fc_term` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`id`);

--
-- Constraints for table `lesson`
--
ALTER TABLE `lesson`
  ADD CONSTRAINT `fk_lesson_topic` FOREIGN KEY (`topic_id`) REFERENCES `syllabus_topic` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `member`
--
ALTER TABLE `member`
  ADD CONSTRAINT `fk_member_dept` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`),
  ADD CONSTRAINT `fk_member_program` FOREIGN KEY (`program_id`) REFERENCES `program` (`id`);

--
-- Constraints for table `program`
--
ALTER TABLE `program`
  ADD CONSTRAINT `fk_prog_dept` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`);

--
-- Constraints for table `publication`
--
ALTER TABLE `publication`
  ADD CONSTRAINT `fk_pub_project` FOREIGN KEY (`research_project_id`) REFERENCES `research_project` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `research_member`
--
ALTER TABLE `research_member`
  ADD CONSTRAINT `fk_rm_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rm_project` FOREIGN KEY (`research_project_id`) REFERENCES `research_project` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `research_project`
--
ALTER TABLE `research_project`
  ADD CONSTRAINT `fk_rp_dept` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`);

--
-- Constraints for table `schedule`
--
ALTER TABLE `schedule`
  ADD CONSTRAINT `fk_sched_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  ADD CONSTRAINT `fk_sched_faculty` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  ADD CONSTRAINT `fk_sched_room` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`),
  ADD CONSTRAINT `fk_sched_term` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`id`);

--
-- Constraints for table `student_enrollment`
--
ALTER TABLE `student_enrollment`
  ADD CONSTRAINT `fk_enroll_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_enroll_term` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`id`);

--
-- Constraints for table `student_leave`
--
ALTER TABLE `student_leave`
  ADD CONSTRAINT `fk_leave_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_medical`
--
ALTER TABLE `student_medical`
  ADD CONSTRAINT `fk_medical_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_organization`
--
ALTER TABLE `student_organization`
  ADD CONSTRAINT `fk_org_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_schedule`
--
ALTER TABLE `student_schedule`
  ADD CONSTRAINT `fk_ss_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ss_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `syllabus`
--
ALTER TABLE `syllabus`
  ADD CONSTRAINT `fk_syl_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  ADD CONSTRAINT `fk_syl_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  ADD CONSTRAINT `fk_syl_term` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`id`);

--
-- Constraints for table `syllabus_outcome`
--
ALTER TABLE `syllabus_outcome`
  ADD CONSTRAINT `fk_outcome_topic` FOREIGN KEY (`topic_id`) REFERENCES `syllabus_topic` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `syllabus_topic`
--
ALTER TABLE `syllabus_topic`
  ADD CONSTRAINT `fk_topic_syl` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabus` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
