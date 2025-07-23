#Carlos Vercellone Clase 6
use sakila;

#1--------------------------------------------------
select a.last_name, a.first_name from actor a
where a.last_name  in (

	select last_name from actor 
	group by last_name having count(*) >1

)
order by a.last_name, a.first_name;

#2--------------------------------------------------
select a.last_name, a.first_name from actor a
where a.actor_id not in (

	select ac.actor_id from actor ac
	inner join film_actor fa on ac.actor_id  = fa.actor_id

);


#3--------------------------------------------------

select cu.* from customer cu
where cu.customer_id in (

	select c.customer_id from customer c
	inner join rental r on c.customer_id = r.customer_id
	group by r.rental_id having count(*) = 1

);

#4--------------------------------------------------

select cu.* from customer cu
where cu.customer_id not in (

	select c.customer_id from customer c
	inner join rental r on c.customer_id = r.customer_id
	group by r.rental_id having count(*) <= 1

);

#5--------------------------------------------------

select a.first_name, a.last_name from actor a
where a.actor_id in (

	select fa.actor_id from film_actor fa 
	inner join film f on fa.film_id = f.film_id
	where f.title in ("BETRAYED REAR", "CATCH AMISTAD")

);

#6--------------------------------------------------

select a.first_name, a.last_name from actor a
where a.actor_id in (

	select fa.actor_id from film_actor fa 
	inner join film f on fa.film_id = f.film_id
	where f.title =  "BETRAYED REAR"

) and a.actor_id not in (

	select fa.actor_id from film_actor fa 
	inner join film f on fa.film_id = f.film_id
	where f.title =  "CATCH AMISTAD"

);

#7--------------------------------------------------

select a.first_name, a.last_name from actor a
where a.actor_id in (

	select fa.actor_id from film_actor fa 
	inner join film f on fa.film_id = f.film_id
	where f.title =  "BETRAYED REAR"

) and a.actor_id in (

	select fa.actor_id from film_actor fa 
	inner join film f on fa.film_id = f.film_id
	where f.title =  "CATCH AMISTAD"

);

#8--------------------------------------------------

select a.first_name, a.last_name from actor a
where a.actor_id not in (

	select fa.actor_id from film_actor fa 
	inner join film f on fa.film_id = f.film_id
	where f.title in ("BETRAYED REAR", "CATCH AMISTAD")

);





