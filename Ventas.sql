use PuntoVentaSysSoftDB
go

select * from VentaTB
go 


/*
se agrega la columna moneda int
se cambio al campo estado de tipo de dato de un varchar a un int
cambio de la longitud del detalle de venta
y quital algunos campos
agregar tipo de venta
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
	SubTotal decimal(18,4) not null,
	--Gravada decimal(18,2) not null,
	Descuento decimal(18,4) not null,
	--Igv decimal(18,2) not null,
	Total decimal(18,4) not null,
	Tipo int not null,
	Estado int null,
	Observaciones varchar(200) null,
	Efectivo decimal(18,4) not null,
	Vuelto decimal(18,4) not null,	
	primary key(IdVenta)
)
go

select * from EmpleadoTB
go

Sp_Listar_Ventas '',
GO

alter procedure Sp_Listar_Ventas
@opcion smallint,
@search varchar(100),
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@Comprobante int,
@Estado int,
@Vendedor varchar(12)
as
if(@opcion = 1)
	begin
		select ROW_NUMBER() over( order by v.IdVenta desc) as Filas ,
		IdVenta,
		v.FechaVenta,
		c.Apellidos + ' '+c.Nombres as Cliente,
		td.Nombre as Comprobante,
		v.Serie,v.Numeracion,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Simbolo,
		v.Total,
		v.Observaciones
		from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as td on v.Comprobante = IdTipoDocumento
		inner join MonedaTB as m on v.Moneda = m.IdMoneda
		where 
		(Vendedor = @Vendedor and @search = '' and CAST(v.FechaVenta as date) = CAST(GETDATE() as date) )
		OR (Vendedor = @Vendedor and @search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE @search+'%' )
		OR (
			(Vendedor = @Vendedor and @search <> '' AND CONCAT(c.Apellidos,'',c.Nombres) LIKE @search+'%')
			OR
			(Vendedor = @Vendedor and @search <> '' AND CONCAT(c.Nombres,' ',c.Apellidos) LIKE @search+'%')
		)
	end
else
	begin
		select ROW_NUMBER() over( order by v.IdVenta desc) as Filas ,
		IdVenta,
		v.FechaVenta,
		c.Apellidos + ' '+c.Nombres as Cliente,
		td.Nombre as Comprobante,
		v.Serie,v.Numeracion,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Simbolo,
		v.Total,
		v.Observaciones
		from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as td on v.Comprobante = td.IdTipoDocumento
		inner join MonedaTB as m on v.Moneda = m.IdMoneda
		where 
		(Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0 AND @Estado = 0
		)
		OR
		(Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante AND v.Estado = @Estado
		)
		OR
		(Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante  AND @Estado = 0
		)
		OR
		(Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0  AND v.Estado = @Estado
		)
	end

go


select  dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,m.Simbolo,v.Total
from VentaTB as v inner join MonedaTB as m on v.Moneda = m.IdMoneda 
where v.IdVenta = ?
go

select * from ArticuloTB
go

alter procedure Sp_Listar_Ventas_Detalle_By_Id 
@IdVenta varchar(12)
as
	select /*ROW_NUMBER() over( order by d.IdArticulo desc) as Filas ,*/
	d.IdArticulo,a.Clave,a.NombreMarca,a.Inventario,a.ValorInventario,
	dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra,
	d.IdImpuesto,
	d.Cantidad,d.CantidadGranel,d.PrecioVenta,
	d.Descuento,d.ValorImpuesto,
	d.ImpuestoSumado,d.Importe
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
truncate table CuentasClienteTB
go
truncate table CuentasHistorialClienteTB
go

select * from VentaTB
go
select * from DetalleVentaTB where IdVenta = 'VT0005'
go
select * from ComprobanteTB
go
select * from CuentasClienteTB
go
select * from CuentasHistorialClienteTB
go


create table DetalleVentaTB(
	IdVenta varchar(12) not null,
	IdArticulo varchar(12) not null,
	Cantidad decimal(18,4) not null,
	CostoVenta decimal(18,4) not null,
	PrecioVenta decimal(18, 4) not null,
	Descuento decimal(18, 4) null,

	IdImpuesto int null,
	NombreImpuesto varchar(12) null,
	ValorImpuesto decimal(18,4) null,
	ImpuestoSumado decimal(18,4) null,

	Importe decimal(18, 4) not null,
	PRIMARY KEY (IdVenta,IdArticulo)
)
go

update ArticuloTB set Cantidad = Cantidad + ? where IdArticulo = ?
go

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

select * from ImpuestoTB
go

alter procedure Sp_Obtener_Venta_ById
@idVenta varchar(12)
as
	begin
		select  v.FechaVenta,c.Apellidos,c.Nombres,t.Nombre as Comprobante,t.NombreImpresion,
		v.Serie,v.Numeracion,v.Observaciones,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Simbolo,Efectivo,Vuelto
        from VentaTB as v inner join MonedaTB as m on v.Moneda = m.IdMoneda
		inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as t on v.Comprobante = t.IdTipoDocumento
        where v.IdVenta = @idVenta
	end
go

create table CuentasClienteTB(
	IdCuentaClientes int identity(1,1) not null,
	IdVenta varchar(12) not null,
	IdCliente varchar(12) not null,
	Plazos int not null,
	FechaVencimiento datetime not null,
	MontoInicial decimal(18,4) not null
	primary key(IdCuentaClientes)
)
go

select * from CuentasClienteTB
go
select * from CuentasHistorialClienteTB
go

alter procedure Sp_Get_CuentasCliente_By_Id
@IdVenta VARCHAR(12)
as
SELECT c.IdCuentaClientes,c.IdCliente,p.Nombre,c.FechaVencimiento,MontoInicial 
FROM CuentasClienteTB as c inner join PlazosTB as p
on c.Plazos = p.IdPlazos
WHERE c.IdVenta = @IdVenta
go

create table CuentasHistorialClienteTB(
	IdCuentasHistorialCliente int identity(1,1) not null,
	IdCuentaClientes int not null,
	Abono decimal(18,4) not null,
	FechaAbono datetime not null,
	Referencia varchar(120) null,
	primary key(IdCuentasHistorialCliente,IdCuentaClientes)
)
go

alter procedure Sp_Listar_CuentasHistorial_By_IdCuenta
@IdCuentaClientes int
as
	select IdCuentasHistorialCliente,FechaAbono,Abono,Referencia from CuentasHistorialClienteTB where IdCuentaClientes = @IdCuentaClientes
go