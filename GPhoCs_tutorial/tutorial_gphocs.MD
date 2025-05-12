
# Tutorial G-PhoCs 

## 1. Baixar e instalar o G-PhoCs do github

```
#1. Clone the G-PhoCS source code from the Github repository
git clone https://github.com/gphocs-dev/G-PhoCS.git

#2. Move to the obtained directory
cd G-PhoCS

#3. Compile G-PhoCS - See Section 9 for multithreading support.

# Ativar a versao multi-thread para conseguir usar todo o poder computacional do cluster

#First, check that OpenMP is installed on your machine. This can be done using the following command pipe in Ubuntu:
echo |cpp -fopenmp -dM | grep -i openmp

#If you have OpenMP installed, then the command pipe will output something like
# define _OPENMP 201511
#If the command prints out nothing, then OpenMP is probably not installed on your machine.

# Modify Makefile, by un-commenting the variable assignment on Line 7:
nano Makefile
# Multi threading enabling flag
#ENABLE_OMP_THREADS = 1

#To enable compilation of multi-threaded version, remove the # sign to un-comment line. To compile standard serial version, add the # sign in the beginning of line. Do not change value of variable.

#OpenMP is configured at this point. Run “make” command to obtain the executables.

make

```

## 2. Fazer o alinhamento das sequências
Fazer o alinhamento das sequências de UCEs até o passo 8 do tutorial (recomendo usar a matriz 95%)

Tutorial alinhamento: https://github.com/febocalini/workshop_bioinformatica/blob/main/Alignment_phyluce/alignment_tutorial.md

### 2.1. Converter o alinhamento em phylip
```bash
phyluce_align_convert_one_align_to_another \
   --alignments /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-95p-clean \
   --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/phylip-glauci-95p-gp \
   --input-format nexus \
   --output-format phylip-relaxed \
   --cores 3 \
   --log-path /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24
```

## 3. Converter o alinhamento em uma matriz concatenada para o G-PhoCs

A função que converte precisa do python 2.7, por isso, precisamos criar um ambiente no conda que tenha o python 2.7 como padrão
 
```` 

conda create -n py27 python=2.7

source activate py27

````

Usar a função `gphocs_from_phy.py` disponível em https://github.com/febocalini/workshop_bioinformatica/edit/main/GPhoCs_tutorial/gphocs_from_phy.py para converter o alinhamento

```` 
python gphocs_from_phy.py /media/fernanda/BOCALINI_HD/Part3_UCEs_2023/8_GPhocs/Chiroxiphia/phylip-chiro-95p-gp /media/fernanda/KINGSTON/2024_UCEs_USP183203/10_Gphocs/gphocs_brejos2025/chiroxiphia/chiro95_GPHOCS.txt

````

A matriz gerada precisa de alguns ajustes antes de dar entrada no programa:

````
sed -i 's/?/N/g' chiro95_GPHOCS.txt #substituir ? por N
sed -i 's/-/N/g' chiro95_GPHOCS.txt #substituir - por N

sed -i 's/_//g' chiro95_GPHOCS.txt #substituir _ por NADA - usar esse passo se o nome das suas amostras for muito longo o que pode dar erro no programa - assim ele vai substituir o "_" por nada

````

## 4. Criar o arquivo de configuração .ctl

Utilizar como exemplo o arquivo: `chiro_gphocs_m1.ctl`

Modificar: 

> 1. `seq-file` – nome da matriz concatenada criada `*GPHOCS.txt`
>  2. `trace-file` – nome do output que será gerado
> 3. `num-loci` – número de loci da sua matriz
> 4. `mcmc-iterations` – número de iterações – recomendo 5 milhões, mas vocês podem tentar rodar com 2 milhões se quiserem resultados mais rápidos
> 5. `CURRENT-POPS-START` – `POP-START` – nome das diferentes populações – lista quais amostras estão nas diferentes populações – o nome da amostra sempre será seguido por um "d", que significa que o indivíduo é diplóide.
> 6. `ANCESTRAL-POPS-START` – mostra como cada população vai coalescer – se tiver mais de duas populações, vai reconstruir a árvore
> 7. `MIG-BANDS-START` – descreve a direção das migrações entre populações que o programa deve considerar


## 5. Criar o pbs para rodar o programa no cluster

Usar como exemplo o arquivo `pbs_chiro95_m1.pbs` 

````

qsub pbs_chiro95_m1.pbs

````

Os passos 2, 3 e 4 podem ser feitos no seu computador, recomendo criar uma pasta com todos os arquivos de entrada e depois transferir para o cluster

 













