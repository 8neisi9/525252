USE ProductionDB;
GO

DECLARE @Year  INT = 2025;
DECLARE @Month INT = 6;                
DECLARE @MonthName NVARCHAR(15) = (SELECT DATENAME(MONTH, DATEFROMPARTS(@Year, @Month, 1)));
DECLARE @ArchiveTableName NVARCHAR(50) = 'Order_' + LOWER(@MonthName);
DECLARE @SQL NVARCHAR(MAX);

PRINT 'Создаётся архивная таблица: ' + @ArchiveTableName;
PRINT 'За период: ' + @MonthName + ' ' + CAST(@Year AS NVARCHAR(4));

SET @SQL = '
    SELECT * 
    INTO ' + @ArchiveTableName + '
    FROM Orders 
    WHERE YEAR(date) = ' + CAST(@Year AS NVARCHAR(4)) + 
    ' AND MONTH(date) = ' + CAST(@Month AS NVARCHAR(2)) + ';
'

EXEC sp_executesql @SQL;

DELETE FROM OrderItems 
WHERE orderId IN (SELECT id FROM Orders 
                  WHERE YEAR(date) = @Year AND MONTH(date) = @Month);

DELETE FROM Orders 
WHERE YEAR(date) = @Year AND MONTH(date) = @Month;

PRINT 'Архивация успешно завершена. Данные перенесены в таблицу:';
PRINT '   → ' + @ArchiveTableName;
GO
