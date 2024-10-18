
# Processamento de dados brutos de UCEs no Phyluce

## Renomear as sequencias
As sequencias chegam da emepresa com o nome muito longo, por isso recomendo utilizar um nome mais curto para facilitar as analises subsequentes

## 1. renomear os arquivos com o programa krename
 Antes de começar a renomear faça uma cópia da pasta com as sequências, para ter um backup das sequências com os nomes original
```bash
cd /home/fernanda/Desktop/uces_analises_teste

mkdir 1_raw_reads

cd /fastq

cp *fastq.gz ../1_raw_reads

cd ..
cd /1_raw_reads

## Instalar o programa krname

sudo apt-get intall krename

krename # digitar krename no terminal

#Abrir o programa
# Em 1.Files clicar em add
#ir para a aba 4.Filename
# Template digitar:

[$32;10][$65;20] #

# find and replace  
"__" por "_"
"_001." por "."
```

# Tutorial Phyluce - baseado em https://phyluce.readthedocs.io/en/latest/tutorials/tutorial-1.html


## Instalando o Miniconda  

O Conda é um gerenciador de pacotes e ambientes, desenvolvido para instalar, rodar e gerenciar pacotes e dependências de software de forma eficiente. Ele é amplamente utilizado para gerenciar ambientes Python e R, mas pode ser usado para outras linguagens.

Em projetos que usam várias bibliotecas e versões diferentes de pacotes, é fácil que conflitos surjam. Por exemplo, diferentes versões de uma mesma biblioteca podem ser necessárias para projetos distintos. O Conda ajuda a isolar ambientes, prevenindo que as dependências de um projeto afetem outro.
```bash

#criando a pasta para o miniconda
mkdir -p ~/miniconda3

#Fazendo o download do miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh

#instalando o miniconda
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3

#removendo o arquivo de instalacao
rm ~/miniconda3/miniconda.sh

~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh

##check installation

conda list
```
## Instalacao do Phyluce 

phyluce is a software package for working with data generated from sequence capture of UCE (ultra-conserved element) loci, as first published in [BCF2012]. Specifically, phyluce is a suite of programs to:

- assemble raw sequence reads from Illumina platforms into contigs
- determine which contigs represent UCE loci
- filter potentially paralagous UCE loci
- generate different sets of UCE loci across taxa of interest
- Additionally, phyluce is capable of the following tasks, which are generally suited to any number of phylogenomic analyses:

  - produce large-scale alignments of these loci in parallel
  - manipulate alignment data prior to further analysis
  - convert alignment data between formats
  - compute statistics on alignments and other data

## Fazer download do phyluce
```bash

wget https://raw.githubusercontent.com/faircloth-lab/phyluce/v1.7.3/distrib/phyluce-1.7.3-py36-Linux-conda.yml

conda env create -n phyluce-1.7.3 --file phyluce-1.7.3-py36-Linux-conda.yml

conda activate phyluce-1.7.3 
```
# 1. Clean reads - limpeza dos dados de leitura

Os dados quando chegam da empresa sao chamados de dados brutos, sem qualquer filtragem. Isso significa que pode conter contaminacao por adaptadores e bases de baixa qualidade e isso precisa ser removido. Essa funcao usa outro programa criado pelo Faircloth o Illumiprocessor

Para usar esse programa, 'e necessario criar um arquivo de configuracao que sera usado para informar o programa quais sao as sequencias dos adaptadores, os barcodes de cada amostra e tambem 'e possivel mudar o nome das amostars nesse passo.
```bash
# this is the section where you list the adapters you used
[adapters]
i7:GATCGGAAGAGCACACGTCTGAACTCCAGTCAC-BCBCBCBC-ATCTCGTATGCCGTCTTCTGCTTG
i5: AATGATACGGCGACCACCGAGATCTACAC-BCBCBCBC-ACACTCTTTCCCTACACGACGCTCTTCCGATCT

# this is the list of indexes we used
[tag sequences]
i5-1:AGGATAGG
i7-1:GTGTTCTA
i7-2:AGTCACTA
i7-3:ATTGGCTC

# this is how each index maps to each set of reads
[tag map]
P001_WA01:i5-1,i7-1
P001_WA02:i5-1,i7-2
P001_WA03:i5-1,i7-3

# we want to rename our read files something a bit more nice
[names]
P001_WA01:SDB692_Xip_alb_MCNA-6076_BR_MG
P001_WA02:SDB693_Xip_alb_LOMO-187_BR_BA
P001_WA03:SDB694_Xip_alb_LOMO-191_BR_BA
```

Com o arquivo de configuracao preparado, agora nos precisamos rodar Illumiprocessor contra os nossos dados brutos de sequencias

Antes disso, vamos criar uma pasta para guardar nossos arquivos log:
```bash
cd /home/fernanda/Desktop/uces_analises_teste
mkdir log_aula
```
Agora sim, vamos rodar o comando do programa
Atencao para o numero de cores (modifique de acordo com o numero disponivel no seu computador)
```bash
illumiprocessor  \
		--input  /home/fernanda/Desktop/uces_analises_teste/1_raw_reads \
		--config /home/fernanda/Desktop/uces_analises_teste/0_codes_and_conf/conf_illumi_aula.conf \
		--output /home/fernanda/Desktop/uces_analises_teste/2_clean_reads \
		--cores 3 \
		--r1-pattern _R1 \
		--r2-pattern _R2 \
		--log-path /home/fernanda/Desktop/uces_analises_teste/log_aula
```

# 2. Quality control
You might want to get some idea of what effect the trimming has on read counts and overall read lengths. There are certainly other (better) tools out there to do this (like FastQC), but you can get a reasonable idea of how good your reads are by running the following, which will output a CSV listing of read stats by sample:
```bash
# move to the directory holding our cleaned reads
cd 2_clean_reads/

# run this script against all directories of reads

for i in *;
do
    phyluce_assembly_get_fastq_lengths --input $i/split-adapter-quality-trimmed/ --csv;
done

samples,reads,total bp,mean length,95 CI length,min length,max length,median legnth,contigs >1kb
SDB692_Xip_alb_MCNA-6076_BR_MG-READ-singleton.fastq.gz,4630990,692653267,149.5691562711213,0.0046101287880817125,40,151,151.0
SDB693_Xip_alb_LOMO-187_BR_BA-READ-singleton.fastq.gz,3672197,544606896,148.3054683613107,0.006774350448695877,40,151,151.0
SDB694_Xip_alb_LOMO-191_BR_BA-READ2.fastq.gz,5186349,767723308,148.0276988687032,0.0060961705781704435,40,151,151.0
```

# 3. Assemble the data

phyluce has several options for assembly - you can use velvet, abyss, or spades. For this tutorial, we are going to use spades, because it seems to works best for most purposes, it is easy to install and run, and it works consistently. The helper programs for the other assemblers use the same config file, so you can easily experiment with all of the assemblers.

To run an assembly, we need to create a another configuration file. The assembly configuration file looks like the following, assuming we want to assemble all of our data from the organisms above:
```bash
[samples]

SDB692_Xip_alb_MCNA-6076_BR_MG:/home/fernanda/Desktop/uces_analises_teste/SDB692_Xip_alb_MCNA-6076_BR_MG/split-adapter-quality-trimmed/
SDB693_Xip_alb_LOMO-187_BR_BA:/home/fernanda/Desktop/uces_analises_teste/2_clean_reads/SDB693_Xip_alb_LOMO-187_BR_BA/split-adapter-quality-trimmed/
SDB694_Xip_alb_LOMO-191_BR_BA:/home/fernanda/Desktop/uces_analises_teste/2_clean_reads/SDB694_Xip_alb_LOMO-191_BR_BA/split-adapter-quality-trimmed/
```

You need to modify this file to use the path to the clean read data on your computer

Com o arquivo de configuracao salvo, agora e so rodas o assembly:
```bash
phyluce_assembly_assemblo_spades  \
		--config /home/fernanda/Desktop/uces_analises_teste/0_codes_and_conf/conf_spades_aula.conf \
		--output /home/fernanda/Desktop/uces_analises_teste/3_assembly_spades \
		--cores 3 \
		--memory 6 \
		--log-path /home/fernanda/Desktop/uces_analises_teste/log_aula

### IMPORTANTE: NAO RODAR NO SEU NOTEBOOK! Pode demorar muito tempo e travar todo o seu computador, voce pode rodar o comando para ver se esta funcionando e depois para com "Ctrl c" 
```

