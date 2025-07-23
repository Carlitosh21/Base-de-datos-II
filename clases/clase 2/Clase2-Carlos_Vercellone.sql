#Carlos Vercellone Clase 2

#1--------------------------------------------------

drop database if exists imdb;
create database imdb;
use imdb;

#2--------------------------------------------------
create table film(
	
	film_id int not null auto_increment,
	title varchar(60) not null,
	description varchar(225),
	release_year int(4),
	constraint film_pk primary key (film_id)

);

create table actor(
	
	actor_id int not null auto_increment,
	first_name varchar(60) not null,
	last_name varchar(60) not null,
	
	constraint actor_pk primary key (actor_id)

);

create table film_actor(
	
	actor_id int not null ,
	film_id int not null,
	
	
	constraint film_actor_pk primary key (actor_id, film_id)

);

#3--------------------------------------------------

alter table film
	add column last_update date;

alter table actor
	add column last_update date;

#4--------------------------------------------------

alter table film_actor
	add constraint film_fk foreign key (film_id) references film(film_id),
	add constraint actor_fk foreign key (actor_id) references actor(actor_id);


#5

insert into film (title, description, release_year)
values ('Iron Man 3', 'Hombre de Acero 3 pelea contra mutante naranja', 2012),
('Avengers infinity War', 'Thanos viene a joder', 2018),
('Avengers Endgame', 'Lo mataron a Thanos por jodido', 2021);

insert into actor (first_name, last_name)
values ('Carlitos', 'Vercellone'),
('Robert Downley Jr', 'Downley Jr'),
('Steve', 'Rogers');


insert into film_actor(actor_id, film_id) values(1,1), (1,2), (1,3), (3,2);







