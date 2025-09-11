use sakila;

-- Clase 17 Carlos vercellone


/*
Exercises
For all the exercises include the queries in the class file.

1- Create two or three queries using address table in sakila db:

include postal_code in where (try with in/not it operator)
eventually join the table with city/country tables.
measure execution time.
Then create an index for postal_code on address table.
measure execution time again and compare with the previous ones.
Explain the results

2- Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?

3- Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.
*/


#1

-- a1)

select * from address a 
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672")

-- a2)

select * from address a 
where a.postal_code not in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672")

-- b)
select a.address, a.postal_code, c.city, co.country from address a 
inner join city c using(city_id)
inner join country co using(country_id)
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672")


-- c1) 
explain
select a.address, a.postal_code, c.city, co.country from address a 
inner join city c using(city_id)
inner join country co using(country_id)
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672")

-- c2) 

SET profiling = 1;



select a.address, a.postal_code, c.city, co.country from address a 
inner join city c using(city_id)
inner join country co using(country_id)
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672");

show PROFILES;

-- c)
/*
 Al medir la duracion nos da que la consulta tarda 0.0010545 segs en ejecutarse
 */ 


-- d) Creamos el Indice

CREATE INDEX postalCode ON address(postal_code);

-- e) medimos nuevamente el tiempo de ejecucion

SET profiling = 1;



select a.address, a.postal_code, c.city, co.country from address a 
inner join city c using(city_id)
inner join country co using(country_id)
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672");

show PROFILES;

-- Ahora vemos que duro 0.0008285 segs, es decir, que tuvimos una mejora del 22% en el tiempo de Ejecucion gracias al Indice



#2

SET profiling = 1;

select * from actor a
where a.first_name LIKE 'Penelope';

show PROFILES; -- duracion 0.0007855


SET profiling = 1;

select * from actor a
where a.last_name LIKE 'GUINESS';

show PROFILES; -- duracion 0.0002355

-- Entre la columna que tiene Index y la que no, hay una diferencia del 70%
-- en la eficacia de las consultas (0.00055 segs)


#3

SET profiling = 1;

SELECT film_id, title, description
FROM film
WHERE description LIKE '%Action%';

show PROFILES; -- 0.0026075 segs





 -- Agergamos el FUlltext Search

Alter table film
add FULLTEXT(description);

SET profiling = 1;

SELECT film_id, title, description
FROM film
WHERE MATCH (description) AGAINST('Action');

show PROFILES; -- 0.00148225


-- Mejora entre la priemr y segunda consulta 43%













