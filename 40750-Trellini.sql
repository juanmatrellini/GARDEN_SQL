create schema GARDEN;
use garden;

create table Sucursales (
id_s int primary key auto_increment,
direccion varchar(50),
capacidad int,
id_prov int,
id_e int
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

create table Proveedores (
id_prov int primary key auto_increment,
nombre text(50),
direccion varchar(50),
id_mp int
);

create table Materia_Prima (
id_mp int primary key auto_increment,
nombre_mp varchar(50),
precio float,
id_producto int
);

create table Productos (
id_producto int primary key auto_increment,
nombre varchar(50),
tipo text (50),
precio float,
id_mp int
);

create table Facturas (
id_factura int primary key auto_increment,
dni_cliente int,
id_producto int,
precio_total int);

create table Clientes (
dni_cliente int primary key,
nombre text(50),
apellido text(50),
fecha_de_nacimiento date,
email varchar(50),
id_factura int
);

alter table Sucursales
add foreign key (id_e)
references Empleados (id_e);

alter table Sucursales
add foreign key (id_prov)
references Proveedores (id_prov);

alter table Empleados
add foreign key (id_s)
references Sucursales(id_s);

alter table Proveedores
add foreign key (id_mp)
references Materia_Prima (id_mp);

alter table Materia_Prima
add foreign key (id_producto)
references Productos (id_producto);

alter table Productos
add foreign key (id_mp)
references Materia_Prima (id_mp);

alter table Facturas
add foreign key (dni_cliente)
references Clientes (dni_cliente);

alter table Facturas
add foreign key (id_producto)
references Productos (id_producto);

alter table Clientes
add foreign key (id_factura)
references Facturas (id_factura);