#Carlos Vercellone Clase 9
use sakila;

#1--------------------------------------------------

select f.title as films_not_in_Inventory from film f
where f.film_id not in ( 

select distinct i.film_id from inventory i

);

#2--------------------------------------------------

select f.title, i.inventory_id from film f
inner join inventory i on i.film_id = f.film_id
where i.inventory_id not in (

select r.inventory_id from rental r

);

#3--------------------------------------------------

select c.first_name, c.last_name, c.store_id, 
f.title, r.rental_date, r.return_date from customer c
inner join rental r on r.customer_id = c.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
order by c.store_id, c.last_name;


#4--------------------------------------------------



select concat(ct.city, ", ", co.country) as location,
concat(st.first_name, " ", st.last_name) as manager,
(

select sum(p.amount) from payment p
inner join rental r on r.rental_id = p.rental_id
inner join customer c on c.customer_id = r.customer_id
where c.store_id = s.store_id

) as total_sales
from store s
inner join staff st on s.manager_staff_id = st.staff_id
inner join address a on a.address_id = s.address_id
inner join city ct on a.city_id = ct.city_id
inner join country co on co.country_id = ct.country_id;



#5--------------------------------------------------

-- Which actor has appeared in the most films?

select 
a.first_name, 
a.last_name,
(

select count(*) from film f 
inner join film_actor fa on f.film_id = fa.film_id
where fa.actor_id = a.actor_id

) as total_apearences
from actor a
order by total_apearences desc
limit 1;




