### Install conda GATK certo #####

cd ~ 
conda env create -n gatk -f /home/fernanda/Desktop/uces_analises_teste/programs/gatk-4.2.0.0/gatkcondaenv.yml
#ativar o ambiente
conda activate gatk

# find out where python lives
which python
# aqui vai mostrar on fica a pasta /bin - ir ate ela
cd /home/fernanda/miniconda3/envs/gatk/bin
# change to the bin directory in this environment an link to the gatk wrapper which is back in the gatk package

# precisamos fazer um link para o executavel do gatk que esta dentro da pasta que voces baixaram na pasta programas
# IMPORTANTE!! executar esse comando dentro da pasta bin do ambiente!

# se precisar instalar o programa ln
# sudo apt-get install ln
ln -s /home/fernanda/Desktop/uces_analises_teste/programs/gatk-4.2.0.0/gatk

#instalar o samtools
conda install bwa samtools=1.9




