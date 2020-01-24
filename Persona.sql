USE PuntoVentaSysSoftDBDesarrollo
go

/*
QUITADO LA TABLA FACTURACION
QUITAR LOS CAMPOS USUARIO DE REGISTRO
QUITAR LOS CAMPOS FECHA DE REGISTRO
QUITAR LOS CAMPOS USUARIO ACTUALIZO
QUITAR LOS CAMPOS FECHA ACTUALIZO
QUITAR LOS CAMPOS APELLIDOS, NOMBRES, SEXO, FECHANACIMIENTO
AGREGAR EL CAMPO REPRESENTANTE
AGREGAR EL CAMPO INFORMACION
*/

create table ClienteTB(
	IdCliente varchar(12) not null,
	TipoDocumento int not null,
	NumeroDocumento varchar(20) not null,
	Informacion varchar(100) not null,
	--Apellidos varchar(50) not null,
	--Nombres varchar(50) not null,
	--Sexo int null,
	--FechaNacimiento date null,
	Telefono varchar(20) null,
	Celular varchar(20) null,
	Email varchar(100) null,
	Direccion varchar(200) null,
	Representante varchar(200) null
	Estado int not null,
	--UsuarioRegistro varchar(50) null,
	--FechaRegistro datetime null,
	--UsuarioActualizado varchar(50) null,
	--FechaActualizado date null,	
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
select ci.IdCliente,ci.NumeroDocumento,ci.Informacion,ci.Telefono,
ci.Celular,ci.Direccion,ci.Representante,dbo.Fc_Obtener_Nombre_Detalle(ci.Estado,'0001') as Estado
from ClienteTB as ci 
where
	(@search = '')  
	or 
	(ci.NumeroDocumento like @search+'%')
	OR
	(ci.Informacion LIKE @search+'%')
	
go 

ALTER procedure Sp_Listar_Clientes_Venta
@search varchar(55)
as
select ci.IdCliente,dbo.Fc_Obtener_Nombre_Detalle(TipoDocumento,'0003') as Documento,ci.NumeroDocumento,
ci.Informacion,ci.Direccion
from ClienteTB as ci
where 
	(@search = '')  
	or 
	(ci.NumeroDocumento like @search+'%')
	or 
	(ci.Informacion LIKE @search+'%')
go

Sp_Get_Cliente_By_Id '78945612'
go

alter procedure Sp_Get_Cliente_By_Id
@NumeroDocumento varchar(20)
as
	begin
		select ci.IdCliente,ci.TipoDocumento,ci.NumeroDocumento,ci.Informacion,
		ci.Telefono,ci.Celular,ci.Email,ci.Direccion,ci.Representante,ci.Estado
		from ClienteTB as ci
		where ci.NumeroDocumento = @NumeroDocumento
	end
go

select * from FacturacionTB
go

truncate table FacturacionTB
go

drop table FacturacionTB(
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
	@IdCliente varchar(12),
	@TipoDocumento int,
	@NumeroDocumento varchar(20),
	@Informacion varchar(100),
	@Telefono varchar(20),
	@Celular varchar(20) ,
	@Email varchar(100) ,
	@Direccion varchar(200) ,
	@Representante varchar(200),
	@Estado int,
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
								update ClienteTB set TipoDocumento=@TipoDocumento,NumeroDocumento=@NumeroDocumento,Informacion=UPPER(@Informacion),
								Telefono=@Telefono,Celular=@Celular,Email=@Email,Direccion=@Direccion,Representante=@Representante,Estado=@Estado
								where IdCliente = @IdCliente
								commit
								set @Message = 'updated'
							end
					end
				else		
					begin
						declare @codCliente varchar(12)		
						set @codCliente = dbo.Fc_Cliente_Codigo_Alfanumerico()

						insert into ClienteTB(IdCliente,TipoDocumento,NumeroDocumento,Informacion,Telefono,Celular,Email,Direccion,Representante,Estado) 
						values(@codCliente,@TipoDocumento,@NumeroDocumento,UPPER(@Informacion),@Telefono,@Celular,@Email,@Direccion,@Representante,@Estado)

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


