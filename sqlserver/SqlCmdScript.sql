IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'GeoLite2')
CREATE database GeoLite2;
GO

USE [master]
GO

IF NOT EXISTS(SELECT 1 FROM [GeoLite2].sys.database_principals WHERE name = 'GeoLite2User')
CREATE LOGIN [GeoLite2User] WITH PASSWORD=N'Password123', DEFAULT_DATABASE=[GeoLite2],
CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [GeoLite2]
GO

IF NOT EXISTS(SELECT 1 FROM [GeoLite2].sys.database_principals WHERE name = 'GeoLite2User')
BEGIN
CREATE USER [GeoLite2User] FOR LOGIN [GeoLite2User]
ALTER USER [GeoLite2User] WITH DEFAULT_SCHEMA=[dbo]
ALTER ROLE [db_owner] ADD MEMBER [GeoLite2User]
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GeoIP')
DROP TABLE GeoIP
GO

CREATE TABLE GeoIP (
    startIpNum bigint,
	endIpNum bigint,
	locId  bigint
)

CREATE CLUSTERED INDEX Geo_IP_Look
ON GeoIP
([startIpNum], [endIpNum],  [locId])

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GeoLocation')
DROP TABLE GeoLocation
GO

CREATE TABLE GeoLocation (
	 locId bigint,
	 country nvarchar(2),
	 region nvarchar(3),
	 city nvarchar(255),
	 postalCode nvarchar(10),
	 latitude nvarchar(15),
	 longitude nvarchar(15),
	 metroCode nvarchar(15),
	 areaCode nvarchar(15)
)

CREATE CLUSTERED INDEX Geo_Info_Look
ON GeoLocation
([locId], [country], [region], [city], [latitude], [longitude])