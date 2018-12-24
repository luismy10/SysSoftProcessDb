use PuntoVentaSysSoftDB
go

select * from VentaTB
go

truncate table  VentaTB
go


create table VentaTB(
	IdVenta varchar(12) not null,
	Cliente varchar(12) null,
	Vendedor varchar(12) not null,
	Comprobante int not null,
	Serie varchar(8) not null,
	Numeracion varchar(16) not null,
	FechaVenta datetime not null,
	SubTotal decimal(18,2) not null,
	Gravada decimal(18,2) not null,
	Descuento decimal(18,2) not null,
	Igv decimal(18,2) not null,
	Total decimal(18,2) not null,
	Estado varchar(70) null,
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
dbo.Fc_Obtener_Nombre_Detalle(v.Comprobante,'0009') Comprobante,
v.Serie,v.Numeracion,
v.Estado,
v.Total,
v.Observaciones
from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
where (cast(FechaVenta as date) = cast(GETDATE() as date) and @search = '')
or (CONCAT(Serie,'-',Numeracion) like @search+'%')
or (
	(CONCAT(c.Apellidos,'',c.Nombres) like @search+'%')
	or
	(CONCAT(c.Nombres,' ',c.Apellidos) like @search+'%')
	)
go

alter procedure Sp_Listar_Ventas_By_Date
@FechaInicial varchar(20),
@FechaFinal varchar(20)
as
select ROW_NUMBER() over( order by v.IdVenta desc) as Filas ,
IdVenta,
v.FechaVenta,
c.Apellidos + ' '+c.Nombres as Cliente,
dbo.Fc_Obtener_Nombre_Detalle(v.Comprobante,'0009') Comprobante,
v.Serie,v.Numeracion,
v.Estado,
v.Total,
v.Observaciones
from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
where CAST(FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal
go


alter procedure Sp_Listar_Ventas_Detalle_By_Id 'VT0005'
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




