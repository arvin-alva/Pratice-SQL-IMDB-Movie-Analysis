USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- there are two ways to solve this 
-- 1) we can take count of the table individually 
-- 2)  or we can fetch the names from information schema and sum the table row to get the count

-- apprach 1 solution


SELECT Count(*) FROM director_mapping;
-- No. of rows: 3867

SELECT Count(*) FROM genre;
-- No. of rows: 14662

SELECT Count(*) FROM  names;
-- No. of rows: 25735

SELECT Count(*) FROM  ratings;
-- No. of rows: 7997

SELECT Count(*) FROM  role_mapping;
-- No. of rows: 15615


-- approach 2 solution 
SELECT
TABLE_NAME, SUM(TABLE_ROWS)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'IMDB'
GROUP BY TABLE_NAME;

-- director_mapping	    3867
-- genre	            14662
-- movie	            8344
-- names	            23934
-- ratings	            8230
-- role_mapping	        15158




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

--  there are 2 ways to solve this one also 

-- approach 1
SELECT
(SELECT count(*) FROM movie WHERE id is NULL) as id,
(SELECT count(*) FROM movie WHERE title is NULL) as title,
(SELECT count(*) FROM movie WHERE year  is NULL) as year,
(SELECT count(*) FROM movie WHERE date_published  is NULL) as date_published,
(SELECT count(*) FROM movie WHERE duration  is NULL) as duration,
(SELECT count(*) FROM movie WHERE country  is NULL) as year, 
(SELECT count(*) FROM movie WHERE worlwide_gross_income  is NULL) as worlwide_gross_income,
(SELECT count(*) FROM movie WHERE languages  is NULL) as languages,
(SELECT count(*) FROM movie WHERE production_company  is NULL) as production_company
;

-- approach 2

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS id_null,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_null,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_null,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_null,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_null,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_null,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_null,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_null,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_null
FROM movie;

-- found null in below given columns ( count mentioned) 
-- year 20
-- worlwide_gross_income  3724
-- languages 194
-- production_company 528




-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
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

SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;
--  In Year 2017 highest no. of movies were released i.e, 3052)

-- Number of movies released each month 
SELECT Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

-- March has highest and December has least no. of films released.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- country like india lower and upper format

SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( upper(country) LIKE '%INDIA%'
          OR upper(country) LIKE '%USA%' )
       AND year = 2019; 

-- Number of movies produced by USA or India for the last year i.e, 2019 is "1059".





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre FROM   genre; 





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT     genre,
           Count(mov.id) AS number_of_movies
FROM       movie       AS mov
INNER JOIN genre       AS gen
where      gen.movie_id = mov.id
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;


-- Drama genre had the highest movies produced overall i.e, 4285.





/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT genre_count, 
       Count(movie_id) movie_count
FROM (SELECT movie_id, Count(genre) genre_count
      FROM genre
      GROUP BY movie_id
      ORDER BY genre_count DESC) genre_counts
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
SELECT     genre,
           Round(Avg(duration),2) AS avg_duration
FROM       movie as mov
INNER JOIN genre as gen
ON      gen.movie_id = mov.id
GROUP BY   genre
ORDER BY avg_duration DESC;


--  Duration of Action movies is highest with duration of 112.88 mins whereas Horror movies have least with duration 92.72 mins.



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
	  Count(movie_id)                            AS movie_count ,
	  Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
   FROM       genre                                 
   GROUP BY   genre 
   )
SELECT *
FROM   genre_summary
WHERE  genre = "THRILLER" ;



-- Thriller genre has 3rd rank with 1484 movies.





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

SELECT 
   Min(avg_rating)    AS min_avg_rating,
   Max(avg_rating)    AS max_avg_rating,
   Min(total_votes)   AS min_total_votes,
   Max(total_votes)   AS max_total_votes,
   Min(median_rating) AS min_median_rating,
   Max(median_rating) AS min_median_rating
FROM   ratings; 




    

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
-- It's ok if RANK() or DENSE_RANK() is used too

-- Finding the rank of each movie based on it's average rating
-- Displaying the top 10 movies using LIMIT clause
SELECT     
   title,
   avg_rating,
   Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       ratings AS rat
INNER JOIN movie   AS mov
ON         mov.id = rat.movie_id limit 10;



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

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
      Count(movie_id) AS movie_count, 
      Rank() OVER( ORDER BY Count(movie_id) DESC ) AS prod_company_rank
FROM ratings AS rat
     INNER JOIN movie AS mov
     ON mov.id = rat.movie_id
WHERE avg_rating > 8
     AND production_company IS NOT NULL
GROUP BY production_company;


-- Dream Warrior Pictures and National Theatre Live production both have the most number of hit movies i.e, 3 movies with average rating > 8




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

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



SELECT genre,
       Count(mov.id) AS movie_count
FROM movie AS mov
     INNER JOIN genre AS gen
           ON gen.movie_id = mov.id
     INNER JOIN ratings AS rat
           ON rat.movie_id = mov.id
WHERE year = 2017
	  AND Month(date_published) = 3
	  AND country LIKE '%USA%'
	  AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;


--  Query covers all conditions mentioned i.e, Month= Mar, Year = 2017, Country = USA and Votes > 1000. 
-- Drama genre had the maximum no. of releases with 24 movies whereas Family genre was least with 1 movie only.



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


SELECT title, avg_rating, genre
FROM movie AS mov
     INNER JOIN genre AS gen
           ON gen.movie_id = mov.id
     INNER JOIN ratings AS rat
               ON rat.movie_id = mov.id
WHERE avg_rating > 8
	  AND title LIKE 'THE%'
ORDER BY avg_rating DESC;

--  There are 8 movies that start with the word ‘The’ and which have an average rating > 8.
-- we can group by title if we don't want repeatation in movie name.









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
   median_rating,
Count(*) AS movie_count
FROM movie AS mov INNER JOIN 
     ratings AS rat ON rat.movie_id = mov.id
WHERE median_rating = 8
	  AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- There are 361 movies that released between 1 April 2018 and 1 April 2019 and were given a median rating of 8.





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
   country, 
   sum(total_votes) as total_votes
FROM movie AS mov
	INNER JOIN ratings as rat
          ON mov.id=rat.movie_id
WHERE lower(country) = 'germany' or lower(country) = 'italy'
GROUP BY country;

-- From the output we can see that German movies have more votes than Italian movies. 
-- country  total_votes
-- Germany	106710
-- Italy	77965



-- Answer is Yes

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

SELECT Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           END) AS name_null,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_null,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_null,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_null
FROM names;

-- null result

-- name                 0  
-- height 				17335
-- date_of_birth 	    13431	
-- known_for_movie		15226






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
-- rank over top 3 mvie and dorector
-- use rank


WITH top_3_genres
AS (
    SELECT genre,
	   Count(mov.id) AS movie_count ,
	   Rank() OVER(ORDER BY Count(mov.id) DESC) AS genre_rank
    FROM movie AS mov
	   INNER JOIN genre AS gen
			 ON gen.movie_id = mov.id
	   INNER JOIN ratings AS rat
			 ON rat.movie_id = mov.id  
    WHERE avg_rating > 8
    GROUP BY genre limit 3 
    )
SELECT 
    nam.NAME AS director_name ,
	Count(dm.movie_id) AS movie_count
FROM director_mapping AS dm
       INNER JOIN genre gen using (movie_id)
       INNER JOIN names AS nam
       ON nam.id = dm.name_id
       INNER JOIN top_3_genres using (genre)
       INNER JOIN ratings using (movie_id)
WHERE avg_rating > 8
GROUP BY name
ORDER BY movie_count DESC limit 3 ;

-- top 3 meniotned below with movie count
-- James Mangold	4
-- Anthony Russo	3
-- Soubin Shahir	3







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
       Count(movie_id) AS movie_count
FROM role_mapping AS rm
       INNER JOIN movie AS mov
             ON mov.id = rm.movie_id
       INNER JOIN ratings AS rat USING(movie_id)
       INNER JOIN names AS nam
             ON nam.id = rm.name_id
WHERE rat.median_rating >= 8
	  AND category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC LIMIT 2;

-- top two actor below with movie_count 
-- Mammootty	8
-- Mohanlal	5








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
FROM movie AS mov
INNER JOIN ratings AS rat
	  ON rat.movie_id = mov.id
GROUP BY production_company LIMIT 3;

-- Marvel Studios, Twentieth Century Fox and Warner Bros are top three production houses based on the number of votes received by their movies.






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
     AS (SELECT n.name AS actor_name, total_votes,
                Count(R.movie_id) AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
         FROM movie AS m
                INNER JOIN ratings AS r
                      ON m.id = r.movie_id
                INNER JOIN role_mapping AS rm
					  ON m.id = rm.movie_id
                INNER JOIN names AS n
                        ON rm.name_id = n.id
         WHERE category = 'actor'
                AND country = "india"
         GROUP BY name
         HAVING movie_count >= 5)
SELECT *,
       Rank() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM actor_summary;

--  Vijay Sethupathi, Fahadh Faasil and Yogi Babu are top 3 actors in respective order. 




-- Top actor is Vijay Sethupathi

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


WITH actress_detail
	 AS(
       SELECT 
          n.name AS actress_name, total_votes,
		  Count(r.movie_id) AS movie_count,
		  Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
        FROM movie AS m
             INNER JOIN ratings AS r
                   ON m.id=r.movie_id
			 INNER JOIN role_mapping AS rm
                   ON m.id = rm.movie_id
			 INNER JOIN names AS n
                   ON rm.name_id = n.id
	    WHERE Upper(category) = 'ACTRESS'
              AND Upper(country) = "INDIA"
              AND Upper(languages) LIKE '%HINDI%'
	   GROUP BY name
	   HAVING movie_count>=3 
       )
SELECT *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM actress_detail LIMIT 5;






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
with thriller_movies as (
    select  
       distinct title, 
       avg_rating
    from movie as mov inner join ratings as rat
         on mov.id = rat.movie_id 
         inner join genre as gen on gen.movie_id = mov.id
	where genre like 'THRILLER')
select *, 
       case 
         when avg_rating > 8 then 'superhit movies'
         when avg_rating between 7 and 8  then 'Hit movies'
         when avg_rating between 5 and 7 then 'one-time-watch movies'
         else 'Flop movies'
		end as avg_rating_category
from thriller_movies ;
  

-- If we go about taking the counts for each category
-- Rating category        counts  
-- Hit movies	            166
-- Flop movies	            492
-- one-time-watch movies	785
-- superhit movies	         39




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


SELECT genre,
       ROUND(AVG(duration),2) AS avg_duration,
       SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
       ROUND(AVG(AVG(duration)) OVER(ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;









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

-- Top 3 Genres based on most number of movies

WITH top_3_genres 
     AS( SELECT genre,
                Count(m.id) AS movie_count ,
                Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
         FROM movie AS m
              INNER JOIN genre AS g
                     ON g.movie_id = m.id
              INNER JOIN ratings AS r
                     ON r.movie_id = m.id
         GROUP BY genre limit 3 ), movie_summary 
     AS( SELECT genre, year,
                title AS movie_name,
                CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
         FROM movie AS m
              INNER JOIN genre AS g
                    ON m.id = g.movie_id
         WHERE genre IN
         ( SELECT genre FROM top_3_genres)
         GROUP BY   movie_name
          )
SELECT * FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR;

-- Query will give 5 highest-grossing movies of each year from top 3 genres based on total no. of movies. 


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



WITH production_company_detail
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM movie AS mov
                INNER JOIN ratings AS rat
		      ON rat.movie_id = mov.id
         WHERE median_rating >= 8
	       AND production_company IS NOT NULL
               AND Position(',' IN languages) > 0
         GROUP BY production_company
         ORDER BY movie_count DESC)
SELECT *,
       Rank() over( ORDER BY movie_count DESC) AS prod_comp_rank
FROM production_company_detail LIMIT 2;

-- Star Cinema and Twentieth Century Fox are the top 2 production houses that have produced the highest number of hits.



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary 
     AS( SELECT n.name AS actress_name,
                SUM(total_votes) AS total_votes,
		Count(r.movie_id) AS movie_count,
                Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
	FROM movie AS m
             INNER JOIN ratings AS r
                   ON m.id=r.movie_id
             INNER JOIN role_mapping AS rm
                   ON m.id = rm.movie_id
             INNER JOIN names AS n
		   ON rm.name_id = n.id
             INNER JOIN GENRE AS g
                  ON g.movie_id = m.id
	WHERE lower(category) = 'actress'
              AND avg_rating>8
              AND lower(genre) = "drama"
	GROUP BY name )
SELECT *,
	   Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM actress_summary LIMIT 3;


-- Parvathy Thiruvothu, Susan Brown and Amanda Lawrence are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre.


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

WITH next_date_published_detail
     AS( SELECT d.name_id, name, d.movie_id, duration, r.avg_rating, total_votes, m.date_published,
                Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
          FROM director_mapping                                                                      AS d
               INNER JOIN names                                                                                 AS n
                     ON n.id = d.name_id
               INNER JOIN movie AS m
                     ON m.id = d.movie_id
               INNER JOIN ratings AS r
                     ON r.movie_id = m.id ), top_director_summary AS
( SELECT *,
         Datediff(next_date_published, date_published) AS date_difference
  FROM   next_date_published_detail )
SELECT   name_id AS director_id,
         name AS director_name,
         Count(movie_id) AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating) AS min_rating,
         Max(avg_rating) AS max_rating,
         Sum(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;








