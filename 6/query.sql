/*
1. Создать хранимую функцию, получающую на вход идентификатор читателя и
возвращающую список идентификаторов книг, которые он уже прочитал и вернул в
библиотеку.
*/

CREATE OR ALTER FUNCTION get_books(@reader_id INT)
    RETURNS @books TABLE
                   (
                       book_id INT
                   )
AS
BEGIN
    INSERT INTO @books (book_id)
    SELECT sb_book
    FROM subscriptions
    WHERE sb_subscriber = @reader_id;

    RETURN;
END;

SELECT *
FROM dbo.get_books(1);

/*
3. Создать хранимую функцию, получающую на вход идентификатор читателя и
возвращающую 1, если у читателя на руках сейчас менее десяти книг, и 0 в
противном случае.
*/

CREATE OR ALTER FUNCTION is_less_ten(@reader_id INT)
    RETURNS INT
AS
BEGIN
    IF ((SELECT COUNT(*) FROM subscriptions WHERE sb_subscriber = @reader_id AND sb_is_active = 'Y') < 10)
        RETURN 1;
    RETURN 0;
END;

SELECT dbo.is_less_ten(6)

/*
4. Создать хранимую функцию, получающую на вход год издания книги и
возвращающую 1, если книга издана менее ста лет назад, и 0 в противном случае.
*/

CREATE OR ALTER FUNCTION is_less_hundred(@year INT)
    RETURNS INT
AS
BEGIN
    IF (DATEPART(year, GETDATE()) - @year < 100)
        RETURN 1;
    RETURN 0;
END;

/*
6. Создать хранимую процедуру, формирующую список таблиц и их внешних ключей,
зависящих от указанной в параметре функции таблицы.
*/

SELECT *
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS;

SELECT *
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'authors'

SELECT *
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE

CREATE OR ALTER FUNCTION get_foreign_keys(@target_table SYSNAME)
    RETURNS @relates TABLE
                     (
                         table_name  SYSNAME,
                         foreign_key SYSNAME
                     )
AS
BEGIN
    INSERT INTO @relates(table_name, foreign_key)
    SELECT cu.TABLE_NAME, cu.COLUMN_NAME
    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS c
             INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cu
                        ON cu.CONSTRAINT_NAME = c.CONSTRAINT_NAME
             INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE ku
                        ON ku.CONSTRAINT_NAME = c.UNIQUE_CONSTRAINT_NAME AND ku.TABLE_NAME = @target_table;

    RETURN;
END;

SELECT *
FROM dbo.get_foreign_keys('authors');

/*
9. Создать хранимую процедуру, автоматически создающую и наполняющую
данными таблицу «arrears», в которой должны быть представлены
идентификаторы и имена читателей, у которых до сих пор находится на руках хотя
бы одна книга, по которой дата возврата установлена в прошлом относительно
текущей даты.
*/

CREATE OR ALTER PROCEDURE ensure_arrears
AS
BEGIN
    IF (EXISTS(SELECT *
               FROM INFORMATION_SCHEMA.TABLES
               WHERE TABLE_NAME = 'arrears'))
        BEGIN
            DROP TABLE arrears;
        END;
    CREATE TABLE arrears
    (
        id   INT,
        name NVARCHAR(150)
    );
    INSERT INTO arrears
    SELECT DISTINCT sb_subscriber, s_name
    FROM subscriptions AS sb
             INNER JOIN subscribers s
                        ON s.s_id = sb.sb_subscriber AND sb.sb_is_active = 'Y' AND sb.sb_finish < GETDATE();
    RETURN;
END;
GO
EXEC ensure_arrears