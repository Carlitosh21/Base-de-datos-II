#Carlos Vercellone Clase 7
use sakila;

#1--------------------------------------------------
select f.title, f.rating from film f
where f.length <= all (

	select f1.length from film f1

);


#2--------------------------------------------------
select f.title from film f
where f.length < all (

	select f1.length from film f1

);

#3------------------------------USANDO MIN()
select c.first_name, c.last_name,a.address , (

select min(p.amount) from payment p
where p.customer_id = c.customer_id

) as min_payment from customer c

inner join address a on c.address_id = a.address_id;

#3------------------------------USANDO ALL and/or ANY

select c.first_name, c.last_name,a.address , (

	select p.amount from payment p
	where p.customer_id = c.customer_id and p.amount <= all (
	
		select p1.amount from payment p1
		where p1.customer_id = c.customer_id
	
	) 
	
	limit 1

) as min_payment from customer c
inner join address a on c.address_id = a.address_id;


#4--------------------------------------------------

select c.first_name, c.last_name,a.address , concat((

select min(p.amount) from payment p
where p.customer_id = c.customer_id

), " | ", (

select max(p.amount) from payment p
where p.customer_id = c.customer_id

)) as min_max_payment from customer c

inner join address a on c.address_id = a.address_id;
