-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-06-2020 a las 00:04:56
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `puntoventasyssoftdbdesarrollo`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_compra_for_editar` (`IdCompra_` VARCHAR(12))  begin
	select IdCompra,Proveedor,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Datos_Proveedor(Proveedor)as DatosProveedor,
		FechaCompra,Serie,Numeracion,TipoMoneda,Observaciones,Notas 
		from CompraTB WHERE IdCompra = IdCompra_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_compra_for_editar` (`IdCompra_` VARCHAR(12))  begin
	select d.IdArticulo,s.Clave,s.NombreMarca,d.Cantidad,d.PrecioCompra,
		d.Descuento,d.Importe,d.IdImpuesto,d.NombreImpuesto,d.ValorImpuesto,d.Descripcion 
		from DetalleCompraTB as d inner join SuministroTB as s on d.IdArticulo = s.IdSuministro 
		where d.IdCompra = IdCompra_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Generar_Listardo_CodBar` (IN `UnidadVenta_` TINYINT, IN `Categoria_` INT(10))  NO SQL
SELECT Clave,ClaveAlterna,NombreMarca,UnidadVenta,Categoria
         FROM ArticuloTB
		 WHERE (UnidadVenta_ = 0 and Categoria_ = 0) 
		 or 
		 (UnidadVenta = UnidadVenta_ and Categoria_ = 0) 
		 or
		 (UnidadVenta = UnidadVenta_ and Categoria = Categoria_) 
		 or
		 (UnidadVenta_ = 0 and Categoria = Categoria_)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Get_Articulo_By_Id` (IN `IdArticulo_` VARCHAR(45))  NO SQL
select IdArticulo,Origen,Clave,ClaveAlterna,NombreMarca,NombreGenerico,
		Categoria,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as CategoriaNombre,
		Marca,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as MarcaNombre,
		Presentacion,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as PresentacionNombre,
		UnidadCompra,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		UnidadVenta,
		StockMinimo,StockMaximo,Cantidad,PrecioCompra,PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,
		Estado,Lote,Inventario,Imagen,
		Impuesto,dbo.Fc_Obtener_Nombre_Impuesto(Impuesto) as ImpuestoNombre
		from ArticuloTB
		where IdArticulo = IdArticulo_ or Clave = IdArticulo_$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Get_Cliente_By_Id` (IN `NumeroDocumento_` VARCHAR(20))  NO SQL
select ci.IdCliente,ci.TipoDocumento,ci.NumeroDocumento,ci.Informacion,
		ci.Telefono,ci.Celular,ci.Email,ci.Direccion,ci.Representante,ci.Estado
		from ClienteTB as ci
		where ci.NumeroDocumento = NumeroDocumento_$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Get_CuentasCliente_By_Id` (IN `IdVenta_ ` VARCHAR(12))  NO SQL
SELECT c.IdCuentaClientes,c.IdCliente,p.Nombre,c.FechaVencimiento,MontoInicial 
FROM CuentasClienteTB as c inner join PlazosTB as p
on c.Plazos = p.IdPlazos
WHERE c.IdVenta = IdVenta_$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Get_Detalle_Id` (IN `IdMantenimiento_` VARCHAR(10))  NO SQL
select IdDetalle,Nombre from DetalleTB where IdMantenimiento = IdMantenimiento_ order by Nombre asc$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Get_Detalle_IdNombre` (IN `Opcion` CHAR(1), IN `IdMantenimiento_` VARCHAR(10), IN `Nombre_` VARCHAR(60))  NO SQL
if Opcion = '1' THEN
			
				select IdDetalle,Nombre from DetalleTB where IdMantenimiento = IdMantenimiento_ and Nombre <> Nombre_;
                ELSEIF Opcion = '2' THEN
                select IdDetalle,Nombre from DetalleTB where IdMantenimiento = IdMantenimiento_;
                ELSEIF Opcion = '3' THEN
                select IdDetalle,Nombre,Descripcion from DetalleTB where IdMantenimiento = IdMantenimiento_;
                ELSEIF Opcion = '4' THEN
                select IdDetalle,Nombre,Descripcion from DetalleTB
				 where (IdMantenimiento = IdMantenimiento_ and Nombre_ = '')
				 or
				 (IdMantenimiento = IdMantenimiento_ and Nombre like '%'+Nombre_+'%') ;
ELSE
select IdDetalle ,Nombre from DetalleTB where IdMantenimiento = IdMantenimiento_ and Nombre = Nombre_;
end IF$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_directorio_by_id` (`IdPersona_` VARCHAR(12))  begin
	select IdDirectorio,Atributo,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Atributo,'0002')as Nombre,Valor,IdPersona
		 from DirectorioTB
		where IdPersona=IdPersona_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_movimiento_inventario_by_id` (`idMovimientoInventario_` VARCHAR(12))  begin
	select UPPER(tm.Nombre) as TipoMovimiento,mv.Fecha, mv.Hora, UPPER(mv.Observacion) as Observacion,
	case
		when mv.Proveedor = '' then 'Proveedor no especificado'
		when mv.Proveedor <> '' then dbo.Fc_Obtener_Datos_Proveedor(mv.Proveedor)
	end as Proveedor,
	case
		when mv.Estado = 0 then 'EN PROCESO'
		when mv.Estado = 1 then 'COMPLETADO'
		when mv.Estado = 2 then 'CANCELADO'
	end as Estado
	from MovimientoInventarioTB mv inner join TipoMovimientoTB as tm on mv.TipoMovimiento = tm.IdTipoMovimiento
	where mv.IdMovimientoInventario = idMovimientoInventario_ ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_proveedor_by_id` (`NumeroDocumento_` VARCHAR(20))  begin
	select IdProveedor,TipoDocumento,NumeroDocumento,RazonSocial,NombreComercial,Pais,Ciudad,Provincia,Distrito,Ambito,Estado,
		Telefono,Celular,Email,PaginaWeb,Direccion,Representante
		 from ProveedorTB where NumeroDocumento = NumeroDocumento_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_suministro_for_asignacion_by_id` (`IdSuministro_` VARCHAR(12))  begin
	select IdSuministro,Clave,NombreMarca,Cantidad,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		PrecioCompra,PrecioVentaGeneral
		from SuministroTB
		where IdSuministro = IdSuministro_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listarcajasaperturadas` (`FechaInicial` VARCHAR(30), `FechaFinal` VARCHAR(30))  begin
		select a.IdCaja,a.FechaApertura,a.HoraApertura,a.FechaCierre,a.HoraCierre,a.Estado,a.Contado,a.Calculado,a.Diferencia,e.Apellidos,e.Nombres 
		from CajaTB as a inner join EmpleadoTB as e
		on a.IdUsuario = e.IdEmpleado
		where 
		(FechaInicial = '' and FechaFinal = '' and a.FechaApertura is not null)
		or
		(cast(a.FechaRegistro as date) between FechaInicial and FechaFinal and a.FechaApertura is not null);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listarcajasaperturadasporusuario` (`Usuario` VARCHAR(12))  begin
		select a.IdCaja,a.FechaApertura,a.HoraApertura,a.FechaCierre,a.HoraCierre,a.Estado,a.Contado,a.Calculado,a.Diferencia,e.Apellidos,e.Nombres 
		from CajaTB as a inner join EmpleadoTB as e
		on a.IdUsuario = e.IdEmpleado
		where 
		e.IdEmpleado = Usuario
		order by a.FechaApertura desc,a.HoraApertura desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_articulo` (`OPTION` TINYINT, `search` VARCHAR(100), `categoria_` INT)  begin
	select IdArticulo,Clave,ClaveAlterna,NombreMarca,NombreGenerico,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
			Cantidad,
			PrecioVentaGeneral,
			Impuesto,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
			UnidadVenta,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
			Imagen	
			from ArticuloTB 
			where (option = 0) 
			OR (Categoria=categoria_ AND option = 1) 
			OR (NombreMarca LIKE search +'%' AND option = 2)	
			OR (
				(Clave = search AND option = 3)
				OR 
				(ClaveAlterna = search AND option = 3)
			   );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_articulo_by_search` (`search` VARCHAR(60))  begin
	select IdArticulo,Clave,NombreMarca,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as Presentacion ,
		Cantidad,PrecioCompra,PrecioVentaGeneral,
		UnidadVenta,Lote,Inventario,Impuesto,ValorInventario
		from ArticuloTB 
		where Clave = search;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_articulo_lista_view` (`opcion` TINYINT, `search` VARCHAR(100))  begin
	select IdArticulo,Clave,NombreMarca,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		Cantidad,PrecioCompra,
		PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,UnidadVenta,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
		Inventario,Impuesto,Lote,ValorInventario,		
		case
			when Origen = 1 then 'COMPRA'
			when Origen = 2 then 'PRODUCCIÓN'
			when Origen = 3 then 'SUB. PRODUCTO(S)'
		end as Origen
		from ArticuloTB 
		where 
		(
			(opcion = 1 and search = '' and Estado = 1) 
			or
			(opcion = 1 and Clave = search and Estado = 1 )
			or
			(opcion = 1 and ClaveAlterna = search and Estado = 1 )
			or
			(opcion = 1 and NombreMarca like search +'%' and Estado = 1)
		)
		or(
			(opcion = 2 and search = '' and Estado = 1 and Origen = 3) 
			or
			(opcion = 2 and Clave = search and Estado = 1 and Origen = 3)
			or
			(opcion = 2 and ClaveAlterna = search and Estado = 1 and Origen = 3)
			or
			(opcion = 2 and NombreMarca like search +'%' and Estado = 1 and Origen = 3)
		);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_articulo_movimiento` (`IdArticulo_` VARCHAR(45))  begin
	select IdArticulo,Clave,NombreMarca,Cantidad,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
	PrecioCompra,PrecioVentaGeneral,
		Inventario,ValorInventario 
		from ArticuloTB
		where 
		IdArticulo = IdArticulo_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_articulo_paginacion` (`paginacion` INT)  begin
	select IdArticulo,Clave,ClaveAlterna,NombreMarca,NombreGenerico,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
			Cantidad,
			PrecioVentaGeneral,
			Impuesto,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
			UnidadVenta,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
			Imagen	
			from ArticuloTB 
			order by IdArticulo asc
			limit paginacion offset 10;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_bancos` (`search` VARCHAR(100))  begin
	SELECT 
	   IdBanco
      ,NombreCuenta
      ,NumeroCuenta
      ,puntoventasyssoftdbdesarrollo.Fc_Obtener_Simbolo_Moneda(IdMoneda) as Simbolo
      ,SaldoInicial
      ,Descripcion
	  ,Sistema
	  ,FormaPago
	  FROM Banco
	  WHERE 
	  (search = '')
	  or
	  (NombreCuenta like search +'%' )
	  or 
	  (NumeroCuenta like search +'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_banco_historial` (`IdBanco_` VARCHAR(12))  begin
		select IdBanco,puntoventasyssoftdbdesarrollo.Fc_Obtener_Datos_Empleado(IdEmpleado) as Empleado,Descripcion,Fecha,Hora,Entrada,Salida 
		from BancoHistorialTB 
		where IdBanco = IdBanco_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_ciudad` (`PaisCodigo_` CHAR(3))  begin
	select IdCiudad,Departamento from CiudadTB where PaisCodigo = PaisCodigo_ order by Departamento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_clientes` (`search` VARCHAR(100))  begin
	select ci.IdCliente,ci.NumeroDocumento,ci.Informacion,ci.Telefono,
ci.Celular,ci.Direccion,ci.Representante,
puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(ci.Estado,'0001') as Estado
from ClienteTB as ci 
where
	(search = '')  
	or 
	(ci.NumeroDocumento like search+'%')
	OR
	(ci.Informacion LIKE search+'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_clientes_venta` (`search` VARCHAR(55))  begin
	select ci.IdCliente,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(TipoDocumento,'0003') as Documento,
	ci.NumeroDocumento,
ci.Informacion,ci.Direccion
from ClienteTB as ci
where 
	(search = '')  
	or 
	(ci.NumeroDocumento like search+'%')
	or 
	(ci.Informacion LIKE search+'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_compras` (`Opcion` BIGINT, `Search` VARCHAR(100), `FechaInicial` VARCHAR(20), `FechaFinal` VARCHAR(20), `EstadoCompra_` INT)  begin
	select ROW_NUMBER() over( order by c.FechaCompra desc) as Filas,c.IdCompra,p.IdProveedor,
			c.FechaCompra,c.HoraCompra,
			c.Serie,c.Numeracion,
			p.NumeroDocumento,p.RazonSocial,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(c.TipoCompra,'0015') Tipo,
			c.EstadoCompra,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') Estado,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total
			from CompraTB as c inner join ProveedorTB as p
			on c.Proveedor = p.IdProveedor
			where (Search = '' and Opcion = 0)
				or (c.Serie like Search+'%' and Opcion = 0) 
				or (c.Numeracion like Search+'%' and Opcion = 0) 
				or (p.NumeroDocumento like Search+'%' and Opcion = 0) 
				or (p.RazonSocial like '%'+Search+'%' and Opcion = 0)

				or (CAST(c.FechaCompra as Date) BETWEEN FechaInicial and FechaFinal and Opcion = 1)

				or (CAST(c.FechaCompra as Date) BETWEEN FechaInicial and FechaFinal and c.EstadoCompra = EstadoCompra_ and Opcion = 2) 
	order by c.FechaCompra desc ,
	c.HoraCompra desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_compras_for_movimiento` (`Search` VARCHAR(120), `fecha` VARCHAR(20), `Opcion` TINYINT)  begin
	select c.IdCompra,c.Fecha,c.Hora,c.Numeracion,p.RazonSocial,puntoventasyssoftdbdesarrollo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total
	from CompraTB as c inner join ProveedorTB as p on c.Proveedor = p.IdProveedor
	where 
	(Search = '' and fecha = '' and c.EstadoCompra != 3)
	or (c.Numeracion like Search+'%' and Opcion = 0 and c.EstadoCompra != 3) 
	or (p.NumeroDocumento like Search+'%' and Opcion = 0 and c.EstadoCompra != 3) 
	or (p.RazonSocial like '%'+Search+'%' and Opcion = 0 and c.EstadoCompra != 3)
	or (cast(c.Fecha as date) = fecha and Opcion = 1 and c.EstadoCompra != 3)
	order by c.Fecha desc,c.Hora desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_compra_credito_por_idcompra` (`IdCompra_` VARCHAR(12))  begin
	select Monto,FechaRegistro,FechaPago,HoraPago,Estado from CompraCreditoTB 
		where IdCompra = IdCompra_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_cuentashistorial_by_idcuenta` (`IdCuentaClientes_` INT)  begin
	select IdCuentasHistorialCliente,FechaAbono,Abono,Referencia from CuentasHistorialClienteTB 
	where IdCuentaClientes = IdCuentaClientes_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_detalle_compra` (`IdCompra_` VARCHAR(12))  begin
	select s.IdSuministro,
s.Clave,s.NombreMarca,
puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(s.UnidadCompra,'0013') as UnidadCompra,s.UnidadVenta,
d.Cantidad,d.PrecioCompra,d.Descuento,d.IdImpuesto,d.ValorImpuesto
from DetalleCompraTB as d inner join SuministroTB as s
on d.IdArticulo = s.IdSuministro
where d.IdCompra = IdCompra_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_detalle_compra_by_idcompra` (`IdCompra_` VARCHAR(12))  begin
	SELECT s.IdSuministro,s.Clave,s.NombreMarca,s.Cantidad,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(s.UnidadCompra,'0013') as UnidadCompraNombre,
		s.PrecioCompra,s.PrecioVentaGeneral,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(s.Categoria,'0006') as Categoria,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(s.Estado,'0001') as Estado,
		s.Inventario,s.ValorInventario 
		FROM DetalleCompraTB as d INNER JOIN SuministroTB AS s ON d.IdArticulo = s.IdSuministro 
		WHERE d.IdCompra = IdCompra_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_directorio` (`search` VARCHAR(50))  begin
	(select pe.IdPersona as Codigo,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(pe.TipoDocumento,'0003') as Tipo,pe.NumeroDocumento as Documento,CONCAT(pe.ApellidoPaterno,' ',pe.ApellidoMaterno,' ',pe.PrimerNombre,' ',pe.SegundoNombre) as Datos
		 from PersonaTB as pe inner join DirectorioTB as di
		on pe.IdPersona = di.IdPersona

		where (search = '') or (pe.NumeroDocumento like search+'%')
		)
		union
		(select pr.IdProveedor as Codigo,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(pr.TipoDocumento,'0003') as Tipo,pr.NumeroDocumento as Documento,pr.RazonSocial as Datos 
		from ProveedorTB as pr inner join DirectorioTB as di
		on pr.IdProveedor = di.IdPersona
		where (search = '') or (pr.NumeroDocumento like search+'%')
		);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_distrito` (`IdProvincia_` INT)  begin
	select IdDistrito,Distrito from DistritoTB where IdProvincia = IdProvincia_ order by Distrito;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_empleados` (`search` VARCHAR(55))  begin
	select ROW_NUMBER() over( order by IdEmpleado desc) as Filas,IdEmpleado,
NumeroDocumento,Apellidos,Nombres,Telefono,Celular,
puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Puesto,'0012') as Puesto,
puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Rol(Rol) as Rol,
puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado
from EmpleadoTB 
where (search = '')  or (NumeroDocumento like search+'%')
or (
			(Apellidos LIKE search+'%')
			or
			(Nombres LIKE search+'%')
			or
			(CONCAT(Apellidos,' ',Nombres) LIKE search+'%') 
		);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_etiquetas_by_type` (`type` INT)  begin
	select et.idEtiqueta,et.nombre,td.nombre as nombretipo,et.predeterminado,et.medida,et.ruta,et.imagen 
		from EtiquetaTB as et inner join TipoEtiquetaTB as td on et.tipo = td.idTipoEtiqueta
		where (type = 0) or (et.tipo = type);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_impuestos` ()  begin
	select IdImpuesto,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Operacion,'0010') as Operacion,
	Nombre,Valor,Predeterminado,CodigoAlterno,Sistema from ImpuestoTB;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_impuesto_calculo` ()  begin
	select IdImpuesto,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Operacion,'0010') as OperacionNombre,
	Operacion,Nombre,Valor,Predeterminado,Sistema from ImpuestoTB;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_inventario_articulos` ()  begin
	select
	IdArticulo,Clave,NombreMarca,PrecioCompra,
	Cantidad,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
	(PrecioCompra*Cantidad) as Total 
	from ArticuloTB 
	where Inventario = 1 order by Total desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_inventario_suministros` (`Producto_` VARCHAR(45), `Existencia_` TINYINT)  begin
	select
		IdSuministro,Clave,NombreMarca,PrecioCompra,
		PrecioVentaGeneral,Cantidad,
		dbo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
		dbo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
		(PrecioCompra*Cantidad) as Total,
		StockMinimo,StockMaximo 
		from SuministroTB 
		where (Producto_ = '' and Existencia_ = 0 and Inventario = 1)
		or (Clave <> '' and Clave = Producto_ and Existencia_ = 0 and Inventario = 1 )
		or (ClaveAlterna <> '' and ClaveAlterna = Producto_ and Existencia_ = 0 and Inventario = 1)
		or (Producto_ = '' and Existencia_ = 1 and Cantidad <= 0)
		or (Producto_ = '' and Existencia_ = 2 and Cantidad > 0)
		or (Producto_ = '' and Existencia_ = 3 and Cantidad > 0 and Cantidad <= StockMinimo)
		order by Cantidad asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_kardex_articulo_by_id` (`idArticulo_` VARCHAR(45))  begin
	SELECT k.IdArticulo,k.Fecha,k.Hora,k.Tipo,t.Nombre,
k.Detalle,k.Cantidad,k.CUnitario,k.CTotal
 FROM KardexArticuloTB AS k INNER JOIN ArticuloTB AS a ON k.IdArticulo = a.IdArticulo
 inner join TipoMovimientoTB AS t ON k.Movimiento = t.IdTipoMovimiento
WHERE 
	(a.IdArticulo = idArticulo_ )
	or
	(a.Clave = idArticulo_ or a.ClaveAlterna = idArticulo_)
	order by k.Fecha,k.Hora asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_kardex_suministro_by_id` (`idArticulo` VARCHAR(45))  begin
	SELECT k.IdSuministro,k.Fecha,k.Hora,k.Tipo,t.Nombre,
k.Detalle,k.Cantidad
FROM KardexSuministroTB AS k INNER JOIN SuministroTB AS a ON k.IdSuministro = a.IdSuministro
inner join TipoMovimientoTB AS t ON k.Movimiento = t.IdTipoMovimiento
WHERE 
	(a.IdSuministro = idArticulo )
	or
	(a.Clave = idArticulo or a.ClaveAlterna = idArticulo)

	order by k.Fecha,k.Hora asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_lote` (`opcion` BIGINT, `search` VARCHAR(60))  begin
	select ROW_NUMBER() over( order by lo.IdLote desc) as Filas, lo.IdLote,lo.NumeroLote,ar.Clave,ar.NombreMarca,lo.FechaCaducidad,lo.ExistenciaInicial,lo.ExistenciaActual
		from LoteTB as lo inner join SuministroTB as ar
		on lo.IdArticulo = ar.IdSuministro
		where (search = '' and opcion = 0)
		 or (lo.NumeroLote like search+'%' and opcion = 0) 
		 or (ar.Clave like search+'%' and opcion = 0) 
		 or (ar.NombreMarca like '%'+search+'%' and opcion = 0)
		 or (CURDATE() <= lo.FechaCaducidad and DATEDIFF( CURDATE(), lo.FechaCaducidad)<=15 and opcion = 1)
		 or	(lo.FechaCaducidad <= CAST(CURDATE() AS DATE) and opcion = 2)				 
		 order by lo.FechaCaducidad asc ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_monedas` ()  begin
	select IdMoneda,Nombre,Abreviado,Simbolo,TipoCambio,Predeterminado from MonedaTB;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_movimiento_inventario` (`init` BIT, `opcion` TINYINT, `movimiento` INT, `fechaInicial` VARCHAR(50), `fechaFinal` VARCHAR(50))  begin
	
	select mv.IdMovimientoInventario, mv.Fecha, mv.Hora, mv.TipoAjuste, UPPER(tm.Nombre) as TipoMovimiento, UPPER(mv.Observacion) as Observacion,
	case 
		when mv.Suministro = 1 and mv.Articulo = 0 then 'MOVIMIENTO DE SUMINISTROS'
		when mv.Suministro = 1 and mv.Articulo = 1 then 'MOVIMIENTO DE SUMINISTROS A ARTÍCULOS'
		when mv.Suministro = 0 and mv.Articulo = 1 then 'MOVIMIENTO DE ARTÍCULOS'
	end as Informacion,
	case
		when mv.Proveedor = '' then 'Proveedor no especificado'
		when mv.Proveedor <> '' then puntoventasyssoftdbdesarrollo.Fc_Obtener_Datos_Proveedor(mv.Proveedor)
	end as Proveedor,
	case
		when mv.Estado = 0 then 'EN PROCESO'
		when mv.Estado = 1 then 'COMPLETADO'
		when mv.Estado = 2 then 'CANCELADO'
	end as Estado
	from MovimientoInventarioTB mv inner join TipoMovimientoTB as tm on mv.TipoMovimiento = tm.IdTipoMovimiento
	where 
	(
		(
		 (opcion = 1 and init = 0)
		 or
		 (opcion = 1 and mv.Fecha between cast(fechaInicial as date) and cast(fechaFinal as date) and movimiento = 0)
		 or
		 (opcion = 1 and mv.Fecha between cast(fechaInicial as date) and cast(fechaFinal as date) and mv.TipoMovimiento = movimiento)
		)
	) 
	or
	(
		(
		(opcion = 2 and mv.Articulo = 1 and init = 0)
		or
		(opcion = 2 and mv.Articulo = 1 and mv.Fecha between cast(fechaInicial as date) and cast(fechaFinal as date) and movimiento = 0)
		or
		(opcion = 2 and mv.Articulo = 1 and mv.Fecha between cast(fechaInicial as date) and cast(fechaFinal as date) and mv.TipoMovimiento = movimiento)
		)
	)
	order by mv.Fecha desc,mv.Hora desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_pais` ()  begin
	select PaisCodigo,PaisNombre from PaisTB order by PaisNombre;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_proveedor` (`search` VARCHAR(100))  begin
	select IdProveedor,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(TipoDocumento,'0003') as Documento,
	NumeroDocumento,RazonSocial,NombreComercial,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
		Telefono,Celular,FechaRegistro as FRegistro,Representante
		 from ProveedorTB where (search = '') or (NumeroDocumento like search+'%')
		or (
			(NombreComercial LIKE search+'%')
			or
			(RazonSocial LIKE search+'%')
		)
		;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_provincia` (`IdCiudad_` INT)  begin
	select IdProvincia,Provincia from ProvinciaTB where IdCiudad = IdCiudad_ order by Provincia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_suministros` (`Opcion` TINYINT, `Clave_` VARCHAR(45), `NombreMarca_` VARCHAR(120), `Categoria_` INT, `Marca_` INT)  begin
	select IdSuministro,Clave,ClaveAlterna,NombreMarca,NombreGenerico,StockMinimo,StockMaximo,Cantidad,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		PrecioCompra,Impuesto,PrecioVentaGeneral,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
		Inventario,ValorInventario,Imagen 
		from SuministroTB
		where (Opcion = 0) 
		or (Clave like Clave_+'%' and Opcion = 1) 
		or (ClaveAlterna like Clave_+'%' and Opcion = 1)
		or (NombreMarca like NombreMarca_+'%' and Opcion = 2)
		or (
			(Clave like NombreMarca_+'%' and Opcion = 3)
			 or 
			 (NombreMarca like NombreMarca_+'%' and Opcion = 3)
			)		
		or (IdSuministro = Clave_ and Opcion = 4)
		or (Categoria=Categoria_ and Opcion = 5)
		or (Marca=Marca_ and Opcion = 6);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_suministros_lista_view` (`opcion` SMALLINT, `search` VARCHAR(100))  begin
	select IdSuministro,Clave,NombreMarca,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		Cantidad,PrecioCompra,
		PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
		UnidadVenta,Inventario,Impuesto,Lote,ValorInventario,Imagen
		from SuministroTB 
		where (opcion = 1 and search = '' and Estado = 1) 
		or 
		(opcion = 1 and Clave = search and Estado = 1)
		or
		(opcion = 1 and ClaveAlterna = search and Estado = 1)
		or
		(opcion = 1 and NombreMarca like search +'%' and Estado = 1)

		or
		(opcion = 2 and 
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') like search +'%' and Estado = 1)
		or
		(opcion = 3 and 
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') like search +'%' and Estado = 1)
		or
		(opcion = 4 and 
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') like search +'%' and Estado = 1)
		or
		(opcion = 5 and 
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') like search +'%' and Estado = 1);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_suministro_by_search` (`search` VARCHAR(60))  begin
	select s.IdSuministro,s.Clave,s.NombreMarca,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(s.Marca,'0007') as Marca,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(s.Presentacion,'0008') as Presentacion,
		s.Cantidad,s.PrecioCompra,s.PrecioVentaGeneral,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
		s.UnidadVenta,s.Lote,s.Inventario,i.Operacion,s.Impuesto,s.ValorInventario		
		from SuministroTB as s inner join ImpuestoTB as i on s.Impuesto = i.IdImpuesto
		where (Clave <> '' and Clave = search) or (ClaveAlterna <> '' and ClaveAlterna = search );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_suministro_paginacion` (`paginacion` INT)  begin
	select IdSuministro,Clave,ClaveAlterna,NombreMarca,NombreGenerico,StockMinimo,StockMaximo,Cantidad,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
		PrecioCompra,Impuesto,PrecioVentaGeneral,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Estado,'0001') as Estado,
		Inventario,ValorInventario,Imagen 
		from SuministroTB 
		order by IdSuministro asc
		limit paginacion offset  20 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_suministro_paginacion_view` (`paginacion` INT)  begin
	select IdSuministro,Clave,NombreMarca,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as Categoria,dbo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as Marca,
			Cantidad,PrecioCompra,
			PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,
			puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompra,
			UnidadVenta,Inventario,Impuesto,Lote,ValorInventario,Imagen
			from SuministroTB 
			order by IdSuministro asc
			limit paginacion offset 20 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_total_banco` (`IdBanco_` VARCHAR(12))  begin
		SELECT puntoventasyssoftdbdesarrollo.Fc_Obtener_Simbolo_Moneda(IdMoneda) as Simbolo,SaldoInicial FROM Banco
	WHERE IdBanco = IdBanco_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_utilidad` (`fechaInicial` DATE, `fechaFinal` DATE, `idSuministro_` VARCHAR(12), `idCategoria` INT, `idMarca` INT, `idPresentacion` INT)  begin
	select a.IdSuministro, a.Clave, a.NombreMarca,v.Estado,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompraNombre,
		case
			when a.ValorInventario = 1 then dv.Cantidad
			when a.ValorInventario = 2 then dv.CantidadGranel
			when a.ValorInventario = 3 then dv.Cantidad
		end as Cantidad, 
		dv.CostoVenta as Costo,
		case
			when a.ValorInventario = 1 then dv.Cantidad * dv.CostoVenta
			when a.ValorInventario = 2 then dv.CantidadGranel * dv.CostoVenta
			when a.ValorInventario = 3 then dv.Cantidad * dv.CostoVenta
		end as CostoTotal,
		a.PrecioVentaGeneral as Precio, 
		case 
			when a.ValorInventario = 1 then dv.Cantidad * a.PrecioVentaGeneral
			when a.ValorInventario = 2 then dv.CantidadGranel * a.PrecioVentaGeneral
			when a.ValorInventario = 3 then dv.Cantidad * a.PrecioVentaGeneral
		end as PrecioTotal,
		case
			when a.ValorInventario = 1 then (dv.Cantidad * a.PrecioVentaGeneral )- (dv.Cantidad * dv.CostoVenta )
			when a.ValorInventario = 2 then (dv.CantidadGranel * a.PrecioVentaGeneral )- (dv.CantidadGranel * dv.CostoVenta )
			when a.ValorInventario = 3 then (dv.Cantidad * a.PrecioVentaGeneral )- (dv.Cantidad * dv.CostoVenta )
		end as Utilidad,a.ValorInventario, m.Simbolo
				from DetalleVentaTB as dv
				inner join SuministroTB as a on dv.IdArticulo = a.IdSuministro 
				inner join VentaTB as v on v.IdVenta = dv.IdVenta
				inner join MonedaTB as m on m.IdMoneda = v.Moneda
				where  
				(v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and idCategoria = 0 and idMarca = 0 and idPresentacion = 0)
				or
				(
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and idCategoria = 0 and idMarca = 0 and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and idMarca = 0 and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and idCategoria = 0 and a.Marca = idMarca and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and idCategoria = 0 and idMarca = 0 and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and a.Marca = idMarca and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and idMarca = 0 and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and idCategoria = 0 and a.Marca = idMarca and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and a.Marca = idMarca and a.Presentacion = idPresentacion
				)
				or
				(
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and a.Categoria = idCategoria and idMarca = 0 and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and idMarca = 0 and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and a.Categoria = idCategoria and a.Marca = idMarca and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and a.Categoria = idCategoria and idMarca = 0 and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and a.Marca = idMarca and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and idMarca = 0 and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and a.Categoria = idCategoria and a.Marca = idMarca and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and a.Marca = idMarca and a.Presentacion = idPresentacion
				)
				or
				(
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and idCategoria = 0 and a.Marca = idMarca and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and idCategoria = 0 and a.Marca = idMarca and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and a.Categoria = idCategoria and a.Marca = idMarca and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and idCategoria = 0 and a.Marca = idMarca and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and a.Marca = idMarca and idPresentacion = 0
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and idCategoria = 0 and a.Marca = idMarca and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and a.Categoria = idCategoria and a.Marca = idMarca and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and a.Marca = idMarca and a.Presentacion = idPresentacion
				)
				or
				(
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and idCategoria = 0 and idMarca = 0 and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and idCategoria = 0 and idMarca = 0 and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and a.Categoria = idCategoria and idMarca = 0 and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and idCategoria = 0 and a.Marca = idMarca and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and idMarca = 0 and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and idCategoria = 0 and a.Marca = idMarca and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and idSuministro_ = '' and a.Categoria = idCategoria and a.Marca = idMarca and a.Presentacion = idPresentacion
					or
					v.Estado <> 3 and cast(v.FechaVenta as date)  between fechaInicial and fechaFinal and a.IdSuministro = idSuministro_ and a.Categoria = idCategoria and a.Marca = idMarca and a.Presentacion = idPresentacion
				)
				
		order by a.NombreMarca asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_ventas` (`opcion` SMALLINT, `search` VARCHAR(100), `FechaInicial` VARCHAR(20), `FechaFinal` VARCHAR(20), `Comprobante_` INT, `Estado_` INT, `Vendedor` VARCHAR(12))  begin
	select
		v.IdVenta,
		v.FechaVenta,
		v.HoraVenta,
		c.Informacion as Cliente,
		td.Nombre as Comprobante,
		v.Serie,v.Numeracion,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Simbolo,
		v.Total,
		v.Observaciones
		from VentaTB as v inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as td on v.Comprobante = IdTipoDocumento
		inner join MonedaTB as m on v.Moneda = m.IdMoneda
		where 
		(v.Vendedor = Vendedor and search = '' and CAST(v.FechaVenta as date) = CAST(GETDATE() as date) and opcion = 1)
		OR (v.Vendedor = Vendedor and search <> '' AND CONCAT(v.Serie,'-',v.Numeracion) LIKE search+'%' and opcion = 1)
		OR (v.Vendedor = Vendedor and search <> '' AND c.Informacion LIKE search+'%' and opcion = 1)
		
		OR
		(v.Vendedor = Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN FechaInicial AND FechaFinal AND Comprobante_ = 0 AND Estado_ = 0 and opcion = 0
		)
		OR
		(v.Vendedor = Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN FechaInicial AND FechaFinal AND v.Comprobante = Comprobante_ AND v.Estado = Estado_ and opcion = 0
		)
		OR
		(v.Vendedor = Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN FechaInicial AND FechaFinal AND v.Comprobante = Comprobante_  AND Estado_ = 0 and opcion = 0
		)
		OR
		(v.Vendedor = Vendedor and
			CAST(v.FechaVenta AS DATE) BETWEEN FechaInicial AND FechaFinal AND Comprobante_ = 0  AND v.Estado = Estado_ and opcion = 0
		)
	
	order by v.FechaVenta desc ,v.HoraVenta desc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_ventas_detalle_by_id` (`IdVenta_` VARCHAR(12))  begin
	select /*ROW_NUMBER() over( order by d.IdArticulo desc) as Filas ,*/
	a.IdSuministro,a.Clave,a.NombreMarca,a.Inventario,a.ValorInventario,
	dbo.Fc_Obtener_Nombre_Detalle(a.UnidadCompra,'0013') as UnidadCompra,	
	d.Cantidad,d.CantidadGranel,d.CostoVenta,d.PrecioVenta,
	d.Descuento,d.DescuentoCalculado,d.IdImpuesto,d.NombreImpuesto,d.ValorImpuesto,d.Importe
	from DetalleVentaTB as d inner join SuministroTB as a on d.IdArticulo = a.IdSuministro
	where d.IdVenta = IdVenta_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_ventas_mostrar` (`search` VARCHAR(100))  begin
	Select
		v.IdVenta,
		v.FechaVenta,
		v.HoraVenta,
		m.Simbolo,
		v.Total,
		v.Codigo
		from VentaTB as v 
		inner join MonedaTB as m on v.Moneda = m.IdMoneda
		where 
		Codigo like search+'%' and search <> '' 		
	   order by v.FechaVenta desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_table_detalle` (IN `IdMantenimiento_` VARCHAR(10), IN `Nombre_` VARCHAR(60))  begin
	select IdDetalle,IdAuxiliar,Nombre,Descripcion,Estado from DetalleTB 
		where (IdMantenimiento = IdMantenimiento_ and Nombre_ = '') 
		or (IdMantenimiento = IdMantenimiento_ and Nombre like Nombre_+'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_table_matenimiento` (`Nombre_` VARCHAR(100))  begin
	select IdMantenimiento,Nombre,Validar from MantenimientoTB 
		where 
		(Nombre like Nombre_+'%' and Estado <> '0')
		or (Nombre_ = '' and Estado <> '0');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_compra_byid` (`IdCompra_` VARCHAR(12))  begin
	select c.FechaCompra, c.HoraCompra,c.Comprobante, c.Serie,c.Numeracion,
	m.Nombre,m.Simbolo,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(c.TipoCompra,'0015') as Tipo,
	c.EstadoCompra,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') as Estado,
	c.Total,c.Observaciones,c.Notas
	from CompraTB as c inner join MonedaTB as m on c.TipoMoneda = m.IdMoneda
	where c.IdCompra = IdCompra_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_proveedor_byidcompra` (`IdCompra_` VARCHAR(12))  begin
	select p.IdProveedor,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(p.TipoDocumento,'0003') as NombreDocumento,
	p.NumeroDocumento,p.RazonSocial as Proveedor,p.Telefono,p.Celular,p.Direccion,p.Email 
                        from CompraTB as c inner join ProveedorTB as p
                        on c.Proveedor = p.IdProveedor
                        where c.IdCompra = IdCompra_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_venta_byid` (`idVenta_` VARCHAR(12))  begin
	select  v.FechaVenta,v.HoraVenta,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(c.TipoDocumento,'0003') as NombreDocumento,
		c.NumeroDocumento,c.Informacion,c.Direccion,
		t.Nombre as Comprobante,t.NombreImpresion,
		v.Serie,v.Numeracion,v.Observaciones,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') Estado,
		m.Nombre,m.Abreviado,m.Simbolo,v.Efectivo,v.Vuelto,v.Total,v.Codigo
        from VentaTB as v inner join MonedaTB as m on v.Moneda = m.IdMoneda
		inner join ClienteTB as c on v.Cliente = c.IdCliente
		inner join TipoDocumentoTB as t on v.Comprobante = t.IdTipoDocumento
        where v.IdVenta = idVenta_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_general_compras` (`FechaInicial` VARCHAR(20), `FechaFinal` VARCHAR(20), `Proveedor` VARCHAR(12), `TipoCompra_` INT)  begin
	select c.FechaCompra,p.RazonSocial as Proveedor,c.Serie,c.Numeracion,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(c.TipoCompra,'0015') Tipo,c.EstadoCompra,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(c.EstadoCompra,'0009') EstadoName,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Simbolo_Moneda(c.TipoMoneda) as Simbolo,c.Total 
	from CompraTB as c inner join ProveedorTB as p on c.Proveedor = p.IdProveedor

	where
	(FechaCompra BETWEEN FechaInicial AND FechaFinal AND Proveedor ='' AND TipoCompra_ = 0)
	or
	(FechaCompra BETWEEN FechaInicial AND FechaFinal AND p.IdProveedor = Proveedor AND TipoCompra_ = 0)
	or
	(FechaCompra BETWEEN FechaInicial AND FechaFinal AND Proveedor ='' AND c.TipoCompra = TipoCompra_)
	or
	(FechaCompra BETWEEN FechaInicial AND FechaFinal AND p.IdProveedor = Proveedor AND TipoCompra_ = 0)
	or
	(FechaCompra BETWEEN FechaInicial AND FechaFinal AND Proveedor = 0 AND c.TipoCompra = TipoCompra_)
	or
	(FechaCompra BETWEEN FechaInicial AND FechaFinal AND p.IdProveedor = Proveedor AND c.TipoCompra = TipoCompra_)
	
	order by c.FechaCompra desc,c.HoraCompra desc;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_general_ventas` (`FechaInicial` VARCHAR(20), `FechaFinal` VARCHAR(20), `TipoDocumento` INT, `Cliente` VARCHAR(12), `Empleado` VARCHAR(12))  begin
	select td.Nombre,v.FechaVenta,c.Informacion as Cliente,v.Serie,v.Numeracion,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(v.Tipo,'0015') Tipo,v.Estado,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(v.Estado,'0009') EstadoName,
	puntoventasyssoftdbdesarrollo.Fc_Obtener_Simbolo_Moneda(v.Moneda) as Simbolo,v.Total 
	from VentaTB as v inner join TipoDocumentoTB as td on v.Comprobante = td.IdTipoDocumento
	inner join ClienteTB as c on v.Cliente = c.IdCliente
	inner join EmpleadoTB as e on v.Vendedor = e.IdEmpleado
	where
	(FechaVenta BETWEEN FechaInicial AND FechaFinal AND TipoDocumento = 0 AND Cliente ='' AND Empleado = '')
	or
	(
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND td.IdTipoDocumento = TipoDocumento AND Cliente ='' AND Empleado = ''
		or
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND td.IdTipoDocumento = TipoDocumento AND c.IdCliente = Cliente AND Empleado = ''
		or
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND td.IdTipoDocumento = TipoDocumento AND Cliente ='' AND e.IdEmpleado = Empleado
		or
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND td.IdTipoDocumento = TipoDocumento AND c.IdCliente = Cliente AND e.IdEmpleado = Empleado
	)
	or
	(
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND TipoDocumento = 0 AND c.IdCliente = Cliente AND Empleado = ''
		or
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND td.IdTipoDocumento = TipoDocumento AND c.IdCliente = Cliente AND Empleado = ''
		or
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND TipoDocumento = 0 AND c.IdCliente = Cliente AND e.IdEmpleado = Empleado
		or
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND td.IdTipoDocumento = TipoDocumento AND c.IdCliente = Cliente AND e.IdEmpleado = Empleado
	)
	or
	(
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND TipoDocumento = 0 AND Cliente ='' AND e.IdEmpleado = Empleado  
		or
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND td.IdTipoDocumento = TipoDocumento AND Cliente ='' AND e.IdEmpleado = Empleado 
		or
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND TipoDocumento = 0 AND c.IdCliente = Cliente AND e.IdEmpleado = Empleado 
		or
		FechaVenta BETWEEN FechaInicial AND FechaFinal AND td.IdTipoDocumento = TipoDocumento AND c.IdCliente = Cliente AND e.IdEmpleado = Empleado 
	)
	order by v.FechaVenta desc,v.HoraVenta desc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_ventas_sumadas_por_fecha` (`FechaInicial` VARCHAR(20), `FechaFinal` VARCHAR(20), `TipoOrden` BIT, `Orden` BIT)  begin
	select FechaVenta,
 Estado,
 puntoventasyssoftdbdesarrollo.Fc_Obtener_Simbolo_Moneda(Moneda) as Simbolo,
 Total from VentaTB
where
 FechaVenta BETWEEN FechaInicial AND FechaFinal 
ORDER BY 
CASE WHEN TipoOrden = 0 AND Orden = 0 THEN FechaVenta END ASC,
CASE WHEN TipoOrden = 0 AND Orden = 1 THEN FechaVenta END DESC,
CASE WHEN TipoOrden = 1 AND Orden = 0 THEN Total END ASC,
CASE WHEN TipoOrden = 1 AND Orden = 1 THEN Total END desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_suministro_by_id` (`IdSuministro_` VARCHAR(45))  begin
	select IdSuministro,Origen,Clave,ClaveAlterna,NombreMarca,NombreGenerico,
		Categoria,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Categoria,'0006') as CategoriaNombre,
		Marca,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Marca,'0007') as MarcaNombre,
		Presentacion,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(Presentacion,'0008') as PresentacionNombre,
		UnidadCompra,
		puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Detalle(UnidadCompra,'0013') as UnidadCompraNombre,
		UnidadVenta,
		StockMinimo,StockMaximo,Cantidad,PrecioCompra,PrecioVentaGeneral,PrecioMargenGeneral,PrecioUtilidadGeneral,
		Estado,Lote,Inventario,ValorInventario,Imagen,
		Impuesto,dbo.Fc_Obtener_Nombre_Impuesto(Impuesto) as ImpuestoNombre,
		ClaveSat,TipoPrecio
		from SuministroTB
		where IdSuministro=IdSuministro_ or Clave = IdSuministro_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validar_ingreso` (`usuario_` VARCHAR(100), `clave_` VARCHAR(100))  begin
	select idempleado ,apellidos ,nombres,puntoventasyssoftdbdesarrollo.Fc_Obtener_Nombre_Rol(rol) as RolName,estado ,rol 
	from empleadotb where usuario = usuario_ and clave = clave_ and estado =1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp__Listar_Compra_Credito_Abonar_Por_IdCompra` (IN `IdCompra_` VARCHAR(12))  NO SQL
select IdCompraCredito,Monto,FechaRegistro,fechaPago,Estado from CompraCreditoTB 
		where IdCompra = IdCompra_$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fc_articulo_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
	declare Incremental int;
	declare ValorActual varchar(12);
	declare ValorNuevo varchar(12);
	declare CodGenerado varchar(12);
				if exists (select IdArticulo from ArticuloTB) THEN										
				
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdArticulo,'AT',''),'','')AS INT)) from ArticuloTB);
						set Incremental = CAST(ValorActual as INT) +1;	
						if Incremental <= 9 then
								set CodGenerado = 'AT000'+ CAST(Incremental as VARCHAR(12));
						elseif Incremental>=10 and Incremental<=99 then 
						
							set CodGenerado = 'AT00'+CAST(Incremental as VARCHAR(12));
						elseif Incremental>=100 and Incremental<=999 then 
							
								set CodGenerado = 'AT0'+CAST(Incremental as VARCHAR(12));
						else
								set CodGenerado = 'AT'+CAST(Incremental as VARCHAR(12));
							
						end if;
				else
					
						set CodGenerado = 'AT0001';
					
				end if ;
			
			return CodGenerado;
	end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_asignacion_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
	declare Incremental int;
	declare ValorActual varchar(12);
	declare CodGenerado varchar(12);
			
				if EXISTS(select IdAsignacion from AsignacionTB) then
										
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdAsignacion,'AS',''),'','')AS INT)) from AsignacionTB);
						set Incremental = CAST(ValorActual as INT) +1 ;
						if(Incremental <= 9)then 
							
								set CodGenerado = 'AS000'+CAST(Incremental as VARCHAR(12));
							
						elseif(Incremental>=10 and Incremental<=99) then 
							
								set CodGenerado = 'AS00'+CAST(Incremental as VARCHAR(12));
							
						elseif(Incremental>=100 and Incremental<=999) then 
							
								set CodGenerado = 'AS0'+CAST(Incremental as VARCHAR(12));
							
						else
							
								set CodGenerado = 'AS'+CAST(Incremental as VARCHAR(12));
						end if;	
					
				else					
						set CodGenerado = 'AS0001';
				end if;
			
			return CodGenerado;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_banco_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
		declare Incremental int;
		declare ValorActual varchar(12);
		declare CodGenerado varchar(12);
	
		if EXISTS(select IdBanco from Banco) then
				set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdBanco,'BA',''),'','')AS INT)) from Banco);
				set Incremental = CAST(ValorActual as INT) +1;
				if(Incremental <= 9) THEN
							
								set CodGenerado = 'BA000'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=10 and Incremental<=99) then 
							
								set CodGenerado = 'BA00'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=100 and Incremental<=999) then 
							
								set CodGenerado = 'BA0'+CAST(Incremental as VARCHAR (12));
							
						else
							
								set CodGenerado = 'BA'+CAST(Incremental as VARCHAR (12));
						end if ;
		else
			set CodGenerado = 'BA0001';
		end if;
	return CodGenerado;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_caja_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
	declare Incremental int;
	declare ValorActual varchar(12);
	declare CodGenerado varchar(12); 

				if EXISTS(select IdCaja from CajaTB) THEN
										
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdCaja,'CJ',''),'','')AS INT)) from CajaTB);
						set Incremental = CAST(ValorActual as INT) +1;
						if(Incremental <= 9) THEN
							
								set CodGenerado = 'CJ000'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=10 and @Incremental<=99) then 
							
								set CodGenerado = 'CJ00'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=100 and @Incremental<=999) then 
							
								set CodGenerado = 'CJ0'+CAST(Incremental as VARCHAR (12));
							
						else
							
								set CodGenerado = 'CJ'+CAST(Incremental as VARCHAR (12));
							end if;
					
				else
					
						set CodGenerado = 'CJ0001';
					end if;
			
			return CodGenerado;
		
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_cliente_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
	declare Length int;
	declare Incremental int;
	declare ValorActual varchar(12);
	declare ValorNuevo varchar(12);
	declare CodGenerado varchar(12);

				if EXISTS(select IdCliente from ClienteTB) then 
										
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdCliente,'CL',''),'','')AS INT)) from ClienteTB);
						set Incremental = CAST(ValorActual as INT) +1;
						if(Incremental <= 9) then
							
								set CodGenerado = 'CL000'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=10 and Incremental<=99) then 
							
								set CodGenerado = 'CL00'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=100 and Incremental<=999) then 
							
								set CodGenerado = 'CL0'+CAST(Incremental as VARCHAR(12));
							
						else
							
								set CodGenerado = 'CL'+CAST(Incremental as VARCHAR (12));
							end if; 
				else 
					
						set CodGenerado = 'CL0001';
					
			   end if; 
			return CodGenerado;
		
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_compra_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
	declare Length int;
	declare Incremental int;
	declare ValorActual varchar(12);
	declare ValorNuevo varchar(12);
	declare CodGenerado varchar(12);

				if EXISTS(select IdCompra from CompraTB) then 
									
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdCompra,'CP',''),'','')AS INT)) from CompraTB);
						set Incremental = CAST(ValorActual as INT) +1;

						if(Incremental <= 9) then 
							
								set @CodGenerado = 'CP000'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=10 and Incremental<=99) then 
							
								set CodGenerado = 'CP00'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=100 and Incremental<=999)then 
							
								set CodGenerado = 'CP0'+CAST(Incremental as VARCHAR (12));
							
						else
							
								set CodGenerado = 'CP'+CAST(Incremental as VARCHAR (12));
							end if;
					
				else
					
						set CodGenerado = 'CP0001';
					end if;
			
			return CodGenerado;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_detalle_generar_codigo` () RETURNS VARCHAR(10) CHARSET utf8 begin
	declare NewCodigo varchar(10);
	declare CodGenerado int;
if exists(select * from DetalleTB where IdMantenimiento = Codigo) THEN
			
				set NewCodigo = (select Max(IdDetalle) from DetalleTB where IdMantenimiento = Codigo);
				set NewCodigo = CAST(NewCodigo as INT)+1 ; 
				if(NewCodigo  <= 9) then 
					
						set CodGenerado= NewCodigo;							
					
				elseif(NewCodigo >= 10 AND NewCodigo <= 99) then 
					
						set CodGenerado= NewCodigo;					
					
				elseif(NewCodigo >= 100 AND NewCodigo <= 999) then 
					
						set CodGenerado=NewCodigo;
					
				else
					
						set CodGenerado=NewCodigo;
					
			end	if;	
		else
			
				set CodGenerado = 1;
			end if; 
		return CodGenerado;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_empleado_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
	declare Length int;
	declare Incremental int;
	declare ValorActual varchar(12);
	declare ValorNuevo varchar(12); 
	declare CodGenerado varchar(12);

				if EXISTS(select IdEmpleado from EmpleadoTB) then 
										
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdEmpleado,'EM',''),'','')AS INT)) from EmpleadoTB);
						set Incremental = CAST(ValorActual as INT) +1 ;
						if(Incremental <= 9) THEN
							
								set CodGenerado = 'EM000'+CAST(Incremental as VARCHAR (12)); 
							
						elseif(Incremental>=10 and Incremental<=99) then 
							
								set CodGenerado = 'EM00'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=100 and Incremental<=999) then 
							
								set CodGenerado = 'EM0'+CAST(Incremental as VARCHAR (12));
							
						else
							
								set CodGenerado = 'EM'+CAST(Incremental as VARCHAR (12));
							
					end if;
				else
					
						set CodGenerado = 'EM0001';
					end if; 
			
			return CodGenerado;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_mantenimiento_generar_codigo` () RETURNS VARCHAR(10) CHARSET utf8 begin
	declare Codigo varchar(10);
	declare NewCodigo varchar(10);
if exists(select IdMantenimiento from MantenimientoTB)then 
					
						set Codigo = (select MAX(IdMantenimiento) from MantenimientoTB);
						set Codigo = CAST(Codigo as INT) +1;
						IF(Codigo  <= 9) then 
							 
								SET NewCodigo='000'+CAST(Codigo as VARCHAR (10));							
							
						ELSEIF(Codigo >= 10 AND Codigo <= 99)then 
							
								SET NewCodigo='00'+CAST(Codigo as VARCHAR (10));					
							
						ELSEIF(Codigo >= 100 AND Codigo <= 999)then 
							
								SET NewCodigo='0'+CAST(Codigo as VARCHAR (10));
							
						ELSE
							
								SET NewCodigo=''+CAST(Codigo as VARCHAR (10));
							
					end if;
				else 
					
						set Codigo =  '0001';
						set NewCodigo = Codigo;
					end if;

		return NewCodigo;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_movimientoinventario_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
declare Incremental int;
declare ValorActual varchar(12);
declare CodGenerado varchar(12); 

				if EXISTS(select IdMovimientoInventario from MovimientoInventarioTB) then 
										
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdMovimientoInventario,'IN',''),'','')AS INT)) from MovimientoInventarioTB);
						set Incremental = CAST(ValorActual as INT) +1;
						if(Incremental <= 9) THEN
							
								set CodGenerado = 'IN000'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=10 and Incremental<=99) then 
							
								set CodGenerado = 'IN00'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=100 and Incremental<=999) then 
						
								set CodGenerado = 'IN0'+CAST(Incremental as VARCHAR (12));
							
						else
							
								set CodGenerado = 'IN'+CAST(Incremental as VARCHAR (12)); 
							end if;
					
				else
					
						set CodGenerado = 'IN0001';
					end if;
			
			return CodGenerado;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_obtener_datos_empleado` (`idProveedor_` VARCHAR(12)) RETURNS VARCHAR(100) CHARSET utf8 begin
	declare datos varchar(100); 
		set datos=	(select Apellidos+' '+Nombres from EmpleadoTB where IdEmpleado = idProveedor_);
		return datos;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_obtener_datos_plazos` (`IdPlazos_` INT) RETURNS VARCHAR(15) CHARSET utf8 begin
		declare datos varchar(15);
		if exists(select Nombre from PlazosTB where IdPlazos = IdPlazos_)then 
			
				set datos= (select Nombre from PlazosTB where IdPlazos = IdPlazos_);
			
		else 
			
				set datos= 'DATOS NO ENCONTRADOS';
			end if;
		return datos;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_obtener_datos_proveedor` (`idProveedor_` VARCHAR(12)) RETURNS VARCHAR(100) CHARSET utf8 begin
	
		declare datos varchar(100);
		set datos=	(select RazonSocial from ProveedorTB where IdProveedor = idProveedor_);
		return datos;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_obtener_nombre_detalle` (`iddetalle_` INT, `idmantenimiento_` VARCHAR(10)) RETURNS VARCHAR(80) CHARSET utf8mb4 begin
	declare result varchar(80);
	set result = (select nombre from detalletb where iddetalle = iddetalle_  and idmantenimiento = idmantenimiento_);
	return result;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_obtener_nombre_impuesto` (`IdImpuesto_` INT) RETURNS VARCHAR(50) CHARSET utf8 begin
	
		DECLARE result VARCHAR(50);
			
				SET result = (SELECT Nombre FROM ImpuestoTB WHERE IdImpuesto = IdImpuesto_);	
		
			RETURN result;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_obtener_nombre_rol` (`IdRol_` INT) RETURNS VARCHAR(60) CHARSET utf8 begin
	
		DECLARE result VARCHAR(60);
			
				SET result = (SELECT Nombre FROM RolTB WHERE IdRol=IdRol_);	
			
			RETURN result;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_obtener_nombre_tipo_documento` (`IdTipoDocumento_` INT) RETURNS VARCHAR(100) CHARSET utf8 begin
	
		DECLARE Result VARCHAR(100);
			
				set Result = (SELECT Nombre FROM TipoDocumentoTB WHERE IdTipoDocumento = IdTipoDocumento_);	
			
			RETURN result;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_obtener_simbolo_moneda` (`IdMoneda_` INT) RETURNS VARCHAR(10) CHARSET utf8 begin
	
		DECLARE Result VARCHAR(10);
			
				set Result = (SELECT Simbolo FROM MonedaTB WHERE IdMoneda = IdMoneda_);	
			
			RETURN Result;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_proveedor_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
	
		declare Length int;
		declare Incremental int; 
		declare ValorActual varchar(12);
		declare ValorNuevo varchar(12); 
		declare CodGenerado varchar(12); 
			
				if EXISTS(select IdProveedor from ProveedorTB)then 
										
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdProveedor,'PR',''),'','')AS INT)) from ProveedorTB);
						set Incremental = CAST(ValorActual as INT) +1;
						if(Incremental <= 9)then 
							
								set CodGenerado = 'PR000'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=10 and Incremental<=99)then 
							
								set CodGenerado = 'PR00'+CAST(Incremental as VARCHAR (12)); 
							
						elseif(Incremental>=100 and Incremental<=999)then 
							
								set CodGenerado = 'PR0'+CAST(Incremental as VARCHAR (12));
							
						else
							
								set CodGenerado = 'PR'+CAST(Incremental as VARCHAR (12));
							end if;
					
				else
					
						set CodGenerado = 'PR0001';
					end if;
			
			return CodGenerado;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_rol_generar_codigo` () RETURNS INT(11) begin
	
		declare NewCodigo int;
		declare CodGenerado int;
		if exists(select * from RolTB) then 
			
				set NewCodigo = (select Max(IdRol) from RolTB);				
				set CodGenerado=NewCodigo+1;					
				
		else
			
				set CodGenerado = 1;
			end if;
		return CodGenerado;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_serie_numero` () RETURNS VARCHAR(40) CHARSET utf8 begin
	declare Serie varchar(10);
	declare Numeracion varchar(16);
	declare ResultNumeracion varchar(16);
	declare AuxNumeracion varchar(16);
	declare Aumentado int;
	set Serie = (select Serie from TipoDocumentoTB where IdTipoDocumento = IdTipoDocumento);
	set Numeracion = (select MAX(Numeracion) from ComprobanteTB where Serie = Serie);
	if (LEN(Numeracion)>0)then
		
			set AuxNumeracion = (select MAX(Numeracion) from ComprobanteTB  where Serie = Serie);
			set Aumentado = CAST(AuxNumeracion as INT) +1;
			set ResultNumeracion = '' +replicate ('0',(8 - LEN(Aumentado))) + CAST(Aumentado as VARCHAR (40));
		
		
	else
		
			set ResultNumeracion = '00000001';
			
		end if;
		
		return Serie+'-'+ResultNumeracion;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_suministro_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
	
		declare Incremental int;
		declare ValorActual varchar(12);
		declare CodGenerado varchar(12);
			
				if EXISTS(select IdSuministro from SuministroTB)then 
										
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdSuministro,'SM',''),'','')AS INT)) from SuministroTB);
						set Incremental = CAST(ValorActual as INT) +1;
						if(Incremental <= 9) THEN
							
								set CodGenerado = 'SM000'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=10 and Incremental<=99) then 
							
								set CodGenerado = 'SM00'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=100 and Incremental<=999) then 
							
								set CodGenerado = 'SM0'+CAST(Incremental as VARCHAR (12));
							
						else
							
								set CodGenerado = 'SM'+CAST(Incremental as VARCHAR (12));
						end if; 	
					ELSE					
						set CodGenerado = 'SM0001';
					end if;  
			
			return CodGenerado;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fc_venta_codigo_alfanumerico` () RETURNS VARCHAR(12) CHARSET utf8 begin
	declare Incremental int;
	declare ValorActual varchar(12);
	declare CodGenerado varchar(12);
			
				if EXISTS(select IdVenta from VentaTB)then 
									
						set ValorActual = (select MAX(CAST(REPLACE(REPLACE(IdVenta,'VT',''),'','')AS INT)) from VentaTB);
						set Incremental = CAST(ValorActual as INT) +1;
						if(Incremental <= 9) then 
							
								set CodGenerado = 'VT000'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=10 and Incremental<=99) then 
							
								set CodGenerado = 'VT00'+CAST(Incremental as VARCHAR (12));
							
						elseif(Incremental>=100 and Incremental<=999) then 
							
								set CodGenerado = 'VT0'+CAST(Incremental as VARCHAR (12)); 
							
						else
							
								set CodGenerado = 'VT'+CAST(Incremental as VARCHAR (12));
							
					end if;
				else
					
						set CodGenerado = 'VT0001';
					end if;
			
			return CodGenerado;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fx_obtener_cliente_by_id` (`Cliente_` VARCHAR(12)) RETURNS VARCHAR(60) CHARSET utf8 begin
	declare datos varchar(60);
		set datos=	(select Informacion from ClienteTB where IdCliente = Cliente_);
		return datos;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignaciondetalletb`
--

CREATE TABLE `asignaciondetalletb` (
  `idasignacion` varchar(12) NOT NULL,
  `idsuministro` varchar(12) NOT NULL,
  `cantidad` decimal(18,4) NOT NULL,
  `costo` decimal(18,4) NOT NULL,
  `precio` decimal(18,4) NOT NULL,
  `movimiento` decimal(18,4) NOT NULL,
  `estado` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignaciontb`
--

CREATE TABLE `asignaciontb` (
  `idasignacion` varchar(12) NOT NULL,
  `idarticulo` varchar(12) NOT NULL,
  `hora` date NOT NULL,
  `fecha` time NOT NULL,
  `cantidad` decimal(18,4) NOT NULL,
  `costo` decimal(18,4) NOT NULL,
  `precio` decimal(18,4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banco`
--

CREATE TABLE `banco` (
  `idbanco` varchar(12) NOT NULL,
  `nombrecuenta` varchar(80) NOT NULL,
  `numerocuenta` varchar(60) DEFAULT NULL,
  `idmoneda` int(11) NOT NULL,
  `saldoinicial` decimal(18,8) NOT NULL,
  `fechacreacion` date NOT NULL,
  `horacreacion` time NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `sistema` bit(1) DEFAULT NULL,
  `formapago` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bancohistorialtb`
--

CREATE TABLE `bancohistorialtb` (
  `idbanco` varchar(12) NOT NULL,
  `idbancohistorial` int(11) NOT NULL,
  `idempleado` varchar(12) DEFAULT NULL,
  `idprocedencia` varchar(12) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `entrada` decimal(18,8) NOT NULL,
  `salida` decimal(18,8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cajatb`
--

CREATE TABLE `cajatb` (
  `idcaja` varchar(12) NOT NULL,
  `fechaapertura` date DEFAULT NULL,
  `fechacierre` date DEFAULT NULL,
  `horaapertura` time DEFAULT NULL,
  `horacierre` time DEFAULT NULL,
  `estado` bit(1) DEFAULT NULL,
  `contado` decimal(18,4) DEFAULT NULL,
  `calculado` decimal(18,4) DEFAULT NULL,
  `diferencia` decimal(18,4) DEFAULT NULL,
  `idusuario` varchar(12) NOT NULL,
  `idbanco` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudadtb`
--

CREATE TABLE `ciudadtb` (
  `idciudad` int(11) NOT NULL,
  `paiscodigo` char(3) NOT NULL DEFAULT '',
  `departamento` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `ciudadtb`
--

INSERT INTO `ciudadtb` (`idciudad`, `paiscodigo`, `departamento`) VALUES
(1, 'PER', 'AMAZONAS'),
(2, 'PER', 'ANCASH'),
(3, 'PER', 'APURIMAC'),
(4, 'PER', '* TRIAL '),
(5, 'PER', 'AYACUCHO'),
(6, 'PER', 'CAJAMARCA'),
(7, 'PER', 'CALLAO'),
(8, 'PER', 'CUSCO'),
(9, 'PER', 'HUANCAVELICA'),
(10, 'PER', 'HUANUCO'),
(11, 'PER', 'ICA'),
(12, 'PER', 'JUNIN'),
(13, 'PER', 'LA LIBERTAD'),
(14, 'PER', 'LAMBAYEQUE'),
(15, 'PER', 'LIMA'),
(16, 'PER', 'LORETO'),
(17, 'PER', '* TRIAL * TRI'),
(18, 'PER', 'MOQUEGUA'),
(19, 'PER', 'PASCO'),
(20, 'PER', 'PIURA'),
(21, 'PER', 'PUNO'),
(22, 'PER', '* TRIAL * '),
(23, 'PER', 'TACNA'),
(24, 'PER', 'TUMBES'),
(25, 'PER', 'UCAYALI');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientetb`
--

CREATE TABLE `clientetb` (
  `idcliente` varchar(12) NOT NULL,
  `tipodocumento` int(11) NOT NULL,
  `numerodocumento` varchar(20) NOT NULL,
  `informacion` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `representante` varchar(200) DEFAULT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `clientetb`
--

INSERT INTO `clientetb` (`idcliente`, `tipodocumento`, `numerodocumento`, `informacion`, `telefono`, `celular`, `email`, `direccion`, `representante`, `estado`) VALUES
('CL0001', 1, '* TRIAL ', '* TRIAL * TRIAL', '', '', '', '', NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compracreditotb`
--

CREATE TABLE `compracreditotb` (
  `idcompra` varchar(12) NOT NULL,
  `idcompracredito` int(11) NOT NULL,
  `monto` decimal(18,2) NOT NULL,
  `fecharegistro` date NOT NULL,
  `horaregistro` time NOT NULL,
  `fechapago` date NOT NULL,
  `horapago` time NOT NULL,
  `estado` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compratb`
--

CREATE TABLE `compratb` (
  `idcompra` varchar(12) NOT NULL,
  `proveedor` varchar(12) NOT NULL,
  `comprobante` int(11) DEFAULT NULL,
  `serie` varchar(10) DEFAULT NULL,
  `numeracion` varchar(20) DEFAULT NULL,
  `tipomoneda` int(11) NOT NULL,
  `fechacompra` date NOT NULL,
  `horacompra` time NOT NULL,
  `fechavencimiento` date DEFAULT NULL,
  `horavencimiento` time DEFAULT NULL,
  `subtotal` decimal(18,8) NOT NULL,
  `descuento` decimal(18,8) DEFAULT NULL,
  `total` decimal(18,8) NOT NULL,
  `observaciones` varchar(300) DEFAULT NULL,
  `notas` varchar(300) DEFAULT NULL,
  `tipocompra` int(11) DEFAULT NULL,
  `estadocompra` int(11) DEFAULT NULL,
  `usuario` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobantetb`
--

CREATE TABLE `comprobantetb` (
  `idtipodocumento` int(11) DEFAULT NULL,
  `serie` varchar(10) NOT NULL,
  `numeracion` varchar(16) NOT NULL,
  `fecharegistro` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentasclientetb`
--

CREATE TABLE `cuentasclientetb` (
  `idcuentaclientes` int(11) NOT NULL,
  `idventa` varchar(12) NOT NULL,
  `idcliente` varchar(12) NOT NULL,
  `plazos` int(11) NOT NULL,
  `fechavencimiento` datetime NOT NULL,
  `montoinicial` decimal(18,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentashistorialclientetb`
--

CREATE TABLE `cuentashistorialclientetb` (
  `idcuentashistorialcliente` int(11) NOT NULL,
  `idcuentaclientes` int(11) NOT NULL,
  `abono` decimal(18,4) NOT NULL,
  `fechaabono` datetime NOT NULL,
  `referencia` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallecompratb`
--

CREATE TABLE `detallecompratb` (
  `idcompra` varchar(12) NOT NULL,
  `idarticulo` varchar(12) NOT NULL,
  `cantidad` decimal(18,8) NOT NULL,
  `preciocompra` decimal(18,8) NOT NULL,
  `descuento` decimal(18,8) DEFAULT NULL,
  `idimpuesto` int(11) DEFAULT NULL,
  `nombreimpuesto` varchar(12) DEFAULT NULL,
  `valorimpuesto` decimal(18,2) DEFAULT NULL,
  `impuestosumado` decimal(18,8) DEFAULT NULL,
  `importe` decimal(18,8) NOT NULL,
  `descripcion` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalletb`
--

CREATE TABLE `detalletb` (
  `iddetalle` int(11) NOT NULL,
  `idmantenimiento` varchar(10) NOT NULL,
  `idauxiliar` varchar(10) DEFAULT NULL,
  `nombre` varchar(60) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `estado` char(1) NOT NULL,
  `usuarioregistro` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalletb`
--

INSERT INTO `detalletb` (`iddetalle`, `idmantenimiento`, `idauxiliar`, `nombre`, `descripcion`, `estado`, `usuarioregistro`) VALUES
(1, '0001', '', 'ACTIVO', 'EL ESTADO ACTIVO HACE QUE EL ELEMENTO SE PUEDA VISUALIZAR O PODER ACCEDER A ELLA', '1', '76423388'),
(1, '0002', '', 'TELEFONO', '', '1', '76423388'),
(1, '0003', '', 'DNI', '', '1', '76423388'),
(1, '0004', '', 'MASCULINO', '', '1', '76423388'),
(1, '0006', '', 'PRINCIPAL', '', '1', '76423388'),
(1, '0009', '', 'PAGADO', '', '1', '76423388'),
(1, '0010', '', 'OP. GRAVADA', '', '1', '76423388'),
(1, '0011', '', 'ABARROTES', '', '1', '76423388'),
(1, '0012', '', 'ADMINISTRADOR', '', '1', '76423388'),
(1, '0014', '', 'DEP. ABARROTES', '', '1', '76423388'),
(1, '0015', '', 'CONTADO', '', '1', '76423388'),
(1, '0016', '', 'COMPRA', '', '1', '76423388'),
(2, '0001', '', 'INACTIVO', 'EL ESTADO INACTIVO HACE QUE EL ELEMENTO NO SE PUEDA VISUALIZAR O ACCEDER A ELLA', '1', '76423388'),
(2, '0002', '', 'CELULAR', 'NÚMERO DE CELULAR', '1', '76423388'),
(2, '0003', '', 'PASAPORTE', 'DOCUMENTO QUE ACREDITA LA IDENTIDAD Y LA NACIONALIDAD DE UNA PERSONA Y QUE ES NECESARIO PARA VIAJAR ', '1', '76423388'),
(2, '0004', '', 'FEMENINO', '', '1', '76423388'),
(2, '0008', '', 'CAJA', '', '1', '76423388'),
(2, '0009', '', 'PENDIENTE', '', '1', '76423388'),
(2, '0010', '', 'OP. INAFECTA', '', '1', '76423388'),
(2, '0011', '', 'BOUTIQUE - ROPA', '', '1', '76423388'),
(2, '0012', '', 'VENDEDOR', '', '1', '76423388'),
(2, '0015', '', 'CREDITO', '', '1', '76423388'),
(2, '0016', '', 'PRODUCCIÓN', '', '1', '76423388'),
(3, '0002', '', 'EMAIL', 'CORREO ELECTRONICO PARA EL ENVÍO DE PROMOCIONES O OTROS ASUNTOS', '1', '76423388'),
(3, '0003', '', 'RUC', 'NÚMERO QUE IDENTIFICA A UNA EMPRESA A NIVEL NACIONAL', '1', '76423388'),
(3, '0009', '', 'OP. EXONERADA', '', '1', '76423388'),
(3, '0010', '', 'OP. EXONERADA', '', '1', '76423388'),
(3, '0011', '', 'CAFETERÍA', '', '1', '76423388'),
(3, '0015', '', 'GUARDADO', '', '1', '76423388'),
(3, '0016', '', 'DIRECCIÓN', '', '1', '76423388'),
(4, '0002', '', 'DIRECCIÓN', '', '1', '76423388'),
(4, '0003', '', 'CARNET DE EXTRANJERIA', 'DOCUMENTO QUE VALIDA LA NACIONALIDAD DE LA PERSONA', '1', '76423388'),
(4, '0005', '', 'SECTOR PÚBLICO', '', '1', '76423388'),
(4, '0009', '', 'GUARDADO', '', '1', '76423388'),
(4, '0011', '', 'CARNICERÍA', '', '1', '76423388'),
(5, '0003', '', 'PART. DE NACIMIENTO-IDENTIDAD', 'DOCUMENTO QUE INDENTIFICA AL CIUDADANO', '1', '76423388'),
(5, '0011', '', 'CIBER', '', '1', '76423388'),
(6, '0011', '', 'DULCERÍA', '', '1', '76423388'),
(7, '0011', '', 'ELECTRÓNICA', '', '1', '76423388'),
(8, '0011', '', 'FARMACIA', '', '1', '76423388'),
(9, '0011', '', 'FERRETERÍA', '', '1', '76423388'),
(10, '0011', '', 'LIBRERÍA', '', '1', '76423388'),
(11, '0011', '', 'LICORERÍA', '', '1', '76423388'),
(12, '0011', '', 'JUGUETERÍA', '', '1', '76423388'),
(13, '0011', '', 'JOYERÍA', '', '1', '76423388'),
(14, '0011', '', 'LIMPIEZA', '', '1', '76423388'),
(15, '0011', '', 'PLASTICOS', '', '1', '76423388'),
(16, '0011', '', 'TIENDA NATURISTA', '', '1', '76423388'),
(17, '0011', '', 'MINIMARKET', '', '1', '76423388'),
(18, '0011', '', 'ZAPATERÍA', '', '1', '76423388'),
(19, '0011', '', 'OTRO', '', '1', '76423388'),
(58, '0013', 'NIU', 'UNIDAD(ES)', '', '1', '76423388');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleventatb`
--

CREATE TABLE `detalleventatb` (
  `idventa` varchar(12) NOT NULL,
  `idarticulo` varchar(12) NOT NULL,
  `cantidad` decimal(18,8) NOT NULL,
  `cantidadgranel` decimal(18,8) DEFAULT NULL,
  `costoventa` decimal(18,8) DEFAULT NULL,
  `precioventa` decimal(18,8) NOT NULL,
  `descuento` decimal(18,8) NOT NULL,
  `descuentocalculado` decimal(18,8) DEFAULT NULL,
  `idoperacion` int(11) DEFAULT NULL,
  `idimpuesto` int(11) DEFAULT NULL,
  `nombreimpuesto` varchar(12) DEFAULT NULL,
  `valorimpuesto` decimal(18,2) DEFAULT NULL,
  `importe` decimal(18,8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `directoriotb`
--

CREATE TABLE `directoriotb` (
  `iddirectorio` bigint(20) NOT NULL,
  `atributo` int(11) NOT NULL,
  `valor` varchar(100) NOT NULL,
  `idpersona` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `distritotb`
--

CREATE TABLE `distritotb` (
  `iddistrito` int(11) NOT NULL DEFAULT 0,
  `distrito` varchar(50) DEFAULT NULL,
  `idprovincia` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `distritotb`
--

INSERT INTO `distritotb` (`iddistrito`, `distrito`, `idprovincia`) VALUES
(1, 'CHACHAPOYAS', 1),
(2, '* TRIAL ', 1),
(3, 'BALSAS', 1),
(4, 'CHETO', 1),
(5, '* TRIAL *', 1),
(6, '* TRIAL * T', 1),
(7, 'GRANADA', 1),
(8, 'HUANCAS', 1),
(9, 'LA JALCA', 1),
(10, 'LEIMEBAMBA', 1),
(11, 'LEVANTO', 1),
(12, 'MAGDALENA', 1),
(13, '* TRIAL * TRIAL *', 1),
(14, '* TRIAL * T', 1),
(15, 'MONTEVIDEO', 1),
(16, 'OLLEROS', 1),
(17, '* TRIAL *', 1),
(18, 'SAN FRANCISCO DE DAGUAS', 1),
(19, 'SAN ISIDRO DE MAINO', 1),
(20, 'SOLOCO', 1),
(21, 'SONCHE', 1),
(22, 'LA PECA', 2),
(23, 'ARAMANGO', 2),
(24, '* TRIAL ', 2),
(25, 'EL PARCO', 2),
(26, 'IMAZA', 2),
(27, 'JUMBILLA', 3),
(28, 'CHISQUILLA', 3),
(29, 'CHURUJA', 3),
(30, 'COROSHA', 3),
(31, 'CUISPES', 3),
(32, 'FLORIDA', 3),
(33, 'JAZAN', 3),
(34, 'RECTA', 3),
(35, 'SAN CARLOS', 3),
(36, '* TRIAL * T', 3),
(37, 'VALERA', 3),
(38, 'YAMBRASBAMBA', 3),
(39, 'NIEVA', 4),
(40, '* TRIAL *', 4),
(41, 'RIO SANTIAGO', 4),
(42, 'LAMUD', 5),
(43, '* TRIAL * TRI', 5),
(44, 'COCABAMBA', 5),
(45, '* TRIAL ', 5),
(46, 'CONILA', 5),
(47, 'INGUILPATA', 5),
(48, 'LONGUITA', 5),
(49, '* TRIAL * T', 5),
(50, 'LUYA', 5),
(51, '* TRIAL * ', 5),
(52, 'MARIA', 5),
(53, 'OCALLI', 5),
(54, 'OCUMAL', 5),
(55, '* TRIAL ', 5),
(56, 'PROVIDENCIA', 5),
(57, 'SAN CRISTOBAL', 5),
(58, '* TRIAL * TRIAL * TRIA', 5),
(59, 'SAN JERONIMO', 5),
(60, 'SAN JUAN DE LOPECANCHA', 5),
(61, 'SANTA CATALINA', 5),
(62, 'SANTO TOMAS', 5),
(63, 'TINGO', 5),
(64, 'TRITA', 5),
(65, 'SAN NICOLAS', 6),
(66, 'CHIRIMOTO', 6),
(67, 'COCHAMAL', 6),
(68, 'HUAMBO', 6),
(69, 'LIMABAMBA', 6),
(70, 'LONGAR', 6),
(71, '* TRIAL * TRIAL * ', 6),
(72, 'MILPUC', 6),
(73, 'OMIA', 6),
(74, '* TRIAL * ', 6),
(75, 'TOTORA', 6),
(76, 'VISTA ALEGRE', 6),
(77, 'BAGUA GRANDE', 7),
(78, 'CAJARURO', 7),
(79, 'CUMBA', 7),
(80, '* TRIAL * ', 7),
(81, 'JAMALCA', 7),
(82, 'LONYA GRANDE', 7),
(83, 'YAMON', 7),
(84, 'HUARAZ', 8),
(85, 'COCHABAMBA', 8),
(86, 'COLCABAMBA', 8),
(87, '* TRIAL ', 8),
(88, 'INDEPENDENCIA', 8),
(89, 'JANGAS', 8),
(90, 'LA LIBERTAD', 8),
(91, 'OLLEROS', 8),
(92, 'PAMPAS', 8),
(93, 'PARIACOTO', 8),
(94, 'PIRA', 8),
(95, 'TARICA', 8),
(96, 'AIJA', 9),
(97, 'CORIS', 9),
(98, 'HUACLLAN', 9),
(99, '* TRIAL *', 9),
(100, 'SUCCHA', 9),
(101, '* TRIAL *', 10),
(102, 'ACZO', 10),
(103, 'CHACCHO', 10),
(104, 'CHINGAS', 10),
(105, 'MIRGAS', 10),
(106, 'SAN JUAN DE RONTOY', 10),
(107, 'CHACAS', 11),
(108, 'ACOCHACA', 11),
(109, 'CHIQUIAN', 12),
(110, 'ABELARDO PARDO LEZAMETA', 12),
(111, 'ANTONIO RAYMONDI', 12),
(112, 'AQUIA', 12),
(113, 'CAJACAY', 12),
(114, 'CANIS', 12),
(115, '* TRIAL ', 12),
(116, 'HUALLANCA', 12),
(117, 'HUASTA', 12),
(118, 'HUAYLLACAYAN', 12),
(119, '* TRIAL * TR', 12),
(120, 'MANGAS', 12),
(121, 'PACLLON', 12),
(122, 'SAN MIGUEL DE CORPANQUI', 12),
(123, 'TICLLOS', 12),
(124, 'CARHUAZ', 13),
(125, 'ACOPAMPA', 13),
(126, 'AMASHCA', 13),
(127, 'ANTA', 13),
(128, 'ATAQUERO', 13),
(129, 'MARCARA', 13),
(130, 'PARIAHUANCA', 13),
(131, 'SAN MIGUEL DE ACO', 13),
(132, 'SHILLA', 13),
(133, 'TINCO', 13),
(134, 'YUNGAR', 13),
(135, 'SAN LUIS', 14),
(136, 'SAN NICOLAS', 14),
(137, 'YAUYA', 14),
(138, 'CASMA', 15),
(139, '* TRIAL * TRIAL ', 15),
(140, 'COMANDANTE NOEL', 15),
(141, 'YAUTAN', 15),
(142, 'CORONGO', 16),
(143, 'ACO', 16),
(144, 'BAMBAS', 16),
(145, 'CUSCA', 16),
(146, '* TRIAL ', 16),
(147, 'YANAC', 16),
(148, 'YUPAN', 16),
(149, 'HUARI', 17),
(150, 'ANRA', 17),
(151, 'CAJAY', 17),
(152, 'CHAVIN DE HUANTAR', 17),
(153, 'HUACACHI', 17),
(154, 'HUACCHIS', 17),
(155, 'HUACHIS', 17),
(156, 'HUANTAR', 17),
(157, 'MASIN', 17),
(158, 'PAUCAS', 17),
(159, 'PONTO', 17),
(160, 'RAHUAPAMPA', 17),
(161, 'RAPAYAN', 17),
(162, 'SAN MARCOS', 17),
(163, '* TRIAL * TRIAL * ', 17),
(164, 'UCO', 17),
(165, 'HUARMEY', 18),
(166, 'COCHAPETI', 18),
(167, '* TRIAL ', 18),
(168, 'HUAYAN', 18),
(169, 'MALVAS', 18),
(170, 'CARAZ', 26),
(171, 'HUALLANCA', 26),
(172, 'HUATA', 26),
(173, 'HUAYLAS', 26),
(174, 'MATO', 26),
(175, 'PAMPAROMAS', 26),
(176, '* TRIAL * TR', 26),
(177, 'SANTA CRUZ', 26),
(178, 'SANTO TORIBIO', 26),
(179, 'YURACMARCA', 26),
(180, 'PISCOBAMBA', 27),
(181, 'CASCA', 27),
(182, 'ELEAZAR GUZMAN BARRON', 27),
(183, '* TRIAL * TRIAL * TRI', 27),
(184, 'LLAMA', 27),
(185, 'LLUMPA', 27),
(186, 'LUCMA', 27),
(187, 'MUSGA', 27),
(188, 'OCROS', 21),
(189, 'ACAS', 21),
(190, 'CAJAMARQUILLA', 21),
(191, 'CARHUAPAMPA', 21),
(192, 'COCHAS', 21),
(193, 'CONGAS', 21),
(194, 'LLIPA', 21),
(195, 'SAN CRISTOBAL DE RAJAN', 21),
(196, 'SAN PEDRO', 21),
(197, 'SANTIAGO DE CHILCAS', 21),
(198, 'CABANA', 22),
(199, 'BOLOGNESI', 22),
(200, '* TRIAL *', 22),
(201, '* TRIAL * TR', 22),
(202, 'HUANDOVAL', 22),
(203, 'LACABAMBA', 22),
(204, 'LLAPO', 22),
(205, 'PALLASCA', 22),
(206, 'PAMPAS', 22),
(207, '* TRIAL * ', 22),
(208, 'TAUCA', 22),
(209, 'POMABAMBA', 23),
(210, '* TRIAL ', 23),
(211, 'PAROBAMBA', 23),
(212, 'QUINUABAMBA', 23),
(213, 'RECUAY', 24),
(214, 'CATAC', 24),
(215, 'COTAPARACO', 24),
(216, 'HUAYLLAPAMPA', 24),
(217, 'LLACLLIN', 24),
(218, 'MARCA', 24),
(219, 'PAMPAS CHICO', 24),
(220, 'PARARIN', 24),
(221, '* TRIAL *', 24),
(222, 'TICAPAMPA', 24),
(223, '* TRIAL ', 25),
(224, 'CACERES DEL PERU', 25),
(225, 'COISHCO', 25),
(226, 'MACATE', 25),
(227, 'MORO', 25),
(228, '* TRIAL * TRI', 25),
(229, 'SAMANCO', 25),
(230, 'SANTA', 25),
(231, 'NUEVO CHIMBOTE', 25),
(232, 'SIHUAS', 26),
(233, 'ACOBAMBA', 26),
(234, '* TRIAL * TRIA', 26),
(235, '* TRIAL * ', 26),
(236, 'CHINGALPO', 26),
(237, 'HUAYLLABAMBA', 26),
(238, 'QUICHES', 26),
(239, 'RAGASH', 26),
(240, 'SAN JUAN', 26),
(241, '* TRIAL * ', 26),
(242, 'YUNGAY', 27),
(243, 'CASCAPARA', 27),
(244, 'MANCOS', 27),
(245, '* TRIAL ', 27),
(246, 'QUILLO', 27),
(247, 'RANRAHIRCA', 27),
(248, 'SHUPLUY', 27),
(249, 'YANAMA', 27),
(250, 'ABANCAY', 28),
(251, 'CHACOCHE', 28),
(252, 'CIRCA', 28),
(253, '* TRIAL *', 28),
(254, '* TRIAL *', 28),
(255, 'LAMBRAMA', 28),
(256, '* TRIAL *', 28),
(257, '* TRIAL * TRIAL * TR', 28),
(258, 'TAMBURCO', 28),
(259, 'ANDAHUAYLAS', 29),
(260, 'ANDARAPA', 29),
(261, 'CHIARA', 29),
(262, 'HUANCARAMA', 29),
(263, 'HUANCARAY', 29),
(264, 'HUAYANA', 29),
(265, 'KISHUARA', 29),
(266, 'PACOBAMBA', 29),
(267, 'PACUCHA', 29),
(268, 'PAMPACHIRI', 29),
(269, 'POMACOCHA', 29),
(270, 'SAN ANTONIO DE CACHI', 29),
(271, '* TRIAL * TR', 29),
(272, 'SAN MIGUEL DE CHACCRAMPA', 29),
(273, '* TRIAL * TRIAL * TRI', 29),
(274, '* TRIAL ', 29),
(275, '* TRIAL * TRI', 29),
(276, 'TURPO', 29),
(277, '* TRIAL * T', 29),
(278, 'ANTABAMBA', 30),
(279, 'EL ORO', 30),
(280, 'HUAQUIRCA', 30),
(281, 'JUAN ESPINOZA MEDRANO', 30),
(282, 'OROPESA', 30),
(283, '* TRIAL * ', 30),
(284, 'SABAINO', 30),
(285, '* TRIAL * ', 31),
(286, 'CAPAYA', 31),
(287, 'CARAYBAMBA', 31),
(288, 'CHAPIMARCA', 31),
(289, 'COLCABAMBA', 31),
(290, 'COTARUSE', 31),
(291, 'HUAYLLO', 31),
(292, 'JUSTO APU SAHUARAURA', 31),
(293, 'LUCRE', 31),
(294, '* TRIAL * ', 31),
(295, 'SAN JUAN DE CHAC&Ntilde;A', 31),
(296, 'SAÑOS', 31),
(297, 'SORAYA', 31),
(298, 'TAPAIRIHUA', 31),
(299, 'TINTAY', 31),
(300, 'TORAYA', 31),
(301, 'YANACA', 31),
(302, '* TRIAL * ', 32),
(303, 'COTABAMBAS', 32),
(304, 'COYLLURQUI', 32),
(305, 'HAQUIRA', 32),
(306, 'MARA', 32),
(307, 'CHALLHUAHUACHO', 32),
(308, 'CHINCHEROS', 33),
(309, 'ANCO-HUALLO', 33),
(310, '* TRIAL *', 33),
(311, 'HUACCANA', 33),
(312, '* TRIAL ', 33),
(313, 'ONGOY', 33),
(314, 'URANMARCA', 33),
(315, 'RANRACANCHA', 33),
(316, 'CHUQUIBAMBILLA', 34),
(317, 'CURPAHUASI', 34),
(318, 'GAMARRA', 34),
(319, '* TRIAL *', 34),
(320, 'MAMARA', 34),
(321, 'MICAELA BASTIDAS', 34),
(322, 'PATAYPAMPA', 34),
(323, 'PROGRESO', 34),
(324, 'SAN ANTONIO', 34),
(325, '* TRIAL * ', 34),
(326, 'TURPAY', 34),
(327, 'VILCABAMBA', 34),
(328, 'VIRUNDO', 34),
(329, 'CURASCO', 34),
(330, 'AREQUIPA', 35),
(331, '* TRIAL * TRIAL *', 35),
(332, 'CAYMA', 35),
(333, '* TRIAL * TRIA', 35),
(334, 'CHARACATO', 35),
(335, 'CHIGUATA', 35),
(336, '* TRIAL * TRI', 35),
(337, 'LA JOYA', 35),
(338, 'MARIANO MELGAR', 35),
(339, 'MIRAFLORES', 35),
(340, 'MOLLEBAYA', 35),
(341, '* TRIAL * ', 35),
(342, 'POCSI', 35),
(343, 'POLOBAYA', 35),
(344, 'QUEQUE&Ntilde;A', 35),
(345, '* TRIAL ', 35),
(346, 'SACHACA', 35),
(347, 'SAN JUAN DE SIGUAS', 35),
(348, 'SAN JUAN DE TARUCANI', 35),
(349, 'SANTA ISABEL DE SIGUAS', 35),
(350, 'SANTA RITA DE SIGUAS', 35),
(351, 'SOCABAYA', 35),
(352, 'TIABAYA', 35),
(353, '* TRIAL ', 35),
(354, 'VITOR', 35),
(355, '* TRIAL *', 35),
(356, 'YARABAMBA', 35),
(357, 'YURA', 35),
(358, 'JOSE LUIS BUSTAMANTE Y RIVERO', 35),
(359, 'CAMANA', 36),
(360, 'JOSE MARIA QUIMPER', 36),
(361, 'MARIANO NICOLAS VALCARCEL', 36),
(362, 'MARISCAL CACERES', 36),
(363, 'NICOLAS DE PIEROLA', 36),
(364, 'OCO&Ntilde;A', 36),
(365, 'QUILCA', 36),
(366, 'SAMUEL PASTOR', 36),
(367, 'CARAVELI', 37),
(368, 'ACARI', 37),
(369, 'ATICO', 37),
(370, 'ATIQUIPA', 37),
(371, 'BELLA UNION', 37),
(372, 'CAHUACHO', 37),
(373, 'CHALA', 37),
(374, '* TRIAL ', 37),
(375, 'HUANUHUANU', 37),
(376, 'JAQUI', 37),
(377, 'LOMAS', 37),
(378, '* TRIAL ', 37),
(379, 'YAUCA', 37),
(380, 'APLAO', 38),
(381, 'ANDAGUA', 38),
(382, 'AYO', 38),
(383, 'CHACHAS', 38),
(384, 'CHILCAYMARCA', 38),
(385, 'CHOCO', 38),
(386, '* TRIAL * ', 38),
(387, 'MACHAGUAY', 38),
(388, 'ORCOPAMPA', 38),
(389, 'PAMPACOLCA', 38),
(390, 'TIPAN', 38),
(391, 'U&Ntilde;ON', 38),
(392, 'URACA', 38),
(393, 'VIRACO', 38),
(394, 'CHIVAY', 39),
(395, 'ACHOMA', 39),
(396, 'CABANACONDE', 39),
(397, 'CALLALLI', 39),
(398, 'CAYLLOMA', 39),
(399, 'COPORAQUE', 39),
(400, 'HUAMBO', 39),
(401, 'HUANCA', 39),
(402, '* TRIAL *', 39),
(403, 'LARI', 39),
(404, 'LLUTA', 39),
(405, 'MACA', 39),
(406, 'MADRIGAL', 39),
(407, 'SAN ANTONIO DE CHUCA', 39),
(408, 'SIBAYO', 39),
(409, 'TAPAY', 39),
(410, 'TISCO', 39),
(411, 'TUTI', 39),
(412, 'YANQUE', 39),
(413, 'MAJES', 39),
(414, 'CHUQUIBAMBA', 40),
(415, 'ANDARAY', 40),
(416, 'CAYARANI', 40),
(417, 'CHICHAS', 40),
(418, 'IRAY', 40),
(419, 'RIO GRANDE', 40),
(420, 'SALAMANCA', 40),
(421, '* TRIAL * ', 40),
(422, 'MOLLENDO', 41),
(423, 'COCACHACRA', 41),
(424, 'DEAN VALDIVIA', 41),
(425, 'ISLAY', 41),
(426, 'MEJIA', 41),
(427, 'PUNTA DE BOMBON', 41),
(428, 'COTAHUASI', 42),
(429, 'ALCA', 42),
(430, 'CHARCANA', 42),
(431, '* TRIAL * T', 42),
(432, 'PAMPAMARCA', 42),
(433, 'PUYCA', 42),
(434, '* TRIAL * ', 42),
(435, 'SAYLA', 42),
(436, 'TAURIA', 42),
(437, 'TOMEPAMPA', 42),
(438, 'TORO', 42),
(439, 'AYACUCHO', 43),
(440, 'ACOCRO', 43),
(441, 'ACOS VINCHOS', 43),
(442, '* TRIAL * T', 43),
(443, 'CHIARA', 43),
(444, 'OCROS', 43),
(445, 'PACAYCASA', 43),
(446, 'QUINUA', 43),
(447, '* TRIAL * TRIAL * T', 43),
(448, 'SAN JUAN BAUTISTA', 43),
(449, 'SANTIAGO DE PISCHA', 43),
(450, 'SOCOS', 43),
(451, '* TRIAL ', 43),
(452, 'VINCHOS', 43),
(453, '* TRIAL * TRIA', 43),
(454, '* TRIAL ', 44),
(455, 'CHUSCHI', 44),
(456, 'LOS MOROCHUCOS', 44),
(457, '* TRIAL * TRIAL * TRIAL', 44),
(458, 'PARAS', 44),
(459, 'TOTOS', 44),
(460, 'SANCOS', 45),
(461, 'CARAPO', 45),
(462, 'SACSAMARCA', 45),
(463, 'SANTIAGO DE LUCANAMARCA', 45),
(464, 'HUANTA', 46),
(465, 'AYAHUANCO', 46),
(466, 'HUAMANGUILLA', 46),
(467, 'IGUAIN', 46),
(468, 'LURICOCHA', 46),
(469, 'SANTILLANA', 46),
(470, 'SIVIA', 46),
(471, 'LLOCHEGUA', 46),
(472, '* TRIAL * ', 47),
(473, 'ANCO', 47),
(474, 'AYNA', 47),
(475, 'CHILCAS', 47),
(476, 'CHUNGUI', 47),
(477, 'LUIS CARRANZA', 47),
(478, 'SANTA ROSA', 47),
(479, 'TAMBO', 47),
(480, 'PUQUIO', 48),
(481, 'AUCARA', 48),
(482, 'CABANA', 48),
(483, 'CARMEN SALCEDO', 48),
(484, '* TRIAL * TRIA', 48),
(485, 'CHIPAO', 48),
(486, '* TRIAL *', 48),
(487, '* TRIAL ', 48),
(488, 'LEONCIO PRADO', 48),
(489, 'LLAUTA', 48),
(490, 'LUCANAS', 48),
(491, 'OCA&Ntilde;A', 48),
(492, 'OTOCA', 48),
(493, 'SAISA', 48),
(494, 'SAN CRISTOBAL', 48),
(495, 'SAN JUAN', 48),
(496, 'SAN PEDRO', 48),
(497, '* TRIAL * TRIAL * ', 48),
(498, 'SANCOS', 48),
(499, 'SANTA ANA DE HUAYCAHUACHO', 48),
(500, 'SANTA LUCIA', 48),
(501, '* TRIAL ', 49),
(502, 'CHUMPI', 49),
(503, '* TRIAL * TRIAL * TRIAL ', 49),
(504, 'PACAPAUSA', 49),
(505, 'PULLO', 49),
(506, 'PUYUSCA', 49),
(507, '* TRIAL * TRIAL * TRIAL * ', 49),
(508, 'UPAHUACHO', 49),
(509, 'PAUSA', 50),
(510, 'COLTA', 50),
(511, '* TRIAL ', 50),
(512, 'LAMPA', 50),
(513, '* TRIAL * ', 50),
(514, 'OYOLO', 50),
(515, 'PARARCA', 50),
(516, '* TRIAL * TRIAL * TRIAL', 50),
(517, 'SAN JOSE DE USHUA', 50),
(518, 'SARA SARA', 50),
(519, 'QUEROBAMBA', 51),
(520, 'BELEN', 51),
(521, 'CHALCOS', 51),
(522, 'CHILCAYOC', 51),
(523, 'HUACA&Ntilde;A', 51),
(524, 'MORCOLLA', 51),
(525, 'PAICO', 51),
(526, 'SAN PEDRO DE LARCAY', 51),
(527, '* TRIAL * TRIAL * TRI', 51),
(528, 'SANTIAGO DE PAUCARAY', 51),
(529, 'SORAS', 51),
(530, 'HUANCAPI', 52),
(531, 'ALCAMENCA', 52),
(532, 'APONGO', 52),
(533, '* TRIAL *', 52),
(534, 'CANARIA', 52),
(535, 'CAYARA', 52),
(536, 'COLCA', 52),
(537, '* TRIAL * TRI', 52),
(538, 'HUANCARAYLLA', 52),
(539, 'HUAYA', 52),
(540, 'SARHUA', 52),
(541, 'VILCANCHOS', 52),
(542, 'VILCAS HUAMAN', 53),
(543, 'ACCOMARCA', 53),
(544, 'CARHUANCA', 53),
(545, 'CONCEPCION', 53),
(546, 'HUAMBALPA', 53),
(547, 'INDEPENDENCIA', 53),
(548, 'SAURAMA', 53),
(549, 'VISCHONGO', 53),
(550, 'CAJAMARCA', 54),
(551, 'CAJAMARCA', 54),
(552, 'ASUNCION', 54),
(553, 'CHETILLA', 54),
(554, 'COSPAN', 54),
(555, 'ENCA&Ntilde;ADA', 54),
(556, 'JESUS', 54),
(557, 'LLACANORA', 54),
(558, 'LOS BA&Ntilde;OS DEL INCA', 54),
(559, 'MAGDALENA', 54),
(560, 'MATARA', 54),
(561, 'NAMORA', 54),
(562, '* TRIAL ', 54),
(563, 'CAJABAMBA', 55),
(564, 'CACHACHI', 55),
(565, '* TRIAL * ', 55),
(566, 'SITACOCHA', 55),
(567, 'CELENDIN', 56),
(568, 'CHUMUCH', 56),
(569, 'CORTEGANA', 56),
(570, 'HUASMIN', 56),
(571, 'JORGE CHAVEZ', 56),
(572, 'JOSE GALVEZ', 56),
(573, '* TRIAL * TRIAL', 56),
(574, 'OXAMARCA', 56),
(575, '* TRIAL *', 56),
(576, 'SUCRE', 56),
(577, 'UTCO', 56),
(578, '* TRIAL * TRIAL * TRI', 56),
(579, 'CHOTA', 57),
(580, 'ANGUIA', 57),
(581, 'CHADIN', 57),
(582, 'CHIGUIRIP', 57),
(583, 'CHIMBAN', 57),
(584, 'CHOROPAMPA', 57),
(585, 'COCHABAMBA', 57),
(586, 'CONCHAN', 57),
(587, 'HUAMBOS', 57),
(588, 'LAJAS', 57),
(589, 'LLAMA', 57),
(590, 'MIRACOSTA', 57),
(591, 'PACCHA', 57),
(592, 'PION', 57),
(593, 'QUEROCOTO', 57),
(594, 'SAN JUAN DE LICUPIS', 57),
(595, 'TACABAMBA', 57),
(596, 'TOCMOCHE', 57),
(597, 'CHALAMARCA', 57),
(598, '* TRIAL *', 58),
(599, 'CHILETE', 58),
(600, '* TRIAL * ', 58),
(601, 'GUZMANGO', 58),
(602, 'SAN BENITO', 58),
(603, 'SANTA CRUZ DE TOLED', 58),
(604, '* TRIAL *', 58),
(605, 'YONAN', 58),
(606, 'CUTERVO', 59),
(607, 'CALLAYUC', 59),
(608, 'CHOROS', 59),
(609, 'CUJILLO', 59),
(610, '* TRIAL *', 59),
(611, '* TRIAL *', 59),
(612, 'QUEROCOTILLO', 59),
(613, 'SAN ANDRES DE CUTERVO', 59),
(614, '* TRIAL * TRIAL * T', 59),
(615, 'SAN LUIS DE LUCMA', 59),
(616, 'SANTA CRUZ', 59),
(617, '* TRIAL * TRIAL * TRIAL * T', 59),
(618, 'SANTO TOMAS', 59),
(619, 'SOCOTA', 59),
(620, 'TORIBIO CASANOVA', 59),
(621, 'BAMBAMARCA', 60),
(622, 'CHUGUR', 60),
(623, 'HUALGAYOC', 60),
(624, 'JAEN', 61),
(625, '* TRIAL * ', 61),
(626, '* TRIAL ', 61),
(627, 'COLASAY', 61),
(628, 'HUABAL', 61),
(629, 'LAS PIRIAS', 61),
(630, 'POMAHUACA', 61),
(631, 'PUCARA', 61),
(632, 'SALLIQUE', 61),
(633, '* TRIAL * ', 61),
(634, 'SAN JOSE DEL ALTO', 61),
(635, 'SANTA ROSA', 61),
(636, 'SAN IGNACIO', 62),
(637, '* TRIAL ', 62),
(638, '* TRIAL ', 62),
(639, '* TRIAL ', 62),
(640, 'NAMBALLE', 62),
(641, 'SAN JOSE DE LOURDES', 62),
(642, 'TABACONAS', 62),
(643, 'PEDRO GALVEZ', 63),
(644, 'CHANCAY', 63),
(645, 'EDUARDO VILLANUEVA', 63),
(646, 'GREGORIO PITA', 63),
(647, 'ICHOCAN', 63),
(648, 'JOSE MANUEL QUIROZ', 63),
(649, 'JOSE SABOGAL', 63),
(650, 'SAN MIGUEL', 64),
(651, '* TRIAL * ', 64),
(652, 'BOLIVAR', 64),
(653, 'CALQUIS', 64),
(654, 'CATILLUC', 64),
(655, '* TRIAL ', 64),
(656, '* TRIAL * ', 64),
(657, 'LLAPA', 64),
(658, 'NANCHOC', 64),
(659, 'NIEPOS', 64),
(660, 'SAN GREGORIO', 64),
(661, '* TRIAL * TRIAL * TRIAL', 64),
(662, 'TONGOD', 64),
(663, '* TRIAL * TRIAL *', 64),
(664, 'SAN PABLO', 65),
(665, 'SAN BERNARDINO', 65),
(666, 'SAN LUIS', 65),
(667, 'TUMBADEN', 65),
(668, 'SANTA CRUZ', 66),
(669, 'ANDABAMBA', 66),
(670, 'CATACHE', 66),
(671, 'CHANCAYBA&Ntilde;OS', 66),
(672, '* TRIAL * TR', 66),
(673, 'NINABAMBA', 66),
(674, 'PULAN', 66),
(675, 'SAUCEPAMPA', 66),
(676, 'SEXI', 66),
(677, '* TRIAL ', 66),
(678, '* TRIAL ', 66),
(679, 'CALLAO', 67),
(680, 'BELLAVISTA', 67),
(681, '* TRIAL * TRIAL * TRIAL * ', 67),
(682, 'LA PERLA', 67),
(683, '* TRIAL ', 67),
(684, 'VENTANILLA', 67),
(685, 'CUSCO', 67),
(686, 'CCORCA', 67),
(687, 'POROY', 67),
(688, 'SAN JERONIMO', 67),
(689, 'SAN SEBASTIAN', 67),
(690, '* TRIAL ', 67),
(691, 'SAYLLA', 67),
(692, 'WANCHAQ', 67),
(693, 'ACOMAYO', 68),
(694, 'ACOPIA', 68),
(695, 'ACOS', 68),
(696, '* TRIAL * TR', 68),
(697, 'POMACANCHI', 68),
(698, 'RONDOCAN', 68),
(699, '* TRIAL *', 68),
(700, 'ANTA', 69),
(701, 'ANCAHUASI', 69),
(702, '* TRIAL *', 69),
(703, 'CHINCHAYPUJIO', 69),
(704, 'HUAROCONDO', 69),
(705, 'LIMATAMBO', 69),
(706, 'MOLLEPATA', 69),
(707, 'PUCYURA', 69),
(708, 'ZURITE', 69),
(709, 'CALCA', 70),
(710, 'COYA', 70),
(711, 'LAMAY', 70),
(712, 'LARES', 70),
(713, 'PISAC', 70),
(714, 'SAN SALVADOR', 70),
(715, 'TARAY', 70),
(716, 'YANATILE', 70),
(717, 'YANAOCA', 71),
(718, 'CHECCA', 71),
(719, 'KUNTURKANKI', 71),
(720, 'LANGUI', 71),
(721, 'LAYO', 71),
(722, 'PAMPAMARCA', 71),
(723, 'QUEHUE', 71),
(724, '* TRIAL * T', 71),
(725, 'SICUANI', 72),
(726, '* TRIAL *', 72),
(727, 'COMBAPATA', 72),
(728, 'MARANGANI', 72),
(729, 'PITUMARCA', 72),
(730, '* TRIAL *', 72),
(731, 'SAN PEDRO', 72),
(732, 'TINTA', 72),
(733, 'SANTO TOMAS', 73),
(734, 'CAPACMARCA', 73),
(735, 'CHAMACA', 73),
(736, '* TRIAL * T', 73),
(737, 'LIVITACA', 73),
(738, 'LLUSCO', 73),
(739, '* TRIAL * TRIA', 73),
(740, 'VELILLE', 73),
(741, 'ESPINAR', 74),
(742, '* TRIAL *', 74),
(743, '* TRIAL *', 74),
(744, 'OCORURO', 74),
(745, 'PALLPATA', 74),
(746, 'PICHIGUA', 74),
(747, '* TRIAL * T', 74),
(748, 'ALTO PICHIGUA', 74),
(749, 'SANTA ANA', 75),
(750, 'ECHARATE', 75),
(751, '* TRIAL *', 75),
(752, 'MARANURA', 75),
(753, 'OCOBAMBA', 75),
(754, 'QUELLOUNO', 75),
(755, 'KIMBIRI', 75),
(756, '* TRIAL * TR', 75),
(757, 'VILCABAMBA', 75),
(758, 'PICHARI', 75),
(759, 'PARURO', 76),
(760, 'ACCHA', 76),
(761, 'CCAPI', 76),
(762, 'COLCHA', 76),
(763, 'HUANOQUITE', 76),
(764, 'OMACHA', 76),
(765, 'PACCARITAMBO', 76),
(766, '* TRIAL *', 76),
(767, 'YAURISQUE', 76),
(768, 'PAUCARTAMBO', 77),
(769, 'CAICAY', 77),
(770, 'CHALLABAMBA', 77),
(771, '* TRIAL * ', 77),
(772, 'HUANCARANI', 77),
(773, '* TRIAL * TRIAL ', 77),
(774, 'URCOS', 78),
(775, 'ANDAHUAYLILLAS', 78),
(776, 'CAMANTI', 78),
(777, 'CCARHUAYO', 78),
(778, 'CCATCA', 78),
(779, 'CUSIPATA', 78),
(780, 'HUARO', 78),
(781, 'LUCRE', 78),
(782, 'MARCAPATA', 78),
(783, 'OCONGATE', 78),
(784, 'OROPESA', 78),
(785, 'QUIQUIJANA', 78),
(786, 'URUBAMBA', 79),
(787, 'CHINCHERO', 79),
(788, 'HUAYLLABAMBA', 79),
(789, 'MACHUPICCHU', 79),
(790, 'MARAS', 79),
(791, '* TRIAL * TRI', 79),
(792, 'YUCAY', 79),
(793, '* TRIAL * TR', 80),
(794, 'ACOBAMBILLA', 80),
(795, 'ACORIA', 80),
(796, 'CONAYCA', 80),
(797, 'CUENCA', 80),
(798, 'HUACHOCOLPA', 80),
(799, 'HUAYLLAHUARA', 80),
(800, '* TRIAL *', 80),
(801, 'LARIA', 80),
(802, 'MANTA', 80),
(803, 'MARISCAL CACERES', 80),
(804, 'MOYA', 80),
(805, '* TRIAL * TR', 80),
(806, 'PALCA', 80),
(807, '* TRIAL ', 80),
(808, 'VILCA', 80),
(809, 'YAULI', 80),
(810, 'ASCENSION', 80),
(811, 'HUANDO', 80),
(812, '* TRIAL ', 81),
(813, '* TRIAL *', 81),
(814, 'ANTA', 81),
(815, 'CAJA', 81),
(816, 'MARCAS', 81),
(817, 'PAUCARA', 81),
(818, 'POMACOCHA', 81),
(819, 'ROSARIO', 81),
(820, 'LIRCAY', 82),
(821, 'ANCHONGA', 82),
(822, 'CALLANMARCA', 82),
(823, 'CCOCHACCASA', 82),
(824, 'CHINCHO', 82),
(825, 'CONGALLA', 82),
(826, '* TRIAL * TRI', 82),
(827, 'HUAYLLAY GRANDE', 82),
(828, 'JULCAMARCA', 82),
(829, '* TRIAL * TRIAL * TRIAL ', 82),
(830, '* TRIAL * TRIAL * T', 82),
(831, 'SECCLLA', 82),
(832, '* TRIAL * TRIA', 83),
(833, 'ARMA', 83),
(834, 'AURAHUA', 83),
(835, '* TRIAL ', 83),
(836, 'CHUPAMARCA', 83),
(837, 'COCAS', 83),
(838, 'HUACHOS', 83),
(839, 'HUAMATAMBO', 83),
(840, 'MOLLEPAMPA', 83),
(841, '* TRIAL ', 83),
(842, '* TRIAL *', 83),
(843, 'TANTARA', 83),
(844, 'TICRAPO', 83),
(845, '* TRIAL *', 84),
(846, 'ANCO', 84),
(847, '* TRIAL * TR', 84),
(848, 'EL CARMEN', 84),
(849, 'LA MERCED', 84),
(850, 'LOCROJA', 84),
(851, '* TRIAL * T', 84),
(852, 'SAN MIGUEL DE MAYOCC', 84),
(853, 'SAN PEDRO DE CORIS', 84),
(854, '* TRIAL * ', 84),
(855, '* TRIAL ', 85),
(856, 'AYAVI', 85),
(857, 'CORDOVA', 85),
(858, 'HUAYACUNDO ARMA', 85),
(859, 'LARAMARCA', 85),
(860, 'OCOYO', 85),
(861, 'PILPICHACA', 85),
(862, 'QUERCO', 85),
(863, 'QUITO-ARMA', 85),
(864, '* TRIAL * TRIAL * TRIAL *', 85),
(865, 'SAN FRANCISCO DE SANGAYAICO', 85),
(866, 'SAN ISIDRO', 85),
(867, 'SANTIAGO DE CHOCORVOS', 85),
(868, 'SANTIAGO DE QUIRAHUARA', 85),
(869, '* TRIAL * TRIAL * TRIAL *', 85),
(870, 'TAMBO', 85),
(871, 'PAMPAS', 86),
(872, 'ACOSTAMBO', 86),
(873, 'ACRAQUIA', 86),
(874, '* TRIAL ', 86),
(875, 'COLCABAMBA', 86),
(876, '* TRIAL * TRIAL ', 86),
(877, 'HUACHOCOLPA', 86),
(878, 'HUARIBAMBA', 86),
(879, '* TRIAL * TRIAL * T', 86),
(880, 'PAZOS', 86),
(881, 'QUISHUAR', 86),
(882, 'SALCABAMBA', 86),
(883, 'SALCAHUASI', 86),
(884, 'SAN MARCOS DE ROCCHAC', 86),
(885, 'SURCUBAMBA', 86),
(886, 'TINTAY PUNCU', 86),
(887, 'HUANUCO', 87),
(888, '* TRIAL ', 87),
(889, 'CHINCHAO', 87),
(890, '* TRIAL * ', 87),
(891, 'MARGOS', 87),
(892, 'QUISQUI', 87),
(893, 'SAN FRANCISCO DE CAYRAN', 87),
(894, 'SAN PEDRO DE CHAULAN', 87),
(895, 'SANTA MARIA DEL VALLE', 87),
(896, 'YARUMAYO', 87),
(897, 'PILLCO MARCA', 87),
(898, 'AMBO', 88),
(899, 'CAYNA', 88),
(900, 'COLPAS', 88),
(901, 'CONCHAMARCA', 88),
(902, 'HUACAR', 88),
(903, 'SAN FRANCISCO', 88),
(904, 'SAN RAFAEL', 88),
(905, 'TOMAY KICHWA', 88),
(906, '* TRIAL ', 89),
(907, 'CHUQUIS', 89),
(908, 'MARIAS', 89),
(909, 'PACHAS', 89),
(910, 'QUIVILLA', 89),
(911, 'RIPAN', 89),
(912, 'SHUNQUI', 89),
(913, 'SILLAPATA', 89),
(914, 'YANAS', 89),
(915, 'HUACAYBAMBA', 90),
(916, '* TRIAL * T', 90),
(917, '* TRIAL * ', 90),
(918, 'PINRA', 90),
(919, 'LLATA', 91),
(920, 'ARANCAY', 91),
(921, '* TRIAL * TRIAL * ', 91),
(922, 'JACAS GRANDE', 91),
(923, 'JIRCAN', 91),
(924, 'MIRAFLORES', 91),
(925, 'MONZON', 91),
(926, 'PUNCHAO', 91),
(927, '* TRIAL * TR', 91),
(928, 'SINGA', 91),
(929, '* TRIAL *', 91),
(930, 'RUPA-RUPA', 92),
(931, '* TRIAL * TRIAL * TR', 92),
(932, 'HERMILIO VALDIZAN', 92),
(933, 'JOSE CRESPO Y CASTILLO', 92),
(934, 'LUYANDO', 92),
(935, 'MARIANO DAMASO BERAUN', 92),
(936, 'HUACRACHUCO', 93),
(937, 'CHOLON', 93),
(938, 'SAN BUENAVENTURA', 93),
(939, 'PANAO', 94),
(940, 'CHAGLLA', 94),
(941, 'MOLINO', 94),
(942, 'UMARI', 94),
(943, '* TRIAL * T', 95),
(944, 'CODO DEL POZUZO', 95),
(945, 'HONORIA', 95),
(946, '* TRIAL * T', 95),
(947, '* TRIAL * ', 95),
(948, 'JESUS', 96),
(949, 'BA&Ntilde;OS', 96),
(950, 'JIVIA', 96),
(951, '* TRIAL * ', 96),
(952, 'RONDOS', 96),
(953, 'SAN FRANCISCO DE ASIS', 96),
(954, 'SAN MIGUEL DE CAURI', 96),
(955, 'CHAVINILLO', 97),
(956, 'CAHUAC', 97),
(957, 'CHACABAMBA', 97),
(958, 'APARICIO POMARES', 97),
(959, 'JACAS CHICO', 97),
(960, 'OBAS', 97),
(961, 'PAMPAMARCA', 97),
(962, 'CHORAS', 97),
(963, 'ICA', 98),
(964, '* TRIAL * TRIAL * ', 98),
(965, '* TRIAL * T', 98),
(966, 'OCUCAJE', 98),
(967, 'PACHACUTEC', 98),
(968, 'PARCONA', 98),
(969, 'PUEBLO NUEVO', 98),
(970, 'SALAS', 98),
(971, 'SAN JOSE DE LOS MOLINOS', 98),
(972, 'SAN JUAN BAUTISTA', 98),
(973, '* TRIAL ', 98),
(974, '* TRIAL * T', 98),
(975, 'TATE', 98),
(976, 'YAUCA DEL ROSARIO', 98),
(977, 'CHINCHA ALTA', 99),
(978, '* TRIAL * ', 99),
(979, 'CHAVIN', 99),
(980, '* TRIAL * TR', 99),
(981, 'EL CARMEN', 99),
(982, 'GROCIO PRADO', 99),
(983, 'PUEBLO NUEVO', 99),
(984, 'SAN JUAN DE YANAC', 99),
(985, '* TRIAL * TRIAL * TRIAL', 99),
(986, 'SUNAMPE', 99),
(987, 'TAMBO DE MORA', 99),
(988, 'NAZCA', 100),
(989, '* TRIAL * ', 100),
(990, '* TRIAL * ', 100),
(991, 'MARCONA', 100),
(992, 'VISTA ALEGRE', 100),
(993, 'PALPA', 101),
(994, 'LLIPATA', 101),
(995, 'RIO GRANDE', 101),
(996, 'SANTA CRUZ', 101),
(997, 'TIBILLO', 101),
(998, 'PISCO', 102),
(999, 'HUANCANO', 102),
(1000, 'HUMAY', 102),
(1001, 'INDEPENDENCIA', 102),
(1002, 'PARACAS', 102),
(1003, '* TRIAL * ', 102),
(1004, 'SAN CLEMENTE', 102),
(1005, '* TRIAL * TRIAL ', 102),
(1006, 'HUANCAYO', 103),
(1007, 'CARHUACALLANGA', 103),
(1008, 'CHACAPAMPA', 103),
(1009, 'CHICCHE', 103),
(1010, 'CHILCA', 103),
(1011, '* TRIAL * TR', 103),
(1012, 'CHUPURO', 103),
(1013, 'COLCA', 103),
(1014, 'CULLHUAS', 103),
(1015, 'EL TAMBO', 103),
(1016, 'HUACRAPUQUIO', 103),
(1017, 'HUALHUAS', 103),
(1018, 'HUANCAN', 103),
(1019, 'HUASICANCHA', 103),
(1020, '* TRIAL * ', 103),
(1021, 'INGENIO', 103),
(1022, 'PARIAHUANCA', 103),
(1023, 'PILCOMAYO', 103),
(1024, 'PUCARA', 103),
(1025, 'QUICHUAY', 103),
(1026, 'QUILCAS', 103),
(1027, '* TRIAL * T', 103),
(1028, 'SAN JERONIMO DE TUNAN', 103),
(1029, 'SAÑOS', 103),
(1030, '* TRIAL * ', 103),
(1031, 'SICAYA', 103),
(1032, '* TRIAL * TRIAL * TRIAL *', 103),
(1033, 'VIQUES', 103),
(1034, '* TRIAL * ', 104),
(1035, 'ACO', 104),
(1036, 'ANDAMARCA', 104),
(1037, 'CHAMBARA', 104),
(1038, 'COCHAS', 104),
(1039, 'COMAS', 104),
(1040, 'HEROINAS TOLEDO', 104),
(1041, '* TRIAL * ', 104),
(1042, 'MARISCAL CASTILLA', 104),
(1043, 'MATAHUASI', 104),
(1044, 'MITO', 104),
(1045, '* TRIAL * TRIA', 104),
(1046, 'ORCOTUNA', 104),
(1047, 'SAN JOSE DE QUERO', 104),
(1048, 'SANTA ROSA DE OCOPA', 104),
(1049, '* TRIAL * T', 105),
(1050, 'PERENE', 105),
(1051, 'PICHANAQUI', 105),
(1052, 'SAN LUIS DE SHUARO', 105),
(1053, 'SAN RAMON', 105),
(1054, 'VITOC', 105),
(1055, 'JAUJA', 106),
(1056, 'ACOLLA', 106),
(1057, 'APATA', 106),
(1058, 'ATAURA', 106),
(1059, '* TRIAL * ', 106),
(1060, '* TRIAL ', 106),
(1061, 'EL MANTARO', 106),
(1062, 'HUAMALI', 106),
(1063, '* TRIAL * ', 106),
(1064, 'HUERTAS', 106),
(1065, '* TRIAL *', 106),
(1066, 'JULCAN', 106),
(1067, 'LEONOR ORDO&Ntilde;EZ', 106),
(1068, 'LLOCLLAPAMPA', 106),
(1069, 'MARCO', 106),
(1070, 'MASMA', 106),
(1071, '* TRIAL * TRI', 106),
(1072, 'MOLINOS', 106),
(1073, 'MONOBAMBA', 106),
(1074, 'MUQUI', 106),
(1075, 'MUQUIYAUYO', 106),
(1076, 'PACA', 106),
(1077, 'PACCHA', 106),
(1078, 'PANCAN', 106),
(1079, 'PARCO', 106),
(1080, 'POMACANCHA', 106),
(1081, 'RICRAN', 106),
(1082, 'SAN LORENZO', 106),
(1083, '* TRIAL * TRIAL * T', 106),
(1084, 'SAUSA', 106),
(1085, 'SINCOS', 106),
(1086, '* TRIAL * T', 106),
(1087, 'YAULI', 106),
(1088, 'YAUYOS', 106),
(1089, 'JUNIN', 107),
(1090, 'CARHUAMAYO', 107),
(1091, 'ONDORES', 107),
(1092, 'ULCUMAYO', 107),
(1093, 'SATIPO', 108),
(1094, 'COVIRIALI', 108),
(1095, 'LLAYLLA', 108),
(1096, 'MAZAMARI', 108),
(1097, 'PAMPA HERMOSA', 108),
(1098, 'PANGOA', 108),
(1099, 'RIO NEGRO', 108),
(1100, 'RIO TAMBO', 108),
(1101, 'TARMA', 109),
(1102, '* TRIAL ', 109),
(1103, '* TRIAL * ', 109),
(1104, '* TRIAL * ', 109),
(1105, 'LA UNION', 109),
(1106, 'PALCA', 109),
(1107, 'PALCAMAYO', 109),
(1108, 'SAN PEDRO DE CAJAS', 109),
(1109, 'TAPO', 109),
(1110, 'LA OROYA', 110),
(1111, '* TRIAL * ', 110),
(1112, 'HUAY-HUAY', 110),
(1113, 'MARCAPOMACOCHA', 110),
(1114, '* TRIAL *', 110),
(1115, 'PACCHA', 110),
(1116, '* TRIAL * TRIAL * TRIAL * TR', 110),
(1117, '* TRIAL * TRIAL * T', 110),
(1118, 'SUITUCANCHA', 110),
(1119, 'YAULI', 110),
(1120, 'CHUPACA', 111),
(1121, 'AHUAC', 111),
(1122, 'CHONGOS BAJO', 111),
(1123, 'HUACHAC', 111),
(1124, '* TRIAL * TRIAL ', 111),
(1125, 'SAN JUAN DE ISCOS', 111),
(1126, 'SAN JUAN DE JARPA', 111),
(1127, '* TRIAL * TRIAL *', 111),
(1128, 'YANACANCHA', 111),
(1129, 'TRUJILLO', 112),
(1130, 'EL PORVENIR', 112),
(1131, '* TRIAL * TRIAL *', 112),
(1132, '* TRIAL *', 112),
(1133, 'LA ESPERANZA', 112),
(1134, 'LAREDO', 112),
(1135, 'MOCHE', 112),
(1136, 'POROTO', 112),
(1137, 'SALAVERRY', 112),
(1138, 'SIMBAL', 112),
(1139, 'VICTOR LARCO HERRERA', 112),
(1140, 'ASCOPE', 113),
(1141, 'CHICAMA', 113),
(1142, 'CHOCOPE', 113),
(1143, '* TRIAL * TRIAL ', 113),
(1144, 'PAIJAN', 113),
(1145, 'RAZURI', 113),
(1146, 'SANTIAGO DE CAO', 113),
(1147, 'CASA GRANDE', 113),
(1148, 'BOLIVAR', 114),
(1149, 'BAMBAMARCA', 114),
(1150, '* TRIAL * T', 114),
(1151, '* TRIAL ', 114),
(1152, 'UCHUMARCA', 114),
(1153, 'UCUNCHA', 114),
(1154, 'CHEPEN', 115),
(1155, 'PACANGA', 115),
(1156, 'PUEBLO NUEVO', 115),
(1157, 'JULCAN', 116),
(1158, 'CALAMARCA', 116),
(1159, 'CARABAMBA', 116),
(1160, 'HUASO', 116),
(1161, 'OTUZCO', 117),
(1162, 'AGALLPAMPA', 117),
(1163, 'CHARAT', 117),
(1164, 'HUARANCHAL', 117),
(1165, 'LA CUESTA', 117),
(1166, 'MACHE', 117),
(1167, 'PARANDAY', 117),
(1168, 'SALPO', 117),
(1169, 'SINSICAP', 117),
(1170, 'USQUIL', 117),
(1171, 'SAN PEDRO DE LLOC', 118),
(1172, 'GUADALUPE', 118),
(1173, 'JEQUETEPEQUE', 118),
(1174, 'PACASMAYO', 118),
(1175, '* TRIAL ', 118),
(1176, '* TRIAL *', 119),
(1177, '* TRIAL *', 119),
(1178, 'CHILLIA', 119),
(1179, 'HUANCASPATA', 119),
(1180, '* TRIAL * ', 119),
(1181, 'HUAYO', 119),
(1182, 'ONGON', 119),
(1183, 'PARCOY', 119),
(1184, 'PATAZ', 119),
(1185, 'PIAS', 119),
(1186, 'SANTIAGO DE CHALLAS', 119),
(1187, 'TAURIJA', 119),
(1188, 'URPAY', 119),
(1189, 'HUAMACHUCO', 120),
(1190, 'CHUGAY', 120),
(1191, '* TRIAL ', 120),
(1192, 'CURGOS', 120),
(1193, '* TRIAL ', 120),
(1194, 'SANAGORAN', 120),
(1195, 'SARIN', 120),
(1196, '* TRIAL * T', 120),
(1197, 'SANTIAGO DE CHUCO', 121),
(1198, 'ANGASMARCA', 121),
(1199, 'CACHICADAN', 121),
(1200, 'MOLLEBAMBA', 121),
(1201, 'MOLLEPATA', 121),
(1202, 'QUIRUVILCA', 121),
(1203, 'SANTA CRUZ DE CHUCA', 121),
(1204, 'SITABAMBA', 121),
(1205, 'GRAN CHIMU', 122),
(1206, 'CASCAS', 122),
(1207, 'LUCMA', 122),
(1208, 'MARMOT', 122),
(1209, '* TRIAL *', 122),
(1210, 'VIRU', 123),
(1211, 'CHAO', 123),
(1212, 'GUADALUPITO', 123),
(1213, '* TRIAL ', 124),
(1214, 'CHONGOYAPE', 124),
(1215, 'ETEN', 124),
(1216, 'ETEN PUERTO', 124),
(1217, '* TRIAL * TRIAL * T', 124),
(1218, 'LA VICTORIA', 124),
(1219, 'LAGUNAS', 124),
(1220, 'MONSEFU', 124),
(1221, '* TRIAL * T', 124),
(1222, 'OYOTUN', 124),
(1223, 'PICSI', 124),
(1224, 'PIMENTEL', 124),
(1225, 'REQUE', 124),
(1226, 'SANTA ROSA', 124),
(1227, 'SA&Ntilde;A', 124),
(1228, 'CAYALTI', 124),
(1229, 'PATAPO', 124),
(1230, 'POMALCA', 124),
(1231, 'PUCALA', 124),
(1232, 'TUMAN', 124),
(1233, 'FERRE&Ntilde;AFE', 125),
(1234, 'CAÑETE', 125),
(1235, '* TRIAL *', 125),
(1236, '* TRIAL * TRIAL * TRIAL * T', 125),
(1237, 'PITIPO', 125),
(1238, 'PUEBLO NUEVO', 125),
(1239, 'LAMBAYEQUE', 126),
(1240, 'CHOCHOPE', 126),
(1241, 'ILLIMO', 126),
(1242, 'JAYANCA', 126),
(1243, 'MOCHUMI', 126),
(1244, 'MORROPE', 126),
(1245, 'MOTUPE', 126),
(1246, 'OLMOS', 126),
(1247, 'PACORA', 126),
(1248, 'SALAS', 126),
(1249, '* TRIAL ', 126),
(1250, 'TUCUME', 126),
(1251, 'LIMA', 127),
(1252, 'ANCON', 127),
(1253, 'ATE', 127),
(1254, 'BARRANCO', 127),
(1255, 'BRE&Ntilde;A', 127),
(1256, 'CARABAYLLO', 127),
(1257, 'CHACLACAYO', 127),
(1258, '* TRIAL * ', 127),
(1259, '* TRIAL * T', 127),
(1260, 'COMAS', 127),
(1261, 'EL AGUSTINO', 127),
(1262, 'INDEPENDENCIA', 127),
(1263, 'JESUS MARIA', 127),
(1264, 'LA MOLINA', 127),
(1265, '* TRIAL * T', 127),
(1266, 'LINCE', 127),
(1267, 'LOS OLIVOS', 127),
(1268, 'LURIGANCHO', 127),
(1269, 'LURIN', 127),
(1270, 'MAGDALENA DEL MAR', 127),
(1271, 'MAGDALENA VIEJA', 127),
(1272, '* TRIAL * ', 127),
(1273, 'PACHACAMAC', 127),
(1274, 'PUCUSANA', 127),
(1275, '* TRIAL * TRI', 127),
(1276, 'PUNTA HERMOSA', 127),
(1277, '* TRIAL * T', 127),
(1278, 'RIMAC', 127),
(1279, 'SAN BARTOLO', 127),
(1280, '* TRIAL *', 127),
(1281, '* TRIAL * ', 127),
(1282, 'SAN JUAN DE LURIGANCHO', 127),
(1283, 'SAN JUAN DE MIRAFLORES', 127),
(1284, 'SAN LUIS', 127),
(1285, '* TRIAL * TRIAL * TR', 127),
(1286, 'SAN MIGUEL', 127),
(1287, 'SANTA ANITA', 127),
(1288, '* TRIAL * TRIAL * T', 127),
(1289, '* TRIAL * ', 127),
(1290, 'SANTIAGO DE SURCO', 127),
(1291, '* TRIAL *', 127),
(1292, '* TRIAL * TRIAL *', 127),
(1293, 'VILLA MARIA DEL TRIUNFO', 127),
(1294, '* TRIAL ', 128),
(1295, '* TRIAL *', 128),
(1296, 'PATIVILCA', 128),
(1297, 'SUPE', 128),
(1298, 'SUPE PUERTO', 128),
(1299, 'CAJATAMBO', 129),
(1300, 'COPA', 129),
(1301, 'GORGOR', 129),
(1302, 'HUANCAPON', 129),
(1303, 'MANAS', 129),
(1304, 'CANTA', 130),
(1305, 'ARAHUAY', 130),
(1306, 'HUAMANTANGA', 130),
(1307, 'HUAROS', 130),
(1308, 'LACHAQUI', 130),
(1309, '* TRIAL * TRIAL ', 130),
(1310, 'SANTA ROSA DE QUIVES', 130),
(1311, '* TRIAL * TRIAL * TRIAL * TR', 131),
(1312, 'ASIA', 131),
(1313, 'CALANGO', 131),
(1314, 'CERRO AZUL', 131),
(1315, 'CHILCA', 131),
(1316, 'COAYLLO', 131),
(1317, '* TRIAL ', 131),
(1318, '* TRIAL *', 131),
(1319, 'MALA', 131),
(1320, 'NUEVO IMPERIAL', 131),
(1321, 'PACARAN', 131),
(1322, 'QUILMANA', 131),
(1323, 'SAN ANTONIO', 131),
(1324, 'SAN LUIS', 131),
(1325, '* TRIAL * TRIAL * TR', 131),
(1326, 'ZU&Ntilde;IGA', 131),
(1327, 'HUARAL', 132),
(1328, 'ATAVILLOS ALTO', 132),
(1329, 'ATAVILLOS BAJO', 132),
(1330, 'AUCALLAMA', 132),
(1331, 'CHANCAY', 132),
(1332, 'IHUARI', 132),
(1333, 'LAMPIAN', 132),
(1334, 'PACARAOS', 132),
(1335, 'SAN MIGUEL DE ACOS', 132),
(1336, 'SANTA CRUZ DE ANDAMARCA', 132),
(1337, 'SUMBILCA', 132),
(1338, 'VEINTISIETE DE NOVIEMBRE', 132),
(1339, 'MATUCANA', 133),
(1340, 'ANTIOQUIA', 133),
(1341, 'CALLAHUANCA', 133),
(1342, '* TRIAL *', 133),
(1343, 'CHICLA', 133),
(1344, 'CUENCA', 133),
(1345, 'HUACHUPAMPA', 133),
(1346, 'HUANZA', 133),
(1347, 'HUAROCHIRI', 133),
(1348, 'LAHUAYTAMBO', 133),
(1349, 'LANGA', 133),
(1350, 'LARAOS', 133),
(1351, 'MARIATANA', 133),
(1352, 'RICARDO PALMA', 133),
(1353, 'SAN ANDRES DE TUPICOCHA', 133),
(1354, 'SAN ANTONIO', 133),
(1355, 'SAN BARTOLOME', 133),
(1356, '* TRIAL * ', 133),
(1357, '* TRIAL * TRIAL ', 133),
(1358, '* TRIAL * TRIAL * TRIAL', 133),
(1359, 'SAN LORENZO DE QUINTI', 133),
(1360, 'SAN MATEO', 133),
(1361, '* TRIAL * TRIAL *', 133),
(1362, 'SAN PEDRO DE CASTA', 133),
(1363, 'SAN PEDRO DE HUANCAYRE', 133),
(1364, '* TRIAL * ', 133),
(1365, 'SANTA CRUZ DE COCACHACRA', 133),
(1366, 'SANTA EULALIA', 133),
(1367, 'SANTIAGO DE ANCHUCAYA', 133),
(1368, '* TRIAL * TRIAL ', 133),
(1369, 'SANTO DOMINGO DE LOS OLLEROS', 133),
(1370, 'SURCO', 133),
(1371, 'HUACHO', 134),
(1372, 'AMBAR', 134),
(1373, '* TRIAL * TRIAL *', 134),
(1374, 'CHECRAS', 134),
(1375, 'HUALMAY', 134),
(1376, 'HUAURA', 134),
(1377, 'LEONCIO PRADO', 134),
(1378, 'PACCHO', 134),
(1379, 'SANTA LEONOR', 134),
(1380, 'SANTA MARIA', 134),
(1381, 'SAYAN', 134),
(1382, 'VEGUETA', 134),
(1383, 'OYON', 135),
(1384, 'ANDAJES', 135),
(1385, 'CAUJUL', 135),
(1386, 'COCHAMARCA', 135),
(1387, 'NAVAN', 135),
(1388, '* TRIAL * ', 135),
(1389, 'YAUYOS', 136),
(1390, 'ALIS', 136),
(1391, 'AYAUCA', 136),
(1392, 'AYAVIRI', 136),
(1393, '* TRIAL ', 136),
(1394, 'CACRA', 136),
(1395, 'CARANIA', 136),
(1396, '* TRIAL *', 136),
(1397, 'CHOCOS', 136),
(1398, 'COCHAS', 136),
(1399, 'COLONIA', 136),
(1400, 'HONGOS', 136),
(1401, 'HUAMPARA', 136),
(1402, '* TRIAL ', 136),
(1403, '* TRIAL * ', 136),
(1404, 'HUANTAN', 136),
(1405, 'HUA&Ntilde;EC', 136),
(1406, 'LARAOS', 136),
(1407, 'LINCHA', 136),
(1408, 'MADEAN', 136),
(1409, '* TRIAL * ', 136),
(1410, 'OMAS', 136),
(1411, 'PUTINZA', 136),
(1412, 'QUINCHES', 136),
(1413, '* TRIAL ', 136),
(1414, '* TRIAL * T', 136),
(1415, 'SAN PEDRO DE PILAS', 136),
(1416, 'TANTA', 136),
(1417, '* TRIAL * ', 136),
(1418, 'TOMAS', 136),
(1419, 'TUPE', 136),
(1420, '* TRIAL * TR', 136),
(1421, 'VITIS', 136),
(1422, 'IQUITOS', 137),
(1423, 'ALTO NANAY', 137),
(1424, 'FERNANDO LORES', 137),
(1425, 'INDIANA', 137),
(1426, 'LAS AMAZONAS', 137),
(1427, 'MAZAN', 137),
(1428, 'NAPO', 137),
(1429, 'PUNCHANA', 137),
(1430, 'PUTUMAYO', 137),
(1431, '* TRIAL * TRIA', 137),
(1432, 'BELEN', 137),
(1433, 'SAN JUAN BAUTISTA', 137),
(1434, 'YURIMAGUAS', 138),
(1435, '* TRIAL * T', 138),
(1436, 'BARRANCA', 138),
(1437, 'CAHUAPANAS', 138),
(1438, 'JEBEROS', 138),
(1439, 'LAGUNAS', 138),
(1440, '* TRIAL * ', 138),
(1441, 'MORONA', 138),
(1442, 'PASTAZA', 138),
(1443, 'SANTA CRUZ', 138),
(1444, '* TRIAL * TRIAL * TRIAL * ', 138),
(1445, 'NAUTA', 139),
(1446, '* TRIAL ', 139),
(1447, 'TIGRE', 139),
(1448, 'TROMPETEROS', 139),
(1449, 'URARINAS', 139),
(1450, 'RAMON CASTILLA', 140),
(1451, 'PEBAS', 140),
(1452, 'YAVARI', 140),
(1453, '* TRIAL *', 140),
(1454, 'REQUENA', 141),
(1455, 'ALTO TAPICHE', 141),
(1456, 'CAPELO', 141),
(1457, '* TRIAL * TRIAL *', 141),
(1458, 'MAQUIA', 141),
(1459, 'PUINAHUA', 141),
(1460, 'SAQUENA', 141),
(1461, 'SOPLIN', 141),
(1462, 'TAPICHE', 141),
(1463, 'JENARO HERRERA', 141),
(1464, 'YAQUERANA', 141),
(1465, 'CONTAMANA', 142),
(1466, 'INAHUAYA', 142),
(1467, 'PADRE MARQUEZ', 142),
(1468, 'PAMPA HERMOSA', 142),
(1469, '* TRIAL ', 142),
(1470, '* TRIAL * TRI', 142),
(1471, '* TRIAL *', 143),
(1472, 'INAMBARI', 143),
(1473, 'LAS PIEDRAS', 143),
(1474, '* TRIAL *', 143),
(1475, 'MANU', 144),
(1476, 'FITZCARRALD', 144),
(1477, '* TRIAL * TRI', 144),
(1478, 'HUEPETUHE', 144),
(1479, 'I&Ntilde;APARI', 145),
(1480, 'IBERIA', 145),
(1481, 'TAHUAMANU', 145),
(1482, 'MOQUEGUA', 146),
(1483, 'CARUMAS', 146),
(1484, '* TRIAL * ', 146),
(1485, 'SAMEGUA', 146),
(1486, 'SAN CRISTOBAL', 146),
(1487, 'TORATA', 146),
(1488, 'OMATE', 147),
(1489, 'CHOJATA', 147),
(1490, 'COALAQUE', 147),
(1491, 'ICHU&Ntilde;A', 147),
(1492, 'LA CAPILLA', 147),
(1493, 'LLOQUE', 147),
(1494, '* TRIAL *', 147),
(1495, 'PUQUINA', 147),
(1496, 'QUINISTAQUILLAS', 147),
(1497, 'UBINAS', 147),
(1498, 'YUNGA', 147),
(1499, 'ILO', 148),
(1500, 'EL ALGARROBAL', 148),
(1501, 'PACOCHA', 148),
(1502, 'CHAUPIMARCA', 149),
(1503, 'HUACHON', 149),
(1504, '* TRIAL ', 149),
(1505, 'HUAYLLAY', 149),
(1506, 'NINACACA', 149),
(1507, '* TRIAL * TR', 149),
(1508, '* TRIAL * T', 149),
(1509, '* TRIAL * TRIAL * TRIAL * TRI', 149),
(1510, 'SIMON BOLIVAR', 149),
(1511, 'TICLACAYAN', 149),
(1512, 'TINYAHUARCO', 149),
(1513, 'VICCO', 149),
(1514, 'YANACANCHA', 149),
(1515, 'YANAHUANCA', 150),
(1516, 'CHACAYAN', 150),
(1517, 'GOYLLARISQUIZGA', 150),
(1518, 'PAUCAR', 150),
(1519, 'SAN PEDRO DE PILLAO', 150),
(1520, '* TRIAL * TRIAL *', 150),
(1521, 'TAPUC', 150),
(1522, '* TRIAL * ', 150),
(1523, '* TRIAL ', 151),
(1524, 'CHONTABAMBA', 151),
(1525, 'HUANCABAMBA', 151),
(1526, 'PALCAZU', 151),
(1527, 'POZUZO', 151),
(1528, 'PUERTO BERMUDEZ', 151),
(1529, 'VILLA RICA', 151),
(1530, 'PIURA', 152),
(1531, 'CASTILLA', 152),
(1532, 'CATACAOS', 152),
(1533, 'CURA MORI', 152),
(1534, 'EL TALLAN', 152),
(1535, 'LA ARENA', 152),
(1536, 'LA UNION', 152),
(1537, 'LAS LOMAS', 152),
(1538, 'TAMBO GRANDE', 152),
(1539, 'AYABACA', 153),
(1540, 'FRIAS', 153),
(1541, 'JILILI', 153),
(1542, 'LAGUNAS', 153),
(1543, 'MONTERO', 153),
(1544, 'PACAIPAMPA', 153),
(1545, 'PAIMAS', 153),
(1546, 'SAPILLICA', 153),
(1547, 'SICCHEZ', 153),
(1548, 'SUYO', 153),
(1549, 'HUANCABAMBA', 154),
(1550, 'CANCHAQUE', 154),
(1551, 'EL CARMEN DE LA FRONTERA', 154),
(1552, 'HUARMACA', 154),
(1553, '* TRIAL ', 154),
(1554, 'SAN MIGUEL DE EL FAIQUE', 154),
(1555, 'SONDOR', 154),
(1556, '* TRIAL * ', 154),
(1557, 'CHULUCANAS', 155),
(1558, '* TRIAL * TR', 155),
(1559, 'CHALACO', 155),
(1560, 'LA MATANZA', 155),
(1561, 'MORROPON', 155),
(1562, 'SALITRAL', 155),
(1563, '* TRIAL * TRIAL * ', 155),
(1564, 'SANTA CATALINA DE MOSSA', 155),
(1565, 'SANTO DOMINGO', 155),
(1566, 'YAMANGO', 155),
(1567, 'PAITA', 156),
(1568, 'AMOTAPE', 156),
(1569, 'ARENAL', 156),
(1570, 'COLAN', 156),
(1571, 'LA HUACA', 156),
(1572, 'TAMARINDO', 156),
(1573, 'VICHAYAL', 156),
(1574, 'SULLANA', 157),
(1575, 'BELLAVISTA', 157),
(1576, 'IGNACIO ESCUDERO', 157),
(1577, 'LANCONES', 157),
(1578, '* TRIAL * T', 157),
(1579, '* TRIAL * TR', 157),
(1580, '* TRIAL * TR', 157),
(1581, 'SALITRAL', 157),
(1582, '* TRIAL * TRIA', 158),
(1583, 'EL ALTO', 158),
(1584, 'LA BREA', 158),
(1585, 'LOBITOS', 158),
(1586, 'LOS ORGANOS', 158),
(1587, 'MANCORA', 158),
(1588, 'SECHURA', 159),
(1589, 'BELLAVISTA DE LA UNION', 159),
(1590, 'BERNAL', 159),
(1591, '* TRIAL * TRIAL ', 159),
(1592, 'VICE', 159),
(1593, 'RINCONADA LLICUAR', 159),
(1594, 'PUNO', 160),
(1595, 'ACORA', 160),
(1596, '* TRIAL ', 160),
(1597, 'ATUNCOLLA', 160),
(1598, '* TRIAL *', 160),
(1599, 'CHUCUITO', 160),
(1600, 'COATA', 160),
(1601, 'HUATA', 160),
(1602, 'MA&Ntilde;AZO', 160),
(1603, 'PAUCARCOLLA', 160),
(1604, 'PICHACANI', 160),
(1605, 'PLATERIA', 160),
(1606, 'SAN ANTONIO', 160),
(1607, 'TIQUILLACA', 160),
(1608, 'VILQUE', 160),
(1609, 'AZANGARO', 161),
(1610, 'ACHAYA', 161),
(1611, 'ARAPA', 161),
(1612, 'ASILLO', 161),
(1613, 'CAMINACA', 161),
(1614, 'CHUPA', 161),
(1615, '* TRIAL * TRIAL * TRIAL *', 161),
(1616, 'MU&Ntilde;ANI', 161),
(1617, 'POTONI', 161),
(1618, 'SAMAN', 161),
(1619, '* TRIAL *', 161),
(1620, 'SAN JOSE', 161),
(1621, 'SAN JUAN DE SALINAS', 161),
(1622, 'SANTIAGO DE PUPUJA', 161),
(1623, '* TRIAL ', 161),
(1624, 'MACUSANI', 162),
(1625, 'AJOYANI', 162),
(1626, 'AYAPATA', 162),
(1627, 'COASA', 162),
(1628, 'CORANI', 162),
(1629, 'CRUCERO', 162),
(1630, 'ITUATA', 162),
(1631, 'OLLACHEA', 162),
(1632, 'SAN GABAN', 162),
(1633, 'USICAYOS', 162),
(1634, 'JULI', 163),
(1635, '* TRIAL * T', 163),
(1636, '* TRIAL * ', 163),
(1637, 'KELLUYO', 163),
(1638, 'PISACOMA', 163),
(1639, 'POMATA', 163),
(1640, 'ZEPITA', 163),
(1641, 'ILAVE', 164),
(1642, 'CAPAZO', 164),
(1643, 'PILCUYO', 164),
(1644, 'SANTA ROSA', 164),
(1645, 'CONDURIRI', 164),
(1646, 'HUANCANE', 165),
(1647, 'COJATA', 165),
(1648, '* TRIAL *', 165),
(1649, 'INCHUPALLA', 165),
(1650, 'PUSI', 165),
(1651, 'ROSASPATA', 165),
(1652, 'TARACO', 165),
(1653, 'VILQUE CHICO', 165),
(1654, 'LAMPA', 166),
(1655, 'CABANILLA', 166),
(1656, 'CALAPUJA', 166),
(1657, 'NICASIO', 166),
(1658, 'OCUVIRI', 166),
(1659, 'PALCA', 166),
(1660, 'PARATIA', 166),
(1661, 'PUCARA', 166),
(1662, '* TRIAL * T', 166),
(1663, 'VILAVILA', 166),
(1664, 'AYAVIRI', 167),
(1665, 'ANTAUTA', 167),
(1666, 'CUPI', 167),
(1667, 'LLALLI', 167),
(1668, 'MACARI', 167),
(1669, '* TRIAL * TR', 167),
(1670, 'ORURILLO', 167),
(1671, 'SANTA ROSA', 167),
(1672, '* TRIAL ', 167),
(1673, 'MOHO', 168),
(1674, 'CONIMA', 168),
(1675, '* TRIAL * ', 168),
(1676, 'TILALI', 168),
(1677, 'PUTINA', 169),
(1678, 'ANANEA', 169),
(1679, '* TRIAL * TRIAL *', 169),
(1680, 'QUILCAPUNCU', 169),
(1681, 'SINA', 169),
(1682, 'JULIACA', 170),
(1683, 'CABANA', 170),
(1684, 'CABANILLAS', 170),
(1685, 'CARACOTO', 170),
(1686, 'SANDIA', 171),
(1687, '* TRIAL ', 171),
(1688, 'LIMBANI', 171),
(1689, 'PATAMBUCO', 171),
(1690, 'PHARA', 171),
(1691, 'QUIACA', 171),
(1692, 'SAN JUAN DEL ORO', 171),
(1693, 'YANAHUAYA', 171),
(1694, 'ALTO INAMBARI', 171),
(1695, 'YUNGUYO', 172),
(1696, 'ANAPIA', 172),
(1697, 'COPANI', 172),
(1698, 'CUTURAPI', 172),
(1699, 'OLLARAYA', 172),
(1700, 'TINICACHI', 172),
(1701, 'UNICACHI', 172),
(1702, '* TRIAL *', 173),
(1703, 'CALZADA', 173),
(1704, 'HABANA', 173),
(1705, '* TRIAL *', 173),
(1706, 'SORITOR', 173),
(1707, 'YANTALO', 173),
(1708, '* TRIAL * ', 174),
(1709, 'ALTO BIAVO', 174),
(1710, 'BAJO BIAVO', 174),
(1711, 'HUALLAGA', 174),
(1712, 'SAN PABLO', 174),
(1713, 'SAN RAFAEL', 174),
(1714, 'SAN JOSE DE SISA', 175),
(1715, 'AGUA BLANCA', 175),
(1716, 'SAN MARTIN', 175),
(1717, '* TRIAL * ', 175),
(1718, 'SHATOJA', 175),
(1719, 'SAPOSOA', 176),
(1720, 'ALTO SAPOSOA', 176),
(1721, 'EL ESLABON', 176),
(1722, '* TRIAL *', 176),
(1723, '* TRIAL ', 176),
(1724, 'TINGO DE SAPOSOA', 176),
(1725, 'LAMAS', 177),
(1726, 'ALONSO DE ALVARADO', 177),
(1727, 'BARRANQUITA', 177),
(1728, 'CAYNARACHI', 177),
(1729, 'CU&Ntilde;UMBUQUI', 177),
(1730, 'PINTO RECODO', 177),
(1731, 'RUMISAPA', 177),
(1732, '* TRIAL * TRIAL * TR', 177),
(1733, 'SHANAO', 177),
(1734, 'TABALOSOS', 177),
(1735, 'ZAPATERO', 177),
(1736, 'JUANJUI', 178),
(1737, 'CAMPANILLA', 178),
(1738, 'HUICUNGO', 178),
(1739, 'PACHIZA', 178),
(1740, 'PAJARILLO', 178),
(1741, 'PICOTA', 179),
(1742, 'BUENOS AIRES', 179),
(1743, '* TRIAL *', 179),
(1744, '* TRIAL ', 179),
(1745, 'PUCACACA', 179),
(1746, '* TRIAL * TRI', 179),
(1747, 'SAN HILARION', 179),
(1748, 'SHAMBOYACU', 179),
(1749, 'TINGO DE PONASA', 179),
(1750, 'TRES UNIDOS', 179),
(1751, 'RIOJA', 180),
(1752, 'AWAJUN', 180),
(1753, '* TRIAL * TRIAL * T', 180),
(1754, 'NUEVA CAJAMARCA', 180),
(1755, '* TRIAL * TR', 180),
(1756, 'POSIC', 180),
(1757, 'SAN FERNANDO', 180),
(1758, 'YORONGOS', 180),
(1759, 'YURACYACU', 180),
(1760, 'TARAPOTO', 181),
(1761, 'ALBERTO LEVEAU', 181),
(1762, 'CACATACHI', 181),
(1763, 'CHAZUTA', 181),
(1764, 'CHIPURANA', 181),
(1765, 'EL PORVENIR', 181),
(1766, 'HUIMBAYOC', 181),
(1767, '* TRIAL * T', 181),
(1768, 'LA BANDA DE SHILCAYO', 181),
(1769, 'MORALES', 181),
(1770, '* TRIAL *', 181),
(1771, 'SAN ANTONIO', 181),
(1772, 'SAUCE', 181),
(1773, 'SHAPAJA', 181),
(1774, 'TOCACHE', 182),
(1775, 'NUEVO PROGRESO', 182),
(1776, 'POLVORA', 182),
(1777, 'SHUNTE', 182),
(1778, 'UCHIZA', 182),
(1779, 'TACNA', 183),
(1780, 'ALTO DE LA ALIANZA', 183),
(1781, 'CALANA', 183),
(1782, 'CIUDAD NUEVA', 183),
(1783, 'INCLAN', 183),
(1784, 'PACHIA', 183),
(1785, 'PALCA', 183),
(1786, 'POCOLLAY', 183),
(1787, 'SAMA', 183),
(1788, '* TRIAL * TRIAL * TRIAL * TRIAL * TR', 183),
(1789, '* TRIAL *', 184),
(1790, 'CAIRANI', 184),
(1791, '* TRIAL ', 184),
(1792, 'CURIBAYA', 184),
(1793, 'HUANUARA', 184),
(1794, '* TRIAL * ', 184),
(1795, 'LOCUMBA', 185),
(1796, 'ILABAYA', 185),
(1797, 'ITE', 185),
(1798, 'TARATA', 186),
(1799, 'CHUCATAMANI', 186),
(1800, 'ESTIQUE', 186),
(1801, '* TRIAL * TRI', 186),
(1802, 'SITAJARA', 186),
(1803, '* TRIAL ', 186),
(1804, '* TRIAL *', 186),
(1805, 'TICACO', 186),
(1806, 'TUMBES', 187),
(1807, 'CORRALES', 187),
(1808, 'LA CRUZ', 187),
(1809, 'PAMPAS DE HOSPITAL', 187),
(1810, 'SAN JACINTO', 187),
(1811, 'SAN JUAN DE LA VIRGEN', 187),
(1812, 'ZORRITOS', 188),
(1813, 'CASITAS', 188),
(1814, '* TRIAL *', 189),
(1815, 'AGUAS VERDES', 189),
(1816, 'MATAPALO', 189),
(1817, 'PAPAYAL', 189),
(1818, 'CALLERIA', 190),
(1819, 'CAMPOVERDE', 190),
(1820, 'IPARIA', 190),
(1821, 'MASISEA', 190),
(1822, '* TRIAL * T', 190),
(1823, 'NUEVA REQUENA', 190),
(1824, 'RAYMONDI', 191),
(1825, 'SEPAHUA', 191),
(1826, '* TRIAL ', 191),
(1827, 'YURUA', 191),
(1828, 'PADRE ABAD', 192),
(1829, 'IRAZOLA', 192),
(1830, '* TRIAL ', 192),
(1831, 'PURUS', 193);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleadotb`
--

CREATE TABLE `empleadotb` (
  `idempleado` varchar(12) NOT NULL,
  `tipodocumento` int(11) NOT NULL,
  `numerodocumento` varchar(20) DEFAULT NULL,
  `apellidos` varchar(50) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `sexo` int(11) DEFAULT NULL,
  `fechanacimiento` date DEFAULT NULL,
  `puesto` int(11) NOT NULL,
  `rol` int(11) DEFAULT NULL,
  `estado` int(11) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `pais` char(3) DEFAULT NULL,
  `ciudad` int(11) DEFAULT NULL,
  `provincia` int(11) DEFAULT NULL,
  `distrito` int(11) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `clave` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresatb`
--

CREATE TABLE `empresatb` (
  `idempresa` int(11) NOT NULL,
  `girocomercial` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `paginaweb` varchar(200) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `domicilio` varchar(200) DEFAULT NULL,
  `tipodocumento` int(11) DEFAULT NULL,
  `numerodocumento` varchar(20) DEFAULT NULL,
  `razonsocial` varchar(100) DEFAULT NULL,
  `nombrecomercial` varchar(100) DEFAULT NULL,
  `pais` char(3) DEFAULT NULL,
  `ciudad` int(11) DEFAULT NULL,
  `provincia` int(11) DEFAULT NULL,
  `distrito` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `etiquetatb`
--

CREATE TABLE `etiquetatb` (
  `idetiqueta` int(11) NOT NULL,
  `nombre` varchar(60) NOT NULL,
  `tipo` int(11) NOT NULL,
  `predeterminado` bit(1) NOT NULL,
  `medida` varchar(80) DEFAULT NULL,
  `ruta` longtext NOT NULL,
  `imagen` longblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formapagotb`
--

CREATE TABLE `formapagotb` (
  `idformapago` int(11) NOT NULL,
  `idventa` varchar(12) NOT NULL,
  `nombre` varchar(12) DEFAULT NULL,
  `monto` decimal(18,8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imagentb`
--

CREATE TABLE `imagentb` (
  `idimagen` bigint(20) NOT NULL,
  `imagen` longblob DEFAULT NULL,
  `idrelacionado` varchar(12) NOT NULL,
  `idsubrelacion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `impuestotb`
--

CREATE TABLE `impuestotb` (
  `idimpuesto` int(11) NOT NULL,
  `operacion` int(11) DEFAULT NULL,
  `nombre` varchar(50) NOT NULL,
  `valor` decimal(18,2) DEFAULT NULL,
  `predeterminado` bit(1) DEFAULT NULL,
  `codigoalterno` varchar(50) DEFAULT NULL,
  `sistema` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `impuestotb`
--

INSERT INTO `impuestotb` (`idimpuesto`, `operacion`, `nombre`, `valor`, `predeterminado`, `codigoalterno`, `sistema`) VALUES
(1, 2, 'NINGUNO(%)', '0.00', b'0', '0', b'0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `kardexsuministrotb`
--

CREATE TABLE `kardexsuministrotb` (
  `idkardex` int(11) NOT NULL,
  `idsuministro` varchar(12) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `tipo` tinyint(3) UNSIGNED NOT NULL,
  `movimiento` int(11) NOT NULL,
  `detalle` varchar(100) NOT NULL,
  `cantidad` decimal(18,8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lotetb`
--

CREATE TABLE `lotetb` (
  `idlote` bigint(20) NOT NULL,
  `numerolote` varchar(45) NOT NULL,
  `fechacaducidad` date NOT NULL,
  `existenciainicial` decimal(18,2) NOT NULL,
  `existenciaactual` decimal(18,2) NOT NULL,
  `idarticulo` varchar(12) NOT NULL,
  `idcompra` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mantenimientotb`
--

CREATE TABLE `mantenimientotb` (
  `idmantenimiento` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` char(1) NOT NULL,
  `validar` char(10) DEFAULT NULL,
  `usuarioregistro` varchar(15) NOT NULL,
  `fecharegistro` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `mantenimientotb`
--

INSERT INTO `mantenimientotb` (`idmantenimiento`, `nombre`, `estado`, `validar`, `usuarioregistro`, `fecharegistro`) VALUES
('0001', 'ESTADO', '0', '0', '* TRIAL ', '2018-08-30 14:08:19'),
('0002', 'DIRECTORIO', '1', '* TRIAL *', '76423388', '2018-08-30 14:08:33'),
('0003', 'DOCUMENTO DE IDENTIDAD', '1', '* TRIAL *', '76423388', '2018-08-30 14:09:07'),
('0004', 'SEXO', '1', '* TRIAL *', '76423388', '2018-08-30 14:10:00'),
('0005', 'ÁMBITO', '1', '0', '76423388', '2018-09-14 14:54:20'),
('0006', 'CATEGORÍA', '1', '0', '76423388', '2018-09-22 11:25:08'),
('0007', 'MARCA', '1', '0', '76423388', '2018-09-22 11:26:57'),
('0008', 'PRESENTACIÓN', '1', '0', '76423388', '2018-09-22 16:26:01'),
('0009', 'ESTADO DE VENTA O COMPRA', '0', '0', '76423388', '2018-09-23 13:24:48'),
('0010', 'TIPO DE OPERACIONES', '1', '1', '76423388', '2018-09-26 16:28:46'),
('0011', 'GIRO COMERCIAL', '1', '* TRIAL *', '76423388', '2018-09-29 09:27:29'),
('0012', 'PUESTO', '1', '0', '76423388', '2018-10-18 16:44:10'),
('0013', 'UNIDAD DE MEDIDA', '1', '0', 'EM0001', '2018-12-13 10:28:34'),
('0014', 'DEPARTAMENTO DE ALMACENAMIENTO', '1', '0', 'EM0001', '2018-12-13 11:08:24'),
('0015', 'TIPO DE VENTA O COMPRA', '0', '0', 'EM0001', '2019-03-05 12:27:02'),
('0016', 'ORIGEN ARTICULO', '0', '* TRIAL *', 'EM0001', '2019-08-14 09:14:04');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menutb`
--

CREATE TABLE `menutb` (
  `idmenu` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `menutb`
--

INSERT INTO `menutb` (`idmenu`, `nombre`) VALUES
(1, 'INICIO'),
(2, 'OPERACIONES'),
(3, 'CONSULTAS'),
(4, 'INVENTARIO'),
(5, 'PRODUCCION'),
(6, 'CONTACTOS'),
(7, '* TRIAL '),
(8, 'GRÁFICOS'),
(9, '* TRIAL * TRI');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `monedatb`
--

CREATE TABLE `monedatb` (
  `idmoneda` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `abreviado` varchar(10) DEFAULT NULL,
  `simbolo` varchar(10) NOT NULL,
  `tipocambio` decimal(18,4) NOT NULL,
  `predeterminado` bit(1) NOT NULL,
  `sistema` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientoinventariodetalletb`
--

CREATE TABLE `movimientoinventariodetalletb` (
  `idmovimientoinventario` varchar(12) NOT NULL,
  `idsuministro` varchar(12) NOT NULL,
  `cantidad` decimal(18,4) NOT NULL,
  `costo` decimal(18,4) NOT NULL,
  `precio` decimal(18,4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientoinventariotb`
--

CREATE TABLE `movimientoinventariotb` (
  `idmovimientoinventario` varchar(12) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `tipoajuste` bit(1) NOT NULL,
  `tipomovimiento` int(11) NOT NULL,
  `observacion` varchar(200) NOT NULL,
  `proveedor` varchar(12) DEFAULT NULL,
  `suministro` bit(1) NOT NULL,
  `articulo` bit(1) NOT NULL,
  `estado` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagoproveedorestb`
--

CREATE TABLE `pagoproveedorestb` (
  `idpagoproveedores` int(11) NOT NULL,
  `cuota` int(11) DEFAULT NULL,
  `monto` decimal(18,4) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `observacion` varchar(30) DEFAULT NULL,
  `estado` tinyint(3) UNSIGNED DEFAULT NULL,
  `idproveedor` varchar(12) DEFAULT NULL,
  `idcompra` varchar(12) DEFAULT NULL,
  `idempleado` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paistb`
--

CREATE TABLE `paistb` (
  `paiscodigo` char(3) NOT NULL DEFAULT '',
  `paisnombre` varchar(52) NOT NULL DEFAULT '',
  `paiscontinente` varchar(50) NOT NULL DEFAULT 'South America',
  `paisregion` varchar(26) NOT NULL DEFAULT '',
  `paisarea` float(53,0) NOT NULL DEFAULT 0,
  `paiscapital` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `paistb`
--

INSERT INTO `paistb` (`paiscodigo`, `paisnombre`, `paiscontinente`, `paisregion`, `paisarea`, `paiscapital`) VALUES
('ABW', 'ARUBA', 'North America', 'Caribbean', 193, 129),
('AFG', '* TRIAL * T', 'Asia', 'Southern and Central Asia', 652090, 1),
('AGO', 'ANGOLA', 'Africa', 'Central Africa', 1246700, 56),
('AIA', '* TRIAL ', 'North America', 'Caribbean', 96, 62),
('ALB', 'ALBANIA', 'Europe', '* TRIAL * TRIAL', 28748, 34),
('AND', 'ANDORRA', 'Europe', 'Southern Europe', 468, 55),
('ANT', 'NETHERLANDS ANTILLES', 'North America', 'Caribbean', 800, 33),
('ARE', 'UNITED ARAB EMIRATES', 'Asia', 'Middle East', 83600, 65),
('ARG', 'ARGENTINA', 'South America', 'South America', 2780400, 69),
('ARM', 'ARMENIA', 'Asia', 'Middle East', 29800, 126),
('ASM', 'AMERICAN SAMOA', 'Oceania', '* TRIAL *', 199, 54),
('ATA', 'ANTARCTICA', 'Antarctica', 'Antarctica', 13120000, NULL),
('ATF', '* TRIAL * TRIAL * TRIAL * T', 'Antarctica', 'Antarctica', 7780, NULL),
('ATG', 'ANTIGUA AND BARBUDA', 'North America', '* TRIAL *', 442, 63),
('AUS', '* TRIAL *', 'Oceania', '* TRIAL * TRIAL * TRIAL *', 7741220, 135),
('AUT', 'AUSTRIA', 'Europe', 'Western Europe', 83859, 1523),
('AZE', 'AZERBAIJAN', 'Asia', '* TRIAL * T', 86600, 144),
('BDI', 'BURUNDI', 'Africa', 'Eastern Africa', 27834, 552),
('BEL', 'BELGIUM', 'Europe', 'Western Europe', 30518, 179),
('BEN', 'BENIN', 'Africa', 'Western Africa', 112622, 187),
('BFA', 'BURKINA FASO', 'Africa', 'Western Africa', 274000, 549),
('BGD', 'BANGLADESH', 'Asia', 'Southern and Central Asia', 143998, 150),
('BGR', 'BULGARIA', 'Europe', '* TRIAL * TRIA', 110994, 539),
('BHR', 'BAHRAIN', 'Asia', '* TRIAL * T', 694, 149),
('BHS', 'BAHAMAS', 'North America', 'Caribbean', 13878, 148),
('BIH', 'BOSNIA AND HERZEGOVINA', 'Europe', 'Southern Europe', 51197, 201),
('BLR', 'BELARUS', 'Europe', 'Eastern Europe', 207600, 3520),
('BLZ', 'BELIZE', 'North America', 'Central America', 22696, 185),
('BMU', 'BERMUDA', 'North America', '* TRIAL * TRI', 53, 191),
('BOL', 'BOLIVIA', 'South America', 'South America', 1098581, 194),
('BRA', 'BRAZIL', '* TRIAL * TRI', 'South America', 8547403, 211),
('BRB', '* TRIAL ', 'North America', 'Caribbean', 430, 174),
('BRN', 'BRUNEI', 'Asia', 'Southeast Asia', 5765, 538),
('BTN', 'BHUTAN', 'Asia', 'Southern and Central Asia', 47000, 192),
('BVT', 'BOUVET ISLAND', 'Antarctica', '* TRIAL * ', 59, NULL),
('BWA', 'BOTSWANA', 'Africa', 'Southern Africa', 581730, 204),
('CAF', 'CENTRAL AFRICAN REPUBLIC', 'Africa', 'Central Africa', 622984, 1889),
('CAN', 'CANADA', 'North America', 'North America', 9970610, 1822),
('CCK', 'COCOS (KEELING) ISLANDS', 'Oceania', '* TRIAL * TRIAL * TRIAL *', 14, 2317),
('CHE', 'SWITZERLAND', 'Europe', 'Western Europe', 41284, 3248),
('CHL', 'CHILE', 'South America', 'South America', 756626, 554),
('CHN', 'CHINA', 'Asia', 'Eastern Asia', 9572900, 1891),
('CIV', 'CÔTE D’IVOIRE', 'Africa', 'Western Africa', 322463, 2814),
('CMR', 'CAMEROON', 'Africa', 'Central Africa', 475442, 1804),
('COD', 'CONGO, THE DEMOCRATIC REPUBLIC OF THE', 'Africa', 'Central Africa', 2344858, 2298),
('COG', 'CONGO', 'Africa', '* TRIAL * TRIA', 342000, 2296),
('COK', 'COOK ISLANDS', 'Oceania', 'Polynesia', 236, 583),
('COL', 'COLOMBIA', '* TRIAL * TRI', 'South America', 1138914, 2257),
('COM', 'COMOROS', 'Africa', 'Eastern Africa', 1862, 2295),
('CPV', '* TRIAL * ', 'Africa', 'Western Africa', 4033, 1859),
('CRI', 'COSTA RICA', 'North America', 'Central America', 51100, 584),
('CUB', 'CUBA', 'North America', 'Caribbean', 110861, 2413),
('CXR', '* TRIAL * TRIAL ', 'Oceania', '* TRIAL * TRIAL * TRIAL *', 135, 1791),
('CYM', '* TRIAL * TRIA', 'North America', 'Caribbean', 264, 553),
('CYP', 'CYPRUS', 'Asia', 'Middle East', 9251, 2430),
('CZE', 'CZECH REPUBLIC', 'Europe', '* TRIAL * TRIA', 78866, 3339),
('DEU', 'GERMANY', 'Europe', 'Western Europe', 357022, 3068),
('DJI', 'DJIBOUTI', 'Africa', 'Eastern Africa', 23200, 585),
('DMA', '* TRIAL ', 'North America', 'Caribbean', 751, 586),
('DNK', 'DENMARK', 'Europe', 'Nordic Countries', 43094, 3315),
('DOM', 'DOMINICAN REPUBLIC', 'North America', 'Caribbean', 48511, 587),
('DZA', 'ALGERIA', 'Africa', 'Northern Africa', 2381741, 35),
('ECU', 'ECUADOR', 'South America', 'South America', 283561, 594),
('EGY', 'EGYPT', 'Africa', 'Northern Africa', 1001449, 608),
('ERI', 'ERITREA', 'Africa', 'Eastern Africa', 117600, 652),
('ESH', 'WESTERN SAHARA', 'Africa', 'Northern Africa', 266000, 2453),
('ESP', 'SPAIN', 'Europe', 'Southern Europe', 505992, 653),
('EST', 'ESTONIA', 'Europe', 'Baltic Countries', 45227, 3791),
('ETH', 'ETHIOPIA', 'Africa', 'Eastern Africa', 1104300, 756),
('FIN', 'FINLAND', 'Europe', '* TRIAL * TRIAL ', 338145, 3236),
('FJI', 'FIJI ISLANDS', 'Oceania', '* TRIAL *', 18274, 764),
('FLK', '* TRIAL * TRIAL ', 'South America', 'South America', 12173, 763),
('FRA', 'FRANCE', 'Europe', '* TRIAL * TRIA', 551500, 2974),
('FRO', 'FAROE ISLANDS', 'Europe', 'Nordic Countries', 1399, 901),
('FSM', 'MICRONESIA, FEDERATED STATES OF', 'Oceania', 'Micronesia', 702, 2689),
('GAB', 'GABON', 'Africa', 'Central Africa', 267668, 902),
('GBR', '* TRIAL * TRIA', 'Europe', 'British Islands', 242900, 456),
('GEO', 'GEORGIA', 'Asia', 'Middle East', 69700, 905),
('GHA', 'GHANA', 'Africa', '* TRIAL * TRIA', 238533, 910),
('GIB', '* TRIAL *', 'Europe', '* TRIAL * TRIAL', 6, 915),
('GIN', 'GUINEA', 'Africa', 'Western Africa', 245857, 926),
('GLP', 'GUADELOUPE', 'North America', '* TRIAL *', 1705, 919),
('GMB', 'GAMBIA', 'Africa', 'Western Africa', 11295, 904),
('GNB', '* TRIAL * TRI', 'Africa', 'Western Africa', 36125, 927),
('GNQ', 'EQUATORIAL GUINEA', 'Africa', 'Central Africa', 28051, 2972),
('GRC', 'GREECE', 'Europe', '* TRIAL * TRIAL', 131626, 2401),
('GRD', 'GRENADA', 'North America', '* TRIAL *', 344, 916),
('GRL', 'GREENLAND', 'North America', 'North America', 2166090, 917),
('GTM', '* TRIAL *', '* TRIAL * TRI', '* TRIAL * TRIAL', 108889, 922),
('GUF', 'FRENCH GUIANA', 'South America', 'South America', 90000, 3014),
('GUM', 'GUAM', 'Oceania', '* TRIAL * ', 549, 921),
('GUY', 'GUYANA', 'South America', 'South America', 214969, 928),
('HKG', '* TRIAL *', 'Asia', 'Eastern Asia', 1075, 937),
('HMD', 'HEARD ISLAND AND MCDONALD ISLANDS', 'Antarctica', 'Antarctica', 359, NULL),
('HND', '* TRIAL ', '* TRIAL * TRI', '* TRIAL * TRIAL', 112088, 933),
('HRV', 'CROATIA', 'Europe', '* TRIAL * TRIAL', 56538, 2409),
('HTI', 'HAITI', 'North America', 'Caribbean', 27750, 929),
('HUN', 'HUNGARY', 'Europe', 'Eastern Europe', 93030, 3483),
('IDN', 'INDONESIA', 'Asia', 'Southeast Asia', 1904569, 939),
('IND', 'INDIA', 'Asia', 'Southern and Central Asia', 3287263, 1109),
('IOT', '* TRIAL * TRIAL * TRIAL * TRIA', 'Africa', 'Eastern Africa', 78, NULL),
('IRL', 'IRELAND', 'Europe', 'British Islands', 70273, 1447),
('IRN', 'IRAN', 'Asia', '* TRIAL * TRIAL * TRIAL *', 1648195, 1380),
('IRQ', 'IRAQ', 'Asia', 'Middle East', 438317, 1365),
('ISL', 'ICELAND', 'Europe', 'Nordic Countries', 103000, 1449),
('ISR', 'ISRAEL', 'Asia', '* TRIAL * T', 21056, 1450),
('ITA', 'ITALY', 'Europe', 'Southern Europe', 301316, 1464),
('JAM', 'JAMAICA', 'North America', '* TRIAL *', 10990, 1530),
('JOR', 'JORDAN', 'Asia', 'Middle East', 88946, 1786),
('JPN', 'JAPAN', 'Asia', '* TRIAL * TR', 377829, 1532),
('KAZ', 'KAZAKSTAN', 'Asia', 'Southern and Central Asia', 2724900, 1864),
('KEN', 'KENYA', 'Africa', '* TRIAL * TRIA', 580367, 1881),
('KGZ', '* TRIAL * ', 'Asia', 'Southern and Central Asia', 199900, 2253),
('KHM', 'CAMBODIA', 'Asia', 'Southeast Asia', 181035, 1800),
('KIR', 'KIRIBATI', 'Oceania', 'Micronesia', 726, 2256),
('KNA', 'SAINT KITTS AND NEVIS', '* TRIAL * TRI', 'Caribbean', 261, 3064),
('KOR', 'SOUTH KOREA', 'Asia', '* TRIAL * TR', 99434, 2331),
('KWT', 'KUWAIT', 'Asia', 'Middle East', 17818, 2429),
('LAO', 'LAOS', 'Asia', 'Southeast Asia', 236800, 2432),
('LBN', 'LEBANON', 'Asia', 'Middle East', 10400, 2438),
('LBR', 'LIBERIA', 'Africa', 'Western Africa', 111369, 2440),
('LBY', 'LIBYAN ARAB JAMAHIRIYA', 'Africa', 'Northern Africa', 1759540, 2441),
('LCA', '* TRIAL * T', 'North America', 'Caribbean', 622, 3065),
('LIE', '* TRIAL * TRI', 'Europe', 'Western Europe', 160, 2446),
('LKA', '* TRIAL *', 'Asia', 'Southern and Central Asia', 65610, 3217),
('LSO', 'LESOTHO', 'Africa', 'Southern Africa', 30355, 2437),
('LTU', '* TRIAL *', 'Europe', 'Baltic Countries', 65301, 2447),
('LUX', 'LUXEMBOURG', 'Europe', '* TRIAL * TRIA', 2586, 2452),
('LVA', 'LATVIA', 'Europe', 'Baltic Countries', 64589, 2434),
('MAC', 'MACAO', 'Asia', 'Eastern Asia', 18, 2454),
('MAR', 'MOROCCO', 'Africa', 'Northern Africa', 446550, 2486),
('MCO', 'MONACO', 'Europe', 'Western Europe', 1, 2695),
('MDA', 'MOLDOVA', 'Europe', '* TRIAL * TRIA', 33851, 2690),
('MDG', 'MADAGASCAR', 'Africa', 'Eastern Africa', 587041, 2455),
('MDV', 'MALDIVES', 'Asia', 'Southern and Central Asia', 298, 2463),
('MEX', 'MEXICO', '* TRIAL * TRI', 'Central America', 1958201, 2515),
('MHL', 'MARSHALL ISLANDS', 'Oceania', 'Micronesia', 181, 2507),
('MKD', 'MACEDONIA', 'Europe', 'Southern Europe', 25713, 2460),
('MLI', 'MALI', 'Africa', 'Western Africa', 1240192, 2482),
('MLT', 'MALTA', 'Europe', '* TRIAL * TRIAL', 316, 2484),
('MMR', 'MYANMAR', 'Asia', 'Southeast Asia', 676578, 2710),
('MNG', '* TRIAL ', 'Asia', '* TRIAL * TR', 1566500, 2696),
('MNP', 'NORTHERN MARIANA ISLANDS', 'Oceania', '* TRIAL * ', 464, 2913),
('MOZ', '* TRIAL * ', 'Africa', 'Eastern Africa', 801590, 2698),
('MRT', 'MAURITANIA', 'Africa', 'Western Africa', 1025520, 2509),
('MSR', 'MONTSERRAT', 'North America', '* TRIAL *', 102, 2697),
('MTQ', 'MARTINIQUE', 'North America', 'Caribbean', 1102, 2508),
('MUS', 'MAURITIUS', 'Africa', 'Eastern Africa', 2040, 2511),
('MWI', 'MALAWI', 'Africa', '* TRIAL * TRIA', 118484, 2462),
('MYS', 'MALAYSIA', 'Asia', 'Southeast Asia', 329758, 2464),
('MYT', 'MAYOTTE', 'Africa', 'Eastern Africa', 373, 2514),
('NAM', 'NAMIBIA', 'Africa', 'Southern Africa', 824292, 2726),
('NCL', 'NEW CALEDONIA', 'Oceania', 'Melanesia', 18575, 3493),
('NER', 'NIGER', 'Africa', 'Western Africa', 1267000, 2738),
('NFK', 'NORFOLK ISLAND', 'Oceania', '* TRIAL * TRIAL * TRIAL *', 36, 2806),
('NGA', 'NIGERIA', 'Africa', '* TRIAL * TRIA', 923768, 2754),
('NIC', '* TRIAL *', 'North America', 'Central America', 130000, 2734),
('NIU', 'NIUE', 'Oceania', 'Polynesia', 260, 2805),
('NLD', 'NETHERLANDS', 'Europe', 'Western Europe', 41526, 5),
('NOR', 'NORWAY', 'Europe', 'Nordic Countries', 323877, 2807),
('NPL', 'NEPAL', 'Asia', '* TRIAL * TRIAL * TRIAL *', 147181, 2729),
('NRU', 'NAURU', 'Oceania', 'Micronesia', 21, 2728),
('NZL', 'NEW ZEALAND', 'Oceania', 'Australia and New Zealand', 270534, 3499),
('OMN', 'OMAN', 'Asia', 'Middle East', 309500, 2821),
('PAK', 'PAKISTAN', 'Asia', 'Southern and Central Asia', 796095, 2831),
('PAN', 'PANAMA', '* TRIAL * TRI', 'Central America', 75517, 2882),
('PCN', '* TRIAL ', 'Oceania', 'Polynesia', 49, 2912),
('PER', 'PERÚ', '* TRIAL * TRI', '* TRIAL * TRI', 1285216, 2890),
('PHL', 'PHILIPPINES', 'Asia', 'Southeast Asia', 300000, 766),
('PLW', 'PALAU', 'Oceania', 'Micronesia', 459, 2881),
('PNG', 'PAPUA NEW GUINEA', 'Oceania', 'Melanesia', 462840, 2884),
('POL', 'POLAND', 'Europe', '* TRIAL * TRIA', 323250, 2928),
('PRI', 'PUERTO RICO', 'North America', '* TRIAL *', 8875, 2919),
('PRK', 'NORTH KOREA', 'Asia', '* TRIAL * TR', 120538, 2318),
('PRT', '* TRIAL ', 'Europe', 'Southern Europe', 91982, 2914),
('PRY', 'PARAGUAY', 'South America', '* TRIAL * TRI', 406752, 2885),
('PSE', 'PALESTINE', 'Asia', 'Middle East', 6257, 4074),
('PYF', 'FRENCH POLYNESIA', 'Oceania', '* TRIAL *', 4000, 3016),
('QAT', 'QATAR', 'Asia', 'Middle East', 11000, 2973),
('REU', 'RÉUNION', 'Africa', 'Eastern Africa', 2510, 3017),
('ROM', 'ROMANIA', 'Europe', 'Eastern Europe', 238391, 3018),
('RUS', 'RUSSIAN FEDERATION', 'Europe', 'Eastern Europe', 17075400, 3580),
('RWA', 'RWANDA', 'Africa', 'Eastern Africa', 26338, 3047),
('SAU', '* TRIAL * TR', 'Asia', '* TRIAL * T', 2149690, 3173),
('SDN', 'SUDAN', 'Africa', 'Northern Africa', 2505813, 3225),
('SEN', 'SENEGAL', 'Africa', '* TRIAL * TRIA', 196722, 3198),
('SGP', 'SINGAPORE', 'Asia', 'Southeast Asia', 618, 3208),
('SGS', 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 'Antarctica', 'Antarctica', 3903, NULL),
('SHN', 'SAINT HELENA', 'Africa', '* TRIAL * TRIA', 314, 3063),
('SJM', 'SVALBARD AND JAN MAYEN', 'Europe', 'Nordic Countries', 62422, 938),
('SLB', 'SOLOMON ISLANDS', 'Oceania', '* TRIAL *', 28896, 3161),
('SLE', 'SIERRA LEONE', 'Africa', 'Western Africa', 71740, 3207),
('SLV', 'EL SALVADOR', 'North America', '* TRIAL * TRIAL', 21041, 645),
('SMR', 'SAN MARINO', 'Europe', 'Southern Europe', 61, 3171),
('SOM', 'SOMALIA', 'Africa', '* TRIAL * TRIA', 637657, 3214),
('SPM', 'SAINT PIERRE AND MIQUELON', 'North America', 'North America', 242, 3067),
('STP', 'SAO TOME AND PRINCIPE', 'Africa', '* TRIAL * TRIA', 964, 3172),
('SUR', 'SURINAME', 'South America', '* TRIAL * TRI', 163265, 3243),
('SVK', '* TRIAL ', 'Europe', 'Eastern Europe', 49012, 3209),
('SVN', '* TRIAL ', 'Europe', 'Southern Europe', 20256, 3212),
('SWE', 'SWEDEN', 'Europe', 'Nordic Countries', 449964, 3048),
('SWZ', 'SWAZILAND', 'Africa', '* TRIAL * TRIAL', 17364, 3244),
('SYC', '* TRIAL * ', 'Africa', 'Eastern Africa', 455, 3206),
('SYR', 'SYRIA', 'Asia', '* TRIAL * T', 185180, 3250),
('TCA', '* TRIAL * TRIAL * TRIAL ', 'North America', 'Caribbean', 430, 3423),
('TCD', 'CHAD', 'Africa', '* TRIAL * TRIA', 1284000, 3337),
('TGO', 'TOGO', 'Africa', 'Western Africa', 56785, 3332),
('THA', 'THAILAND', 'Asia', 'Southeast Asia', 513115, 3320),
('TJK', 'TAJIKISTAN', 'Asia', 'Southern and Central Asia', 143100, 3261),
('TKL', 'TOKELAU', 'Oceania', 'Polynesia', 12, 3333),
('TKM', 'TURKMENISTAN', 'Asia', '* TRIAL * TRIAL * TRIAL *', 488100, 3419),
('TMP', 'EAST TIMOR', 'Asia', 'Southeast Asia', 14874, 1522),
('TON', 'TONGA', 'Oceania', 'Polynesia', 650, 3334),
('TTO', 'TRINIDAD AND TOBAGO', '* TRIAL * TRI', 'Caribbean', 5130, 3336),
('TUN', 'TUNISIA', 'Africa', '* TRIAL * TRIAL', 163610, 3349),
('TUR', 'TURKEY', 'Asia', 'Middle East', 774815, 3358),
('TUV', 'TUVALU', 'Oceania', 'Polynesia', 26, 3424),
('TWN', 'TAIWAN', 'Asia', 'Eastern Asia', 36188, 3263),
('TZA', 'TANZANIA', 'Africa', 'Eastern Africa', 883749, 3306),
('UGA', 'UGANDA', 'Africa', 'Eastern Africa', 241038, 3425),
('UKR', 'UKRAINE', 'Europe', 'Eastern Europe', 603700, 3426),
('UMI', 'UNITED STATES MINOR OUTLYING ISLANDS', 'Oceania', 'Micronesia/Caribbean', 16, NULL),
('URY', 'URUGUAY', 'South America', '* TRIAL * TRI', 175016, 3492),
('USA', 'UNITED STATES', 'North America', 'North America', 9363520, 3813),
('UZB', 'UZBEKISTAN', 'Asia', 'Southern and Central Asia', 447400, 3503),
('VAT', 'HOLY SEE (VATICAN CITY STATE)', 'Europe', '* TRIAL * TRIAL', 0, 3538),
('VCT', 'SAINT VINCENT AND THE GRENADINES', 'North America', 'Caribbean', 388, 3066),
('VEN', '* TRIAL *', 'South America', 'South America', 912050, 3539),
('VGB', 'VIRGIN ISLANDS, BRITISH', 'North America', 'Caribbean', 151, 537),
('VIR', 'VIRGIN ISLANDS, U.S.', 'North America', 'Caribbean', 347, 4067),
('VNM', 'VIETNAM', 'Asia', 'Southeast Asia', 331689, 3770),
('VUT', 'VANUATU', 'Oceania', 'Melanesia', 12189, 3537),
('WLF', 'WALLIS AND FUTUNA', 'Oceania', '* TRIAL *', 200, 3536),
('WSM', 'SAMOA', 'Oceania', '* TRIAL *', 2831, 3169),
('YEM', 'YEMEN', 'Asia', 'Middle East', 527968, 1780),
('YUG', '* TRIAL * ', 'Europe', '* TRIAL * TRIAL', 102173, 1792),
('ZAF', 'SOUTH AFRICA', 'Africa', 'Southern Africa', 1221037, 716),
('ZMB', 'ZAMBIA', 'Africa', '* TRIAL * TRIA', 752618, 3162),
('ZWE', 'ZIMBABWE', 'Africa', 'Eastern Africa', 390757, 4068);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisomenustb`
--

CREATE TABLE `permisomenustb` (
  `idrol` int(11) NOT NULL,
  `idmenus` int(11) NOT NULL,
  `estado` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `permisomenustb`
--

INSERT INTO `permisomenustb` (`idrol`, `idmenus`, `estado`) VALUES
(1, 1, b'1'),
(1, 2, b'1'),
(1, 3, b'1'),
(1, 4, b'1'),
(1, 5, b'0'),
(1, 6, b'1'),
(1, 7, b'1'),
(1, 8, b'1'),
(1, 9, b'1'),
(2, 1, b'0'),
(2, 2, b'1'),
(2, 3, b'1'),
(2, 4, b'0'),
(2, 5, b'0'),
(2, 6, b'0'),
(2, 7, b'0'),
(2, 8, b'0'),
(2, 9, b'0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisoprivilegiostb`
--

CREATE TABLE `permisoprivilegiostb` (
  `idrol` int(11) NOT NULL,
  `idprivilegio` int(11) NOT NULL,
  `estado` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `permisoprivilegiostb`
--

INSERT INTO `permisoprivilegiostb` (`idrol`, `idprivilegio`, `estado`) VALUES
(1, 1, b'1'),
(1, 2, b'1'),
(1, 3, b'1'),
(1, 4, b'1'),
(1, 5, b'1'),
(1, 6, b'1'),
(1, 7, b'1'),
(1, 8, b'1'),
(1, 9, b'1'),
(1, 10, b'1'),
(1, 11, b'1'),
(1, 12, b'1'),
(1, 13, b'1'),
(1, 14, b'1'),
(1, 15, b'1'),
(1, 16, b'1'),
(1, 17, b'1'),
(1, 18, b'1'),
(1, 19, b'1'),
(1, 20, b'1'),
(1, 21, b'1'),
(1, 22, b'1'),
(1, 23, b'1'),
(1, 24, b'1'),
(1, 25, b'1'),
(1, 26, b'1'),
(1, 27, b'1'),
(1, 28, b'1'),
(1, 29, b'1'),
(1, 30, b'1'),
(1, 31, b'1'),
(1, 32, b'1'),
(1, 33, b'1'),
(1, 34, b'1'),
(1, 35, b'1'),
(1, 36, b'1'),
(1, 37, b'1'),
(1, 38, b'1'),
(1, 39, b'1'),
(1, 40, b'1'),
(1, 41, b'1'),
(1, 42, b'1'),
(1, 43, b'1'),
(1, 44, b'1'),
(1, 45, b'1'),
(1, 46, b'1'),
(1, 47, b'1'),
(1, 48, b'1'),
(1, 49, b'1'),
(1, 50, b'1'),
(1, 51, b'1'),
(1, 52, b'1'),
(1, 53, b'1'),
(1, 54, b'1'),
(1, 55, b'1'),
(1, 56, b'1'),
(1, 57, b'1'),
(1, 58, b'1'),
(1, 59, b'1'),
(1, 60, b'1'),
(1, 61, b'1'),
(1, 62, b'1'),
(1, 63, b'1'),
(1, 64, b'1'),
(1, 65, b'1'),
(1, 66, b'1'),
(1, 67, b'1'),
(1, 68, b'1'),
(1, 69, b'1'),
(1, 70, b'1'),
(1, 71, b'1'),
(1, 72, b'1'),
(1, 73, b'1'),
(1, 74, b'1'),
(1, 75, b'1'),
(1, 76, b'1'),
(1, 77, b'1'),
(1, 78, b'1'),
(1, 79, b'1'),
(1, 80, b'1'),
(1, 81, b'0'),
(2, 1, b'0'),
(2, 2, b'1'),
(2, 3, b'1'),
(2, 4, b'1'),
(2, 5, b'1'),
(2, 6, b'0'),
(2, 7, b'0'),
(2, 8, b'0'),
(2, 9, b'1'),
(2, 10, b'1'),
(2, 11, b'1'),
(2, 12, b'1'),
(2, 13, b'1'),
(2, 14, b'1'),
(2, 15, b'1'),
(2, 16, b'0'),
(2, 17, b'0'),
(2, 18, b'0'),
(2, 19, b'0'),
(2, 20, b'0'),
(2, 21, b'0'),
(2, 22, b'0'),
(2, 23, b'0'),
(2, 24, b'0'),
(2, 25, b'0'),
(2, 26, b'0'),
(2, 27, b'0'),
(2, 28, b'0'),
(2, 29, b'0'),
(2, 30, b'0'),
(2, 31, b'0'),
(2, 32, b'0'),
(2, 33, b'0'),
(2, 34, b'1'),
(2, 35, b'1'),
(2, 36, b'0'),
(2, 37, b'0'),
(2, 38, b'0'),
(2, 39, b'0'),
(2, 40, b'0'),
(2, 41, b'0'),
(2, 42, b'0'),
(2, 43, b'1'),
(2, 44, b'1'),
(2, 45, b'1'),
(2, 46, b'1'),
(2, 47, b'0'),
(2, 48, b'1'),
(2, 49, b'0'),
(2, 50, b'1'),
(2, 51, b'0'),
(2, 52, b'1'),
(2, 53, b'1'),
(2, 54, b'1'),
(2, 55, b'1'),
(2, 56, b'0'),
(2, 57, b'1'),
(2, 58, b'0'),
(2, 59, b'1'),
(2, 60, b'1'),
(2, 61, b'1'),
(2, 62, b'1'),
(2, 63, b'1'),
(2, 64, b'1'),
(2, 65, b'1'),
(2, 66, b'1'),
(2, 67, b'1'),
(2, 68, b'1'),
(2, 69, b'1'),
(2, 70, b'1'),
(2, 71, b'1'),
(2, 72, b'1'),
(2, 73, b'1'),
(2, 74, b'1'),
(2, 75, b'1'),
(2, 76, b'1'),
(2, 77, b'0'),
(2, 78, b'1'),
(2, 79, b'0'),
(2, 80, b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisosubmenustb`
--

CREATE TABLE `permisosubmenustb` (
  `id` int(11) NOT NULL,
  `idrol` int(11) DEFAULT NULL,
  `idmenus` int(11) DEFAULT NULL,
  `idsubmenus` int(11) DEFAULT NULL,
  `estado` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `permisosubmenustb`
--

INSERT INTO `permisosubmenustb` (`id`, `idrol`, `idmenus`, `idsubmenus`, `estado`) VALUES
(1, 1, 2, 1, b'1'),
(2, 1, 2, 2, b'1'),
(3, 1, 2, 3, b'1'),
(4, 1, 2, 4, b'1'),
(5, 1, 2, 5, b'1'),
(6, 1, 3, 7, b'1'),
(7, 1, 3, 8, b'1'),
(8, 1, 3, 10, b'1'),
(9, 1, 3, 11, b'1'),
(10, 1, 4, 12, b'1'),
(11, 1, 4, 13, b'1'),
(12, 1, 4, 14, b'1'),
(13, 1, 4, 15, b'1'),
(14, 1, 4, 16, b'1'),
(15, 1, 4, 17, b'1'),
(16, 1, 4, 18, b'1'),
(17, 1, 5, 19, b'0'),
(18, 1, 5, 20, b'0'),
(19, 1, 6, 21, b'1'),
(20, 1, 6, 22, b'1'),
(21, 1, 9, 23, b'1'),
(22, 1, 9, 24, b'1'),
(23, 1, 9, 25, b'1'),
(24, 1, 9, 26, b'1'),
(25, 1, 9, 27, b'1'),
(26, 1, 9, 28, b'1'),
(27, 1, 9, 29, b'1'),
(28, 1, 9, 30, b'1'),
(29, 1, 9, 31, b'1'),
(30, 2, 2, 1, b'1'),
(31, 2, 2, 2, b'0'),
(32, 2, 2, 3, b'0'),
(33, 2, 2, 4, b'1'),
(34, 2, 2, 5, b'0'),
(35, 2, 3, 7, b'1'),
(36, 2, 3, 8, b'0'),
(37, 2, 3, 10, b'0'),
(38, 2, 3, 11, b'0'),
(39, 2, 4, 12, b'0'),
(40, 2, 4, 13, b'0'),
(41, 2, 4, 14, b'0'),
(42, 2, 4, 15, b'0'),
(43, 2, 4, 16, b'0'),
(44, 2, 4, 17, b'0'),
(45, 2, 4, 18, b'0'),
(46, 2, 5, 19, b'0'),
(47, 2, 5, 20, b'0'),
(48, 2, 6, 21, b'0'),
(49, 2, 6, 22, b'0'),
(50, 2, 9, 23, b'0'),
(51, 2, 9, 24, b'0'),
(52, 2, 9, 25, b'0'),
(53, 2, 9, 26, b'0'),
(54, 2, 9, 27, b'0'),
(55, 2, 9, 28, b'0'),
(56, 2, 9, 29, b'0'),
(57, 2, 9, 30, b'0'),
(58, 2, 9, 31, b'0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plazostb`
--

CREATE TABLE `plazostb` (
  `idplazos` int(11) NOT NULL,
  `nombre` varchar(15) DEFAULT NULL,
  `dias` int(11) DEFAULT NULL,
  `estado` bit(1) DEFAULT NULL,
  `predeterminado` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preciostb`
--

CREATE TABLE `preciostb` (
  `idprecios` int(11) NOT NULL,
  `idarticulo` varchar(12) NOT NULL,
  `idsuministro` varchar(12) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `valor` decimal(18,8) NOT NULL,
  `factor` decimal(18,8) DEFAULT NULL,
  `estado` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `privilegiostb`
--

CREATE TABLE `privilegiostb` (
  `idprivilegio` int(11) NOT NULL,
  `idsubmenu` int(11) DEFAULT NULL,
  `nombre` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `privilegiostb`
--

INSERT INTO `privilegiostb` (`idprivilegio`, `idsubmenu`, `nombre`) VALUES
(1, 1, '* TRIAL * TRIAL * TRIA'),
(2, 1, 'COBRAR'),
(3, 1, '* TRIAL * TRIAL'),
(4, 1, 'LISTA DE PRECIO'),
(5, 1, 'CANTIDAD'),
(6, 1, 'CAMBIAR PRECIO'),
(7, 1, 'DESCUENTO'),
(8, 1, 'SUMAR PRECIO'),
(9, 1, 'QUITAR ARTICULO'),
(10, 1, '* TRIAL * TRIAL * '),
(11, 1, 'IMPRESORA'),
(12, 1, 'CANCELAR VENTA'),
(13, 1, '* TRIAL * TRIA'),
(14, 1, 'CAMBIAR TIPO DE DOCUMENTO'),
(15, 1, '* TRIAL * TRIAL * TRIA'),
(16, 2, '* TRIAL * TRIAL'),
(17, 2, 'RECARGAR'),
(18, 2, 'ETIQUETA'),
(19, 2, 'BUSCAR POR CLAVE O CLAVE ALTERNA'),
(20, 2, 'BUSCAR POR DESCIPCIÓN'),
(21, 2, 'BUSCAR POR CATEGORÍA'),
(22, 2, 'BUSCAR POR MARCA'),
(23, 3, '* TRIAL * TRIAL '),
(24, 3, 'BUSCAR SUMINISTRO'),
(25, 3, 'EDITAR SUMINISTRO'),
(26, 3, 'QUITAR SUMINISTRO'),
(27, 3, '* TRIAL * TRIAL '),
(28, 3, 'EDITAR FECHA DE COMPRA'),
(29, 3, 'CAMBIAR TIPO DE COMPROBANTE'),
(30, 3, 'INGRESAR NUMERACIÓN'),
(31, 3, '* TRIAL * TRIAL * TRIAL * TRIAL * TRIA'),
(32, 3, 'INGRESAR OBSERVACIÓN'),
(33, 3, 'INGRESAR NOTAS'),
(34, 4, '* TRIAL * TRIA'),
(35, 4, '* TRIAL * TRIAL * TRIAL * TR'),
(36, 5, 'BUSCAR ARTÍCULO'),
(37, 5, 'REMOVER ARTÍCULO'),
(38, 5, '* TRIAL * TRIAL * T'),
(39, 5, 'INGRESAR UN PROVEEDOR'),
(40, 5, 'CAMBIAR TIPO DE MOVIMIENTO'),
(41, 5, '* TRIAL * TRIAL * TRIAL * TRI'),
(42, 5, 'INGRESAR UNA OBSERVACIÓN'),
(43, 1, '* TRIAL * TRIAL * TRIA'),
(44, 1, 'CAMBIAR CANTIDADES DESDE LA TABLA '),
(45, 1, '* TRIAL * TRIAL * TRIAL * TRIA'),
(46, 1, 'CAMBIAR CANTIDADES A LOS PRODUCTOS BASADOS EN UNIDADES '),
(47, 1, 'CAMBIAR PRECIO A LOS PRODUCTOS BASADOS EN UNIDADES'),
(48, 1, 'APLICAR DESCUENTO A LOS PRODUCTOS BASADOS EN UNIDADES'),
(49, 1, '* TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIA'),
(50, 1, 'CAMBIAR PRECIO DE LOS PRODUCTOS  BASADO EN VALOR MONETARIO'),
(51, 1, '* TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * T'),
(52, 7, 'MOSTRAR DETALLE'),
(53, 7, 'RECARGAR'),
(54, 7, '* TRIAL * TRI'),
(55, 7, '* TRIAL * T'),
(56, 7, '* TRIAL * TRIAL *'),
(57, 7, 'ESTADO DE LA VENTA'),
(58, 7, 'VENDEDOR'),
(59, 7, 'BUSQUEDA POR CLIENTE O SERIE/NUMERACIÓN'),
(60, 12, '* TRIAL * TRIAL '),
(61, 12, 'EDITAR PRODUCTO'),
(62, 12, 'CLONAR PRODUCTO'),
(63, 12, 'RECARGAR LISTA'),
(64, 12, 'IMPRIMIR ETIQUETA'),
(65, 12, '* TRIAL * TRIAL *'),
(66, 12, '* TRIAL * TRIAL * TRIAL * TRIAL '),
(67, 12, '* TRIAL * TRIAL * TRIAL'),
(68, 12, '* TRIAL * TRIAL * TR'),
(69, 12, '* TRIAL * TRIAL '),
(70, 12, 'EDITAR EL COSTO DEL ARTICULO'),
(71, 1, '* TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL *'),
(72, 1, 'CAMBIAR PRECIO A LOS PRODUCTOS BASADOS EN MEDIDA'),
(73, 1, 'APLICAR DESCUENTO A LOS PRODUCTOS BASADOS EN MEDIDA'),
(74, 1, 'MOSTRAR LA COLUMNA OPCION DE LA TABLA'),
(75, 1, 'MOSTRAR LA COLUMNA CANTIDAD DE LA TABLA'),
(76, 1, '* TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * '),
(77, 1, 'MOSTRAR LA COLUMNA IMPUESTO DE LA TABLA'),
(78, 1, 'MOSTRAR LA COLUMNA PRECIO DE LA TABLA'),
(79, 1, 'MOSTRAR LA COLUMNA DESCUENTO DE LA TABLA'),
(80, 1, '* TRIAL * TRIAL * TRIAL * TRIAL * TRIA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedortb`
--

CREATE TABLE `proveedortb` (
  `idproveedor` varchar(12) NOT NULL,
  `tipodocumento` int(11) NOT NULL,
  `numerodocumento` varchar(20) NOT NULL,
  `razonsocial` varchar(100) NOT NULL,
  `nombrecomercial` varchar(100) DEFAULT NULL,
  `pais` char(3) DEFAULT NULL,
  `ciudad` int(11) DEFAULT NULL,
  `provincia` int(11) DEFAULT NULL,
  `distrito` int(11) DEFAULT NULL,
  `ambito` int(11) DEFAULT NULL,
  `estado` int(11) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `paginaweb` varchar(100) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `usuarioregistro` varchar(15) NOT NULL,
  `fecharegistro` datetime NOT NULL,
  `representante` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provinciatb`
--

CREATE TABLE `provinciatb` (
  `idprovincia` int(11) NOT NULL DEFAULT 0,
  `provincia` varchar(50) DEFAULT NULL,
  `idciudad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `provinciatb`
--

INSERT INTO `provinciatb` (`idprovincia`, `provincia`, `idciudad`) VALUES
(1, '* TRIAL * TR', 1),
(2, 'BAGUA', 1),
(3, 'BONGARA', 1),
(4, '* TRIAL * TR', 1),
(5, 'LUYA', 1),
(6, 'RODRIGUEZ DE MENDOZA', 1),
(7, '* TRIAL *', 1),
(8, 'HUARAZ', 2),
(9, 'AIJA', 2),
(10, 'ANTONIO RAYMONDI', 2),
(11, 'ASUNCION', 2),
(12, 'BOLOGNESI', 2),
(13, 'CARHUAZ', 2),
(14, '* TRIAL * TRIAL * TRIAL *', 2),
(15, 'CASMA', 2),
(16, 'CORONGO', 2),
(17, 'HUARI', 2),
(18, 'HUARMEY', 2),
(19, 'HUAYLAS', 2),
(20, 'MARISCAL LUZURIAGA', 2),
(21, 'OCROS', 2),
(22, 'PALLASCA', 2),
(23, 'POMABAMBA', 2),
(24, 'RECUAY', 2),
(25, 'SANTA', 2),
(26, 'SIHUAS', 2),
(27, 'YUNGAY', 2),
(28, 'ABANCAY', 3),
(29, 'ANDAHUAYLAS', 3),
(30, '* TRIAL *', 3),
(31, '* TRIAL ', 3),
(32, '* TRIAL * ', 3),
(33, 'CHINCHEROS', 3),
(34, 'GRAU', 3),
(35, '* TRIAL ', 4),
(36, 'CAMANA', 4),
(37, '* TRIAL ', 4),
(38, 'CASTILLA', 4),
(39, '* TRIAL ', 4),
(40, 'CONDESUYOS', 4),
(41, 'ISLAY', 4),
(42, '* TRIAL ', 4),
(43, '* TRIAL ', 5),
(44, 'CANGALLO', 5),
(45, 'HUANCA SANCOS', 5),
(46, 'HUANTA', 5),
(47, 'LA MAR', 5),
(48, 'LUCANAS', 5),
(49, 'PARINACOCHAS', 5),
(50, 'PAUCAR DEL SARA SARA', 5),
(51, 'SUCRE', 5),
(52, 'VICTOR FAJARDO', 5),
(53, 'VILCAS HUAMAN', 5),
(54, 'CAJAMARCA', 6),
(55, 'CAJABAMBA', 6),
(56, 'CELENDIN', 6),
(57, 'CHOTA ', 6),
(58, 'CONTUMAZA', 6),
(59, 'CUTERVO', 6),
(60, 'HUALGAYOC', 6),
(61, 'JAEN', 6),
(62, '* TRIAL * T', 6),
(63, '* TRIAL * ', 6),
(64, '* TRIAL *', 6),
(65, 'SANTA CRUZ', 6),
(66, 'CALLAO', 7),
(67, 'CUSCO', 8),
(68, 'ACOMAYO', 8),
(69, 'ANTA', 8),
(70, 'CALCA', 8),
(71, 'CANAS', 8),
(72, 'CANCHIS', 8),
(73, 'CHUMBIVILCAS', 8),
(74, 'ESPINAR', 8),
(75, 'LA CONVENCION', 8),
(76, 'PARURO', 8),
(77, '* TRIAL * T', 8),
(78, '* TRIAL * TR', 8),
(79, 'URUBAMBA', 8),
(80, 'HUANCAVELICA', 9),
(81, 'ACOBAMBA', 9),
(82, 'ANGARAES', 9),
(83, 'CASTROVIRREYNA', 9),
(84, 'CHURCAMPA', 9),
(85, 'HUAYTARA', 9),
(86, 'TAYACAJA', 9),
(87, 'HUANUCO', 10),
(88, 'AMBO', 10),
(89, 'DOS DE MAYO', 10),
(90, '* TRIAL * T', 10),
(91, 'HUAMALIES', 10),
(92, 'LEONCIO PRADO', 10),
(93, 'MARA&Ntilde;ON', 10),
(94, 'PACHITEA', 10),
(95, '* TRIAL * T', 10),
(96, 'LAURICOCHA', 10),
(97, 'YAROWILCA', 10),
(98, 'ICA', 11),
(99, 'CHINCHA', 11),
(100, 'NAZCA', 11),
(101, 'PALPA', 11),
(102, 'PISCO', 11),
(103, '* TRIAL ', 12),
(104, 'CONCEPCION', 12),
(105, '* TRIAL * T', 12),
(106, 'JAUJA', 12),
(107, 'JUNIN', 12),
(108, 'SATIPO', 12),
(109, 'TARMA', 12),
(110, 'YAULI', 12),
(111, 'CHUPACA', 12),
(112, 'TRUJILLO', 13),
(113, 'ASCOPE', 13),
(114, 'BOLIVAR', 13),
(115, 'CHEPEN', 13),
(116, 'JULCAN', 13),
(117, 'OTUZCO', 13),
(118, '* TRIAL *', 13),
(119, 'PATAZ', 13),
(120, '* TRIAL * TRIAL', 13),
(121, 'SANTIAGO DE CHUCO', 13),
(122, 'GRAN CHIMU', 13),
(123, 'VIRU', 13),
(124, 'CHICLAYO', 14),
(125, 'FERRE&Ntilde;AFE', 14),
(126, '* TRIAL * ', 14),
(127, 'LIMA', 15),
(128, 'BARRANCA', 15),
(129, '* TRIAL *', 15),
(130, 'CANTA', 15),
(131, 'CA&Ntilde;ETE', 15),
(132, 'HUARAL', 15),
(133, 'HUAROCHIRI', 15),
(134, 'HUAURA', 15),
(135, 'OYON', 15),
(136, 'YAUYOS', 15),
(137, 'MAYNAS', 16),
(138, 'ALTO AMAZONAS', 16),
(139, 'LORETO', 16),
(140, 'MARISCAL RAMON CASTILLA', 16),
(141, 'REQUENA', 16),
(142, 'UCAYALI', 16),
(143, 'TAMBOPATA', 17),
(144, 'MANU', 17),
(145, '* TRIAL *', 17),
(146, '* TRIAL * TRIA', 18),
(147, 'GENERAL SANCHEZ CERRO', 18),
(148, 'ILO', 18),
(149, 'PASCO', 19),
(150, 'DANIEL ALCIDES CARRION', 19),
(151, 'OXAPAMPA', 19),
(152, 'PIURA', 20),
(153, 'AYABACA', 20),
(154, 'HUANCABAMBA', 20),
(155, 'MORROPON', 20),
(156, 'PAITA', 20),
(157, 'SULLANA', 20),
(158, 'TALARA', 20),
(159, 'SECHURA', 20),
(160, 'PUNO', 21),
(161, 'AZANGARO', 21),
(162, 'CARABAYA', 21),
(163, '* TRIAL ', 21),
(164, 'EL COLLAO', 21),
(165, 'HUANCANE', 21),
(166, 'LAMPA', 21),
(167, 'MELGAR', 21),
(168, 'MOHO', 21),
(169, '* TRIAL * TRIAL * TRI', 21),
(170, '* TRIAL *', 21),
(171, 'SANDIA', 21),
(172, 'YUNGUYO', 21),
(173, 'MOYOBAMBA', 22),
(174, '* TRIAL * ', 22),
(175, 'EL DORADO', 22),
(176, '* TRIAL ', 22),
(177, 'LAMAS', 22),
(178, '* TRIAL * TRIAL ', 22),
(179, 'PICOTA', 22),
(180, 'RIOJA', 22),
(181, '* TRIAL * ', 22),
(182, 'TOCACHE', 22),
(183, 'TACNA', 23),
(184, 'CANDARAVE', 23),
(185, 'JORGE BASADRE', 23),
(186, 'TARATA', 23),
(187, 'TUMBES', 24),
(188, '* TRIAL * TRIAL * TRI', 24),
(189, '* TRIAL *', 24),
(190, 'CORONEL PORTILLO', 25),
(191, 'ATALAYA', 25),
(192, '* TRIAL * ', 25),
(193, 'PURUS', 25);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roltb`
--

CREATE TABLE `roltb` (
  `idrol` int(11) NOT NULL,
  `nombre` varchar(60) NOT NULL,
  `sistema` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `roltb`
--

INSERT INTO `roltb` (`idrol`, `nombre`, `sistema`) VALUES
(1, 'ADMINISTRADOR(A)', b'1'),
(2, 'CAJA', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `submenutb`
--

CREATE TABLE `submenutb` (
  `idsubmenu` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `idmenu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `submenutb`
--

INSERT INTO `submenutb` (`idsubmenu`, `nombre`, `idmenu`) VALUES
(1, 'VENTAS', 2),
(2, '* TRIAL *', 2),
(3, 'COMPRAS', 2),
(4, 'CORTE CAJA', 2),
(5, '* TRIAL * T', 2),
(7, 'VENTAS REALIZADAS', 3),
(8, 'COMPRAS REALIZADAS', 3),
(10, 'KARDEX ARTÍCULO', 3),
(11, 'CORTE CAJA', 3),
(12, 'PRODUCTOS', 4),
(13, 'KARDEX PRODUCTO', 4),
(14, '* TRIAL * TRIAL ', 4),
(15, 'INVENTARIO INICIAL', 4),
(16, 'MOVIMIENTOS', 4),
(17, 'ASIGNACION DE PRODUCTOS', 4),
(18, 'PRODUCTOS LOTE', 4),
(19, 'PRODUCIR', 5),
(20, 'EQUIPOS', 5),
(21, 'CLIENTES', 6),
(22, 'PROVEEDOR', 6),
(23, 'MI EMPRESA', 9),
(24, 'TABLAS BÁSICAS', 9),
(25, 'ROLES', 9),
(26, 'EMPLEADOS', 9),
(27, 'MONEDA', 9),
(28, '* TRIAL * T', 9),
(29, 'IMPUESTOS', 9),
(30, 'TICKETS', 9),
(31, '* TRIAL *', 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `suministrotb`
--

CREATE TABLE `suministrotb` (
  `idsuministro` varchar(12) NOT NULL,
  `origen` int(11) NOT NULL,
  `clave` varchar(45) NOT NULL,
  `clavealterna` varchar(45) DEFAULT NULL,
  `nombremarca` varchar(120) NOT NULL,
  `nombregenerico` varchar(120) DEFAULT NULL,
  `categoria` int(11) DEFAULT NULL,
  `marca` int(11) DEFAULT NULL,
  `presentacion` int(11) DEFAULT NULL,
  `unidadcompra` int(11) DEFAULT NULL,
  `unidadventa` tinyint(3) UNSIGNED DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `stockminimo` decimal(18,4) DEFAULT NULL,
  `stockmaximo` decimal(18,4) DEFAULT NULL,
  `cantidad` decimal(18,8) DEFAULT NULL,
  `impuesto` int(11) DEFAULT NULL,
  `tipoprecio` bit(1) DEFAULT NULL,
  `preciocompra` decimal(18,8) DEFAULT NULL,
  `precioventageneral` decimal(18,8) DEFAULT NULL,
  `preciomargengeneral` smallint(6) DEFAULT NULL,
  `precioutilidadgeneral` decimal(18,8) DEFAULT NULL,
  `lote` bit(1) DEFAULT NULL,
  `inventario` bit(1) DEFAULT NULL,
  `valorinventario` tinyint(3) UNSIGNED DEFAULT NULL,
  `imagen` longtext DEFAULT NULL,
  `clavesat` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tickettb`
--

CREATE TABLE `tickettb` (
  `idticket` int(11) NOT NULL,
  `nombre` varchar(60) NOT NULL,
  `tipo` int(11) NOT NULL,
  `predeterminado` bit(1) NOT NULL,
  `ruta` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tickettb`
--

INSERT INTO `tickettb` (`idticket`, `nombre`, `tipo`, `predeterminado`, `ruta`) VALUES
(1, '* TRIAL ', 1, b'1', '* TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL * TRIAL *');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipodocumentotb`
--

CREATE TABLE `tipodocumentotb` (
  `idtipodocumento` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `serie` varchar(50) DEFAULT NULL,
  `predeterminado` bit(1) DEFAULT NULL,
  `nombreimpresion` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoetiquetatb`
--

CREATE TABLE `tipoetiquetatb` (
  `idtipoetiqueta` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipoetiquetatb`
--

INSERT INTO `tipoetiquetatb` (`idtipoetiqueta`, `nombre`) VALUES
(1, '* TRIAL '),
(2, 'Lotes'),
(3, 'Compra');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipomovimientotb`
--

CREATE TABLE `tipomovimientotb` (
  `idtipomovimiento` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `predeterminado` bit(1) NOT NULL,
  `sistema` bit(1) NOT NULL,
  `ajuste` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipomovimientotb`
--

INSERT INTO `tipomovimientotb` (`idtipomovimiento`, `nombre`, `predeterminado`, `sistema`, `ajuste`) VALUES
(1, 'SALIDA', b'1', b'1', b'0'),
(2, 'ENTRADA', b'0', b'1', b'1'),
(3, 'DEVOLUCION', b'0', b'1', b'1'),
(4, 'AJUSTE', b'0', b'1', b'0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipotickettb`
--

CREATE TABLE `tipotickettb` (
  `idtipoticket` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipotickettb`
--

INSERT INTO `tipotickettb` (`idtipoticket`, `nombre`) VALUES
(1, 'Venta');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventatb`
--

CREATE TABLE `ventatb` (
  `idventa` varchar(12) NOT NULL,
  `cliente` varchar(12) DEFAULT NULL,
  `vendedor` varchar(12) NOT NULL,
  `comprobante` int(11) NOT NULL,
  `moneda` int(11) DEFAULT NULL,
  `serie` varchar(8) NOT NULL,
  `numeracion` varchar(16) NOT NULL,
  `fechaventa` date NOT NULL,
  `horaventa` time DEFAULT NULL,
  `fechavencimiento` date DEFAULT NULL,
  `horavencimiento` time DEFAULT NULL,
  `subtotal` decimal(18,8) NOT NULL,
  `descuento` decimal(18,8) NOT NULL,
  `total` decimal(18,8) NOT NULL,
  `tipo` int(11) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `observaciones` varchar(200) DEFAULT NULL,
  `efectivo` decimal(18,4) DEFAULT NULL,
  `vuelto` decimal(18,4) DEFAULT NULL,
  `codigo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asignaciondetalletb`
--
ALTER TABLE `asignaciondetalletb`
  ADD PRIMARY KEY (`idasignacion`,`idsuministro`);

--
-- Indices de la tabla `asignaciontb`
--
ALTER TABLE `asignaciontb`
  ADD PRIMARY KEY (`idasignacion`);

--
-- Indices de la tabla `banco`
--
ALTER TABLE `banco`
  ADD PRIMARY KEY (`idbanco`);

--
-- Indices de la tabla `bancohistorialtb`
--
ALTER TABLE `bancohistorialtb`
  ADD PRIMARY KEY (`idbanco`,`idbancohistorial`),
  ADD KEY `ix_tmp_autoinc` (`idbancohistorial`);

--
-- Indices de la tabla `cajatb`
--
ALTER TABLE `cajatb`
  ADD PRIMARY KEY (`idcaja`);

--
-- Indices de la tabla `ciudadtb`
--
ALTER TABLE `ciudadtb`
  ADD PRIMARY KEY (`idciudad`);

--
-- Indices de la tabla `clientetb`
--
ALTER TABLE `clientetb`
  ADD PRIMARY KEY (`idcliente`);

--
-- Indices de la tabla `compracreditotb`
--
ALTER TABLE `compracreditotb`
  ADD PRIMARY KEY (`idcompra`,`idcompracredito`),
  ADD KEY `ix_tmp_autoinc` (`idcompracredito`);

--
-- Indices de la tabla `compratb`
--
ALTER TABLE `compratb`
  ADD PRIMARY KEY (`idcompra`);

--
-- Indices de la tabla `comprobantetb`
--
ALTER TABLE `comprobantetb`
  ADD PRIMARY KEY (`serie`,`numeracion`);

--
-- Indices de la tabla `cuentasclientetb`
--
ALTER TABLE `cuentasclientetb`
  ADD PRIMARY KEY (`idcuentaclientes`),
  ADD KEY `ix_tmp_autoinc` (`idcuentaclientes`);

--
-- Indices de la tabla `cuentashistorialclientetb`
--
ALTER TABLE `cuentashistorialclientetb`
  ADD PRIMARY KEY (`idcuentashistorialcliente`,`idcuentaclientes`),
  ADD KEY `ix_tmp_autoinc` (`idcuentashistorialcliente`);

--
-- Indices de la tabla `detallecompratb`
--
ALTER TABLE `detallecompratb`
  ADD PRIMARY KEY (`idcompra`,`idarticulo`);

--
-- Indices de la tabla `detalletb`
--
ALTER TABLE `detalletb`
  ADD PRIMARY KEY (`iddetalle`,`idmantenimiento`);

--
-- Indices de la tabla `detalleventatb`
--
ALTER TABLE `detalleventatb`
  ADD PRIMARY KEY (`idventa`,`idarticulo`);

--
-- Indices de la tabla `directoriotb`
--
ALTER TABLE `directoriotb`
  ADD PRIMARY KEY (`iddirectorio`),
  ADD KEY `ix_tmp_autoinc` (`iddirectorio`);

--
-- Indices de la tabla `distritotb`
--
ALTER TABLE `distritotb`
  ADD PRIMARY KEY (`iddistrito`);

--
-- Indices de la tabla `empleadotb`
--
ALTER TABLE `empleadotb`
  ADD PRIMARY KEY (`idempleado`);

--
-- Indices de la tabla `empresatb`
--
ALTER TABLE `empresatb`
  ADD PRIMARY KEY (`idempresa`),
  ADD KEY `ix_tmp_autoinc` (`idempresa`);

--
-- Indices de la tabla `etiquetatb`
--
ALTER TABLE `etiquetatb`
  ADD PRIMARY KEY (`idetiqueta`),
  ADD KEY `ix_tmp_autoinc` (`idetiqueta`);

--
-- Indices de la tabla `formapagotb`
--
ALTER TABLE `formapagotb`
  ADD PRIMARY KEY (`idformapago`,`idventa`),
  ADD KEY `ix_tmp_autoinc` (`idformapago`);

--
-- Indices de la tabla `imagentb`
--
ALTER TABLE `imagentb`
  ADD PRIMARY KEY (`idimagen`),
  ADD KEY `ix_tmp_autoinc` (`idimagen`);

--
-- Indices de la tabla `impuestotb`
--
ALTER TABLE `impuestotb`
  ADD PRIMARY KEY (`idimpuesto`),
  ADD KEY `ix_tmp_autoinc` (`idimpuesto`);

--
-- Indices de la tabla `kardexsuministrotb`
--
ALTER TABLE `kardexsuministrotb`
  ADD PRIMARY KEY (`idkardex`,`idsuministro`),
  ADD KEY `ix_tmp_autoinc` (`idkardex`);

--
-- Indices de la tabla `lotetb`
--
ALTER TABLE `lotetb`
  ADD PRIMARY KEY (`idlote`),
  ADD KEY `ix_tmp_autoinc` (`idlote`);

--
-- Indices de la tabla `mantenimientotb`
--
ALTER TABLE `mantenimientotb`
  ADD PRIMARY KEY (`idmantenimiento`);

--
-- Indices de la tabla `menutb`
--
ALTER TABLE `menutb`
  ADD PRIMARY KEY (`idmenu`),
  ADD KEY `ix_tmp_autoinc` (`idmenu`);

--
-- Indices de la tabla `monedatb`
--
ALTER TABLE `monedatb`
  ADD PRIMARY KEY (`idmoneda`),
  ADD KEY `ix_tmp_autoinc` (`idmoneda`);

--
-- Indices de la tabla `movimientoinventariodetalletb`
--
ALTER TABLE `movimientoinventariodetalletb`
  ADD PRIMARY KEY (`idmovimientoinventario`,`idsuministro`);

--
-- Indices de la tabla `pagoproveedorestb`
--
ALTER TABLE `pagoproveedorestb`
  ADD PRIMARY KEY (`idpagoproveedores`),
  ADD KEY `ix_tmp_autoinc` (`idpagoproveedores`);

--
-- Indices de la tabla `paistb`
--
ALTER TABLE `paistb`
  ADD PRIMARY KEY (`paiscodigo`);

--
-- Indices de la tabla `permisomenustb`
--
ALTER TABLE `permisomenustb`
  ADD PRIMARY KEY (`idrol`,`idmenus`);

--
-- Indices de la tabla `permisoprivilegiostb`
--
ALTER TABLE `permisoprivilegiostb`
  ADD PRIMARY KEY (`idrol`,`idprivilegio`);

--
-- Indices de la tabla `permisosubmenustb`
--
ALTER TABLE `permisosubmenustb`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_tmp_autoinc` (`id`);

--
-- Indices de la tabla `plazostb`
--
ALTER TABLE `plazostb`
  ADD PRIMARY KEY (`idplazos`),
  ADD KEY `ix_tmp_autoinc` (`idplazos`);

--
-- Indices de la tabla `preciostb`
--
ALTER TABLE `preciostb`
  ADD PRIMARY KEY (`idprecios`),
  ADD KEY `ix_tmp_autoinc` (`idprecios`);

--
-- Indices de la tabla `privilegiostb`
--
ALTER TABLE `privilegiostb`
  ADD PRIMARY KEY (`idprivilegio`),
  ADD KEY `ix_tmp_autoinc` (`idprivilegio`);

--
-- Indices de la tabla `proveedortb`
--
ALTER TABLE `proveedortb`
  ADD PRIMARY KEY (`idproveedor`);

--
-- Indices de la tabla `provinciatb`
--
ALTER TABLE `provinciatb`
  ADD PRIMARY KEY (`idprovincia`);

--
-- Indices de la tabla `roltb`
--
ALTER TABLE `roltb`
  ADD PRIMARY KEY (`idrol`);

--
-- Indices de la tabla `submenutb`
--
ALTER TABLE `submenutb`
  ADD PRIMARY KEY (`idsubmenu`),
  ADD KEY `ix_tmp_autoinc` (`idsubmenu`);

--
-- Indices de la tabla `suministrotb`
--
ALTER TABLE `suministrotb`
  ADD PRIMARY KEY (`idsuministro`);

--
-- Indices de la tabla `tickettb`
--
ALTER TABLE `tickettb`
  ADD PRIMARY KEY (`idticket`),
  ADD KEY `ix_tmp_autoinc` (`idticket`);

--
-- Indices de la tabla `tipodocumentotb`
--
ALTER TABLE `tipodocumentotb`
  ADD PRIMARY KEY (`idtipodocumento`),
  ADD KEY `ix_tmp_autoinc` (`idtipodocumento`);

--
-- Indices de la tabla `tipoetiquetatb`
--
ALTER TABLE `tipoetiquetatb`
  ADD PRIMARY KEY (`idtipoetiqueta`),
  ADD KEY `ix_tmp_autoinc` (`idtipoetiqueta`);

--
-- Indices de la tabla `tipomovimientotb`
--
ALTER TABLE `tipomovimientotb`
  ADD KEY `ix_tmp_autoinc` (`idtipomovimiento`);

--
-- Indices de la tabla `tipotickettb`
--
ALTER TABLE `tipotickettb`
  ADD PRIMARY KEY (`idtipoticket`),
  ADD KEY `ix_tmp_autoinc` (`idtipoticket`);

--
-- Indices de la tabla `ventatb`
--
ALTER TABLE `ventatb`
  ADD PRIMARY KEY (`idventa`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bancohistorialtb`
--
ALTER TABLE `bancohistorialtb`
  MODIFY `idbancohistorial` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `compracreditotb`
--
ALTER TABLE `compracreditotb`
  MODIFY `idcompracredito` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cuentasclientetb`
--
ALTER TABLE `cuentasclientetb`
  MODIFY `idcuentaclientes` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cuentashistorialclientetb`
--
ALTER TABLE `cuentashistorialclientetb`
  MODIFY `idcuentashistorialcliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `directoriotb`
--
ALTER TABLE `directoriotb`
  MODIFY `iddirectorio` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empresatb`
--
ALTER TABLE `empresatb`
  MODIFY `idempresa` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `etiquetatb`
--
ALTER TABLE `etiquetatb`
  MODIFY `idetiqueta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `formapagotb`
--
ALTER TABLE `formapagotb`
  MODIFY `idformapago` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `imagentb`
--
ALTER TABLE `imagentb`
  MODIFY `idimagen` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `impuestotb`
--
ALTER TABLE `impuestotb`
  MODIFY `idimpuesto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `kardexsuministrotb`
--
ALTER TABLE `kardexsuministrotb`
  MODIFY `idkardex` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lotetb`
--
ALTER TABLE `lotetb`
  MODIFY `idlote` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `menutb`
--
ALTER TABLE `menutb`
  MODIFY `idmenu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `monedatb`
--
ALTER TABLE `monedatb`
  MODIFY `idmoneda` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pagoproveedorestb`
--
ALTER TABLE `pagoproveedorestb`
  MODIFY `idpagoproveedores` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisosubmenustb`
--
ALTER TABLE `permisosubmenustb`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT de la tabla `plazostb`
--
ALTER TABLE `plazostb`
  MODIFY `idplazos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `preciostb`
--
ALTER TABLE `preciostb`
  MODIFY `idprecios` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `privilegiostb`
--
ALTER TABLE `privilegiostb`
  MODIFY `idprivilegio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT de la tabla `submenutb`
--
ALTER TABLE `submenutb`
  MODIFY `idsubmenu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `tickettb`
--
ALTER TABLE `tickettb`
  MODIFY `idticket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tipodocumentotb`
--
ALTER TABLE `tipodocumentotb`
  MODIFY `idtipodocumento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipoetiquetatb`
--
ALTER TABLE `tipoetiquetatb`
  MODIFY `idtipoetiqueta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipomovimientotb`
--
ALTER TABLE `tipomovimientotb`
  MODIFY `idtipomovimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tipotickettb`
--
ALTER TABLE `tipotickettb`
  MODIFY `idtipoticket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
