-- ============================================================
-- Pre-entrega Módulo 5
-- Archivo: m5_consultas_joins.sql
-- Base de datos: Ventas_Tech_DB
-- Objetivo: Consultas con JOIN y UNION ALL para el proyecto
-- Autor: Franco Bazzalo
-- Motor: SQL Server
-- ============================================================

USE Ventas_Tech_DB;
GO

-- ============================================================
-- DATOS COMPLEMENTARIOS PARA EL ANÁLISIS
-- Se agregan registros de ejemplo para que las consultas de
-- clientes sin ventas y productos sin ventas devuelvan resultados.
-- Se usa IF NOT EXISTS para evitar duplicados si se ejecuta más de una vez.
-- ============================================================

IF NOT EXISTS (SELECT 1 FROM clientes WHERE id_cliente = 6)
BEGIN
    INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro)
    VALUES (6, 'Sofía Martínez', 'sofia@mail.com', 'Salta', '2024-03-20');
END;

IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = 7)
BEGIN
    INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo)
    VALUES (7, 'Tablet Lite 10', 1, 300.00, 20, 1);
END;
GO

-- ============================================================
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Pregunta de negocio:
-- ¿Cómo obtener una vista enriquecida de ventas con información
-- de cliente, producto y categoría?
-- ============================================================

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
ORDER BY
    v.fecha_venta,
    v.id_venta;


-- ============================================================
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Pregunta de negocio:
-- ¿Qué clientes registrados aún no realizaron ninguna compra?
-- ============================================================

SELECT
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY
    c.id_cliente;


-- ============================================================
-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Pregunta de negocio:
-- ¿Qué productos del catálogo no tienen ninguna venta registrada?
-- ============================================================

SELECT
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio,
    p.stock,
    p.activo
FROM productos p
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
LEFT JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL
ORDER BY
    p.id_producto;


-- ============================================================
-- CONSULTA 4: Consolidado por canal (UNION ALL)
-- Pregunta de negocio:
-- ¿Cómo consolidar ventas de distintos orígenes o canales
-- manteniendo todos los registros?
--
-- La columna canal no existe en la tabla ventas.
-- Se crea dentro de cada SELECT como valor literal.
-- ============================================================

SELECT
    fecha_venta,
    cantidad * precio_unitario AS total_venta,
    'Online' AS canal
FROM ventas
WHERE id_venta <= 5

UNION ALL

SELECT
    fecha_venta,
    cantidad * precio_unitario AS total_venta,
    'Presencial' AS canal
FROM ventas
WHERE id_venta > 5
ORDER BY
    fecha_venta;


-- ============================================================
-- CONSULTA 4B: Total consolidado por canal
-- Esta consulta resume el resultado anterior por canal.
-- ============================================================

SELECT
    canal,
    COUNT(*) AS cantidad_ventas,
    SUM(total_venta) AS total_facturado
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total_venta,
        'Online' AS canal
    FROM ventas
    WHERE id_venta <= 5

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total_venta,
        'Presencial' AS canal
    FROM ventas
    WHERE id_venta > 5
) AS ventas_por_canal
GROUP BY
    canal
ORDER BY
    total_facturado DESC;