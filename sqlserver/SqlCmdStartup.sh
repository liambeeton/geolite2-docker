#!/bin/bash
# wait for the SQL Server to come up
sleep 10s

# run the script to create the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -d master -i ./SqlCmdScript.sql

# create format file for GeoLite2 IPv4 Addresses
# /opt/mssql-tools/bin/bcp GeoLite2.dbo.IpAddressV4 format nul -S localhost -U sa -P Passw0rd -c -f IpAddressV4-c.fmt

# create format file for GeoLite2 City
# /opt/mssql-tools/bin/bcp GeoLite2.dbo.City format nul -S localhost -U sa -P Passw0rd -c -f City-c.fmt

# import GeoLite2 IPv4 Addresses
/opt/mssql-tools/bin/bcp GeoLite2.dbo.IpAddressV4 in ./geolite2/GeoLite2-City-Blocks-IPv4.csv -c -t ',' -r '0x0A' -F 2 -S localhost -U sa -P Passw0rd

# import GeoLite2 City
/opt/mssql-tools/bin/bcp GeoLite2.dbo.City in ./geolite2/GeoLite2-City-Locations-en.csv -c -t ',' -r '0x0A' -F 2 -S localhost -U sa -P Passw0rd