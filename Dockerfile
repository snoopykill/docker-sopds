FROM python:3.10.9-alpine3.16
LABEL maintainer="snoopykill@mail.ru"

WORKDIR /sopds

RUN wget https://github.com/snoopykill/sopds/archive/refs/heads/master.zip && mv master.zip sopds.zip

RUN apk add --no-cache -U unzip \
    && unzip sopds.zip && rm sopds.zip && mv sopds-*/* ./

COPY requirements.txt .
COPY configs/settings.py ./sopds
COPY scripts/fb2conv /fb2conv
COPY scripts/superuser.exp .

RUN apk add --no-cache -U tzdata build-base libxml2-dev libxslt-dev libffi-dev libc-dev jpeg-dev zlib-dev curl mariadb-dev \
    && cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
    && echo "Europe/Moscow" > /etc/timezone \
    && pip3 install --upgrade pip setuptools \
    && pip3 install --upgrade -r requirements.txt \
    && apk del mariadb-dev build-base \
    && mkdir -p /sopds/tmp/ \
    && chmod ugo+w /sopds/tmp/

COPY scripts/start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 8001
