FROM alpine:latest
ARG license_key
RUN apk add --no-cache curl \
    && curl -Ls "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City-CSV&license_key=${license_key}&suffix=zip" -o geolite2.zip \
    && mkdir ./geolite2 \
    && unzip -j geolite2.zip -d ./geolite2 \
    && rm geolite2.zip

FROM microsoft/mssql-server-linux
ENV ACCEPT_EULA Y
ENV SA_PASSWORD Passw0rd
COPY --from=0 ./geolite2 ./geolite2
COPY ./entrypoint.sh ./SqlCmdStartup.sh ./SqlCmdScript.sql ./
RUN chmod +x ./SqlCmdStartup.sh
CMD /bin/bash ./entrypoint.sh