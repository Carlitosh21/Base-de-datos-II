#Carlos Vercellone Clase 4
use sakila;

select f.title, f.special_features from film f
where f.rating like "PG-13";

select distinct f.length from film f
order by f.length ;

select f.title, f.rental_rate, f.replacement_cost from film f
where f.replacement_cost between 20.00 and 24.00
order by f.replacement_cost ;

select f.title, c.name, f.rating from film f
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id  = c.category_id
where f.special_features like "%Behind the Scenes%";

select a.first_name, a.last_name from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id  = f.film_id
where f.title like "%ZOOLANDER FICTION%"

select ad.address, cy.city, ct.country from store s
inner join address ad on s.address_id  = ad.address_id
inner join city cy on ad.city_id = cy.city_id
inner join country ct on cy.country_id  = ct.country_id
where s.store_id = 1;

select f.title as "film 1 title", f.rating as "film 1 rating", 
fl.title as "film 2 title", fl.rating as "film 2 rating" from film f
inner join film fl on f.rating = fl.rating;

select f.*, ma.first_name, ma.last_name from film f
inner join inventory i on f.film_id = i.film_id
inner join store s on i.store_id = s.store_id
inner join staff ma on s.manager_staff_id  = ma.staff_id
where s.store_id =2;
