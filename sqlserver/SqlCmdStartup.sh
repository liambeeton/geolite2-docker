#!/bin/bash
# wait for the SQL Server to come up
sleep 10s

# run the script to create the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -d master -i ./SqlCmdScript.sql

# import GeoLite2 City IPv4 Addresses
/opt/mssql-tools/bin/bcp CityBlock in ./GeoLite2-City-Blocks-IPv4.csv -S localhost -U sa -P Passw0rd -d GeoLite2 -c -t ',' -r '0x0A'

# import GeoLite2 City Locations
/opt/mssql-tools/bin/bcp CityLocation in ./GeoLite2-City-Locations-en.csv -S localhost -U sa -P Passw0rd -d GeoLite2 -c -t ',' -r '0x0A'