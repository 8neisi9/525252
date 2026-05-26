USE ProductionDB;
GO

CREATE OR ALTER FUNCTION GetProductCost(@ProductID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @cost DECIMAL(10,2);
    
    SELECT @cost = SUM(s.Quantity * m.PricePerUnit)
    FROM Specs s
    JOIN Materials m ON s.MaterialID = m.MaterialID
    WHERE s.ProductID = @ProductID;
    
    RETURN ISNULL(@cost, 0);
END
GO

CREATE OR ALTER PROCEDURE GetMaxOrderStatistics
    @date_start DATE,
    @date_end DATE
AS
BEGIN
    SELECT TOP 1
        c.name AS Çàêàç÷èê,
        COUNT(DISTINCT o.id) AS [Ìàêñ.êîë-âî çàêàçîâ],
        SUM(oi.qty) AS [Ìàêñ.êîë-âî ïðîäóêöèè],
        SUM(oi.qty * dbo.GetProductCost(oi.productId)) AS [Ìàêñ.ñóììà çàêàçîâ]
    FROM Orders o
    JOIN Clients c ON o.clientId = c.id
    JOIN OrderItems oi ON o.id = oi.orderId
    WHERE o.date BETWEEN @date_start AND @date_end
    GROUP BY c.name
    ORDER BY SUM(oi.qty * dbo.GetProductCost(oi.productId)) DESC;
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'total_sum')
BEGIN
    ALTER TABLE Orders ADD total_sum DECIMAL(12,2) DEFAULT 0;
END
GO

CREATE OR ALTER TRIGGER trg_CalculateOrderTotal
ON OrderItems
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Orders
    SET total_sum = (
        SELECT ISNULL(SUM(oi.qty * dbo.GetProductCost(oi.productId)), 0)
        FROM OrderItems oi
        WHERE oi.orderId = Orders.id
    )
    WHERE id IN (
        SELECT orderId FROM inserted
        UNION
        SELECT orderId FROM deleted
    );
END
GO

UPDATE OrderItems SET qty = qty;
GO

SELECT 
    o.id,
    c.name AS Çàêàç÷èê,
    o.date,
    o.total_sum AS [Èòîãîâàÿ ñóììà çàêàçà]
FROM Orders o
JOIN Clients c ON o.clientId = c.id;
GO

EXEC GetMaxOrderStatistics '2025-01-01', '2025-12-31';
GO
