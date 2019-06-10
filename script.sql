USE [PuntoVentaSysSoftDBDesarrollo]
GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Articulo_Codigo_Alfanumerico]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[Fc_Cliente_Codigo_Alfanumerico]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[Fc_Compra_Codigo_Alfanumerico]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[Fc_Detalle_Generar_Codigo]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[Fc_Empleado_Codigo_Alfanumerico]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[Fc_Mantenimiento_Generar_Codigo]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[Fc_Obtener_Nombre_Detalle]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[Fc_Obtener_Nombre_Impuesto]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[Fc_Obtener_Nombre_Impuesto]
	(
	 @IdImpuesto int
	)
	RETURNS VARCHAR(50)
	AS
	BEGIN
		DECLARE @Result VARCHAR(50)
			BEGIN
				SET @Result = (SELECT Nombre FROM ImpuestoTB WHERE IdImpuesto = @IdImpuesto)	
			END
			RETURN @Result
	END


GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Obtener_Simbolo_Moneda]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[Fc_Obtener_Simbolo_Moneda]
	(
	 @IdMoneda int
	)
	RETURNS VARCHAR(10)
	AS
	BEGIN
		DECLARE @Result VARCHAR(10)
			BEGIN
				SET @Result = (SELECT Simbolo FROM MonedaTB WHERE IdMoneda = @IdMoneda)	
			END
			RETURN @Result
	END


GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Proveedor_Codigo_Alfanumerico]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  UserDefinedFunction [dbo].[Fc_Serie_Numero]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fc_Serie_Numero](@tipo varchar(12)) returns varchar(40)
as
begin
	declare @serie varchar(8), @resultSerie varchar(8),@numeracion varchar(16),@resulNumeracion varchar(16)
	declare @numero int
	declare @ValorActual varchar(16)

	declare @Length int,@Incremental int,@ActualValor varchar(12),@ValorNuevo varchar(12)

	if(@tipo = 'boleta')
		begin
			set @serie = (select Max(serie_b) from ComprobanteTB)
			set @numeracion = (select Max(Numeracion) from ComprobanteTB where serie_b = @serie)

			if (LEN(@serie) > 0  and LEN(@numeracion) > 0)
				begin
					set @ValorActual = @numeracion

					if(@ValorActual < 99999999)
						begin
							set @resultSerie = (select Max(serie_b) from ComprobanteTB)

							set @numero = CONVERT(INT,@ValorActual) +1

							set @resulNumeracion = '' +replicate ('0',(8 - len(@numero))) + convert(varchar, @numero)
							--insert into ComprobanteTB(Serie,Numeracion,FechaRegistro) values(@resultSerie,@resulNumeracion,GETDATE())
					
						end
					else
						begin
							set @serie = (select Max(serie_b) from ComprobanteTB)
							set @Length = LEN(@serie)
							set @ValorNuevo = SUBSTRING(@serie,2,@Length-1)
							set @Incremental = CONVERT(INT,@ValorNuevo) +1
							if(@Incremental <= 9)
								begin
									set @resultSerie  = 'B00'+CONVERT(VARCHAR,@Incremental)
								end
							else if(@Incremental>=10 and @Incremental<=99)
								begin
									set @resultSerie  = 'B0'+CONVERT(VARCHAR,@Incremental)
								end
							else
								begin
									set @resultSerie  = 'B'+CONVERT(VARCHAR,@Incremental)
								end

							set @resulNumeracion = '00000001'
							--insert into ComprobanteTB(,serie_b,FechaRegistro) values(@resultSerie,@resulNumeracion,GETDATE())
						end
				end
			else
				begin
					set @resultSerie = 'B001'
					set @resulNumeracion = '00000001'
					--insert into ComprobanteTB(serie_b,Numeracion,FechaRegistro) values(@resultSerie,@resulNumeracion,GETDATE())
				end

		end

	else if (@tipo = 'factura')
		begin
			set @serie = (select Max(serie_f) from ComprobanteTB)
			set @numeracion = (select Max(Numeracion) from ComprobanteTB where serie_f = @serie)

			if (LEN(@serie) > 0  and LEN(@numeracion) > 0)
				begin
					set @ValorActual = @numeracion

					if(@ValorActual < 99999999)
						begin
							set @resultSerie = (select Max(serie_f) from ComprobanteTB)

							set @numero = CONVERT(INT,@ValorActual) +1

							set @resulNumeracion = '' +replicate ('0',(8 - len(@numero))) + convert(varchar, @numero)
					
						end
					else
						begin
							set @serie = (select Max(serie_f) from ComprobanteTB)
							set @Length = LEN(@serie)
							set @ValorNuevo = SUBSTRING(@serie,2,@Length-1)
							set @Incremental = CONVERT(INT,@ValorNuevo) +1
							if(@Incremental <= 9)
								begin
									set @resultSerie  = 'F00'+CONVERT(VARCHAR,@Incremental)
								end
							else if(@Incremental>=10 and @Incremental<=99)
								begin
									set @resultSerie  = 'F0'+CONVERT(VARCHAR,@Incremental)
								end
							else
								begin
									set @resultSerie  = 'F'+CONVERT(VARCHAR,@Incremental)
								end

							set @resulNumeracion = '00000001'

						end
				end
			else
				begin
					set @resultSerie = 'F001'
					set @resulNumeracion = '00000001'
				end
		end

	else if (@tipo = 'ticket')
		begin
			set @serie = (select Max(serie_t) from ComprobanteTB)
			set @numeracion = (select Max(Numeracion) from ComprobanteTB where serie_t = @serie)

			if (LEN(@serie) > 0  and LEN(@numeracion) > 0)
				begin
					set @ValorActual = @numeracion

					if(@ValorActual < 99999999)
						begin
							set @resultSerie = (select Max(serie_t) from ComprobanteTB)

							set @numero = CONVERT(INT,@ValorActual) +1

							set @resulNumeracion = '' +replicate ('0',(8 - len(@numero))) + convert(varchar, @numero)
					
						end
					else
						begin
							set @serie = (select Max(serie_t) from ComprobanteTB)
							set @Length = LEN(@serie)
							set @ValorNuevo = SUBSTRING(@serie,2,@Length-1)
							set @Incremental = CONVERT(INT,@ValorNuevo) +1
							if(@Incremental <= 9)
								begin
									set @resultSerie  = 'T00'+CONVERT(VARCHAR,@Incremental)
								end
							else if(@Incremental>=10 and @Incremental<=99)
								begin
									set @resultSerie  = 'T0'+CONVERT(VARCHAR,@Incremental)
								end
							else
								begin
									set @resultSerie  = 'T'+CONVERT(VARCHAR,@Incremental)
								end

							set @resulNumeracion = '00000001'

						end
				end
			else
				begin
					set @resultSerie = 'T001'
					set @resulNumeracion = '00000001'
				end
		end

	return  CONVERT(varchar,@resultSerie,2)+'-'+@resulNumeracion

end




GO
/****** Object:  UserDefinedFunction [dbo].[Fc_Venta_Codigo_Alfanumerico]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Fc_Venta_Codigo_Alfanumerico] ()  returns varchar(12)
	as
		begin
		declare @Length int,@Incremental int,@ValorActual varchar(12),@ValorNuevo varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdVenta from VentaTB)
					begin					
						set @ValorActual = (select MAX(IdVenta) from VentaTB)
						set @Length = LEN(@ValorActual)
						set @ValorNuevo = SUBSTRING(@ValorActual,3,@Length-2)
						set @Incremental = CONVERT(INT,@ValorNuevo) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'VT000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'VT00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'VT0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'VT'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'VT0001'
					end
			end
			return @CodGenerado
		end


GO
/****** Object:  UserDefinedFunction [dbo].[Fx_Obtener_Cliente_By_Id]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[Fx_Obtener_Cliente_By_Id]
(
@Cliente varchar(12)
) returns varchar(60)

as
	begin
		declare @datos varchar(60)
		set @datos=	(select Apellidos+' '+Nombres from ClienteTB where IdCliente = @Cliente)
		return @datos
	end




GO
/****** Object:  Table [dbo].[ArticuloTB]    Script Date: 10/06/2019 08:02:04 ******/
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
	[Categoria] [int] NULL,
	[Marca] [int] NULL,
	[Presentacion] [int] NULL,
	[UnidadCompra] [int] NULL,
	[UnidadVenta] [tinyint] NULL,
	[Estado] [int] NULL CONSTRAINT [DF__ArticuloT__Estad__57A801BA]  DEFAULT ((0)),
	[StockMinimo] [decimal](18, 4) NULL CONSTRAINT [DF__ArticuloT__Stock__67DE6983]  DEFAULT ((0)),
	[StockMaximo] [decimal](18, 4) NULL CONSTRAINT [DF__ArticuloT__Stock__68D28DBC]  DEFAULT ((0)),
	[Cantidad] [decimal](18, 4) NOT NULL CONSTRAINT [DF__ArticuloT__Canti__725BF7F6]  DEFAULT ((0)),
	[Impuesto] [int] NULL,
	[PrecioCompra] [decimal](18, 4) NULL CONSTRAINT [DF__ArticuloT__Preci__69C6B1F5]  DEFAULT ((0)),
	[PrecioVentaGeneral] [decimal](18, 4) NULL,
	[PrecioMargenGeneral] [smallint] NULL,
	[PrecioUtilidadGeneral] [decimal](18, 4) NULL,
	[Lote] [bit] NULL,
	[Inventario] [bit] NULL,
	[ValorInventario] [bit] NULL,
	[Imagen] [varchar](max) NULL,
 CONSTRAINT [PK__Articulo__F8FF5D5215DED1B3] PRIMARY KEY CLUSTERED 
(
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CajaTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CajaTB](
	[IdCaja] [int] IDENTITY(1,1) NOT NULL,
	[FechaApertura] [datetime] NULL,
	[FechaCierre] [datetime] NULL,
	[Estado] [bit] NULL,
	[Contado] [decimal](18, 4) NULL,
	[Calculado] [decimal](18, 4) NULL,
	[Diferencia] [decimal](18, 4) NULL,
	[IdUsuario] [varchar](12) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CiudadTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[ClienteTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[CompraTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CompraTB](
	[IdCompra] [varchar](12) NOT NULL,
	[Proveedor] [varchar](12) NOT NULL,
	[Comprobante] [int] NULL,
	[Numeracion] [varchar](20) NULL,
	[TipoMoneda] [int] NULL,
	[FechaCompra] [datetime] NOT NULL,
	[SubTotal] [decimal](18, 4) NOT NULL,
	[Descuento] [decimal](18, 4) NULL,
	[Total] [decimal](18, 4) NOT NULL,
	[Observaciones] [varchar](300) NULL,
	[Notas] [varchar](3000) NULL,
	[TipoCompra] [int] NULL,
	[EstadoCompra] [int] NULL,
 CONSTRAINT [PK__CompraTB__0A5CDB5CD2159C09] PRIMARY KEY CLUSTERED 
(
	[IdCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComprobanteTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComprobanteTB](
	[serie_b] [varchar](8) NULL,
	[serie_f] [varchar](8) NULL,
	[serie_t] [varchar](8) NULL,
	[Numeracion] [varchar](16) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CuentasClienteTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CuentasClienteTB](
	[IdCuentaClientes] [int] IDENTITY(1,1) NOT NULL,
	[IdVenta] [varchar](12) NOT NULL,
	[IdCliente] [varchar](12) NOT NULL,
	[Plazos] [int] NOT NULL,
	[FechaVencimiento] [datetime] NOT NULL,
	[MontoInicial] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCuentaClientes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CuentasHistorialClienteTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CuentasHistorialClienteTB](
	[IdCuentasHistorialCliente] [int] IDENTITY(1,1) NOT NULL,
	[IdCuentaClientes] [int] NOT NULL,
	[Abono] [decimal](18, 4) NOT NULL,
	[FechaAbono] [datetime] NOT NULL,
	[Referencia] [varchar](120) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCuentasHistorialCliente] ASC,
	[IdCuentaClientes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DetalleCompraTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DetalleCompraTB](
	[IdCompra] [varchar](12) NOT NULL,
	[IdArticulo] [varchar](12) NOT NULL,
	[Cantidad] [decimal](18, 4) NOT NULL,
	[PrecioCompra] [decimal](18, 4) NOT NULL,
	[Descuento] [decimal](18, 4) NULL,
	[PrecioVenta1] [decimal](18, 4) NULL,
	[Margen1] [tinyint] NULL,
	[Utilidad1] [decimal](18, 4) NULL,
	[IdImpuesto] [int] NULL,
	[NombreImpuesto] [varchar](12) NULL,
	[ValorImpuesto] [decimal](18, 4) NULL,
	[ImpuestoSumado] [decimal](18, 4) NULL,
	[Importe] [decimal](18, 4) NOT NULL,
	[Descripcion] [varchar](120) NULL,
 CONSTRAINT [PK__DetalleC__35D32E8906C2D139] PRIMARY KEY CLUSTERED 
(
	[IdCompra] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DetalleTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DetalleTB](
	[IdDetalle] [int] NOT NULL,
	[IdMantenimiento] [varchar](10) NOT NULL,
	[IdAuxiliar] [varchar](10) NULL,
	[Nombre] [varchar](60) NOT NULL,
	[Descripcion] [varchar](100) NULL,
	[Estado] [char](1) NOT NULL,
	[UsuarioRegistro] [varchar](15) NOT NULL,
 CONSTRAINT [Pk_DetalleTB] PRIMARY KEY CLUSTERED 
(
	[IdDetalle] ASC,
	[IdMantenimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DetalleVentaTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DetalleVentaTB](
	[IdVenta] [varchar](12) NOT NULL,
	[IdArticulo] [varchar](12) NOT NULL,
	[Cantidad] [decimal](18, 4) NOT NULL,
	[CantidadGranel] [decimal](18, 4) NULL,
	[CostoVenta] [decimal](18, 4) NULL,
	[PrecioVenta] [decimal](18, 4) NOT NULL,
	[Descuento] [decimal](18, 4) NULL,
	[IdImpuesto] [int] NULL,
	[NombreImpuesto] [varchar](12) NULL,
	[ValorImpuesto] [decimal](18, 4) NULL,
	[ImpuestoSumado] [decimal](18, 4) NULL,
	[Importe] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK__DetalleV__839DB56862ECF3B8] PRIMARY KEY CLUSTERED 
(
	[IdVenta] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DirectorioTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[DistritoTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[EmpleadoTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[EmpresaTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[EtiquetaTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EtiquetaTB](
	[idEtiqueta] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](60) NOT NULL,
	[tipo] [int] NOT NULL,
	[predeterminado] [bit] NOT NULL,
	[medida] [varchar](80) NULL,
	[ruta] [varchar](max) NOT NULL,
	[imagen] [image] NULL,
PRIMARY KEY CLUSTERED 
(
	[idEtiqueta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FacturacionTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[HistorialArticuloTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HistorialArticuloTB](
	[IdHistorial] [bigint] IDENTITY(1,1) NOT NULL,
	[IdArticulo] [varchar](12) NULL,
	[FechaRegistro] [datetime] NULL,
	[TipoOperacion] [varchar](60) NULL,
	[Entrada] [decimal](18, 2) NULL,
	[Salida] [decimal](18, 2) NULL,
	[Saldo] [decimal](18, 2) NULL,
	[UsuarioRegistro] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdHistorial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ImagenTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[ImpuestoTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ImpuestoTB](
	[IdImpuesto] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Valor] [decimal](18, 2) NULL,
	[Predeterminado] [bit] NULL,
	[CodigoAlterno] [varchar](50) NULL,
	[Sistema] [bit] NULL,
 CONSTRAINT [PK_ImpuestoTB] PRIMARY KEY CLUSTERED 
(
	[IdImpuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LoteTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LoteTB](
	[IdLote] [bigint] IDENTITY(1,1) NOT NULL,
	[NumeroLote] [varchar](45) NOT NULL,
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
/****** Object:  Table [dbo].[MantenimientoTB]    Script Date: 10/06/2019 08:02:04 ******/
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
	[Validar] [char](10) NULL,
	[UsuarioRegistro] [varchar](15) NOT NULL,
	[FechaRegistro] [datetime] NULL,
 CONSTRAINT [PK__Mantenim__DD1C4417C160352D] PRIMARY KEY CLUSTERED 
(
	[IdMantenimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MenuTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[MonedaTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MonedaTB](
	[IdMoneda] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Abreviado] [varchar](10) NULL,
	[Simbolo] [varchar](10) NOT NULL,
	[TipoCambio] [decimal](18, 4) NOT NULL,
	[Predeterminado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdMoneda] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MovimientoCajaTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MovimientoCajaTB](
	[IdMovimientoCaja] [int] IDENTITY(1,1) NOT NULL,
	[IdCaja] [int] NOT NULL,
	[IdUsuario] [varchar](12) NOT NULL,
	[FechaMovimiento] [datetime] NOT NULL,
	[Comentario] [varchar](120) NULL,
	[Movimiento] [varchar](6) NOT NULL,
	[Entrada] [decimal](18, 4) NULL,
	[Salidas] [decimal](18, 4) NULL,
	[Saldo] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdMovimientoCaja] ASC,
	[IdCaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PagoProveedoresTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PagoProveedoresTB](
	[IdPagoProveedores] [int] IDENTITY(1,1) NOT NULL,
	[MontoTotal] [decimal](18, 4) NULL,
	[MontoActual] [decimal](18, 4) NULL,
	[CuotaActual] [int] NULL,
	[Plazos] [varchar](12) NULL,
	[Dias] [int] NULL,
	[FechaActual] [datetime] NULL,
	[Observacion] [varchar](30) NULL,
	[Estado] [varchar](12) NULL,
	[IdProveedor] [varchar](12) NULL,
	[IdCompra] [varchar](12) NULL,
	[IdEmpleado] [varchar](12) NULL,
 CONSTRAINT [PK__PagoProv__CC4061977D6E6FE2] PRIMARY KEY CLUSTERED 
(
	[IdPagoProveedores] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PaisTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[PermisoMenusTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[PermisoSubMenusTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermisoSubMenusTB](
	[IdRol] [int] NULL,
	[IdMenus] [int] NULL,
	[IdSubMenus] [int] NULL,
	[Estado] [bit] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PlazosTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PlazosTB](
	[IdPlazos] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](15) NULL,
	[Dias] [int] NULL,
	[Estado] [bit] NULL,
	[Predeterminado] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPlazos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProveedorTB]    Script Date: 10/06/2019 08:02:04 ******/
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
PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProvinciaTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[RolTB]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  Table [dbo].[SubmenuTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubmenuTB](
	[IdSubmenu] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](30) NOT NULL,
	[IdMenu] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdSubmenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TicketTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TicketTB](
	[idTicket] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](60) NOT NULL,
	[tipo] [int] NOT NULL,
	[predeterminado] [bit] NOT NULL,
	[ruta] [varchar](max) NOT NULL,
 CONSTRAINT [PK__TicketTB__22B1456F5693C91A] PRIMARY KEY CLUSTERED 
(
	[idTicket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoDocumentoTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TipoDocumentoTB](
	[IdTipoDocumento] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Predeterminado] [bit] NOT NULL,
	[NombreImpresion] [varchar](120) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdTipoDocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoEtiquetaTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TipoEtiquetaTB](
	[idTipoEtiqueta] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idTipoEtiqueta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoTicketTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TipoTicketTB](
	[idTipoTicket] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idTipoTicket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VentaTB]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VentaTB](
	[IdVenta] [varchar](12) NOT NULL,
	[Cliente] [varchar](12) NULL,
	[Vendedor] [varchar](12) NOT NULL,
	[Comprobante] [int] NOT NULL,
	[Moneda] [int] NULL,
	[Serie] [varchar](8) NOT NULL,
	[Numeracion] [varchar](16) NOT NULL,
	[FechaVenta] [datetime] NOT NULL,
	[SubTotal] [decimal](18, 4) NOT NULL,
	[Descuento] [decimal](18, 4) NOT NULL,
	[Total] [decimal](18, 4) NOT NULL,
	[Tipo] [int] NULL,
	[Estado] [int] NULL,
	[Observaciones] [varchar](200) NULL,
	[Efectivo] [decimal](18, 4) NULL,
	[Vuelto] [decimal](18, 4) NULL,
 CONSTRAINT [PK__VentaTB__BC1240BDF6BE598B] PRIMARY KEY CLUSTERED 
(
	[IdVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[LoteTB] ADD  DEFAULT (NULL) FOR [IdCompra]
GO
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Detalle]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Crud_Detalle]
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


GO
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Directorio]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Mantenimiento]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Crud_MiEmpresa]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Crud_Persona_Cliente]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Generar_Listardo_CodBar]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Generar_Listardo_CodBar] 
@UnidadVenta tinyint,
@Categoria int
as
	begin
		SELECT Clave,ClaveAlterna,NombreMarca,UnidadVenta,Categoria
         FROM ArticuloTB
		 WHERE (@UnidadVenta = 0 and @Categoria = 0) 
		 or 
		 (UnidadVenta = @UnidadVenta and @Categoria = 0) 
		 or
		 (UnidadVenta = @UnidadVenta and Categoria = @Categoria) 
		 or
		 (@UnidadVenta = 0 and Categoria = @Categoria) 
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Articulo_By_Id]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Get_Articulo_By_Id]
@Clave varchar(45)
as
	begin
		select IdArticulo,Clave,ClaveAlterna,NombreMarca,NombreGenerico,
		Categoria,dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as CategoriaNombre,
		Marca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as MarcaNombre,
		Presentacion,dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as PresentacionNombre,
		UnidadCompra,dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		UnidadVenta,
		StockMinimo,StockMaximo,PrecioCompra,PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,
		Estado,Lote,Inventario,ValorInventario,Imagen,
		Impuesto,dbo.Fc_Obtener_Nombre_Impuesto(Impuesto) as ImpuestoNombre
		from ArticuloTB
		where Clave=@Clave
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Cliente_By_Id]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Get_CuentasCliente_By_Id]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_Get_CuentasCliente_By_Id]
@IdVenta VARCHAR(12)
as
SELECT c.IdCuentaClientes,c.IdCliente,p.Nombre,c.FechaVencimiento,MontoInicial 
FROM CuentasClienteTB as c inner join PlazosTB as p
on c.Plazos = p.IdPlazos
WHERE c.IdVenta = @IdVenta


GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Detalle_Id]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Get_Detalle_IdNombre]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Get_Directorio_By_Id]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Get_Proveedor_By_Id]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_List_Table_Detalle]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_List_Table_Detalle]
@IdMantenimiento varchar(10),
@Nombre varchar(60)
as
	begin
		select IdDetalle,IdAuxiliar,Nombre,Descripcion,Estado from DetalleTB 
		where (IdMantenimiento = @IdMantenimiento and @Nombre = '') or (IdMantenimiento = @IdMantenimiento and Nombre like @Nombre+'%')
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_List_Table_Matenimiento]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_List_Table_Matenimiento]
@Nombre varchar(100)
as
	begin
		select IdMantenimiento,Nombre,Validar from MantenimientoTB 
		where 
		(Nombre like @Nombre+'%' and Estado <> '0')
		 or (@Nombre = '' and Estado <> '0')
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Lista_Movimiento_Caja_ById]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Lista_Movimiento_Caja_ById]
@IdCaja int
as
	begin
		select m.FechaMovimiento,m.Comentario,m.Movimiento,m.Entrada,m.Salidas
		 from MovimientoCajaTB as m where IdCaja = @IdCaja order by m.FechaMovimiento asc
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Articulo]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Articulo]
@option tinyint,
@search varchar(100),
@categoria int
as
	begin	
		if(@option = 0)
			begin
				select IdArticulo,Clave,NombreMarca,
				dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
				Cantidad,
				PrecioVentaGeneral,
			    dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
				UnidadVenta,
				dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
				dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
				Imagen	
				from ArticuloTB 
				where Categoria=@categoria	
			end
		else if(@option = 1)
			begin
				select IdArticulo,Clave,NombreMarca,
				dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
				Cantidad,
				PrecioVentaGeneral,
				dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
				UnidadVenta,
				dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
				dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
				Imagen	
				from ArticuloTB 
				where	
					@search = ''  
					or 
					(@search <> ''  and NombreMarca like @search +'%')			
			end		
		else if(@option = 2)
			begin
				select IdArticulo,Clave,NombreMarca,
				dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
				Cantidad,
				PrecioVentaGeneral,
				dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
				UnidadVenta,
				dbo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
				dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
				Imagen	
				from ArticuloTB 
				where	
					@search = ''  
					or 
					(@search <> '' and Clave = @search )
					or
					(@search <> '' and ClaveAlterna = @search)						
			end	
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Articulo_By_Search]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Articulo_By_Search] 
@search varchar(60)
as
	begin
		select IdArticulo,Clave,NombreMarca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		dbo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as Presentacion ,
		Cantidad,PrecioCompra,PrecioVentaGeneral,
		UnidadVenta,Lote,Inventario,Impuesto,ValorInventario
		from ArticuloTB 
		where Clave = @search
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Articulo_Lista_View]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Articulo_Lista_View]
@search varchar(100)
as
	begin
		select IdArticulo,Clave,NombreMarca,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		Cantidad,PrecioCompra,
		PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,
		UnidadVenta,Inventario,Impuesto,Lote,ValorInventario
		from ArticuloTB 
		where (@search = '') 
		or 
		(@search <> '' and Clave = @search)
		or
		(@search <> '' and ClaveAlterna = @search)
		or
		(@search <> '' and NombreMarca like @search +'%')
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Ciudad]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Clientes]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Clientes_Venta]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Compras]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Compras]
@Opcion bigint,
@Search varchar(100),
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@EstadoCompra int
as
	if(@Opcion = 0)
		begin
			select ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,c.IdCompra,p.IdProveedor,
			c.FechaCompra as Fecha,c.Numeracion,
			p.NumeroDocumento,p.RazonSocial,
			dbo.Fc_Obtener_Nombre_Detalle(c.TipoCompra,'0015') Tipo,
			dbo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') Estado,
			dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total
			from CompraTB as c inner join ProveedorTB as p
			on c.Proveedor = p.IdProveedor
			where (@Search = '')
			or (c.Numeracion like @Search+'%') 
			or (p.NumeroDocumento like @Search+'%') 
			or (p.RazonSocial like '%'+@Search+'%')
		end

	else if(@Opcion = 1)
		begin
			select ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,c.IdCompra,p.IdProveedor,
			c.FechaCompra as Fecha,c.Numeracion,
			p.NumeroDocumento,p.RazonSocial,
			dbo.Fc_Obtener_Nombre_Detalle(c.TipoCompra,'0015') Tipo,
			dbo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') Estado,
			dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total
			from CompraTB as c inner join ProveedorTB as p
			on c.Proveedor = p.IdProveedor
			where (CAST(c.FechaCompra as Date) BETWEEN @FechaInicial and @FechaFinal)
		end
	else if(@Opcion = 2)
		begin
			select ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,c.IdCompra,p.IdProveedor,
			c.FechaCompra as Fecha,c.Numeracion,
			p.NumeroDocumento,p.RazonSocial,
			dbo.Fc_Obtener_Nombre_Detalle(c.TipoCompra,'0015') Tipo,
			dbo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') Estado,
			dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total
			from CompraTB as c inner join ProveedorTB as p
			on c.Proveedor = p.IdProveedor
			where (CAST(c.FechaCompra as Date) BETWEEN @FechaInicial and @FechaFinal) and c.EstadoCompra = @EstadoCompra
		end
		


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_CuentasHistorial_By_IdCuenta]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_Listar_CuentasHistorial_By_IdCuenta]
@IdCuentaClientes int
as
	select IdCuentasHistorialCliente,FechaAbono,Abono,Referencia from CuentasHistorialClienteTB where IdCuentaClientes = @IdCuentaClientes


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Detalle_Compra]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_Listar_Detalle_Compra]
@IdCompra varchar(12)
as
select 
a.Clave,a.NombreMarca,d.Cantidad,a.UnidadVenta,dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra ,d.PrecioCompra,d.Descuento,d.IdImpuesto,d.ValorImpuesto,d.ImpuestoSumado,d.Importe
from DetalleCompraTB as d inner join ArticuloTB as a
on d.IdArticulo = a.IdArticulo
where d.IdCompra = @IdCompra


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Directorio]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Distrito]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Empleados]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Etiquetas_By_Type]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Sp_Listar_Etiquetas_By_Type]
@type int
as
	begin
		select et.idEtiqueta,et.nombre,td.nombre as nombretipo,et.predeterminado,et.medida,et.ruta,et.imagen 
		from EtiquetaTB as et inner join TipoEtiquetaTB as td on et.tipo = td.idTipoEtiqueta
		where (@type = 0) or (et.tipo = @type)
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_listar_Historial_Articulo]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_listar_Historial_Articulo]
@IdArticulo varchar(12)
as
begin
	select ROW_NUMBER() over( order by IdHistorial desc) as Filas,FechaRegistro,TipoOperacion,Entrada,Salida,Saldo,UsuarioRegistro 
	from HistorialArticuloTB
	where (IdArticulo = @IdArticulo) 
end





GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Historial_Pagos]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Historial_Pagos]
@IdCompra varchar(12)
as
select IdPagoProveedores, MontoTotal, MontoActual, CuotaActual, Plazos, Dias, FechaActual, Observacion, Estado, IdProveedor, IdCompra, IdEmpleado from PagoProveedoresTB where IdCompra = @IdCompra
GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Impuestos]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Impuestos]
as
begin
select IdImpuesto,Nombre,Valor,Predeterminado,CodigoAlterno,Sistema from [dbo].[ImpuestoTB]
end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Inventario_Articulos]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Inventario_Articulos]
as
	select
	IdArticulo,Clave,NombreMarca,PrecioCompra,
	Cantidad,
	dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
	dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
	(PrecioCompra*Cantidad) as Total 
	from ArticuloTB 
	where Inventario = 1 order by Total desc


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Lote]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Lote]
@opcion bigint,
@search varchar(60)
as
if(@opcion = 0)
	begin
		select ROW_NUMBER() over( order by lo.IdLote desc) as Filas, lo.IdLote,lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
		from LoteTB as lo inner join ArticuloTB as ar
		on lo.IdArticulo = ar.IdArticulo
		where (@search = '')
		 or (lo.NumeroLote like @search+'%') 
		 or (ar.Clave like @search+'%') 
		 or (ar.NombreMarca like '%'+@search+'%')
	end
else if(@opcion = 1)
	
	begin
		select ROW_NUMBER() over( order by lo.IdLote desc) as Filas, lo.IdLote,lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
		from LoteTB as lo inner join ArticuloTB as ar
		on lo.IdArticulo = ar.IdArticulo
		where GETDATE() <= lo.FechaCaducidad and DATEDIFF(day, GETDATE(), lo.FechaCaducidad)<=15 order by lo.FechaCaducidad asc 
	end
else if(@opcion = 2)
	begin
		select ROW_NUMBER() over( order by lo.IdLote desc) as Filas, lo.IdLote,lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
		from LoteTB as lo inner join ArticuloTB as ar
		on lo.IdArticulo = ar.IdArticulo
		where lo.FechaCaducidad <= CAST(GETDATE() AS DATE) order by lo.FechaCaducidad desc
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Monedas]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_Listar_Monedas]
as
	begin
		select IdMoneda,Nombre,Abreviado,Simbolo,TipoCambio,Predeterminado from MonedaTB
	end



GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Pais]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Proveedor]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Proveedor]
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


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Provincia]    Script Date: 10/06/2019 08:02:04 ******/
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
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Utilidad]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Listar_Utilidad]
@option tinyint,
@fechaInicial Date,
@fechaFinal Date,
@busqueda varchar(120)
--@inventario bit
as
	begin
		if(@option = 1)
			begin
				select dv.IdArticulo, a.Clave, a.NombreMarca, sum(dv.Cantidad) as Cantidad, sum(dv.CantidadGranel) as CantidadGranel, dv.CostoVenta, dv.PrecioVenta, sum(dv.CostoVenta * dv.Cantidad) as CostoTotal, sum(dv.PrecioVenta * dv.Cantidad) as PrecioTotal, sum(dv.Importe)as Importe, (sum(dv.PrecioVenta * dv.Cantidad) - sum(dv.CostoVenta * dv.Cantidad) ) as Utilidad, a.ValorInventario, dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra, m.Simbolo from DetalleVentaTB as dv
				inner join ArticuloTB as a on dv.IdArticulo = a.IdArticulo 
				inner join VentaTB as v on v.IdVenta = dv.IdVenta
				inner join MonedaTB as m on m.IdMoneda = v.Moneda
				where  cast(v.FechaVenta as date)  between @fechaInicial and @fechaFinal
				group by dv.IdArticulo, a.Clave, a.NombreMarca, dv.CostoVenta, dv.PrecioVenta, a.ValorInventario, a.UnidadCompra, m.Simbolo
			end
		else if(@option = 2)
			begin
				select dv.IdArticulo, a.Clave, a.NombreMarca, sum(dv.Cantidad) as Cantidad, sum(dv.CantidadGranel) as CantidadGranel, dv.CostoVenta, dv.PrecioVenta, sum(dv.CostoVenta * dv.Cantidad) as CostoTotal, sum(dv.PrecioVenta * dv.Cantidad) as PrecioTotal, sum(dv.Importe)as Importe, (sum(dv.PrecioVenta * dv.Cantidad) - sum(dv.CostoVenta * dv.Cantidad) ) as Utilidad , a.ValorInventario, dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra, m.Simbolo from DetalleVentaTB as dv
				inner join ArticuloTB as a on dv.IdArticulo = a.IdArticulo 
				inner join VentaTB as v on v.IdVenta = dv.IdVenta
				inner join MonedaTB as m on m.IdMoneda = v.Moneda
				where ( cast(v.FechaVenta as date)  between @fechaInicial and @fechaFinal ) and (a.Clave like @busqueda+'%' or a.NombreMarca like @busqueda+'%')				
				group by dv.IdArticulo, a.Clave, a.NombreMarca, dv.CostoVenta, dv.PrecioVenta, a.ValorInventario, a.UnidadCompra, m.Simbolo
			end
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Ventas]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_Listar_Ventas]
@opcion smallint,
@search varchar(100),
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@Comprobante int,
@Estado int,
@Vendedor varchar(12)
as
if(@opcion = 1)
	begin
		select ROW_NUMBER() over( order by v.IdVenta desc) as Filas ,
		IdVenta,
		v.FechaVenta,
		c.Apellidos + ' '+c.Nombres as Cliente,
		td.Nombre as Comprobante,
		v.Serie,v.Numeracion,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Simbolo,
		v.Total,
		v.Observaciones
		from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as td on v.Comprobante = IdTipoDocumento
		inner join MonedaTB as m on v.Moneda = m.IdMoneda
		where 
		(Vendedor = @Vendedor and @search = '' and CAST(v.FechaVenta as date) = CAST(GETDATE() as date) )
		OR (Vendedor = @Vendedor and @search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE @search+'%' )
		OR (
			(Vendedor = @Vendedor and @search <> '' AND CONCAT(c.Apellidos,'',c.Nombres) LIKE @search+'%')
			OR
			(Vendedor = @Vendedor and @search <> '' AND CONCAT(c.Nombres,' ',c.Apellidos) LIKE @search+'%')
		)
	end
else
	begin
		select ROW_NUMBER() over( order by v.IdVenta desc) as Filas ,
		IdVenta,
		v.FechaVenta,
		c.Apellidos + ' '+c.Nombres as Cliente,
		td.Nombre as Comprobante,
		v.Serie,v.Numeracion,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Simbolo,
		v.Total,
		v.Observaciones
		from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as td on v.Comprobante = td.IdTipoDocumento
		inner join MonedaTB as m on v.Moneda = m.IdMoneda
		where 
		(Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0 AND @Estado = 0
		)
		OR
		(Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante AND v.Estado = @Estado
		)
		OR
		(Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @Comprobante  AND @Estado = 0
		)
		OR
		(Vendedor = @Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @Comprobante = 0  AND v.Estado = @Estado
		)
	end


GO
/****** Object:  StoredProcedure [dbo].[Sp_Listar_Ventas_Detalle_By_Id]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Listar_Ventas_Detalle_By_Id] 
@IdVenta varchar(12)
as
	select /*ROW_NUMBER() over( order by d.IdArticulo desc) as Filas ,*/
	d.IdArticulo,a.Clave,a.NombreMarca,a.Inventario,a.ValorInventario,
	dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra,
	d.IdImpuesto,
	d.Cantidad,d.CantidadGranel,d.PrecioVenta,
	d.Descuento,d.ValorImpuesto,
	d.ImpuestoSumado,d.Importe
	from DetalleVentaTB as d inner join ArticuloTB as a on d.IdArticulo = a.IdArticulo
	where d.IdVenta = @IdVenta

GO
/****** Object:  StoredProcedure [dbo].[Sp_ListarCajasAperturadas]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_ListarCajasAperturadas]
@FechaInicial varchar(30),
@FechaFinal varchar(30)
as
	begin
		select a.IdCaja,a.FechaApertura,a.FechaCierre,a.Estado,a.Contado,a.Calculado,a.Diferencia,e.Apellidos,e.Nombres 
		from CajaTB as a inner join EmpleadoTB as e
		on a.IdUsuario = e.IdEmpleado
		where 
		(@FechaInicial = '' and @FechaFinal = '' and a.FechaApertura is not null)
		or
		(cast(a.FechaRegistro as date) between @FechaInicial and @FechaFinal and a.FechaApertura is not null)
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Obtener_Compra_ById]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Obtener_Compra_ById]
@IdCompra varchar(12)
as
	select c.FechaCompra as Fecha, c.Comprobante, c.Numeracion,
	dbo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,
	dbo.Fc_Obtener_Nombre_Detalle(c.TipoCompra,'0015') as Tipo,
	dbo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') as Estado,
	c.Total,c.Observaciones,c.Notas,td.Nombre 
	from CompraTB as c inner join TipoDocumentoTB as td on c.Comprobante=td.IdTipoDocumento 
	where c.IdCompra = @IdCompra

GO
/****** Object:  StoredProcedure [dbo].[Sp_Obtener_Venta_ById]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_Obtener_Venta_ById]
@idVenta varchar(12)
as
	begin
		select  v.FechaVenta,c.Apellidos,c.Nombres,t.Nombre as Comprobante,t.NombreImpresion,
		v.Serie,v.Numeracion,v.Observaciones,
		dbo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		dbo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Simbolo,v.Efectivo,v.Vuelto,v.Total
        from VentaTB as v inner join MonedaTB as m on v.Moneda = m.IdMoneda
		inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as t on v.Comprobante = t.IdTipoDocumento
        where v.IdVenta = @idVenta
	end

GO
/****** Object:  StoredProcedure [dbo].[Sp_Reporte_General_Ventas]    Script Date: 10/06/2019 08:02:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_Reporte_General_Ventas] 
@FechaInicial varchar(20),
@FechaFinal varchar(20),
@TipoDocumento int
as
select td.Nombre,cast(v.FechaVenta as date) as FechaVenta,c.Apellidos,c.Nombres,dbo.Fc_Obtener_Simbolo_Moneda(v.Moneda) as Simbolo,v.Total 
from VentaTB as v inner join TipoDocumentoTB as td on v.Comprobante = td.IdTipoDocumento
inner join ClienteTB as c on v.Cliente = c.IdCliente
where
( CAST(FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND @TipoDocumento = 0)
or
( CAST(FechaVenta AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND v.Comprobante = @TipoDocumento)
order by v.FechaVenta desc


GO
