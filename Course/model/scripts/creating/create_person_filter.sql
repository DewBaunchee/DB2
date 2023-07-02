CREATE TABLE programming_language_filter
(
    person_id                INT         NOT NULL,
    programming_language_key VARCHAR(20) NOT NULL,

    CONSTRAINT FK_programming_language_filter_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_programming_language_filter_language
        FOREIGN KEY (programming_language_key) REFERENCES programming_language (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX programming_language_filter_index ON programming_language_filter (person_id);
CLUSTER programming_language_filter USING programming_language_filter_index;

CREATE TABLE person_filter
(
    person_id          INT NOT NULL UNIQUE,
    marital_status_key CHAR(10),
    sex_key            CHAR(5),
    age                SMALLINT,
    city_id            INT,
    height             SMALLINT,

    CONSTRAINT FK_person_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_marital_status
        FOREIGN KEY (marital_status_key) REFERENCES marital_status (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_sex
        FOREIGN KEY (sex_key) REFERENCES sex (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX person_filter_index ON person_filter (person_id);
CLUSTER person_filter USING person_filter_index;