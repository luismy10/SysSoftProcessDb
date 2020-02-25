use [PuntoVentaSysSoftDBDesarrollo]
go

/*
agregado campo serie 17.02.2020
*/

create table TipoDocumentoTB(
	IdTipoDocumento int identity not null,
	Nombre varchar(100) not null,
	Serie varchar (10) not null,
	Predeterminado bit not null,
	NombreImpresion varchar(120) not null
	primary key(IdTipoDocumento)
)
go

truncate table TipoDocumentoTB

select * from TipoDocumentoTB

--call me