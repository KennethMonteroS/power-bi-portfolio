-- =========================================================================
--                               CONSULTAS           
-- =========================================================================

-- ========================= Consultas básicas ==============================

-- Obtener los nombres de los clientes cuyo apellido termine en 'ez' o que contenga las letras 'as':
SELECT Nombre, Apellido 
FROM Clientes 
WHERE Apellido LIKE '%ez' OR Apellido LIKE '%as%' 
ORDER BY Apellido ASC;

-- Obtener el nombre de los productos de la categoría 'Deportes' y de marca 'Adidas':
SELECT Nombre 
FROM Productos 
WHERE Categoria = 'Deportes' AND Marca = 'Adidas';

-- Obtener una lista de las sucursales y sus direcciones con más de 20 empleados ordenados de la mayor a la menor cantidad de empleados.
SELECT Nombre, Ubicacion, CantidadEmpleados 
FROM Sucursal 
WHERE CantidadEmpleados > 15 
ORDER BY CantidadEmpleados DESC;

-- Obtener el nombre y el número de teléfono de los proveedores ubicados en Heredia
SELECT Nombre, Telefono
FROM Proveedores
WHERE Ubicacion = 'Heredia, Costa Rica';

-- Obtener una lista de los vendedores hombres y sus correos
SELECT Nombre, Apellido, Email
FROM Vendedores
WHERE Genero = 'Masculino';

-- Obtener una lista de los clientes que cumplen años en julio
SELECT Nombre, Apellido, FechaNacimiento 
FROM Clientes
WHERE MONTH(FechaNacimiento) = 7;

-- ======================== Consultas avanzadas ============================

-- Mostrar los 5 vendedores con mayor cantidad de productos vendidos
SELECT 
    CONCAT(vt.Nombre, ' ', vt.Apellido) AS Vendedor,
    SUM(v.Unidades) AS Total_Vendido
FROM
    Ventas AS v
        JOIN
    Vendedores AS vt ON v.ID_Vendedor = vt.ID_Vendedor
GROUP BY Vendedor
ORDER BY Total_Vendido DESC
LIMIT 5;

-- Total de unidades vendidas por categoría de producto
SELECT 
    Categoria, SUM(Unidades) AS Total_Unidades
FROM
    Productos AS p
        JOIN
    Ventas AS v ON p.ID_Producto = v.ID_Producto
GROUP BY Categoria;

-- Sucursales con ingresos mayores a ₡1,000,000.00
SELECT 
    s.Nombre AS Sucursal,
    s.Ubicacion AS Ubicacion,
    SUM(v.Unidades * p.Precio) AS Total_Ingresos
FROM
    Ventas v
        JOIN
    Productos p ON v.ID_Producto = p.ID_Producto
        JOIN
    Sucursal s ON v.ID_Sucursal = s.ID_Sucursal
GROUP BY s.Nombre , s.Ubicacion
HAVING SUM(v.Unidades * p.Precio) > 1000000
ORDER BY Total_Ingresos DESC;

-- Mostrar los 3 vendedores que generaron mayores ingresos en ventas
SELECT 
    CONCAT(Vendedores.Nombre,
            ' ',
            Vendedores.Apellido) AS Vendedor,
    SUM(Productos.Precio * Ventas.Unidades) AS TotalVentas
FROM
    Ventas
        JOIN
    Vendedores ON Ventas.ID_Vendedor = Vendedores.ID_Vendedor
        JOIN
    Productos ON Ventas.ID_Producto = Productos.ID_Producto
GROUP BY Vendedores.ID_Vendedor
ORDER BY TotalVentas DESC
LIMIT 3;

-- Mostrar lista de los 5 clientes que más han comprado.
SELECT 
    c.Nombre AS Nombre_Cliente,
    c.Apellido AS Apellido_Cliente,
    c.Email AS Correo_Cliente,
    SUM(v.Unidades * p.Precio) AS Total_Compras
FROM
    Ventas v
        JOIN
    Productos p ON v.ID_Producto = p.ID_Producto
        JOIN
    Clientes c ON v.ID_Cliente = c.ID_Cliente
GROUP BY c.Nombre , c.Apellido , c.Email
ORDER BY Total_Compras DESC
LIMIT 5;

-- Mostrar las 5 sucursales con menor cantidad de unidades vendidas
SELECT 
    s.Nombre AS Sucursal,
    s.Ubicacion AS Ubicacion_Sucursal,
    SUM(v.Unidades) AS Total_Vendido
FROM
    Sucursal AS s
        LEFT JOIN
    Ventas AS v ON s.ID_Sucursal = v.ID_Sucursal
GROUP BY s.ID_Sucursal
ORDER BY Total_Vendido ASC
LIMIT 5;

-- Productos y sus Proveedores (incluye productos sin proveedor)
SELECT 
    p.Nombre AS Producto, 
    p.Marca, 
    pr.Nombre AS Proveedor
FROM
    Productos AS p
        RIGHT JOIN
    Proveedores AS pr ON p.ID_Proveedor = pr.ID_Proveedor;

-- Mostrar una lista con los productos más vendidos 
SELECT 
    p.Nombre AS Producto,
    p.Marca,
    SUM(v.Unidades) AS Total_Unidades_Vendidas
FROM
    Ventas v
        RIGHT JOIN
    Productos p ON v.ID_Producto = p.ID_Producto
GROUP BY Producto , Marca
ORDER BY Total_Unidades_Vendidas DESC;

-- =============== Consultas de actualización/eliminación ================

#SET SQL_SAFE_UPDATES = 0;  #De esta forma se deshabilita la opción de seguridad para modificar o actualizar tablas.
#SET FOREIGN_KEY_CHECKS = 0; #Desactivar las restricciones de claves foráneas.

-- Modificar a 26 la cantidad de empleados de la sucursal con ID = 1
UPDATE sucursal
SET CantidadEmpleados = 26
WHERE ID_Sucursal = 1;

-- Actualizar el precio de un producto ('Refrigeradora LG')
UPDATE Productos
SET Precio = Precio * 0.85
WHERE Nombre = 'Refrigeradora LG';

-- Modificar el número de teléfono de un vendedor
UPDATE Vendedores
SET Telefono = '86881247'
WHERE ID_Vendedor = 5;

-- Eliminar una sucursal
DELETE FROM Sucursal
WHERE CantidadEmpleados <= 18;

-- Eliminar un proveedor
DELETE FROM Proveedores
WHERE Nombre = 'HogarPerfecto';

-- ======================== Creación de vista ============================

CREATE VIEW resumen_ventas AS
SELECT 
    v.ID_Venta,
    v.Fecha,
    c.Nombre AS Cliente,
    CONCAT(vd.Nombre,' ',vd.Apellido) AS Vendedor,
    s.Nombre AS Sucursal,
    p.Nombre AS Producto,
    p.Categoria,
    v.Unidades,
    p.Precio,
    (v.Unidades * p.Precio) AS Total_Venta
FROM Ventas v
JOIN Clientes c ON v.ID_Cliente = c.ID_Cliente
JOIN Vendedores vd ON v.ID_Vendedor = vd.ID_Vendedor
JOIN Productos p ON v.ID_Producto = p.ID_Producto
JOIN Sucursal s ON v.ID_Sucursal = s.ID_Sucursal;

SELECT * FROM resumen_ventas;