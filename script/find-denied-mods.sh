#!/bin/bash

#https://stackoverflow.com/a/37840948
function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

echo "Downloading latest version of Modpack"
echo "----------------------------------------------"

url="https://api.curseforge.com/v1/mods/${MODPACK_ID}/files/${FILE_ID}"


json=$(curl -s $url --header "x-api-key: $CF_API_KEY")


file_name=$(echo "$json" | jq '.data.fileName' | tr -d '"' | jq -sRr @uri)
file_name=${file_name%\%0A}
pack_url=$(echo "$json" | jq '.data.downloadUrl' | tr -d '"' | sed 's![^/]*$!!')


echo "Downloading: $pack_url$file_name"

curl -sL -o modpack.zip $pack_url$file_name

ls

unzip -o modpack.zip manifest.json

json=$(cat manifest.json)

rm -rf modpack.zip manifest.json


for row in $(echo "${json}" | jq -c '.files[]'); do

    projectId=$(echo ${row} | jq -r '.projectID')
    fileId=$(echo ${row} | jq -r '.fileID')

    url="https://api.curseforge.com/v1/mods/$projectId/files/$fileId"

    json=$(curl -s --location $url --header "x-api-key: $CF_API_KEY")


    if [[ $(echo "$json" | jq '.data.downloadUrl != null') == "false" ]]; then

        url="https://edge.forgecdn.net/files/$(echo $fileId | cut -c1-4)/$(echo $fileId | cut -c5-7)/$(echo "$json" | jq '.data.fileName' | tr -d '"' | jq -sRr @uri)"
        url=${url%\%0A}

        echo "Downloading: $url"
        curl -s -LO $url
    fi
done

# decode file names
for f in *.jar; do
    mv "$f" "$(urldecode "$f")"
done