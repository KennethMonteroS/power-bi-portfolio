-- =========================================================================
--                 Creación de Base de Datos "Multishop S.A"           
-- =========================================================================

-- ===================== Creación de Base de Datos =========================
DROP DATABASE IF EXISTS multishop_project;
CREATE DATABASE IF NOT EXISTS multishop_project;
USE multishop_project;

-- ========================= Creación de Tablas ============================

-- ========================== Tabla Sucursal ===============================
CREATE TABLE Sucursal (
    ID_Sucursal INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Ciudad VARCHAR(100),
    CantidadEmpleados INT CHECK (CantidadEmpleados > 0),
    Email VARCHAR(100) UNIQUE
);

-- Renombrar columna "ciudad" a "ubicacion"
ALTER TABLE Sucursal
CHANGE Ciudad Ubicacion VARCHAR(100);

-- ======================== Tabla Vendedores ===============================
CREATE TABLE Vendedores (
    ID_Vendedor INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(25) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    FechaContratacion DATE NOT NULL,
    Email VARCHAR(50) UNIQUE,
    Telefono VARCHAR(20) CHECK (Telefono REGEXP '^[0-9]{8}$'), -- Validar teléfonos de 8 dígitos
    Genero VARCHAR (25) DEFAULT 'No indicado'
);

-- Agregar columna ID_Sucursal a la tabla Vendedores
ALTER TABLE Vendedores
ADD COLUMN ID_Sucursal INT,
ADD CONSTRAINT FK_Vendedor_Sucursal FOREIGN KEY (ID_Sucursal) REFERENCES Sucursal(ID_Sucursal);

-- ========================= Tabla Clientes ===============================
CREATE TABLE Clientes (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(25) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Email VARCHAR(50) UNIQUE,
    Telefono VARCHAR(20) CHECK (Telefono REGEXP '^[0-9]{8}$'), -- Validar teléfonos de 8 dígitos
    Genero VARCHAR (25)
);

-- ======================== Tabla Proveedores ==============================
CREATE TABLE Proveedores (
    ID_Proveedor INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Ubicacion VARCHAR(255),
    Telefono VARCHAR(20) CHECK (Telefono REGEXP '^[0-9]{8}$') -- Validar teléfonos de 8 dígitos
);

-- ========================= Tabla Productos ===============================
CREATE TABLE Productos (
    ID_Producto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Marca VARCHAR(25),
    Precio DECIMAL(10, 2) NOT NULL,
    Categoria VARCHAR(50),
    ID_Proveedor INT, -- Relación con Proveedores
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor)
);

-- =========================== Tabla Ventas =================================
CREATE TABLE Ventas (
    ID_Venta INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE NOT NULL,
    ID_Cliente INT,
    ID_Vendedor INT,
    ID_Producto INT,
    ID_Sucursal INT,
    Unidades INT,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente) ON DELETE CASCADE,
    FOREIGN KEY (ID_Vendedor) REFERENCES Vendedores(ID_Vendedor) ON DELETE CASCADE,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto) ON DELETE CASCADE,
    FOREIGN KEY (ID_Sucursal) REFERENCES Sucursal(ID_Sucursal) ON DELETE CASCADE
);

-- ====================== Inserción de registros ============================

-- Insertar registros en la tabla Sucursal
INSERT INTO Sucursal (Nombre, Ubicacion, CantidadEmpleados, Email) VALUES
('Sucursal San José','San José',25,'sanjose@multishop.com'),
('Sucursal Heredia','Heredia',20,'heredia@multishop.com'),
('Sucursal Alajuela','Alajuela',18,'alajuela@multishop.com'),
('Sucursal Cartago','Cartago',15,'cartago@multishop.com'),
('Sucursal Liberia','Guanacaste',10,'liberia@multishop.com'),
('Sucursal Puntarenas','Puntarenas',12,'puntarenas@multishop.com'),
('Sucursal Limón','Limón',14,'limon@multishop.com'),
('Sucursal Escazú','San José',16,'escazu@multishop.com'),
('Sucursal Tibás','San José',11,'tibas@multishop.com'),
('Sucursal Desamparados','San José',17,'desampa@multishop.com'),
('Sucursal Grecia','Alajuela',9,'grecia@multishop.com'),
('Sucursal San Ramón','Alajuela',13,'sanramon@multishop.com'),
('Sucursal Nicoya','Guanacaste',8,'nicoya@multishop.com'),
('Sucursal Santa Ana','San José',15,'santana@multishop.com'),
('Sucursal Curridabat','San José',14,'curridabat@multishop.com');

SELECT * FROM Sucursal LIMIT 7;

-- Insertar registros en la tabla Vendedores
INSERT INTO Vendedores (Nombre, Apellido, FechaContratacion, Email, Telefono,Genero,ID_Sucursal)
VALUES 
('Carlos', 'González', '2022-03-15', 'carlos.gonzalez@multishop.cr', '88501234', 'Masculino',12),
('Ana', 'Jiménez', '2023-06-21', 'ana.jimenez@multishop.cr', '88507654', 'Femenino',11),
('Luis', 'Pérez', '2021-11-30', 'luis.perez@multishop.cr', '88504321', 'Masculino',10),
('María', 'Rodríguez', '2020-07-25', 'maria.rodriguez@multishop.cr', '88509876', 'Femenino',9),
('Juan', 'Alvarado', '2022-01-10', 'juan.alvarado@multishop.cr', '88506543', 'Masculino',8),
('Sofía', 'Martínez', '2023-02-14', 'sofia.martinez@multishop.cr', '88508765', 'Femenino',7),
('José', 'Lopez', '2021-08-18', 'jose.lopez@multishop.cr', '88505432', 'Masculino',6),
('Isabel', 'González', '2020-04-19', 'isabel.gonzalez@multishop.cr', '88507643', 'Femenino',5),
('David', 'Castro', '2023-03-11', 'david.castro@multishop.cr', '88502345', 'Masculino',4),
('Laura', 'Fernández', '2022-07-22', 'laura.fernandez@multishop.cr', '88507687', 'Femenino',3),
('Miguel', 'Campos', '2023-07-01', 'miguel.campos@multishop.cr', '88501111', 'Masculino',2),
('Carla', 'Ruiz', '2022-10-15', 'carla.ruiz@multishop.cr', '88502222', 'Femenino',1),
('Diego', 'Hernández', '2021-03-30', 'diego.hernandez@multishop.cr', '88503333', 'Masculino',5),
('Luisa', 'Cordero', '2023-12-20', 'luisa.cordero@multishop.cr', '88504444','Femenino',8),
('Alonso', 'Vega', '2023-01-05', 'alonso.vega@multishop.cr', '88505555', 'Masculino',11);

SELECT * FROM Vendedores LIMIT 7;

-- Insertar registros en la tabla Clientes
INSERT INTO Clientes (Nombre, Apellido, FechaNacimiento, Email, Telefono, Genero)
VALUES 
('Carlos', 'Mora', '1990-05-14', 'carlos.mora@gmail.com', '89512345', 'Masculino'),
('María', 'Vargas', '1985-08-30', 'maria.vargas@gmail.com', '89523456', 'Femenino'),
('Juan', 'Jiménez', '1992-02-25', 'juan.jimenez@gmail.com', '89534567', 'Masculino'),
('Lucía', 'Rojas', '1993-11-12', 'lucia.rojas@gmail.com', '89545678', 'Femenino'),
('Pedro', 'Sánchez', '1988-01-19', 'pedro.sanchez@gmail.com', '89556789', 'Masculino'),
('Gabriela', 'Ramírez', '1991-03-10', 'gabriela.ramirez@gmail.com', '89567890', 'Femenino'),
('José', 'Pérez', '1990-12-11', 'jose.perez@gmail.com', '89578901', 'Masculino'),
('Laura', 'Castro', '1994-06-23', 'laura.castro@gmail.com', '89589012', 'Femenino'),
('Ricardo', 'Fernández', '1987-07-04', 'ricardo.fernandez@gmail.com', '89590123', 'Masculino'),
('Andrea', 'Torres', '1995-09-29', 'andrea.torres@gmail.com', '89501234', 'Femenino'),
('Santiago', 'Villalobos', '1989-04-18', 'santiago.villalobos@gmail.com', '89611111', 'Masculino'),
('Fernanda', 'Salas', '1995-02-09', 'fernanda.salas@gmail.com', '89622222', 'Femenino'),
('Esteban', 'Durán', '1990-07-12', 'esteban.duran@gmail.com', '89633333', 'Masculino'),
('Valeria', 'Mena', '1987-01-04', 'valeria.mena@gmail.com', '89644444', 'Femenino'),
('Pablo', 'Arias', '1991-09-27', 'pablo.arias@gmail.com', '89655555', 'Masculino');

SELECT * FROM Clientes LIMIT 7;

-- Insertar registros en la tabla Proveedores
INSERT INTO Proveedores (Nombre, Ubicacion, Telefono)
VALUES 
('DeportePlus', 'San José, Costa Rica', '88812345'),
('PerfumeDeluxe', 'Alajuela, Costa Rica', '88823456'),
('ElectroMaster', 'Cartago, Costa Rica', '88834567'),
('ModaTrendy', 'Heredia, Costa Rica', '88845678'),
('TenisPro', 'Puntarenas, Costa Rica', '88856789'),
('AvanzaDeportes', 'Liberia, Costa Rica', '88867890'),
('EstiloModa', 'Limón, Costa Rica', '88878901'),
('TechGuanacaste', 'Guanacaste, Costa Rica', '88889012'),
('CalzadoElite', 'Escazú, Costa Rica', '88890123'),
('HogarPerfecto', 'Santa Ana, Costa Rica', '88801234'),
('CasaDeportes', 'San Ramón, Costa Rica', '88811111'),
('EstiloVanguard', 'Pérez Zeledón, Costa Rica', '88822222'),
('HogarFácil', 'Quepos, Costa Rica', '88833333'),
('ModaConEstilo', 'Turrialba, Costa Rica', '88844444'),
('MegaTech', 'Liberia, Costa Rica', '88855555');

SELECT * FROM Proveedores LIMIT 7;

-- Insertar registros en la tabla Productos
INSERT INTO Productos (Nombre, Marca, Precio, Categoria, ID_Proveedor)
VALUES 
('Pelota de fútbol', 'Nike', 25000.00, 'Deportes', 1),
('Perfume Chanel No. 5', 'Chanel', 100000.00, 'Perfumes', 2),
('Aspiradora Dyson V11', 'Dyson', 150000.00, 'Electrodomésticos', 3),
('Camiseta deportiva', 'Adidas', 15000.00, 'Deportes', 1),
('Tenis para correr', 'Puma', 45000.00, 'Deportes', 1),
('Perfume Dior Sauvage', 'Dior', 110000.00, 'Perfumes', 2),
('Refrigeradora LG', 'LG', 250000.00, 'Electrodomésticos', 3),
('Reloj inteligente', 'Samsung', 120000.00, 'Tecnología', 4),
('Zapatillas de moda', 'Converse', 55000.00, 'Calzado', 4),
('Bicicleta de montaña', 'Trek', 300000.00, 'Deportes', 1),
('Maquillaje Palette', 'Huda Beauty', 85000.00, 'Cosméticos', 2),
('Audífonos inalámbricos', 'Sony', 90000.00, 'Tecnología', 4),
('Televisor 55 pulgadas', 'Samsung', 350000.00, 'Electrodomésticos', 3),
('Juego de pesas', 'Reebok', 80000.00, 'Deportes', 1),
('Perfume Black Opium', 'Yves Saint Laurent', 120000.00, 'Perfumes', 2);

SELECT * FROM Productos LIMIT 7;

-- Insertar registros en la tabla Ventas
INSERT INTO Ventas (Fecha, ID_Cliente, ID_Vendedor, ID_Producto, ID_Sucursal, Unidades)
VALUES 
('2024-10-15', 10, 2, 8, 1, 3),
('2024-10-18', 6, 2, 2, 5, 5),
('2024-10-20', 7, 3, 3, 8, 1),
('2024-10-22', 2, 4, 13, 6, 4),
('2024-10-25', 2, 5, 6, 1, 2),
('2024-10-28', 3, 6, 6, 1, 1),
('2024-11-01', 1, 7, 8, 4, 5),
('2024-11-05', 2, 8, 11, 12, 3),
('2024-11-10', 14, 2, 5, 10, 2),
('2024-11-12', 8, 10, 11, 3, 4),
('2024-11-15', 1, 1, 12, 11, 1),
('2024-11-18', 11, 2, 13, 8, 5),
('2024-11-20', 10, 2, 5, 2, 2),
('2024-11-22', 2, 4, 15, 7, 3),
('2024-11-25', 1, 5, 3, 7, 4),
('2024-01-15', 3, 6, 12, 11, 2),
('2024-03-12', 10, 4, 4, 4, 1),
('2024-02-05', 7, 11, 3, 4, 5),
('2024-01-20', 2, 9, 1, 2, 3),
('2024-04-02', 8, 3, 5, 8, 4),
('2024-01-28', 12, 14, 12, 7, 2),
('2024-03-01', 5, 2, 6, 12, 1),
('2024-02-19', 1, 8, 11, 11, 5),
('2024-04-18', 13, 5, 9, 2, 3),
('2024-03-25', 4, 12, 2, 1, 4),
('2024-02-10', 9, 1, 13, 1, 2),
('2024-01-17', 14, 15, 10, 8, 5),
('2024-04-07', 6, 7, 15, 8, 3),
('2024-02-14', 15, 10, 14, 9, 4),
('2024-03-05', 11, 13, 8, 8, 1);

SELECT * FROM Ventas LIMIT 7;