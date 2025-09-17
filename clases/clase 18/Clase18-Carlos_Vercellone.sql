use sakila;

#clase 18 Carlos Vercellone

/*Exercises
Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.

Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. 
You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS.

Review the function inventory_in_stock and the procedure film_in_stock explain the code, write usage examples.*/


-- 1) Write a function that returns the amount of copies of a film in a store in sakila-db. 

-- Pass either the film id or the film name and the store id.


delimiter CarlitosCrack

CREATE FUNCTION cantidad_copias(
    pelicula_id INT,
    tienda_id INT
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE copias_vendidas INT;

    SELECT COUNT(*)
    INTO copias_vendidas
    FROM inventory i
    WHERE i.store_id = tienda_id
      AND i.film_id = pelicula_id;

    RETURN copias_vendidas;
END

CarlitosCrack

delimiter ;

SELECT cantidad_copias(1,1) AS total_copias;



-- 2) Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. 

-- You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS.


delimiter Esta_re_dificil_el_Cursor

create Procedure clientes_x_pais (

in pais text ,
out lista_clientes text

)
begin
	
	declare fin int default 0;
	declare v_cliente varchar(200);
	
	declare bucle cursor for 
	select concat(c.first_name, " ",c.last_name) from customer c
	inner join address a using(address_id)
	inner join city ci using(city_id)
	inner join country co using(country_id)
	where co.country LIKE pais;
	
	declare continue handler for NOT FOUND set fin = 1;
	
	set lista_clientes = "";
	
	open bucle;
	
	bucle_loop: loop
		
		fetch bucle into v_cliente;
		if fin = 1 then 
			leave bucle_loop;
		end if;
		
		set lista_clientes = concat(lista_clientes, v_cliente, "; " );
	end loop;
	
	close bucle;
	
	
end Esta_re_dificil_el_Cursor

Delimiter ;

call clientes_x_pais('Argentina', @total);
select @total;

-- 3) Review the function inventory_in_stock and the procedure film_in_stock explain the code, write usage examples.

-- 3a)

show create function inventory_in_stock ;


CREATE DEFINER=`root`@`localhost` FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1) 
-- se le ingresara el id de Inventory y devolvera un 
-- numero de 1 digito (1 = SI ESTA EN STOCK | 0 = NO ESTA EN STOCK)
    READS SQL DATA
BEGIN
    DECLARE v_rentals INT; -- definimos la cantidad de peliculas rentadas
    DECLARE v_out     INT;


    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id; -- calculamos y setteamos la cant de Pelicuals rentadas

    IF v_rentals = 0 THEN
      RETURN TRUE; -- Si NO hay ninguna pelicula rentada significa que SI esta en Stock
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL; -- Se ven que peliculas se rentaron y Aun no se devolvieron (solo se hace esta comparacion si esta rentatada la peli)

    IF v_out > 0 THEN
      RETURN FALSE; -- Si NO se devolvio (NO HAY STOCK)
    ELSE
      RETURN TRUE; -- Si SI se devolvio (SI HAY STOCK)
    END IF;
END


SELECT inventory_in_stock(inventory_id) from inventory i



-- 3b)


show create procedure film_in_stock;


CREATE DEFINER=`root`@`localhost` PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT) 
-- le entra el id de la film, el id de la Store
-- y devuelve la cantidad de peliculas
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id); 
     -- obtienen el id de inventario de la pelicula en la store definida (con los ids), el cual despues chequean si tiene stock usando la funcion de antes
	--	estos resultados se mostraran al llamar a la funcion 'call'

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count; -- Este devuelve la CANTIDAD de peliculas en Stock que hay para los parametros Dados para cuando se use el select @total
END

call film_in_stock(1,1,@total);
select @total;
