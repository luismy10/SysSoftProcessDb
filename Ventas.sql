use [PuntoVentaSysSoftDBDesarrollo]
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

/*
	AGREGAR CODIGO DE VENTA
	FECHA VENTA - DATE
	HORA VENTA - TIME
	TOTAL,DESCUENTO,SUBTOTAL A 6 DECIMALES
*/

/*
	
*/

create table VentaTB(
	IdVenta varchar(12) not null,
	Cliente varchar(12) null,
	Vendedor varchar(12) not null,
	Comprobante int not null,
	Moneda int not null,
	Serie varchar(8) not null,
	Numeracion varchar(16) not null,
	FechaVenta date not null,
	SubTotal decimal(18,8) not null,
	--Gravada decimal(18,2) not null,
	Descuento decimal(18,8) not null,
	--Igv decimal(18,2) not null,
	Total decimal(18,8) not null,
	Tipo int not null,
	Estado int null,
	Observaciones varchar(200) null,
	Efectivo decimal(18,4) not null,
	Vuelto decimal(18,4) not null,	
	primary key(IdVenta)
)
go

select * from VentaTB
go


[dbo].[Sp_Listar_Ventas_Detalle_By_Id] 'VT0007'


update VentaTB set HoraVenta = CAST(FechaVenta AS TIME)
GO

update VentaTB set FechaVenta = CAST(FechaVenta AS DATE)
GO

update VentaTB set Codigo = ''

Sp_Listar_Ventas '',
GO

ALTER procedure [dbo].[Sp_Listar_Ventas]
@opcion smallint,
@search varchar(100),
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@Comprobante int,
@Estado int,
@Vendedor varchar(12)
as
	select
		v.IdVenta,
		v.FechaVenta,
		v.HoraVenta,
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
		(v.Vendedor = @Vendedor and @search = '' and CAST(v.FechaVenta as date) = CAST(GETDATE() as date) and @opcion = 1)
		OR (v.Vendedor = @Vendedor and @search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE @search+'%' and @opcion = 1)
		OR (
			(v.Vendedor = @Vendedor and @search <> '' AND CONCAT(c.Apellidos,'',c.Nombres) LIKE @search+'%' and @opcion = 1)
			OR
			(v.Vendedor = @Vendedor and @search <> '' AND CONCAT(c.Nombres,' ',c.Apellidos) LIKE @search+'%' and @opcion = 1)
		)

		OR
		(v.Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0 AND @Estado = 0 and @opcion = 0
		)
		OR
		(v.Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante AND v.Estado = @Estado and @opcion = 0
		)
		OR
		(v.Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante  AND @Estado = 0 and @opcion = 0
		)
		OR
		(v.Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0  AND v.Estado = @Estado and @opcion = 0
		)
	
	order by v.FechaVenta desc ,v.HoraVenta desc
go

alter procedure Sp_Listar_Ventas_Mostrar
@search varchar(100)
as
	select
		v.IdVenta,
		v.FechaVenta,
		v.HoraVenta,
		m.Simbolo,
		v.Total,
		v.Codigo
		from VentaTB as v 
		inner join MonedaTB as m on v.Moneda = m.IdMoneda
		where 
		Codigo like @search+'%' and @search <> '' 		
	   order by v.FechaVenta desc 
go



select  dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,m.Simbolo,v.Total
from VentaTB as v inner join MonedaTB as m on v.Moneda = m.IdMoneda 
where v.IdVenta = ?
go


ALTER procedure [dbo].[Sp_Listar_Ventas_Detalle_By_Id] 
@IdVenta varchar(12)
as
	select /*ROW_NUMBER() over( order by d.IdArticulo desc) as Filas ,*/
	a.IdSuministro,a.Clave,a.NombreMarca,a.Inventario,a.ValorInventario,
	dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra,	
	d.Cantidad,d.CantidadGranel,d.CostoVenta,d.PrecioVenta,
	d.Descuento,d.DescuentoCalculado,d.IdImpuesto,d.NombreImpuesto,d.ValorImpuesto,d.Importe
	from DetalleVentaTB as d inner join SuministroTB as a on d.IdArticulo = a.IdSuministro
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

ALTER function [dbo].[Fc_Venta_Codigo_Alfanumerico] ()  returns varchar(12)
	as
		begin
		declare @Incremental int,@ValorActual varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdVenta from VentaTB)
					begin					
						set @ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdVenta,'VT',''),'','')AS INT)) from VentaTB)
						set @Incremental = CONVERT(INT,@ValorActual) +1
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

select DATEPART(month, FechaVenta) AS FechaVenta,sum(Total) as Total from VentaTB
where FechaVenta between '2019/11/01' and '2019/12/07' and Estado = 1
group by DATEPART(month, FechaVenta)
--order by FechaVenta,Total desc
go

select FechaVenta,sum(Total) as Total from VentaTB 
where FechaVenta between '2019/11/01' and '2019/12/07' and  Estado = 1
group by FechaVenta
order by FechaVenta desc
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
select * from DetalleVentaTB 
go
select * from ComprobanteTB
go
select * from CuentasClienteTB
go
select * from CuentasHistorialClienteTB
go

UPDATE DetalleVentaTB SET IdArticulo =  'SM'+SUBSTRING(IdArticulo,3,LEN(IdArticulo))
go

/*
CAMBIAR TODO A 8 DECIMALES
BORRAR COSTO VENTA GRANEL
BORRAR PRECIO VENTA GRANEL
BORRAR IMPUESTO SUMADO

AGREGAR DescuentoCalculado 
AGREGAR idoperacion
*/

create table DetalleVentaTB(
	IdVenta varchar(12) not null,
	IdArticulo varchar(12) not null,
	Cantidad decimal(18,8) not null,
	CantidadGranel decimal(18,8) not null,
	CostoVenta decimal(18,8) not null,
	--CostoVentaGranel decimal(18,6) not null,
	PrecioVenta decimal(18, 8) not null,
	--PrecioVentaGranel decimal(18,6) not null,
	Descuento decimal(18, 8) null,
	DescuentoCalculado decimal(18,8) not null,
	IdOperacion int null,
	IdImpuesto int null,
	NombreImpuesto varchar(12) null,
	ValorImpuesto decimal(18,2) null,
	ImpuestoSumado decimal(18,8) null,

	Importe decimal(18, 8) not null,
	PRIMARY KEY (IdVenta,IdArticulo)
)
go

update ArticuloTB set Cantidad = Cantidad + ? where IdArticulo = ?
go

Sp_Reporte_General_Ventas '2019/11/24','2019/12/05',0,'',''

alter procedure Sp_Reporte_General_Ventas 
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@TipoDocumento int,
@Cliente varchar(12),
@Empleado varchar(12)
as
	select td.Nombre,v.FechaVenta,concat(c.Apellidos,' ',c.Nombres) as Cliente,v.Serie,v.Numeracion,
	dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
	dbo.Fc_Obtener_Simbolo_Moneda(v.Moneda) as Simbolo,v.Total 
	from VentaTB as v inner join TipoDocumentoTB as td on v.Comprobante = td.IdTipoDocumento
	inner join ClienteTB as c on v.Cliente = c.IdCliente
	inner join EmpleadoTB as e on v.Vendedor = e.IdEmpleado
	where
	(FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND @TipoDocumento = 0 AND @Cliente ='' AND @Empleado = '')
	or
	(
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND td.IdTipoDocumento = @TipoDocumento AND @Cliente ='' AND @Empleado = ''
		or
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND td.IdTipoDocumento = @TipoDocumento AND c.IdCliente = @Cliente AND @Empleado = ''
		or
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND td.IdTipoDocumento = @TipoDocumento AND @Cliente ='' AND e.IdEmpleado = @Empleado
		or
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND td.IdTipoDocumento = @TipoDocumento AND c.IdCliente = @Cliente AND e.IdEmpleado = @Empleado
	)
	or
	(
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND @TipoDocumento = 0 AND c.IdCliente = @Cliente AND @Empleado = ''
		or
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND td.IdTipoDocumento = @TipoDocumento AND c.IdCliente = @Cliente AND @Empleado = ''
		or
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND @TipoDocumento = 0 AND c.IdCliente = @Cliente AND e.IdEmpleado = @Empleado
		or
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND td.IdTipoDocumento = @TipoDocumento AND c.IdCliente = @Cliente AND e.IdEmpleado = @Empleado
	)
	or
	(
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND @TipoDocumento = 0 AND @Cliente ='' AND e.IdEmpleado = @Empleado  
		or
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND td.IdTipoDocumento = @TipoDocumento AND @Cliente ='' AND e.IdEmpleado = @Empleado 
		or
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND @TipoDocumento = 0 AND c.IdCliente = @Cliente AND e.IdEmpleado = @Empleado 
		or
		FechaVenta BETWEEN @FechaInicial AND @FechaFinal AND td.IdTipoDocumento = @TipoDocumento AND c.IdCliente = @Cliente AND e.IdEmpleado = @Empleado 
	)
	order by v.FechaVenta desc,v.HoraVenta desc
go

Sp_Reporte_General_Ventas '2019-11-21','2019-11-21',0

select * from VentaTB
go

ALTER procedure Sp_Obtener_Venta_ById
@idVenta varchar(12)
as
	begin
		select  v.FechaVenta,v.HoraVenta,dbo.Fc_Obtener_Nombre_Detalle(c.TipoDocumento,'0003') as NombreDocumento,c.NumeroDocumento,c.Apellidos,c.Nombres,c.Direccion,
		t.Nombre as Comprobante,t.NombreImpresion,
		v.Serie,v.Numeracion,v.Observaciones,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Abreviado,m.Simbolo,v.Efectivo,v.Vuelto,v.Total,v.Codigo
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