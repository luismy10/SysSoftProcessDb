use [PuntoVentaSysSoftDBDesarrollo]
go

----------------------------------------------compra-----------------------------------------------------------

/*
 se quito el campo representante
 Agregado campo(s) ipoMoneda 15/02/19
 Modificado SubTotal, Descuento y Total a 4 decimales 16/02/19
 Agregado campos(s) Observaciones y Notas 16/02/19
 Agrego campos TipoCompra y EstadoCompra 28/02/2019

*/
create table CompraTB
(
	IdCompra varchar(12) primary key not null,
	Proveedor varchar(12) not null,
	--Representante varchar(12) null,
	Comprobante int null,
	Numeracion varchar(20) null,
	TipoMoneda int not null,
	Fecha date not null,
	Hora time not null,
	SubTotal decimal(18,4) not null,
	--Gravada decimal(18,2) not null,
	Descuento decimal(18,4) null,
	--Igv decimal(18,2) null,
	Total decimal(18,4) not null,
	Observaciones varchar(300) null,
	Notas varchar(300) null,
	TipoCompra int null,
	EstadoCompra int null,
	Usuario varchar(12) not null
)
go 

select * from CompraTB
go

exec Sp_Listar_Compras 1,'','26/08/2019','26/08/2019',0
go

select * from CompraTB where IdCompra = 'CP0001' and EstadoCompra = 3
go

select IdCompra,Proveedor,dbo.Fc_Obtener_Datos_Proveedor(Proveedor) as DatosProveedor,Fecha,Comprobante,Numeracion,TipoMoneda,Observaciones,Notas from CompraTB
go


SELECT * FROM CompraTB WHERE IdCompra = 'CP0001' AND EstadoCompra = 3
go

select d.IdArticulo,s.Clave,s.NombreMarca,d.Cantidad,d.PrecioCompra,d.Descuento,d.Importe,d.Descripcion from DetalleCompraTB as d inner join SuministroTB as s on d.IdArticulo = s.IdSuministro
 where d.IdCompra = 'CP0001'
go

ALTER procedure [dbo].[Sp_Listar_Compras]
@Opcion bigint,
@Search varchar(100),
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@EstadoCompra int
as
select ROW_NUMBER() over( order by c.Fecha desc) as Filas,c.IdCompra,p.IdProveedor,
			c.Fecha,c.Hora,c.Numeracion,
			p.NumeroDocumento,p.RazonSocial,
			dbo.Fc_Obtener_Nombre_Detalle(c.TipoCompra,'0015') Tipo,
			dbo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') Estado,
			dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total
			from CompraTB as c inner join ProveedorTB as p
			on c.Proveedor = p.IdProveedor
			where (@Search = '' and @Opcion = 0)
				or (c.Numeracion like @Search+'%' and @Opcion = 0) 
				or (p.NumeroDocumento like @Search+'%' and @Opcion = 0) 
				or (p.RazonSocial like '%'+@Search+'%' and @Opcion = 0)

				or (CAST(c.Fecha as Date) BETWEEN @FechaInicial and @FechaFinal and @Opcion = 1)

				or (CAST(c.Fecha as Date) BETWEEN @FechaInicial and @FechaFinal and c.EstadoCompra = @EstadoCompra and @Opcion = 2) 
	order by c.Fecha desc ,
	c.Hora desc
go



create function Fc_Obtener_Simbolo_Moneda
	(
	 @IdMoneda int
	)
	RETURNS VARCHAR(10)
	AS
	BEGIN
		DECLARE @Result VARCHAR(10)
			BEGIN
				SET @Result = (SELECT Simbolo FROM MonedaTB WHERE IdMoneda = @IdMoneda)	
			END
			RETURN @Result
	END
go

create function Fc_Compra_Codigo_Alfanumerico ()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdCompra from CompraTB)
					begin					
						set @ValorActual = (select MAX(IdCompra) from CompraTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'CP000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'CP00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'CP0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'CP'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'CP0001'
					end
			end
			return @CodGenerado
		end
go


/*
 varios campos nuevos  Descuento,Margen,Utilidad,PrecioVentaMayoreo,MargenMayoreo,UtilidadMayoreo 23//11/2018

 se quito varios campos PrecioVentaMayoreo etc

 Agrego campos NombreImpuesto, ValorImpuesto e ImpuestoSumado (15/02/19)
 Modificado Cantidad, PrecioCompra, Descuento, PrecioVenta, Utilidad, NombreImpuesto, ValorImpuesto, ImpuestoSumado y Importe a cuatro deciamles (16/02/19)
 Agregado campo IdImpuesto (16/02/19)

 Actulizado campos PrecioVenta, Margen  y Utilidad a PrecioVenta1, Margen1 y Utilidad1 22/02719
 Agregado campos PrecioVenta2, Margen2, Utilidad2, PrecioVenta3, Margen3 y Utilidad3 22/02719

 quitar los campos de precio

*/

select * from DetalleCompraTB
go

create table DetalleCompraTB 
(
	IdCompra varchar(12) not null,
	IdArticulo varchar(12) not null,
	Cantidad decimal(18,4) null,
	PrecioCompra decimal(18,4) not null,
	Descuento decimal(18,4) null,

	--PrecioVenta1 decimal(18,4) null,
	--Margen1 tinyint null,
	--Utilidad1 decimal(18,4) null,

	--PrecioVenta2 decimal(18,4) null,
	--Margen2 tinyint null,
	--Utilidad2 decimal(18,4) null,
	--PrecioVenta3 decimal(18,4) null,
	--Margen3 tinyint null,
	--Utilidad3 decimal(18,4) null,

	IdImpuesto int null,
	NombreImpuesto varchar(12) null,
	ValorImpuesto decimal(18,4) null,
	ImpuestoSumado decimal(18,4) null,
	--PrecioVentaMayoreo decimal(18,2),
	--MargenMayoreo tinyint null,
	--UtilidadMayoreo decimal(18,2) null,
	Importe decimal(18,4) not null,
	Descripcion varchar(120) null,
	PRIMARY KEY (IdCompra,IdArticulo)
)
go



truncate table CompraTB
go
truncate table DetalleCompraTB
go
truncate table LoteTB
go
truncate table CuentasProveedorTB
go
truncate table CuentasHistorialProveedorTB
go


select * from CompraTB
go
select * from DetalleCompraTB where IdCompra = 'CP0007'
go
select * from LoteTB
go
select * from CuentasProveedorTB
go
select * from CuentasHistorialProveedorTB
go
select * from PlazosTB
go


Sp_Listar_Compras_For_Movimiento '','2019-09-15', 1

ALTER procedure [dbo].[Sp_Listar_Compras_For_Movimiento] 
@Search varchar(120),
@fecha varchar(20),
@Opcion tinyint
as
	select c.IdCompra,c.Fecha,c.Hora,c.Numeracion,p.RazonSocial,dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total from CompraTB as c inner join ProveedorTB as p on c.Proveedor = p.IdProveedor
	where 
	(@Search = '' and @fecha = '' and c.EstadoCompra != 3)
	or (c.Numeracion like @Search+'%' and @Opcion = 0 and c.EstadoCompra != 3) 
	or (p.NumeroDocumento like @Search+'%' and @Opcion = 0 and c.EstadoCompra != 3) 
	or (p.RazonSocial like '%'+@Search+'%' and @Opcion = 0 and c.EstadoCompra != 3)
	or (cast(c.Fecha as date) = @fecha and @Opcion = 1 and c.EstadoCompra != 3)
	order by c.Fecha desc,c.Hora desc
go


select FORMAT(CAST(FechaCompra as date),'MMMM/dd/yyyy') as Fecha,dbo.Fc_Obtener_Nombre_Detalle(Comprobante,'0009') as Comprobante,Numeracion,Total from CompraTB
where IdCompra = 'CP0001'
go

select ROW_NUMBER() over( order by a.Clave desc) as Filas ,a.Clave,a.NombreMarca, d.Cantidad,d.PrecioCompra,d.Importe from DetalleCompraTB as d inner join ArticuloTB as a
on d.IdArticulo = a.IdArticulo
where d.IdCompra = 'CP0001'
go

SELECT 
ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,
	c.FechaCompra,
	p.NumeroDocumento,p.RazonSocial,
	c.Total
FROM CompraTB as c inner join ProveedorTB as p
on c.Proveedor = p.IdProveedor
go

go

select * from CompraTB
go

ALTER procedure [dbo].[Sp_Listar_Detalle_Compra]
@IdCompra varchar(12)
as
select s.IdSuministro,
s.Clave,s.NombreMarca,d.Cantidad,s.UnidadVenta,dbo.Fc_Obtener_Nombre_Detalle(s.UnidadCompra,'0013') as UnidadCompra ,d.PrecioCompra,d.Descuento,d.IdImpuesto,d.ValorImpuesto,d.ImpuestoSumado,d.Importe
from DetalleCompraTB as d inner join SuministroTB as s
on d.IdArticulo = s.IdSuministro
where d.IdCompra = @IdCompra

go


-- Borrado TipoLote, FechaFabricacion (15/02/19)

CREATE TABLE LoteTB (
  IdLote bigint NOT NULL identity,
  --TipoLote bit NOT NULL,
  NumeroLote varchar(45) NOT NULL,
  --FechaFabricacion date NOT NULL,
  FechaCaducidad date NOT NULL,
  ExistenciaInicial decimal(18,2) NOT NULL,
  ExistenciaActual decimal(18,2) NOT NULL,
  IdArticulo varchar(12) NOT NULL,
  IdCompra varchar(12) DEFAULT NULL,
  --`tra_id` bigint(20) DEFAULT NULL, trasparo
  --`ven_id` bigint(20) DEFAULT NULL, ventas
  --`ncr_id` bigint(20) DEFAULT NULL nota de credio
  PRIMARY KEY (IdLote)
  --KEY `fk_lote_articulo1` (`art_id`),
  --KEY `fk_lote_compra1` (`com_id`),
  --KEY `fk_lote_traspaso1` (`tra_id`),
  --KEY `fk_lote_venta1` (`ven_id`),
  --KEY `fk_lote_notaCredito1` (`ncr_id`)
)
go

select * from DetalleTB where IdMantenimiento = '0009'
go

ALTER procedure Sp_Obtener_Compra_ById
@IdCompra varchar(12)
as
	select c.Fecha, c.Hora,c.Comprobante, c.Numeracion,
	dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,
	dbo.Fc_Obtener_Nombre_Detalle(c.TipoCompra,'0015') as Tipo,
	dbo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') as Estado,
	c.Total,c.Observaciones,c.Notas,td.Nombre 
	from CompraTB as c inner join TipoDocumentoTB as td on c.Comprobante=td.IdTipoDocumento 
	where c.IdCompra = @IdCompra
go

select * from LoteTB
go

alter procedure Sp_Listar_Lote
@opcion bigint,
@search varchar(60)
as
select ROW_NUMBER() over( order by lo.IdLote desc) as Filas, lo.IdLote,lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
		from LoteTB as lo inner join SuministroTB as ar
		on lo.IdArticulo = ar.IdSuministro
		where (@search = '' and @opcion = 0)
		 or (lo.NumeroLote like @search+'%' and @opcion = 0) 
		 or (ar.Clave like @search+'%' and @opcion = 0) 
		 or (ar.NombreMarca like '%'+@search+'%' and @opcion = 0)
		 or (GETDATE() <= lo.FechaCaducidad and DATEDIFF(day, GETDATE(), lo.FechaCaducidad)<=15 and @opcion = 1)
		 or	(lo.FechaCaducidad <= CAST(GETDATE() AS DATE) and @opcion = 2)
				 
		 order by lo.FechaCaducidad asc 
GO

create table CuentasProveedorTB(
	IdCompra varchar(12) not null,
	IdCuentasProveedor int identity not null,
	MontoTotal decimal(18,4) not null,
	Plazos int not null,
	FechaPago date not null,
	FechaRegistro date not null,
	primary key(IdCompra,IdCuentasProveedor)
)
go

ALTER procedure Sp_Get_Cuentas_Proveedor_By_IdCompra
@idCompra varchar(12)
as
	begin
		select IdCuentasProveedor,MontoTotal,
		dbo.Fc_Obtener_Datos_Plazos(Plazos) as Plazos,
		FechaPago,FechaRegistro
		from CuentasProveedorTB where IdCompra = @idCompra
	end
go

create table CuentasHistorialProveedorTB(
	IdCuentasHistorialProveedor int identity not null,
	IdCuentasProveedor int not null,
	Monto decimal(18,4),
	Cuota int,
	Fecha date,
	Hora time,
	Observacion varchar(120),
	Estado tinyint,
	Usuario varchar(12),
	primary key(IdCuentasHistorialProveedor)
)
go


/*
 Agregado Tabla PlazosTB 02/03/19
*/
create table PlazosTB(
	IdPlazos int primary key identity(1,1) not null,
	Nombre varchar(15) null,
	Dias int null,
	Estado bit null,
	Predeterminado bit null
)

go


ALTER function Fc_Obtener_Datos_Plazos
(
@IdPlazos int
) returns varchar(15)
as
	begin
		declare @datos varchar(15)
		if exists(select Nombre from PlazosTB where IdPlazos = @IdPlazos)
			begin
				set @datos= (select Nombre from PlazosTB where IdPlazos = @IdPlazos)
			end
		else 
			begin
				set @datos= 'DATOS NO ENCONTRADOS'
			end
		return @datos
	end
go