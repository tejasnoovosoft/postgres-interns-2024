SELECT f.film_id, f.title, SUM(f.length) AS total_duration
FROM film f
         JOIN film_actor fa ON f.film_id = fa.film_id
         JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title
ORDER BY total_duration DESC
LIMIT 1;
