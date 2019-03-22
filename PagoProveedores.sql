

alter procedure Sp_Listar_Historial_Pagos 
	@IdCompra varchar(12)
as
 select IdPagoProveedores, MontoTotal, MontoActual, CuotaTotal, CuotaActual, ValorCuota, Plazos, FechaInicial, FechaActual, FechaFinal, Observacion, Estado, IdProveedor, IdCompra from PagoProveedoresTB where IdCompra = @IdCompra

 exec Sp_Listar_Historial_Pagos 'cp0005'

 select * from PagoProveedoresTB