# EmotionTrack Entity-Relationship Diagram (ERD)

The diagram below represents the entities and relationships inferred from the current SQLAlchemy models.

```mermaid
erDiagram
    USERS {
        INT id PK
        STRING firstname
        STRING lastname
        STRING email UNIQUE
        STRING password_hash
        DATE birthday
        STRING gender
        STRING strand
        STRING grade_level
        STRING section
        BOOLEAN is_admin
        ENUM role
        DATETIME created_at
        DATETIME last_profile_update
    }

    MOOD_LOGS {
        INT log_id PK
        INT user_id FK
        STRING emotion
        INT intensity
        FLOAT sleep
        INT energy
        STRING triggers
        STRING coping
        TEXT gratitude
        DATETIME log_date
    }

    DASS21_RESULTS {
        INT id PK
        INT user_id FK
        INT depression_score
        INT anxiety_score
        INT stress_score
        STRING depression_severity
        STRING anxiety_severity
        STRING stress_severity
        DATETIME created_at
    }

    STUDENT_MESSAGES {
        INT id PK
        INT sender_user_id FK
        TEXT message_text
        BOOLEAN is_read
        TEXT admin_response
        BOOLEAN is_response_read_by_student
        STRING conversation_type
        INT responded_by_admin_id FK
        DATETIME created_at
        DATETIME responded_at
    }

    CLASS_ASSIGNMENTS {
        INT id PK
        INT faculty_id FK
        STRING grade_level
        STRING section
        DATETIME created_at
        UNIQUE unique_grade_section
    }

    USERS ||--o{ MOOD_LOGS : "user_id"
    USERS ||--o{ DASS21_RESULTS : "user_id"
    USERS ||--o{ STUDENT_MESSAGES : "sender_user_id"
    USERS ||--o{ STUDENT_MESSAGES : "responded_by_admin_id"
    USERS ||--o{ CLASS_ASSIGNMENTS : "faculty_id"
```

Notes:
- STUDENT_MESSAGES.conversation_type distinguishes whether a message thread is for the guidance office or a faculty adviser.
- CLASS_ASSIGNMENTS enforces one faculty per (grade_level, section) via a unique constraint.
- The responded_by_admin_id on STUDENT_MESSAGES is optional (nullable) and points to the admin user who responded.
- USERS.role is an ENUM with values: student, guidance_admin, faculty_admin.