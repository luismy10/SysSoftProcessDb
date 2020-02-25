use [PuntoVentaSysSoftDBDesarrollo]
go

/*
tabla alterada 18/02/2020
*/

create table ComprobanteTB(
	IdTipoDocumento int,
	Serie varchar(10) not null,
	Numeracion varchar(16) not null,
	FechaRegistro date not null
	primary key(Serie,Numeracion)
)
go

insert into ComprobanteTB(Serie,Numeracion,FechaRegistro) values(0xAFFF,'99999997',GETDATE())
go
--esa tabla tiene que cambiar ayer has echo te acuerdas algo
--se borro hacer de nuevo que cambios se necesita

SELECT * FROM ComprobanteTB
GO

--
--con el combo box vamos elejir que tipo de documento es
declare @Serie varchar(10),@Numeracion varchar(16),@ResultNumeracion varchar(16)
declare @AuxNumeracion varchar(16),@Aumentado int
set @Serie = (select Serie from TipoDocumentoTB where IdTipoDocumento = 2)
set @Numeracion = (select Numeracion from ComprobanteTB where Serie = @Serie)
if LEN(@Numeracion)>0
	begin
		set @AuxNumeracion = (select Max(Numeracion) from ComprobanteTB  where Serie = @Serie)
		set @Aumentado = CONVERT(INT,@AuxNumeracion) +1
		set @ResultNumeracion = '' +replicate ('0',(8 - len(@Aumentado))) + convert(varchar, @Aumentado)
		print @ResultNumeracion
	end
else
	begin
		set @ResultNumeracion = '00000001'
		print @ResultNumeracion
	end
go
--
truncate table [dbo].[ComprobanteTB]
go

PRINT dbo.Fc_Serie_Numero_Generado()
GO
/*
eliminada Fc_Serie_Numero 18/02/2020
*/
alter function Fc_Serie_Numero(@tipo varchar(12)) returns varchar(40)
as
begin

	declare @serie varchar(8), @resultSerie varchar(8),@numeracion varchar(16),@resulNumeracion varchar(16)
	declare @numero int
	declare @ValorActual varchar(16)
	declare @Length int,@Incremental int,@ActualValor varchar(12),@ValorNuevo varchar(12)

	if(@tipo = 'boleta')
		begin
			set @serie = (select Max(serie_b) from ComprobanteTB)
			print @serie
			set @numeracion = (select Max(Numeracion) from ComprobanteTB where serie_b = @serie)

			if (LEN(@serie) > 0  and LEN(@numeracion) > 0)
				begin
					set @ValorActual = @numeracion
					--oeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
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
			/*
			9999
			1
			*/

			if (LEN(@serie) > 0  and LEN(@numeracion) > 0)
				begin
				--
			set @ValorActual = @numeracion
					
					if(@ValorActual < 99999999)
						begin
							set @resultSerie = (select Max(serie_t) from ComprobanteTB)

							set @numero = CONVERT(INT,@ValorActual) +1

							set @resulNumeracion = '' +replicate ('0',(8 - len(@numero))) + convert(varchar, @numero)
							
							print @resulNumeracion
						--end
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




go

