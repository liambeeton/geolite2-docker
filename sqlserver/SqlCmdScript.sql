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
    network varchar(30) default NULL,
	geoname_id varchar(30) default NULL,
	registered_country_geoname_id varchar(30) default NULL,
	represented_country_geoname_id varchar(30) default NULL,
	is_anonymous_proxy varchar(30) default NULL,
	is_satellite_provider varchar(30) default NULL,
	postal_code varchar(30) default NULL,
	latitude varchar(30) default NULL,
	longitude varchar(30) default NULL,
	accuracy_radius varchar(30) default NULL
)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CityLocation')
DROP TABLE CityLocation
GO

CREATE TABLE CityLocation (
	geoname_id varchar(30) default NULL,
	locale_code varchar(30) default NULL,
	continent_code varchar(30) default NULL,
	continent_name varchar(30) default NULL,
	country_iso_code varchar(30) default NULL,
	country_name varchar(30) default NULL,
	subdivision_1_iso_code varchar(30) default NULL,
	subdivision_1_name varchar(30) default NULL,
	subdivision_2_iso_code varchar(30) default NULL,
	subdivision_2_name varchar(30) default NULL,
	city_name varchar(30) default NULL,
	metro_code varchar(30) default NULL,
	time_zone varchar(30) default NULL,
	is_in_european_union varchar(30) default NULL
)