USE master;
go
alter database BsAll set single_user with rollback immediate;
restore database BsAll from disk = 'C:\Backup\BsAll.BAK'
with move 'BsAll' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\BsAll.mdf',
move 'BsAll_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\BsAll_log.ldf',
replace;
go

alter database BsAll set multi_user;
go
