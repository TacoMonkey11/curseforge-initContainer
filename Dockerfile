FROM debian:stable-slim

RUN apt update && apt -y install --no-install-recommends jq curl unzip ca-certificates

COPY ./script/find-denied-mods.sh /usr/src/find-denied-mods.sh

VOLUME [ "/downloads" ]
WORKDIR "/downloads"

ENTRYPOINT [ "/bin/bash", "/usr/src/find-denied-mods.sh" ]