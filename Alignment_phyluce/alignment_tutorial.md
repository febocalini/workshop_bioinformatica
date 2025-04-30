# Tutorial - Alinhamento das sequências de UCEs usando o phyluce para rodar os programas RAxMl, IQTree, Astral e GPhoCs 

#### Tutorial adaptado do Phyluce: https://phyluce.readthedocs.io/en/latest/tutorials/tutorial-1.html
```bash
## criar um diretorio para guardar as pastas dos alinhamentos
mkdir /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium
# ir ate esse diretorio
cd /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium

#activate phyluce
source activate phyluce-1.7.3
```

# 1.Create the data matrix configuration file 
- aqui pode ser o mesmo criado durante o processo SNP calling, mas prestar atenção se ele inclui todos os taxons que são necessários nas analises filogenéticas (outgroups) - lembre-se que se voce removeu alguma amostra com o snpfiltR por estar errada ou muito ruim voce deve remove-la agora tambem.
```bash
phyluce_assembly_get_match_counts \
    --locus-db /media/fernanda/KINGSTON/2024_UCEs_USP183203/4_UCEsearch_glauc_UCEs24/probe.matches.sqlite \
    --taxon-list-config /media/fernanda/KINGSTON/2024_UCEs_USP183203/0_codes_and_conf_UCEs24/dataset_glaucidium.conf \
    --taxon-group 'glauci_tree' \
    --incomplete-matrix \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/glaucidium_align_incomp.conf

#There are  5041 UCE loci in an INCOMPLETE matrix
#14 taxa
```
# 2.Extracting FASTA data using the data matrix configuration file
```bash
phyluce_assembly_get_fastas_from_match_counts \
    --contigs /home/fernanda/Desktop/3_glauc_assembly_UCEs24/contigs \
    --locus-db /media/fernanda/KINGSTON/2024_UCEs_USP183203/4_UCEsearch_glauc_UCEs24/probe.matches.sqlite \
    --match-count-output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/glaucidium_align_incomp.conf \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/glaucidium_align_incomp.fasta \
    --incomplete-matrix /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/glaucidium_align_incomp.incomplete \
    --log-path /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24
```

# 3. Align the data - turn off trimming and output FASTA 
```bash

#### ATENÇÃO: substitua o argumento --taxa pelo número de amostras que você tem!!!
phyluce_align_seqcap_align \
    --input /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/glaucidium_align_incomp.fasta \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-fasta-glauci \
    --taxa 14 \
    --aligner mafft \
    --cores 4 \
    --incomplete-matrix \
    --output-format fasta \
    --no-trim \
    --log-path /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24

#Now, we are going to trim these loci using Gblocks:
```
# 4. Run gblocks trimming on the alignments 
- antes de rodar as analises filogeneticas precisamos limpar as regioes do alinhamento de baixa qualidade
```bash
phyluce_align_get_gblocks_trimmed_alignments_from_untrimmed \
    --alignments /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-fasta-glauci  \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci \
    --cores 3 \
    --log /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24
```
# 5. Alignments Summary stats 
We can output summary stats for these alignments by running the following program: 
- passo importante para observar a quantidade de alinhamentos em cada matriz com diferentes proporporções de missing data, assim pode-se escolher quais porcentagens serão usadas nos proximos passos
```bash
phyluce_align_get_align_summary_data \
    --alignments /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci \
    --cores 3 \
    --log-path /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24

#resultados:
#[Matrix 50%]		3287 alignments
#[Matrix 55%]		2301 alignments
#[Matrix 60%]		2277 alignments
#[Matrix 65%]		2277 alignments
#[Matrix 70%]		2247 alignments
#[Matrix 75%]		2195 alignments
#[Matrix 80%]		2084 alignments
#[Matrix 85%]		2084 alignments
#[Matrix 90%]		1802 alignments
#[Matrix 95%]		967 alignments
# Vamos usar as matrizes de 75% e 95%
``` 

# 6.1. Filtrar a matriz 75% completa
```bash
phyluce_align_get_only_loci_with_min_taxa \
    --alignments /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci \
    --taxa 14 \
    --percent 0.75 \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-75p \
    --cores 3 \
    --log-path /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24
```

# 6.2. Filtrar a matriz 95% completa
```bash
phyluce_align_get_only_loci_with_min_taxa \
    --alignments /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci \
    --taxa 14 \
    --percent 0.95 \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-95p \
    --cores 3 \
    --log-path /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24
```

# 8. Clean  
- Each sequence line in the alignments contains beside the genus_species designator the name of the locus. Since we have separate alignments now, each containing the locus information in its name (locus1.nexus etc.) we want to remove the locus name from each sequence line within these alignments, to reserve the option to later concatenate some or all of the loci. To remove the locus information from each sequence line, run the following command:
```bash

# 8.1 - Clean 75% matrix
phyluce_align_remove_locus_name_from_files \
    --alignments /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-75p \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-75p-clean \
    --cores 2 \
    --log-path  /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24


# 8.2 - Clean 95% matrix
phyluce_align_remove_locus_name_from_files \
    --alignments /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-95p \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-95p-clean \
    --cores 2 \
    --log-path  /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24
```

# Preparing data for downstream analysis
## 9. Matriz concatenada para RaxML
```bash
# build the concatenated data matrix - 75%
phyluce_align_concatenate_alignments \
    --alignments /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-75p-clean \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-75p-clean-raxml \
    --phylip \
    --log-path /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24

# build the concatenated data matrix - 95%
phyluce_align_concatenate_alignments \
    --alignments /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-95p-clean \
    --output /media/fernanda/KINGSTON/2024_UCEs_USP183203/7_alignments/Glaucidium/mafft-nexus-gbl-glauci-95p-clean-raxml \
    --phylip \
    --log-path /media/fernanda/KINGSTON/2024_UCEs_USP183203/logs_uces24

### enviar para o cluster somente essa pasta do raxml e o pbs para rodar o codigo do programa
````

