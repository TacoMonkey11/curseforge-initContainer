FROM alpine:latest

RUN apk add --no-cache bash jq curl unzip

COPY ./script/find-denied-mods.sh /usr/src/find-denied-mods.sh

VOLUME [ "/downloads" ]
WORKDIR "/downloads"

ENTRYPOINT [ "/bin/bash", "/usr/src/find-denied-mods.sh" ]