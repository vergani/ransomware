#!/bin/bash

openssl rsautl -in chave.enc -out chave.key -decrypt -inkey resgate.pem

arquivos=$(ls)

# coment
for file in $arquivos
do
	if [ "$file" != "ranso.sh" ] && [ "$file" != "chave.enc" ] && [ "$file" != "resgate.pem" ] && [ "file" != "resgate.sh" ];
	then
		openssl enc -in $file -out $file".limpo" -d -aes256 -k chave.key
	fi
done
