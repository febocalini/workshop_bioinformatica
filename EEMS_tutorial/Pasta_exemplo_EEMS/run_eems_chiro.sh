#!/bin/bash

# Ativar o ambiente Conda

source activate eems_env || { echo "Erro ao ativar o ambiente Conda"; exit 1; }

# Ir para o diretório do EEMS
cd /home/fernanda/eems/runeems_snps/src/ || { echo "Erro ao acessar o diretório"; exit 1; }

# Executar as análises para cada conjunto de dados

for d in 200 400 600; do
  for i in 1 2 3; do
    SEED=$((123 + (i - 1) * 222))
    PARAMS="/home/fernanda/EEMS_brejos/chiroxiphia/d${d}/chiro_eems_chain${i}.in"
    
    echo "Rodando EEMS para d${d}, chain ${i}..."
    ./runeems_snps --params "$PARAMS" --seed "$SEED" &
  done
done
wait
echo "Todas as execuções foram concluídas!"


