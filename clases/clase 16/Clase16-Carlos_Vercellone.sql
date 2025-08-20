use sakila;

#Clase 16 Carlos Vercellone

#Primero modificamos la tabla staff para que este como lo indica el repositorio:

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 

(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),

(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),

(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);

DELIMITER $$
CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    INSERT INTO employees_audit
    SET action = 'update',
     employeeNumber = OLD.employeeNumber,
        lastname = OLD.lastname,
        changedat = NOW(); 
END$$
DELIMITER ;

UPDATE employees 
SET 
    lastName = 'Phan'
WHERE
    employeeNumber = 1056;

SELECT 
    *
FROM
    employees_audit;


/*

1- Insert a new employee to , but with an null email. Explain what happens.


*/
select * from employees e

INSERT INTO employees 
(employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES
(2121, 'Vercellone', 'Carlos Ignacio', 'x101', null, '1', 1002, 'Co-Fundador');

/*
 Aca al intentar ingresar un registro a employee con mail null, no nos lo va a permitir, ya que al definir la tabla, se coloco un
 constraint el cual EVITA este tipo de inserts, esto ayuda a que, por ams que ya exista la verificacion en el JS del Sitio, si 
 de alguna forma logran hacer una request directamente con la DB, esta no acepte campos nulos para ciertos parametros, 
 todo esto para mantener la integridad de la base de datos.
 */


/*

2- Run the first the query

UPDATE employees SET employeeNumber = employeeNumber - 20

What did happen? Explain. Then run this other

UPDATE employees SET employeeNumber = employeeNumber + 20

Explain this case also.


*/

select * from employees e

select * from employees_audit;

UPDATE employees SET employeeNumber = employeeNumber - 20

/*
 Al ejecutar esta query, primero que anda pidio confirmacion, ya que era una query que iba  modificar TODOs los reguistros de
 la tabla de employees (porque no tenia WHERE clause). Luego, al modificar cada unos de estros registros, por cada uno que se modifico,
 se registro el cambio con los datos viejos a modo de auditoria, en la tabla employeees_audit. Obviamente, como la query lo indica, se
 le resto 20 a todos los employees Numbers.
 */

UPDATE employees SET employeeNumber = employeeNumber + 20

/*
 Al ejecutar esta segunda query (evidentemente, como tampoco tiene where clause, nos pide confiramcion) se detiene al tratar de
 modificarle el Number al segundo empleyee, ya que cuando se le resto 20 en la query anterior, quedaron: registro 2 = 1034 
 y resgitro 3 = 1054. Entonces, al tratar de sumarle 20 nuevamente al registro 2, tira error, pq ya existe una fila con numero 1054.
 Lo que se deberia hacer es sumerle 20 a la tercer fila primero, y ahi recien le podriamos sumar a la segunda.
 */


/*
 3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
 */

select * from employees e

alter table employees
add column Age int check (Age between 16 and 70);

INSERT INTO employees 
(employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle, Age)
VALUES
(9998, 'Test', 'Usuario', 'x200', 'test@empresa.com', '1', NULL, 'Sales Rep', 25); -- funciona

INSERT INTO employees 
(employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle, Age)
VALUES
(9999, 'Otro', 'Usuario', 'x201', 'otro@empresa.com', '1', NULL, 'Sales Rep', 12); --  error 

/*
 4- Describe the referential integrity between tables film, actor and film_actor in sakila db.
 
 La integridad referencial entre las tres tablas previene registros 'huerfanos' 
 (que refieren a actores o a peliculas que no existan). peliculas tiene su PK llamada film_id. Actores su PK actor_id. Y film_actor
 funciona tabla intermedia para posibilitar que muchos actores actuen en muchas peliculas (Many to Many). 
 
 esto permite, como mencione al inicio, que solo se permitan elegir actores para actuar que EFECTIVAMENTE esten en la tabla actores
 y los actores solo puedan actuar en peliculas que EFECTIVAMENTE esten registradas, todo esto gracias a la tabla de 
 film_actor
 */

/*
 5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated 
 on inserts and updates operations. Bonus: add a column lastUpdateUser and the respective trigger(s) to specify
  who was the last MySQL user that changed the row (assume multiple users, other than root, can connect to MySQL 
  and change this table).
 */

select * from employees e

alter TABLE employees
add column lastUpdate DateTime default now(),
add column lastUpdateUser char(50)

delimiter $$ -- se deben de ejecutar en archivo separado par apoder crearlos correctamente
create trigger user_date_time_insert
before insert on employees
for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end$$
delimiter ;

delimiter $$
create trigger user_date_time_update
before update on employees
for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end$$
delimiter ;


INSERT INTO employees 
(employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES
(2121, 'Vercellone', 'Carlos Ignacio', 'x101', "carlos@gmail.com", '1', 1002, 'Co-Fundador');

select * from employees;

/*
 6- Find all the triggers in sakila db related to loading film_text table. What do they do? 
 Explain each of them using its source code for the explanation.
 */

SHOW TRIGGERS LIKE 'film';

/*
 Hay 3 triggers:
 */

/*
 ins_film(AFTER)
 BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END
  
 Cada que se inserta una nueva pelicula,  se guardan los datos insertados en otra tabla llamada film_text, a modo de tener
 otra tabla con los 'logs' de lo que se hace/modifica en la tabla de peliculas
 */

/*
  upd_film(AFTER)
  BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END
  
  Cada que se actualiza una pelicula, se actualiza la fila en la tabla ya mencionada de film_text. previo a la modificacion de
  los datos, se valida con un IF que al menos 1 de los campos sea distintos a los que ya estan insertdos, ya que si son iguales no 
  tiene sentido hacer la operacion. Una vez validados los datos, busca la fila en film_text que tenga el mismo id y ahi modifica
  los datos
  */

/*
  del_film (AFTER)
  BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END
  
  Cuando se borra una pelicula de la tabla films, se bora tambien de la tabla film_text, asi de simple...
 */














