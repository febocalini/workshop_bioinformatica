# instalar o ambiente gatk
# baixar a pasta: https://www.dropbox.com/scl/fo/8lk7wl2oxg8ts3h0jqrbi/ABvcw2yupY9RzDPafHubEg4?rlkey=kpadg6j0ttphpvgpzl66p04vd&dl=0

cd ~ 
conda env create -n gatk -f /home/fernanda/Desktop/uces_analises_teste/programs/gatk-4.2.0.0/gatkcondaenv.yml
#ativar o ambiente
conda activate gatk
#instalar gatk 
conda install bioconda::gatk4
#instalar o samtools
conda install bwa samtools=1.9

