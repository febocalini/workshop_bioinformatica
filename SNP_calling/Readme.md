
# SNP calling - extracao de SNPs  a partir do assembly

Ir ate a pasta em que estao os resultados do assembly
```bash
cd /home/fernanda/Desktop/uces_analises_teste/3_assembly_spades
ls -lts

# observe que todas as pastas tem um "_spades" no final e isso pode atrapalhar as analises subsequentes, por isso, precisamos renomear as pastas

# eliminar o spades dos diretórios ## 
find . -type d -execdir rename 's/_spades//' '{}' \+

#agora veja se o camando funcionou
ls 

#como copiei apenas 3 diretorios da pasta assembly do cluster, nao temos uma pasta "contigs" com os symlinks do assembly de cada amostra, por isso vamos cria-la

mkdir contigs

#instalar o programa ln para criar os symlinks
sudo apt-get install ln

#criar os symlinks
for dir in *; do
    for r in contigs.fasta; do
        outfile=${dir%/}.contigs.fasta
        glob=${r}
        ln -s "/home/fernanda/Desktop/uces_analises_teste/3_assembly_spades/$dir"/$glob contigs/"$outfile"
    done
done

#veja se funcionou
cd contigs
ls
#remova o link errado
rm contigs.contigs.fasta
cd ..
#Agora podemos seguir os proximos passos no phyluce
conda activate phyluce-1.7.3 
```
# 4.Finding UCE loci - encontrando os loci de UCEs
Agora que nos ja montamos nossos contigs a partir dos dados brutos de leitura, é hora de encontrar aqueles contigs que são loci UCE e remover aqueles que não são.
```bash
#primeiro voce precisa fazer o download do probeset usado no sequenciamento, recomendo salvar ele na pasta codes_and_conf
cd ..
cd 0_codes_and_conf

wget https://raw.githubusercontent.com/faircloth-lab/uce-probe-sets/master/uce-5k-probe-set/uce-5k-probes.fasta

# Agora podemos rodar a funcao "phyluce_assembly_match_contigs_to_probes"

phyluce_assembly_match_contigs_to_probes \
    --contigs /home/fernanda/Desktop/uces_analises_teste/3_assembly_spades/contigs \
    --probes /home/fernanda/Desktop/uces_analises_teste/0_codes_and_conf/uce-5k-probes.fasta \
    --output /home/fernanda/Desktop/uces_analises_teste/4_UCE_search \
    --log-path /home/fernanda/Desktop/uces_analises_teste/log_aula
```
# SNP calling
Agora podemos iniciar o processo de extracao de SNPs de fato, se voce possuia dados de varias especies de diferentes projetos, agora e o momento de separar por especie ou por grupo de especies
```bash
#primeiro vamos criar uma pasta para o processo de SNP calling
cd ..
mkdir 5_SNP_calling

# Dentro desta pasta, vamos criar uma pasta para o grupo de especies que vamos trabalhar
cd 5_SNP_calling
mkdir Xiphocolaptes
cd Xiphocolaptes
```
# 5. Extracting UCE loci

Agora que localizamos os loci de UCE, precisamos determinar quais taxons queremos em nossa analise, criar uma lista desses táxons e, então, gerar uma lista de quais loci UCE enriquecemos em cada taxon (o “arquivo de configuração da matriz de dados”). Usaremos então essa lista para extrair dados FASTA para cada táxon para cada locus UCE.
```bash
# O arquivo de configuracao deve ter o seguinte formato:
[xiphoc]
SDB692_Xip_alb_MCNA-6076_BR_MG
SDB693_Xip_alb_LOMO-187_BR_BA
SDB694_Xip_alb_LOMO-191_BR_BA

# forma simples de criar essa lista:
#vai ate a pasta do assembly
cd ..
cd ..
cd 3_assembly_spades
# pode modemos salvar o nome das pastas em um arquivo de texto
ls | awk '{print}' > /home/fernanda/Desktop/uces_analises_teste/0_codes_and_conf/dataset_xiphoc.conf

# podemos editar esse arquivo inserindo o nome desse taxon set no inico [xiphoc] e apagando o nome contigs
cd ..
cd 0_codes_and_conf/
nano dataset_xiphoc.conf

# voltando para a pasta dos SNPs
cd /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes

# 5.1. create the data matrix configuration file:

phyluce_assembly_get_match_counts \
    --locus-db /home/fernanda/Desktop/uces_analises_teste/4_UCE_search/probe.matches.sqlite \
    --taxon-list-config /home/fernanda/Desktop/uces_analises_teste/0_codes_and_conf/dataset_xiphoc.conf \
    --taxon-group 'xiphoc' \
    --incomplete-matrix \
    --output /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/xiphoc_snps_incomp.conf

# 5.2. Agora nos precisamos extrair o arquivo fasta que corresponde aos loci de UCEs presentes no arquivo de configuracao que acabamos de criar

phyluce_assembly_get_fastas_from_match_counts \
    --contigs /home/fernanda/Desktop/uces_analises_teste/3_assembly_spades/contigs \
    --locus-db /home/fernanda/Desktop/uces_analises_teste/4_UCE_search/probe.matches.sqlite \
    --match-count-output /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/xiphoc_snps_incomp.conf \
    --output /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/xiphoc_snps_incomp.fasta \
    --incomplete-matrix /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/xiphoc_snps_incomp.incomplete \
    --log-path /home/fernanda/Desktop/uces_analises_teste/log_aula


# 5.3. Exploding the monolithic FASTA file

# O arquivo FASTA extraido esta em um unico arquivo com todos os dados para todos os organismos, precisamos extrair por individuo

# explode the monolithic FASTA by taxon (you can also do by locus)
phyluce_assembly_explode_get_fastas_file \
    --input /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/xiphoc_snps_incomp.fasta \
    --output /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc \
    --by-taxon

# 5.4. checar a qualidade de cada amostra para escolher a referência para a extracao dos SNPs:

for i in /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/*.fasta;
do
phyluce_assembly_get_fasta_lengths --input $i --csv;
done

##resultado - copiar e colar no excel:
#samples,contigs,total bp,mean length,95 CI length,min length,max length,median legnth,contigs >1kb
#SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta,4858,4685032,964.3952243721697,2.7739901323173006,210,2146,988.0,2296
#SDB693-Xip-alb-LOMO-187-BR-BA.unaligned.fasta,4855,3638614,749.4570545829042,2.604282030388932,211,1802,760.0,347
#SDB694-Xip-alb-LOMO-191-BR-BA.unaligned.fasta,4818,4748467,985.5680780406808,3.0617763169411307,208,2234,1012.0,2544

# A amostra SDB692 tem um numero maior de contigs, alem disso, o tamanho medio dos contigs e muito maior quando comparado a segunda amostra com maior numero de contigs e, por isso, sera a referencia
```
# 6. Create the BAMs files 
Criar os arquivos BAMs fazendo um realinhamento com os clean reads
```bash
##### PROTOCOLO FEITO POR SERGIO BOLIVAR - 10/2022 #####

# para seguir, precisamos desativar o ambiente do phyluce e instalar outro ambiente (o gatk)
# desativando o phyluce
conda deactivate

# 6.1.instalando o ambiente para o gatk
# usar o arquivo .yml da pasta programs
cd ~ 
conda env create -n gatk -f /home/fernanda/Desktop/uces_analises_teste/programs/gatk-4.2.0.0/gatkcondaenv.yml

#ativar o ambiente
conda activate gatk

#instalar gatk *ver se precisa com conda list*
#conda install bioconda::gatk4

#instalar o samtools
conda install bwa samtools=1.9

## 6.2. Formatar a referencia
# criar index de samtools
bwa index /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta
#Create the reference index file.
samtools faidx /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta

#Create the reference dictionary file:
gatk --java-options "-Xmx2G" CreateSequenceDictionary --REFERENCE /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta

# precisamos criar uma pasta onde serao guardados os arquivos temporarios de cada amostra, essa pasta deve conter subpastas com o nome de cada amostra

# criando a pasta maior
cd /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes
mkdir SNPS_xiphoc_aula
cd SNPS_xiphoc_aula

# criando as subpastas com o nome das amostras, deve ser o mesmo nome da pasta clean reads, quando temos muitas amostras, podemos criar as pastas pela linha de comando da seguinte forma:

# ir ate a pasta clean reads
### importante!!! se tiver dados de varias especies, criar uma pasta separada apenas com os clean reads da especie de interesse no momento #####

cd /home/fernanda/Desktop/uces_analises_teste/2_clean_reads

#salvando o nome das pastas em um arquivo de texto dentro da pasta dos SNPs
ls | awk '{print}' > /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/list_clean_xipho_aula.txt

# voltando para a pasta dos SNPs
cd /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/SNPS_xiphoc_aula
# criando as pastas de acordo com o .txt que nos salvamos
mkdir $( tr '[,\n]' ' ' < /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/list_clean_xipho_aula.txt )
ls # checar se as pastas forma criadas

## 6.3. Criar o arquivo .SAM usando o bwa-mem - esse passo ira fazer um realinhamento com os clean reads, usando a amostra que foi escolhida como referencia

#ir ate a pasta clean reads

cd /home/fernanda/Desktop/uces_analises_teste/2_clean_reads
# rodar o bwa-mem # substitua ref e outfolder de acordo com seu path
for dir in *; do
    for r in 1.fastq.gz; do
        for j in 2.fastq.gz; do
            outfile=${dir%/}.sam
            ref="/home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta"
            glob1=split-adapter-quality-trimmed/*${r}
            glob2=split-adapter-quality-trimmed/*${j}
            out_folder=/home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/SNPS_xiphoc_aula/$(basename -- "$dir")/
            bwa mem -t 2 $ref "$dir"/$glob1 "$dir"/$glob2 > "$dir/$outfile" &&
            mv "$dir"/$outfile $out_folder
        done
    done
done 

# ~ 7min

# 6.4. Criar o arquivo .BAM para cada amostra baseado na referencia usando samtools view

# voltar para a pasta dos SNPs

cd /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/SNPS_xiphoc_aula

for dir in */; do
    for r in .sam; do
        outfile=${dir%/}.bam
        glob=*${r}
        samtools view -b -S "$dir"/$glob -o "$dir/$outfile"
    done
done

# ~ 3 min

# 6.5. Criar o sorted.BAM para cada amostra 
# samtools sort!!!
for dir in */; do
    for r in .bam; do
        outfile=${dir%/}.sorted.bam
        glob=*${r}
        samtools sort "$dir"/$glob -o "$dir/$outfile"
    done
done
# ~ 3min

# 6.6. Indexar o sorted.bam
# Criar o sorted.BAM.BAI para cada amostra usando samtools index

for dir in */; do
    for r in .sorted.bam; do
        glob=*${r}
        samtools index "$dir"/$glob
    done
done

# 6.7.  Limpeza dos arquivos .bam com CleanSam

for dir in *; do
    for r in .sorted.bam; do
        outfile=${dir%/}-CL.bam
        glob=*${r}
        gatk --java-options "-Xmx2G" CleanSam -I "$dir"/$glob -O "$dir/$outfile"
    done
done

# 6.8. Adicionar a informacao do flowcell (read group) nos bams - como as amostras vem do mesmo sequenciamento temos apenas um flowcell e podemos rodar a funcao dessa forma. Caso sejam amostras de varios sequenciamento temos que extrair o flowcell de cada amostra e rodar a funcao de outra forma (ver no final)

# para descobrir o flowcell ir ate a pasta clean reads de alguma amostra e ver o conteudo com less, o flowcell sera a sequencia de letras depois do segundo : da primeira linha - HTMKCDSXC

for dir in *; do
    for r in -CL.bam; do
        outfile=${dir%/}-CL-RG.bam
        glob=*${r} 
       gatk --java-options "-Xmx2G" AddOrReplaceReadGroups -I "$dir"/$glob -O "$dir/$outfile" --RGID "$dir" --RGLB 'Lib1' --RGPL 'illumina' --RGPU 'HTMKCDSXC' --RGSM "$dir"
    done
done

# 6.9. Agora devemos marcar as duplicatas dos arquivos bam

for dir in *; do
    for r in -CL-RG.bam; do
        glob=*${r}
        outfile=${dir%/}-CL-RG-MD.bam
        gatk --java-options "-Xmx2G" MarkDuplicatesSpark -I "$dir"/$glob -O "$dir/$outfile" --spark-master local[3]
    done
done
# demorou 20 min aqui

# 6.10. Fix the NM, MD, and UQ tags in a SAM/BAM/CRAM file

for dir in *; do
    for r in -RG-MD.bam; do
        glob=*${r}
        outfile=${dir%/}-CL-RG-MD-fix.bam
        ref="/home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta"
        gatk --java-options "-Xmx8G" SetNmMdAndUqTags -I "$dir"/$glob -O "$dir/$outfile" --REFERENCE_SEQUENCE $ref
    done
done

# 6.11. Indexar fix.bam que acabou de ser criado

for dir in *; do
    for r in -MD-fix.bam; do
        glob=*${r}
        outfile=${dir%/}-CL-RG-MD-fix.bai
        gatk --java-options "-Xmx6G" BuildBamIndex -I "$dir"/$glob -O "$dir/$outfile"
    done
done
```
# 7. SNP calling !!!!
```bash
# 7.1. Juntar os arquivos bam de todos os individuos

##### reunir todos os fix.bam en una pasta separada:
mkdir fix_bams_xiphoc_aula
#copiar apenas os arquivos *-fix.bam" para essa pasta
find -type f -name "*-fix.bam" -exec cp "{}" /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/SNPS_xiphoc_aula/fix_bams_xiphoc_aula \;
# ir para a pasta fix_bam
cd /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/SNPS_xiphoc_aula/fix_bams_xiphoc_aula
ls
# para salvar o nome dos arquivos que serao usado no prox. passo
ls  >../bam_xiphoc_aula.txt 

# 7.2. Juntar todos os arquivos bam em 1 
gatk --java-options "-Xmx8G" MergeSamFiles \
I=SDB692_Xip_alb_MCNA-6076_BR_MG-CL-RG-MD-fix.bam \
I=SDB693_Xip_alb_LOMO-187_BR_BA-CL-RG-MD-fix.bam \
I=SDB694_Xip_alb_LOMO-191_BR_BA-CL-RG-MD-fix.bam \
SO=coordinate AS=true VALIDATION_STRINGENCY=SILENT \
O=/home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/SNPS_xiphoc_aula/merged-bam.bam

# 7.3. indexing merged bam
cd ..
samtools index merged-bam.bam

# A partir desse passo precisamos rodar funcoes que so estao disponiveis no GATK 3.8, por isso, vamos usar o caminho do gatk 3.8 que vou passar para voces

# 7.4.RealignerTargetCreator (Determining (small) suspicious intervals which are likely in need of realignment)

java -Xmx6g -jar /home/fernanda/GenomeAnalysisTK-3.8-1-0/GenomeAnalysisTK.jar \
  -T RealignerTargetCreator \
  -R /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta \
  -I merged-bam.bam \
  --minReadsAtLocus 4 -o merged.intervals

# 7.5. Indel Realigner - Brant correction (Running the realigner over those intervals)
java -Xmx6g -jar /home/fernanda/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta \
-I merged-bam.bam \
-targetIntervals merged.intervals \
-LOD 3.0 \
-rf NotPrimaryAlignment \
-o merged_realigned.bam

## esse demora bastante

# 7.6. Unified Genotyper- This tool uses a Bayesian genotype likelihood model to estimate simultaneously the most likely genotypes and allele frequency in #a population of N samples, emitting a genotype for each sample. The system can either emit just the variant sites or complete #genotypes (which includes homozygous reference calls) satisfying some phred-scaled confidence value.
java -Xmx6g -jar /home/fernanda/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
-T UnifiedGenotyper \
-R /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta \
-I merged_realigned.bam \
-gt_mode DISCOVERY \
-stand_call_conf 30 \
-o rawSNPS_Q30.vcf

# 7.7. Variant Annotator -This tool is designed to annotate variant calls based on their context (as opposed to functional annotation).

java -Xmx6g -jar /home/fernanda/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
-T VariantAnnotator \
-R /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta \
-I merged_realigned.bam \
-G StandardAnnotation \
-V:variant,VCF rawSNPS_Q30.vcf \
-XA SnpEff \
-o rawSNPS_Q30_annotated.vcf

# 7.8. Call indels
java -Xmx6g -jar /home/fernanda/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
-T UnifiedGenotyper \
-R /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta \
-I merged_realigned.bam \
-gt_mode DISCOVERY \
-glm INDEL \
-stand_call_conf 30 \
-o inDels_Q30.vcf

# 7.9. Filter SNP calls around indels (note, this is pretty conservative).
java -Xmx6g -jar /home/fernanda/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
-T VariantFiltration \
-R /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta \
-V rawSNPS_Q30_annotated.vcf \
--mask inDels_Q30.vcf \
--maskExtension 5 \
--maskName InDel \
--clusterWindowSize 10 \
--filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" \
--filterName "BadValidation" \
--filterExpression "QUAL < 30.0" \
--filterName "LowQual" \
--filterExpression "QD < 5.0" \
--filterName "LowVQCBD" \
-o Q30_SNPs.vcf

#7.10.Phasing - The output of this step is a .vcf file containing the final set of phased SNPs for all individuals. This can then be used to produce input files for SNP-based analyses. 

java -Xmx6g -jar /home/fernanda/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
-T ReadBackedPhasing \
-R /home/fernanda/Desktop/uces_analises_teste/5_SNP_calling/Xiphocolaptes/exploded-fastas-xiphoc/SDB692-Xip-alb-MCNA-6076-BR-MG.unaligned.fasta \
-I merged_realigned.bam \
--variant Q30_SNPs.vcf \
-L Q30_SNPs.vcf \
-o xhiphoc_snps_total_raw.vcf \
--phaseQualityThresh 20.0 \
-rf BadCigar

# ver quantos snps temos:
vcftools --vcf xhiphoc_snps_total_raw.vcf
````
# Script para quando temos varios flowcells diferentes
```bash
# extrair os flowcell dos clean-reads
# aqui, depois de extrai-los, se elimina o texto que sobra e deixa somente o flowcell.txt dentro de cada pasta
cd /media/fernanda/BOCALINI_HD/Part3_UCEs_2023/7_SNPs_extraction_pt3/Conopophaga/clean_reads_cono
for dir in *; do
    for r in -READ1.fastq.gz; do
        outfile=${dir%/}.flowcell
        glob=split-adapter-quality-trimmed/*${r}
       zcat "$dir"/$glob | sed -n '1p' > "$dir/$outfile"
    done
done
#
cd /media/fernanda/BOCALINI_HD/Part3_UCEs_2023/7_SNPs_extraction_pt3/Conopophaga/SNPS_cono_incomp_Z
for dir in *; do
    for r in -CL.bam; do
        outfile=${dir%/}-CL-RG.bam
        glob=*${r}
        flowcell=$(find $dir -type f -name '*.flowcell')
        code_flowcell=$(head -n1 $flowcell)
        gatk --java-options "-Xmx8G"  AddOrReplaceReadGroups -I "$dir"/$glob -O "$dir/$outfile" --RGID "$dir" --RGLB 'Lib1' --RGPL 'illumina' --RGPU $code_flowcell --RGSM "$dir"
    done
done
````









