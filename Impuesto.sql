use [PuntoVentaSysSoftDBDesarrollo]
go

/*
agregar nombre de la operación

*/

create table ImpuestoTB(
	IdImpuesto int not null,
	Operacion int not null,
	Nombre varchar(50) not null,
	Valor decimal(18,2) not null,
	Predeterminado bit not null,
	CodigoAlterno varchar(50) not null,
	Sistema bit not null,
	primary key(IdImpuesto)
)
go

select * from ImpuestoTB
go

ALTER procedure Sp_Listar_Impuestos
as
begin
select IdImpuesto,dbo.Fc_Obtener_Nombre_Detalle(Operacion,'0010') as Operacion,Nombre,Valor,Predeterminado,CodigoAlterno,Sistema from [dbo].[ImpuestoTB]
end

alter procedure Sp_Listar_Impuesto_Calculo
as
begin
select IdImpuesto,dbo.Fc_Obtener_Nombre_Detalle(Operacion,'0010') as OperacionNombre,Operacion,Nombre,Valor,Predeterminado from [dbo].[ImpuestoTB]
end