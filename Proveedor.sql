USE PuntoVentaSysSoftDB
go

truncate table ProveedorTB
go

select * from ProveedorTB
go

/*
se quito dos campos UsuarioActualizado,FechaActualizado

*/
--proveedor tablas
create table ProveedorTB(
	IdProveedor varchar(12) not null primary key,
	TipoDocumento int not null,
	NumeroDocumento varchar(20) not null,
	RazonSocial varchar(100) not null,
	NombreComercial varchar(100) null,
	Pais char(3) null,
	Ciudad int null,
	Provincia int null,
	Distrito int null,
	Ambito int null,
	Estado int not null,
	Telefono varchar(20) null,
	Celular varchar(20) null,
	Email varchar(100) null,
	PaginaWeb varchar(100) null,
	Direccion varchar(200) null,
	UsuarioRegistro varchar(15) not null,
	FechaRegistro datetime not null
	--UsuarioActualizado varchar(15) null,
	--FechaActualizado datetime null
)
go

alter table ProveedorTB
add Ambito int
go

select * from CompraTB where Proveedor = 'PR0001'


alter procedure Sp_Listar_Proveedor
@search varchar(100)
as
	begin
		select IdProveedor,dbo.Fc_Obtener_Nombre_Detalle(TipoDocumento,'0003') as Documento,NumeroDocumento,RazonSocial,NombreComercial,dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
		Telefono,Celular,FechaRegistro as FRegistro
		 from ProveedorTB where (@search = '') or (NumeroDocumento like @search+'%')
		or (
			(NombreComercial LIKE @search+'%')
			or
			(RazonSocial LIKE @search+'%')
		)
	end
go

alter procedure Sp_Get_Proveedor_By_Id
@NumeroDocumento varchar(20)
as
	begin
		select IdProveedor,TipoDocumento,NumeroDocumento,RazonSocial,NombreComercial,Pais,Ciudad,Provincia,Distrito,Ambito,Estado,
		Telefono,Celular,Email,PaginaWeb,Direccion
		 from ProveedorTB where NumeroDocumento = @NumeroDocumento
	end
go


create function Fc_Proveedor_Codigo_Alfanumerico ()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdProveedor from ProveedorTB)
					begin					
						set @ValorActual = (select MAX(IdProveedor) from ProveedorTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'PR000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'PR00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'PR0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'PR'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'PR0001'
					end
			end
			return @CodGenerado
		end
go
