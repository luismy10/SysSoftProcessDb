use [PuntoVentaSysSoftDB]
go

/*
	agregado campos Ingresos, Egresos
*/
drop table CajaTB(
	IdCaja int identity(1,1) not null,	
	MontoInicial decimal(18,2),
	MontoFinal decimal(18,2),
	Ingresos decimal(18,2),
	Egresos decimal (18,2),
	Devolucionones decimal(18,2),
	Entradas decimal(18,2),
	Salidas decimal(18,2),
	FechaApertura datetime,
	FechaCierre datetime,
	Estado varchar(12),
	IdEmpleado varchar(12),
	primary key(IdCaja)
)

/*
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
*/

select * from CajaTB
select * from CajaTB  where Estado = 'activo'
go

drop procedure Sp_Aperturar_Caja
@IdCajaTrabajador int,
@MontoInicial decimal(18,2),
@MontoFinal decimal(18,2),
@Estado varchar(12),
@Fecha datetime
as
insert into CajaTB(IdCajaTrabajador,MontoInicial,MontoFinal,Estado,Fecha)
values(@IdCajaTrabajador,@MontoInicial,@MontoFinal,@Estado,@Fecha)

go

select sum(MontoFinal) as 'Ventas Totales' from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'
go
select MontoInicial as 'Fondo en caja' from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'
go
select Entrada from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'
go
select Salida from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'
go
select Devolucion from CajaTB where IdEmpleado = 'EM0001' and Estado = 'activo'
go


/*
Probar cortes de caja nuevo
*/

create table CajaTB(
	IdCaja int primary key identity(1,1)not null,
	FechaApertura datetime null,
	FechaCierre datetime null,
	Estado bit null,
	Contado decimal(18,4) null,
	Calculado decimal(18,4) null,
	Diferencia decimal(18,4) null,
	IdUsuario varchar(12) not null,
	FechaRegistro datetime not null
)
go

Sp_ListarCajasAperturadas '2019-04-17','2019-04-17'
go

alter procedure Sp_ListarCajasAperturadas
@FechaInicial varchar(30),
@FechaFinal varchar(30)
as
	begin
		select a.IdCaja,a.FechaApertura,a.FechaCierre,a.Estado,a.Contado,a.Calculado,a.Diferencia,e.Apellidos,e.Nombres 
		from CajaTB as a inner join EmpleadoTB as e
		on a.IdUsuario = e.IdEmpleado
		where 
		(@FechaInicial = '' and @FechaFinal = '' and a.FechaApertura is not null)
		or
		(cast(a.FechaRegistro as date) between @FechaInicial and @FechaFinal and a.FechaApertura is not null)
	end
go


truncate table CajaTB
go
truncate table MovimientoCajaTB
go

select * from CajaTB
go
select * from MovimientoCajaTB
go

create table MovimientoCajaTB(
	IdMovimientoCaja int identity(1,1) not null,
	IdCaja int not null,
	IdUsuario varchar(12) not null,
	FechaMovimiento datetime not null,
	Comentario varchar(120) null,
	Movimiento varchar(6) not null,	
	Entrada decimal(18,4) null,
	Salidas decimal(18,4) null,
	Saldo decimal(18,4) null
	primary key(IdMovimientoCaja,IdCaja)
)
go

SELECT * FROM MovimientoCajaTB
GO