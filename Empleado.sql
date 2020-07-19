use PuntoVentaSysSoftDBDesarrollo
go


create table EmpleadoTB
(
	IdEmpleado varchar(12) not null,
	TipoDocumento int not null,
	NumeroDocumento varchar(20),
	Apellidos varchar(50) not null,
	Nombres varchar(50) not null,
	Sexo int null,
	FechaNacimiento date,
	Puesto int not null,
	Rol int null,
	Estado int not null,
	Telefono varchar(20) null,
	Celular varchar(20) null,
	Email varchar(100) null,
	Direccion varchar(200) null,
	Pais char(3) null,
	Ciudad int null,
	Provincia int null,
	Distrito int null,
	Usuario varchar(100) null,
	Clave varchar(100) null,
	primary key(IdEmpleado) 
)
go

SELECT * FROM EmpleadoTB
GO

alter procedure Sp_Listar_Empleados ''
@search varchar(55)
as
select ROW_NUMBER() over( order by IdEmpleado desc) as Filas,IdEmpleado,
NumeroDocumento,Apellidos,Nombres,Telefono,Celular,
dbo.Fc_Obtener_Nombre_Detalle(Puesto,'0012') as Puesto,
dbo.Fc_Obtener_Nombre_Rol(Rol) as Rol,
dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado
 from EmpleadoTB 
where (@search = '')  or (NumeroDocumento like @search+'%')
or (
			(Apellidos LIKE @search+'%')
			or
			(Nombres LIKE @search+'%')
			or
			(CONCAT(Apellidos,' ',Nombres) LIKE @search+'%')
		)
go 


create function Fc_Empleado_Codigo_Alfanumerico()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdEmpleado from EmpleadoTB)
					begin					
						set @ValorActual = (select MAX(IdEmpleado) from EmpleadoTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'EM000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'EM00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'EM0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'EM'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'EM0001'
					end
			end
			return @CodGenerado
		end
go

alter function [dbo].Fc_Obtener_Datos_Empleado
(
@IdEmpleado varchar(12)
) returns varchar(100)

as
	begin
		declare @datos varchar(100)
		set @datos=	(select Apellidos+' '+Nombres from EmpleadoTB where IdEmpleado = @IdEmpleado)
		return @datos
	end
go


create procedure Sp_Validar_Ingreso
@usuario varchar(100),
@clave varchar(100)
as
SELECT IdEmpleado,Apellidos,Nombres,dbo.Fc_Obtener_Nombre_Rol(Rol) as RolName,Estado,Rol FROM EmpleadoTB
                WHERE Usuario = @usuario and Clave = @clave and Estado = 1
go

--administrador
----
--caja
-----
--


create table RolTB
(
	IdRol int identity(1,1) not null,
	Nombre varchar(60) not null,
	Sistema bit,
	primary key(IdRol)
)
go


create table MenuTB
(
	IdMenu int identity not null,
	Nombre varchar(30) not null,
	primary key(IdMenu)
)
go

create table SubmenuTB
(
	IdSubmenu int identity not null,
	Nombre varchar(30) not null,
	IdMenu int not null,
	primary key(IdSubmenu)
)
go

create table PrivilegiosTB(
	IdPrivilegio int identity not null,
	IdSubmenu int,
	Nombre varchar(120)
	primary key(IdPrivilegio)
)
go


create table PermisoMenusTB(
	IdRol int not null,
	IdMenus int not null,
	Estado bit not null
	primary key(IdRol,IdMenus)
)
go

create table PermisoSubMenusTB(
	IdRol int,
	IdMenus int,
	IdSubMenus int,
	Estado bit not null
)
go

create table PermisoPrivilegiosTB(
	IdRol int,
	IdPrivilegio int,
	Estado bit,
	primary key(IdRol,IdPrivilegio)
)
go

select * from EmpleadoTB
go

/**/
select * from RolTB
go
select * from MenuTB
go
select * from SubmenuTB
go
select * from PrivilegiosTB
go

update PrivilegiosTB set IdPrivilegio = IdPrivilegio+1
go
/**/
select * from PermisoMenusTB
go
select * from PermisoSubMenusTB
go
select * from PermisoPrivilegiosTB
go

update PermisoPrivilegiosTB set IdPrivilegio =IdPrivilegio+1 where IdRol = 3
go

truncate table RolTB
truncate table MenuTB
truncate table SubmenuTB
truncate table PrivilegiosTB

truncate table PermisoMenusTB
truncate table PermisoSubMenusTB
truncate table PermisoPrivilegiosTB
/*
	administrador
		--inicio
		--operaciones
		--consultas
		--reportes
		--graficos
		--configuracion
*/

/*
		inicio
		operaciones
			--ventas
			--compras
			--articulos
			--clientes
			--proveedores
			--lotes
			--inventario inicial
		consultas
			--ventas
			--compras
			--directorio
			--articulos
			--inventario

*/


select m.IdMenu,m.Nombre,pm.Estado from 
PermisoMenusTB as pm inner join RolTB as r 
on pm.IdRol = r.IdRol
inner join MenuTB as m 
on pm.IdMenus = m.IdMenu
where pm.IdRol = 1
go

select sm.IdSubmenu,sm.Nombre,psm.Estado from PermisoSubMenusTB as psm inner join RolTB as r 
on psm.IdRol = r.IdRol
inner join SubmenuTB as sm
on psm.IdSubMenus = sm.IdSubmenu
where psm.IdRol = 1 and psm.IdMenus = 2
go

select pp.IdPrivilegio,p.Nombre,pp.Estado 
from PermisosPrivilegiosTB as pp inner join PrivilegiosTB as p on pp.IdPrivilegio = p.IdPrivilegio
where pp.IdRol = 1 and p.IdSubmenu = 1
go

print dbo.Fc_Rol_Generar_Codigo()
go

PRINT DBO.Fc_Obtener_Nombre_Rol(1)
GO

create function Fc_Obtener_Nombre_Rol
	(
	@IdRol int
	)
	RETURNS VARCHAR(60)
	AS
	BEGIN
		DECLARE @Result VARCHAR(60)
			BEGIN
				SET @Result = (SELECT Nombre FROM RolTB WHERE IdRol=@IdRol)	
			END
			RETURN @Result
	END

go
create function Fc_Rol_Generar_Codigo ()returns int
as
	begin 
		declare @NewCodigo int,@CodGenerado int
		if exists(select * from RolTB)
			begin
				set @NewCodigo = (select Max(IdRol) from RolTB)				
				set @CodGenerado=@NewCodigo+1					
			end		
		else
			begin
				set @CodGenerado = 1
			end
		return @CodGenerado
	end
go


