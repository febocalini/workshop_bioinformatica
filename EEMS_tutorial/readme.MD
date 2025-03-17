
# Tutorial EEMS

## 1. Instalar o EEMS 

No cluster, crie um ambiente no conda para o EEMS seguindo este tutorial: https://github.com/febocalini/workshop_bioinformatica/blob/main/Tutorial_cluster_MZUSP01/tutorial_pbs.md

## 2. Transformar o vcf em diffs

Use a matriz unliked 95% completa (de preferência).

Transforme o arquivo .vcf em .diffs seguindo esse script: https://github.com/febocalini/workshop_bioinformatica/blob/main/EEMS_tutorial/Pasta_exemplo_EEMS/genind2diff_chiro.R

## 3. Criar o arquivo .coord

O arquivo .coord é um arquivo com apenas as coordenadas das amostras utilizadas na ordem que está na matriz de snps, sendo a primeira coluna a longitude e a segunda a latitude separado por tab (\t). Exemplo em: https://github.com/febocalini/workshop_bioinformatica/blob/main/EEMS_tutorial/Pasta_exemplo_EEMS/chiro_eems.coord

## 4. Criar o arquivo .outer

O arquivo .outer será a região do mapa onde você gostaria que programa plotasse os resultados. Pode ser, por exemplo, toda a America do Sul. 

Um tutorial de como criar um polígono no Qgis pode ser enconrado em: https://github.com/mtop/speciesgeocoder/wiki/Tutorial-for-creating-polygons-in-QGIS

Exemplo de um arquivo .outer: https://github.com/febocalini/workshop_bioinformatica/blob/main/EEMS_tutorial/Pasta_exemplo_EEMS/chiro_eems.outer

## 5. Criar as pastas para diferentes demes testados

Para cada valor de deme testado, criar uma pasta pasta para salvar os resultados. Exemplo d200 d400 d600

## 6. Criar as pastas para salvar 3 corridas para cada deme

Na pasta de cada deme criar 3 pastas para salvar os outputs: output_run1, output_run2, output_run3

## 7. Criar os arquivos de configuração (.in) para cada corrida 

Dentro da pasta de cada deme criar 3 arquivos de configuração (.in) para cada corrida. Exemplo aqui: https://github.com/febocalini/workshop_bioinformatica/blob/main/EEMS_tutorial/Pasta_exemplo_EEMS/d200/chiro_eems_chain1.in

## 8. Rodar o EEMS

```
##ir para a pasta com o arquivos executável
cd /Users/imac/eems/runeems_snps/src

#d200
#1
./runeems_snps --params /home/fernanda/EEMS_brejos/chiroxiphia/d200/chiro_eems_chain1.in --seed 123

```
Você pode rodar uma corrida de cada vez como no exemplo acima criar um arquivo .sh para rodar todas as corridas de uma vez como em: https://github.com/febocalini/workshop_bioinformatica/blob/main/EEMS_tutorial/Pasta_exemplo_EEMS/run_eems_chiro.sh

## 9. Criar um .pbs e submeter o job para o cluster

Criar um pbs como em: https://github.com/febocalini/workshop_bioinformatica/blob/main/EEMS_tutorial/Pasta_exemplo_EEMS/pbs_eems_chiro.pbs

```
#submeter o job no cluster
qsub pbs_eems_chiro.pbs

``` 







