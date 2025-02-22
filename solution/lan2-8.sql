-- lab sql 2.8
USE sakila;

-- Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, c.city, co.country
FROM sakila.store s
JOIN sakila.address a
USING (address_id)
JOIN sakila.city c
USING (city_id)
JOIN sakila.country co
USING(country_id);

-- Write a query to display how much business, in dollars, each store brought in.

SELECT SUM(p.amount) as total_amount_dollars, st.store_id
FROM sakila.store as s
JOIN sakila.staff as st
USING (store_id)
JOIN sakila.payment as p
USING (staff_id)
GROUP BY st.store_id;

-- Out: total amount dollars 33489.47 store 1 and 33927.04 in store 2

-- Which film categories are longest?

SELECT * FROM film;

SELECT MAX(f.length) as longest, c.name
FROM sakila.category as c
JOIN sakila.film_category as fc
USING (category_id)
JOIN sakila.film as f
USING (film_id)
GROUP BY c.name
ORDER BY longest DESC;

SELECT SUM(f.length) as total_duration, c.name
FROM sakila.category as c
JOIN sakila.film_category as fc
USING (category_id)
JOIN sakila.film as f
USING (film_id)
GROUP BY c.name
ORDER BY total_duration DESC;

-- Display the most frequently rented movies in descending order.

SELECT COUNT(f.film_id) as frequency_rent, f.title
FROM sakila.rental as r
JOIN sakila.inventory as i
USING (inventory_id)
JOIN sakila.film as f
USING (film_id)
GROUP BY f.title
ORDER BY frequency_rent DESC
LIMIT 1;

-- Output: Bucket Brotherhood with frequency(of renting) 34

-- List the top five genres in gross revenue in descending order.

SELECT SUM(p.amount) as gross_revenue, c.name as genre_name
FROM sakila.category as c
JOIN sakila.film_category as fc
USING (category_id)
JOIN sakila.film as f
USING (film_id)
JOIN sakila.inventory as i
USING (film_id)
JOIN sakila.rental as r
USING (inventory_id)
JOIN sakila.payment as p
USING (rental_id)
GROUP BY c.name
ORDER BY gross_revenue DESC
LIMIT 5;

-- Output:
-- '5314.21','Sports'
-- '4756.98','Sci-Fi'
-- '4656.30','Animation'
-- '4587.39','Drama'
-- '4383.58','Comedy'

-- Is "Academy Dinosaur" available for rent from Store 1?

SELECT f.title, r.return_date, i.store_id
FROM sakila.film as f
JOIN sakila.inventory as i
USING (film_id)
JOIN sakila.store as s
USING (store_id)
JOIN sakila.rental as r
ON r.inventory_id = i.inventory_id
WHERE (s.store_id = '1') AND (r.return_date IS NULL) AND (f.title = 'Academy Dinosaur');
-- checking for both stores by changing the store id, only available on store 1.

SELECT store_id, f.title, COUNT(store_id) AS Num_film
FROM store
JOIN sakila.inventory i
USING (store_id)
JOIN sakila.film f
USING(film_id)
GROUP BY f.title, store_id
HAVING f.title = 'Academy Dinosaur';
-- checking how many titles are available on each store if title is "Academy Dinosaur"

-- GROUP BY c.name
-- ORDER BY gross_revenue DESC
-- LIMIT 5;

-- Get all pairs of actors that worked together.

SELECT *
FROM sakila.film_actor a1
JOIN sakila.film_actor a2
ON (a1.film_id = a2.film_id) -- AND (a1.actor_id <> a2.actor_id)
HAVING a1.actor_id <> a2.actor_id AND a1.film_id = a2.film_id;

-- checking by listing names and film id.
SELECT  first_name, last_name, f.film_id
FROM sakila.actor a
RIGHT JOIN sakila.film_actor f
USING(actor_id);
-- lists all actors as per film_id so we can see which actors worked together in same films

-- Get all pairs of customers that have rented the same film more than 3 times.
SELECT customer_id, first_name, last_name, film_id
FROM sakila.customer c
RIGHT JOIN sakila.rental  r
USING (customer_id)
RIGHT JOIN sakila.inventory i
USING (inventory_id)
GROUP BY film_id;

-- For each film, list actor that has acted in more films.

SELECT film_id, CONCAT(a.first_name,' ', a.last_name) AS Actor
FROM film
JOIN sakila.film_actor fa
USING(film_id)
JOIN sakila.actor a
USING (actor_id)
GROUP BY fa.film_id, actor_id
HAVING COUNT(film_id) > 0;
-- ORDER BY film_id DESC;

SELECT fa.film_id, actor_id, a.first_name, a.last_name
FROM sakila.film_actor fa
RIGHT JOIN sakila.actor a
USING (actor_id)
ORDER BY actor_id;

SELECT a1.film_id, a2.actor_id
FROM sakila.film_actor a1
JOIN sakila.film_actor a2
ON (a1.actor_id = a2.actor_id) AND (a1.film_id <> a2.film_id)
ORDER BY a1.film_id ASC;


