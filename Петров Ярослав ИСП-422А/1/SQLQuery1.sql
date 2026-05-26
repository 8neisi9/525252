CREATE DATABASE BsAll;
GO
USE BsAll;
GO
CREATE TABLE Users (userID VARCHAR(10), pswd VARCHAR(256));
GO
DECLARE @i int = 1;
DECLARE @userName NVARCHAR(10) = '';
DECLARE @pswdRandom NVARCHAR(5) = '';
DECLARE @sql NVARCHAR(MAX) = '';
DECLARE @databaseName NVARCHAR(10) = '';
WHILE @i <= 14
BEGIN
	set @userName = 'user' + CAST(@i AS nvarchar(2));
	set @databaseName = 'Bs' + CAST(@i AS nvarchar(2));
	set @pswdRandom = LEFT(CONVERT(NVARCHAR(100), NEWID()), 5);
	EXEC('CREATE DATABASE ' + @databaseName);
	INSERT INTO Users values(@userName, @pswdRandom);
	set @sql = N'CREATE LOGIN ' + QUOTENAME(@userName) + ' WITH PASSWORD = ''' + @pswdRandom + ''', CHECK_POLICY = OFF 
				USE ' + QUOTENAME(@databaseName) + ';
				CREATE USER ' + QUOTENAME(@userName) + ' FOR LOGIN ' + QUOTENAME(@userName) + ';
				GRANT CONNECT TO ' + QUOTENAME(@userName) + ';
				GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO ' + QUOTENAME(@userName) + ';';

	EXEC sp_executesql @sql;
	DECLARE @denyBDSQL NVARCHAR(MAX) = N'USE master;
										DENY CREATE ANY DATABASE TO ' + QUOTENAME(@userName) + ';'
	exec sp_executesql @denyBDSQL;
	set @i += 1;
END
