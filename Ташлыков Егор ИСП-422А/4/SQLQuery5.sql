CREATE DATABASE ProductionDB;
GO

USE ProductionDB;
GO

CREATE TABLE Clients (
    id        INT PRIMARY KEY IDENTITY(1,1),
    name      NVARCHAR(100) NOT NULL,
    phone     NVARCHAR(20)
);
GO

CREATE TABLE Materials (
    MaterialID    INT PRIMARY KEY IDENTITY(1,1),
    MaterialName  NVARCHAR(100) NOT NULL,
    PricePerUnit  DECIMAL(10,2) NOT NULL
);
GO

CREATE TABLE Products (
    ProductID     INT PRIMARY KEY IDENTITY(1,1),
    ProductName   NVARCHAR(100) NOT NULL,
    ProductPrice  DECIMAL(10,2) NOT NULL
);
GO

CREATE TABLE Specs (
    SpecID     INT PRIMARY KEY IDENTITY(1,1),
    ProductID  INT,
    MaterialID INT,
    Quantity   DECIMAL(10,3),

    CONSTRAINT FK_Specs_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_Specs_Materials FOREIGN KEY (MaterialID) REFERENCES Materials(MaterialID)
);
GO

CREATE TABLE Orders (
    id        INT PRIMARY KEY IDENTITY(1,1),
    date      DATE,
    clientId  INT,
    total_sum DECIMAL(12,2) DEFAULT 0,

    CONSTRAINT FK_Orders_Clients FOREIGN KEY (clientId) REFERENCES Clients(id)
);
GO

CREATE TABLE OrderItems (
    id        INT PRIMARY KEY IDENTITY(1,1),
    orderId   INT,
    productId INT,
    qty       INT,
    sum       DECIMAL(12,2),

    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (orderId) REFERENCES Orders(id),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (productId) REFERENCES Products(ProductID)
);
GO

CREATE TABLE Production (
    ProductionID    INT PRIMARY KEY IDENTITY(1,1),
    ProductionDate  DATE,
    ProductID       INT,
    Quantity        DECIMAL(10,2),

    CONSTRAINT FK_Production_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

CREATE TABLE ProdMaterials (
    ProdMaterialID INT PRIMARY KEY IDENTITY(1,1),
    ProductionID   INT,
    MaterialID     INT,
    QuantityUsed   DECIMAL(10,3),

    CONSTRAINT FK_ProdMaterials_Production FOREIGN KEY (ProductionID) REFERENCES Production(ProductionID),
    CONSTRAINT FK_ProdMaterials_Materials FOREIGN KEY (MaterialID) REFERENCES Materials(MaterialID)
);
GO

INSERT INTO Clients (name, phone) VALUES
('ООО "Цельсий"', '+79184572398'),
('ООО "Мясной цех №1"', '+79882584546'),
('ООО "Ромашка"', '+79198634592');
GO

INSERT INTO Materials (MaterialName, PricePerUnit) VALUES
('Говядина', 370),
('Молоко', 34),
('Соль', 60);
GO

INSERT INTO Products (ProductName, ProductPrice) VALUES
('Сосиски молочные', 560),
('Пельмени говяжьи', 450),
('Сосиски венские', 570);
GO

INSERT INTO Specs (ProductID, MaterialID, Quantity) VALUES
(1, 1, 0.4),
(2, 1, 0.5),
(3, 1, 0.4);
GO

INSERT INTO Orders (date, clientId) VALUES
('2025-06-01', 1),
('2025-06-06', 1),
('2025-06-10', 2);
GO

INSERT INTO OrderItems (orderId, productId, qty, sum) VALUES
(1, 1, 10, 5600),
(2, 2, 8, 3600),
(2, 3, 3, 1710);
GO

INSERT INTO Production (ProductionDate, ProductID, Quantity) VALUES
('2025-06-09', 1, 100),
('2025-06-10', 2, 80),
('2025-06-11', 3, 200);
GO

INSERT INTO ProdMaterials (ProductionID, MaterialID, QuantityUsed) VALUES
(1, 1, 40),
(2, 1, 32),
(3, 1, 100);
GO
