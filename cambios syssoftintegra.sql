USE Actual
GO


DROP PROCEDURE  Sp_Listar_CuentasHistorial_By_IdCuenta
DROP PROCEDURE  Sp_Get_CuentasCliente_By_Id
DROP PROCEDURE  Sp_Get_Articulo_By_Id
DROP FUNCTION   Fc_Detalle_Generar_Codigo
DROP PROCEDURE  Sp_Get_CuentasCliente_By_Id
DROP PROCEDURE Sp_Listar_CuentasHistorial_By_IdCuenta


DROP TABLE CuentasHistorialClienteTB 
DROP TABLE CuentasClienteTB
DROP TABLE PagoProveedoresTB

create table VentaCreditoTB(
IdVenta varchar(12) not null,
IdVentaCredito int identity not null,
Monto decimal(18,4) not null,
FechaRegistro date not null,
HoraRegistro time not null,
FechaPago date not null,
HoraPago time not null,
Estado bit not null
)
go

SELECT * FROM SuministroTB
GO


ALTER procedure [dbo].[Sp_Listar_Kardex_Suministro_By_Id] 
@idArticulo varchar(45),
@fechaInicio varchar(15),
@fechaFinal varchar(15)
as
SELECT k.IdSuministro,k.Fecha,k.Hora,k.Tipo,t.Nombre,
k.Detalle,k.Cantidad
FROM KardexSuministroTB AS k INNER JOIN SuministroTB AS a ON k.IdSuministro = a.IdSuministro
inner join TipoMovimientoTB AS t ON k.Movimiento = t.IdTipoMovimiento
WHERE 
	(a.IdSuministro = @idArticulo and @fechaInicio = '' and @fechaFinal = '')
	or
	(a.IdSuministro = @idArticulo and k.Fecha between @fechaInicio and @fechaFinal)

	order by k.Fecha desc , k.Hora asc
go

ALTER procedure [dbo].[Sp_Suministro_By_Id]
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
		ClaveSat,TipoPrecio
		from SuministroTB
		where IdSuministro=@IdSuministro or Clave = @IdSuministro or ClaveAlterna = @IdSuministro
	end
go

ALTER procedure [dbo].[Sp_Obtener_Venta_ById]
@idVenta varchar(12)
as
	begin
		select  v.FechaVenta,v.HoraVenta,dbo.Fc_Obtener_Nombre_Detalle(c.TipoDocumento,'0003') as NombreDocumento,
		c.NumeroDocumento,c.Informacion,c.Direccion,c.Celular,
		t.Nombre as Comprobante,
		v.Serie,v.Numeracion,v.Observaciones,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Nombre,m.Abreviado,m.Simbolo,v.Efectivo,v.Vuelto,v.Tarjeta,v.Total,v.Codigo
        from VentaTB as v inner join MonedaTB as m on v.Moneda = m.IdMoneda
		inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as t on v.Comprobante = t.IdTipoDocumento
        where v.IdVenta = @idVenta
	end
go
/*
alterar la tabla detalletb 
el campo iddetalle identitya

*/

/*
13/07/2020
*/
drop procedure [dbo].[Sp_Listar_Kardex_Articulo_By_Id] 
go

alter table KardexSuministroTB
add Costo decimal(18,8),Total decimal(18,8)
go

update KardexSuministroTB set KardexSuministroTB.Costo = SuministroTB.PrecioCompra,  
KardexSuministroTB.Total =  SuministroTB.PrecioCompra * KardexSuministroTB.Cantidad
from KardexSuministroTB inner join SuministroTB 
on KardexSuministroTB.IdSuministro = SuministroTB.IdSuministro
go

ALTER procedure [dbo].[Sp_Listar_Kardex_Suministro_By_Id] 
@idArticulo varchar(45),
@fechaInicio varchar(15),
@fechaFinal varchar(15)
as
SELECT k.IdSuministro,k.Fecha,k.Hora,k.Tipo,t.Nombre,
k.Detalle,k.Cantidad,k.Costo,k.Total
FROM KardexSuministroTB AS k INNER JOIN SuministroTB AS a ON k.IdSuministro = a.IdSuministro
inner join TipoMovimientoTB AS t ON k.Movimiento = t.IdTipoMovimiento
WHERE 
	(a.IdSuministro = @idArticulo and @fechaInicio = '' and @fechaFinal = '')
	or
	(a.IdSuministro = @idArticulo and k.Fecha between @fechaInicio and @fechaFinal)

	order by k.Fecha asc , k.Hora asc
go


/*
14/07/2020
*/

ALTER procedure [dbo].[Sp_Listar_Inventario_Suministros]
@Producto varchar(45),
@Existencia tinyint,
@NombreMarca varchar(120),
@opcion tinyint,
@Categoria int,
@Marca int,
@PosicionPagina smallint,
@FilasPorPagina smallint
as
	begin
		select
		IdSuministro,Clave,ClaveAlterna,NombreMarca,PrecioCompra,
		PrecioVentaGeneral,Cantidad,
		dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
		dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
		(PrecioCompra*Cantidad) as Total,
		StockMinimo,StockMaximo,
		dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
		dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca
		from SuministroTB 
		where
		(@Producto = '' and @NombreMarca = '' and @Existencia = 0 and Inventario = 1 and @opcion = 0)
		-------------------------------------------------------------------------------------------------------------
		or (Clave <> '' and Clave = @Producto and Inventario = 1 and @opcion = 1)
		or (ClaveAlterna <> '' and ClaveAlterna = @Producto and Inventario = 1 and @opcion = 1)
		-------------------------------------------------------------------------------------------------------------
		or (NombreMarca like @NombreMarca+'%' and Inventario = 1 and @opcion = 2)
		-------------------------------------------------------------------------------------------------------------
		or ( @Existencia = 1 and Cantidad <= 0 and @opcion = 3)
		or ( @Existencia = 2 and Cantidad > 0 and Cantidad < StockMinimo and @opcion = 3)
		or ( @Existencia = 3 and Cantidad >= StockMinimo  and Cantidad < StockMaximo and @opcion = 3)
		or ( @Existencia = 4 and Cantidad >= StockMaximo and @opcion = 3)
		------------------------------------------------------------------------------------------------------------- 
		or ( Categoria = @Categoria and Inventario = 1 and @opcion = 4)
		-------------------------------------------------------------------------------------------------------------
		or ( Marca = @Marca and Inventario = 1 and @opcion = 5)
		
		order by IdSuministro asc offset @PosicionPagina rows fetch next @FilasPorPagina rows only
	end
go

/*
18/07/2020
*/

create procedure Sp_Listar_Compras_Credito
@Search varchar(100)
as
	select
			c.IdCompra,p.IdProveedor,
			c.FechaCompra,c.HoraCompra,
			p.NumeroDocumento,p.RazonSocial,
			c.EstadoCompra,
			dbo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') Estado,
			dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,
			c.Total
			from CompraTB as c inner join ProveedorTB as p
			on c.Proveedor = p.IdProveedor	
			where
			 (c.TipoCompra = 2 and @Search = '') 
			 or 
			 (c.TipoCompra = 2 and p.NumeroDocumento like @Search+'%' )
			  or 
			 (c.TipoCompra = 2 and p.RazonSocial like @Search+'%' )
	order by c.FechaCompra desc,c.HoraCompra desc
go


/*
18/07/2020
*/

drop procedure [dbo].[Sp_Listar_Suministros]
go

drop procedure [dbo].[Sp_Listar_Suministro_Paginacion]
go

drop procedure Sp_Listar_Suministro_Paginacion_View
go

create procedure [dbo].[Sp_Listar_Suministros]
@Opcion tinyint,
@Clave varchar(45),
@NombreMarca varchar(120),
@Categoria int,
@Marca int,
@PosicionPagina smallint,
@FilasPorPagina smallint
as
	begin	
		select IdSuministro,Clave,ClaveAlterna,NombreMarca,
		NombreGenerico,StockMinimo,StockMaximo,Cantidad,
		dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		PrecioCompra,Impuesto,PrecioVentaGeneral,
		dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
		dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
		Inventario,ValorInventario,Imagen 
		from SuministroTB 
		where
		(@Clave = '' and @NombreMarca = '' and @Categoria = 0 and @Marca = 0 and @Opcion = 0)
		-------------------------------------------------------------------------------------------------------------
		or (Clave <> '' and Clave = @Clave and @opcion = 1)
		or (ClaveAlterna <> '' and ClaveAlterna = @Clave and @opcion = 1)
		-------------------------------------------------------------------------------------------------------------
		or (NombreMarca like @NombreMarca+'%' and @opcion = 2)
		-------------------------------------------------------------------------------------------------------------
		or ( Categoria = @Categoria and Inventario = 1 and @opcion = 3)
		-------------------------------------------------------------------------------------------------------------
		or ( Marca = @Marca and Inventario = 1 and @opcion = 4)
		order by IdSuministro asc offset @PosicionPagina rows fetch next @FilasPorPagina rows only
	end
go

ALTER procedure [dbo].[Sp_Listar_Suministros_Count]
@Opcion tinyint,
@Clave varchar(45),
@NombreMarca varchar(120),
@Categoria int,
@Marca int
as
	begin	
		select count(*) as Total from SuministroTB 
		where
		(@Clave = '' and @NombreMarca = '' and @Categoria = 0 and @Marca = 0 and @Opcion = 0)
		-------------------------------------------------------------------------------------------------------------
		or (Clave <> '' and Clave = @Clave and @opcion = 1)
		or (ClaveAlterna <> '' and ClaveAlterna = @Clave and @opcion = 1)
		-------------------------------------------------------------------------------------------------------------
		or (NombreMarca like @NombreMarca+'%' and @opcion = 2)
		-------------------------------------------------------------------------------------------------------------
		or ( Categoria = @Categoria and Inventario = 1 and @opcion = 3)
		-------------------------------------------------------------------------------------------------------------
		or ( Marca = @Marca and Inventario = 1 and @opcion = 4)
	end
go


ALTER procedure Sp_Listar_Suministros_Lista_View 
@opcion smallint,
@search varchar(100),
@PosicionPagina smallint,
@FilasPorPagina smallint
as
	begin
		select IdSuministro,Clave,NombreMarca,dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		Cantidad,PrecioCompra,
		PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
		UnidadVenta,Inventario,Impuesto,Lote,ValorInventario,Imagen
		from SuministroTB 
		where 
		(@opcion = 0 and Estado = 1) 
		or 
		(@opcion = 1 and Clave = @search and Estado = 1)
		or
		(@opcion = 1 and ClaveAlterna = @search and Estado = 1)
		or
		(@opcion = 1 and NombreMarca like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 2 and dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 3 and dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 4 and dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 5 and dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') like @search +'%' and Estado = 1)

		order by IdSuministro asc offset @PosicionPagina rows fetch next @FilasPorPagina rows only
	end
go

ALTER procedure Sp_Listar_Suministros_Lista_View_Count
@opcion smallint,
@search varchar(100)
as
	begin
		select count(*) as Total 
		from SuministroTB 
		where 
		(@opcion = 0 and Estado = 1) 
		or 
		(@opcion = 1 and Clave = @search and Estado = 1)
		or
		(@opcion = 1 and ClaveAlterna = @search and Estado = 1)
		or
		(@opcion = 1 and NombreMarca like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 2 and dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 3 and dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 4 and dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 5 and dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') like @search +'%' and Estado = 1)

	end
go

https://www.youtube.com/watch?v=UZYI13Y7v_4
https://www.youtube.com/watch?v=A78iNBzT8ug

/*
20/07/2020
*/

ALTER procedure Sp_Get_Suministro_For_Movimiento
@IdSuministro varchar(12)
as
	begin
		select IdSuministro,Clave,NombreMarca,StockMinimo,Cantidad,
		dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		PrecioCompra,Impuesto,PrecioVentaGeneral,
		Inventario,ValorInventario 
		from SuministroTB
		where IdSuministro = @IdSuministro
	end
go

/*
22/07/2020
*/

select * from CompraTB
go

select sum(Total) as 'ventasContado' from VentaTB where Tipo = 1 and FechaCompra between ? and ?

SELECT * FROM SuministroTB where Clave = '720342563393'

 Sp_Listar_Kardex_Suministro_By_Id 0,'SM1089','',''
 go

ALTER procedure [dbo].[Sp_Listar_Kardex_Suministro_By_Id] 
@opcion tinyint,
@idArticulo varchar(45),
@fechaInicio varchar(15),
@fechaFinal varchar(15),
@PosicionPagina smallint,
@FilasPorPagina smallint
as
SELECT k.IdSuministro,k.Fecha,k.Hora,k.Tipo,t.Nombre,
k.Detalle,k.Cantidad,k.Costo,k.Total
FROM KardexSuministroTB AS k INNER JOIN SuministroTB AS a ON k.IdSuministro = a.IdSuministro
inner join TipoMovimientoTB AS t ON k.Movimiento = t.IdTipoMovimiento
WHERE 
	(a.IdSuministro = @idArticulo and @fechaInicio = '' and @fechaFinal = '' and @opcion = 0)
	or
	(a.IdSuministro = @idArticulo and k.Fecha between @fechaInicio and @fechaFinal and @opcion = 1)

	--order by k.Fecha asc , k.Hora asc
	order  by k.Fecha asc , k.Hora asc offset @PosicionPagina rows fetch next @FilasPorPagina rows only
go



/*
24/07/2020
*/

ALTER procedure [dbo].[Sp_Obtener_Cliente_Informacion_NumeroDocumento]
@opcion tinyint,
@search varchar(100)
as
	begin
		select IdCliente,TipoDocumento,NumeroDocumento,Informacion,Direccion,Celular from ClienteTB 
		where 
		@search = '' and @opcion = 1
		or
		NumeroDocumento = @search and @opcion = 2
		or 
		@search <> ''and Informacion like @search+'%' and @opcion = 3
	end
go

[dbo].[Sp_Obtener_Cliente_Informacion_NumeroDocumento] 3,''
GO

/*
30/07/2020
*/

CREATE procedure Sp_Obtener_Proveedor_For_ComboBox
@search varchar(100)
as
	SELECT IdProveedor,NumeroDocumento,RazonSocial FROM ProveedorTB
	WHERE (@search <> '' and NumeroDocumento LIKE @search+'%') OR (@search<>'' and RazonSocial LIKE @search+'%')
go


/*
31/07/2020
*/


select sum(Total) as 'ventasContado' from VentaTB where Tipo = 1 and FechaVenta between '2020-07-03' and '2020-07-03'
go

select * from VentaTB
go

select Total as 'ventasCredito' from VentaTB where FechaVenta = '2020-07-03'
go

select sum(Total) as 'comprasAnuladas' from CompraTB where EstadoCompra = 2
go

select * from VentaTB
go

/*
30/07/2020
*/

Sp_Listar_Kardex_Suministro_By_Id 0

ALTER procedure [dbo].[Sp_Listar_Kardex_Suministro_By_Id] 
@opcion tinyint,
@idArticulo varchar(45),
@fechaInicio varchar(15),
@fechaFinal varchar(15)
--@PosicionPagina smallint,
--@FilasPorPagina smallint
as
SELECT k.IdSuministro,k.Fecha,k.Hora,k.Tipo,t.Nombre,
k.Detalle,k.Cantidad,k.Costo,k.Total
FROM KardexSuministroTB AS k INNER JOIN SuministroTB AS a ON k.IdSuministro = a.IdSuministro
inner join TipoMovimientoTB AS t ON k.Movimiento = t.IdTipoMovimiento
WHERE 
	(a.IdSuministro = @idArticulo and @fechaInicio = '' and @fechaFinal = '' and @opcion = 0)
	or
	(a.IdSuministro = @idArticulo and k.Fecha between @fechaInicio and @fechaFinal and @opcion = 1)

	order by k.Fecha asc , k.Hora asc
	--order  by k.Fecha asc , k.Hora asc offset @PosicionPagina rows fetch next @FilasPorPagina rows only
go

alter procedure [dbo].[Sp_Listar_Kardex_Suministro_By_Id_Count] 
@opcion tinyint,
@idArticulo varchar(45),
@fechaInicio varchar(15),
@fechaFinal varchar(15)
as
SELECT count(*) as Total FROM KardexSuministroTB AS k INNER JOIN SuministroTB AS a ON k.IdSuministro = a.IdSuministro
inner join TipoMovimientoTB AS t ON k.Movimiento = t.IdTipoMovimiento
WHERE 
	(a.IdSuministro = @idArticulo and @fechaInicio = '' and @fechaFinal = '' and @opcion = 0)
	or
	(a.IdSuministro = @idArticulo and k.Fecha between @fechaInicio and @fechaFinal and @opcion = 1)
go


SELECT * FROM SuministroTB WHERE IdSuministro = 'SM0001'
GO

SELECT * FROM SuministroTB WHERE Clave = '720342563393'
go
select * from KardexSuministroTB where IdSuministro = 'SM1089'
go

select * from VentaTB
go


select * from CompraTB
go
/*
01/08/2020
*/
alter procedure Sp_Obtener_Proveedor_For_ComboBox
@search varchar(100)
as
	SELECT IdProveedor,NumeroDocumento,RazonSocial FROM ProveedorTB
	WHERE (NumeroDocumento LIKE @search+'%') OR (@search<>'' and RazonSocial LIKE @search+'%')
go

select * from KardexSuministroTB
go

delete KardexSuministroTB 
go

print CONVERT (time, GETDATE())
go

insert into KardexSuministroTB (IdSuministro,Fecha,Hora,Tipo,Movimiento,Detalle,Cantidad,Costo,Total)
select IdSuministro,CONVERT (date, GETDATE()),CONVERT (time, GETDATE()),1,2,'MONTO INICIAL',Cantidad,PrecioCompra,Cantidad*PrecioCompra from SuministroTB 
go

select * from TipoTicketTB
go

delete TicketTB where idTicket = 1 and predeterminado
go


/*
05/08/2020
*/


ALTER procedure [dbo].[Sp_Obtener_Cliente_Informacion_NumeroDocumento]
@opcion tinyint,
@search varchar(100)
as
	begin
		select IdCliente,TipoDocumento,NumeroDocumento,Informacion,Direccion,Celular from ClienteTB 
		where 
		@search = '' and @opcion = 1
		or
		NumeroDocumento = @search and @opcion = 2
		or 
		@search <> ''and Informacion like @search+'%' and @opcion = 3
		or
		@search <> ''and NumeroDocumento like @search+'%' and @opcion = 4
		or
		@search <> ''and Informacion like @search+'%' and @opcion = 4
	end
go


/*
06/08/2020
*/
ALTER procedure Sp_Listar_Suministros_Lista_View 
@opcion smallint,
@search varchar(100),
@PosicionPagina smallint,
@FilasPorPagina smallint
as
	begin
		select IdSuministro,Clave,NombreMarca,dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		Cantidad,PrecioCompra,
		PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
		UnidadVenta,Inventario,Impuesto,Lote,ValorInventario,Imagen
		from SuministroTB 
		where 
		(@opcion = 0 and Estado = 1) 
		or 
		(@search<> '' and @opcion = 1 and Clave = @search and Estado = 1)
		or
		(@search<> '' and @opcion = 1 and ClaveAlterna = @search and Estado = 1)
		or
		(@search<> '' and @opcion = 1 and NombreMarca like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 2 and dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 3 and dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 4 and dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 5 and dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') like @search +'%' and Estado = 1)

		order by IdSuministro asc offset @PosicionPagina rows fetch next @FilasPorPagina rows only
	end
go

ALTER procedure Sp_Listar_Suministros_Lista_View_Count
@opcion smallint,
@search varchar(100)
as
	begin
		select count(*) as Total 
		from SuministroTB 
		where 
		(@opcion = 0 and Estado = 1) 
		or 
		(@search<> '' and @opcion = 1 and Clave = @search and Estado = 1)
		or
		(@search<> '' and @opcion = 1 and ClaveAlterna = @search and Estado = 1)
		or
		(@search<> '' and @opcion = 1 and NombreMarca like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 2 and dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 3 and dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 4 and dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') like @search +'%' and Estado = 1)
		-----------------------------------------------------------------------------------------------------------
		or
		(@opcion = 5 and dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') like @search +'%' and Estado = 1)

	end
go

[Sp_Listar_Ventas] 2,'','','',0,0,'',0,20
go

ALTER procedure [dbo].[Sp_Listar_Ventas]
@opcion smallint,
@search varchar(100),
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@Comprobante int,
@Estado int,
@Vendedor varchar(12),
@PosicionPagina smallint,
@FilasPorPagina smallint
as
	select
		v.IdVenta,
		v.FechaVenta,
		v.HoraVenta,
		c.Informacion as Cliente,
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
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE @search+'%' and @opcion = 1)
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND c.Informacion LIKE @search+'%' and @opcion = 1)
		
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0 AND @Estado = 0 and @opcion = 0)
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante AND v.Estado = @Estado and @opcion = 0)
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante  AND @Estado = 0 and @opcion = 0)
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0  AND v.Estado = @Estado and @opcion = 0)
		--OR
		--(@search = '' and @opcion = 2)
	--order by v.FechaVenta desc, v.HoraVenta desc descoffset @PosicionPagina rows fetch next @FilasPorPagina rows only
	order by v.FechaVenta desc,v.HoraVenta desc offset @PosicionPagina rows fetch next @FilasPorPagina rows only
go

alter procedure Sp_Listar_Ventas_Count
@opcion smallint,
@search varchar(100),
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@Comprobante int, 
@Estado int,
@Vendedor varchar(12)
as
	select COUNT(*) as Total from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as td on v.Comprobante = IdTipoDocumento
		inner join MonedaTB as m on v.Moneda = m.IdMoneda
		where 
		(v.Vendedor = @Vendedor and @search = '' and CAST(v.FechaVenta as date) = CAST(GETDATE() as date) and @opcion = 1)
		OR (v.Vendedor = @Vendedor and @search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE @search+'%' and @opcion = 1)
		OR (v.Vendedor = @Vendedor and @search <> '' AND c.Informacion LIKE @search+'%' and @opcion = 1)
		
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
go

ALTER procedure [dbo].[Sp_Obtener_Venta_ById]
@idVenta varchar(12)
as
	begin
		select  v.FechaVenta,v.HoraVenta,
		dbo.Fc_Obtener_Nombre_Detalle(c.TipoDocumento,'0003') as NombreDocumento,
		c.NumeroDocumento,c.Informacion,c.Direccion,c.Email,c.Celular,
		t.Nombre as Comprobante,
		v.Serie,v.Numeracion,v.Observaciones,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Nombre,m.Abreviado,m.Simbolo,v.Efectivo,v.Vuelto,v.Tarjeta,v.Total,v.Codigo
        from VentaTB as v inner join MonedaTB as m on v.Moneda = m.IdMoneda
		inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as t on v.Comprobante = t.IdTipoDocumento
        where v.IdVenta = @idVenta
	end
GO

alter procedure Sp_Listar_Compras_Credito
@Search varchar(100),
@FechaInicio varchar(20),
@FechaFinal varchar(20),
@Opcion tinyint
as
	select
			c.IdCompra,p.IdProveedor,
			c.FechaCompra,c.HoraCompra,
			c.Serie,c.Numeracion,
			p.NumeroDocumento,p.RazonSocial,
			c.EstadoCompra,
			dbo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') Estado,
			dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,
			c.Total
			from CompraTB as c inner join ProveedorTB as p on c.Proveedor = p.IdProveedor	
			where
			 (@Opcion = 0 and c.TipoCompra = 2 and @Search = '') 
			 or 
			 (@Opcion = 0 and c.TipoCompra = 2 and p.NumeroDocumento like @Search+'%' )
			 or 
			 (@Opcion = 0 and c.TipoCompra = 2 and p.RazonSocial like @Search+'%' )
			 or 
			 (@Opcion = 0 and c.TipoCompra = 2 and c.Serie like @Search+'%' )
			 or 
			 (@Opcion = 0 and c.TipoCompra = 2 and c.Numeracion like @Search+'%' )
			  or 
			 (@Opcion = 0 and c.TipoCompra = 2 and CONCAT(c.Serie,'-',c.Numeracion) like @Search+'%' )
			 or 
			 (@Opcion = 1 and c.TipoCompra = 2 and c.FechaCompra between @FechaInicio and @FechaFinal )
	order by c.FechaCompra desc,c.HoraCompra desc
go


select * from ClienteTB
go

truncate table [dbo].[VentaTB]
truncate table [dbo].[VentaCreditoTB]
truncate table [dbo].[TipoDocumentoTB]
truncate table [dbo].[MovimientoInventarioTB]
truncate table [dbo].[MovimientoInventarioDetalleTB]
truncate table [dbo].[MonedaTB]
truncate table [dbo].[MovimientoCajaTB]
truncate table [dbo].[ImpuestoTB]
truncate table [dbo].[DetalleVentaTB]
truncate table [dbo].[EmpresaTB]
truncate table [dbo].[DetalleCompraTB]
truncate table [dbo].[ComprobanteTB]
truncate table [dbo].[CompraTB]
truncate table [dbo].[CompraCreditoTB]
truncate table [dbo].[CajaTB]
truncate table [dbo].[BancoHistorialTB]
truncate table [dbo].[Banco]
truncate table [dbo].[AsignacionTB]
truncate table [dbo].[AsignacionDetalleTB]
go




