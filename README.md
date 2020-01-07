# Running GeoLite2 on Docker

This tutorial will walk you through setting up GeoLite2 databases which are free IP geolocation databases.

You will need to register and obtain a license key from the [MaxMind](https://www.maxmind.com/) website.

[GeoLite2 Databases](https://dev.maxmind.com/geoip/geoip2/geolite2/) has more detailed information about the databases and how to sign up for a license key.

## MaxMind Account

[MaxMind](https://www.maxmind.com/) now requires you to register with them to obtain a license key for downloading the GeoLite2 Databases.

Once you have generated your free license key you can test downloading the CSV version of the GeoLite2 database using this url: https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City-CSV&license_key=YOUR-LICENSE-KEY&suffix=zip

Ensure that you replace the license key in the URL with your own.

## ENV file

Use an .env file to manage your environment variables. This file is ignored by default in the [.gitignore](.gitignore) file.

```
$ touch .env
```

Add the environment variable MAXMIND_LICENSE_KEY=YOUR-LICENSE-KEY to your .env file.

## SQL Server

The SQL Server [Dockerfile](sqlserver/Dockerfile) uses multi-stage builds to configure the following two stages:

* 1st stage - Download and unzip the GeoLite2 databases in CSV format
* 2nd stage - Setup a SQL Server instance and run scripts to create the GeoLite2 database with tables as well as import the CSV files

## Usage

Use the following commands to setup the services and database:

```sh
$ docker-compose build
$ docker-compose up
```

Use the following commands to reset and remove the services and database:

```sh
$ docker-compose down
```

## Copyright

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

