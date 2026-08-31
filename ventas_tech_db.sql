-- ============================================================
-- Checkpoint Módulo 3
-- Base de datos: Ventas_Tech_DB
-- Proyecto: TechStore - Ventas de Tecnología
-- Motor: SQL Server
-- ============================================================

-- 1. Crear la base de datos si no existe
IF DB_ID('Ventas_Tech_DB') IS NULL
    CREATE DATABASE Ventas_Tech_DB;
GO

-- 2. Seleccionar la base de datos
USE Ventas_Tech_DB;
GO

-- ============================================================
-- 3. DROP TABLES
-- Se eliminan primero las tablas que dependen de otras tablas.
-- Orden inverso de dependencias:
-- ventas -> productos -> clientes -> categorias
-- ============================================================

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
GO

-- ============================================================
-- 4. CREATE TABLES
-- Se crean primero las tablas sin dependencias:
-- categorias y clientes.
-- Luego productos, que depende de categorias.
-- Por último ventas, que depende de clientes y productos.
-- ============================================================

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo TINYINT DEFAULT 1,

    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,

    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
GO

-- ============================================================
-- 5. INSERT DATA
-- Se insertan primero las tablas sin dependencias.
-- Luego productos y finalmente ventas.
-- ============================================================

-- Categorías
INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

-- Clientes
INSERT INTO clientes VALUES (1, 'María López', 'maria@mail.com', 'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz', 'carlos@mail.com', 'Córdoba', '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez', 'ana@mail.com', 'Rosario', '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz', 'pedro@mail.com', 'Mendoza', '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres', 'laura@mail.com', 'Tucumán', '2024-03-01');

-- Productos
INSERT INTO productos VALUES (1, 'Laptop Pro 15', 1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico', 2, 28.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"', 1, 450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro', 3, 120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB', 4, 130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Teclado Mecánico', 2, 95.00, 40, 1);

-- Ventas
INSERT INTO ventas VALUES (1, 1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2, 2, 2, 5, 28.00, '2024-03-06');
INSERT INTO ventas VALUES (3, 3, 3, 1, 450.00, '2024-03-07');
INSERT INTO ventas VALUES (4, 1, 4, 2, 120.00, '2024-03-08');
INSERT INTO ventas VALUES (5, 4, 5, 3, 130.00, '2024-03-10');
INSERT INTO ventas VALUES (6, 2, 6, 4, 95.00, '2024-03-11');
INSERT INTO ventas VALUES (7, 5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8, 3, 2, 8, 28.00, '2024-03-13');
INSERT INTO ventas VALUES (9, 4, 4, 1, 120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2, 450.00, '2024-03-15');
GO

-- ============================================================
-- 6. CONSULTAS DE VALIDACIÓN
-- Sirven para confirmar que las tablas se crearon y cargaron bien.
-- ============================================================

SELECT * FROM categorias;

SELECT * FROM clientes;

SELECT * FROM productos;

SELECT * FROM ventas;

-- Validación adicional: cantidad de registros por tabla
SELECT 'categorias' AS tabla, COUNT(*) AS cantidad_registros FROM categorias;
SELECT 'clientes' AS tabla, COUNT(*) AS cantidad_registros FROM clientes;
SELECT 'productos' AS tabla, COUNT(*) AS cantidad_registros FROM productos;
SELECT 'ventas' AS tabla, COUNT(*) AS cantidad_registros FROM ventas;