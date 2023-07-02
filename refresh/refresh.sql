
/* ---------------------------------------------------- */
/*  Generated by Enterprise Architect Version 15.0 		*/
/* ---------------------------------------------------- */

/* Drop Foreign Key Constraints */

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_computers_rooms]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [computers] DROP CONSTRAINT [FK_computers_rooms]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_connections_cities1]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [connections] DROP CONSTRAINT [FK_connections_cities1]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_connections_cities2]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [connections] DROP CONSTRAINT [FK_connections_cities2]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_site_pages_site_pages]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [site_pages] DROP CONSTRAINT [FK_site_pages_site_pages]
GO

/* Drop Tables */

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[cities]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [cities]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[computers]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [computers]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[connections]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [connections]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dates]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dates]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[library_in_json]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [library_in_json]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[overflow]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [overflow]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[rooms]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [rooms]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[shopping]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [shopping]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[site_pages]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [site_pages]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[table_with_nulls]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [table_with_nulls]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[test_counts]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [test_counts]
GO

/* Create Tables */

CREATE TABLE [cities]
(
	[ct_id] int NOT NULL IDENTITY (1, 1),
	[ct_name] nvarchar(50) NOT NULL
)
GO

CREATE TABLE [computers]
(
	[c_id] int NOT NULL IDENTITY (1, 1),
	[c_room] int NULL,
	[c_name] nvarchar(50) NOT NULL
)
GO

CREATE TABLE [connections]
(
	[cn_from] int NOT NULL,
	[cn_to] int NOT NULL,
	[cn_cost] money NULL,
	[cn_bidir] char(1) NOT NULL
)
GO

CREATE TABLE [dates]
(
	[d] date NULL
)
GO

CREATE TABLE [library_in_json]
(
	[lij_id] int NOT NULL IDENTITY (1, 1),
	[lij_book] nvarchar(150) NOT NULL,
	[lij_author] nvarchar(2000) NOT NULL,
	[lij_genre] nvarchar(2000) NOT NULL
)
GO

CREATE TABLE [overflow]
(
	[x] int NULL
)
GO

CREATE TABLE [rooms]
(
	[r_id] int NOT NULL IDENTITY (1, 1),
	[r_name] nvarchar(50) NOT NULL,
	[r_space] tinyint NOT NULL
)
GO

CREATE TABLE [shopping]
(
	[sh_id] int NOT NULL IDENTITY (1, 1),
	[sh_transaction] int NOT NULL,
	[sh_category] nvarchar(150) NOT NULL
)
GO

CREATE TABLE [site_pages]
(
	[sp_id] int NOT NULL IDENTITY (1, 1),
	[sp_parent] int NULL,
	[sp_name] nvarchar(200) NULL
)
GO

CREATE TABLE [table_with_nulls]
(
	[x] int NULL
)
GO

CREATE TABLE [test_counts]
(
	[id] int NOT NULL IDENTITY (1, 1),
	[fni] int NULL,
	[fwi] int NULL,
	[fni_nn] int NOT NULL,
	[fwi_nn] int NOT NULL
)
GO

/* Create Primary Keys, Indexes, Uniques, Checks */

ALTER TABLE [cities]
 ADD CONSTRAINT [PK_cities]
	PRIMARY KEY CLUSTERED ([ct_id] ASC)
GO

ALTER TABLE [computers]
 ADD CONSTRAINT [PK_computers]
	PRIMARY KEY CLUSTERED ([c_id] ASC)
GO

ALTER TABLE [connections]
 ADD CONSTRAINT [PK_connections]
	PRIMARY KEY CLUSTERED ([cn_from] ASC,[cn_to] ASC)
GO

ALTER TABLE [connections]
 ADD CONSTRAINT [CHK_bidir] CHECK ([cn_bidir] IN ('N','Y'))
GO

CREATE NONCLUSTERED INDEX [idx_d]
 ON [dates] ([d] ASC)
GO

ALTER TABLE [library_in_json]
 ADD CONSTRAINT [PK_library_in_json]
	PRIMARY KEY CLUSTERED ([lij_id] ASC)
GO

ALTER TABLE [library_in_json]
 ADD CONSTRAINT [lij_author_is_JSON] CHECK (ISJSON([lij_author])=1)
GO

ALTER TABLE [library_in_json]
 ADD CONSTRAINT [lij_genre_is_JSON] CHECK (ISJSON([lij_genre])=1)
GO

ALTER TABLE [rooms]
 ADD CONSTRAINT [PK_rooms]
	PRIMARY KEY CLUSTERED ([r_id] ASC)
GO

ALTER TABLE [shopping]
 ADD CONSTRAINT [PK_shopping]
	PRIMARY KEY CLUSTERED ([sh_id] ASC)
GO

ALTER TABLE [site_pages]
 ADD CONSTRAINT [PK_site_pages]
	PRIMARY KEY CLUSTERED ([sp_id] ASC)
GO

ALTER TABLE [test_counts]
 ADD CONSTRAINT [PK_test_counts]
	PRIMARY KEY CLUSTERED ([id] ASC)
GO

CREATE NONCLUSTERED INDEX [idx_fwi]
 ON [test_counts] ([fwi] ASC)
GO

CREATE NONCLUSTERED INDEX [idx_fwi_nn]
 ON [test_counts] ([fwi_nn] ASC)
GO

/* Create Foreign Key Constraints */

ALTER TABLE [computers] ADD CONSTRAINT [FK_computers_rooms]
	FOREIGN KEY ([c_room]) REFERENCES [rooms] ([r_id]) ON DELETE Cascade ON UPDATE Cascade
GO

ALTER TABLE [connections] ADD CONSTRAINT [FK_connections_cities1]
	FOREIGN KEY ([cn_from]) REFERENCES [cities] ([ct_id]) ON DELETE Cascade ON UPDATE Cascade
GO

ALTER TABLE [connections] ADD CONSTRAINT [FK_connections_cities2]
	FOREIGN KEY ([cn_to]) REFERENCES [cities] ([ct_id]) ON DELETE No Action ON UPDATE No Action
GO

ALTER TABLE [site_pages] ADD CONSTRAINT [FK_site_pages_site_pages]
	FOREIGN KEY ([sp_parent]) REFERENCES [site_pages] ([sp_id])
GO

/* ---------------------------------------------------- */
/*  Generated by Enterprise Architect Version 15.0 	*/
/* ---------------------------------------------------- */

/* Drop Foreign Key Constraints */

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_m2m_books_authors_authors]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [m2m_books_authors] DROP CONSTRAINT [FK_m2m_books_authors_authors]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_m2m_books_authors_books]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [m2m_books_authors] DROP CONSTRAINT [FK_m2m_books_authors_books]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_m2m_books_genres_books]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [m2m_books_genres] DROP CONSTRAINT [FK_m2m_books_genres_books]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_m2m_books_genres_genres]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [m2m_books_genres] DROP CONSTRAINT [FK_m2m_books_genres_genres]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_subscriptions_books]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [subscriptions] DROP CONSTRAINT [FK_subscriptions_books]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[FK_subscriptions_subscribers]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [subscriptions] DROP CONSTRAINT [FK_subscriptions_subscribers]
GO

/* Drop Tables */

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[authors]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [authors]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[books]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [books]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[genres]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [genres]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[m2m_books_authors]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [m2m_books_authors]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[m2m_books_genres]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [m2m_books_genres]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[subscribers]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [subscribers]
GO

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[subscriptions]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [subscriptions]
GO

/* Create Tables */

CREATE TABLE [authors]
(
	[a_id] int NOT NULL IDENTITY (1, 1),
	[a_name] nvarchar(150) NOT NULL
)
GO

CREATE TABLE [books]
(
	[b_id] int NOT NULL IDENTITY (1, 1),
	[b_name] nvarchar(150) NOT NULL,
	[b_year] smallint NOT NULL,
	[b_quantity] smallint NOT NULL
)
GO

CREATE TABLE [genres]
(
	[g_id] int NOT NULL IDENTITY (1, 1),
	[g_name] nvarchar(150) NOT NULL
)
GO

CREATE TABLE [m2m_books_authors]
(
	[b_id] int NOT NULL,
	[a_id] int NOT NULL
)
GO

CREATE TABLE [m2m_books_genres]
(
	[b_id] int NOT NULL,
	[g_id] int NOT NULL
)
GO

CREATE TABLE [subscribers]
(
	[s_id] int NOT NULL IDENTITY (1, 1),
	[s_name] nvarchar(150) NOT NULL
)
GO

CREATE TABLE [subscriptions]
(
	[sb_id] int NOT NULL IDENTITY (1, 1),
	[sb_subscriber] int NOT NULL,
	[sb_book] int NOT NULL,
	[sb_start] date NOT NULL,
	[sb_finish] date NOT NULL,
	[sb_is_active] char(1) NOT NULL
)
GO

/* Create Primary Keys, Indexes, Uniques, Checks */

ALTER TABLE [authors]
 ADD CONSTRAINT [PK_authors]
	PRIMARY KEY CLUSTERED ([a_id] ASC)
GO

ALTER TABLE [books]
 ADD CONSTRAINT [PK_books]
	PRIMARY KEY CLUSTERED ([b_id] ASC)
GO

ALTER TABLE [genres]
 ADD CONSTRAINT [PK_genres]
	PRIMARY KEY CLUSTERED ([g_id] ASC)
GO

ALTER TABLE [genres]
 ADD CONSTRAINT [UQ_genres_g_name] UNIQUE NONCLUSTERED ([g_name] ASC)
GO

ALTER TABLE [m2m_books_authors]
 ADD CONSTRAINT [PK_m2m_books_authors]
	PRIMARY KEY CLUSTERED ([b_id] ASC,[a_id] ASC)
GO

ALTER TABLE [m2m_books_genres]
 ADD CONSTRAINT [PK_m2m_books_genres]
	PRIMARY KEY CLUSTERED ([b_id] ASC,[g_id] ASC)
GO

ALTER TABLE [subscribers]
 ADD CONSTRAINT [PK_subscribers]
	PRIMARY KEY CLUSTERED ([s_id] ASC)
GO

ALTER TABLE [subscriptions]
 ADD CONSTRAINT [PK_subscriptions]
	PRIMARY KEY CLUSTERED ([sb_id] ASC)
GO

ALTER TABLE [subscriptions]
 ADD CONSTRAINT [check_enum] CHECK ([sb_is_active] IN ('Y', 'N'))
GO

/* Create Foreign Key Constraints */

ALTER TABLE [m2m_books_authors] ADD CONSTRAINT [FK_m2m_books_authors_authors]
	FOREIGN KEY ([a_id]) REFERENCES [authors] ([a_id]) ON DELETE Cascade ON UPDATE Cascade
GO

ALTER TABLE [m2m_books_authors] ADD CONSTRAINT [FK_m2m_books_authors_books]
	FOREIGN KEY ([b_id]) REFERENCES [books] ([b_id]) ON DELETE Cascade ON UPDATE Cascade
GO

ALTER TABLE [m2m_books_genres] ADD CONSTRAINT [FK_m2m_books_genres_books]
	FOREIGN KEY ([b_id]) REFERENCES [books] ([b_id]) ON DELETE Cascade ON UPDATE Cascade
GO

ALTER TABLE [m2m_books_genres] ADD CONSTRAINT [FK_m2m_books_genres_genres]
	FOREIGN KEY ([g_id]) REFERENCES [genres] ([g_id]) ON DELETE Cascade ON UPDATE Cascade
GO

ALTER TABLE [subscriptions] ADD CONSTRAINT [FK_subscriptions_books]
	FOREIGN KEY ([sb_book]) REFERENCES [books] ([b_id]) ON DELETE Cascade ON UPDATE Cascade
GO

ALTER TABLE [subscriptions] ADD CONSTRAINT [FK_subscriptions_subscribers]
	FOREIGN KEY ([sb_subscriber]) REFERENCES [subscribers] ([s_id]) ON DELETE Cascade ON UPDATE Cascade
GO

SET IDENTITY_INSERT [rooms] ON;
INSERT INTO [rooms] ([r_id], [r_name], [r_space])
VALUES
(1, N'������� � ����� ������������', 5),
(2, N'������� � ����� ������������', 5),
(3, N'������ ������� 1', 2),
(4, N'������ ������� 2', 2),
(5, N'������ ������� 3', 2);
SET IDENTITY_INSERT [rooms] OFF;

SET IDENTITY_INSERT [computers] ON;
INSERT INTO [computers] ([c_id], [c_room], [c_name])
VALUES
(1, 1, N'��������� A � ������� 1'),
(2, 1, N'��������� B � ������� 1'),
(3, 2, N'��������� A � ������� 2'),
(4, 2, N'��������� B � ������� 2'),
(5, 2, N'��������� C � ������� 2'),
(6, NULL, N'��������� ��������� A'),
(7, NULL, N'��������� ��������� B'),
(8, NULL, N'��������� ��������� C');
SET IDENTITY_INSERT [computers] OFF;

SET IDENTITY_INSERT [library_in_json] ON;
INSERT INTO [library_in_json]
(
    [lij_id],
	[lij_book],
    [lij_author],
    [lij_genre]
) VALUES
(1, N'������� ������', N'[{"id":7,"name":"�.�. ������"}]', N'[{"id":1,"name":"������"},{"id":5,"name":"��������"}]'),
(2, N'��������� ����������������', N'[{"id":1,"name":"�. ����"}]', N'[{"id":2,"name":"����������������"},{"id":5,"name":"��������"}]'),
(3, N'���� ������������� ������', N'[{"id":4,"name":"�.�. ������"},{"id":5,"name":"�.�. ������"}]', N'[{"id":5,"name":"��������"}]'),
(4, N'��������� � �������', N'[{"id":2,"name":"�. ������"}]', N'[{"id":6,"name":"����������"}]'),
(5, N'���������� ����������������', N'[{"id":3,"name":"�. �������"},{"id":6,"name":"�. ����������"}]', N'[{"id":2,"name":"����������������"},{"id":3,"name":"����������"}]'),
(6, N'������ � ������ � �����', N'[{"id":7,"name":"�.�. ������"}]', N'[{"id":1,"name":"������"},{"id":5,"name":"��������"}]'),
(7, N'���� ���������������� �++', N'[{"id":6,"name":"�. ����������"}]', N'[{"id":2,"name":"����������������"}]');
SET IDENTITY_INSERT [library_in_json] OFF;


SET IDENTITY_INSERT [site_pages] ON;
INSERT INTO [site_pages] ([sp_id], [sp_parent], [sp_name]) VALUES
(1, NULL, N'�������'),
(2, 1, N'���������'),
(3, 1, N'���������'),
(4, 1, N'��������������'),
(5, 2, N'�������'),
(6, 2, N'����������'),
(7, 3, N'�����������'),
(8, 3, N'������� ������'),
(9, 4, N'�����'),
(10, 1, N'��������'),
(11, 3, N'���������'),
(12, 6, N'�������'),
(13, 6, N'��������'),
(14, 6, N'�������������');
SET IDENTITY_INSERT [site_pages] OFF;

SET IDENTITY_INSERT [cities] ON;
INSERT INTO [cities] ([ct_id], [ct_name]) VALUES
(1, N'������'),
(2, N'�����'),
(3, N'������'),
(4, N'�����'),
(5, N'������'),
(6, N'����'),
(7, N'�����'),
(8, N'����'),
(9, N'�������'),
(10, N'������');
SET IDENTITY_INSERT [cities] OFF;

INSERT INTO [connections] ([cn_from], [cn_to], [cn_cost], [cn_bidir]) VALUES
(1, 5, 10, 'Y'),
(1, 7, 20, 'N'),
(7, 1, 25, 'N'),
(7, 2, 15, 'Y'),
(2, 6, 50, 'N'),
(6, 8, 40, 'Y'),
(8, 4, 30, 'N'),
(4, 8, 35, 'N'),
(8, 9, 15, 'Y'),
(9, 1, 20, 'N'),
(7, 3, 5, 'N'),
(3, 6, 5, 'N');

SET IDENTITY_INSERT [shopping] ON;
INSERT INTO [shopping]
(
    [sh_id],
    [sh_transaction],
    [sh_category]
) VALUES
(1, 1, N'�����'),
(2, 1, N'������'),
(3, 1, N'�����'),
(4, 2, N'�����'),
(5, 2, N'����'),
(6, 3, N'������'),
(7, 3, N'����'),
(8, 3, N'�����'),
(9, 3, N'������'),
(10, 4, N'�����');
SET IDENTITY_INSERT [shopping] OFF;

SET IDENTITY_INSERT [books] ON;
INSERT INTO [books] ([b_id], [b_name], [b_year], [b_quantity])
VALUES
(1, N'Евгений Онегин', 1985, 2),
(2, N'Сказка о рыбаке и рыбке', 1990, 3),
(3, N'Основание и империя', 2000, 5),
(4, N'Психология программирования', 1998, 1),
(5, N'Язык программирования С++', 1996, 3),
(6, N'Курс теоретической физики', 1981, 12),
(7, N'Искусство программирования', 1993, 7);
SET IDENTITY_INSERT [books] OFF;

SET IDENTITY_INSERT [authors] ON;
INSERT INTO [authors] ([a_id], [a_name])
VALUES
(1, N'Д. Кнут'),
(2, N'А. Азимов'),
(3, N'Д. Карнеги'),
(4, N'Л.Д. Ландау'),
(5, N'Е.М. Лифшиц'),
(6, N'Б. Страуструп'),
(7, N'А.С. Пушкин');
SET IDENTITY_INSERT [authors] OFF;

SET IDENTITY_INSERT [genres] ON;
INSERT INTO [genres] ([g_id], [g_name])
VALUES
(1, N'Поэзия'),
(2, N'Программирование'),
(3, N'Психология'),
(4, N'Наука'),
(5, N'Классика'),
(6, N'Фантастика');
SET IDENTITY_INSERT [genres] OFF;

SET IDENTITY_INSERT [subscribers] ON;
INSERT INTO [subscribers] ([s_id], [s_name])
VALUES
(1, N'Иванов И.И.'),
(2, N'Петров П.П.'),
(3, N'Сидоров С.С.'),
(4, N'Сидоров С.С.');
SET IDENTITY_INSERT [subscribers] OFF;

INSERT INTO [m2m_books_authors]
([b_id], [a_id])
VALUES
(1, 7),
(2, 7),
(3, 2),
(4, 3),
(4, 6),
(5, 6),
(6, 5),
(6, 4),
(7, 1);

INSERT INTO [m2m_books_genres] ([b_id], [g_id])
VALUES
(1, 1),
(1, 5),
(2, 1),
(2, 5),
(3, 6),
(4, 2),
(4, 3),
(5, 2),
(6, 5),
(7, 2),
(7, 5);

SET IDENTITY_INSERT [subscriptions] ON;
INSERT INTO [subscriptions] ([sb_id], [sb_subscriber], [sb_book], [sb_start], [sb_finish], [sb_is_active])
VALUES
(100, 1, 3, '2011-01-12', '2011-02-12', 'N'),
(2, 1, 1, '2011-01-12', '2011-02-12', 'N'),
(3, 3, 3, '2012-05-17', '2012-07-17', 'Y'),
(42, 1, 2, '2012-06-11', '2012-08-11', 'N'),
(57, 4, 5, '2012-06-11', '2012-08-11', 'N'),
(61, 1, 7, '2014-08-03', '2014-10-03', 'N'),
(62, 3, 5, '2014-08-03', '2014-10-03', 'Y'),
(86, 3, 1, '2014-08-03', '2014-09-03', 'Y'),
(91, 4, 1, '2015-10-07', '2015-03-07', 'Y'),
(95, 1, 4, '2015-10-07', '2015-11-07', 'N'),
(99, 4, 4, '2015-10-08', '2025-11-08', 'Y');
SET IDENTITY_INSERT [subscriptions] OFF;