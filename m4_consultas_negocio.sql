
-- Pre-entrega Módulo 4
-- Archivo: m4_consultas_negocio.sql
-- Base de datos: Ventas_Tech_DB
-- Objetivo: Extraer métricas clave de negocio con SQL
-- Motor: SQL Server


USE Ventas_Tech_DB;
GO


-- Consulta 1
-- Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio,
-- agrupados por mes.


SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;



-- Consulta 2
-- Ranking de productos
-- Top 5 de id_producto por total facturado,
-- mostrando unidades vendidas y total generado.


SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;



-- Consulta 3
-- Clientes recurrentes
-- Clientes que realizaron más de un pedido,
-- mostrando cantidad de pedidos y total gastado.


SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;



-- Consulta 4
-- Meses por encima o por debajo del promedio
-- Compara el total facturado mensual contra el promedio mensual general.

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE
        WHEN SUM(cantidad * precio_unitario) >= (
            SELECT AVG(total_mensual)
            FROM (
                SELECT
                    MONTH(fecha_venta) AS mes,
                    SUM(cantidad * precio_unitario) AS total_mensual
                FROM ventas
                GROUP BY MONTH(fecha_venta)
            ) AS ventas_mensuales
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS etiqueta
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- Bloque de cierre: hallazgos concretos


-- 1. En marzo se registraron 10 pedidos, con una facturación total de 6444.00
--    y un ticket promedio de 644.40.

-- 2. El producto con mayor facturación fue el id_producto 1, con 3600.00
--    de total facturado y 3 unidades vendidas.

-- 3. Todos los clientes registrados en la tabla ventas realizaron más de un pedido.
--    El cliente con mayor gasto fue el id_cliente 1, con un total gastado de 2640.00.