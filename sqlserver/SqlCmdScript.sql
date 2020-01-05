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

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CityBlock')
DROP TABLE CityBlock
GO

CREATE TABLE CityBlock (
    network nvarchar(15) default NULL,
	geoname_id nvarchar(15) default NULL,
	registered_country_geoname_id nvarchar(15) default NULL,
	represented_country_geoname_id nvarchar(15) default NULL,
	is_anonymous_proxy nvarchar(15) default NULL,
	is_satellite_provider nvarchar(15) default NULL,
	postal_code nvarchar(15) default NULL,
	latitude nvarchar(15) default NULL,
	longitude nvarchar(15) default NULL,
	accuracy_radius nvarchar(15) default NULL
)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CityLocation')
DROP TABLE CityLocation
GO

CREATE TABLE CityLocation (
	geoname_id nvarchar(15) default NULL,
	locale_code nvarchar(15) default NULL,
	continent_code nvarchar(15) default NULL,
	continent_name nvarchar(15) default NULL,
	country_iso_code nvarchar(15) default NULL,
	country_name nvarchar(15) default NULL,
	subdivision_1_iso_code nvarchar(15) default NULL,
	subdivision_1_name nvarchar(15) default NULL,
	subdivision_2_iso_code nvarchar(15) default NULL,
	subdivision_2_name nvarchar(15) default NULL,
	city_name nvarchar(15) default NULL,
	metro_code nvarchar(15) default NULL,
	time_zone nvarchar(15) default NULL,
	is_in_european_union nvarchar(15) default NULL
)