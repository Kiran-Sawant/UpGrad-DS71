USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT
TABLE_NAME, SUM(TABLE_ROWS)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'IMDB'
GROUP BY TABLE_NAME;

/*
'director_mapping', '3867'
'genre', '14662'
'movie', '8261'
'names', '25120'
'ratings', '8230'
'role_mapping', '15582'
*/


/*------------------------------------------------------------------------------------------------------------------*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select
(select count(*) from movie where id is NULL) as ID,
(select count(*) from movie where title is Null) as title,
(select count(*) from movie where movie.year is Null) as year,
(select count(*) from movie where country is Null) as country,
(select count(*) from movie where date_published is Null) as date_published,
(select count(*) from movie where duration is Null) as duration,
(select count(*) from movie where worlwide_gross_income is Null) as gross_income,
(select count(*) from movie where languages is Null) as languages,
(select count(*) from movie where production_company is Null) as production_company
;

/* Output
# ID, title, year, country, date_published, duration, gross_income, languages, production_company
-- '0', '0', '0', '20', '0', '0', '3724', '194', '528'
-- country, gross_income, languages and production_company has Null values.
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- For highest Number of movies per year

SELECT 
    movie.year, COUNT(movie.id)
FROM
    movie
GROUP BY movie.year;

-- The Year 2017 has seen highest number of movie releases i.e, 3052)

-- For highest Number of movies released across months in all years
SELECT
	MONTH(date_published) AS release_month,
	Count(*) AS movies_released
FROM
	movie
GROUP BY
	release_month
ORDER BY
	release_month;

/* Output
'1', '804'
'2', '640'
'3', '824'
'4', '680'
'5', '625'
'6', '580'
'7', '493'
'8', '678'
'9', '809'
'10', '801'
'11', '625'
'12', '438'
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT
	Count(DISTINCT id) AS number_of_movies,
    movie.year
FROM
	movie
WHERE
	(upper(country) LIKE '%INDIA%' OR upper(country) LIKE '%USA%' )
	AND movie.year = 2019;

-- Number of movies produced by USA or India in 2019 is "1059".


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre.genre from genre;

/*
'Drama'
'Fantasy'
'Thriller'
'Comedy'
'Horror'
'Family'
'Romance'
'Adventure'
'Action'
'Sci-Fi'
'Crime'
'Mystery'
'Others'
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT
	genre,
    count(DISTINCT movie.id) AS number_of_movies
FROM 
	movie
JOIN genre
	WHERE genre.movie_id = movie.id
GROUP BY genre
ORDER BY number_of_movies DESC;

-- The drama Genre has seen highest number of movie releases
	
/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT genre_count, 
       Count(movie_id) AS movie_count
FROM (SELECT movie_id, Count(genre) AS genre_count
      FROM genre
      GROUP BY movie_id
      ORDER BY genre_count DESC) AS genre_counts
WHERE genre_count = 1
GROUP BY genre_count;

-- 3289 movies have exactly one genre.

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
	genre,
	ROUND(AVG(duration), 2) AS average_duration
FROM
	movie AS mov
INNER JOIN
	genre as gen ON gen.movie_id = mov.id
GROUP BY
	genre
ORDER BY
	average_duration DESC;

/*
Action	112.88
Romance	109.53
Crime	107.05
Drama	106.77
Fantasy	105.14
Comedy	102.62
Adventure	101.87
Mystery	101.80
Thriller	101.58
Family	100.97
Others	100.16
Sci-Fi	97.94
Horror	92.72
*/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_summary AS
(
   SELECT  
      genre,
	  Count(movie_id) AS movie_count,
	  RANK() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
   FROM
		genre                                 
   GROUP BY
		genre)
SELECT *
FROM   genre_summary
WHERE  genre = "THRILLER" ;

/*
'Thriller', '1484', '3'
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select
	min(avg_rating) AS min_avg_rating,
    max(avg_rating) AS max_avg_rating,
    min(total_votes) AS min_total_votes,
    max(total_votes) AS max_total_Votes,
    min(median_rating) AS min_median_rating,
    max(median_rating) AS max_median_rating
FROM
	ratings;

/* Output
# min_avg_rating, max_avg_rating, min_total_votes, max_total_Votes, min_median_rating, max_median_rating
'1.0', '10.0', '100', '725138', '1', '10'
*/


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)
SELECT     
   title,
   avg_rating,
   Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM
	ratings AS rate
INNER JOIN
	movie AS mov ON mov.id = rate.movie_id
LIMIT 10;

/*
Kirket	10.0	1
Love in Kilnerry	10.0	1
Gini Helida Kathe	9.8	3
Runam	9.7	4
Fan	9.6	5
Android Kunjappan Version 5.25	9.6	5
Yeh Suhaagraat Impossible	9.5	7
Safe	9.5	7
The Brighton Miracle	9.5	7
Shibu	9.4	10
*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT
	median_rating,
    COUNT(movie_id) AS movie_count
FROM
	ratings
GROUP BY
	median_rating
ORDER BY
	median_rating ASC;

/* Output
# median_rating, movie_count
'1', '94'
'2', '119'
'3', '283'
'4', '479'
'5', '985'
'6', '1975'
'7', '2257'
'8', '1030'
'9', '429'
'10', '346'
*/


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
      COUNT(movie_id) AS movie_count, 
      Rank() OVER(ORDER BY Count(movie_id) DESC) AS prod_company_rank
FROM
	ratings AS rat
INNER JOIN movie AS mov
	ON mov.id = rat.movie_id
WHERE
	avg_rating > 8 AND production_company IS NOT NULL
GROUP BY
	production_company;

/* Output
# production_company, movie_count, prod_company_rank
'Dream Warrior Pictures', '3', '1'
'National Theatre Live', '3', '1'
'Lietuvos Kinostudija', '2', '3'
'Swadharm Entertainment', '2', '3'
'Panorama Studios', '2', '3'
'Marvel Studios', '2', '3'
*/
-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both
/*-------------------------------------------------------------------------------------------------------------------------------------*/

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
	genre,
	COUNT(mov.id) AS movie_count
FROM
	movie AS mov
JOIN genre AS gen
	ON gen.movie_id = mov.id
JOIN ratings AS rate
	ON rate.movie_id = mov.id
WHERE year = 2017
	  AND MONTH(date_published) = 3
	  AND country LIKE '%USA%'
	  AND total_votes > 1000
GROUP BY
	genre
ORDER BY
	movie_count DESC;

/* Output
Drama	24
Comedy	9
Action	8
Thriller	8
Sci-Fi	7
Crime	6
Horror	6
Mystery	4
Romance	4
Fantasy	3
Adventure	3
Family	1
*/


/*---------------------------------------------------------------------------------------------------------------------------------------*/
-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	title,
    avg_rating, genre
FROM
	movie AS mov
JOIN genre AS gen
	ON gen.movie_id = mov.id
JOIN ratings AS rat
	ON rat.movie_id = mov.id
WHERE
	avg_rating > 8 AND title LIKE 'THE%'
ORDER BY
	avg_rating DESC;

/* Output
# title, avg_rating, genre
'The Brighton Miracle', '9.5', 'Drama'
'The Colour of Darkness', '9.1', 'Drama'
'The Blue Elephant 2', '8.8', 'Drama'
'The Blue Elephant 2', '8.8', 'Horror'
'The Blue Elephant 2', '8.8', 'Mystery'
'The Irishman', '8.7', 'Crime'
'The Irishman', '8.7', 'Drama'
'The Mystery of Godliness: The Sequel', '8.5', 'Drama'
'The Gambinos', '8.4', 'Crime'
'The Gambinos', '8.4', 'Drama'
'Theeran Adhigaaram Ondru', '8.3', 'Action'
'Theeran Adhigaaram Ondru', '8.3', 'Crime'
'Theeran Adhigaaram Ondru', '8.3', 'Thriller'
'The King and I', '8.2', 'Drama'
'The King and I', '8.2', 'Romance'
*/

/*----------------------------------------------------------------------------------------------------------------------------------------------------*/
-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
	median_rating,
	Count(*) AS movie_count
FROM 
	movie AS mov
JOIN ratings AS rat
	ON rat.movie_id = mov.id
WHERE
	median_rating = 8 AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY
	median_rating;

/* Output
median_rating, movie_count
'8', '361'
*/

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
   country, 
   sum(total_votes)
FROM
	movie AS mov
JOIN ratings AS rat
	ON mov.id=rat.movie_id
WHERE
	LOWER(country) = 'germany' OR lower(country) = 'italy'
GROUP BY
	country;

/* Output
Germany	106710
Italy	77965
*/

-- Answer is Yes
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT SUM(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           END) AS name_null,
       SUM(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_null,
       SUM(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_null,
       SUM(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_null
FROM names;

/* Output
name_null, height_null, date_of_birth_null, known_for_movies_null
'0', '17335', '13431', '15226'
*/

/*----------------------------------------------------------------------------------------------------------------------------------------------------*/
/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_3_genres
AS (
    SELECT
		genre,
		COUNT(mov.id) AS movie_count,
		RANK() OVER(ORDER BY Count(mov.id) DESC) AS genre_rank
    FROM
		movie AS mov
	JOIN genre AS gen
		ON gen.movie_id = mov.id
	JOIN ratings AS rate
		ON rate.movie_id = mov.id
    WHERE
		avg_rating > 8
    GROUP BY
		genre limit 3)
SELECT
    nam.NAME AS director_name,
	COUNT(dm.movie_id) AS movie_count
FROM
	director_mapping AS dm
JOIN genre AS gen USING (movie_id)
JOIN names AS nam
	ON nam.id = dm.name_id
JOIN top_3_genres USING (genre)
JOIN ratings USING (movie_id)
WHERE 
	avg_rating > 8
GROUP BY
	name
ORDER BY
	movie_count DESC LIMIT 3 ;

/* Output
director_name, movie_count
'James Mangold', '4'
'Anthony Russo', '3'
'Soubin Shahir', '3'
*/

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
	nam.name AS actor_name,
	COUNT(movie_id) AS movie_count
FROM
	role_mapping AS rol
JOIN movie AS mov
	ON mov.id = rol.movie_id
JOIN ratings AS rate USING(movie_id)
JOIN names AS nam
	ON nam.id = rol.name_id
WHERE
	rate.median_rating >= 8 AND category = 'actor'
GROUP BY
	actor_name
ORDER BY
	movie_count DESC LIMIT 2;

/* Output
actor_name, movie_count
'Mammootty', '8'
'Mohanlal', '5'
*/

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
   production_company,
   Sum(total_votes) AS vote_count,
   Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM
	movie AS mov
JOIN ratings AS rate
	ON rate.movie_id = mov.id
GROUP BY
	production_company LIMIT 3;

/* Output
# production_company, vote_count, prod_comp_rank
'Marvel Studios', '2656967', '1'
'Twentieth Century Fox', '2411163', '2'
'Warner Bros.', '2396057', '3'
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_summary
     AS (SELECT 
			n.name AS actor_name,
			SUM(total_votes),
			Count(rate.movie_id) AS movie_count,
			Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
		FROM 
			movie AS mov
		INNER JOIN ratings AS rate
			ON mov.id = rate.movie_id
		INNER JOIN role_mapping AS rm
			ON mov.id = rm.movie_id
		INNER JOIN names AS n
			ON rm.name_id = n.id
		WHERE
			category = 'actor' AND country = "india"
		GROUP BY
			actor_name
		HAVING
			movie_count >= 5)
SELECT *,
       Rank() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM actor_summary;

/* Output
# actor_name, SUM(total_votes), movie_count, actor_avg_rating, actor_rank
'Vijay Sethupathi', '23114', '5', '8.42', '1'
'Fahadh Faasil', '13557', '5', '7.99', '2'
'Yogi Babu', '8500', '11', '7.83', '3'
'Joju George', '3926', '5', '7.58', '4'
'Ammy Virk', '2504', '6', '7.55', '5'
'Dileesh Pothan', '6235', '5', '7.52', '6'
'Kunchacko Boban', '5628', '6', '7.48', '7'
'Pankaj Tripathi', '40728', '5', '7.44', '8'
'Rajkummar Rao', '42560', '6', '7.37', '9'
'Dulquer Salmaan', '17666', '5', '7.30', '10'
'Amit Sadh', '13355', '5', '7.21', '11'
'Tovino Thomas', '11596', '8', '7.15', '12'
'Mammootty', '12613', '8', '7.04', '13'
'Nassar', '4016', '5', '7.03', '14'
'Karamjit Anmol', '1970', '6', '6.91', '15'
'Hareesh Kanaran', '3196', '5', '6.58', '16'
'Naseeruddin Shah', '12604', '5', '6.54', '17'
'Anandraj', '2750', '6', '6.54', '17'
'Mohanlal', '17244', '6', '6.51', '19'
'Siddique', '5953', '7', '6.43', '20'
'Aju Varghese', '2237', '5', '6.43', '20'
'Prakash Raj', '8548', '6', '6.37', '22'
'Jimmy Sheirgill', '3826', '6', '6.29', '23'
'Mahesh Achanta', '2716', '6', '6.21', '24'
'Biju Menon', '1916', '5', '6.21', '24'
'Suraj Venjaramoodu', '4284', '6', '6.19', '26'
'Abir Chatterjee', '1413', '5', '5.80', '27'
'Sunny Deol', '4594', '5', '5.71', '28'
'Radha Ravi', '1483', '5', '5.70', '29'
'Prabhu Deva', '2044', '5', '5.68', '30'
*/

-- Top actor is Vijay Sethupathi

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_summary
     AS (SELECT 
			n.name AS actress_name,
			SUM(total_votes),
			Count(rate.movie_id) AS movie_count,
			Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actess_avg_rating
		FROM 
			movie AS mov
		INNER JOIN ratings AS rate
			ON mov.id = rate.movie_id
		INNER JOIN role_mapping AS rm
			ON mov.id = rm.movie_id
		INNER JOIN names AS n
			ON rm.name_id = n.id
		WHERE
			category = 'actress' AND country = "india" AND languages LIKE "%HINDI%"
		GROUP BY
			actor_name
		HAVING
			movie_count >= 3)
SELECT *,
       Rank() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM actor_summary;

/*Output
# actor_name, SUM(total_votes), movie_count, actor_avg_rating, actor_rank
'Taapsee Pannu', '18061', '3', '7.74', '1'
'Kriti Sanon', '21967', '3', '7.05', '2'
'Divya Dutta', '8579', '3', '6.88', '3'
'Shraddha Kapoor', '26779', '3', '6.63', '4'
'Kriti Kharbanda', '2549', '3', '4.80', '5'
'Sonakshi Sinha', '4025', '4', '4.18', '6'

*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
---------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
with thriller_movies as (
    SELECT  
       DISTINCT title AS movie_name,
       avg_rating
    FROM
		movie AS mov
	JOIN ratings AS rate
         ON mov.id = rate.movie_id
	JOIN genre AS gen
		ON gen.movie_id = mov.id
	WHERE
		genre LIKE 'THRILLER'
	)
SELECT 
    movie_name,
    CASE
        WHEN avg_rating > 8 THEN 'superhit movie'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'one-time-watch movie'
        ELSE 'Flop movie'
    END AS movie_category
FROM
    thriller_movies;

/* Output
# movie_name, movie_category
'Der müde Tod', 'Hit movie'
'Fahrenheit 451', 'Flop movie'
'Pet Sematary', 'one-time-watch movie'
'Dukun', 'one-time-watch movie'
'Back Roads', 'Hit movie'
'Countdown', 'one-time-watch movie'
'Staged Killer', 'Flop movie'
'Vellaipookal', 'Hit movie'
'Uriyadi 2', 'Hit movie'
'Incitement', 'Hit movie'
'Rakshasudu', 'superhit movie'
...
*/

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
	genre,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    ROUND(AVG(AVG(duration)) OVER(ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration
FROM
	movie AS mov
INNER JOIN genre AS g 
	ON m.id= g.movie_id
GROUP BY
	genre
ORDER BY
	genre;

/* Output
# genre, avg_duration, running_total_duration, moving_avg_duration
'Action', '112.88', '112.88', '112.88'
'Adventure', '101.87', '214.75', '107.38'
'Comedy', '102.62', '317.37', '105.79'
'Crime', '107.05', '424.42', '106.11'
'Drama', '106.77', '531.19', '106.24'
'Family', '100.97', '632.16', '105.36'
'Fantasy', '105.14', '737.30', '105.33'
'Horror', '92.72', '830.02', '103.75'
'Mystery', '101.80', '931.82', '103.54'
'Others', '100.16', '1031.98', '103.20'
'Romance', '109.53', '1141.51', '103.78'
'Sci-Fi', '97.94', '1239.45', '102.42'
'Thriller', '101.58', '1341.03', '102.39'
*/


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_3_genres AS(
		SELECT
			genre,
			Count(m.id) AS movie_count ,
			Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
		FROM movie AS m
			INNER JOIN genre AS g
				ON g.movie_id = m.id
			INNER JOIN ratings AS r
				ON r.movie_id = m.id
		GROUP BY
			genre limit 3 
		),
		movie_summary AS(
			SELECT
				genre,
                year,
                title AS movie_name,
                CAST(REPLACE(REPLACE(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) AS worlwide_gross_income,
                RANK() OVER(PARTITION BY YEAR ORDER BY CAST(REPLACE(REPLACE(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10))  DESC ) AS movie_rank
			FROM
				movie AS m
			JOIN genre AS g
					ON m.id = g.movie_id
			WHERE
				genre IN ( SELECT genre FROM top_3_genres)
			)
SELECT
	*
FROM
	movie_summary
WHERE
	movie_rank <= 5
ORDER BY
	year;
/* Output
# genre, year, movie_name, worlwide_gross_income, movie_rank
'Thriller', '2017', 'The Fate of the Furious', '1236005118', '1'
'Comedy', '2017', 'Despicable Me 3', '1034799409', '2'
'Comedy', '2017', 'Jumanji: Welcome to the Jungle', '962102237', '3'
'Drama', '2017', 'Zhan lang II', '870325439', '4'
'Thriller', '2017', 'Zhan lang II', '870325439', '4'
'Thriller', '2018', 'The Villain', '1300000000', '1'
'Drama', '2018', 'Bohemian Rhapsody', '903655259', '2'
'Thriller', '2018', 'Venom', '856085151', '3'
'Thriller', '2018', 'Mission: Impossible - Fallout', '791115104', '4'
'Comedy', '2018', 'Deadpool 2', '785046920', '5'
'Drama', '2019', 'Avengers: Endgame', '2797800564', '1'
'Drama', '2019', 'The Lion King', '1655156910', '2'
'Comedy', '2019', 'Toy Story 4', '1073168585', '3'
'Drama', '2019', 'Joker', '995064593', '4'
'Thriller', '2019', 'Joker', '995064593', '4'
*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- Top 3 Genres based on most number of movies

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_detail AS (
		SELECT
			production_company,
			Count(id) AS movie_count
        FROM
			movie AS mov
        JOIN ratings AS rate ON rate.movie_id = mov.id
        WHERE
			median_rating >= 8 AND production_company IS NOT NULL AND Position(',' IN languages) > 0
        GROUP BY
			production_company
        ORDER BY
			movie_count DESC
		)
SELECT *,
       Rank() OVER( ORDER BY movie_count DESC) AS prod_comp_rank
FROM
	production_company_detail LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language
/*Output
# production_company, movie_count, prod_comp_rank
'Star Cinema', '7', '1'
'Twentieth Century Fox', '4', '2'
*/

-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
WITH actress_summary AS (
		SELECT
			n.name AS actress_name,
            SUM(total_votes) AS total_votes,
			Count(r.movie_id) AS movie_count,
            Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
		FROM
			movie AS m
        JOIN ratings AS r
			ON m.id=r.movie_id
		JOIN role_mapping AS rm
            ON m.id = rm.movie_id
        JOIN names AS n
		   ON rm.name_id = n.id
        JOIN GENRE AS g
           ON g.movie_id = m.id
		WHERE
			lower(category) = 'actress' AND avg_rating > 8 AND lower(genre) = "drama"
		GROUP BY
			movie.name
		)
SELECT *,
	   Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM
	actress_summary LIMIT 3;

/* Output
# actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
'Parvathy Thiruvothu', '4974', '2', '8.25', '1'
'Susan Brown', '656', '2', '8.94', '1'
'Amanda Lawrence', '656', '2', '8.94', '1'
*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_detail AS(
	SELECT
		dir.name_id,
        name,
        dir.movie_id,
        duration,
        rate.avg_rating,
        total_votes,
        m.date_published,
        Lead(date_published,1) OVER(partition BY dir.name_id ORDER BY date_published,movie_id ) AS next_date_published
    FROM director_mapping AS dir
		INNER JOIN names AS n
			ON n.id = dir.name_id
		INNER JOIN movie AS m
			ON m.id = dir.movie_id
		INNER JOIN ratings AS rate
			ON rate.movie_id = m.id ), top_director_summary AS(
										SELECT
											*,
											Datediff(next_date_published, date_published) AS date_difference
										FROM
											next_date_published_detail
                                        )
SELECT
	name_id AS director_id,
    name AS director_name,
    Count(movie_id) AS number_of_movies,
	Round(AVG(date_difference),2) AS avg_inter_movie_days,
	Round(AVG(avg_rating),2) AS avg_rating,
	Sum(total_votes) AS total_votes,
    Min(avg_rating) AS min_rating,
    Max(avg_rating) AS max_rating,
    Sum(duration) AS total_duration
FROM
	top_director_summary
GROUP BY
	director_id
ORDER BY
	Count(movie_id) DESC LIMIT 9;

/* Output
# director_id, director_name, number_of_movies, avg_inter_movie_days, avg_rating, total_votes, min_rating, max_rating, total_duration
'nm2096009', 'Andrew Jones', '5', '190.75', '3.02', '1989', '2.7', '3.2', '432'
'nm1777967', 'A.L. Vijay', '5', '176.75', '5.42', '1754', '3.7', '6.9', '613'
'nm0814469', 'Sion Sono', '4', '331.00', '6.03', '2972', '5.4', '6.4', '502'
'nm0831321', 'Chris Stokes', '4', '198.33', '4.33', '3664', '4.0', '4.6', '352'
'nm0515005', 'Sam Liu', '4', '260.33', '6.23', '28557', '5.8', '6.7', '312'
'nm0001752', 'Steven Soderbergh', '4', '254.33', '6.48', '171684', '6.2', '7.0', '401'
'nm0425364', 'Jesse V. Johnson', '4', '299.00', '5.45', '14778', '4.2', '6.5', '383'
'nm2691863', 'Justin Price', '4', '315.00', '4.50', '5343', '3.0', '5.8', '346'
'nm6356309', 'Özgür Bakar', '4', '112.00', '3.75', '1092', '3.1', '4.9', '374'
*/
