#Carlos Vercellone Clase 9
use sakila;

#1--------------------------------------------------


select * from customer
order by customer_id desc


insert into customer
(store_id, first_name, last_name, email, address_id, active)
values 
(1, 'Carlos', 'Vercellone', 'carlosvercellone21@gmail.com', (

select a.address_id from address a
inner join city c on a.city_id = c.city_id
inner join country co on co.country_id = c.country_id
order by a.address_id desc
limit 1

), 1);


#2--------------------------------------------------

select * from rental
order by rental.rental_id desc

insert into rental
(rental_date, inventory_id, customer_id, return_date, staff_id)
values
(now(), (

select i.inventory_id from inventory i 
inner join film f on i.film_id = f.film_id
where f.title = 'AFRICAN EGG'
limit 1

), (

select c.customer_id from customer c 
order by c.customer_id desc
limit 1

), DATE_ADD(now(), interval 10 day), (

select s.staff_id from staff s
where s.store_id = 2
limit 1

));

#3--------------------------------------------------

select distinct release_year from film
order by film_id desc

update film
set release_year = 2001
where rating = "G";

update film
set release_year = 2002
where rating = "R";

update film
set release_year = 2003
where rating = "NC-17";

update film
set release_year = 2004
where rating = "PG-13";

update film
set release_year = 2005
where rating = "PG";


#4--------------------------------------------------

select r.rental_id from rental r 
where r.return_date is null
order by r.rental_date desc
limit 1;

update rental
set return_date = now()
where rental_id = 11739;

select * from rental r
where rental_id = 11739;



#5--------------------------------------------------
-- Me tira este error al intentar eliminarlo, ya que tiene dependencias
-- SQL Error [1451] [23000]: Cannot delete or update a parent row: a foreign key 
-- constraint fails (`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` 
-- FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON UPDATE CASCADE)

select * from film f
order by f.film_id desc;

-- procedo a borrar todos los film_actor que haya cn el id de esa film

delete from film_actor
where film_id = 1000;

-- Ahora me tira que hay dependencias en film_category, procedo a borrarlas

delete from film_category
where film_id = 1000;

-- Ahora que hay dependencias en inventory, pero me dice que tengo dependencias en retal 

-- procedo a borrar los rental

delete from rental
where inventory_id in (

select inventory_id from inventory
where film_id = 1000

);

-- Ahora si puedo borrar los inventory

delete from inventory 
where film_id = 1000;

-- Y por fin pude borrar la pelicula


delete from film
where film_id = 1000;

#6--------------------------------------------------


select i.inventory_id from inventory i
where i.inventory_id not in (

select r.inventory_id from rental r

) limit 1;

select * from rental
order by rental.rental_id desc;

select * from payment
order by payment_id desc;

-- 5 es el inventory id available

insert into rental
(rental_date, inventory_id, customer_id, staff_id)
values
(now(), (select i.inventory_id from inventory i
where i.inventory_id not in (

select r.inventory_id from rental r

) limit 1), 1, 1);

insert into payment 
(customer_id, staff_id, rental_id, amount, payment_date )
values 
((

select customer_id from rental
order by rental_id desc
limit 1

), (

select staff_id from rental
order by rental_id desc
limit 1

), (

select rental_id from rental
order by rental_id desc
limit 1

), 10, now());





