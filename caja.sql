use [PuntoVentaSysSoftDB]

create table CajaTB(
	IdCaja int identity(1,1) not null,
	IdCajaTrabajador int not null,
	MontoInicial decimal(18,2) not null,
	MontoFinal decimal(18,2) not null,
	Estado varchar(12)not null,
	Fecha datetime not null,
	primary key(IdCaja)
)

create table CajaTrabajadorTB(
	IdCajaTrabajador int identity(1,1) not null,
	IdEmpleado varchar(12) not null,
	MontoInicial decimal(18,2) not null,
	Entrada decimal(18,2) not null,
	Salida decimal(18,2),
	Devolucion decimal(18,2),
	Estado varchar(12) not null,
	FechaApertura datetime not null,
	FechaCierre datetime not null,
	primary key(IdCajaTrabajador)
)

truncate table CajaTB
truncate table CajaTrabajadorTB


INSERT INTO CajaTrabajadorTB (IdEmpleado,MontoInicial,Entrada,Salida,Devolucion,Estado,FechaApertura,FechaCierre)

go
create procedure Sp_Aperturar_Caja
@IdCajaTrabajador int,
@MontoInicial decimal(18,2),
@MontoFinal decimal(18,2),
@Estado varchar(12),
@Fecha datetime
--


as
insert into CajaTB(IdCajaTrabajador,MontoInicial,MontoFinal,Estado,Fecha)
values(@IdCajaTrabajador,@MontoInicial,@MontoFinal,@Estado,@Fecha)