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

select * from TicketTB
go



