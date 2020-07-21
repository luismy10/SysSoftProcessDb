use [PuntoVentaSysSoftDBDesarrollo]
go

/*
agregado campo serie 17.02.2020
agregar campo sistema 18 06 2020
*/

create table TipoDocumentoTB(
	IdTipoDocumento int identity not null,
	Nombre varchar(100) not null,
	Serie varchar (10) not null,
	Predeterminado bit not null,
	---NombreImpresion varchar(120) not null,
	Sistema bit null,
	primary key(IdTipoDocumento)
)
go

truncate table TipoDocumentoTB

select * from TipoDocumentoTB
go

alter function Fc_Obtener_Nombre_Tipo_Documento
	(
	 @IdTipoDocumento int
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @Result VARCHAR(100)
			BEGIN
				SET @Result = (SELECT Nombre FROM TipoDocumentoTB WHERE IdTipoDocumento = @IdTipoDocumento)	
			END
			RETURN @Result
	END
go

--call me