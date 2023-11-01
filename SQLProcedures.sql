CREATE DATABASE Spotify
USE Spotify

CREATE TABLE Users
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
Surname VARCHAR(50) DEFAULT 'XXX',
Username VARCHAR(50) NOT NULL,
Password VARCHAR(50) NOT NULL,
Gender CHAR(10) NOT NULL,
)

CREATE TABLE Artists
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
Surname VARCHAR(50) DEFAULT 'XXX',
Birthday DATE,
Gender VARCHAR(10) NOT NULL,
)


CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
)

CREATE TABLE Musics
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
Duration INT,
CategoryID INT REFERENCES Categories(Id),
ArtistID INT REFERENCES Artists(Id)
)

ALTER TABLE Musics ADD IsDeleted BIT DEFAULT 0



CREATE PROCEDURE usp_CreateUser @name VARCHAR(50), @surname VARCHAR(50) = 'XXX', @username VARCHAR(25), @password VARCHAR(50), @gender VARCHAR(10)
AS
INSERT INTO Users VALUES(@name,@surname,@username,@password,@gender)

EXEC usp_CreateUser 'Murad','Ganbarov','Murad2004','murad2004','Male'
EXEC usp_CreateUser 'Amin','Rzayev','Amin2004','amin2004','Male'
EXEC usp_CreateUser 'Rashad','Rufullayev','Rashad2004','rashad2004','Male'

CREATE PROCEDURE usp_CreateArtist @name VARCHAR(50),@surname VARCHAR(50) = 'XXX',@birthday DATE,@gender VARCHAR(10)
AS
INSERT INTO Artists VALUES (@name,@surname,@birthday,@gender)

EXEC usp_CreateArtist 'Kurt','Cobain','02-20-1067','Male'
EXEC usp_CreateArtist 'Nina','Simone','02-21-1933','Female'
EXEC usp_CreateArtist 'Eric','Wright','09-07-1964','Male'

CREATE PROCEDURE usp_CreateCategory @name VARCHAR(50)
AS
INSERT INTO Categories VALUES(@name)

EXEC usp_CreateCategory 'rock'
EXEC usp_CreateCategory 'jazz'
EXEC usp_CreateCategory 'rap'

CREATE PROCEDURE usp_CreateMusic @name VARCHAR(50), @duration INT,@CategoryID INT,@ArtistID INT,@IsDeleted BIT = 0
AS
INSERT INTO Musics VALUES (@name,@duration,@CategoryID,@ArtistId,@IsDeleted)

EXEC usp_CreateMusic 'School', 200,1,1
EXEC usp_CreateMusic 'Blackbird',300,2,2
EXEC usp_CreateMusic 'Dopeman', 600,3,3


--TASK 2 burdan bashliyir
CREATE TABLE UserArtists
(
UserID INT FOREIGN KEY REFERENCES Users(Id),
ArtistId INT FOREIGN KEY REFERENCES Artists(Id)
)

INSERT INTO UserArtists VALUES
(1,1),
(2,2),
(3,3)

CREATE TRIGGER DeleteMusic
ON Musics
INSTEAD OF DELETE

AS
BEGIN
DECLARE @Id INT
DECLARE @IsDeleted BIT
SELECT @Id = deleted.Id,@IsDeleted = deleted.IsDeleted FROM deleted
IF (@IsDeleted = 0)
 BEGIN
 UPDATE Musics SET IsDeleted = 1 WHERE @Id = Id
 END

ELSE
 BEGIN
 DELETE FROM Musics WHERE @Id = Id
 END

END

delete from Musics where id = 1

--TASK 3 Burdan bashlayir
CREATE FUNCTION GetUserListenArtistsCount (@Id INT)
RETURNS INT
AS
BEGIN
DECLARE @count INT
SELECT  @count = COUNT(ua.ArtistID) FROM UserArtists as ua 
WHERE ua.UserId = @Id
RETURN @count
END

SELECT dbo.GetUserListenArtistsCount(1)
