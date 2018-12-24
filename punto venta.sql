CREATE DATABASE PuntoVentaSysSoftDB
GO

USE PuntoVentaSysSoftDB
go



--declare @count INT =40254;
--WHILE @count <= 40254+80000
--BEGIN
--	insert into DirectorioTB(IdDirectorio,Atributo,Valor1,Valor2,Valor3,IdPersona,UsuarioRegistro,FechaRegistro,UsuarioActualizo,FechaActualizo) 
--	values(@count,5,'977834322',null,null,5,76423388,'2018-08-17',null,null)

--	SET @count = @count+1;
--END
--GO

truncate table MantenimientoTB
go

select * from MantenimientoTB
go

create table MantenimientoTB
(
	IdMantenimiento varchar(10) primary key not null,
	Nombre varchar(100) not null,
	Estado char(1) not null,
	UsuarioRegistro varchar(15) not null,
	FechaRegistro datetime
)
go

alter procedure Sp_List_Table_Matenimiento
@Nombre varchar(100)
as
	begin
		select IdMantenimiento,Nombre from MantenimientoTB 
		where 
		(Nombre like @Nombre+'%' and IdMantenimiento <> '0001')
		 or (@Nombre = '' and IdMantenimiento <> '0001')
	end

go

select * from DetalleTB
go


create table DetalleTB
(
	IdDetalle int not null,
	IdMantenimiento varchar(10) not null,
	IdAuxiliar varchar(10) null,
	Nombre varchar(60) not null,
	Descripcion varchar(100),
	Estado char(1) not null,
	UsuarioRegistro varchar(15) not null
)
go

Sp_Get_Detalle_IdNombre '0','0003','RUC'
GO

alter procedure Sp_Get_Detalle_IdNombre
@Opcion char(1),
@IdMantenimiento varchar(10),
@Nombre varchar(60)
as
	begin
		if(@Opcion = '1')
			begin
				select IdDetalle,Nombre from DetalleTB where IdMantenimiento = @IdMantenimiento and Nombre <> @Nombre
			end
		else if(@Opcion = '2')
			begin
				select IdDetalle,Nombre from DetalleTB where IdMantenimiento = @IdMantenimiento
			end
		else if(@Opcion = '3')
			begin
				select IdDetalle,Nombre,Descripcion from DetalleTB where IdMantenimiento = @IdMantenimiento
			end
		else if(@Opcion = '4')
			begin
				select IdDetalle,Nombre,Descripcion from DetalleTB
				 where (IdMantenimiento = @IdMantenimiento and @Nombre = '')
				 or
				 (IdMantenimiento = @IdMantenimiento and Nombre like '%'+@Nombre+'%') 
			end
		else
			begin
				select IdDetalle,Nombre from DetalleTB where IdMantenimiento = @IdMantenimiento and Nombre = @Nombre
			end
		
	end
go

create procedure Sp_Get_Detalle_Id
@IdMantenimiento varchar(10)
as
	begin
		select IdDetalle,Nombre from DetalleTB where IdMantenimiento = @IdMantenimiento
	end
go

select * from DetalleTB where IdMantenimiento = '0007'


alter procedure Sp_Crud_Detalle
@IdDetalle int,
@IdMantenimiento varchar(10),
@IdAuxiliar varchar(10),
@Nombre varchar(60),
@Descripcion varchar(100),
@Estado char(1),
@UsuarioRegistro varchar(15),
@Message varchar(20) out
as

	begin
		begin try
			begin transaction
				if exists(select IdDetalle,IdMantenimiento from DetalleTB where IdDetalle=@IdDetalle and IdMantenimiento=@IdMantenimiento)
					begin
						if exists(select IdDetalle,IdMantenimiento from DetalleTB where IdDetalle<>@IdDetalle and IdMantenimiento=@IdMantenimiento and Nombre = @Nombre)
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								update DetalleTB set IdAuxiliar=UPPER(@IdAuxiliar),Nombre=UPPER(@Nombre),Descripcion=UPPER(@Descripcion),Estado=@Estado
								where IdDetalle =@IdDetalle and IdMantenimiento = @IdMantenimiento
								commit
								set @Message = 'updated'
							end
					end
				else
					begin
						if exists(select Nombre from DetalleTB where IdMantenimiento = @IdMantenimiento and Nombre = @Nombre)
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								insert into DetalleTB(IdDetalle,IdMantenimiento,IdAuxiliar,Nombre,Descripcion,Estado,UsuarioRegistro)
								values(dbo.Fc_Detalle_Generar_Codigo(@IdMantenimiento),@IdMantenimiento,UPPER(@IdAuxiliar),UPPER(@Nombre),UPPER(@Descripcion),@Estado,@UsuarioRegistro)
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

alter procedure Sp_List_Table_Detalle
@IdMantenimiento varchar(10),
@Nombre varchar(60)
as
	begin
		select IdDetalle,IdAuxiliar,Nombre,Descripcion,Estado from DetalleTB 
		where (IdMantenimiento = @IdMantenimiento and @Nombre = '') or (IdMantenimiento = @IdMantenimiento and Nombre like @Nombre+'%')
	end
go

alter table DetalleTB add constraint Pk_DetalleTB primary key(IdDetalle,IdMantenimiento)
go

alter procedure Sp_Crud_Mantenimiento
@IdMantenimiento varchar(10),
@Nombre varchar(100),
@Estado char(1),
@UsuarioRegistro varchar(15),
@Message varchar(20) out
as
	begin
		begin try
			begin tran	
				if exists(select IdMantenimiento from MantenimientoTB where IdMantenimiento = @IdMantenimiento)
					begin
						if exists(select Nombre,IdMantenimiento from MantenimientoTB where IdMantenimiento <> @IdMantenimiento and Nombre = @Nombre)
							begin								
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								update MantenimientoTB set Nombre=UPPER(@Nombre) where IdMantenimiento = @IdMantenimiento
								commit
								set @Message = 'updated'
							end
					end
				else
					begin
						if exists(select Nombre,IdMantenimiento from MantenimientoTB where IdMantenimiento <> @IdMantenimiento and Nombre = @Nombre)
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								insert into MantenimientoTB(IdMantenimiento,Nombre,Estado,UsuarioRegistro,FechaRegistro)
								values(dbo.Fc_Mantenimiento_Generar_Codigo(),UPPER(@Nombre),@Estado,@UsuarioRegistro,GETDATE())
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



alter function Fc_Mantenimiento_Generar_Codigo() returns varchar(10)
	as
		begin
			declare @Codigo varchar(10),@NewCodigo varchar(10)
				if exists(select IdMantenimiento from MantenimientoTB)
					begin
						set @Codigo = (select MAX(IdMantenimiento) from MantenimientoTB)
						set @Codigo = CONVERT(INT,@Codigo) +1
						IF(@Codigo  <= 9)
							BEGIN 
								SET @NewCodigo='000'+CONVERT(VARCHAR,@Codigo)							
							END
						ELSE IF(@Codigo >= 10 AND @Codigo <= 99)
							BEGIN
								SET @NewCodigo='00'+CONVERT(VARCHAR,@Codigo)					
							END
						ELSE IF(@Codigo >= 100 AND @Codigo <= 999)
							BEGIN 
								SET @NewCodigo='0'+CONVERT(VARCHAR,@Codigo)
							END
						ELSE
							BEGIN
								SET @NewCodigo=''+CONVERT(VARCHAR,@Codigo)
							END
					end
				else 
					begin
						set @Codigo =  '0001'
						set @NewCodigo = @Codigo
					end

		return @NewCodigo
		end

go

alter function Fc_Detalle_Generar_Codigo(@Codigo varchar(10))returns int
as
	begin 
		declare @NewCodigo varchar(10),@CodGenerado int
		if exists(select * from DetalleTB where IdMantenimiento = @Codigo)
			begin
				set @NewCodigo = (select Max(IdDetalle) from DetalleTB where IdMantenimiento = @Codigo)
				set @NewCodigo = CONVERT(int,@NewCodigo)+1
				if(@NewCodigo  <= 9)
					begin 
						set @CodGenerado= @NewCodigo							
					end
				else if(@NewCodigo >= 10 AND @NewCodigo <= 99)
					begin
						set @CodGenerado= @NewCodigo					
					end
				else if(@NewCodigo >= 100 AND @NewCodigo <= 999)
					begin 
						set @CodGenerado=@NewCodigo
					end
				else
					begin
						set @CodGenerado=@NewCodigo
					end
			end		
		else
			begin
				set @CodGenerado = 1
			end
		return @CodGenerado
	end
go



/*
create table ImpuestoTB[dbo].[RepresentanteTB]
(
	IdImpuesto int identity not null,
	Nombre varchar(40) not null,
	Impuesto decimal(18,2) not null

)
go
*/