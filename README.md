# ransomware
Lab para ransomware linux / unix


Para criar arquivos para simular arquivos reais:

for i in {000..999}; do base64 /dev/urandom | head -c 1000 > file$i.txt; done


