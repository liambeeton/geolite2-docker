# Running GeoLite2 on Docker

This tutorial will walk you through setting up GeoLite2 databases which are free IP geolocation databases.

Here you can get more information about [GeoLite2 Free Downloadable Databases](https://dev.maxmind.com/geoip/geoip2/geolite2/).

You will need to register and obtain a license key from the [MaxMind](https://www.maxmind.com/) website.

## MaxMind Account

MaxMind now requires you to register with them to obtain a license key for downloading the GeoLite2 Databases.

Once you have generated your free license key you can test downloading the CSV version of the GeoLite2 database using this url: https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City-CSV&license_key=ABCD12345&suffix=zip

Ensure that you replace the license key in the URL with your own.

## Usage

```sh
$ docker-compose build
$ docker-compose up
$ docker-compose down
```

## Copyright

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

