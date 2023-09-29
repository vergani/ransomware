#!/bin/bash
#################################
# Autor: Rafael Vergani 	#
# https://github.com/vergani 	#
# Data: 29/09/2023		#
#################################

if [[ -f resgate.pem && -f chave.enc ]];
then
	echo "[+] Restaurando chave de resgate."
	openssl rsautl -in chave.enc -out chave.key -decrypt -inkey resgate.pem
else
	echo "[-] Necessita arquivos de resgate."
	exit 0
fi


volume_alvo=/dados
arquivos=$(find $volume_alvo -print | egrep ".cry")

echo "----------------------------------------------"
echo "[+] Desfazendo criptografia."
echo "----------------------------------------------"
i=0
for file in $arquivos
do
	path=$(dirname $(readlink -f $file))
	novo_nome=$(basename $file .cry)
	fullname=$path/$novo_nome
	openssl enc -in $file -out $fullname -d -aes-256-cbc -pbkdf2 -k chave.key
	echo "$fullname"
	rm $file
 	((i=i+1))
done
echo "----------------------------------------------"
echo "$i arquivos restaurados com sucesso"
echo "----------------------------------------------"
