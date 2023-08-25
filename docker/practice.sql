select * from actor;

select first_name as Actor from actor;

select DISTINCT(first_name) from actor;

select film_id,title,release_year from film
order by film_id limit 5;

select film_id,title,release_year from film
order by film_id FETCH FIRST 5 ROW ONLY;

