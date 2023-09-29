# ransomware
Lab para ransomware linux / unix


## para criar 999 arquivos de 1Mb cada um em uma pasta para simular arquivos reais:
for i in {001..999}; do head -c 1M </dev/zero >file$i; done
