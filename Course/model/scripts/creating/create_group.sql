CREATE TABLE group_type
(
    key CHAR(40) NOT NULL ,

    CONSTRAINT PK_group_type PRIMARY KEY (key)
);
CLUSTER group_type USING pk_group_type;

CREATE TABLE "group"
(
    id            BIGINT,
    label         VARCHAR(40) NOT NULL,
    type          CHAR(40)    NOT NULL,
    creation_date TIMESTAMP   NOT NULL,

    CONSTRAINT PK_group PRIMARY KEY (id),

    CONSTRAINT FK_group_type
        FOREIGN KEY (type) REFERENCES group_type (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CLUSTER "group" USING pk_group;

CREATE TABLE group_member
(
    person_id INT    NOT NULL,
    group_id  BIGINT NOT NULL,

    CONSTRAINT FK_group_name_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_group_member_group
        FOREIGN KEY (group_id) REFERENCES "group" (id)
            ON DELETE CASCADE ON UPDATE RESTRICT
);
CREATE INDEX group_member_person_index ON group_member (person_id);
CREATE INDEX group_member_group_index ON group_member (group_id);
CLUSTER group_member USING group_member_person_index;