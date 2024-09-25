/* 
Elvis Tiec
Lab #3
Creates movie ratings database. Creates movies, consumers, and ratings tables and fills in the data
*/

-- Create the database (dropping the previous version if necessary 
DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;

USE movie_ratings;

-- create movies table
CREATE TABLE Movies
(
    PRIMARY KEY (movie_id),
    movie_id   INT AUTO_INCREMENT,
    movie_title   VARCHAR(250),
    release_date  DATE,
    genre VARCHAR(250)
);

-- create consumers table
CREATE TABLE Consumers
(
    PRIMARY KEY (consumer_id),
    consumer_id   INT AUTO_INCREMENT,
    consumer_first_name VARCHAR(50),
    consumer_last_name  VARCHAR(50),
    consumer_address   VARCHAR(50),
    consumer_city   VARCHAR(50),
    consumer_state  VARCHAR(2),
    consumer_zip_code  VARCHAR(5)
);

-- create ratings table
CREATE TABLE Ratings
(
    movie_id    INT,
    consumer_id INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (consumer_id) REFERENCES Consumers(consumer_id),
    when_rated  DATETIME,
    number_stars    INT
);


-- filling in movies data
INSERT INTO Movies (movie_title, release_date, genre)
VALUES ('The Hunt for Red October', '1990-03-02', 'Acton, Adventure, Thriller'),
('Lady Bird', '2017-12-01', 'Comedy, Drama'),
('Inception', '2010-08-16', 'Acton, Adventure, Science Fiction'),
('Monty Python and the Holy Grail', '1975-04-03', 'Comedy');

-- filling in consumers data
INSERT INTO Consumers (consumer_first_name, consumer_last_name, consumer_address, consumer_city, consumer_state, consumer_zip_code)
VALUES ('Toru', 'Okada', '800 Glenridge Ave', 'Hobart', 'IN', '46343'),
('Kumiko', 'Okada', '864 NW Bohemia St', 'Vincentown', 'NJ', '08088'),
('Noboru', 'Wataya', '342 Joy Ridge St', 'Hermitage', 'TN', '37076'),
('May', 'Kasahara', '5 Kent Rd', 'East Haven', 'CT', '06512');

-- filling in ratings data
INSERT INTO Ratings (movie_id, consumer_id, when_rated, number_stars)
VALUES (1, 1, '2010-09-02 10:54:19', 4),
(1, 3, '2012-08-05 15:00:01', 3),
(1, 4, '2016-10-02 23:58:12', 1),
(2,	3, '2017-03-27 00:12:48', 2),
(2, 4, '2018-08-02 00:54:42', 4);


SELECT * FROM Movies;
SELECT * FROM Consumers;
SELECT * FROM Ratings;

/* Generate a report */
SELECT consumer_first_name, consumer_last_name, movie_title, number_stars
  FROM Movies
      NATURAL JOIN Ratings
      NATURAL JOIN Consumers;



/* We can reduce the redundancy of the movie genres. Also, the genres I have setup can cause confusion because some 
fields may contain multiple different genres but it is labeled with only one string. I will solve this by creating a join table */

DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;

USE movie_ratings;

-- create genres table
CREATE TABLE Genres
(
    PRIMARY KEY (genre_id),
    genre_id    INT AUTO_INCREMENT,
    genre_name  VARCHAR(100)
);

-- create movies table
CREATE TABLE Movies
(
    PRIMARY KEY (movie_id),
    movie_id   INT AUTO_INCREMENT,
    movie_title   VARCHAR(250),
    release_date  DATE
);

-- create movie_genres join table
CREATE TABLE Movie_Genres
(
    movie_id  INT,
    genre_id  INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id),
    PRIMARY KEY (movie_id, genre_id)
);

-- create consumers table
CREATE TABLE Consumers
(
    PRIMARY KEY (consumer_id),
    consumer_id   INT AUTO_INCREMENT,
    consumer_first_name VARCHAR(50),
    consumer_last_name  VARCHAR(50),
    consumer_address   VARCHAR(50),
    consumer_city   VARCHAR(50),
    consumer_state  VARCHAR(2),
    consumer_zip_code  VARCHAR(5)
);

-- create ratings table
CREATE TABLE Ratings
(
    movie_id    INT,
    consumer_id INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (consumer_id) REFERENCES Consumers(consumer_id),
    when_rated  DATETIME,
    number_stars    INT
);


-- filling in genre data
INSERT INTO Genres (genre_name) VALUES
('Action'),
('Adventure'),
('Thriller'),
('Comedy'),
('Drama'),
('Science Fiction');

-- filling in movies data
INSERT INTO Movies (movie_title, release_date)
VALUES ('The Hunt for Red October', '1990-03-02'),
('Lady Bird', '2017-12-01'),
('Inception', '2010-08-16'),
('Monty Python and the Holy Grail', '1975-04-03');

-- filling in movie_genres data
-- Associating "The Hunt for Red October" with Action, Adventure, and Thriller
INSERT INTO Movie_Genres (movie_id, genre_id)
VALUES
(1, 1),  -- Action
(1, 2),  -- Adventure
(1, 3);  -- Thriller

-- Associating "Lady Bird" with Comedy and Drama
INSERT INTO Movie_Genres (movie_id, genre_id)
VALUES
(2, 4),  -- Comedy
(2, 5);  -- Drama

-- Associating "Inception" with Acton, Adventure, Science Fiction
INSERT INTO Movie_Genres (movie_id, genre_id)
VALUES
(3, 1),  -- Action
(3, 2),  -- Adventure
(3, 6);  -- Science Fiction

-- Associating "Monty Python and the Holy Grail" with Comedy
INSERT INTO Movie_Genres (movie_id, genre_id)
VALUES
(4, 4);  -- Comedy

-- filling in consumers data
INSERT INTO Consumers (consumer_first_name, consumer_last_name, consumer_address, consumer_city, consumer_state, consumer_zip_code)
VALUES ('Toru', 'Okada', '800 Glenridge Ave', 'Hobart', 'IN', '46343'),
('Kumiko', 'Okada', '864 NW Bohemia St', 'Vincentown', 'NJ', '08088'),
('Noboru', 'Wataya', '342 Joy Ridge St', 'Hermitage', 'TN', '37076'),
('May', 'Kasahara', '5 Kent Rd', 'East Haven', 'CT', '06512');

-- filling in ratings data
INSERT INTO Ratings (movie_id, consumer_id, when_rated, number_stars)
VALUES (1, 1, '2010-09-02 10:54:19', 4),
(1, 3, '2012-08-05 15:00:01', 3),
(1, 4, '2016-10-02 23:58:12', 1),
(2,	3, '2017-03-27 00:12:48', 2),
(2, 4, '2018-08-02 00:54:42', 4);


SELECT * FROM Movies;
SELECT * FROM Consumers;
SELECT * FROM Ratings;

-- generate a report for movies with genres
SELECT 
    Movies.movie_title, 
    GROUP_CONCAT(Genres.genre_name ORDER BY Genres.genre_name SEPARATOR ', ') AS genres
FROM 
    Movies
JOIN 
    Movie_Genres ON Movies.movie_id = Movie_Genres.movie_id
JOIN 
    Genres ON Movie_Genres.genre_id = Genres.genre_id
GROUP BY 
    Movies.movie_id;


/* Generate a report */
SELECT 
    consumer_first_name, 
    consumer_last_name, 
    movie_title, 
    GROUP_CONCAT(Genres.genre_name ORDER BY Genres.genre_name SEPARATOR ', ') AS genres,  -- List of genres
    number_stars
FROM 
    Movies
JOIN 
    Ratings ON Movies.movie_id = Ratings.movie_id
JOIN 
    Consumers ON Ratings.consumer_id = Consumers.consumer_id
JOIN 
    Movie_Genres ON Movies.movie_id = Movie_Genres.movie_id
JOIN 
    Genres ON Movie_Genres.genre_id = Genres.genre_id
GROUP BY 
    Movies.movie_id, Ratings.consumer_id;
