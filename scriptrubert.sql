USE [PuntoVentaSysSoftDB]
GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Articulo_Codigo_Alfanumerico]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Articulo_Codigo_Alfanumerico] ()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdArticulo from ArticuloTB)
					begin					
						set @ValorActual = (select MAX(IdArticulo) from ArticuloTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'AT000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'AT00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'AT0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'AT'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'AT0001'
					end
			end
			return @CodGenerado
		end



GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Cliente_Codigo_Alfanumerico]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Cliente_Codigo_Alfanumerico]()  returns varchar(12)
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

GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Compra_Codigo_Alfanumerico]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Compra_Codigo_Alfanumerico] ()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdCompra from CompraTB)
					begin					
						set @ValorActual = (select MAX(IdCompra) from CompraTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'CP000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'CP00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'CP0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'CP'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'CP0001'
					end
			end
			return @CodGenerado
		end



GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Detalle_Generar_Codigo]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Detalle_Generar_Codigo](@Codigo varchar(10))returns int
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



GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Empleado_Codigo_Alfanumerico]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Empleado_Codigo_Alfanumerico]()  returns varchar(12)
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

GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Mantenimiento_Generar_Codigo]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[Fc_Mantenimiento_Generar_Codigo]() returns varchar(10)
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




GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Obtener_Nombre_Detalle]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Obtener_Nombre_Detalle]
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
/****** Object:  UserDefinedFunction [dbo].[Fc_Persona_Codigo_Alfanumerico]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[Fc_Persona_Codigo_Alfanumerico]()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdPersona from PersonaTB)
					begin					
						set @ValorActual = (select MAX(IdPersona) from PersonaTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'PE000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'PE00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'PE0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'PE'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'PE0001'
					end
			end
			return @CodGenerado
		end



GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Proveedor_Codigo_Alfanumerico]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Proveedor_Codigo_Alfanumerico] ()  returns varchar(12)
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



GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Representante_Codigo_Alfanumerico]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Representante_Codigo_Alfanumerico] ()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdRepresentante from RepresentanteTB)
					begin					
						set @ValorActual = (select MAX(IdRepresentante) from RepresentanteTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'RE000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'RE00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'RE0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'RE'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'RE0001'
					end
			end
			return @CodGenerado
		end

GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Serie_Numero_Generado]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Serie_Numero_Generado]() returns varchar(40)
as
	begin
	declare @serie varchar(8), @resultSerie varbinary(2),@numeracion varchar(16),@resulNumeracion varchar(16)
	declare @numero int

	declare @ValorActual varchar(16)

	set @numeracion = (select Max(Numeracion) from ComprobanteTB)
	set @serie = (select Max(Serie) from ComprobanteTB)


	if (LEN(@serie) > 0  and LEN(@numeracion) > 0)
		begin
			set @ValorActual = (select Max(Numeracion) from ComprobanteTB where Serie = @serie)

			if(@ValorActual < 99999999)
				begin
					set @resultSerie = (select Max(Serie) from ComprobanteTB)

					set @numero = CONVERT(INT,@ValorActual) +1

					set @resulNumeracion = '' +replicate ('0',(8 - len(@numero))) + convert(varchar, @numero)
					/*insert into ComprobanteTB(Serie,Numeracion,FechaRegistro) values(@resultSerie,@resulNumeracion,GETDATE())*/
					
				end
			else
				begin
					set @resultSerie = (select Max(Serie) from ComprobanteTB)
					set @resultSerie = @resultSerie+1
					set @resulNumeracion = '00000001'
					/*insert into ComprobanteTB(Serie,Numeracion,FechaRegistro) values(@resultSerie,@resulNumeracion,GETDATE())*/
				end
		end
	else
		begin
			set @resultSerie = CONVERT(VARBINARY(2), 40960)
			set @resulNumeracion = '00000001'
			/*insert into ComprobanteTB(Serie,Numeracion,FechaRegistro) values(@resultSerie,@resulNumeracion,GETDATE())*/
		end
	return  CONVERT(varchar,@resultSerie,2)+'-'+@resulNumeracion
end
 

GO
/****** Object:  Table [dbo].[ArticuloTB]    Script Date: 11/11/2018 07:06:24  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ArticuloTB](
	[IdArticulo] [varchar](12) NOT NULL,
	[Clave] [varchar](45) NOT NULL,
	[ClaveAlterna] [varchar](45) NULL,
	[NombreMarca] [varchar](120) NOT NULL,
	[NombreGenerico] [varchar](120) NULL,
	[Descripcion] [varchar](200) NULL,
	[Categoria] [int] NULL,
	[Marca] [int] NULL,
	[Presentacion] [int] NULL,
	[Modelo] [int] NULL,
	[Estado] [int] NULL CONSTRAINT [DF__ArticuloT__Estad__57A801BA]  DEFAULT ((0)),
	[StockMinimo] [decimal](18, 2) NULL CONSTRAINT [DF__ArticuloT__Stock__67DE6983]  DEFAULT ((0)),
	[StockMaximo] [decimal](18, 2) NULL CONSTRAINT [DF__ArticuloT__Stock__68D28DBC]  DEFAULT ((0)),
	[PrecioCompra] [decimal](18, 2) NULL CONSTRAINT [DF__ArticuloT__Preci__69C6B1F5]  DEFAULT ((0)),
	[PrecioVenta] [decimal](18, 2) NULL CONSTRAINT [DF__ArticuloT__Preci__6ABAD62E]  DEFAULT ((0)),
	[Cantidad] [decimal](18, 2) NULL CONSTRAINT [DF__ArticuloT__Canti__725BF7F6]  DEFAULT ((0)),
	[Lote] [bit] NULL,
 CONSTRAINT [PK__Articulo__F8FF5D5215DED1B3] PRIMARY KEY CLUSTERED 
(
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CiudadTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CiudadTB](
	[IdCiudad] [int] NOT NULL,
	[PaisCodigo] [char](3) NOT NULL DEFAULT (''),
	[Departamento] [varchar](50) NOT NULL DEFAULT (''),
PRIMARY KEY CLUSTERED 
(
	[IdCiudad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ClienteTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ClienteTB](
	[IdCliente] [varchar](12) NOT NULL,
	[TipoDocumento] [int] NOT NULL,
	[NumeroDocumento] [varchar](20) NOT NULL,
	[Apellidos] [varchar](50) NOT NULL,
	[Nombres] [varchar](50) NOT NULL,
	[Sexo] [int] NULL,
	[FechaNacimiento] [date] NULL,
	[Telefono] [varchar](20) NULL,
	[Celular] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[Direccion] [varchar](200) NULL,
	[Estado] [int] NOT NULL,
	[UsuarioRegistro] [varchar](50) NULL,
	[FechaRegistro] [datetime] NULL,
	[UsuarioActualizado] [varchar](50) NULL,
	[FechaActualizado] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompraTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CompraTB](
	[IdCompra] [varchar](12) NOT NULL,
	[Proveedor] [varchar](12) NOT NULL,
	[Representante] [varchar](12) NULL,
	[Comprobante] [int] NULL,
	[Numeracion] [varchar](20) NULL,
	[FechaCompra] [datetime] NOT NULL,
	[SubTotal] [decimal](18, 2) NOT NULL,
	[Gravada] [decimal](18, 2) NOT NULL,
	[Descuento] [decimal](18, 2) NULL,
	[Igv] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComprobanteTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComprobanteTB](
	[Serie] [varbinary](2) NOT NULL,
	[Numeracion] [varchar](16) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Serie] ASC,
	[Numeracion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DetalleCompraTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DetalleCompraTB](
	[IdCompra] [varchar](12) NOT NULL,
	[IdArticulo] [varchar](12) NOT NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
	[PrecioCompra] [decimal](18, 2) NOT NULL,
	[PrecioVenta] [decimal](18, 2) NOT NULL,
	[Importe] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCompra] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DetalleTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DetalleTB](
	[IdDetalle] [int] NOT NULL,
	[IdMantenimiento] [varchar](10) NOT NULL,
	[Nombre] [varchar](60) NOT NULL,
	[Descripcion] [varchar](100) NULL,
	[Estado] [char](1) NOT NULL,
	[UsuarioRegistro] [varchar](15) NOT NULL,
	[FechaRegistro] [datetime] NULL,
 CONSTRAINT [Pk_DetalleTB] PRIMARY KEY CLUSTERED 
(
	[IdDetalle] ASC,
	[IdMantenimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DirectorioTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DirectorioTB](
	[IdDirectorio] [bigint] IDENTITY(1,1) NOT NULL,
	[Atributo] [int] NOT NULL,
	[Valor] [varchar](100) NOT NULL,
	[IdPersona] [varchar](12) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdDirectorio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DistritoTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DistritoTB](
	[IdDistrito] [int] NOT NULL DEFAULT ('0'),
	[Distrito] [varchar](50) NULL DEFAULT (NULL),
	[IdProvincia] [int] NULL DEFAULT (NULL),
PRIMARY KEY CLUSTERED 
(
	[IdDistrito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmpleadoTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmpleadoTB](
	[IdEmpleado] [varchar](12) NOT NULL,
	[TipoDocumento] [int] NOT NULL,
	[NumeroDocumento] [varchar](20) NULL,
	[Apellidos] [varchar](50) NOT NULL,
	[Nombres] [varchar](50) NOT NULL,
	[Sexo] [int] NULL,
	[FechaNacimiento] [date] NULL,
	[Puesto] [int] NOT NULL,
	[Rol] [int] NULL,
	[Estado] [int] NOT NULL,
	[Telefono] [varchar](20) NULL,
	[Celular] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[Direccion] [varchar](200) NULL,
	[Pais] [char](3) NULL,
	[Ciudad] [int] NULL,
	[Provincia] [int] NULL,
	[Distrito] [int] NULL,
	[Usuario] [varchar](100) NULL,
	[Clave] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdEmpleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmpresaTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmpresaTB](
	[IdEmpresa] [int] IDENTITY(1,1) NOT NULL,
	[GiroComercial] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Telefono] [varchar](20) NULL,
	[Celular] [varchar](20) NULL,
	[PaginaWeb] [varchar](200) NULL,
	[Email] [varchar](100) NULL,
	[Domicilio] [varchar](200) NULL,
	[TipoDocumento] [int] NULL,
	[NumeroDocumento] [varchar](20) NULL,
	[RazonSocial] [varchar](100) NULL,
	[NombreComercial] [varchar](100) NULL,
	[Pais] [char](3) NULL,
	[Ciudad] [int] NULL,
	[Provincia] [int] NULL,
	[Distrito] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdEmpresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FacturacionTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FacturacionTB](
	[IdFacturacion] [bigint] IDENTITY(1,1) NOT NULL,
	[IdCliente] [varchar](12) NOT NULL,
	[TipoDocumento] [int] NULL,
	[NumeroDocumento] [varchar](20) NULL,
	[RazonSocial] [varchar](50) NULL,
	[NombreComercial] [varchar](50) NULL,
	[Pais] [char](3) NULL,
	[Ciudad] [int] NULL,
	[Provincia] [int] NULL,
	[Distrito] [int] NULL,
	[Moneda] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdFacturacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HistorialArticuloTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HistorialArticuloTB](
	[IdHistorial] [int] NOT NULL,
	[TipoOperacion] [varchar](25) NULL,
	[IdOperacion] [varchar](12) NULL,
	[IdArticulo] [varchar](12) NULL,
	[FechaRegistro] [date] NULL,
	[Entrada] [int] NULL,
	[Salida] [int] NULL,
	[UsuarioRegistro] [varchar](12) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdHistorial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ImagenTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ImagenTB](
	[IdImagen] [bigint] IDENTITY(1,1) NOT NULL,
	[Imagen] [varbinary](max) NULL,
	[IdRelacionado] [varchar](12) NOT NULL,
	[IdSubRelacion] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdImagen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LoteTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LoteTB](
	[IdLote] [bigint] IDENTITY(1,1) NOT NULL,
	[TipoLote] [bit] NOT NULL,
	[NumeroLote] [varchar](45) NOT NULL,
	[FechaFabricacion] [date] NOT NULL,
	[FechaCaducidad] [date] NOT NULL,
	[ExistenciaInicial] [decimal](18, 2) NOT NULL,
	[ExistenciaActual] [decimal](18, 2) NOT NULL,
	[IdArticulo] [varchar](12) NOT NULL,
	[IdCompra] [varchar](12) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdLote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MantenimientoTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MantenimientoTB](
	[IdMantenimiento] [varchar](10) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Estado] [char](1) NOT NULL,
	[UsuarioRegistro] [varchar](15) NOT NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdMantenimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MenuTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MenuTB](
	[IdMenu] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PaisTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PaisTB](
	[PaisCodigo] [char](3) NOT NULL DEFAULT (''),
	[PaisNombre] [varchar](52) NOT NULL DEFAULT (''),
	[PaisContinente] [varchar](50) NOT NULL DEFAULT ('South America'),
	[PaisRegion] [varchar](26) NOT NULL DEFAULT (''),
	[PaisArea] [float] NOT NULL DEFAULT ('0.00'),
	[PaisCapital] [int] NULL DEFAULT (NULL),
PRIMARY KEY CLUSTERED 
(
	[PaisCodigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PermisoMenusTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermisoMenusTB](
	[IdRol] [int] NOT NULL,
	[IdMenus] [int] NOT NULL,
	[Estado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC,
	[IdMenus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonaTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersonaTB](
	[IdPersona] [varchar](12) NOT NULL,
	[TipoDocumento] [int] NOT NULL,
	[NumeroDocumento] [varchar](20) NOT NULL,
	[ApellidoPaterno] [varchar](50) NOT NULL,
	[ApellidoMaterno] [varchar](50) NOT NULL,
	[PrimerNombre] [varchar](50) NOT NULL,
	[SegundoNombre] [varchar](50) NULL,
	[Sexo] [int] NULL,
	[FechaNacimiento] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProveedorPersonaTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProveedorPersonaTB](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProveedor] [varchar](12) NOT NULL,
	[IdRepresentante] [varchar](12) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProveedorTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProveedorTB](
	[IdProveedor] [varchar](12) NOT NULL,
	[TipoDocumento] [int] NOT NULL,
	[NumeroDocumento] [varchar](20) NOT NULL,
	[RazonSocial] [varchar](100) NOT NULL,
	[NombreComercial] [varchar](100) NULL,
	[Pais] [char](3) NULL,
	[Ciudad] [int] NULL,
	[Provincia] [int] NULL,
	[Distrito] [int] NULL,
	[Ambito] [int] NULL,
	[Estado] [int] NOT NULL,
	[Telefono] [varchar](20) NULL,
	[Celular] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[PaginaWeb] [varchar](100) NULL,
	[Direccion] [varchar](200) NULL,
	[UsuarioRegistro] [varchar](15) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
	[UsuarioActualizado] [varchar](15) NULL,
	[FechaActualizado] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProvinciaTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProvinciaTB](
	[IdProvincia] [int] NOT NULL DEFAULT ('0'),
	[Provincia] [varchar](50) NULL DEFAULT (NULL),
	[IdCiudad] [int] NULL DEFAULT (NULL),
PRIMARY KEY CLUSTERED 
(
	[IdProvincia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RepresentanteTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RepresentanteTB](
	[IdRepresentante] [varchar](12) NOT NULL,
	[TipoDocumento] [int] NOT NULL,
	[NumeroDocumento] [varchar](20) NOT NULL,
	[Apellidos] [varchar](100) NOT NULL,
	[Nombres] [varchar](100) NOT NULL,
	[Telefono] [varchar](20) NULL,
	[Celular] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[Direccion] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdRepresentante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RolTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RolTB](
	[IdRol] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](60) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SubmenuTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubmenuTB](
	[IdSubmenu] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](30) NOT NULL,
	[Estado] [bit] NOT NULL,
	[IdMenu] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdSubmenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VentaTB]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VentaTB](
	[IdVenta] [bigint] IDENTITY(1,1) NOT NULL,
	[Cliente] [varchar](12) NULL,
	[Vendedor] [varchar](12) NOT NULL,
	[Comprobante] [int] NOT NULL,
	[Serie] [varchar](8) NOT NULL,
	[Numeracion] [varchar](16) NOT NULL,
	[FechaVenta] [datetime] NOT NULL,
	[SubTotal] [decimal](18, 2) NOT NULL,
	[Gravada] [decimal](18, 2) NOT NULL,
	[Descuento] [decimal](18, 2) NOT NULL,
	[Igv] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[LoteTB] ADD  DEFAULT (NULL) FOR [IdCompra]
GO
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Articulo]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Crud_Articulo]
@IdArticulo varchar(12),
@Clave varchar(45),
@ClaveAlterna varchar(45),
@NombreMarca varchar(120),
@NombreGenerico varchar(120),
@Descripcion varchar(200),
@Categoria int,
@Marca int,
@Presentacion int,
@StockMinimo decimal(18,2),
@StockMaximo decimal(18,2),
@PrecioCompra decimal(18,2),
@PrecioVenta decimal(18,2),
@Estado int,
@Lote bit,
-------------------------------
@Imagen varbinary(MAX),
-------------------------------
@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				if exists(select * from ArticuloTB where IdArticulo = @IdArticulo)
					begin
						if exists(select * from ArticuloTB where IdArticulo <> @IdArticulo and Clave = @Clave )
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								update ArticuloTB set Clave = @Clave,ClaveAlterna=@ClaveAlterna,
								NombreMarca=UPPER(@NombreMarca),NombreGenerico=UPPER(@NombreGenerico),
								Descripcion=UPPER(@Descripcion),Categoria=@Categoria,Marca=@Marca,Presentacion=@Presentacion,
								StockMinimo=@StockMinimo,StockMaximo=@StockMaximo,PrecioCompra=@PrecioCompra,
								PrecioVenta=@PrecioVenta,Estado=@Estado,Lote=@Lote
								where IdArticulo = @IdArticulo
								commit
								set @Message = 'updated'
							end
						
					end
				else 
					begin
						if exists(select * from ArticuloTB where Clave = @Clave)
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								declare @idGenerado varchar(12)
								set @idGenerado = dbo.Fc_Articulo_Codigo_Alfanumerico()
								insert into ArticuloTB(IdArticulo,Clave,ClaveAlterna,NombreMarca,NombreGenerico,Descripcion,Categoria,Marca,Presentacion,
								StockMinimo,StockMaximo,PrecioCompra,PrecioVenta,Cantidad,Estado,Lote)
								values(@idGenerado,@Clave,@ClaveAlterna,UPPER(@NombreMarca),UPPER(@NombreGenerico),UPPER(@Descripcion),@Categoria,@Marca,@Presentacion,
								@StockMinimo,@StockMinimo,@PrecioCompra,@PrecioVenta,0,@Estado,@Lote)
								
								insert into ImagenTB(Imagen,IdRelacionado)
								values(@Imagen,@idGenerado)
								
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
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Detalle]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_Crud_Detalle]
@IdDetalle int,
@IdMantenimiento varchar(10),
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
								update DetalleTB set Nombre=UPPER(@Nombre),Descripcion=UPPER(@Descripcion),Estado=@Estado
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
								insert into DetalleTB(IdDetalle,IdMantenimiento,Nombre,Descripcion,Estado,UsuarioRegistro,FechaRegistro)
								values(dbo.Fc_Detalle_Generar_Codigo(@IdMantenimiento),@IdMantenimiento,UPPER(@Nombre),UPPER(@Descripcion),@Estado,@UsuarioRegistro,GETDATE())
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
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Directorio]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_Crud_Directorio]
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



GO
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Imagen]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[Sp_Crud_Imagen]
@IdImagen bigint,
@Imagen varbinary(MAX),
@IdRelacionado varchar(12),
@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				if exists(select IdImagen from ImagenTB where IdImagen=@IdImagen and IdRelacionado=@IdRelacionado)
					begin
						update ImagenTB
						set Imagen=@Imagen
						where IdImagen=@IdImagen and IdRelacionado=@IdRelacionado
						commit
						set @Message = 'update'
					end
				else
					begin
						insert into ImagenTB(Imagen,IdRelacionado)
						values(@Imagen,@IdRelacionado)
						commit
						set @Message = 'insert'
					end
		end try
		begin catch
			rollback
			set @Message = 'error'
		end catch
	end



GO
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Mantenimiento]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Crud_Mantenimiento]
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



GO
/****** Object:  StoredProcedure [dbo].[Sp_Crud_MiEmpresa]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_Crud_MiEmpresa]
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


GO
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Persona_Cliente]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Crud_Persona_Cliente]
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
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Proveedor]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Crud_Proveedor]
@IdProveedor varchar(12),
@TipoDocumento int,
@NumeroDocumento varchar(20),
@RazonSocial varchar(100),
@NombreComercial varchar(100),
@Pais char(3),
@Ciudad int,
@Provincia int,
@Distrito int,
@Ambito int,
@Estado int,
@Telefono varchar(20),
@Celular varchar(20),
@Email varchar(100),
@PaginaWeb varchar(100),
@Direccion varchar(200),
@UsuarioRegistro varchar(15),
@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				if exists(select * from ProveedorTB where IdProveedor = @IdProveedor)
					begin
						if exists(select * from ProveedorTB where IdProveedor <> @IdProveedor and NumeroDocumento=@NumeroDocumento)
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								update ProveedorTB
								set TipoDocumento =@TipoDocumento,NumeroDocumento=@NumeroDocumento,RazonSocial=UPPER(@RazonSocial),
								NombreComercial=UPPER(@NombreComercial),Pais=@Pais,Ciudad=@Ciudad,Provincia=@Provincia,Distrito=@Distrito,Ambito=@Ambito,Estado=@Estado,
								Telefono=@Telefono,Celular=@Celular,Email=@Email,PaginaWeb=@PaginaWeb,Direccion=@Direccion,UsuarioActualizado=@UsuarioRegistro,FechaActualizado=GETDATE()
								where IdProveedor = @IdProveedor
								commit 
								set @Message = 'updated'
							end
						
					end
				else
					begin
						if exists(select * from ProveedorTB where NumeroDocumento=@NumeroDocumento)
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								insert into ProveedorTB(IdProveedor,TipoDocumento,NumeroDocumento,RazonSocial,NombreComercial,Pais,Ciudad,Provincia,Distrito,Ambito,Estado,Telefono,Celular,Email,PaginaWeb,Direccion,UsuarioRegistro,FechaRegistro)
								values(dbo.Fc_Proveedor_Codigo_Alfanumerico(),@TipoDocumento,@NumeroDocumento,UPPER(@RazonSocial),UPPER(@NombreComercial),@Pais,@Ciudad,@Provincia,@Distrito,@Ambito,@Estado,@Telefono,@Celular,@Email,@PaginaWeb,@Direccion,@UsuarioRegistro,GETDATE())
																
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
/****** Object:  StoredProcedure [dbo].[Sp_Get_Articulo_By_Id]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Get_Articulo_By_Id]
@Clave varchar(45)
as
	begin
		select IdArticulo,Clave,ClaveAlterna,NombreMarca,NombreGenerico,Descripcion,
		Categoria,dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as CategoriaNombre,
		Marca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as MarcaNombre,
		Presentacion,dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as PresentacionNombre,
		StockMinimo,StockMaximo,PrecioCompra,PrecioVenta,Cantidad,Estado,Lote
		from ArticuloTB
		where Clave=@Clave
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Articulo_By_Id_View]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_Get_Articulo_By_Id_View]
@IdArticulo varchar(12)
as
	begin
		select NombreMarca,NombreGenerico,PrecioVenta,Cantidad
		from ArticuloTB
		where IdArticulo=@IdArticulo
	end



GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Cliente_By_Id]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Get_Cliente_By_Id]
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

GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Detalle_Id]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_Get_Detalle_Id]
@IdMantenimiento varchar(10)
as
	begin
		select IdDetalle,Nombre from DetalleTB where IdMantenimiento = @IdMantenimiento
	end



GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Detalle_IdNombre]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Get_Detalle_IdNombre]
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

GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Directorio_By_Id]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_Get_Directorio_By_Id]
@IdPersona varchar(12)
as
	begin
		select IdDirectorio,Atributo,dbo.Fc_Obtener_Nombre_Detalle(Atributo,'0002')as Nombre,Valor,IdPersona
		 from DirectorioTB
		where IdPersona=@IdPersona
	end



GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Proveedor_By_Id]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Get_Proveedor_By_Id]
@NumeroDocumento varchar(20)
as
	begin
		select IdProveedor,TipoDocumento,NumeroDocumento,RazonSocial,NombreComercial,Pais,Ciudad,Provincia,Distrito,Ambito,Estado,
		Telefono,Celular,Email,PaginaWeb,Direccion
		 from ProveedorTB where NumeroDocumento = @NumeroDocumento
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Insert_Representante]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_Insert_Representante]
@TipoDocumento int,
@NumeroDocumento varchar(20),
@Apellidos varchar(100),
@Nombres varchar(100),
@Telefono varchar(20),
@Celular varchar(20),
@Email varchar(100) ,
@Direccion varchar(200),
@IdProveedor varchar(12),
@Message varchar(20) out
as
	begin
		begin try
			begin transaction
				declare @codRepresentante varchar(12)
				if exists(select * from  RepresentanteTB where NumeroDocumento = @NumeroDocumento)
					begin						
						set @codRepresentante = (select IdRepresentante from RepresentanteTB where NumeroDocumento = @NumeroDocumento)
						if exists(select * from ProveedorPersonaTB where IdProveedor = @IdProveedor and IdRepresentante = @codRepresentante)
							begin
								rollback
								set @Message = 'duplicate'
							end
						else
							begin
								insert into ProveedorPersonaTB(IdProveedor,IdRepresentante)
								values(@IdProveedor,@codRepresentante)
								commit
								set @Message = 'registered'	
							end						
					end
				else
					begin				
						set @codRepresentante = dbo.Fc_Representante_Codigo_Alfanumerico()
						insert into RepresentanteTB(IdRepresentante,TipoDocumento,NumeroDocumento,Apellidos,
						Nombres,Telefono,Celular,Email,Direccion)
						values(@codRepresentante,@TipoDocumento,@NumeroDocumento,@Apellidos,@Nombres,@Telefono,@Celular,@Email,@Direccion)

						insert into ProveedorPersonaTB(IdProveedor,IdRepresentante)
						values(@IdProveedor,@codRepresentante)
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
/****** Object:  StoredProcedure [dbo].[Sp_List_Table_Detalle]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_List_Table_Detalle]
@IdMantenimiento varchar(10),
@Nombre varchar(60)
as
	begin
		select IdDetalle,Nombre,Descripcion,Estado from DetalleTB 
		where (IdMantenimiento = @IdMantenimiento and @Nombre = '') or (IdMantenimiento = @IdMantenimiento and Nombre like @Nombre+'%')
	end



GO
/****** Object:  StoredProcedure [dbo].[Sp_List_Table_Matenimiento]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_List_Table_Matenimiento]
@Nombre varchar(100)
as
	begin
		select IdMantenimiento,Nombre from MantenimientoTB 
		where 
		(Nombre like @Nombre+'%' and IdMantenimiento <> '0001')
		 or (@Nombre = '' and IdMantenimiento <> '0001')
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Articulo]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Articulo]
@search varchar(100)
as
	begin
		select IdArticulo,Clave,NombreMarca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as Presentacion ,dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,Lote,
		Cantidad,PrecioVenta
		from ArticuloTB 
		where (@search = '') 
		or 
		(Clave like @search+'%')
		or
		(NombreMarca like '%'+ @search +'%')
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Ciudad]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Ciudad] 
@PaisCodigo char(3)
as
	begin
		select IdCiudad,Departamento from CiudadTB where PaisCodigo = @PaisCodigo order by Departamento
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Clientes]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Clientes]
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

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Clientes_Venta]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Clientes_Venta]
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

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Compras]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Compras]
as
	
		select ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,c.IdCompra,p.IdProveedor,CAST(c.FechaCompra as Date) as Fecha,p.NumeroDocumento,p.RazonSocial,c.Total
		from CompraTB as c inner join ProveedorTB as p
		on c.Proveedor = p.IdProveedor


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Directorio]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Directorio]
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

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Distrito]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_Listar_Distrito]
@IdProvincia int
as
	begin
		select IdDistrito,Distrito from DistritoTB where IdProvincia = @IdProvincia order by Distrito
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Empleados]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Empleados]
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

GO
/****** Object:  StoredProcedure [dbo].[Sp_listar_Historial]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_listar_Historial]
@search varchar(100)
as
begin
	select * from HistorialArticuloTB
	where (@search = '') 
end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Lote]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Lote]
@search varchar(60)
as
select ROW_NUMBER() over( order by lo.NumeroLote desc) as Filas, lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaFabricacion,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
from LoteTB as lo inner join ArticuloTB as ar
on lo.IdArticulo = ar.IdArticulo
where (@search = '') or (lo.NumeroLote like @search+'%') or (ar.Clave like @search+'%') or (ar.NombreMarca like '%'+@search+'%')

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Pais]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[Sp_Listar_Pais]
as
	begin
		select PaisCodigo,PaisNombre from PaisTB order by PaisNombre
	end



GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Proveedor]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Proveedor]
@search varchar(100)
as
	begin
		select dbo.Fc_Obtener_Nombre_Detalle(TipoDocumento,'0003') as Documento,NumeroDocumento,RazonSocial,NombreComercial,dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
		Telefono,Celular,CAST(FechaRegistro as date) FRegistro
		 from ProveedorTB where (@search = '') or (NumeroDocumento like @search+'%')
		or (
			(NombreComercial LIKE @search+'%')
			or
			(RazonSocial LIKE @search+'%')
		)
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Provincia]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_Listar_Provincia]
@IdCiudad int
as
	begin
		select IdProvincia,Provincia from ProvinciaTB where IdCiudad = @IdCiudad order by Provincia
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Representantes]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_Listar_Representantes]
@Search varchar(55)
as
	select ROW_NUMBER() over( order by re.IdRepresentante desc) as Filas,re.NumeroDocumento,re.Apellidos,re.Nombres,
	re.Telefono,re.Celular
	from RepresentanteTB as re 
	where ( @Search = '')
	or ( re.NumeroDocumento like @Search+'%') 

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Representantes_By_IdProveedor]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_Listar_Representantes_By_IdProveedor]
@IdProveedor varchar(12),
@Search varchar(55)
as
	select ROW_NUMBER() over( order by pp.Id desc) as Filas,re.NumeroDocumento,re.Apellidos,re.Nombres,
	re.Telefono,re.Celular
	from ProveedorTB as pr inner join ProveedorPersonaTB  as pp on pr.IdProveedor = pp.IdProveedor
	inner join RepresentanteTB as re on pp.IdRepresentante = re.IdRepresentante
	where (pr.IdProveedor = @IdProveedor and @Search = '')
	or (pr.IdProveedor = @IdProveedor and re.NumeroDocumento like @Search+'%') 

GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Representante]    Script Date: 11/11/2018 07:06:25  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Update_Representante]
@IdRepresentante varchar(12),
@TipoDocumento int,
@NumeroDocumento varchar(20),
@Apellidos varchar(100),
@Nombres varchar(100),
@Telefono varchar(20),
@Celular varchar(20),
@Email varchar(100) ,
@Direccion varchar(200),
@Message varchar(20) out
as
	begin
		begin try
			begin transaction
			if exists(select * from RepresentanteTB where IdRepresentante = @IdRepresentante)
				begin
					if exists(select * from RepresentanteTB where IdRepresentante <> @IdRepresentante and NumeroDocumento = @NumeroDocumento)
						begin	
							rollback
							set @Message = 'duplicate'
						end
					else
						begin
							update RepresentanteTB set TipoDocumento = @TipoDocumento,NumeroDocumento=@NumeroDocumento,
							Apellidos=@Apellidos,Nombres=@Nombres,Celular=@Celular,Email=@Email,Direccion=@Direccion
							where IdRepresentante = @IdRepresentante
							commit 
							set @Message = 'updated'
						end
				end
				
		end try
		begin catch
			rollback
			set @Message='error'
		end catch
	end

GO
