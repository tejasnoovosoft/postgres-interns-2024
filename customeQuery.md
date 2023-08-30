[//]: # (-- Q.1 Query to Find Actors Who Have Collaborated the Most.)

`SELECT a1.actor_id AS actor1_id,
a1.first_name AS actor1_first_name,
a2.actor_id AS actor2_id,
a2.first_name AS actor2_first_name,
COUNT(DISTINCT fa1.film_id) AS shared_film_count
FROM actor a1
JOIN film_actor fa1 ON a1.actor_id = fa1.actor_id
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id != fa2.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY a1.actor_id, a1.first_name, a2.actor_id, a2.first_name
ORDER BY shared_film_count DESC
LIMIT 1;`

[//]: # (-- Query to Find Countries with the Longest Average Address Street Length.)

`SELECT co.country_id, co.country, AVG(LENGTH(a.address)) AS avg_street_length
FROM country co
JOIN city c ON co.country_id = c.country_id
JOIN address a ON c.city_id = a.city_id
GROUP BY co.country_id, co.country
ORDER BY avg_street_length DESC
LIMIT 5;`

[//]: # (--Find the Location of stores whose goods are used for making films whose release year is 2005.)

`SELECT DISTINCT s.staff_id, a.address
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN address a ON s.address_id = a.address_id
WHERE f.release_year = 2005;`

[//]: # (-- select the staffs firstname and lastname in one column and their whole payment)

`SELECT CONCAT(first_name, ' ', last_name) AS staff_name,p.amount AS total_payment
FROM staff s JOIN payment p ON s.staff_id = p.staff_id;`

[//]: # ( select 25 the actors firstname and lastname in one column named as name and their film names who have released in)

[//]: # (recent year 2022 order by name)

`SELECT CONCAT(a.first_name, ' ', a.last_name) AS name, f.title
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.release_year = 2022
ORDER BY name
LIMIT 25;`

[//]: # (Determine which customer watch how many movies of particular actor.)
`SELECT
c.customer_id,
c.first_name,
c.last_name,
a.actor_id,
a.first_name,
COUNT(*) AS MoviesWatched
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.actor_id, a.first_name, c.first_name, c.last_name, a.actor_id, c.customer_id
ORDER BY MoviesWatched DESC;`

