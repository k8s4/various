create table users (
	id serial not null constraint users_pk primary key,
	name text,
	rank text
);
alter table users owner to postgres;
create unique index users_id_uindex on users (id);

create table cars (
	id serial not null constraint cars_pk primary key,
	user_id integer constraint cars_users_id_fk references users,
	colour text,
	brand text,
	license_plate text
);
alter table cars owner to postgres;
create unique index cars_id_uindex on cars (id);

insert into db.users (id, name, rank) values (1, "Peter Jonson", "Manager");

insert into db.cars (id, user_id, colour, brand, license_plate) values (1, 1, "Blue", "Lada", "RFD943");

alter sequince cars_id_seq restart with 20;
alter sequince users_id_seq restart with 10;



