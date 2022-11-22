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



arquivos=$(ls *.cry 2>/dev/null)

echo "[+] Desfazendo criptografia."

for file in $arquivos
do
	novo_nome=$(basename $file .cry)
	openssl enc -in $file -out $novo_nome -d -md sha512 -k chave.key
	rm $file
done

echo "[+] Restauração concluída."
