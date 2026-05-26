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

