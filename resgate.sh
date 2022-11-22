#!/bin/bash
#################################
# Autor: Rafael Vergani 	#
# https://github.com/vergani 	#
#################################


openssl rsautl -in chave.enc -out chave.key -decrypt -inkey resgate.pem

arquivos=$(ls *.cry)

# coment
for file in $arquivos
do
	novo_nome=$(basename $file .cry)
	openssl enc -in $file -out $novo_nome  -d -aes256 -k chave.key
	rm $file
done
