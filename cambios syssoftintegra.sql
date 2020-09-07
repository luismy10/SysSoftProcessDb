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

select * from VentaTB
go

[Sp_Listar_Ventas] 2,'T001-00000097','14-08-2020','15-08-2020',0,0,'EM0001',0,20
go

ALTER procedure Sp_Listar_Ventas
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
		dbo.Fc_Obtener_Apellidos_Empleado(v.Vendedor) as ApellidosVendedor,
		dbo.Fc_Obtener_Nombres_Empleado(v.Vendedor) as NombresVendedor,
		dbo.Fc_Obtener_NumeroDocumento_Cliente(v.Cliente) as DocumentoCliente,
		dbo.Fc_Obtener_Datos_Cliente(v.Cliente) as Cliente,
		td.Nombre as Comprobante,
		td.CodigoAlterno as ComprobanteCodigoAlterno,
		v.Serie,v.Numeracion,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		dbo.Fc_Obtener_Simbolo_Moneda(v.Moneda) as Simbolo,
		dbo.Fc_Obtener_Nombre_Moneda(v.Moneda) as NombreMoneda,
		dbo.Fc_Obtener_Abreviatura_Moneda(v.Moneda) as AbreviaturaMoneda,
		v.Total,
		v.Observaciones
		from VentaTB as v
		inner join TipoDocumentoTB as td on v.Comprobante = IdTipoDocumento
		where 
		(v.Vendedor = @Vendedor and @search = '' and CAST(v.FechaVenta as date) = CAST(GETDATE() as date) and @opcion = 1)
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE @search+'%' and @opcion = 1)
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND v.Serie LIKE @search+'%' and @opcion = 1)
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND v.Numeracion LIKE @search+'%' and @opcion = 1)
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND dbo.Fc_Obtener_Datos_Cliente(v.Cliente) LIKE @search+'%' and @opcion = 1)
		
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0 AND @Estado = 0 and @opcion = 0)
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante AND v.Estado = @Estado and @opcion = 0)
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante  AND @Estado = 0 and @opcion = 0)
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0  AND v.Estado = @Estado and @opcion = 0)
		
		OR 
		(@search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE @search+'%' and @opcion = 2)
		OR 
		(@search <> '' AND v.Serie LIKE @search+'%' and @opcion = 2)
		OR 
		(@search <> '' AND v.Numeracion LIKE @search+'%' and @opcion = 2)
		OR 
		(@search <> '' AND dbo.Fc_Obtener_NumeroDocumento_Cliente(v.Cliente) LIKE @search+'%' and @opcion = 2)
		OR 
		(@search <> '' AND dbo.Fc_Obtener_Datos_Cliente(v.Cliente) LIKE @search+'%' and @opcion = 2)

		OR
		(CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0 AND @Estado = 0 and @opcion = 3)
		OR
		(CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante AND v.Estado = @Estado and @opcion = 3)
		OR
		(CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante  AND @Estado = 0 and @opcion = 3)
		OR
		(CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0  AND v.Estado = @Estado and @opcion = 3)
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
	select COUNT(*) as Total 
		from VentaTB as v
		inner join TipoDocumentoTB as td on v.Comprobante = IdTipoDocumento
		where 
		(v.Vendedor = @Vendedor and @search = '' and CAST(v.FechaVenta as date) = CAST(GETDATE() as date) and @opcion = 1)
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE @search+'%' and @opcion = 1)
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND v.Serie LIKE @search+'%' and @opcion = 1)
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND v.Numeracion LIKE @search+'%' and @opcion = 1)
		OR 
		(v.Vendedor = @Vendedor and @search <> '' AND dbo.Fc_Obtener_Datos_Cliente(v.Cliente) LIKE @search+'%' and @opcion = 1)	
			
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0 AND @Estado = 0 and @opcion = 0)
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante AND v.Estado = @Estado and @opcion = 0)
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante  AND @Estado = 0 and @opcion = 0)
		OR
		(v.Vendedor = @Vendedor and CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0  AND v.Estado = @Estado and @opcion = 0)

		OR 
		(@search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE @search+'%' and @opcion = 2)
		OR 
		(@search <> '' AND v.Serie LIKE @search+'%' and @opcion = 2)
		OR 
		(@search <> '' AND v.Numeracion LIKE @search+'%' and @opcion = 2)
		OR 
		(@search <> '' AND dbo.Fc_Obtener_NumeroDocumento_Cliente(v.Cliente) LIKE @search+'%' and @opcion = 2)
		OR 
		(@search <> '' AND dbo.Fc_Obtener_Datos_Cliente(v.Cliente) LIKE @search+'%' and @opcion = 2)

		OR
		( CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0 AND @Estado = 0 and @opcion = 3)
		OR
		(CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante AND v.Estado = @Estado and @opcion = 3)
		OR
		(CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante  AND @Estado = 0 and @opcion = 3)
		OR
		(CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0  AND v.Estado = @Estado and @opcion = 3)
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
		m.Nombre,m.Abreviado,m.Simbolo,v.Efectivo,v.Vuelto,v.Tarjeta,v.SubTotal,v.Descuento,v.Impuesto,v.Total,v.Codigo
        from VentaTB as v inner join MonedaTB as m on v.Moneda = m.IdMoneda
		inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as t on v.Comprobante = t.IdTipoDocumento
        where v.IdVenta = @idVenta
	end
GO

select  * from VentaTB
go

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


alter function [dbo].[Fc_Obtener_Datos_Cliente]
(
@idCliente varchar(12)
) returns varchar(100)

as
	begin
		declare @datos varchar(100)
		set @datos=	(select Informacion from ClienteTB where IdCliente = @idCliente)
		return @datos
	end
go

create function [dbo].[Fc_Obtener_NumeroDocumento_Cliente]
(
@idCliente varchar(12)
) returns varchar(100)

as
	begin
		declare @datos varchar(20)
		set @datos=	(select NumeroDocumento from ClienteTB where IdCliente = @idCliente)
		return @datos
	end
go

ALTER function [dbo].[Fc_Obtener_Datos_Empleado]
(
@idProveedor varchar(12)
) returns varchar(100)

as
	begin
		declare @datos varchar(100)
		set @datos=	(select Nombres+' '+Apellidos from EmpleadoTB where IdEmpleado = @idProveedor)
		return @datos
	end
go

alter procedure Sp_Obtener_Proveedor_For_ComboBox
@search varchar(100)
as
	SELECT IdProveedor,NumeroDocumento,RazonSocial FROM ProveedorTB
	WHERE (NumeroDocumento LIKE @search+'%') OR (RazonSocial LIKE @search+'%')
go

/*19-08-2020*/

alter function [dbo].[Fc_Obtener_Apellidos_Empleado]
(
@idProveedor varchar(12)
) returns varchar(100)

as
	begin
		declare @datos varchar(100)
		set @datos=	(select Apellidos from EmpleadoTB where IdEmpleado = @idProveedor)
		return @datos
	end
go

alter function [dbo].[Fc_Obtener_Nombres_Empleado]
(
@idProveedor varchar(12)
) returns varchar(100)

as
	begin
		declare @datos varchar(100)
		set @datos=	(select Nombres from EmpleadoTB where IdEmpleado = @idProveedor)
		return @datos
	end
go

update SubmenuTB set Nombre = 'CORTES REALIZADOS' where IdSubmenu = 10
go
update SubmenuTB set Nombre = 'CUENTAS POR PAGAR' where IdSubmenu = 11
go
 INSERT INTO SubmenuTB(Nombre,IdMenu) VALUES('CUENTAS POR PAGAR',3)
 GO
  INSERT INTO SubmenuTB(Nombre,IdMenu) VALUES('BANCOS',3)
 GO
 INSERT INTO PermisoSubMenusTB(IdRol,IdMenus,IdSubMenus,Estado) VALUES(1,3,32,1)
 GO
 INSERT INTO PermisoSubMenusTB(IdRol,IdMenus,IdSubMenus,Estado) VALUES(1,3,33,1)
 GO
 INSERT INTO PermisoSubMenusTB(IdRol,IdMenus,IdSubMenus,Estado) VALUES(2,3,32,0)
 GO
 INSERT INTO PermisoSubMenusTB(IdRol,IdMenus,IdSubMenus,Estado) VALUES(2,3,33,0)
 GO

 
CREATE function [dbo].[Fc_Obtener_Nombre_Moneda]
	(
	 @IdMoneda int
	)
	RETURNS VARCHAR(10)
	AS
	BEGIN
		DECLARE @Result VARCHAR(10)
			BEGIN
				SET @Result = (SELECT Nombre FROM MonedaTB WHERE IdMoneda = @IdMoneda)	
			END
			RETURN @Result
	END
GO

CREATE function [dbo].[Fc_Obtener_Abreviatura_Moneda]
	(
	 @IdMoneda int
	)
	RETURNS VARCHAR(10)
	AS
	BEGIN
		DECLARE @Result VARCHAR(10)
			BEGIN
				SET @Result = (SELECT Abreviado FROM MonedaTB WHERE IdMoneda = @IdMoneda)	
			END
			RETURN @Result
	END
GO

 SELECT * FROM ImpuestoTB
 go

 alter table ImpuestoTB
 add Codigo varchar(20),Numeracion varchar(20),NombreImpuesto varchar(20),Letra varchar(20),Categoria varchar(20)
 go

 update ImpuestoTB set Codigo = '',Numeracion = '',NombreImpuesto = '',Letra = '',Categoria = ''
 go

 select * from TipoDocumentoTB
 go

 select * from MonedaTB
 go

 alter table TipoDocumentoTB
add CodigoAlterno varchar(10)
go

update TipoDocumentoTB set CodigoAlterno = ''
go

update TipoDocumentoTB set Sistema = 0
go


select * from VentaTB where IdVenta = 'VT0106'
go

[dbo].[Sp_Listar_Ventas_Detalle_By_Id] 'VT0106'
go

ALTER procedure [dbo].[Sp_Listar_Ventas_Detalle_By_Id] 
@IdVenta varchar(12)
as
	select /*ROW_NUMBER() over( order by d.IdArticulo desc) as Filas ,*/
	a.IdSuministro,a.Clave,a.NombreMarca,a.Inventario,a.ValorInventario,a.ClaveSat,
	dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra,	
	d.Cantidad,d.CantidadGranel,d.CostoVenta,d.PrecioVenta,
	d.Descuento,d.DescuentoCalculado,d.IdImpuesto,d.NombreImpuesto,d.ValorImpuesto,
	i.Codigo,i.Numeracion,i.NombreImpuesto,
	d.Importe
	from DetalleVentaTB as d inner join SuministroTB as a on d.IdArticulo = a.IdSuministro
	inner join  ImpuestoTB as i on d.IdImpuesto = i.IdImpuesto
	where d.IdVenta = @IdVenta
go

select * from EmpleadoTB
go

alter procedure [dbo].[Sp_Listar_Compra_Credito_Abonar_Por_IdCompra]
@IdCompra varchar(12)
as
	begin
		select IdCompraCredito,Monto,FechaRegistro,fechaPago,HoraPago,Estado,IdTransaccion
		from CompraCreditoTB 
		where IdCompra = @IdCompra
	end
go

alter procedure Sp_Listar_Compra_Credito_Abonar_Por_IdTransaccion
@IdTransaccion varchar(12)
as
	begin
		select IdCompraCredito,Monto,FechaRegistro,fechaPago,HoraPago,Estado 
		from CompraCreditoTB 
		where @IdTransaccion <> '' AND IdTransaccion = @IdTransaccion
	end
go

create procedure [dbo].[Sp_Obtener_Proveedor_By_IdProveedor]
@IdProveedor varchar(12)
as
	begin
		select dbo.Fc_Obtener_Nombre_Detalle(p.TipoDocumento,'0003') as NombreDocumento,
		p.NumeroDocumento,p.RazonSocial,p.Telefono,p.Celular,p.Direccion,p.Email 
        from  ProveedorTB as p
		where p.IdProveedor = @IdProveedor
	end
go

ALTER procedure [dbo].[Sp_Obtener_Proveedor_ByIdCompra]
@IdCompra varchar(12)
as
	begin
		select c.Serie,c.Numeracion,c.EstadoCompra,
		dbo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') EstadoName,
		c.Total,
		p.IdProveedor,
		dbo.Fc_Obtener_Nombre_Detalle(p.TipoDocumento,'0003') as NombreDocumento,
		p.NumeroDocumento,p.RazonSocial as Proveedor,
		p.Telefono,p.Celular,p.Direccion,p.Email	
        from CompraTB as c inner join ProveedorTB as p
        on c.Proveedor = p.IdProveedor
        where c.IdCompra = @IdCompra
	end
go

select * from TransaccionTB
go

select * from CompraTB
go

select * from CompraCreditoTB where IdCompra = 'CP0098'
go

print dbo.Fc_Cambiar_Estado_Compra('CP0074')
go

alter function Fc_Cambiar_Estado_Compra(@IdCompra varchar(12))  returns varchar(10)
as
	begin
		declare @TotalCompra smallint,@NumeroTotalCompra smallint,@Estado varchar(10)
		set @TotalCompra = (select count(*) from CompraCreditoTB where IdCompra = @IdCompra)
		set @NumeroTotalCompra = (select count(*) from CompraCreditoTB where IdCompra = @IdCompra and Estado = 1)
		if(@TotalCompra = @NumeroTotalCompra)
			begin
				set @Estado = 'completado'
			end
		else
			begin
				set @Estado = 'falta'
			end		
		return @Estado
	end
go

SELECT IdCompra FROM  CompraCreditoTB WHERE IdTransaccion = ''
GO

ALTER TABLE CompraCreditoTB
ALTER COLUMN Monto decimal(18,8)
go

ALTER TABLE CompraCreditoTB
ADD IdTransaccion varchar(12) 
go

update CompraCreditoTB set IdTransaccion = ''
go


/*
1=inreso
2=salida
*/

create table TransaccionTB(
IdTransaccion varchar(12) not null primary key,
Fecha date not null,
Hora time not null,
Descripcion varchar(200),
TipoTransaccion smallint,
Monto decimal(18,8),
Usuario varchar(12)
)
go

select * from ImpuestoTB
go

ALTER procedure [dbo].[Sp_Listar_Impuestos]
as
begin
select IdImpuesto,dbo.Fc_Obtener_Nombre_Detalle(Operacion,'0010') as Operacion,
Nombre,Valor,Predeterminado,Codigo,Sistema 
from [dbo].[ImpuestoTB]
end
go


truncate table[dbo].[AsignacionDetalleTB]
truncate table[dbo].[AsignacionTB]
truncate table[dbo].[Banco]
truncate table[dbo].[BancoHistorialTB]
truncate table[dbo].[CajaTB]
truncate table[dbo].[ClienteTB]
truncate table[dbo].[CompraCreditoTB]
truncate table[dbo].[CompraTB]
truncate table[dbo].[ComprobanteTB]
truncate table[dbo].[DetalleCompraTB]
truncate table[dbo].[DetalleVentaTB]
truncate table[dbo].[DirectorioTB]
truncate table[dbo].[EmpleadoTB]
truncate table[dbo].[EmpresaTB]
truncate table[dbo].[EtiquetaTB]
truncate table[dbo].[ImagenTB]
truncate table[dbo].[ImpuestoTB]
truncate table[dbo].[KardexSuministroTB]
truncate table[dbo].[LoteTB]
truncate table[dbo].[MonedaTB]
truncate table[dbo].[MovimientoCajaTB]
truncate table[dbo].[MovimientoInventarioDetalleTB]
truncate table[dbo].[MovimientoInventarioTB]
truncate table[dbo].[PlazosTB]
truncate table[dbo].[ProveedorTB]
truncate table[dbo].[TicketTB]
truncate table[dbo].[TipoDocumentoTB]
truncate table[dbo].[VentaCreditoTB]
truncate table[dbo].[VentaTB]
update SuministroTB set Cantidad = 0
go

ALTER procedure [dbo].[Sp_Listar_Ventas_Detalle_By_Id] 
@IdVenta varchar(12)
as
	select /*ROW_NUMBER() over( order by d.IdArticulo desc) as Filas ,*/
	a.IdSuministro,a.Clave,a.NombreMarca,a.Inventario,a.ValorInventario,a.ClaveSat,
	dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra,	
	d.Cantidad,d.CantidadGranel,d.CostoVenta,d.PrecioVenta,
	d.Descuento,d.DescuentoCalculado,d.IdImpuesto,d.NombreImpuesto,d.ValorImpuesto,
	i.Codigo,i.Numeracion,i.NombreImpuesto,i.Letra,i.Categoria,
	d.Importe
	from DetalleVentaTB as d inner join SuministroTB as a on d.IdArticulo = a.IdSuministro
	inner join  ImpuestoTB as i on d.IdImpuesto = i.IdImpuesto
	where d.IdVenta = @IdVenta
go
ALTER procedure [dbo].[Sp_Listar_Ventas_Detalle_By_Id] 
@IdVenta varchar(12)
as
	select /*ROW_NUMBER() over( order by d.IdArticulo desc) as Filas ,*/
	a.IdSuministro,a.Clave,a.NombreMarca,a.Inventario,a.ValorInventario,a.ClaveSat,
	dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra,	
	d.Cantidad,d.CantidadGranel,d.CostoVenta,d.PrecioVenta,
	d.Descuento,d.DescuentoCalculado,d.IdImpuesto,d.NombreImpuesto,d.ValorImpuesto,
	i.Codigo,i.Numeracion,i.NombreImpuesto,i.Letra,i.Categoria,
	d.Importe
	from DetalleVentaTB as d inner join SuministroTB as a on d.IdArticulo = a.IdSuministro
	inner join  ImpuestoTB as i on d.IdImpuesto = i.IdImpuesto
	where d.IdVenta = @IdVenta
go

create procedure Sp_Obtener_Caja_Aperturada_By_Id
@IdCaja varchar(12)
as
	begin
		select a.IdCaja,a.FechaApertura,a.HoraApertura,a.FechaCierre,
		a.HoraCierre,a.Contado,a.Calculado,
		a.Diferencia,e.Apellidos,e.Nombres 
		from CajaTB as a inner join EmpleadoTB as e
		on a.IdUsuario = e.IdEmpleado
		where 
		a.IdCaja = @IdCaja	
	end
go


print [dbo].[Fc_Transaccion_Codigo_Alfanumerico]() 
go

ALTER function Fc_Transaccion_Codigo_Alfanumerico ()  returns varchar(12)
	as
		begin
		declare @Incremental int,@ValorActual varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdTransaccion from TransaccionTB)
					begin					
						set @ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdTransaccion,'TA-',''),'','')AS INT)) from TransaccionTB)
						set @Incremental = CONVERT(INT,@ValorActual) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'TA-000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'TA-00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'TA-0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'TA-'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'TA-0001'
					end
			end
			return @CodGenerado
		end
go

drop function [dbo].[Fc_Articulo_Codigo_Alfanumerico]
go


/*
buscar cambios
*/

ALTER procedure [dbo].[Sp_Listar_Ventas_Detalle_By_Id] 
@IdVenta varchar(12)
as
	select /*ROW_NUMBER() over( order by d.IdArticulo desc) as Filas ,*/
	a.IdSuministro,a.Clave,a.NombreMarca,a.Inventario,a.ValorInventario,a.ClaveSat,
	dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra,	
	d.Cantidad,d.CantidadGranel,d.CostoVenta,d.PrecioVenta,
	d.Descuento,d.DescuentoCalculado,d.IdImpuesto,d.NombreImpuesto,d.ValorImpuesto,
	i.Codigo,i.Numeracion,i.NombreImpuesto,i.Letra,i.Categoria,
	d.Importe
	from DetalleVentaTB as d inner join SuministroTB as a on d.IdArticulo = a.IdSuministro
	inner join  ImpuestoTB as i on d.IdImpuesto = i.IdImpuesto
	where d.IdVenta = @IdVenta
go

create procedure Sp_Obtener_Caja_Aperturada_By_Id
@IdCaja varchar(12)
as
	begin
		select a.IdCaja,a.FechaApertura,a.HoraApertura,a.FechaCierre,
		a.HoraCierre,a.Contado,a.Calculado,
		a.Diferencia,e.Apellidos,e.Nombres 
		from CajaTB as a inner join EmpleadoTB as e
		on a.IdUsuario = e.IdEmpleado
		where 
		a.IdCaja = @IdCaja	
	end
go

alter table VentaTB
add Impuesto decimal(18,8)
go

UPDATE VentaTB SET Impuesto = 0
GO

select * from VentaTB
go

select * from TipoTicketTB
go

select * from OPE_PRODUCTO where CODIGO_BARRA like 'hs%'
go

select * from OPEVW_STOCK where ID_PRODUCTO = '154228'
go

select * from OPEVW_STOCKALL where ID_PRODUCTO = '154228'
go

