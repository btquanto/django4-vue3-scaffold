FROM node:17-alpine3.14

ARG USER=app
ARG USER_ID=1000

RUN if [ "$(id -u node)" -ne "$USER_ID" ]; then adduser -D -u $USER_ID $USER; fi;

ENTRYPOINT ["sleep", "infinity"]

RUN apk add --no-cache git;