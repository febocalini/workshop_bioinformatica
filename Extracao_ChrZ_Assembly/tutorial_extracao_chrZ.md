# 🧬 Extração de Contigs do Cromossomo Z — UCEs

Este tutorial descreve como preparar e identificar contigs do cromossomo Z a partir de assemblies de UCEs utilizando ferramentas como `blastn` em ambiente Conda.

## ⚠️ Pré-requisitos

- Conda instalado
- BLAST+ instalado
- Dados de referência do cromossomo Z disponíveis em: https://github.com/febocalini/workshop_bioinformatica/tree/main/Extracao_ChrZ_Assembly/db

## 🐍 Criar ambiente Conda com Python 2.7

> Os scripts requerem Python 2.7, que **não é compatível com Python 3**.

Execute o seguinte comando para criar o ambiente:

```bash
conda create -n py27 python=2.7
```

Depois, ative o ambiente com:

```bash
conda activate py27
```

## 🔧 Passo a Passo

### 1. Ative o ambiente Conda

```bash
conda activate py27
```

### 2. Prepare o diretório de trabalho

Crie uma nova pasta fora da pasta original do assembly para evitar sobrescritas indesejadas:

```bash
cd /home/fernanda/Desktop/Zextraction_Prim_UCEs24/3_prim_assembly_UCEs24
```

> Certifique-se de copiar os arquivos necessários para essa nova pasta.

### 3. Limpe o diretório

Remova a pasta `contigs` antiga, caso exista:

```bash
rm -r contigs
```

### 4. Renomeie os arquivos `contigs.fasta`

Cada diretório terá seu arquivo `contigs.fasta` renomeado com o nome da amostra como prefixo:

```bash
for dir in *; do
    for r in contigs; do
        outfile=${dir%}.contigs.fasta
        glob=${r}.fasta
        mv "$dir"/$glob "$dir/$outfile"
    done
done
```

### 5. Rode o BLAST contra a referência do cromossomo Z

Utilize a referência do cromossomo Z para identificar os contigs relevantes em cada amostra
Db disponivel em:

```bash
for dir in */; do
    for r in contigs.fasta; do
        outfile=${dir%/}.blastout
        glob=*.${r}
        dbase="/home/fernanda/Desktop/db/tgu_ref_Taeniopygia_guttata-3.2.4_chrZ.fa"
        blastn -query "$dir"/$glob -db $dbase -out "$dir/$outfile"
    done
done
```


### 6. Retirar as sequencias de matches dos FASTAS originais
```bash
for dir in */; do
    for r in blastout; do
        outfile=${dir%/}.blastout_list_contigs
        glob=*.${r}
        sed 's/\t[^/]*$//g' "$dir"/$glob > "$dir/$outfile"
    done
done
```

### 7. Adicionar a funcao 'grep' a cada linha da lista dos contigs

```bash
for dir in */; do
    for r in blastout_list_contigs; do
        outfile=${dir%/}_scriptmatches.sh
        glob=*.${r}
        sed -r 's/^/grep /g' "$dir"/$glob > "$dir/$outfile"
    done
done
```
### 8. Inserir no nome da amostra a cada linha 

```bash
for dir in */; do
    for r in _scriptmatches; do
        outfile=${dir%/}_scriptmatches.sh
        glob=*.${r}
        path=${dir%/}
        sed -i -r "s/$/ $path.contigs.tab >> $path.Z_matches.tab /g" "$dir/$outfile"
    done
done
```

### 9. Transforma arquivos FASTA em tabular (um por linha, mais fácil de gerenciar), funcao dentro da pasta db https://github.com/febocalini/workshop_bioinformatica/tree/main/Extracao_ChrZ_Assembly/db

```bash
for dir in */; do
    for r in .contigs.fasta; do
        outfile=${dir%/}.contigs.tab
        glob=*${r}
        soft="/home/fernanda/Desktop/db/fasta_to_tabular.py"
        python $soft "$dir"/$glob "$dir/$outfile" 0 1
    done
done
```
### 10. Rodar o script para retirar as sequencias do FASTA

```bash
for x in $(find */ -type f -name "*_scriptmatches.sh"); do
    chmod +x ${x} 
done
```
### 11. Rodar o '.sh' em cada subdiretorio

```bash
find . -name "*_scriptmatches.sh" -type f -execdir {} '&' \; 
```
### 12. Reter apenas as sequencias únicas

```bash
for x in $(find */ -type f -name "*.Z_matches.tab"); do
    sort -u ${x} -o ${x}
done
```
### 13. Transformar os Z-linked de volta para '.fasta' 

```bash
#Volta arquivos tabular para formato FASTA dos contigs extraidos!!!!!
for dir in *; do
    for r in Z_matches.tab; do
        outfile=${dir%/}.Z_matches.contigs.fasta
        glob=*${r}
        soft="/home/fernanda/Desktop/db/tabular_to_fasta.py"
        python $soft "$dir"/$glob 1 0 "$dir/$outfile"
    done
done
```
### 14. Extrair os nomes dos contigs que deram macth com Z-linked

```bash
for dir in */; do
    for r in Z_matches.tab; do
        outfile=${dir%/}.list_Z_uces.txt
        glob=*.${r}
        awk '{ print $1 }' "$dir"/$glob > "$dir/$outfile"
    done
done
```

### 15. Extrair dos contigs.tab original os contigs Z-linked

```bash
for dir in */; do
    for r in list_Z_uces.txt; do
        outfile=${dir%/}_no_Z.contigs.tab
        glob=*.${r}
        glob2=*.contigs.tab
        grep -vwF -f "$dir"/$glob "$dir"/$glob2 > "$dir/$outfile"
    done
done
```


### 16. Voltar os arquivos tabular para o foramato fasta dos contigs extraidos

```bash
for dir in */; do
    for r in _no_Z.contigs.tab; do
        outfile=${dir%/}_final.contigs.fasta
        glob=*${r}
        soft="/home/fernanda/Desktop/db/tabular_to_fasta.py"
        python $soft "$dir"/$glob 1 0 "$dir/$outfile"
    done
done
```
### 17. Mudar o nome para contigs.fasta, para não alterar o fluxo dos outros scripts
```bash
for f in $(find */ -type f -name "*_final.contigs.fasta"); do
    mv "$f" "$(dirname "$f")/contigs.fasta"; 
done
```

### 18. Eliminar os arquivos temporários!
```bash
find . \( -name '*_scriptmatches.sh' -or -name '*.blastout*' -or -name '*list*' -or -name '*.contigs.tab*' -or -name '*.Z_matches.tab' \) -type f -delete
```

### 19. Criar os symlinks da pasta assembly
```bash
cd /home/fernanda/Desktop/Zextraction_Prim_UCEs24/3_prim_assembly_UCEs24
mkdir contigs

for dir in *; do
    for r in contigs.fasta; do
        outfile=${dir%/}.contigs.fasta
        glob=${r}
        ln -s "/home/fernanda/Desktop/Zextraction_Prim_UCEs24/3_prim_assembly_UCEs24/$dir"/$glob contigs/"$outfile"
    done
done

conda deactivate
```
