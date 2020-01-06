#!/bin/bash
# wait for the SQL Server to come up
sleep 10s

# run the script to create the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -d master -i ./SqlCmdScript.sql

# create Format file for GeoLite2 City IPv4 Addresses
# /opt/mssql-tools/bin/bcp GeoLite2.dbo.CityBlock format nul -S localhost -U sa -P Passw0rd -c -f CityBlock-c.fmt

# create Format file for GeoLite2 City Locations
# /opt/mssql-tools/bin/bcp GeoLite2.dbo.CityLocation format nul -S localhost -U sa -P Passw0rd -c -f CityLocation-c.fmt

# import GeoLite2 City IPv4 Addresses
/opt/mssql-tools/bin/bcp GeoLite2.dbo.CityBlock in ./geolite2/GeoLite2-City-Blocks-IPv4.csv -c -t ',' -r '0x0A' -S localhost -U sa -P Passw0rd

# import GeoLite2 City Locations
/opt/mssql-tools/bin/bcp GeoLite2.dbo.CityLocation in ./geolite2/GeoLite2-City-Locations-en.csv -c -t ',' -r '0x0A' -S localhost -U sa -P Passw0rd