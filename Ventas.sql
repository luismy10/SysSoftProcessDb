use PuntoVentaSysSoftDB
go

select * from VentaTB
go

truncate table  VentaTB
go

/*
se agrega la columna moneda int
se cambio al campo estado de tipo de dato de un varchar a un int
*/

create table VentaTB(
	IdVenta varchar(12) not null,
	Cliente varchar(12) null,
	Vendedor varchar(12) not null,
	Comprobante int not null,
	Moneda int not null,
	Serie varchar(8) not null,
	Numeracion varchar(16) not null,
	FechaVenta datetime not null,
	SubTotal decimal(18,2) not null,
	Gravada decimal(18,2) not null,
	Descuento decimal(18,2) not null,
	Igv decimal(18,2) not null,
	Total decimal(18,2) not null,
	Estado int null,
	Observaciones varchar(200) null,	
	primary key(IdVenta)
)
go

Sp_Listar_Ventas ''
GO

alter procedure Sp_Listar_Ventas
@search varchar(100)
as
select ROW_NUMBER() over( order by v.IdVenta desc) as Filas ,
IdVenta,
v.FechaVenta,
c.Apellidos + ' '+c.Nombres as Cliente,
td.Nombre as Comprobante,
v.Serie,v.Numeracion,
dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
m.Abreviado,
v.Total,
v.Observaciones
from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
inner join TipoDocumentoTB as td on v.Comprobante = IdTipoDocumento
inner join MonedaTB as m on v.Moneda = m.IdMoneda
where 
(CAST(FechaVenta as date) = cast(GETDATE() as date) and @search = '')
OR (CONCAT(Serie,'-',Numeracion) LIKE @search+'%')
OR (
	(CONCAT(c.Apellidos,'',c.Nombres) LIKE @search+'%')
	OR
	(CONCAT(c.Nombres,' ',c.Apellidos) LIKE @search+'%')
)
go

alter procedure Sp_Listar_Ventas_By_Date
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@Comprobante int,
@Estado int
as
select ROW_NUMBER() over( order by v.IdVenta desc) as Filas ,
IdVenta,
v.FechaVenta,
c.Apellidos + ' '+c.Nombres as Cliente,
td.Nombre as Comprobante,
v.Serie,v.Numeracion,
dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
m.Abreviado,
v.Total,
v.Observaciones
from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
inner join TipoDocumentoTB as td on v.Comprobante = td.IdTipoDocumento
inner join MonedaTB as m on v.Moneda = m.IdMoneda
where 
(
	CAST(FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0 AND @Estado = 0
)
OR
(
	CAST(FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante AND v.Estado = @Estado
)
OR
(
	CAST(FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante  AND @Estado = 0
)
OR
(
	CAST(FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0  AND v.Estado = @Estado
)


go

select  dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,m.Simbolo,v.Total
from VentaTB as v inner join MonedaTB as m on v.Moneda = m.IdMoneda
where v.IdVenta = ?
go


alter procedure Sp_Listar_Ventas_Detalle_By_Id 
@IdVenta varchar(12)
as
	select ROW_NUMBER() over( order by d.IdArticulo desc) as Filas ,a.IdArticulo,a.NombreMarca,a.UnidadVenta,d.Cantidad,d.PrecioUnitario,d.Descuento,d.Importe
	 from DetalleVentaTB as d inner join ArticuloTB as a on d.IdArticulo = a.IdArticulo
	 where d.IdVenta = @IdVenta
go


create function Fx_Obtener_Cliente_By_Id
(
@Cliente varchar(12)
) returns varchar(60)

as
	begin
		declare @datos varchar(60)
		set @datos=	(select Apellidos+' '+Nombres from ClienteTB where IdCliente = @Cliente)
		return @datos
	end
go

print dbo.Fc_Venta_Codigo_Alfanumerico()
go

alter function Fc_Venta_Codigo_Alfanumerico ()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdVenta from VentaTB)
					begin					
						set @ValorActual = (select MAX(IdVenta) from VentaTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'VT000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'VT00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'VT0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'VT'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'VT0001'
					end
			end
			return @CodGenerado
		end
go

truncate table VentaTB
go
truncate table DetalleVentaTB
go
truncate table ComprobanteTB
go


select * from VentaTB where IdVenta = 'VT0003'
go
select * from DetalleVentaTB where IdVenta = 'VT0003'
go
select * from ComprobanteTB
go



create table DetalleVentaTB(
	IdVenta varchar(12) not null,
	IdArticulo varchar(12) not null,
	Cantidad decimal(18,2) not null,
	PrecioUnitario decimal(18, 2) not null,
	Descuento decimal(18, 2) null,
	Importe decimal(18, 2) not null,
	PRIMARY KEY (IdVenta,IdArticulo)
)
go


update ArticuloTB set Cantidad = Cantidad + ? where IdArticulo = ?
go

select e.Apellidos,e.Nombres 
from VentaTB as v inner join EmpleadoTB as e 
on v.Vendedor = e.IdEmpleado
where v.IdVenta = ?

SELECT Clave,NombreMarca FROM ArticuloTB
WHERE UnidadVenta = 2

go

select * from VentaTB
go

Sp_Reporte_General_Ventas '16/01/2019','22/02/2019',0

alter procedure Sp_Reporte_General_Ventas 
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@TipoDocumento int
as
select td.Nombre,cast(v.FechaVenta as date) as FechaVenta,c.Apellidos,c.Nombres,dbo.Fc_Obtener_Simbolo_Moneda(v.Moneda) as Simbolo,v.Total 
from VentaTB as v inner join TipoDocumentoTB as td on v.Comprobante = td.IdTipoDocumento
inner join ClienteTB as c on v.Cliente = c.IdCliente
where
( CAST(FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @TipoDocumento = 0)
or
( CAST(FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @TipoDocumento)
order by v.FechaVenta desc
go
