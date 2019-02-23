use [PuntoVentaSysSoftDB]

create table CajaTB(
	IdCaja int identity(1,1) not null,	
	MontoInicial decimal(18,2),
	MontoFinal decimal(18,2),
	Entrada decimal(18,2),
	Salida decimal(18,2),
	Devolucion decimal(18,2),
	FechaApertura datetime,
	FechaCierre datetime,
	Estado varchar(12),
	IdEmpleado varchar(12),
	primary key(IdCaja)
)

drop table CajaTrabajadorTB(
	IdCajaTrabajador int identity(1,1) not null,
	MontoInicial decimal(18,2),
	MontoFinal decimal(18,2),
	Entrada decimal(18,2),
	Salida decimal(18,2),
	Devolucion decimal(18,2),
	FechaApertura datetime,
	FechaCierre datetime,
	Estado varchar(12),
	IdEmpleado varchar(12),
	primary key(IdCajaTrabajador)
)

select * from CajaTB
select * from CajaTB  where Estado = 'activo'


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

select sum(MontoFinal) as 'Ventas Totales' from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'

select MontoInicial as 'Fondo en caja' from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'

select Entrada from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'

select Salida from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'

select Devolucion from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'
