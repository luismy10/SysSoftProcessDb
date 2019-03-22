use PuntoVentaSysSoftDB
go

create table ImpuestoTB(
	IdImpuesto int not null,
	Nombre varchar(50) not null,
	Valor decimal(18,2) not null,
	Predeterminado bit not null,
	CodigoAltero varchar(50) not null,
	Sistema bit not null,
	primary key(IdImpuesto)
)
go

select * from ImpuestoTB
go

ALTER procedure Sp_Listar_Impuestos
as
begin
select IdImpuesto,Nombre,Valor,Predeterminado,CodigoAlterno,Sistema from [dbo].[ImpuestoTB]
end
