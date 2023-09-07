FROM python:3.10.9-slim-buster
LABEL maintainer="snoopykill@mail.ru"

WORKDIR /sopds

ADD https://github.com/mitshel/sopds/archive/refs/heads/master.zip /sopds.zip

RUN apt-get -y update \
    && apt-get install -y unzip python3-pip python3-dev build-essential libssl-dev default-libmysqlclient-dev curl \
    && unzip /sopds.zip && rm /sopds.zip && mv sopds-*/* ./

COPY requirements.txt .
COPY configs/settings.py ./sopds

RUN cp /usr/share/zoneinfo/Europe/Warsaw /etc/localtime \
    && echo "Europe/Warsaw" > /etc/timezone \
    && pip3 install --upgrade -r requirements.txt \
    && mkdir -p /sopds/tmp/ \
    && chmod ugo+w /sopds/tmp/

ENV TIME_ZONE="Europe/Warsaw"

COPY scripts/start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["bash","/start.sh"]

EXPOSE 8001
