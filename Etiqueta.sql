use PuntoVentaSysSoftDBDesarrollo
go

create table TipoEtiquetaTB(
	idTipoEtiqueta int identity(1,1) not null,
	Nombre varchar(50),
	primary key(idTipoEtiqueta)
)
go

select * from TipoEtiquetaTB
go

--tipo etiqueta	
----1 articulo
----2 lotes
----3 compras

------tipo variable
--------1 articulo
----------1 codigo
----------2 descripcion
----------3 cantidad
----------4 precio compra
--------2 empresa
----------1 giro comercial
----------2 nombre
----------3 numero documento
----------4 representante

insert into TipoEtiquetaTB(Nombre)values('Artículo')
go

truncate table EtiquetaTB
go

create table EtiquetaTB(
	idEtiqueta int identity(1,1) not null,
	nombre varchar(60) not null,
	tipo int not null,
	predeterminado bit not null,
	medida varchar(80),
	ruta varchar(max) not null,
	imagen image,
	primary key(idEtiqueta)
)
go

TRUNCATE TABLE EtiquetaTB
GO

SELECT  * FROM EtiquetaTB
GO

SELECT nombre FROM EtiquetaTB WHERE idEtiqueta <> 2 and nombre = 'Articulo con precio'
GO

select et.idEtiqueta,et.nombre,td.nombre as nombretipo,et.predeterminado,et.medida,et.ruta,et.imagen
from EtiquetaTB as et inner join TipoEtiquetaTB as td 
on et.tipo = td.idTipoEtiqueta
go

alter procedure Sp_Listar_Etiquetas_By_Type
@type int
as
	begin
		select et.idEtiqueta,et.nombre,td.nombre as nombretipo,et.predeterminado,et.medida,et.ruta,et.imagen 
		from EtiquetaTB as et inner join TipoEtiquetaTB as td on et.tipo = td.idTipoEtiqueta
		where (@type = 0) or (et.tipo = @type)
	end
go