use PuntoVentaSysSoftDB
go

----------------------------------------------compra-----------------------------------------------------------

truncate table CompraTB
go

create table CompraTB
(
	IdCompra varchar(12) primary key not null,
	Proveedor varchar(12) not null,
	Representante varchar(12) null,
	Comprobante int null,
	Numeracion varchar(20) null,
	FechaCompra datetime not null,
	SubTotal decimal(18,2) not null,
	Gravada decimal(18,2) not null,
	Descuento decimal(18,2) null,
	Igv decimal(18,2) null,
	Total decimal(18,2) not null
)
go


alter procedure Sp_Listar_Compras 
@Search varchar(100)
as
	
		select ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,c.IdCompra,p.IdProveedor,
		CAST(c.FechaCompra as Date) as Fecha,c.Numeracion,
		p.NumeroDocumento,p.RazonSocial,c.Total
		from CompraTB as c inner join ProveedorTB as p
		on c.Proveedor = p.IdProveedor
		where (@Search = '')
		or (c.Numeracion like @Search+'%') 
		or (p.NumeroDocumento like @Search+'%') 
		or (p.RazonSocial like '%'+@Search+'%')

go

alter procedure Sp_Listar_Compras_By_Fecha 
@FechaInicial varchar(20),
@FechaFinal varchar(20)
as
	
		select ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,c.IdCompra,p.IdProveedor,
		CAST(c.FechaCompra as Date) as Fecha,c.Numeracion,
		p.NumeroDocumento,p.RazonSocial,c.Total
		from CompraTB as c inner join ProveedorTB as p
		on c.Proveedor = p.IdProveedor
		where (CAST(c.FechaCompra as Date) BETWEEN @FechaInicial and @FechaFinal)

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
*/

create table DetalleCompraTB 
(
	IdCompra varchar(12) not null,
	IdArticulo varchar(12) not null,
	Cantidad decimal(18,2) null,
	PrecioCompra decimal(18,2) not null,
	Descuento decimal(182,2) null,
	PrecioVenta decimal(18,2) not null,
	Margen tinyint null,
	Utilidad decimal(18,2) null,
	PrecioVentaMayoreo decimal(18,2),
	MargenMayoreo tinyint null,
	UtilidadMayoreo decimal(18,2) null,
	Importe decimal(18,2) not null,
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

CREATE TABLE LoteTB (
  IdLote bigint NOT NULL identity,
  TipoLote bit NOT NULL,
  NumeroLote varchar(45) NOT NULL,
  FechaFabricacion date NOT NULL,
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

select  l.ExistenciaInicial,l.ExistenciaActual,l.FechaCaducidad from LoteTB as l
where l.IdArticulo = 'AT0001'
go

alter procedure Sp_Listar_Lote
@search varchar(60)
as
select ROW_NUMBER() over( order by lo.NumeroLote desc) as Filas, lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaFabricacion,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
from LoteTB as lo inner join ArticuloTB as ar
on lo.IdArticulo = ar.IdArticulo
where (@search = '') or (lo.NumeroLote like @search+'%') or (ar.Clave like @search+'%') or (ar.NombreMarca like '%'+@search+'%')
GO

insert into LoteTB(TipoLote,NumeroLote,FechaFabricacion,FechaCaducidad,ExistenciaInicial,ExistenciaActual,Estado,IdArticulo,IdCompra)
values()
go

update LoteTB
FechaFabricacion = ,
FechaCaducidad = ,
ExistenciaInicial = ,
ExistenciaActual ,
where IdLote = 
go

delete LoteTB
where IdLote
go


select CAST(FechaCompra as date) as Fecha,
dbo.Fc_Obtener_Nombre_Detalle(Comprobante,'0009') as Comprobante,
Numeracion,Total from CompraTB
where IdCompra = ? 
go


select p.NumeroDocumento,p.RazonSocial as Proveedor,p.Telefono,p.Celular,p.Direccion 
from CompraTB as c inner join ProveedorTB as p
on c.Proveedor = p.IdProveedor
where c.IdCompra = ?
go

select r.Apellidos,r.Nombres,r.Telefono,r.Celular
from CompraTB as c inner join RepresentanteTB as r
on c.Representante = r.IdRepresentante
where c.IdCompra = ?

