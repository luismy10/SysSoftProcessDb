use PuntoVentaSysSoftDBDesarrollo
go

create table TipoTicketTB(
	idTipoTicket int identity(1,1) not null,
	Nombre varchar(50),
	primary key(idTipoTicket)
)
go

select * from TipoTicketTB
go

create table TicketTB(
	idTicket int identity(1,1) not null,
	nombre varchar(60) not null,
	tipo int not null,
	predeterminado bit not null,
	ruta varchar(max) not null
	primary key(idTicket)

)
go

select * from [dbo].[TicketTB] where tipo <> 0
go


truncate table 
TicketTB

truncate table 
ImagenTB

print dbo.Fc_Ticket_Codigo_Numerico()
go


alter procedure Sp_Listar_Ticket_By_Tipo_Opcion
@Tipo int,
@Opcion bit
as
	begin
		SELECT * FROM TicketTB WHERE (tipo <> 0 and @Opcion = 1) or (tipo = @Tipo and @Opcion = 0)
	end
go

alter function Fc_Ticket_Codigo_Numerico ()  returns int
	as
		begin
		declare @Incremental int,@ValorActual  int,@CodGenerado int
			begin
				if EXISTS(select idTicket from TicketTB)
					begin					
						set @ValorActual = (select MAX(idTicket) from TicketTB)
						set @Incremental = @ValorActual +1						
						set @CodGenerado = @Incremental
						
					end
				else
					begin
						set @CodGenerado = 1
					end
			end
			return @CodGenerado
		end
go
