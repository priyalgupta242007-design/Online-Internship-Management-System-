# MySQL Database Setup Guide for InternPortal

This guide walks you through setting up and verifying the MySQL relational database for **InternPortal – Online Internship Management System**.

---

## 1. Prerequisites
- MySQL Community Server 8.0 or higher (or MariaDB 10.5+)
- MySQL Workbench, phpMyAdmin, or MySQL Command-Line Client

---

## 2. Database Creation & Execution

Open your MySQL terminal or client and run:

```sql
CREATE DATABASE IF NOT EXISTS internportal_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE internportal_db;
```

Next, execute the schema definitions:
- File location: [`backend/src/main/resources/schema.sql`](file:///backend/src/main/resources/schema.sql)

Finally, load the realistic seed data:
- File location: [`backend/src/main/resources/data.sql`](file:///backend/src/main/resources/data.sql)

---

## 3. Tables Created

| Table Name | Description | Key Relationships |
|------------|-------------|-------------------|
| `users` | Core credentials, roles (STUDENT, RECRUITER, ADMIN), active status | Primary Auth table |
| `student_profiles` | Academic background, CGPA, verified skills, PDF resume path, completeness score | FK to `users.id` |
| `recruiter_profiles` | Company information, website, logo, verification status | FK to `users.id` |
| `internships` | Job postings, domains, stipends, required skills, deadlines, status | FK to `users.id` (recruiter) |
| `applications` | Student submissions, skill match %, stage status, recruiter feedback | FK to `internships.id`, `users.id` |
| `interviews` | Scheduled sessions, date, time, Google Meet / Zoom URL, status | FK to `applications.id` |
| `notifications` | In-app alerts, types, read/unread states | FK to `users.id` |
| `saved_internships` | Student favorites / bookmarks | Unique pair (`student_id`, `internship_id`) |

---

## 4. Key Constraints & Data Integrity

1. **Duplicate Application Prevention**:
   ```sql
   UNIQUE KEY uq_student_internship (student_id, internship_id)
   ```
   Ensures students cannot submit multiple applications to the same opening.

2. **Cascade Deletion**:
   Student profiles and submitted applications automatically cascade upon user de-registration.

3. **Status Enums**:
   Enforces strict lifecycle state integrity:
   `APPLIED`, `UNDER_REVIEW`, `SHORTLISTED`, `INTERVIEW_SCHEDULED`, `SELECTED`, `REJECTED`.

---

## 5. Sample Verification Queries

Check total registered students and recruiters:
```sql
SELECT role, COUNT(*) AS count FROM users GROUP BY role;
```

Check top internships with applicant count:
```sql
SELECT i.title, i.company_name, COUNT(a.id) AS total_applicants
FROM internships i
LEFT JOIN applications a ON i.id = a.internship_id
GROUP BY i.id;
```

Inspect shortlisted candidates and their skill match scores:
```sql
SELECT u.name, i.title, a.skill_match_percentage, a.status
FROM applications a
JOIN users u ON a.student_id = u.id
JOIN internships i ON a.internship_id = i.id
WHERE a.status IN ('SHORTLISTED', 'SELECTED');
```
