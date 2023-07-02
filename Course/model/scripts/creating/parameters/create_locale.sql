CREATE TABLE locale
(
    key   CHAR(5)     NOT NULL,
    label VARCHAR(40) NOT NULL UNIQUE,

    CONSTRAINT PK_locale PRIMARY KEY (key)
);
CLUSTER locale USING pk_locale;

CREATE TABLE locale_picture
(
    locale_key CHAR(5) UNIQUE,
    picture    BYTEA NOT NULL,

    CONSTRAINT FK_locale_picture
        FOREIGN KEY (locale_key) REFERENCES locale (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX locale_picture_index ON locale_picture (locale_key);
CLUSTER locale_picture USING locale_picture_index;