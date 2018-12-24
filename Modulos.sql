use PuntoVentaSysSoftDB
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

alter procedure Sp_Listar_Empleados
@search varchar(55)
as
select ROW_NUMBER() over( order by IdEmpleado desc) as Filas,IdEmpleado,
NumeroDocumento,Apellidos,Nombres,Telefono,Celular,dbo.Fc_Obtener_Nombre_Detalle(Puesto,'0012') as Puesto,
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

create table RolTB
(
	IdRol int identity(1,1) not null,
	Nombre varchar(60) not null,
	primary key(IdRol)
)
go

SELECT * FROM RolTB
GO


--administrador
----
--caja
-----
--
--
--
--
--

create table PermisoMenusTB(
	IdRol int not null,
	IdMenus int not null,
	Estado bit not null
	primary key(IdRol,IdMenus)

)
go

select * from PermisoMenusTB
go

select m.IdMenu,m.Nombre,pm.Estado from 
PermisoMenusTB as pm inner join RolTB as r 
on pm.IdRol = r.IdRol
inner join MenuTB as m 
on pm.IdMenus = m.IdMenu
where pm.IdRol = 2 
go

insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(1,1,1)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(1,2,1)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(1,3,1)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(1,4,1)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(1,5,1)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(1,6,1)
go

insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(2,1,1)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(2,2,1)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(2,3,0)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(2,4,0)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(2,5,0)
go
insert into PermisoMenusTB(IdRol,IdMenus,Estado)values(2,6,0)
go

create table MenuTB
(
	IdMenu int identity not null,
	Nombre varchar(30) not null,
	primary key(IdMenu)
)
go

insert into MenuTB(Nombre) values('INICIO',0)
go
insert into MenuTB(Nombre) values('OPERACIONES',0)
go
insert into MenuTB(Nombre) values('CONSULTAS',0)
go
insert into MenuTB(Nombre) values('REPORTES',0)
go
insert into MenuTB(Nombre) values('GRÁFICOS',0)
go
insert into MenuTB(Nombre) values('CONFIGURACIÓN',0)
go

SELECT * FROM MenuTB
GO
SELECT * FROM SubmenuTB
GO

create table SubmenuTB
(
	IdSubmenu int identity not null,
	Nombre varchar(30) not null,
	Estado bit not null,
	IdMenu int not null,
	primary key(IdSubmenu)
)
go

SELECT IdSubmenu,Nombre,Estado FROM SubmenuTB where IdMenu = 
GO

insert into SubmenuTB(Nombre,Estado,IdMenu) values('MI EMPRESA',0,6)
go
insert into SubmenuTB(Nombre,Estado,IdMenu) values('TABLAS BÁSICAS',0,6)
go
insert into SubmenuTB(Nombre,Estado,IdMenu) values('ROLES',0,6)
go
insert into SubmenuTB(Nombre,Estado,IdMenu) values('EMPLEADOS',0,6)
go
