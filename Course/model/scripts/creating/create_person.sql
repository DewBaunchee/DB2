CREATE TABLE person
(
    id           SERIAL,
    name         VARCHAR(40)  NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    phone_number CHAR(15)     NOT NULL UNIQUE,

    CONSTRAINT PK_person PRIMARY KEY (id)
);
CLUSTER person USING pk_person;

CREATE TABLE person_credentials
(
    person_id INT      NOT NULL UNIQUE,
    password  CHAR(60) NOT NULL,

    CONSTRAINT FK_person_credentials
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX person_credentials_index ON person_credentials (person_id);
CLUSTER person_credentials USING person_credentials_index;

CREATE TABLE person_locale
(
    person_id  INT     NOT NULL,
    locale_key CHAR(5) NOT NULL,

    CONSTRAINT FK_person_locale_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_locale_locale
        FOREIGN KEY (locale_key) REFERENCES locale (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX person_locale_index ON person_locale (person_id);
CLUSTER person_locale USING person_locale_index;

CREATE TABLE person_programming_language
(
    person_id                INT         NOT NULL,
    programming_language_key VARCHAR(20) NOT NULL,

    CONSTRAINT FK_person_programming_language_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_programming_language_language
        FOREIGN KEY (programming_language_key) REFERENCES programming_language (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX person_programming_language_index ON person_programming_language (person_id);
CLUSTER person_programming_language USING person_programming_language_index;

CREATE TABLE person_interest
(
    person_id    INT         NOT NULL,
    interest_key VARCHAR(40) NOT NULL,

    CONSTRAINT FK_person_interest_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_interest_interest
        FOREIGN KEY (interest_key) REFERENCES interest (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX person_interest_index ON person_interest (person_id);
CLUSTER person_interest USING person_interest_index;

CREATE TABLE photo
(
    id   BIGINT NOT NULL,
    data BYTEA  NOT NULL,

    CONSTRAINT PK_photo PRIMARY KEY (id)
);
CLUSTER photo USING PK_photo;

CREATE TABLE person_photo
(
    person_id INT    NOT NULL,
    photo_id  BIGINT NOT NULL,

    CONSTRAINT FK_person_photo_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_photo_photo
        FOREIGN KEY (photo_id) REFERENCES photo (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX person_photo_index ON person_photo (person_id);
CLUSTER person_photo USING person_photo_index;

CREATE TABLE person_public_info
(
    person_id          INT NOT NULL UNIQUE,
    marital_status_key CHAR(10),
    sex_key            CHAR(5),
    birthday           DATE CHECK ( birthday < now() - interval '18 years' ),
    city_id            INT,
    height             SMALLINT,
    main_photo         BIGINT,

    CONSTRAINT FK_person_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_marital_status
        FOREIGN KEY (marital_status_key) REFERENCES marital_status (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_sex
        FOREIGN KEY (sex_key) REFERENCES sex (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_city
        FOREIGN KEY (city_id) REFERENCES city (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_main_photo
        FOREIGN KEY (main_photo) REFERENCES photo (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX person_public_info_index ON person_public_info (person_id);
CREATE INDEX person_public_info_city_index ON person_public_info (city_id);
CLUSTER person_public_info USING person_public_info_index;

CREATE TABLE visited_person
(
    person_id         INT     NOT NULL,
    visited_person_id INT     NOT NULL,
    accepted          BOOLEAN NOT NULL,

    CONSTRAINT FK_visited_person_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_visited_person_visited
        FOREIGN KEY (visited_person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX visited_person_index ON visited_person (person_id);
CREATE INDEX visited_person_index2 ON visited_person (visited_person_id);
CLUSTER visited_person USING visited_person_index;
