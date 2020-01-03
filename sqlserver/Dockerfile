FROM microsoft/mssql-server-linux

ENV ACCEPT_EULA Y
ENV SA_PASSWORD Passw0rd

COPY ./entrypoint.sh ./SqlCmdStartup.sh ./SqlCmdScript.sql ./
RUN chmod +x ./SqlCmdStartup.sh
CMD /bin/bash ./entrypoint.sh