use sakila;

#Clase 19 Carlos Vercellone

/*
Create a user data_analyst

Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.

Login with this user and try to create a table. Show the result of that operation.

Try to update a title of a film. Write the update script.

With root or any admin user revoke the UPDATE permission. Write the command

Login again with data_analyst and try again the update done in step 4. Show the result.
*/

#1) 
CREATE USER data_analyst@'%' -- qie se pueda conecetgar desde cualqueir host
IDENTIFIED BY '1234';



#2)
GRANT SELECT, UPDATE, DELETE ON sakila.*
TO data_analyst@'%' WITH GRANT OPTION


#3) Creo la COnexion en el Dveaber con el usuario data_analyst y la passwrd 1234
-- Una vez con esta cuenta, ttrato de hacer:

Create Table Tabla_super_pro (

titulo varchar(50)

);
-- SQL Error [1142] [42000]: 
-- CREATE command denied to user 'data_analyst'@'192.168.65.1' for table 'Tabla_super_pro'


#4) Trato de Actualizar Tabla y Funciona

Update film f 
set title = 'ACADEMY Dinosaurio'
where title LIKE 'ACADEMY DINOSAUR';

#5) revokeamos el persmiso a Data_analyst

revoke UPDATE on sakila.* From data_analyst@'%';

#6) Nos loggeamos como data analyst de nuevo y probamos:
Update film f 
set title = 'ACADEMY DINOSAUR'
where title LIKE 'ACADEMY Dinosaurio';
-- no tira este error:

-- SQL Error [1142] [42000]: UPDATE command denied to user 'data_analyst'@'192.168.65.1' for table 'film'


