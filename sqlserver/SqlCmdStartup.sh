#!/bin/bash
# wait for the SQL Server to come up
sleep 10s

# run the script to create the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -d master -i SqlCmdScript.sql

# run any other scripts
# /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -d master -i CleanupScript.sql