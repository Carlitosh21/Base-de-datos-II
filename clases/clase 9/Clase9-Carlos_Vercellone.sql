#Carlos Vercellone Clase 9
use sakila;

#1--------------------------------------------------


select co.country, (

select count(*) from city c
where c.country_id = co.country_id

) as cities_per_country from country co
order by co.country_id;

#2--------------------------------------------------

select co.country, (

select count(*) from city c
where c.country_id = co.country_id

) as cities_per_country from country co
having cities_per_country > 10
order by cities_per_country;

#3--------------------------------------------------



select c.first_name, c.last_name, a.address, (

select count(*) from rental r
where r.customer_id = c.customer_id

) as total_films_rented , (

select sum(p.amount) from payment p
inner join rental r on r.rental_id = p.rental_id
where r.customer_id = c.customer_id

) as total_spent from customer c
inner join address a on c.address_id = a.address_id
order by total_spent desc;


#4--------------------------------------------------


select ca.name, (

select avg(f1.length) from film f1
inner join film_category fc1 on f1.film_id = fc1.film_id
where fc1.category_id = ca.category_id

) as average_film_duration from category ca
inner join film_category fc on ca.category_id = fc.category_id
inner join film f on fc.film_id = f.film_id
group by ca.category_id
order by average_film_duration desc;


#5--------------------------------------------------


select f.rating, (

select sum(p.amount) from payment p
inner join rental r on p.rental_id = r.rental_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f1 on i.film_id = f1.film_id
where f1.rating = f.rating

) as total_earnings from film f
group by f.rating;




