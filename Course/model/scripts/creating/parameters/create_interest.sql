CREATE TABLE interest_category
(
    key VARCHAR(40) NOT NULL,

    CONSTRAINT PK_interest_category PRIMARY KEY (key)
);
CLUSTER interest_category USING pk_interest_category;

CREATE TABLE interest
(
    key          VARCHAR(40) NOT NULL,
    category_key VARCHAR(40) NOT NULL,

    CONSTRAINT PK_interest PRIMARY KEY (key),

    CONSTRAINT FK_interest_category
        FOREIGN KEY (category_key) REFERENCES interest_category (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CLUSTER interest USING pk_interest;

CREATE PROCEDURE add_interest(
    interest_key VARCHAR(40),
    interest_category_key VARCHAR(40)
)
AS
$$
BEGIN
    INSERT INTO interest_category(key)
    VALUES (interest_category_key)
    ON CONFLICT DO NOTHING;

    INSERT INTO interest(key, category_key)
    VALUES (interest_key, interest_category_key);
END;
$$ LANGUAGE plpgsql;