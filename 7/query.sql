/*
1. Создать хранимую процедуру, которая:
a) добавляет каждой книге два случайных жанра;
b) отменяет совершённые действия, если в процессе работы хотя бы одна операция вставки
завершилась ошибкой в силу дублирования значения первичного ключа таблицы «m2m_books_genres»
(т.е. у такой книги уже был такой жанр).
*/

CREATE OR ALTER PROCEDURE random_genres
AS
BEGIN
    BEGIN TRANSACTION;

    DECLARE @genre1 INT
    DECLARE @genre2 INT
    SET @genre1 = (SELECT TOP 1 g_id
                   FROM genres
                   ORDER BY NEWID());
    SET @genre2 = (SELECT TOP 1 g_id
                   FROM genres
                   ORDER BY NEWID());
    BEGIN TRY
        INSERT INTO m2m_books_genres(b_id, g_id)
        SELECT b_id, genre
        FROM books
                 FULL JOIN (SELECT @genre1 as genre UNION SELECT @genre2 as genre) as gg ON 1 = 1
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO
EXEC random_genres
SELECT *
FROM m2m_books_genres

/*
2. Создать хранимую процедуру, которая:
а) увеличивает значение поля «b_quantity» для всех книг в два раза;
б) отменяет совершённое действие, если по итогу выполнения операции
среднее количество экземпляров книг превысит значение 50.
*/

CREATE OR ALTER PROCEDURE double_quantity
AS
BEGIN
    BEGIN TRANSACTION;
    UPDATE books
    SET b_quantity = 2 * books.b_quantity;

    IF EXISTS(SELECT 1 FROM books HAVING AVG(b_quantity) > 50)
        BEGIN
            ROLLBACK TRANSACTION;
            RETURN;
        END;
    COMMIT TRANSACTION;
END;
GO
EXEC double_quantity

/*
3. Написать запросы, которые, будучи выполненными параллельно, обеспечивали бы следующий эффект:
а) первый запрос должен считать количество выданных на руки и возвращённых в
библиотеку книг и не зависеть от запросов на обновление таблицы
«subscriptions» (не ждать их завершения);
б) второй запрос должен инвертировать значения поля «sb_is_active» таблицы
subscriptions с «Y» на «N» и наоборот и не зависеть от первого запроса (не ждать его завершения).
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
SELECT sb_is_active, COUNT(*)
FROM subscriptions
GROUP BY sb_is_active;
COMMIT;

BEGIN TRANSACTION;
UPDATE subscriptions
SET sb_is_active = IIF(sb_is_active = 'Y', 'N', 'Y');
COMMIT;

/*
6. Создать на таблице «subscriptions» триггер, определяющий уровень
изолированности транзакции, в котором сейчас проходит операция
обновления, и отменяющий операцию, если уровень изолированности
транзакции отличен от REPEATABLE READ.
*/

CREATE OR ALTER TRIGGER check_transaction_trigger
    ON subscriptions
    FOR INSERT, UPDATE
    AS
BEGIN
    IF (EXISTS((SELECT 1
                FROM sys.dm_exec_sessions
                WHERE session_id = @@SPID
                  AND transaction_isolation_level != 3)))
        RAISERROR ('Allowed only REPEATABLE READ transaction isolation level', 1, 1)
END;
GO
/*
7. Создать хранимую функцию, порождающую исключительную ситуацию в случае,
если выполняются оба условия (подсказка: эта задача имеет решение только для MS SQL Server):
а) режим автоподтверждения транзакций выключен;
б) функция запущена из вложенной транзакции.

*/

CREATE OR ALTER FUNCTION check_transactions()
    RETURNS INT
AS
BEGIN
    IF (@@TRANCOUNT > 1 AND EXISTS(SELECT 1 WHERE @@OPTIONS & 2 = 0))
        RETURN CAST('Conditions not met!' AS INT)
    RETURN 1;
END;

SET IMPLICIT_TRANSACTIONS OFF;
BEGIN TRANSACTION;
SELECT dbo.check_transactions()
COMMIT;