# ransomware
Lab para ransomware linux / unix


### para criar arquivos para simular arquivos reais:

for i in {001..999}; do head -c 1M </dev/zero >file$i; done

for n in {1..100}; do { < /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-30};echo; } ;done > Business.txt
