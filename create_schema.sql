CREATE TABLE USERS
(
    USERNAME VARCHAR(50) NOT NULL PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    SURNAME VARCHAR(50) NOT NULL,
    EMAIL VARCHAR(100) NOT NULL UNIQUE,
    PASSWORD VARCHAR(100) NOT NULL,
    WEIGHT NUMERIC(5, 2),
    HEIGHT NUMERIC(5, 2),
    VERIFIED INTEGER DEFAULT 0,
    FAVORITE_EXERCISE INTEGER,
    AVATAR VARCHAR(7)
);

CREATE TABLE WORKOUTS
(
    WORKOUT_ID INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    START_DATETIME TIMESTAMP,
    USERNAME VARCHAR(50) NOT NULL,
    END_DATETIME TIMESTAMP,
    DESCRIPTION VARCHAR(255),
    CREATED_DATETIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IS_POSTED INTEGER DEFAULT 0,
    SCHEDULE INTEGER DEFAULT 0,
    CONSTRAINT FK_WORKOUTS_USERNAME FOREIGN KEY (USERNAME)
        REFERENCES USERS (USERNAME) ON DELETE CASCADE
);

CREATE TABLE MUSCLES
(
    MUSCLE_ID INTEGER NOT NULL PRIMARY KEY,
    MUSCLE_NAME VARCHAR(40) NOT NULL
);

CREATE TABLE EXERCISES
(
    EXERCISE_ID INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    TYPE CHAR(1) DEFAULT 'S',
    KCAL_BURNED INTEGER DEFAULT 0,
    NAME VARCHAR(40) NOT NULL,
    VIDEO_ID VARCHAR(11)
);

CREATE TABLE EXERCISES_MUSCLES
(
    ID INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    EXERCISE_ID INTEGER NOT NULL,
    MUSCLE_ID INTEGER NOT NULL,
    CONSTRAINT MUSCLE_FK FOREIGN KEY (MUSCLE_ID)
        REFERENCES MUSCLES (MUSCLE_ID),
    CONSTRAINT EXERCISE_FK FOREIGN KEY (EXERCISE_ID)
        REFERENCES EXERCISES (EXERCISE_ID) ON DELETE CASCADE
);

CREATE TABLE ACTIVITIES
(
    ACTIVITY_ID INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    EXERCISE_ID INTEGER NOT NULL,
    REPS INTEGER DEFAULT 0,
    WEIGHT INTEGER DEFAULT 0,
    DURATION INTERVAL DEFAULT '00:00:00',
    WORKOUT_ID INTEGER NOT NULL,
    CONSTRAINT FK_WORKOUT FOREIGN KEY (WORKOUT_ID)
        REFERENCES WORKOUTS (WORKOUT_ID) ON DELETE CASCADE,
    CONSTRAINT FK_EXERCISE FOREIGN KEY (EXERCISE_ID)
        REFERENCES EXERCISES (EXERCISE_ID) ON DELETE CASCADE
);

CREATE TABLE TOKEN
(
    EMAIL VARCHAR(255) NOT NULL PRIMARY KEY,
    VERIFICATION_TOKEN VARCHAR(255),
    RESET_TOKEN VARCHAR(255),
    RESET_EXPIRY TIMESTAMP,
    CONSTRAINT EMAIL_FK FOREIGN KEY (EMAIL)
        REFERENCES USERS (EMAIL) ON DELETE CASCADE
);

CREATE TABLE FRIENDSHIPS
(
    ID INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    FRIEND1_USERNAME VARCHAR(50) NOT NULL,
    FRIEND2_USERNAME VARCHAR(50) NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FRIENDSHIP_UNIQUE_PAIR1
        UNIQUE (FRIEND1_USERNAME, FRIEND2_USERNAME),
    CONSTRAINT FK_USER1 FOREIGN KEY (FRIEND1_USERNAME)
        REFERENCES USERS (USERNAME) ON DELETE CASCADE,
    CONSTRAINT FK_USER2 FOREIGN KEY (FRIEND2_USERNAME)
        REFERENCES USERS (USERNAME) ON DELETE CASCADE
);

CREATE TABLE FRIENDSHIP_INVITATIONS
(
    ID INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    WHO_SEND_USERNAME VARCHAR(50) NOT NULL,
    WHO_RECEIVE_USERNAME VARCHAR(50) NOT NULL,
    SEND_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT UNIQUE_FRIENDSHIP_INVITATION UNIQUE (WHO_SEND_USERNAME, WHO_RECEIVE_USERNAME),
    CONSTRAINT FK_WHO_RECEIVE FOREIGN KEY (WHO_RECEIVE_USERNAME)
        REFERENCES USERS (USERNAME) ON DELETE CASCADE,
    CONSTRAINT FK_WHO_SEND FOREIGN KEY (WHO_SEND_USERNAME)
        REFERENCES USERS (USERNAME) ON DELETE CASCADE
);

CREATE TABLE POSTS
(
    POST_ID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    AUTHOR_USERNAME VARCHAR(50) NOT NULL,
    POST_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TITLE VARCHAR(100) NOT NULL,
    WORKOUT_ID INTEGER,
    CONTENT VARCHAR(200),
    CONSTRAINT FK_USERNAME FOREIGN KEY (AUTHOR_USERNAME)
        REFERENCES USERS (USERNAME) ON DELETE CASCADE,
    CONSTRAINT FK_WORKOUT_ID FOREIGN KEY (WORKOUT_ID)
        REFERENCES WORKOUTS (WORKOUT_ID) ON DELETE CASCADE
);

CREATE TABLE POST_COMMENTS
(
    POST_COMMENT_ID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    POST_ID INTEGER NOT NULL,
    AUTHOR_USERNAME VARCHAR(50) NOT NULL,
    CONTENT VARCHAR(255),
    POST_COMMENT_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_POST_ID FOREIGN KEY (POST_ID)
        REFERENCES POSTS (POST_ID),
    CONSTRAINT FK_AUTHOR_USERNAME FOREIGN KEY (AUTHOR_USERNAME)
        REFERENCES USERS (USERNAME)
);

CREATE TABLE POST_REACTIONS
(
    POST_REACTION_ID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    POST_ID INTEGER NOT NULL,
    AUTHOR_USERNAME VARCHAR(40) NOT NULL,
    CONSTRAINT UNIQUE_REACTION_AUTHOR UNIQUE (POST_ID, AUTHOR_USERNAME),
    CONSTRAINT FK_REACTOR_USERNAME FOREIGN KEY (AUTHOR_USERNAME)
        REFERENCES USERS (USERNAME) ON DELETE CASCADE,
    CONSTRAINT FK_REACTION_POST_ID FOREIGN KEY (POST_ID)
        REFERENCES POSTS (POST_ID) ON DELETE CASCADE
);
