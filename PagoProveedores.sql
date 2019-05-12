/*	Se elimino los campos CuotaTotal, ValorCuota, FechaInicial y FechaFinal el 24/04/19
	Se actualiso el Sp_Listar_Historial_Pagos el 24/04/19

	Se agrego los campos Dias y IdEmpleado 25/04/19
	Se actualizo el procedimiento almacenado con los nuevos campos agregados 25/04/19
*/
go
alter procedure Sp_Listar_Historial_Pagos
@IdCompra varchar(12)
as
select IdPagoProveedores, MontoTotal, MontoActual, CuotaActual, Plazos, Dias, FechaActual, Observacion, Estado, IdProveedor, IdCompra, IdEmpleado from PagoProveedoresTB where IdCompra = @IdCompra

exec Sp_Listar_Historial_Pagos 'cp0001'

select * from PagoProveedoresTB

--select * from PlazosTB as p inner join PagoProveedoresTB as pp on p.IdPlazos = 

go
truncate table [dbo].[PagoProveedoresTB]

go
truncate table CompraTB
go
truncate table DetalleCompraTB
go
truncate table LoteTB
go
truncate table PagoProveedoresTB
go