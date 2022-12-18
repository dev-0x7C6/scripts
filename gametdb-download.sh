#!/usr/bin/env bash

date="2022-12-14"

for type in {disc,cover3D,cover}; do
	for lang in {US,JA,EN,FR,DE,ES,IT,NL,AU,SE,DK,NO,FI,KO,ZH,RU}; do
		curl "https://www.gametdb.com/download.php?FTP=GameTDB-wii_${type}-${lang}-${date}.zip" -o "GameTDB-wii_${type}-${lang}-2022-12-14.zip"
	done
done
