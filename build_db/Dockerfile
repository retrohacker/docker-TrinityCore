# The backend postgres database for the auth and world servers
FROM mariadb:latest

ADD sql /sql

VOLUME /var/lib/mysql

ADD build.sh /build.sh
RUN chmod +x build.sh
