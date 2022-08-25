create schema trellini_garden;

use trellini_garden;


/* CREACION DE TABLAS*/

create table Sucursales (
id_s int primary key auto_increment,
direccion varchar(50),
capacidad int
);

create table Empleados (
id_e int primary key auto_increment,
rol text(50),
nombre text(50),
apellido text(50),
domicilio varchar(50),
id_s int,
salario float
);

create table Materia_Prima (
id_mp int primary key auto_increment,
nombre_mp varchar(50),
precio float
);

create table Proveedores (
id_prov int primary key auto_increment,
nombre text(50),
direccion varchar(50),
id_mp int,
categoria text(50)
);

create table Clientes (
dni_cliente int primary key,
nombre text(50),
apellido text(50),
fecha_de_nacimiento date,
email varchar(50)
);

create table Facturas (
id_factura int primary key auto_increment,
dni_cliente int,
precio_total int);


/* ASIGNACION DE PK y FK*/

alter table Empleados
add foreign key (id_s)
references Sucursales(id_s);

alter table Proveedores
add foreign key (id_mp)
references Materia_Prima (id_mp);

alter table Facturas
add foreign key (dni_cliente)
references Clientes (dni_cliente);


/* INSERCION DE DATOS*/

insert into sucursales (direccion, capacidad) VALUES
('azcuenaga 1520', '125'),
('alem 1589', '100'),
('estomba 699', '250'),
('paraguay 5746', '70');

insert into empleados (rol, nombre, apellido, domicilio, id_s, salario) VALUES
('cocinero', 'jorge', 'aguirre', 'alem 153', '2', '150000'),
('cheff', 'josefina', 'achaval', 'irigoyen 233', '4', '270000'),
('cocinero', 'luis', 'diaz', 'donado 343', '2', '200000'),
('mozo', 'adrian', 'manzo', 'rodriguez 1588', '3', '150000'),
('cajera', 'isabel', 'gomez', 'saenz peña 35', '4', '130000'),
('cocinero', 'alberto', 'gutierrez', 'nicaragua 785', '1', '150000'),
('cocinero', 'kiara', 'del cielo', 'uruguay 489', '1', '270000'),
('cocinero', 'franco', 'isco', 'gorriti 1569', '3', '200000'),
('limpieza', 'alejo', 'marisco', 'vieytes 35', '3', '150000'),
('mozo', 'lucrecia', 'stefenalli', 'estomba 123', '2', '130500');

insert into materia_prima (nombre_mp, precio) VALUES
('lomo', '1500'),
('pechuga', '2500'),
('arroz', '500'),
('langostinos', '1500'),
('cassata', '2500'),
('vino', '500');

insert into proveedores (nombre, direccion, id_mp, categoria) VALUES
('Mity', 'sarmiento 1230', '1', 'carniceria'),
('Carnes blancas', 'ohiggins 250', '2', 'polleria'),
('cooperativa obrera', 'roca 85', '3', 'supermercado'),
('mobi', '11 de abril 750', '4', 'pescaderia'),
('lepomm', 'mitre 250', '5', 'heladeria'),
('raffaelo', 'polonia 885', '6', 'vinoteca');

insert into clientes (dni_cliente, nombre, apellido, fecha_de_nacimiento, email) VALUES
('15963588', 'juan', 'ormazabal', '1989-04-15', 'jormazabal@hotmail.com'),
('1598762', 'josefina', 'rodriguez', '1991-05-03', 'jrodriguez@hotmail.com'),
('24856963', 'luis', 'alberto', '1990-06-05', 'lalberto@hotmail.com'),
('32233564', 'julieta', 'diaz', '1990-12-11', 'jdiaz@hotmail.com'),
('15935715', 'agustin', 'lingone', '199-03-15', 'alingone@hotmail.com'),
('25869632', 'horacio', 'fernandez', '1995-07-05', 'hfernandez@hotmail.com'),
('45687912', 'nicolas', 'ceferino', '1990-07-07', 'nceferino@hotmail.com'),
('19597845', 'tiago', 'avila', '1986-12-21', 'tavila@hotmail.com');

insert into facturas (dni_cliente, precio_total) VALUES
('15963588', '8500'),
('1598762', '6000'),
('24856963', '5320'),
('32233564', '13693'),
('15963588', '8500'),
('15963588', '6000'),
('24856963', '5320'),
('1598762', '13693');


/* CREACION DE VISTAS */

create or replace view vh_salarios_altos as
select nombre, apellido, rol from empleados where salario > 150000;

create or replace view vh_empleados_por_sucursal as
select sucursales.id_s, empleados.nombre, empleados.apellido
from sucursales
inner join empleados
on sucursales.id_s = empleados.id_s;

create or replace view vh_facturas_caras as
select clientes.dni_cliente, clientes.nombre, clientes.apellido, facturas.precio_total
from clientes
inner join facturas
on clientes.dni_cliente = facturas.dni_cliente
where facturas.precio_total > 8000;

create or replace view vh_materia_prima_barata as
select proveedores.nombre, proveedores.categoria, materia_prima.nombre_mp, materia_prima.precio
from proveedores
inner join materia_prima
on proveedores.id_mp = materia_prima.id_mp
where materia_prima.precio < 1000;

create or replace view vh_primeros_clientes as
select facturas.id_factura, clientes.apellido, clientes.email, facturas.precio_total
from facturas
inner join clientes
on facturas.dni_cliente = clientes.dni_cliente
limit 5;



/* FUNCION 1*/
drop function if exists fn_apellido_empleado

delimiter $$
create function fn_apellido_empleado (p_id_e int)
returns varchar (50)
deterministic
begin
declare empleado_resultado varchar (50);
	set empleado_resultado = (select apellido from empleados where id_e = p_id_e);
return empleado_resultado;
end $$
delimiter ;

select fn_apellido_empleado (4);


/*FUNCION 2*/
drop function if exists fn_cant_rol

delimiter //
create function fn_cant_rol (rol_empleado varchar(50))
returns int
deterministic
begin
declare total_rol int;
set total_rol = (select count(*) from empleados where rol = rol_empleado);
return total_rol;
end //
delimiter ;

select fn_cant_rol ('cheff') ; /* distintos roles = cheff, mozo, cocinero, cajera, limpieza) */



/*PROCEDURE ORDENAR LISTA DE EMPLEADOS POR APELLIDO*/
drop procedure if exists sp_ordenar_empleados;
delimiter $$
create procedure sp_ordenar_empleados (inout apellido_empleado varchar(25), inout asc_desc varchar (25))
begin
set @order1 = concat('select * from empleados u order by', ' ', apellido_empleado, ' ', asc_desc, ' ');
prepare param_stmt from @order1;
execute param_stmt;
deallocate prepare param_stmt;
end $$
delimiter ;
set @apellido_empleado = 'apellido';
set @asc_desc = 'desc';

call sp_ordenar_empleados (@ordenar , @asc_desc);


/*PROCEDURE ELIMINAR EMPLEADO POR ID */
drop procedure if exists sp_eliminar_empleado;
delimiter $$
create procedure sp_eliminar_empleado (inout id_eliminar int)
begin
set @delete_empleado = concat('delete from empleados where id_e =', id_eliminar);
prepare param_stmt from @delete_empleado;
execute param_stmt;
deallocate prepare param_stmt;
end $$
delimiter ;
set @delete_empleado = '2';

call sp_eliminar_empleado (@delete_empleado);


/*PROCEDURE AGREGAR NUEVO EMPLEADO*/
drop procedure if exists sp_agregar_empleado;
delimiter $$
create procedure sp_agregar_empleado (inout nuevo_rol text (25), inout nuevo_nombre text(25), inout nuevo_apellido text(25), inout nuevo_domicilio varchar (50), inout nuevo_id_s int, nuevo_salario float)
begin
	insert into empleados (id_e, rol, nombre, apellido, domicilio, id_s, salario) 
	VALUES (null, nuevo_rol , nuevo_nombre, nuevo_apellido, nuevo_domicilio, nuevo_id_s, nuevo_salario);
end $$
delimiter ;

set @nuevo_rol = 'seguridad';
set @nuevo_nombre = 'jaime';
set @nuevo_apellido = 'larreta';
set @nuevo_domicilio = '3 de febrero 1518';
set @nuevo_id_s = '4';
set @nuevo_salario = 185000;

call sp_agregar_empleado (@nuevo_rol, @nuevo_nombre, @nuevo_apellido, @nuevo_domicilio, @nuevo_id_s, @nuevo_salario);

select * from empleados;



/*CREACION TABLA LOG_AUDITORIA EMPLEADOS*/
drop table if exists log_auditoria_empleados;
create table if not exists log_auditoria_empleados
(id_log int auto_increment primary key,
nombre_de_accion varchar (10),
nombre_tabla varchar (100),
id_e int,
rol text (50),
salario_anterior float,
salario_nuevo float,
usuario varchar(50),
fecha_log date);


/*TRIGER INSERT NUEVOS EMPLEADOS*/
drop trigger if exists trg_log_nvos_empleados;
delimiter //
create trigger  trg_log_nvos_empleados after insert on trellini_garden.empleados
for each row
begin
	insert into log_auditoria_empleados (nombre_de_accion , nombre_tabla, id_e, rol,  usuario, fecha_log)
	values ( 'insert' , 'empleados' , new.id_e , new.rol ,current_user(), now());
end//
delimiter ;

insert into empleados (rol, nombre, apellido, domicilio, id_s, salario) values
('seguridad', 'jorge', 'newbery', 'alvarado 310', '2', '150000');

select * from log_auditoria_empleados;


/*TRIGER DELETE EMPLEADOS*/
drop trigger if exists trg_eliminar_empleado ;
delimiter //
create trigger  trg_eliminar_empleado before delete on trellini_garden.empleados
for each row
begin
	insert into log_auditoria_empleados (nombre_de_accion , nombre_tabla, id_e, rol, usuario, fecha_log)
	values ( 'delete', 'empleados', old.id_e, old.rol, current_user(), now());
end//
delimiter ;

DELETE FROM trellini_garden.empleados
WHERE id_e = 7 ;

select * from log_auditoria_empleados;


/*TRIGER ACTUALIZAR SALARIO EMPLEADOS*/
drop trigger if exists trg_actualizar_empleado ;
delimiter //
create trigger trg_actualizar_empleado before update on trellini_garden.empleados
for each row
begin
	insert into log_auditoria_empleados (nombre_de_accion , nombre_tabla, id_e, rol, salario_anterior, salario_nuevo, usuario, fecha_log)
	values ( 'update', 'empleados', new.id_e, new.rol, old.salario, new.salario, current_user(), now());
end//
delimiter ;

UPDATE trellini_garden.empleados SET salario = '1' WHERE id_e = 10 ; 

select * from log_auditoria_empleados;

select * from empleados





