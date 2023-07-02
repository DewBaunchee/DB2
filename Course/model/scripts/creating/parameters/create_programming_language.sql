CREATE TABLE programming_language
(
    key VARCHAR(20) NOT NULL,

    CONSTRAINT PK_programming_language PRIMARY KEY (key)
);
CLUSTER programming_language USING pk_programming_language;