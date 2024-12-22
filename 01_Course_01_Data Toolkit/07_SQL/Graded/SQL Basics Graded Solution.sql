-- Graded 2
-- Q1) Write a query to find the full name of the actor who has acted in the maximum number of movies.
-- My annswer
select concat(first_name, " ", last_name) as full_name, sum(film_id)
from actor as a inner join film_actor as fa
on a.actor_id = fa.actor_id
group by fa.actor_id
order by sum(film_id) desc
limit 1;

-- Right Answer
-- I used SUM() instead of COUNT(). SUM will add two numerical film_ids i.e. 1004 + 1006 = 2010 films!
SELECT concat(first_name, " ", last_name) as full_name
FROM actor as a JOIN film_actor as fa
ON a.actor_id = fa.actor_id
GROUP BY full_name
ORDER BY COUNT(fa.film_id) DESC
LIMIT 1;

-- Q) Write a query to find the full name of the actor who has acted in the third most number of movies.
SELECT concat(first_name, " ", last_name) as full_name
FROM actor as a JOIN film_actor as fa
ON a.actor_id = fa.actor_id
GROUP BY full_name
ORDER BY COUNT(fa.film_id) DESC
LIMIT 1 offset 2;

-- Q) Write a query to find the film which grossed the highest revenue for the video renting organisation.
SELECT 
	f.title,
    SUM(p.amount) AS total_revenue
FROM
	payment as p 
JOIN 
	rental as r ON p.rental_id = r.rental_id
JOIN
	inventory as i ON r.inventory_id = i.inventory_id
JOIN
	film as f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY total_revenue DESC
LIMIT 1;

-- Q) Write a query to find the city which generated the maximum revenue for the organisation.
SELECT city
FROM payment as p
JOIN
	rental as r ON p.rental_id = r.rental_id
JOIN
	customer as cus ON r.customer_id = cus.customer_id
JOIN
	address as adr ON cus.address_id = adr.address_id
JOIN
	city as ct ON adr.city_id = ct.city_id
GROUP BY ct.city
ORDER BY SUM(p.amount) desc
limit 1;

-- Right Answer
SELECT
    city
FROM 
    payment as p
JOIN
	customer as cus ON p.customer_id = cus.customer_id
JOIN
	address as adr ON cus.address_id = adr.address_id
JOIN
	city as ct ON adr.city_id = ct.city_id
GROUP BY ct.city
ORDER BY SUM(p.amount) desc
limit 1;

-- Q) Write a query to find out how many times a particular movie category is rented.
-- Arrange these categories in the decreasing order of the number of times they are rented.
select
	name, count(rental_date) as Rental_count
from
	rental as r
JOIN
	inventory as inv ON r.inventory_id = inv.inventory_id
JOIN
	film as flm ON inv.film_id = flm.film_id
JOIN
	film_category as flmc ON flm.film_id = flmc.film_id
JOIN
	category as cat ON flmc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY Rental_count desc;

-- Q) Write a query to find the full names of customers who have rented sci-fi movies more than 2 times.
-- Arrange these names in the alphabetical order.
SELECT
	concat(cus.first_name, " ", cus.last_name) AS Customer_name
FROM
	customer as cus
JOIN
	rental as rnt ON cus.customer_id = rnt.customer_id
JOIN
	inventory as inv ON rnt.inventory_id = inv.inventory_id
JOIN
	film as flm ON inv.film_id = flm.film_id
JOIN
	film_category as fc ON flm.film_id = fc.film_id
JOIN
	category as cat ON fc.category_id = cat.category_id
WHERE
	cat.name = "sci-fi"
GROUP BY
	Customer_name
HAVING
	COUNT(rnt.rental_id) > 2
ORDER BY
	Customer_name;
    
    
-- Q) Write a query to find the full names of those customers who have rented at least one movie
-- and belong to the city Arlington.

select
	DISTINCT concat(cus.first_name, " ", last_name)
from
	city as ct
JOIN
	address as ad ON ct.city_id = ad.city_id
JOIN
	customer as cus ON ad.address_id = cus.address_id
JOIN
	rental as rnt ON cus.customer_id = rnt.customer_id
WHERE
	ct.city = "Arlington";

-- Q) Write a query to find the number of movies rented across each country.
-- Display only those countries where at least one movie was rented.
-- Arrange these countries in the alphabetical order.

select
	ctr.country, count(rnt.rental_id) as Rental_count
from
	country as ctr
JOIN
	city as ct ON ctr.country_id = ct.country_id
JOIN
	address as ad ON ct.city_id = ad.city_id
JOIN
	customer as cus ON ad.address_id = cus.address_id
JOIN
	rental as rnt ON cus.customer_id = rnt.customer_id
GROUP BY 
	ctr.country
HAVING
	Rental_count > 0
order by
	ctr.country;
	

-- select COUNT('sci-fi') from category;
    
    
    
    
    
    























