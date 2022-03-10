FROM ubuntu:focal

# Variables
ENV APP_DIR /src
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV TZ=Asia/Ho_Chi_Minh

# Time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# App dir
RUN mkdir ${APP_DIR}
WORKDIR ${APP_DIR}

# Upgrade apt cache
RUN apt update --fix-missing && apt install -f

RUN apt upgrade -y && apt dist-upgrade -y 

# Install neccesaries
RUN apt install -y \
                python3 python3-pip python3-tk python3-dev python3-setuptools \
                vim curl git wget zip unzip net-tools openssl \
                ca-certificates build-essential checkinstall \
                libbz2-dev libc6-dev libffi-dev libgdbm-dev libncursesw5-dev \
                libreadline-gplv2-dev libsqlite3-dev libssl-dev \
                libc-client-dev libfreetype6-dev libmcrypt-dev libcairo2-dev libpango1.0-dev libpng-dev libjpeg-dev libgirepository1.0-dev \
                libldap2-dev libkrb5-dev libtidy-dev libzip-dev libsodium-dev \
                libmysqlclient-dev tk-dev zlib1g-dev \
                gettext ffmpeg

RUN apt install -y nginx

RUN pip3 install -U pip wheel virtualenv

# Remove downloaded package files to reduce image size
RUN apt autoremove -y && apt clean -y

# Nginx
COPY nginx.conf /etc/nginx/sites-available/default

# Entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN ln -s /usr/local/bin/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]