FROM nginx/unit:1.28.0-python3.10

ARG USER=app
ARG USER_ID=1000

ENV APP_USER=$USER

RUN useradd $USER -u $USER_ID -m -r

RUN apt-get update;
RUN apt-get install -y git vim gettext;
RUN apt-get install -y nginx;
RUN apt-get clean;

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN pip3 install --upgrade pip wheel setuptools supervisor

ENTRYPOINT ["docker-entrypoint", "unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]