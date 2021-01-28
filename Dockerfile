FROM ubuntu:18.10

RUN mkdir -p /app

WORKDIR /app

ADD  ./app

RUN apt-get update
RUN apt-get install apache2
RUN service apache2 start

VOLUME ["/data", "/var/log/httpd"]

EXOPOSE 8080

CMD ["/app/log.backup.sh"]

