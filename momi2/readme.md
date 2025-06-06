# Tutorial Momi2

## 1. Introdução

Para entender melhor sobre o programa, leia este tutorial:  
👉 [https://radcamp.github.io/AF-Biota/07_momi2_API.html](https://radcamp.github.io/AF-Biota/07_momi2_API.html)

⚠️ **Atenção:** A instalação descrita no tutorial acima está desatualizada.  
Siga os passos abaixo para instalar corretamente o `momi2`.

---

## 2. Instalação do Momi2 com Conda

### Ambiente testado:
- Kubuntu 22.04 LTS
- Cluster CentOS Linux 7 (Core)

### Passo a passo:

```bash
#### 1. Criar um ambiente Conda com Python 3.8 ####
conda create -n momi2_py38 python=3.8
source activate momi2_py38

#### 2. Instalar o scipy 1.6.2 (última versão compatível com o momi2) ####
conda install -c anaconda scipy=1.6.2

#### 3. Instalar o momi2 via pip ####
pip install momi

#### 4. Instalar dependências adicionais ####
conda install ipyparallel jupyter -c defaults -c conda-forge -c bioconda -c jackkamm

#### 5. Ativar o ambiente e abrir o Jupyter Notebook ####
source activate momi2_py38
jupyter notebook &
```

---

## 3. Pré-processamento dos dados

### Converter VCF em BED no R:

```r
# Transformar VCF em BED
# install.packages("bedr")
library(bedr)

x <- read.vcf("prim95_unlinked.vcf.gz")
x.bed <- vcf2bed(x)

write.table(
  x.bed,
  file = "prim95_momi2.bed",
  row.names = FALSE,
  col.names = FALSE,
  quote = FALSE
)
```

---

## 4. Populações

Crie um arquivo delimitando as populações (separado por tabulação), como no exemplo disponível na pasta:  
📄 `popmap_prim.txt`

---

## 5. Execução no Jupyter Notebook

Abra o arquivo `primolius.ipynb` no Jupyter Notebook e execute os blocos de código para rodar os modelos.

---
