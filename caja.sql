use [PuntoVentaSysSoftDBDesarrollo]
go


/*
Probar cortes de caja nuevo
*/

create table CajaTB(
	IdCaja varchar(12) primary key not null,
	FechaApertura date null,
	FechaCierre date null,
	HoraApertura time null,
	HoraCierre time null,
	Estado bit null,
	Contado decimal(18,4) null,
	Calculado decimal(18,4) null,
	Diferencia decimal(18,4) null,
	IdUsuario varchar(12) not null,
	FechaRegistro date not null,
	HoraRegistro time not null
)
go


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



Sp_ListarCajasAperturadas '2019-09-10','2019-09-10'
go

alter procedure Sp_ListarCajasAperturadas
@FechaInicial varchar(30),
@FechaFinal varchar(30)
as
	begin
		select a.IdCaja,a.FechaApertura,a.HoraApertura,a.FechaCierre,a.HoraCierre,a.Estado,a.Contado,a.Calculado,a.Diferencia,e.Apellidos,e.Nombres 
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
SELECT * FROM MovimientoCajaTB
GO


create table MovimientoCajaTB(
	IdMovimientoCaja int identity(1,1) not null,
	IdCaja varchar(12) not null,
	IdUsuario varchar(12) not null,
	FechaMovimiento date not null,
	HoraMovimiento time not null,
	Comentario varchar(120) null,
	Movimiento varchar(6) not null,	
	Entrada decimal(18,4) null,
	Salidas decimal(18,4) null,
	Saldo decimal(18,4) null
	primary key(IdMovimientoCaja,IdCaja)
)
go


alter procedure Sp_Lista_Movimiento_Caja_ById 
@IdCaja varchar(12)
as
	begin
		select m.FechaMovimiento,m.HoraMovimiento,m.Comentario,m.Movimiento,m.Entrada,m.Salidas
		 from MovimientoCajaTB as m where IdCaja = @IdCaja order by m.FechaMovimiento asc
	end
go


create function [dbo].[Fc_Caja_Codigo_Alfanumerico] ()  returns varchar(12)
	as
		begin
		declare @Incremental int,@ValorActual varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdMovimientoInventario from MovimientoInventarioTB)
					begin					
						set @ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdCaja,'CJ',''),'','')AS INT)) from CajaTB)
						set @Incremental = CONVERT(INT,@ValorActual) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'CJ000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'CJ00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'CJ0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'CJ'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'CJ0001'
					end
			end
			return @CodGenerado
		end
go