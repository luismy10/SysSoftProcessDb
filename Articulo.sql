use PuntoVentaSysSoftDB
go
-------------------------------------------------table articulos---------------------------------------------------------------
truncate table ArticuloTB
go

select * from ArticuloTB
go


/*
 dos campos nuevos  Departamento, Inventario 22/11/2018
 dos campos nuevos  Margen,Utilidad,PrecioMayoreo 23//11/2018
 un capo nuevo CantidadGranel 25/11/2018
 eliminado el campo descripcion 29/11/2018
 eliminado el campo modelo 12/12/2018
*/

/*
 agredando campo Imagen 11/12/2018
 combio el campo Image por varchar(MAX) 21/12/2018

 se elimino el campo departamento 5/02/2019

 se elimino el campo precio venta mayoreo 

 Quitado CantidadGranel (15/02/19)

 Actualizado PrecioVenta, Margen y Utilidad a PrecioVenta1, Margen1 y Utilidad1;
 Agregado: 
		  PrecioVenta2, Margen2, Utilidad2;
		  PrecioVenta3, Margen3, Utilidad3  21/02/2019	

*/



create table ArticuloTB
(
	IdArticulo varchar(12) primary key not null,
	Clave varchar(45) not null,
	ClaveAlterna varchar(45) null,
	NombreMarca varchar(120) not null,
	NombreGenerico varchar(120) null,
	Descripcion varchar(200) null,
	Categoria int null,
	Marca int null,
	Presentacion int,
	UnidadCompra int,
	UnidadVenta tinyint,
	--Departamento int,
	--Localizacion int,
	Estado int,
	StockMinimo decimal(18,4),
	StockMaximo decimal(18,4),
	Cantidad decimal(18,4),
	--CantidadGranel decimal(18,2),
	PrecioCompra decimal(18,4),	
	PrecioVenta1 decimal(18,4),	
	Margen1 smallint,
	Utilidad1 decimal(18,4),
	PrecioVenta2 decimal(18,4),	
	Margen2 smallint,
	Utilidad2 decimal(18,4),
	PrecioVenta3 decimal(18,4),	
	Margen3 smallint,
	Utilidad3 decimal(18,4),
	--PrecioVentaMayoreo decimal(18,2),	
	--MargenMayoreo smallint,
	--UtilidadMayoreo decimal(18,2),	
	Lote bit,
	Inventario bit,
	Imagen varchar(MAX)
	--Serie bit,
)
go

select * from ArticuloTB
go


/*
este procedimiento procedimiento
0almacenado esta en
deprecate

drop procedure Sp_Crud_Articulo
@IdArticulo varchar(12),
@Clave varchar(45),
@ClaveAlterna varchar(45),
@NombreMarca varchar(120),
@NombreGenerico varchar(120),
@Descripcion varchar(200),
@Categoria int,
@Marca int,
@Presentacion int,
@StockMinimo decimal(18,2),
@StockMaximo decimal(18,2),
@PrecioCompra decimal(18,2),
@PrecioVenta decimal(18,2),
@Estado int,
@Lote bit,
-------------------------------
@Imagen varbinary(MAX),
-------------------------------
@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				if exists(select * from ArticuloTB where IdArticulo = @IdArticulo)
					begin
						if exists(select * from ArticuloTB where IdArticulo <> @IdArticulo and Clave = @Clave )
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								update ArticuloTB set Clave = @Clave,ClaveAlterna=@ClaveAlterna,
								NombreMarca=UPPER(@NombreMarca),NombreGenerico=UPPER(@NombreGenerico),
								Descripcion=UPPER(@Descripcion),Categoria=@Categoria,Marca=@Marca,Presentacion=@Presentacion,
								StockMinimo=@StockMinimo,StockMaximo=@StockMaximo,PrecioCompra=@PrecioCompra,
								PrecioVenta=@PrecioVenta,Estado=@Estado,Lote=@Lote
								where IdArticulo = @IdArticulo
								commit
								set @Message = 'updated'
							end
						
					end
				else 
					begin
						if exists(select * from ArticuloTB where Clave = @Clave)
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								declare @idGenerado varchar(12)
								set @idGenerado = dbo.Fc_Articulo_Codigo_Alfanumerico()

								insert into ArticuloTB(IdArticulo,Clave,ClaveAlterna,NombreMarca,NombreGenerico,Descripcion,Categoria,Marca,Presentacion,
								StockMinimo,StockMaximo,PrecioCompra,PrecioVenta,Cantidad,Estado,Lote)
								values(@idGenerado,@Clave,@ClaveAlterna,UPPER(@NombreMarca),UPPER(@NombreGenerico),UPPER(@Descripcion),@Categoria,@Marca,@Presentacion,
								@StockMinimo,@StockMinimo,@PrecioCompra,@PrecioVenta,0,@Estado,@Lote)
								
								insert into ImagenTB(Imagen,IdRelacionado)
								values(@Imagen,@idGenerado)
								
								insert into HistorialArticuloTB(IdArticulo,FechaRegistro,TipoOperacion,Entrada,Salida,Saldo,UsuarioRegistro)
								values('7878',GETDATE(),'Alta de Artículo',0,0,0,'')

								commit
								set @Message = 'registered'
							end
						
					end				
		end try
		begin catch
			rollback
			set @Message='error'
		end catch
	end
go

*/

SELECT IdArticulo,Clave,NombreMarca,Lote,Cantidad FROM ArticuloTB WHERE Cantidad = 0
GO

update ArticuloTB set UnidadCompra = 58

select * from ArticuloTB


/*
	Eliminado campo CantidadGranel 21/02/19
	Actualizado campos PrecioVenta, Margen y Utilidad a PrecioVenta1, Margen1 y Utilidad1 21/02/19
	Agregado campos PrecioVenta2, Margen2, Utilidad2, PrecioVenta3, Margen3 y Utilidad3 21/02/19
*/
alter procedure Sp_Get_Articulo_By_Id
@Clave varchar(45)
as
	begin
		select IdArticulo,Clave,ClaveAlterna,NombreMarca,NombreGenerico,
		Categoria,dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as CategoriaNombre,
		Marca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as MarcaNombre,
		Presentacion,dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as PresentacionNombre,
		UnidadCompra,dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		UnidadVenta,
		StockMinimo,StockMaximo,PrecioCompra,PrecioVenta1,Margen1,Utilidad1,
		PrecioVenta2,Margen2,Utilidad2,PrecioVenta3,Margen3,Utilidad3,
		Cantidad,Estado,Lote,Inventario,Imagen,
		Impuesto,dbo.Fc_Obtener_Nombre_Impuesto(Impuesto) as ImpuestoNombre
		from ArticuloTB
		where Clave=@Clave
	end
go

CREATE function [dbo].[Fc_Obtener_Nombre_Impuesto]
	(
	 @IdImpuesto int
	)
	RETURNS VARCHAR(50)
	AS
	BEGIN
		DECLARE @Result VARCHAR(50)
			BEGIN
				SET @Result = (SELECT Nombre FROM ImpuestoTB WHERE IdImpuesto = @IdImpuesto)	
			END
			RETURN @Result
	END
go


SELECT * FROM ArticuloTB

/*
este procedimiento procedimiento
almacenado esta en
deprecate

drop procedure Sp_Get_Articulo_By_Id_View
@IdArticulo varchar(12)
as
	begin
		select NombreMarca,NombreGenerico,PrecioVenta,Cantidad
		from ArticuloTB
		where IdArticulo=@IdArticulo
	end
go

*/

alter procedure Sp_Listar_Inventario_Articulos
as
	select ROW_NUMBER() over( order by IdArticulo desc) as Filas ,IdArticulo,Clave,NombreMarca,PrecioCompra,PrecioVenta,Cantidad,CantidadGranel,
	UnidadVenta,StockMinimo,StockMaximo
	from ArticuloTB 
go

Sp_Listar_Articulo '283875418426'
GO


/*
	Eliminado campo CantidadGranel 21/02/19
	Actualizado Campo PrecioVenta a PrecioVenta1 21/02/19
*/
alter procedure Sp_Listar_Articulo
@search varchar(100)
as
	begin
			select IdArticulo,Clave,NombreMarca,
			dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
			Cantidad,
			PrecioVenta1,
			UnidadVenta,
			dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
			dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
			Imagen	
			from ArticuloTB 
			where 			
			(@search = '' ) 
			or 
			(Clave = @search )
			or
			(ClaveAlterna = @search )
			or
			(NombreMarca like @search +'%')
			
			order by NombreMarca asc

		
	end
go

/*
	Eliminado campo CantidadGranel 21/02/19
	Actualizado Campo PrecioVenta a PrecioVenta1 21/02/19
*/
alter procedure Sp_Listar_Articulo_Categoria
@Categoria int
as
	begin
			select IdArticulo,Clave,NombreMarca,
			dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
			Cantidad,
			PrecioVenta1,
			UnidadVenta,
			dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
			dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
			Imagen	
			from ArticuloTB 
			where Categoria=@Categoria			
			order by NombreMarca asc
	end
go

/*
	Actualizado campo PrecioVenta a PrecioVenta1 21/02/19
	Agregado campos: Margen1, Utilidad1,
					 PrecioVenta2, Margen2, Utilidad2,
					 PrecioVenta3, Margen3 y Utilidad3
*/

alter procedure Sp_Listar_Articulo_Lista_View
@search varchar(100)
as
	begin
		select IdArticulo,Clave,NombreMarca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		Cantidad,PrecioCompra,PrecioVenta1,Margen1,Utilidad1,PrecioVenta2,Margen2,Utilidad2,PrecioVenta3,Margen3,Utilidad3,UnidadVenta,Inventario,Impuesto,Lote
		from ArticuloTB 
		where (@search = '') 
		or 
		(Clave = @search)
		or
		(ClaveAlterna = @search)
		or
		(NombreMarca like @search +'%')
		order by NombreMarca asc
	end
go


alter procedure Sp_Listar_Articulo_By_Search 
@search varchar(60)
as
	begin
		select IdArticulo,Clave,NombreMarca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as Presentacion ,
		Cantidad,PrecioVenta,
		dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,UnidadVenta,Lote,Inventario
		from ArticuloTB 
		where Clave = @search
	end
go

select * from ArticuloTB
go


create function Fc_Articulo_Codigo_Alfanumerico ()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdArticulo from ArticuloTB)
					begin					
						set @ValorActual = (select MAX(IdArticulo) from ArticuloTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'AT000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'AT00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'AT0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'AT'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'AT0001'
					end
			end
			return @CodGenerado
		end
go
--------------------------------------------------------------------------------------------------------------

----------------------------------tabla imagen----------------------------------------------------------------
--eliminando la tabla imagen
--11/12/2018
drop table ImagenArticuloTB
(
	IdImagenArticulo bigint identity primary key not null,
	Imagen varbinary(MAX) null,
	IdRelacionado varchar(12) not null
)
go


truncate table ImagenArticuloTB
GO

select * from ImagenArticuloTB
go

/*
este procedimiento procedimiento
almacenado esta en
deprecate

drop procedure Sp_Crud_Imagen
@IdImagen bigint,
@Imagen varbinary(MAX),
@IdRelacionado varchar(12),
@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				if exists(select IdImagen from ImagenTB where IdImagen=@IdImagen and IdRelacionado=@IdRelacionado)
					begin
						update ImagenTB
						set Imagen=@Imagen
						where IdImagen=@IdImagen and IdRelacionado=@IdRelacionado
						commit
						set @Message = 'update'
					end
				else
					begin
						insert into ImagenTB(Imagen,IdRelacionado)
						values(@Imagen,@IdRelacionado)
						commit
						set @Message = 'insert'
					end
		end try
		begin catch
			rollback
			set @Message = 'error'
		end catch
	end
go
*/
------------------------------------------------------------------------------------------------------------------------

----------------------------------------------histirial del artículo----------------------------------------------------

truncate Table HistorialArticuloTB
go

select * from HistorialArticuloTB
go

create table HistorialArticuloTB
(
	IdHistorial bigint not null identity primary key,
	IdArticulo varchar(12),
	FechaRegistro datetime,
	TipoOperacion varchar(60),	
	Entrada decimal(18,2),
	Salida decimal(18,2),
	Saldo decimal(18,2),
	UsuarioRegistro varchar(15)
)
go

update HistorialArticuloTB 
set FechaRegistro = GETDATE(),TipoOperacion = ?,Entrada = ? , Salida = ?, Saldo = ?, UsuarioRegistro = ?
where IdArticulo = ? 

alter procedure Sp_listar_Historial_Articulo
@IdArticulo varchar(12)
as
begin
	select ROW_NUMBER() over( order by IdHistorial desc) as Filas,FechaRegistro,TipoOperacion,Entrada,Salida,Saldo,UsuarioRegistro 
	from HistorialArticuloTB
	where (IdArticulo = @IdArticulo) 
end
go

alter procedure Sp_Generar_Listardo_CodBar 
@UnidadVenta tinyint,
@Categoria int
as
	begin
		SELECT Clave,ClaveAlterna,NombreMarca,UnidadVenta,Categoria
         FROM ArticuloTB
		 WHERE (@UnidadVenta = 0 and @Categoria = 0) 
		 or 
		 (UnidadVenta = @UnidadVenta and @Categoria = 0) 
		 or
		 (UnidadVenta = @UnidadVenta and Categoria = @Categoria) 
		 or
		 (@UnidadVenta = 0 and Categoria = @Categoria) 
	end
go

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         