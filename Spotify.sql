--For this project I downloaded the Spodify data from kaggle

--I then created a table to insert the downloaded data into

--After uploading the data I performed analysis on the data using SQL

CREATE TABLE Spotifydata (
id integer PRIMARY KEY,
artist_name varchar NOT NULL,
track_name varchar NOT NULL,
track_id varchar NOT NULL,
popularity integer NOT NULL,
danceability decimal(4,3) NOT NULL,
energy decimal(4,3) NOT NULL,
key integer NOT NULL,
loudness decimal(5,3) NOT NULL,
mode integer NOT NULL,
speechiness decimal(5,4) NOT NULL,
acousticness decimal(6,5) NOT NULL,
instrumentalness text NOT NULL,
liveness decimal(5,4) NOT NULL,
valence decimal(4,3) NOT NULL,
tempo decimal(6,3) NOT NULL,
duration_ms integer NOT NULL,
time_signature integer NOT NULL 
);

--After creating the table I uploaded the csv data into the table

-- I performed analysis on my data using the following SQL queries 

--Selecting all spotify data
SELECT * 
FROM Spotifydata;

--What is the average danceability by artist and list them in descending order? 
SELECT artist_name, AVG(danceability) as Avg_danceabilty
FROM Spotifydata
GROUP BY artist_name
ORDER BY AVG(danceability) DESC;

--Who are the top 5 artists based on popularity?
SELECT artist_name, popularity 
FROM Spotifydata s 
ORDER BY popularity DESC 
LIMIT 5;

-- What 3 artists released the longest songs?
SELECT artist_name, duration_ms 
FROM Spotifydata s
ORDER BY duration_ms DESC 
LIMIT 3; 

--What's the average danceability for the 10 most popular songs?
SELECT track_name, AVG(danceability), popularity  
FROM Spotifydata s
GROUP BY track_name 
ORDER BY popularity DESC
LIMIT 10;

--What's the average danceability for the 10 least popular songs?
SELECT track_name, AVG(danceability), popularity  
FROM Spotifydata s
GROUP BY track_name 
ORDER BY popularity ASC 
LIMIT 10;

