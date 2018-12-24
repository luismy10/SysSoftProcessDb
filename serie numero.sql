use PuntoVentaSysSoftDB
go

create table ComprobanteTB(
	Serie varbinary(2) not null,
	Numeracion varchar(16) not null,
	FechaRegistro datetime not null
	primary key(Serie,Numeracion),
)
go

insert into ComprobanteTB(Serie,Numeracion,FechaRegistro) values(0xAFFF,'99999997',GETDATE())
go

truncate table [dbo].[ComprobanteTB]
go

select * from [dbo].[ComprobanteTB]
go

PRINT dbo.Fc_Serie_Numero_Generado()
GO

create function Fc_Serie_Numero_Generado() returns varchar(40)
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
 
go



print CONVERT(VARBINARY(9), 10+1)
print CONVERT(VARBINARY(8), 10+1)
print CONVERT(VARBINARY(7), 10+1)
print CONVERT(VARBINARY(6), 10+1)
print CONVERT(VARBINARY(5), 10+1)
print CONVERT(VARBINARY(4), 10+1)
print CONVERT(VARBINARY(3), 10+1)
print CONVERT(VARBINARY(2), 10+1)
print CONVERT(VARBINARY(1), 10+1)

print CONVERT(VARBINARY(2), 40960)

print CONVERT(INT, CONVERT(VARBINARY, '0xA000', 1))


declare @Cant int
set @Cant = 1
while @Cant < 100
begin
select 'CAT' +replicate ('*',(8 - len(@Cant))) + convert(varchar, @Cant)
set @Cant = @Cant + 1
continue
end