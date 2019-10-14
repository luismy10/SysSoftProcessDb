use PuntoVentaSysSoftDBDesarrollo
go

truncate table SuministroTB
go

select * from SuministroTB
go


create table SuministroTB(
	IdSuministro varchar(12) primary key not null,
	Origen int not null,
	Clave varchar(45) not null,
	ClaveAlterna varchar(45) null,
	NombreMarca varchar(120) not null,
	NombreGenerico varchar(120) null,
	Categoria int null,
	Marca int null,
	Presentacion int,
	UnidadCompra int,
	UnidadVenta tinyint,
	Estado int,
	StockMinimo decimal(18,4),
	StockMaximo decimal(18,4),
	Cantidad decimal(18,4),
	Impuesto int,
	PrecioCompra decimal(18,4),
	PrecioVentaGeneral decimal(18,4),	
	PrecioMargenGeneral smallint,
	PrecioUtilidadGeneral decimal(18,4),	
	Lote bit,
	Inventario bit,
	ValorInventario bit,
	Imagen varchar(MAX)
)


select * from SuministroTB
go

alter procedure Sp_Suministro_By_Id
@IdSuministro varchar(45)
as
	begin
		select IdSuministro,Origen,Clave,ClaveAlterna,NombreMarca,NombreGenerico,
		Categoria,dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as CategoriaNombre,
		Marca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as MarcaNombre,
		Presentacion,dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as PresentacionNombre,
		UnidadCompra,dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		UnidadVenta,
		StockMinimo,StockMaximo,Cantidad,PrecioCompra,PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,
		Estado,Lote,Inventario,ValorInventario,Imagen,
		Impuesto,dbo.Fc_Obtener_Nombre_Impuesto(Impuesto) as ImpuestoNombre,
		ClaveSat
		from SuministroTB
		where IdSuministro=@IdSuministro or Clave = @IdSuministro
	end
go

SELECT * FROM SuministroTB
GO

alter procedure Sp_Listar_Suministros_Lista_View 
@search varchar(100)
as
	begin
		select IdSuministro,Clave,NombreMarca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		Cantidad,PrecioCompra,
		PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
		UnidadVenta,Inventario,Impuesto,Lote,ValorInventario
		from SuministroTB 
		where (@search = '' and Estado = 1) 
		or 
		(Clave = @search and Estado = 1)
		or
		(ClaveAlterna = @search and Estado = 1)
		or
		(NombreMarca like @search +'%' and Estado = 1)
	end
go

create procedure Sp_Listar_Detalle_Compra_By_IdCompra
@IdCompra varchar(12)
as
	begin
		SELECT s.IdSuministro,s.Clave,s.NombreMarca,s.Cantidad,dbo.Fc_Obtener_Nombre_Detalle(s.UnidadCompra,'0013') as UnidadCompraNombre,
		s.PrecioCompra,s.PrecioVentaGeneral,dbo.Fc_Obtener_Nombre_Detalle(s.Categoria,'0006') as Categoria,dbo.Fc_Obtener_Nombre_Detalle(s.Estado,'0001') as Estado,
		s.Inventario,s.ValorInventario 
		FROM DetalleCompraTB as d INNER JOIN SuministroTB AS s ON d.IdArticulo = s.IdSuministro 
		WHERE d.IdCompra = @IdCompra
	end
go

ALTER procedure [dbo].[Sp_Listar_Suministros]
@Opcion tinyint,
@Clave varchar(45),
@NombreMarca varchar(120)
as
	begin
		select IdSuministro,Clave,ClaveAlterna,NombreMarca,Cantidad,dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		PrecioCompra,Impuesto,PrecioVentaGeneral,dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
		Inventario,ValorInventario 
		from SuministroTB
		where (@Opcion = 0) 
		or (Clave like @Clave+'%' and @Opcion = 1) 
		or (ClaveAlterna like @Clave+'%' and @Opcion = 1)
		or (NombreMarca like @NombreMarca+'%' and @Opcion = 2)
		or (
			(Clave like @NombreMarca+'%' and @Opcion = 3)
			 or 
			 (NombreMarca like @NombreMarca+'%' and @Opcion = 3)
			)
		or(IdSuministro = @Clave and @Opcion = 4)
	end
go

alter procedure Sp_Get_Suministro_For_Asignacion_By_Id
@IdSuministro varchar(12)
as
	begin
		select IdSuministro,Clave,NombreMarca,Cantidad,dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		PrecioCompra,PrecioVentaGeneral
		from SuministroTB
		where IdSuministro = @IdSuministro
	end
go

create procedure Sp_Listar_Inventario_Suministros
as
	select
	IdSuministro,Clave,NombreMarca,PrecioCompra,
	Cantidad,
	dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
	dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
	(PrecioCompra*Cantidad) as Total 
	from SuministroTB 
	where Inventario = 1 order by Total desc
go

go
create function [dbo].[Fc_Suministro_Codigo_Alfanumerico] ()  returns varchar(12)
	as
		begin
		declare @Incremental int,@ValorActual varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdSuministro from SuministroTB)
					begin					
						set @ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdSuministro,'SM',''),'','')AS INT)) from SuministroTB)
						set @Incremental = CONVERT(INT,@ValorActual) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'SM000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'SM00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'SM0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'SM'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'SM0001'
					end
			end
			return @CodGenerado
		end
go



create table KardexSuministroTB
(
	IdKardex int identity(1,1) not null,
	IdSuministro varchar(12) not null,
	Fecha date not null,
	Hora time not null,
	Tipo tinyint not null,
	Movimiento int not null,
	Detalle varchar(100) not null,
	Cantidad decimal(18,4) not null,
	CUnitario decimal(18,4) not null,
	CTotal decimal(18,4) not null,
	primary key(IdKardex,IdSuministro)
)
go

alter procedure Sp_Listar_Kardex_Suministro_By_Id
@idArticulo varchar(45)
as
SELECT k.IdSuministro,k.Fecha,k.Hora,k.Tipo,t.Nombre,
k.Detalle,k.Cantidad,k.CUnitario,k.CTotal
FROM KardexSuministroTB AS k INNER JOIN SuministroTB AS a ON k.IdSuministro = a.IdSuministro
inner join TipoMovimientoTB AS t ON k.Movimiento = t.IdTipoMovimiento
WHERE 
	(a.IdSuministro = @idArticulo )
	or
	(a.Clave = @idArticulo or a.ClaveAlterna = @idArticulo)

	order by k.Fecha,k.Hora asc
GO


truncate table SuministroTB
go
truncate table KardexSuministroTB
go
truncate table PreciosTB
go
truncate table MovimientoInventarioTB
go
truncate table MovimientoInventarioDetalleTB
go
truncate table AsignacionTB
go
truncate table AsignacionDetalleTB
go

update SuministroTB set ValorInventario = 0 where IdSuministro = 'SM0007'
go

select * from SuministroTB
go
select * from KardexSuministroTB
go
select * from PreciosTB
go
select * from MovimientoInventarioTB
go
select * from MovimientoInventarioDetalleTB
go

create table TipoMovimientoTB
(
	IdTipoMovimiento int identity(1,1)not null,
	Nombre varchar(100),
	Predeterminado bit not null,
	Sistema bit not null,
	Ajuste bit not null
)
go

TRUNCATE TABLE TipoMovimientoTB
GO
select * from TipoMovimientoTB
go

     

create function [dbo].[Fc_MovimientoInventario_Codigo_Alfanumerico] ()  returns varchar(12)
	as
		begin
		declare @Incremental int,@ValorActual varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdMovimientoInventario from MovimientoInventarioTB)
					begin					
						set @ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdMovimientoInventario,'IN',''),'','')AS INT)) from MovimientoInventarioTB)
						set @Incremental = CONVERT(INT,@ValorActual) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'IN000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'IN00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'IN0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'IN'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'IN0001'
					end
			end
			return @CodGenerado
		end
go

create table MovimientoInventarioDetalleTB
(
	IdMovimientoInventario varchar(12) not null,
	IdSuministro varchar(12) not null,
	Cantidad decimal(18,4) not null,
	Costo decimal(18,4) not null,
	Precio decimal(18,4) not null
	primary key(IdMovimientoInventario,IdSuministro) 
)
go

select  *from MovimientoInventarioTB
go

select * from MovimientoInventarioDetalleTB
go

go

select * from MovimientoInventarioTB
go

Sp_Listar_Movimiento_Inventario 1,2,'2019-09-28','2019-09-28'
go

alter procedure Sp_Listar_Movimiento_Inventario
@init bit,
@opcion tinyint,
@movimiento int,
@fechaInicial varchar(50),
@fechaFinal varchar(50)
as
	select mv.IdMovimientoInventario, mv.Fecha, mv.Hora, mv.TipoAjuste, UPPER(tm.Nombre) as TipoMovimiento, UPPER(mv.Observacion) as Observacion,
	case 
		when mv.Suministro = 1 and mv.Articulo = 0 then 'MOVIMIENTO DE SUMINISTROS'
		when mv.Suministro = 1 and mv.Articulo = 1 then 'MOVIMIENTO DE SUMINISTROS A ARTÍCULOS'
		when mv.Suministro = 0 and mv.Articulo = 1 then 'MOVIMIENTO DE ARTÍCULOS'
	end as Informacion,
	case
		when mv.Proveedor = '' then 'Proveedor no especificado'
		when mv.Proveedor <> '' then dbo.Fc_Obtener_Datos_Proveedor(mv.Proveedor)
	end as Proveedor,
	case
		when mv.Estado = 0 then 'EN PROCESO'
		when mv.Estado = 1 then 'COMPLETADO'
		when mv.Estado = 2 then 'CANCELADO'
	end as Estado
	from MovimientoInventarioTB mv inner join TipoMovimientoTB as tm on mv.TipoMovimiento = tm.IdTipoMovimiento
	where 
	(
		(
		 (@opcion = 1 and @init = 0)
		 or
		 (@opcion = 1 and mv.Fecha between cast(@fechaInicial as date) and cast(@fechaFinal as date) and @movimiento = 0)
		 or
		 (@opcion = 1 and mv.Fecha between cast(@fechaInicial as date) and cast(@fechaFinal as date) and mv.TipoMovimiento = @movimiento)
		)
	) 
	or
	(
		(
		(@opcion = 2 and mv.Articulo = 1 and @init = 0)
		or
		(@opcion = 2 and mv.Articulo = 1 and mv.Fecha between cast(@fechaInicial as date) and cast(@fechaFinal as date) and @movimiento = 0)
		or
		(@opcion = 2 and mv.Articulo = 1 and mv.Fecha between cast(@fechaInicial as date) and cast(@fechaFinal as date) and mv.TipoMovimiento = @movimiento)
		)
	)
	order by mv.Fecha desc,mv.Hora desc
go

select * from MovimientoInventarioTB
go

create procedure Sp_Get_Movimiento_Inventario_By_Id
@idMovimientoInventario varchar(12)
as
	select UPPER(tm.Nombre) as TipoMovimiento,mv.Fecha, mv.Hora, UPPER(mv.Observacion) as Observacion,
	case
		when mv.Proveedor = '' then 'Proveedor no especificado'
		when mv.Proveedor <> '' then dbo.Fc_Obtener_Datos_Proveedor(mv.Proveedor)
	end as Proveedor,
	case
		when mv.Estado = 0 then 'EN PROCESO'
		when mv.Estado = 1 then 'COMPLETADO'
		when mv.Estado = 2 then 'CANCELADO'
	end as Estado
	from MovimientoInventarioTB mv inner join TipoMovimientoTB as tm on mv.TipoMovimiento = tm.IdTipoMovimiento
	where mv.IdMovimientoInventario = @idMovimientoInventario 
go

create function Fc_Obtener_Datos_Proveedor
(
@idProveedor varchar(12)
) returns varchar(60)

as
	begin
		declare @datos varchar(100)
		set @datos=	(select RazonSocial from ProveedorTB where IdProveedor = @idProveedor)
		return @datos
	end
go


create table AsignacionTB(
	IdAsignacion varchar(12) not null,
	IdArticulo varchar(12) not null,
	Hora date not null,
	Fecha time not null,
	Cantidad decimal(18,4) not null,
	Costo decimal(18,4) not null,
	Precio decimal(18,4) not null,
	primary key(IdAsignacion)
)
go

create table AsignacionDetalleTB(
	IdAsignacion varchar(12) not null,
	IdSuministro varchar(12) not null,
	Cantidad decimal(18,4) not null,
	Costo decimal(18,4) not null,
	Precio decimal(18,4) not null,
	Movimiento decimal(18,4) not null,
	Estado bit not null,
	primary key(IdAsignacion,IdSuministro)
)
go




select * from AsignacionTB
go
select * from AsignacionDetalleTB
go

create function [dbo].[Fc_Asignacion_Codigo_Alfanumerico] ()  returns varchar(12)
	as
		begin
		declare @Incremental int,@ValorActual varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdAsignacion from AsignacionTB)
					begin					
						set @ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdAsignacion,'AS',''),'','')AS INT)) from AsignacionTB)
						set @Incremental = CONVERT(INT,@ValorActual) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'AS000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'AS00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'AS0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'AS'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'AS0001'
					end
			end
			return @CodGenerado
		end
go