CREATE TABLE achievements
(
    id          INT NOT NULL,
    icon        BYTEA NOT NULL,
    label       VARCHAR(40) NOT NULL ,
    description VARCHAR(200) NOT NULL,

    CONSTRAINT PK_achievements PRIMARY KEY (id)
);
CLUSTER achievements USING PK_achievements;

CREATE TABLE person_achievements
(
    person_id      INT NOT NULL,
    achievement_id INT NOT NULL,

    CONSTRAINT FK_person_photo_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_photo_photo
        FOREIGN KEY (achievement_id) REFERENCES achievements (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX person_achievements_index ON person_achievements (person_id);
CLUSTER person_achievements USING person_achievements_index;

CREATE VIEW person_achievements_view AS
SELECT *
FROM person_achievements
         INNER JOIN achievements a ON a.id = person_achievements.achievement_id;
