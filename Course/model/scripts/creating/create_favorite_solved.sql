CREATE TABLE favorite_solved
(
    person_id           INT NOT NULL,
    solver_id           INT NOT NULL,
    solved_objective_id INT NOT NULL,

    CONSTRAINT FK_favorite_solved_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_favorite_solved_solver
        FOREIGN KEY (solver_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_favorite_solved_objective
        FOREIGN KEY (solved_objective_id) REFERENCES objective (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX favorite_solved_index ON favorite_solved (person_id);
CREATE INDEX favorite_solved_index2 ON favorite_solved (solver_id);
CREATE INDEX favorite_solved_index3 ON favorite_solved (solved_objective_id);
CLUSTER favorite_solved USING favorite_solved_index;

CREATE PROCEDURE like_solving(who_likes INT, solver_id_ INT, objective_id INT)
AS
$$
BEGIN
    INSERT INTO favorite_solved
    VALUES (who_likes, solver_id_, objective_id);
END;
$$ LANGUAGE plpgsql;
