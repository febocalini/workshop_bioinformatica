###### Comandos basicos para usar no Linux ###########

Comandos essenciais para navegar pelo sistema de arquivos
### Importante:
#Linux é case-sensitive
# ctrl shift C - copia dentro do terminal
# ctrl shift V - cola dentro do terminal
# NUNCA USAR ESPAÇO OU ACENTO EM NOMES DE PASTAS OU ARQUIVOS!!
# tab - autocompleta nome de arquivos/pastas e comandos

#### pwd (print working directory): Mostra o diretório atual

pwd 

#### ls (list): Lista arquivos e diretórios ######

ls

ls -lhas ##lista arquivos em ordem alfabética
ls -lts ## lista arquivos por data de modificação
ls -R # lista o conteudo de um diretorio e de seus subdiretórios

#### cd (change directory): Muda para outro diretório.
cd /home/Fernanda/Documents
cd .. ## volta para o diretótio anterior

#### mkdir (make directory): Cria um novo diretório

mkdir minha_pasta
mkdir minha_pasta2 minha_pasta3 ## pode criar varios ao mesmo tempo

#### Vamos testar

cd minha_pasta

pwd

ls

#### editores de texto em linux

## nano - edita texto texto somente no terminal - usado no cluster

nano arquivo1.txt   #irá criar um arquivo de texto em branco e vai abrir o programa para editar

# escreva Hello world! salve e feche o programa

#vamos ver se o arquivo esta la
ls

## vamos ver o conteudo desse arquivo
cat arquivo1.txt

### Outras formas 

less #lista conteúdo de um arquivo por pags

more #lista o conteúdoce um arquivo aos poucos (apertar espaço para continuar lendo)

head #mostra apenas começo, como por exemplo com head -10 a.txt, ou usado como filtro 
        #para mostrar apenas os primeiros x resultados de outro comando

tail #mostra apenas final

### cp - copiando um arquivo

cp arquivo1.txt /caminho/destino/

cp arquivo1.txt /minha_pasta2

### rm - apagando um arquivo

cd minha_pasta2
rm arquivo1.txt

## se quiser remover uma pasta

cd ..
rm -r minha_pasta3

#### touch cria arquivos vazios
touch test1.txt test2.txt test3.txt

#### mv -  mover um arquivo para outra pasta (igual ao cp)

mv test1.txt /minha_pasta2

#### gedit - editor de texto do linux com interface gráfica

gedit test1.txt ### vai abrir o programa e vc pode editar

### Redirecionamento e Pipe

#Redirecionamento de saída
    # > Redireciona a saída para um arquivo (substitui o conteúdo)
echo "texto" > test1.txt
    # >>: Redireciona a saída para um arquivo (acrescenta ao final).
echo "mais texto" >> test1.txt

#Pipe (`|`): Encaminha a saída de um comando para outro.
ls | wc -l #vai contar o numero do seu diretorio

#### vamos esses comandos com as sequencias

cd /.../workshop_bioinformatica/uces_analise_teste/1_raw_reads

pwd

ls

ls -lts

ls -lhas

ls | wc -l

less Rapid...  #apertar q para sair do less 

### copiar uma sequencia para outra pasta
cp  Rapid.. /.../workshop_bioinformatica/uces_analise_teste

cp Rapid.. .. #se quiser copiar para pasta anterir basta inserir ..

## agora vamos para pasta anterior e apagar esses arquivos
cd ..
rm Rapid.. Rapid.. #popde colocar 2 arquivos de uma vez

# vamos voltar para a pasta das sequencias
cd 1_raw_reads

## as sequencias estao em  fastq.gz, ou seja, estao zipadas, vamos descomprir uma delas
gunzip Rapid..

#se quiser descomprimir todas as sequencias das pasta
gunzip *fastq.gz ##não rodar agora porque pode demorar

## vamos checar se o arquivo foi realmente descomprimido
ls *fastq

# vamos ver o conteudo do arquivo:
more Rapid..fastq  #espaço para continuar vendo o arquivo e q para sair

cat Rapid...fastq  #vai abrir o arquivo todo de uma vez para parar digitar "ctrl c" no terminal

head Rapid...fastq #vai mostrar só as primeiras linhas do arquivo

head -10 ##vai mostrar as 10 primeiras linhas do arquivo

tail Rapid...fastq #vai abrir só as ultimas linhas do arquivo
## como mostrar as 3 ultimas linhas?

### grep - vai buscar padrões especificos no seu arquivo
grep "ATG" Rapid..    #vai buscar sempre que aparecer ATG no arquivo", digitar "ctrl" c para parar
grep -c "ATG" Rapid.. #contar quantas vezes aparece ATG no arquivo
grep -c "^@" Rapid...  #contar quantas linhas começam com @ - isso é ao numero de reads da amostra

####grep possui varias outras possibilidades para ver todas usar o comando "man" - vai mostrar o manual dessa funçao

man grep
man ls

### o -help vai mostrar todas as opçoes de um comando
grep --help

#### agora precisamos comprimir essa sequencia novamente (o programa que vamos usar só aceita no formato fastq.gz)

gzip Rapid...

### checar se funcionou 
ls *.fastq

### Scripts em Bash
# Um script em Bash é um arquivo de texto que contém uma sequência de comandos que podem ser executados automaticamente. 
# Em vez de digitar um comando de cada vez no terminal, você pode agrupar comandos em um script para automatizar tarefas.

### Criando um Script Bash
# 1: Criar o arquivo

nano meu_script.sh

#2: Escrever o script

#Adicione os seguintes comandos:

#!/bin/bash
echo "Este é o meu primeiro script!"

#A linha #!/bin/bash é o shebang e indica que o script deve ser executado no Bash

#3: Tornar o script executável

#Para rodar o script, você precisa torná-lo executável usando o comando chmod:

chmod +x meu_script.sh

#4: Executar o script

./meu_script.sh

# Use '>' para salvar o output em um arquivo separado
./meu_script.sh >stdout.txt 

# Use '2>' para salvar o erro em aquivo separado 
./meu_script.sh >stdout.txt 2>stderr.txt

## Como ver o que foi salvo em stdout.txt?


##### Como instalar e gerenciar pacotes no Ubuntu?

# para instalar e gerenciar pacotes e programas no Ubuntu usamos:
sudo apt-get 

# usa-se sudo para executar comandos com privilégios de administrador (root) 
# Como a instalação de pacotes afeta o sistema, é necessário ter permissões de superusuário
sudo apt-get install vim
#vim é um editor de texto como o nano (nao usem! é muito dificil!)

sudo apt-get install tree

#tree é um pacote parecido com ls, mas ele mostra todos os conteúdos de subdiretóios, o que vai ser importante no processo de SNPcalling

sudo apt-get install git
# git é um pacote utilizado para mexer com arquivos do github

#Remover Pacotes:
sudo apt-get remove vim

# Atualizar a Lista de Pacotes

sudo apt-get update

#











 





