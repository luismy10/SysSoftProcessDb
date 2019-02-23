use PuntoVentaSysSoftDB
go

create table TipoDocumentoTB(
	IdTipoDocumento int identity not null,
	Nombre varchar(100) not null,
	Predeterminado bit not null
	primary key(IdTipoDocumento)

)
go

select * from TipoDocumentoTB
go

