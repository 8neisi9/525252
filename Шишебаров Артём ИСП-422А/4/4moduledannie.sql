USE ProductionDB;
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

-- 4. 
INSERT INTO Specs (ProductID, MaterialID, Quantity) VALUES
(1, 1, 0.4),
(2, 1, 0.5),
(3, 1, 0.4);
GO

-- 5. 
INSERT INTO Orders (date, clientId) VALUES
('2025-06-01', 1),
('2025-06-06', 1),
('2025-06-10', 2);
GO

-- 6. 
INSERT INTO OrderItems (orderId, productId, qty, sum) VALUES
(1, 1, 10, 5600),
(2, 2, 8, 3600),
(2, 3, 3, 1710);
GO

-- 7.
INSERT INTO Production (ProductionDate, ProductID, Quantity) VALUES
('2025-06-09', 1, 100),
('2025-06-10', 2, 80),
('2025-06-11', 3, 200);
GO

-- 8. 
INSERT INTO ProdMaterials (ProductionID, MaterialID, QuantityUsed) VALUES
(1, 1, 40),
(2, 1, 32),
(3, 1, 100);
GO
