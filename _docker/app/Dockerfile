FROM python:3.9-bullseye

ARG USER=app
ARG UID=1000
ARG GID=1000

RUN useradd $USER -u $UID -m -r

USER $USER
WORKDIR /home/${USER}

ENTRYPOINT ["sleep", "infinity"]