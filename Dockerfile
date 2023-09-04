FROM python:3.10.9-alpine3.16
LABEL maintainer="snoopykill@mail.ru"

WORKDIR /sopds

ADD https://github.com/mitshel/sopds/archive/refs/heads/master.zip /sopds.zip
ARG FB2C_I386=https://github.com/rupor-github/fb2converter/releases/latest/download/fb2c_linux_i386.zip

RUN apk add --no-cache -U unzip \
    && unzip /sopds.zip && rm /sopds.zip && mv sopds-*/* ./

COPY requirements.txt .
COPY configs/settings.py ./sopds
COPY scripts/fb2conv /fb2conv
COPY scripts/superuser.exp .

RUN apk add --no-cache -U tzdata build-base libxml2-dev libxslt-dev libffi-dev libc-dev jpeg-dev zlib-dev curl \
    && cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
    && echo "Europe/Moscow" > /etc/timezone \
    && pip3 install --upgrade pip setuptools 'psycopg2-binary>=2.8,<2.9' \
    && pip3 install --upgrade -r requirements.txt \
    && curl -L -o /fb2c_linux.zip ${FB2C_I386}; \
    && unzip /fb2c_linux.zip -d /sopds/convert/fb2c/ \
    && rm /fb2c_linux.zip \
    && pip install toml-cli \
    && /sopds/convert/fb2c/fb2c export /sopds/convert/fb2c/ \
    && toml set --toml-path /sopds/convert/fb2c/configuration.toml logger.file.level none \
    && mv /fb2conv /sopds/convert/fb2c/fb2conv \
    && chmod +x /sopds/convert/fb2c/fb2conv \
    && ln -sT /sopds/convert/fb2c/fb2conv /sopds/convert/fb2c/fb2epub \
    && ln -sT /sopds/convert/fb2c/fb2conv /sopds/convert/fb2c/fb2mobi \
    && mkdir -p /sopds/tmp/ \
    && chmod ugo+w /sopds/tmp/

COPY scripts/start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 8001

ENTRYPOINT ["/start.sh"]
