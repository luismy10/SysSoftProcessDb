use PuntoVentaSysSoftDB
go

----------------------------------------------compra-----------------------------------------------------------

/*
 Agregado campo(s) ipoMoneda 15/02/19
 Modificado SubTotal, Descuento y Total a 4 decimales 16/02/19
 Agregado campos(s) Observaciones y Notas 16/02/19
*/
create table CompraTB
(
	IdCompra varchar(12) primary key not null,
	Proveedor varchar(12) not null,
	Representante varchar(12) null,
	Comprobante int null,
	Numeracion varchar(20) null,
	TipoMoneda int not null,
	FechaCompra datetime not null,
	SubTotal decimal(18,4) not null,
	--Gravada decimal(18,2) not null,
	Descuento decimal(18,4) null,
	--Igv decimal(18,2) null,
	Total decimal(18,4) not null,
	Observaciones varchar(300) null,
	Notas varchar(300) null
)
go


alter procedure Sp_Listar_Compras
@Opcion bigint,
@Search varchar(100),
@FechaInicial varchar(20),
@FechaFinal varchar(20)
as
	if(@Opcion = 1)
		begin
			select ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,c.IdCompra,p.IdProveedor,
			CAST(c.FechaCompra as Date) as Fecha,c.Numeracion,
			p.NumeroDocumento,p.RazonSocial,dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total
			from CompraTB as c inner join ProveedorTB as p
			on c.Proveedor = p.IdProveedor
			where (@Search = '')
			or (c.Numeracion like @Search+'%') 
			or (p.NumeroDocumento like @Search+'%') 
			or (p.RazonSocial like '%'+@Search+'%')
		end
	else
		begin
			select ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,c.IdCompra,p.IdProveedor,
			CAST(c.FechaCompra as Date) as Fecha,c.Numeracion,
			p.NumeroDocumento,p.RazonSocial,dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total
			from CompraTB as c inner join ProveedorTB as p
			on c.Proveedor = p.IdProveedor
			where (CAST(c.FechaCompra as Date) BETWEEN @FechaInicial and @FechaFinal)
		end
		

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

*/

create table DetalleCompraTB 
(
	IdCompra varchar(12) not null,
	IdArticulo varchar(12) not null,
	Cantidad decimal(18,4) null,
	PrecioCompra decimal(18,4) not null,
	Descuento decimal(18,4) null,

	PrecioVenta1 decimal(18,4) null,
	Margen1 tinyint null,
	Utilidad1 decimal(18,4) null,
	PrecioVenta2 decimal(18,4) null,
	Margen2 tinyint null,
	Utilidad2 decimal(18,4) null,
	PrecioVenta3 decimal(18,4) null,
	Margen3 tinyint null,
	Utilidad3 decimal(18,4) null,

	IdImpuesto int null,
	NombreImpuesto varchar(12) null,
	ValorImpuesto decimal(18,4) null,
	ImpuestoSumado decimal(18,4) null,
	--PrecioVentaMayoreo decimal(18,2),
	--MargenMayoreo tinyint null,
	--UtilidadMayoreo decimal(18,2) null,
	Importe decimal(18,4) not null,
	PRIMARY KEY (IdCompra,IdArticulo)
)
go



truncate table CompraTB
go
truncate table DetalleCompraTB
go
truncate table LoteTB
go

select * from CompraTB
go
select * from DetalleCompraTB
go
select * from LoteTB
go

select p.NumeroDocumento,p.RazonSocial as Proveedor from CompraTB as c inner join ProveedorTB as p
on c.Proveedor = p.IdProveedor
where c.IdCompra = 'CP0001'
go

select p.ApellidoPaterno,p.ApellidoMaterno,p.PrimerNombre,P.SegundoNombre from CompraTB as c inner join PersonaTB as p
on c.Representante = p.IdPersona
where c.IdCompra = 'CP0003'
go

select d.Atributo,d.Valor from ProveedorTB as p inner join DirectorioTB as d
on p.IdProveedor = d.IdPersona
where d.IdPersona = 'PR0001'
go

select d.Atributo,d.Valor from PersonaTB as p inner join DirectorioTB as d
on p.IdPersona = d.IdPersona
where d.IdPersona = 'PE0001'
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

create procedure Sp_Listar_Detalle_Compra
@IdCompra varchar(12)
as
select 
a.Clave,a.NombreMarca,d.Cantidad,a.UnidadVenta,dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra ,d.PrecioCompra,d.Descuento,d.IdImpuesto,d.ValorImpuesto,d.ImpuestoSumado,d.Importe
from DetalleCompraTB as d inner join ArticuloTB as a
on d.IdArticulo = a.IdArticulo
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

truncate table LoteTB
go
select * from LoteTB
go


alter procedure Sp_Listar_Lote
@opcion bigint,
@search varchar(60)
as
if(@opcion = 0)
	begin
		select ROW_NUMBER() over( order by lo.IdLote desc) as Filas, lo.IdLote,lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
		from LoteTB as lo inner join ArticuloTB as ar
		on lo.IdArticulo = ar.IdArticulo
		where (@search = '')
		 or (lo.NumeroLote like @search+'%') 
		 or (ar.Clave like @search+'%') 
		 or (ar.NombreMarca like '%'+@search+'%')
	end
else if(@opcion = 1)
	
	begin
		select ROW_NUMBER() over( order by lo.IdLote desc) as Filas, lo.IdLote,lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
		from LoteTB as lo inner join ArticuloTB as ar
		on lo.IdArticulo = ar.IdArticulo
		where GETDATE() <= lo.FechaCaducidad and DATEDIFF(day, GETDATE(), lo.FechaCaducidad)<=15 order by lo.FechaCaducidad asc 
	end
else if(@opcion = 2)
	begin
		select ROW_NUMBER() over( order by lo.IdLote desc) as Filas, lo.IdLote,lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
		from LoteTB as lo inner join ArticuloTB as ar
		on lo.IdArticulo = ar.IdArticulo
		where lo.FechaCaducidad <= CAST(GETDATE() AS DATE) order by lo.FechaCaducidad desc
	end
GO

SELECT COUNT(FechaCaducidad) AS Caducados FROM LoteTB WHERE FechaCaducidad < CAST(GETDATE() AS DATE)

select DATEDIFF(day, FechaCaducidad,GETDATE()) from LoteTB 

