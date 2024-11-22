## Tutorial: Como Submeter e Gerenciar Jobs com PBS em um Cluster Computacional

O **PBS (Portable Batch System)** é um sistema de gerenciamento de jobs usado para agendar e executar tarefas em clusters computacionais. Aqui, explicaremos como criar, submeter e monitorar jobs usando o PBS.

---

## **1. O que é um Job no PBS?**
Um **job** no PBS é um conjunto de comandos ou scripts que você quer executar em um cluster. Ele contém:
- Configurações de recursos (CPU, memória, tempo de execução).
- O comando ou programa a ser executado.
- Qualquer entrada e saída relacionada ao job.

---

## **2. Estrutura Básica de um Script PBS**
Um script PBS é geralmente um arquivo de texto contendo as configurações e comandos necessários para executar o job.

### Exemplo de Script PBS (`meu_job.pbs`):
```bash
#!/usr/bin/sh

# MZUSP01

#################
# PBS VARIABLES #
#################
#PBS -V                  #exporta as vaiaveis do ambiente
#PBS -N meu_job          # Nome do job
#PBS -e spadesp1.stderr  # Nome que irá salvar o arquivo de erro
#PBS -o spadesp1.stdout  # Nome que irá salvar o output
#PBS -r n				 # o job nao pode ser reiniciado se cair
##PBS -q <workq|regular> # opçoes da de PBS -q
#PBS -q workq            # Submete para a fila 'workq'
#PBS -l place=scatter    # Distribui as tarefas nos nós e processadores selecionados
##PBS -l select=<1-11>:ncpus=<1-64>:mpiprocs=<1-64>:mem=<gb>:host=<no1-no11> #opçoes disponíveis no cluster
#PBS -l select=1:ncpus=64:mpiprocs=64:host=no7  #aqui foi selecionado 1 nó, 64 processadores e o nó 7 especificamente
#PBS -l walltime=10000:00:00 # Tempo máximo de execução (HH:MM:SS)
##FABRIC=<shm|sock|ssm|rdma|rdssm>
FABRIC=rdma
CORES=$[ `cat $PBS_NODEFILE | wc -l` ]
NODES=$[ `uniq $PBS_NODEFILE | wc -l` ]
# Mover para o diretório de trabalho
cd $PBS_O_WORKDIR

###################
# LOG AND MODULES #
###################

printf "Time =  `date`\n" > $PBS_JOBNAME-$PBS_JOBID.LOG
printf "PBS work directory = $PBS_O_WORKDIR\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
printf "PBS queue = $PBS_O_QUEUE\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
printf "PBS job ID = $PBS_JOBID\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
qstat -f $PBS_JOBID > $PBS_JOBID.TXT
printf "PBS job name = $PBS_JOBNAME\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG 
printf "Fabric interconnect selected = $FABRIC\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
printf "This job will run on $CORES processors\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
printf "List of nodes in $PBS_NODEFILE\n\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG

###########
# COMMAND #
###########

python meu_programa.py
````
---

## **3. Submetendo um Job ao PBS**

Use o comando `qsub` para submeter o script:
```bash
# o arquivo de texto acima deve ser salvo como meu_job.pbs 
qsub meu_job.pbs
```

Ao submeter o job, o PBS retornará um **ID do job** (por exemplo, `1234.cluster`), que você usará para monitorar ou gerenciar o job.

---

## **4. Monitorando o Status de um Job**

### 4.1 Verificar todos os jobs na fila:
```bash
qstat
```

### 4.2 Verificar detalhes de um job específico:
```bash
qstat -f <job_id>
```

### 4.3 Exibir jobs de um usuário específico:
```bash
qstat -u <seu_usuario>
```

---

## **5. Cancelando um Job**

Caso precise cancelar um job em execução ou na fila, use o comando:
```bash
qdel <job_id>
```

## **6. Dicas e Boas Práticas**
- **Teste localmente**: Antes de submeter ao cluster, teste seu script em uma máquina local para evitar erros.
- **Verifique quais nós estão livres**: Antes de submeter um job no cluster é importante verificar quais nós estão livres para executar tarefas, assim seu job não fica na fila sem necessidade
``` bash
pbsnodes -a
````
---

## **7. Exemplo de como fazer um pbs para rodar o assembly no phyluce**

### 1. Instalar o Miniconda e phyluce:
- Cada usuário do cluster é um ambiente separado e por isso possui apenas os programas gerais instalados.
- Por isso, você deve instalar o miniconda e o phyluce no seu usuário da mesma forma que foi feito no tutorial do phyluce.

### 2. Criar um bash com o comando para rodar o assembly
- Depois de criar o arquivo de configuração para rodar o assembly `conf_spades_aula.conf` e criar a pasta `log`, vamos criar um arquivo em bash com o comando para rodar a função do assembly chamado `bash_assembly.sh`


```bash
#!/bin/bash
set -o errexit

source activate phyluce-1.7.3

MY_CONFIG="/home/fernanda/2024_UCEs_USP183203/0_codes_and_conf_UCEs24/conf_spades_aula.conf" # My configuration file
OUTPUT_DIR="/home/fernanda/2024_UCEs_USP183203/3_assembly_spades" # My output directory
LOG_DIR="/home/fernanda/2024_UCEs_USP183203/log" # Path to log files

function main {
	printf "> START Assembly Spades: `date`\n"
	phyluce_assembly_assemblo_spades  \
		--config ${MY_CONFIG} \
		--output ${OUTPUT_DIR} \
		--cores 64 \
		--memory 122 \
		--log-path ${LOG_DIR}
	wait
	printf "> END Assembly Spades: `date`\n"
}

main

conda deactivate

exit
````
### 3. Criar um arquivo pbs para executar o comando do assembly
Vamos criar .pbs um arquivo chamado `pbs_assembly_aula.pbs` com o seguinte formato

```bash
#!/usr/bin/sh

# MZUSP01

#################
# PBS VARIABLES #
#################

#PBS -V
#PBS -N assembly_aula
#PBS -e assembly.stderr
#PBS -o assembly.stdout
#PBS -r n
##PBS -q <workq|regular>
#PBS -q workq
##PBS -l <free|pack|scatter|vscatter>
#PBS -l place=scatter
##PBS -l select=<1-11>:ncpus=<1-64>:mpiprocs=<1-64>:mem=<gb>:host=<no1-no11>
#PBS -l select=1:ncpus=64:mpiprocs=64:host=no7
#PBS -l walltime=10000:00:00
##FABRIC=<shm|sock|ssm|rdma|rdssm>
FABRIC=rdma
CORES=$[ `cat $PBS_NODEFILE | wc -l` ]
NODES=$[ `uniq $PBS_NODEFILE | wc -l` ]
cd $PBS_O_WORKDIR

###################
# LOG AND MODULES #
###################

printf "Time =  `date`\n" > $PBS_JOBNAME-$PBS_JOBID.LOG
printf "PBS work directory = $PBS_O_WORKDIR\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
printf "PBS queue = $PBS_O_QUEUE\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
printf "PBS job ID = $PBS_JOBID\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
qstat -f $PBS_JOBID > $PBS_JOBID.TXT
printf "PBS job name = $PBS_JOBNAME\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG 
printf "Fabric interconnect selected = $FABRIC\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
printf "This job will run on $CORES processors\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG
printf "List of nodes in $PBS_NODEFILE\n\n" >> $PBS_JOBNAME-$PBS_JOBID.LOG

###########
# COMMAND #
###########

sh bash_spadesP1_uces24.sh > stdout_assembly.txt 2> stderr_assembly.txt

```

### 4. Submeta o job:
```bash

qsub pbs_assembly_aula.pbs
    ```
### 5. Monitore o job:
```bash
qstat
```

---

