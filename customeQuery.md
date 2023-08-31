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

`Select a.district, film.film_id
from address a
inner join store on a.address_id = store.address_id
inner join staff on store.address_id = staff.address_id
inner join rental on staff.staff_id = rental.staff_id
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on film.film_id = inventory.film_id
where film.release_year = 2006
group by a.district, film.film_id;`

[//]: # (-- select the staffs firstname and lastname in one column and their whole payment)

`select concat(s.first_name ,' ',s.last_name) ,
sum(p.amount) as payment
from staff s
inner join payment p
on s.staff_id = p.staff_id
group by concat(s.first_name ,' ',s.last_name)`

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

[//]: # (List the top 3 actors having done maximum sci-fi movies and with maximum rental rates)

`SELECT a.first_name AS Actor_Name,COUNT(*) AS Number_of_SciFi_Movies
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
GROUP BY a.first_name, a.actor_id, a.actor_id
ORDER BY Number_of_SciFi_Movies DESC
LIMIT 3;`

[//]: # (Find all actors who acted in more than one language. Output should contain actor_name, language. Sorted by languages, actor_name.)

`SELECT DISTINCT a.first_name || ' ' || a.last_name AS Actor_Name, l.name AS Language
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN language l ON f.language_id = l.language_id
WHERE a.actor_id IN (
SELECT actor_id
FROM film_actor
GROUP BY actor_id
HAVING COUNT(DISTINCT film_id) > 1
)
ORDER BY l.name, Actor_Name;`

list out all films

[//]: # (with highest rental rate  and classify the films labelled as "inappropriate for children under 13" with ratings PG-13 , "General" with ratings as G and " Restricted for Age below 18" with ratings as R)

`with table2 as (select description,
case
when rating = 'PG-13' then 'inappropriate for children under 13'
when rating = 'G' then 'General'
when rating = 'R' then 'Restricted for Age below 18'
end as Category  from
(select description , rating ,max(rental_rate) from film group by description ,rating) as sub)
select description , category
from table2 tab
where category is not null`

[//]: # (1&#41; Find the Indian Staff whose goods are used in making Hindi films with language id 1.)

`Select count(*) from country c
inner join city c2 on c.country_id = c2.country_id
inner join public.address a on c2.city_id = a.city_id
inner join staff s on a.address_id = s.address_id
inner join rental r on s.staff_id = r.staff_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
where c.country = 'India'
and f.language_id = 1;`

[//]: # (What are the top 10 films that have been rented by customers in the United States, and how many times have they been rented?)

`select count(con.country) , f.title from country con
inner join city c
on con.country_id = c.country_id
inner join address ad
on c.city_id = ad.city_id
inner join customer cus
on ad.address_id = cus.address_id
inner join rental rent
on cus.customer_id = rent.customer_id
inner join inventory i
on rent.inventory_id = i.inventory_id
inner join film f
on i.film_id = f.film_id
where con.country ='United States'
group by f.title
order by  count(con.country) desc limit 10`

[//]: # (What is the average rental duration for the top 5 films that have been rented by customers in each country)
`Select c.country as top_country, film.title, avg(film.length) as duration
from film
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join customer on rental.customer_id = customer.customer_id
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country c on city.country_id = c.country_id
group by film.title, top_country
order by duration desc
limit 5;`

[//]: # (Find the category which was rented the most for each month in year 2005, if there is a tie find all categories. Sorted by months and category names. Output should contain month, category, count. You can ignore the month if there is no data present for it. )
`select c.name , count(*) from film f
inner join inventory i
on f.film_id = i.film_id
inner join rental
on i.inventory_id = rental.inventory_id
inner join film_category fc
on f.film_id = fc.film_id
inner join category c
on fc.category_id = c.category_id
group by c.name`

[//]: # (List out top 10 most revenue generated district to release animated film with average price running on that district)

`select address.district, round(avg(rental_rate), 2)
from film
inner join film_category
on film.film_id = film_category.film_id
inner join category
on film_category.category_id = category.category_id
inner join inventory
on film.film_id = inventory.film_id
inner join rental
on inventory.inventory_id = rental.inventory_id
inner join payment
on rental.rental_id = payment.rental_id
inner join customer
on payment.customer_id = customer.customer_id
inner join address
on customer.address_id = address.address_id
where category.name = 'Animation'
group by address.district
order by sum(amount) desc
LIMIT 10`