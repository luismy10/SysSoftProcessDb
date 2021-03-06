use PuntoVentaSysSoftDBDesarrollo
go

create table MonedaTB(
	IdMoneda int identity not null,
	Nombre varchar(100) not null,
	Abreviado varchar(10) null,
	Simbolo varchar(10) not null,
	TipoCambio decimal(18,4) not null,
	Predeterminado bit not null,
	Sistema bit not null,
	primary key(IdMoneda)
)
go

create procedure Sp_Listar_Monedas
as
	begin
		select IdMoneda,Nombre,Abreviado,Simbolo,TipoCambio,Predeterminado from MonedaTB
	end
go

select * from MonedaTB
go


