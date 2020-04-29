use [PuntoVentaSysSoftDBDesarrollo]
go



create table Banco(
	IdBanco varchar(12) not null,
	NombreCuenta varchar(80) not null,
	NumeroCuenta varchar(60) null,
	IdMoneda int not null,
	SaldoInicial decimal(18,8) not null,
	FechaCreacion date not null,
	HoraCreacion time not null,
	Descripcion varchar(200) null,
	Sistema bit not null,
	FormaPago smallint
	primary key(IdBanco)

)
go

/* creacion de columna Forma Pago 17/03/20*/
Alter table Banco add FormaPago smallint 

/*
	Asigancion = false
*/

select * from Banco
go

alter PROCEDURE Sp_Listar_Bancos
@search varchar(100)
AS
	BEGIN
	   SELECT 
	   IdBanco
      ,NombreCuenta
      ,NumeroCuenta
      ,dbo.Fc_Obtener_Simbolo_Moneda(IdMoneda) as Simbolo
      ,SaldoInicial
      ,Descripcion
	  ,Sistema
	  ,FormaPago
	  FROM Banco
	  WHERE 
	  (@search = '')
	  or
	  (NombreCuenta like @search +'%' )
	  or 
	  (NumeroCuenta like @search +'%')

	END
GO



CREATE function Fc_Banco_Codigo_Alfanumerico ()  returns varchar(12)
	as
		begin
		declare @Incremental int,@ValorActual varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdBanco from Banco)
					begin					
						set @ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdBanco,'BA',''),'','')AS INT)) from Banco)
						set @Incremental = CONVERT(INT,@ValorActual) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'BA000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'BA00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'BA0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'BA'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'BA0001'
					end
			end
			return @CodGenerado
		end
go

/*Se actualizó la tabla BancoHistorialTB, la columna IdBancoHistorial para que sea autoincremental 18/03/2020*/

create table BancoHistorialTB(
	IdBanco varchar(12) not null,
	IdBancoHistorial int not null identity,
	IdProcedencia varchar(12) not null,
	Descripcion varchar(100) not null,
	Fecha date not null,
	Hora time not null,
	Entrada decimal(18,8) not null,
	Salida decimal(18,8) not null
	primary key(IdBanco,IdBancoHistorial)
)
go



print dbo.Fc_Banco_Historial_Codigo_Alfanumerico()
go

/*Funcion borrada por que le dio coronavirus 18/03/2020*/
drop function Fc_Banco_Historial_Codigo_Alfanumerico ()  returns varchar(12)
	as
		begin
		declare @Incremental int,@ValorActual varchar(12),@CodGenerado varchar(12)
			begin
				if EXISTS(select IdBancoHistorial from BancoHistorialTB)
					begin					
						set @ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdBancoHistorial,'BH',''),'','')AS INT)) from BancoHistorialTB)
						set @Incremental = CONVERT(INT,@ValorActual) +1
						if(@Incremental <= 9)
							begin
								set @CodGenerado = 'BH000'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=10 and @Incremental<=99)
							begin
								set @CodGenerado = 'BH00'+CONVERT(VARCHAR,@Incremental)
							end
						else if(@Incremental>=100 and @Incremental<=999)
							begin
								set @CodGenerado = 'BH0'+CONVERT(VARCHAR,@Incremental)
							end
						else
							begin
								set @CodGenerado = 'BH'+CONVERT(VARCHAR,@Incremental)
							end
					end
				else
					begin
						set @CodGenerado = 'BH0001'
					end
			end
			return @CodGenerado
		end
go

alter procedure Sp_Listar_Banco_Historial
@IdBanco varchar(12)
as
	begin
		select IdBanco,Descripcion,Fecha,Hora,Entrada,Salida from BancoHistorialTB where IdBanco = @IdBanco
	end
go

select * from Banco
go
select * from BancoHistorialTB
go

truncate table Banco
go
truncate table BancoHistorialTB
go