IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'GeoLite2')
	CREATE database GeoLite2;
GO

USE [master]
GO

IF NOT EXISTS(SELECT 1 FROM [GeoLite2].sys.database_principals WHERE name = 'GeoLite2User')
	CREATE LOGIN [GeoLite2User] WITH PASSWORD=N'Password123', DEFAULT_DATABASE=[GeoLite2], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
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

IF EXISTS (SELECT 1 FROM Information_schema.Routines WHERE Specific_schema = 'dbo' AND specific_name = 'IPAddressToInteger' AND Routine_Type = 'FUNCTION') 
	DROP FUNCTION dbo.IPAddressToInteger
GO

CREATE FUNCTION dbo.IPAddressToInteger(@IP varchar(15))
RETURNS bigint
AS
BEGIN
	DECLARE @num bigint

	SET @num = 
		CONVERT(bigint, PARSENAME(@IP, 4)) * 256 * 256 * 256 +
		CONVERT(bigint, PARSENAME(@IP, 3)) * 256 * 256 +
		CONVERT(bigint, PARSENAME(@IP, 2)) * 256 +
		CONVERT(bigint, PARSENAME(@IP, 1))

	RETURN (@num)
END
GO

IF EXISTS (SELECT 1 FROM Information_schema.Routines WHERE Specific_schema = 'dbo' AND specific_name = 'GetStartIp' AND Routine_Type = 'FUNCTION') 
	DROP FUNCTION dbo.GetStartIp
GO

CREATE FUNCTION dbo.GetStartIp(@CidrIP varchar(64))
RETURNS bigint
AS
BEGIN
	DECLARE @num bigint
	SET @num = dbo.IPAddressToInteger(LEFT(@CidrIP, patindex('%/%' , @CidrIP) - 1)) & (cast(4294967295 as bigint) ^ (Power(2, 32 - Cast(substring(@CidrIP, patindex('%/%' , @CidrIP) + 1, 2) as int)) - 1))
	RETURN @num
END
GO

IF EXISTS (SELECT 1 FROM Information_schema.Routines WHERE Specific_schema = 'dbo' AND specific_name = 'GetEndIp' AND Routine_Type = 'FUNCTION') 
	DROP FUNCTION dbo.GetEndIp
GO

CREATE FUNCTION dbo.GetEndIp(@StartIp bigint, @CidrIP varchar(64))
RETURNS bigint
AS
BEGIN
	DECLARE @num bigint
	SET @num = @StartIp + (Power(2, 32 - Cast(substring(@CidrIP, patindex('%/%' , @CidrIP) + 1, 2) as int)) - 1) 
	RETURN @num
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GeoLite2IPv4')
	DROP TABLE GeoLite2IPv4
GO

CREATE TABLE [GeoLite2IPv4] (
	[network] [nvarchar](64) NOT NULL,
	[geoname_id] [int] NULL,
	[registered_country_geoname_id] [int] NULL,
	[represented_country_geoname_id] [int] NULL,
	[is_anonymous_proxy] [int] NULL DEFAULT ((0)),
	[is_satellite_provider] [int] NULL DEFAULT ((0)),
	[postal_code] [nvarchar](16) NULL,
	[latitude] [decimal](9,6) NULL,
	[longitude] [decimal](9,6) NULL,
	[accuracy_radius] [int] NULL
)

ALTER TABLE [GeoLite2IPv4] ADD CONSTRAINT [PK_GeoLite2IPv4] PRIMARY KEY CLUSTERED ([network])
GO

BULK INSERT GeoLite2IPv4 
FROM 'C:\geolite2\GeoLite2-City-Blocks-IPv4.csv'
WITH 
(
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
) 

ALTER TABLE GeoLite2IPv4 ADD startIpNum bigint NOT NULL DEFAULT 0
ALTER TABLE GeoLite2IPv4 ADD endIpNum bigint NOT NULL DEFAULT 0
GO

UPDATE GeoLite2IPv4 SET startIpNum = dbo.GetStartIp(network)
UPDATE GeoLite2IPv4 SET endIpNum = dbo.GetEndIp(startIpNum, network)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GeoLite2IPv6')
	DROP TABLE GeoLite2IPv6
GO

CREATE TABLE GeoLite2IPv6 (
	[network] [nvarchar](64) NOT NULL,
	[geoname_id] [int] NULL,
	[registered_country_geoname_id] [int] NULL,
	[represented_country_geoname_id] [int] NULL,
	[is_anonymous_proxy] [int] NULL DEFAULT ((0)),
	[is_satellite_provider] [int] NULL DEFAULT ((0)),
	[postal_code] [nvarchar](16) NULL,
	[latitude] [decimal](9,6) NULL,
	[longitude] [decimal](9,6) NULL,
	[accuracy_radius] [int] NULL
)

ALTER TABLE [GeoLite2IPv6] ADD CONSTRAINT [PK_GeoLite2IPv6] PRIMARY KEY CLUSTERED ([network])
GO

BULK INSERT GeoLite2IPv6 
FROM 'C:\geolite2\GeoLite2-City-Blocks-IPv6.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a'  --Use to shift the control to next row
)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GeoLite2Locations')
	DROP TABLE GeoLite2Locations
GO

CREATE TABLE GeoLite2Locations (
	[geoname_id] [int] NOT NULL,
	[locale_code] [nvarchar](16) NULL,
	[continent_code] [nvarchar](16) NULL,
	[continent_name] [nvarchar](64) NULL,
	[country_iso_code] [nvarchar](16) NULL,
	[country_name] [nvarchar](64) NULL,
	[subdivision_1_iso_code] [nvarchar](64) NULL,
	[subdivision_1_name] [nvarchar](64) NULL,
	[subdivision_2_iso_code] [nvarchar](64) NULL,
	[subdivision_2_name] [nvarchar](64) NULL,
	[city_name] [nvarchar](64) NULL,
	[metro_code] [nvarchar](32) NULL,
	[time_zone] [nvarchar](64) NULL
)

ALTER TABLE [GeoLite2Locations] ADD CONSTRAINT [PK_GeoLite2Locations] PRIMARY KEY CLUSTERED ([geoname_id])
GO

BULK INSERT GeoLite2Locations 
FROM 'C:\geolite2\GeoLite2-City-Locations-en.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
) 

UPDATE GeoLite2Locations SET continent_name = REPLACE(continent_name, '"', '')
UPDATE GeoLite2Locations SET country_name = REPLACE(country_name, '"', '')
UPDATE GeoLite2Locations SET city_name = REPLACE(city_name, '"', '')
UPDATE GeoLite2Locations SET subdivision_1_name = REPLACE(subdivision_1_name, '"', '')
UPDATE GeoLite2Locations SET subdivision_2_name = REPLACE(subdivision_2_name, '"', '')