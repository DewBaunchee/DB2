CREATE TABLE sex
(
    key CHAR(10) NOT NULL,

    CONSTRAINT PK_sex PRIMARY KEY (key)
);
CLUSTER sex USING pk_sex;