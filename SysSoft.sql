USE PuntoVentaSysSoftDB
go

----------------------------------------------table de pais-----------------------------------------------------------
CREATE TABLE PaisTB (
  PaisCodigo char(3) NOT NULL DEFAULT '',
  PaisNombre varchar(52) NOT NULL DEFAULT '',
  PaisContinente varchar(50) NOT NULL DEFAULT 'South America',
  PaisRegion varchar(26) NOT NULL DEFAULT '',
  PaisArea float NOT NULL DEFAULT '0.00',
  PaisCapital int DEFAULT NULL,
  PRIMARY KEY ("PaisCodigo")
)
GO
select * from PaisTB where PaisNombre like 'pe%'
go

alter procedure Sp_Listar_Pais
as
	begin
		select PaisCodigo,PaisNombre from PaisTB order by PaisNombre
	end
go


CREATE TABLE CiudadTB (
  IdCiudad int NOT NULL,
  PaisCodigo char(3) NOT NULL DEFAULT '',
  Departamento varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (IdCiudad)
)
GO

--drop procedure Sp_Listar_Ubigeo
--@PaisCodigo char(3)
--as
--select DISTINCT ci.IdCiudad,ci.Departamento,pr.Provincia,di.Distrito 
--from CiudadTB as ci inner join ProvinciaTB as pr on ci.IdCiudad = pr.IdCiudad
--inner join DistritoTB as di on pr.IdProvincia = di.IdProvincia
--where ci.PaisCodigo = @PaisCodigo order by ci.Departamento
--go

CREATE TABLE ProvinciaTB (
IdProvincia int NOT NULL DEFAULT '0',
Provincia varchar(50) DEFAULT NULL,
IdCiudad int DEFAULT NULL,
PRIMARY KEY (IdProvincia)
)
GO

CREATE TABLE DistritoTB (
IdDistrito int NOT NULL DEFAULT '0',
Distrito varchar(50) DEFAULT NULL,
IdProvincia int DEFAULT NULL,
PRIMARY KEY (IdDistrito)
)
go

select * from DistritoTB where Distrito like 's%'
go

alter procedure Sp_Listar_Ciudad 
@PaisCodigo char(3)
as
	begin
		select IdCiudad,Departamento from CiudadTB where PaisCodigo = @PaisCodigo order by Departamento
	end
go

create procedure Sp_Listar_Provincia
@IdCiudad int
as
	begin
		select IdProvincia,Provincia from ProvinciaTB where IdCiudad = @IdCiudad order by Provincia
	end
go

create procedure Sp_Listar_Distrito
@IdProvincia int
as
	begin
		select IdDistrito,Distrito from DistritoTB where IdProvincia = @IdProvincia order by Distrito
	end
go

----------------------------------------------empresa-----------------------------------------------------------

create table EmpresaTB(
	IdEmpresa int identity primary key,
	GiroComercial int not null,
	Nombre varchar(100) not null,
	Telefono varchar(20) null,
	Celular varchar(20) null,
	PaginaWeb varchar(200) null,
	Email varchar(100) null,
	Domicilio varchar(200) null,
	TipoDocumento int null,
	NumeroDocumento varchar(20) null,
	RazonSocial varchar(100) null,
	NombreComercial varchar(100) null,
	Pais char(3) null,
	Ciudad int null,
	Provincia int null,
	Distrito int null
)
go

select * from EmpresaTB
go

alter procedure Sp_Crud_MiEmpresa
@IdEmpresa int,
@GiroComercial int,
@Nombre varchar(100),
@Telefono varchar(20) ,
@Celular varchar(20) ,
@PaginaWeb varchar(200) ,
@Email varchar(100) ,
@Domicilio varchar(200) ,
@TipoDocumento int ,
@NumeroDocumento varchar(20) ,
@RazonSocial varchar(100) ,
@NombreComercial varchar(100) ,
@Pais char(3) ,
@Ciudad int ,
@Provincia int null,
@Distrito int null,
@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				if exists(select IdEmpresa from EmpresaTB where IdEmpresa = @IdEmpresa)
					begin
						update EmpresaTB
						set GiroComercial=@GiroComercial,Nombre = UPPER(@Nombre),Telefono=@Telefono,Celular=@Celular,PaginaWeb=@PaginaWeb,
						Email=@Email,Domicilio=UPPER(@Domicilio),TipoDocumento=@TipoDocumento,NumeroDocumento=@NumeroDocumento,
						RazonSocial=UPPER(@RazonSocial),NombreComercial=UPPER(@NombreComercial),Pais=@Pais,Ciudad=@Ciudad,Provincia=@Provincia,Distrito=@Distrito
						where IdEmpresa=@IdEmpresa
						commit
						set @Message = 'updated'
					end
				else
					begin
						insert into EmpresaTB(GiroComercial,Nombre,Telefono,Celular,PaginaWeb,Email,Domicilio,
						TipoDocumento,NumeroDocumento,RazonSocial,NombreComercial,Pais,Ciudad,Provincia,Distrito)
						values(@GiroComercial,UPPER(@Nombre),@Telefono,@Celular,@PaginaWeb,@Email,UPPER(@Domicilio),
						@TipoDocumento,@NumeroDocumento,UPPER(@RazonSocial),UPPER(@NombreComercial),@Pais,@Ciudad,@Provincia,@Distrito)
						commit
						set @Message = 'registered'
					end
		end try

		begin catch
			rollback
			set @Message='error'
		end catch
	end
go

create table ImagenTB
(
	IdImagen bigint identity primary key not null,
	Imagen varbinary(MAX) null,
	IdRelacionado varchar(12) not null,
	IdSubRelacion bigint null
)
go

alter table ImagenTB
add IdSubRelacion bigint
go

truncate table ImagenTB
GO

select * from ImagenTB
go