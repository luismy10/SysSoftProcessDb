USE PuntoVentaSysSoftDBDesarrollo
go


create table ClienteTB(
	IdCliente varchar(12) not null,
	TipoDocumento int not null,
	NumeroDocumento varchar(20) not null,
	Apellidos varchar(50) not null,
	Nombres varchar(50) not null,
	Sexo int null,
	FechaNacimiento date null,
	Telefono varchar(20) null,
	Celular varchar(20) null,
	Email varchar(100) null,
	Direccion varchar(200) null,
	Estado int not null,
	UsuarioRegistro varchar(50) null,
	FechaRegistro datetime null,
	UsuarioActualizado varchar(50) null,
	FechaActualizado date null,	
	primary key(IdCliente)
)
go

truncate table ClienteTB
go

select * from ClienteTB
go

alter procedure Sp_Listar_Clientes
@search varchar(55)
as
select ROW_NUMBER() over( order by ci.IdCliente desc) as Filas,ci.IdCliente,ci.NumeroDocumento,
ci.Apellidos,ci.Nombres,
ci.Telefono,ci.Celular,
dbo.Fc_Obtener_Nombre_Detalle(ci.Estado,'0001') as Estado,CAST(ci.FechaRegistro AS DATE) FRegistro
 from ClienteTB as ci 
where (@search = '')  or (ci.NumeroDocumento like @search+'%')
or (
			(CONCAT(ci.Apellidos,' ',ci.Nombres) LIKE @search+'%')
			or
			(CONCAT(ci.Nombres,' ',ci.Apellidos) LIKE @search+'%')
			
		)
go 

alter procedure Sp_Listar_Clientes_Venta
@search varchar(55)
as
select ROW_NUMBER() over( order by ci.IdCliente desc) as Filas,ci.IdCliente,ci.NumeroDocumento,
ci.Apellidos,ci.Nombres
from ClienteTB as ci
where (@search = '')  or (ci.NumeroDocumento like @search+'%')
or (
			(CONCAT(ci.Apellidos,' ',ci.Nombres) LIKE @search+'%')
			or
			(CONCAT(ci.Nombres,' ',ci.Apellidos) LIKE @search+'%')
		)
go

Sp_Get_Cliente_By_Id '78945612'
go

alter procedure Sp_Get_Cliente_By_Id
@NumeroDocumento varchar(20)
as
	begin
		select ci.IdCliente,ci.TipoDocumento,ci.NumeroDocumento,ci.Apellidos,
		ci.Nombres,ci.Sexo,ci.FechaNacimiento,
		ci.Telefono,ci.Celular,ci.Email,ci.Direccion,ci.Estado,
		f.TipoDocumento as TipoFactura,f.NumeroDocumento as NumeroFactura,f.RazonSocial,f.NombreComercial,
		f.Pais,f.Ciudad,f.Provincia,f.Distrito
		from ClienteTB as ci inner join FacturacionTB as f
		on ci.IdCliente = f.IdCliente
		where ci.NumeroDocumento = @NumeroDocumento
	end
go


select * from FacturacionTB
go

truncate table FacturacionTB
go

create table FacturacionTB(
	IdFacturacion bigint identity primary key not null,
	IdCliente varchar(12) not null,
	TipoDocumento int null,
	NumeroDocumento varchar(20) null,
	RazonSocial varchar(50) null,
	NombreComercial varchar(50) null,
	Pais char(3) null,
	Ciudad int null,
	Provincia int null,
	Distrito int null,
	Moneda int null
)
go

/*
drop procedure Sp_Crud_Persona
	@IdPersona varchar(12),
	@TipoDocumento int,
	@NumeroDocumento varchar(20),
	@ApellidoPaterno varchar(50),
	@ApellidoMaterno varchar(50),
	@PrimerNombre varchar(50),
	@SegundoNombre varchar(50),
	@Sexo int,
	@FechaNacimiento date,
	@Estado int,
	@UsuarioRegistro varchar(50),
	------------------------------------
	@TipoDocumentoFactura int,
	@NumeroDocumentoFactura varchar(20),
	@RazonSocial varchar(50) ,
	@NombreComercial varchar(50),

	@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				if exists(select IdPersona from PersonaTB where IdPersona = @IdPersona)
					begin
						if exists(select NumeroDocumento from PersonaTB where IdPersona <> @IdPersona and NumeroDocumento = @NumeroDocumento)
							begin								
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								update PersonaTB set TipoDocumento=@TipoDocumento,NumeroDocumento = @NumeroDocumento,
								ApellidoPaterno=UPPER(@ApellidoPaterno),ApellidoMaterno=UPPER(@ApellidoMaterno),
								PrimerNombre=UPPER(@PrimerNombre),SegundoNombre=UPPER(@SegundoNombre),Sexo=@Sexo,
								FechaNacimiento=@FechaNacimiento,Estado=@Estado
								where IdPersona = @IdPersona

								update FacturacionTB set TipoDocumento =@TipoDocumentoFactura,
								NumeroDocumento=@NumeroDocumentoFactura,RazonSocial=UPPER(@RazonSocial),
								NombreComercial=UPPER(@NombreComercial)
								where IdPersona =  @IdPersona

								commit
								set @Message = 'updated'
							end
					end
				else
					begin
						if exists(select NumeroDocumento from PersonaTB where NumeroDocumento = @NumeroDocumento)
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								declare @codigoPersona varchar(12)
								set @codigoPersona = dbo.Fc_Persona_Codigo_Alfanumerico()
								insert into PersonaTB(IdPersona,TipoDocumento,NumeroDocumento,ApellidoPaterno,ApellidoMaterno,PrimerNombre,SegundoNombre,Sexo,FechaNacimiento,Estado,UsuarioRegistro,FechaRegistro)
								values(@codigoPersona,@TipoDocumento,@NumeroDocumento,UPPER(@ApellidoPaterno),UPPER(@ApellidoMaterno),UPPER(@PrimerNombre),UPPER(@SegundoNombre),@Sexo,@FechaNacimiento,@Estado,@UsuarioRegistro,GETDATE())
								
								insert into FacturacionTB(IdPersona,TipoDocumento,NumeroDocumento,RazonSocial,NombreComercial)
								values(@codigoPersona,@TipoDocumentoFactura,@NumeroDocumentoFactura,UPPER(@RazonSocial),UPPER(@NombreComercial))

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

GO
*/

declare @NumeroDocumento varchar(20),@idpersona varchar(20)
set @NumeroDocumento = '71498203'
if exists(select NumeroDocumento from PersonaTB where NumeroDocumento = @NumeroDocumento)
	
	begin							
		set @idpersona = (select IdPersona from PersonaTB where NumeroDocumento = @NumeroDocumento)
		if exists(select IdPersona from ClienteTB where IdPersona = @idpersona)
			begin
				print 'existe'
			end
		else
			begin
				print 'no existe'
			end
		
					
	end
else
		begin
				print 'no'
		end
go

alter procedure Sp_Crud_Persona_Cliente
	------------------------------------
	@IdCliente varchar(12),
	@TipoDocumento int,
	@NumeroDocumento varchar(20),
	@Apellidos varchar(50),
	@Nombres varchar(50),
	@Sexo int,
	@FechaNacimiento date,
	@Telefono varchar(20),
	@Celular varchar(20) ,
	@Email varchar(100) ,
	@Direccion varchar(200) ,
	@Estado int,
	@UsuarioRegistro varchar(50),
	------------------------------------
	@TipoDocumentoFactura int,
	@NumeroDocumentoFactura varchar(20),
	@RazonSocial varchar(50) ,
	@NombreComercial varchar(50),
	@Pais char(3),
	@Ciudad int,
	@Provincia int,
	@Distrito int,
	@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				if exists(select c.IdCliente from ClienteTB as c  where c.IdCliente = @IdCliente)
					begin
						if exists(select c.IdCliente from ClienteTB as c where c.IdCliente <> @IdCliente and c.NumeroDocumento = @NumeroDocumento)
							begin								
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								
								update ClienteTB set TipoDocumento=@TipoDocumento,NumeroDocumento=@NumeroDocumento,Apellidos=UPPER(@Apellidos),Nombres=UPPER(@Nombres),
								Sexo=@Sexo,FechaNacimiento=@FechaNacimiento,
								Telefono=@Telefono,Celular=@Celular,Email=@Email,Direccion=@Direccion,Estado=@Estado,
								UsuarioActualizado=@UsuarioRegistro,FechaActualizado = GETDATE()
								where IdCliente = @IdCliente

								update FacturacionTB set TipoDocumento =@TipoDocumentoFactura,
								NumeroDocumento=@NumeroDocumentoFactura,RazonSocial=UPPER(@RazonSocial),
								NombreComercial=UPPER(@NombreComercial),Pais=@Pais,Ciudad=@Ciudad,Provincia=@Provincia,Distrito=@Distrito
								where IdCliente =  @IdCliente

								commit
								set @Message = 'updated'
							end
					end
				else		
					begin
						declare @codCliente varchar(12)		
						set @codCliente = dbo.Fc_Cliente_Codigo_Alfanumerico()

						insert into ClienteTB(IdCliente,TipoDocumento,NumeroDocumento,Apellidos,Nombres,Sexo,FechaNacimiento,Telefono,Celular,Email,Direccion,Estado,UsuarioRegistro,FechaRegistro) 
						values(@codCliente,@TipoDocumento,@NumeroDocumento,UPPER(@Apellidos),UPPER(@Nombres),@Sexo,@FechaNacimiento,@Telefono,@Celular,@Email,@Direccion,@Estado,@UsuarioRegistro,GETDATE())

						insert into FacturacionTB(IdCliente,TipoDocumento,NumeroDocumento,RazonSocial,NombreComercial,Pais,Ciudad ,Provincia ,Distrito )
						values(@codCliente,@TipoDocumentoFactura,@NumeroDocumentoFactura,UPPER(@RazonSocial),UPPER(@NombreComercial),@Pais,@Ciudad,@Provincia,@Distrito)

						commit 
						set @Message = 'registered'						
					end
		end try

		begin catch
			rollback
			set @Message='error'
		end catch
	end

GO


create function Fc_Cliente_Codigo_Alfanumerico()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdCliente from ClienteTB)
					begin					
						set @ValorActual = (select MAX(IdCliente) from ClienteTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'CL000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'CL00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'CL0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'CL'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'CL0001'
					end
			end
			return @CodGenerado
		end
go



select * from DirectorioTB
go

truncate table DirectorioTB
go

--tabla directorio
create table DirectorioTB(
	IdDirectorio bigint identity primary key,
	Atributo int not null,
	Valor varchar(100) not null,
	IdPersona varchar(12) not null
)
go

--procedimiento para unir tablas
alter procedure Sp_Listar_Directorio
@search varchar(50)
as
	begin
		(select pe.IdPersona as Codigo,dbo.Fc_Obtener_Nombre_Detalle(pe.TipoDocumento,'0003') as Tipo,pe.NumeroDocumento as Documento,CONCAT(pe.ApellidoPaterno,' ',pe.ApellidoMaterno,' ',pe.PrimerNombre,' ',pe.SegundoNombre) as Datos
		 from PersonaTB as pe inner join DirectorioTB as di
		on pe.IdPersona = di.IdPersona

		where (@search = '') or (pe.NumeroDocumento like @search+'%')
		)
		union
		(select pr.IdProveedor as Codigo,dbo.Fc_Obtener_Nombre_Detalle(pr.TipoDocumento,'0003') as Tipo,pr.NumeroDocumento as Documento,pr.RazonSocial as Datos 
		from ProveedorTB as pr inner join DirectorioTB as di
		on pr.IdProveedor = di.IdPersona
		where (@search = '') or (pr.NumeroDocumento like @search+'%')
		)
	end
go

--procedimiento directorio
create procedure Sp_Crud_Directorio
@IdDirectorio bigint,
@Atributo int,
@Valor varchar(100),
@IdPersona varchar(12),
@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				if exists(select * from DirectorioTB where IdDirectorio = @IdDirectorio)
					begin
						update DirectorioTB set Atributo =@Atributo,
						Valor=@Valor				
						where IdDirectorio = @IdDirectorio
						commit 
						set @Message = 'updated'
					end
				else
					begin
						insert into DirectorioTB(Atributo,Valor,IdPersona)
						values(@Atributo,@Valor,@IdPersona)
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

--directorio
create procedure Sp_Get_Directorio_By_Id
@IdPersona varchar(12)
as
	begin
		select IdDirectorio,Atributo,dbo.Fc_Obtener_Nombre_Detalle(Atributo,'0002')as Nombre,Valor,IdPersona
		 from DirectorioTB
		where IdPersona=@IdPersona
	end
go

create function Fc_Obtener_Nombre_Detalle
	(
	@IdDetalle int,
	@IdMantenimiento varchar(10)
	)
	RETURNS VARCHAR(80)
	AS
	BEGIN
		DECLARE @Result VARCHAR(80)
			BEGIN
				SET @Result = (SELECT Nombre FROM DetalleTB WHERE IdDetalle=@IdDetalle and IdMantenimiento=@IdMantenimiento)	
			END
			RETURN @Result
	END
GO


