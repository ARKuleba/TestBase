USE master; 
GO

DROP DATABASE IF EXISTS VeterinaryClinic;
GO

CREATE DATABASE VeterinaryClinic; 
GO

USE VeterinaryClinic; 
GO

-- Создание таблиц узлов
CREATE TABLE Owners (
    UserID INT IDENTITY NOT NULL,
    UserName NVARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    City NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Users PRIMARY KEY (UserID)
) AS NODE;
GO


CREATE TABLE Pets (
    PetID INT IDENTITY NOT NULL,
    PetName NVARCHAR(100) NOT NULL,
    Species NVARCHAR(100) NOT NULL,
	Breed NVARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    CONSTRAINT PK_Pets PRIMARY KEY (PetID)
) AS NODE;


CREATE TABLE Cities (
    CityID INT IDENTITY NOT NULL,
    CityName NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Cities PRIMARY KEY (CityID)
) AS NODE;
GO

-- Создание таблиц ребер
CREATE TABLE Friends AS EDGE;
GO
ALTER TABLE Friends ADD CONSTRAINT EC_Friends CONNECTION (Owners to Owners);

CREATE TABLE TakesCareOf AS EDGE;
GO
ALTER TABLE TakesCareOf ADD CONSTRAINT EC_TakesCareOf CONNECTION (Owners to Pets);

CREATE TABLE ResidesIn AS EDGE;
GO
ALTER TABLE ResidesIn ADD CONSTRAINT EC_ResidesIn CONNECTION (Owners to Cities);


-- Заполнение таблиц узлов
INSERT INTO Owners (UserName, Age, City)
VALUES ('John Smith', 25, 'New York'),
       ('Emily Johnson', 30, 'Los Angeles'),
       ('Michael Davis', 40, 'Chicago'),
       ('Jessica Wilson', 28, 'San Francisco'),
       ('David Taylor', 35, 'Houston'),
       ('Emma Anderson', 27, 'Miami'),
       ('Christopher Clark', 32, 'Seattle'),
       ('Olivia Martinez', 29, 'Boston'),
       ('Daniel Rodriguez', 33, 'Dallas'),
       ('Sophia Lee', 31, 'Atlanta');

INSERT INTO Pets (PetName, Species, Breed, Age)
VALUES
    ('Max', 'Dog', 'Labrador Retriever', 3),
    ('Luna', 'Cat', 'Siamese', 5),
    ('Buddy', 'Dog', 'Golden Retriever', 2),
    ('Charlie', 'Dog', 'Poodle', 4),
    ('Oliver', 'Parrot', 'African Grey', 3),
    ('Lucy', 'Dog', 'Beagle', 2),
    ('Milo', 'Cat', 'Persian', 3),
    ('Daisy', 'Turtle', 'Red-Eared Slider', 10),
    ('Rocky', 'Dog', 'Bulldog', 4),
    ('Sophie', 'Cat', 'Ragdoll', 2),
	('Coco', 'Dog', 'Chihuahua', 1),
    ('Oscar', 'Cat', 'British Shorthair', 4);


INSERT INTO Cities (CityName, Country)
VALUES ('New York', 'United States'),
		('London', 'United Kingdom'),
		('Paris', 'France'),
		('Tokyo', 'Japan'),
		('Sydney', 'Australia'),
		('Rome', 'Italy'),
		('Moscow', 'Russia'),
		('Los Angeles', 'United States'),
		('Chicago', 'United States'),
		('Houston', 'United States');


-- Заполнение таблиц ребер
INSERT INTO Friends ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Owners WHERE UserID = 1), -- John Smith
		(SELECT $node_id FROM Owners WHERE UserID = 2) -- Emily Johnson
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 1), -- John Smith
		(SELECT $node_id FROM Owners WHERE UserID = 3) -- Michael Davis
	),	
	(
		(SELECT $node_id FROM Owners WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Owners WHERE UserID = 4) -- Jessica Wilson
	),	
	(
		(SELECT $node_id FROM Owners WHERE UserID = 5), -- David Taylor
		(SELECT $node_id FROM Owners WHERE UserID = 6) -- Emma Anderson
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 5), -- David Taylor
		(SELECT $node_id FROM Owners WHERE UserID = 7) -- Christopher Clark
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 8), -- Olivia Martinez
		(SELECT $node_id FROM Owners WHERE UserID = 9) -- Daniel Rodriguez
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Owners WHERE UserID = 8) -- Olivia Martinez
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Owners WHERE UserID = 1) -- John Smith
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Owners WHERE UserID = 3) -- Michael Davis
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Owners WHERE UserID = 5) -- David Taylor
	)
;


INSERT INTO TakesCareOf ($from_id, $to_id)
VALUES
    (
        (SELECT $node_id FROM Owners WHERE UserID = 1), -- John Smith
        (SELECT $node_id FROM Pets WHERE PetID = 1) -- Max
    ),
    (
        (SELECT $node_id FROM Owners WHERE UserID = 2), -- Emily Johnson
        (SELECT $node_id FROM Pets WHERE PetID = 2) -- Luna
    ),
    (
        (SELECT $node_id FROM Owners WHERE UserID = 3), -- Michael Davis
        (SELECT $node_id FROM Pets WHERE PetID = 3) -- Buddy
    ),
    (
        (SELECT $node_id FROM Owners WHERE UserID = 4), -- Jessica Wilson
        (SELECT $node_id FROM Pets WHERE PetID = 4) -- Charlie
    ),
    (
        (SELECT $node_id FROM Owners WHERE UserID = 2), -- Emily Johnson
        (SELECT $node_id FROM Pets WHERE PetID = 5) -- Oliver
    ),
    (
        (SELECT $node_id FROM Owners WHERE UserID = 6), -- Emma Anderson
        (SELECT $node_id FROM Pets WHERE PetID = 6) -- Lucy
    ),
    (
        (SELECT $node_id FROM Owners WHERE UserID = 7), -- Christopher Clark
        (SELECT $node_id FROM Pets WHERE PetID = 7) -- Milo
    ),
    (
        (SELECT $node_id FROM Owners WHERE UserID = 2), -- Emily Johnson
        (SELECT $node_id FROM Pets WHERE PetID = 8) -- Daisy
    ),
    (
        (SELECT $node_id FROM Owners WHERE UserID = 9), -- Daniel Rodriguez
        (SELECT $node_id FROM Pets WHERE PetID = 9) -- Rocky
    ),
    (
        (SELECT $node_id FROM Owners WHERE UserID = 10), -- Sophia Lee
        (SELECT $node_id FROM Pets WHERE PetID = 10) -- Sophie
    ),
	(
        (SELECT $node_id FROM Owners WHERE UserID = 5), -- David Taylor
        (SELECT $node_id FROM Pets WHERE PetID =11) -- Rocky
    ),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 8), -- Olivia Martinez
		(SELECT $node_id FROM Pets WHERE PetID = 12) -- Oscar
	)
;


INSERT INTO ResidesIn ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Owners WHERE UserID = 1), -- John Smith
		(SELECT $node_id FROM Cities WHERE CityID = 10) -- New York
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 2), -- Emily Johnson
		(SELECT $node_id FROM Cities WHERE CityID = 9) -- London
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Cities WHERE CityID = 8) -- Paris
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 4), -- Jessica Wilson
		(SELECT $node_id FROM Cities WHERE CityID = 7) -- Tokyo
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 5), -- David Taylor
		(SELECT $node_id FROM Cities WHERE CityID = 6) -- Sydney
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 6), -- Emma Anderson
		(SELECT $node_id FROM Cities WHERE CityID = 5) -- Rome
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 7), -- Christopher Clark
		(SELECT $node_id FROM Cities WHERE CityID = 4) -- Moscow
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 8), -- Olivia Martinez
		(SELECT $node_id FROM Cities WHERE CityID = 3) -- Rio de Janeiro
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 9), -- Daniel Rodriguez
		(SELECT $node_id FROM Cities WHERE CityID = 2) -- Cairo
	),
	(
		(SELECT $node_id FROM Owners WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Cities WHERE CityID = 1) -- Cape Town
	)
;


-- 5. Запросы с функцией MATCH

-- хозяева собак:
SELECT O.UserName AS [Имя хозяина]
FROM Owners AS O, 
	TakesCareOf AS T, 
	Pets AS P
WHERE MATCH (O-(T)->P) 
	  AND P.Species = 'Dog';


-- хозяева, которые дружат с Майклом Девисом:
SELECT O1.UserName AS [Имя хозяина]
FROM Owners AS O1, 
	 Friends AS S, 
	 Owners AS O2
WHERE MATCH (O1-(S)->O2) 
	  AND O2.UserName = 'Michael Davis';	


-- Питомцы Эмилии Джонсон
SELECT P.PetName AS [питомец]
FROM Owners AS O, 
	TakesCareOf AS T, 
	Pets AS P
WHERE MATCH (O-(T)->P) 
	AND O.UserName = 'Emily Johnson';


-- хозяева, живущие в городах Москва, London и Sydney
SELECT O.UserName AS [Имя хозяина]
FROM Owners AS O, 
	ResidesIn AS R, 
	Cities AS C
WHERE MATCH (O-(R)->C)
      AND C.CityName IN ('Moscow', 'London', 'Sydney');


-- хозяева, живущие в Америке
SELECT O.UserName AS [Имя пользователя]
FROM Owners AS O, 
	ResidesIn AS R, 
	Cities AS C
WHERE MATCH (O-(R)->C)
	AND C.Country = 'United States'


-- 6. Запросы с функцией SHORTEST_PATH

--кратчайший путь от хозяина David Taylor к другим пользователям, где длина пути составляет от 1 до 5
SELECT O1.UserName AS UserName1,
	STRING_AGG(O2.UserName, '->') WITHIN GROUP (GRAPH PATH) AS UserPath
FROM Owners AS O1,
	Owners FOR PATH AS O2,
	Friends FOR PATH AS F
WHERE MATCH(SHORTEST_PATH(O1(-(F)->O2){1,5}))
	and O1.UserName = 'David Taylor';

-- кратчайший путь от хозяина Michael Davis к другим пользователям любой длины
SELECT O1.UserName AS UserName1,
	STRING_AGG(O2.UserName, '->') WITHIN GROUP (GRAPH PATH) AS UserPath
FROM Owners AS O1,
	Owners FOR PATH AS O2,
	Friends FOR PATH AS F
WHERE MATCH(SHORTEST_PATH(O1(-(F)->O2)+))
	and O1.UserName = 'Michael Davis';






