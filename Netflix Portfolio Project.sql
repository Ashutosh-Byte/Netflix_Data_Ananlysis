--NETFLIX DATA ANALYSIS
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;

select distinct type 
from netflix;
-- 15 Business problem

--1.Count total no. of tv shows and Movies
select type,count(title) as total_content
from netflix
group by type;

--2.Find the most common rating for movies and TV shows
select * from 
(select *, rank() over(partition by type order by cnt desc ) rnk from 
(select type,rating,count(rating) as cnt 
from netflix
group by rating,type
order by count(rating) desc))
where rnk = 1;
--3. List all movies released in a specific year (e.g., 2020)	
select * from netflix
where type = 'Movie'
and release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
select   unnest(string_to_array(country, ',')) as new_country , count(type)
from Netflix
group by new_country
order by count(type) desc
limit 5 ;

--5. Identify the longest movie?
select * from netflix
where type = 'Movie'
and duration = (select max(duration) from Netflix);

--6. Find content added in the last 5 years
select * 
from Netflix
where  to_date(date_added, 'Month DD, YYYY')>=current_date - interval '5 years';

--7 Find all the movies/TV shows by director 'Rajil Chilaka'!/
select *
from netflix
where director like '%Rajiv Chilaka%';

--8 List all TV shows with more than 5 seasons
select *
from Netflix
where 
type = 'TV Show' 
and 
split_part(duration ,' ', 1 ):: numeric > 5 ;

--9 Count the number of content items in each genre
select unnest(string_to_array(listed_in, ', ')) as genre , count(title)
from netflix 
group by genre
order by count(title) desc;

--10. Find each year and the average numbers of content release by India on netflix.
--return top 5 year with highest avg content release !
SELECT
EXTRACT (YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
COUNT (*),
COUNT (*) :: numeric/(SELECT COUNT (*)FROM netflix WHERE country = 'India') ::numeric * 100 as avg_content_per_year
from netflix 
where country = 'India'
group by year;

--11.list all movies that ara documentaries
select title , type,listed_in
from netflix
where listed_in like '%Documentaries%'
and type = 'Movie';

--12. Find all content without a director
select * from netflix
where director is null;

--13 Find how many movie actor Salman Khan appeared in last 10 yrs
select * 
from Netflix
where casts ilike '%salman khan%'
and type = 'Movie'
and release_year>Extract(year from current_date)-10;

--14.Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT
UNNEST (STRING_TO_ARRAY (casts, ',')) as actors,
COUNT (*) as total_content
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

