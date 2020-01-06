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

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'IpAddressV4')
DROP TABLE IpAddressV4
GO

CREATE TABLE IpAddressV4 (
    Network varchar(30) default NULL,
	GeonameId varchar(30) default NULL,
	RegisteredCountryGeonameId varchar(30) default NULL,
	RepresentedCountryGeonameId varchar(30) default NULL,
	IsAnonymousProxy varchar(30) default NULL,
	IsSatelliteProvider varchar(30) default NULL,
	PostalCode varchar(30) default NULL,
	Latitude varchar(30) default NULL,
	Longitude varchar(30) default NULL,
	AccuracyRadius varchar(30) default NULL
)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'City')
DROP TABLE City
GO

CREATE TABLE City (
	GeonameId varchar(30) default NULL,
	LocaleCode varchar(30) default NULL,
	ContinentCode varchar(30) default NULL,
	ContinentName varchar(30) default NULL,
	CountryIsoCode varchar(30) default NULL,
	CountryName varchar(30) default NULL,
	Subdivision1IsoCode varchar(30) default NULL,
	Subdivision1Name varchar(30) default NULL,
	Subdivision2IsoCode varchar(30) default NULL,
	Subdivision2Name varchar(30) default NULL,
	CityName varchar(30) default NULL,
	MetroCode varchar(30) default NULL,
	TimeZone varchar(30) default NULL,
	IsInEuropeanUnion varchar(30) default NULL
)