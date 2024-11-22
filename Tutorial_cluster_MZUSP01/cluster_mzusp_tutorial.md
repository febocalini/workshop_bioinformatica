
## Usando o cluster MZUSP
IMPORTANTE: Antes de começar a usar o cluster leia atentatamente o manual com todas as regras de utilização

### O que é SSH?
SSH é um protocolo que permite a conexão segura e encriptada com um servidor remoto. Ele é amplamente utilizado para acessar clusters de computação, servidores em nuvem e sistemas de computação de alto desempenho (HPC).

### 1. Abrindo o Terminal

- Abra o **Terminal**.

### 2. Comando Básico de SSH
O comando básico para se conectar a um servidor é:
```bash
ssh usuario@hostname
```

- **usuario**: seu nome de usuário no servidor remoto.
- **hostname**: o endereço do servidor (pode ser um endereço IP ou um nome de domínio).

**Exemplo**:
````bash
# No caso do cluster do MZUSP o acesso é feito em duas etapas para maior segurança:
# 1) Acesso do seu computador ao gatekeeper:

ssh -X fernanda@143.107.38.43

#IMPORTANTE: a senha deve ser sempre digitada e não colada com ctrl v

# 2) Uma vez dentro do gatekeeper, agora sim voce poderá acessaro cluster de fato:

ssh -X fernanda@192.168.34.2

````

### 3. Primeira Conexão
Na primeira vez que você se conectar a um servidor específico, o SSH irá perguntar se você deseja confiar na chave de autenticação do servidor. Você verá uma mensagem como esta:
```
The authenticity of host 'meuservidor.com (192.168.0.100)' can't be established.
Are you sure you want to continue connecting (yes/no)?
```
Digite **yes** e pressione Enter. A chave do servidor será adicionada ao seu arquivo de **known_hosts**.

### 4. Inserindo a Senha
Após isso, você será solicitado a inserir a sua senha. Digite a senha (ela não será exibida no terminal) e pressione Enter. Se a senha estiver correta, você será conectado ao servidor.


### 7. Fechando a Conexão
Para sair do servidor remoto, digite:
```bash
exit
```
## Transferência de arquivos: usar os comandos `scp` ou `rsync`


### **1. Usando `scp` (Secure Copy Protocol)**

O `scp` é uma ferramenta simples para transferir arquivos de forma segura.

### Sintaxe Básica
```bash
scp [opções] fonte destino
```

#### Exemplos Práticos

##### 1.1 Transferir um único arquivo para o cluster:
```bash
# 1. enviar para o gatekeeper
scp /home/fernanda/meu_arquivo.txt fernanda@143.107.38.43:/home/fernanda/TRANSFER

#IMPORTANTE: 
	# 1 - Sempre transferir para a pasta TRANSFER que fica dentro do gatekeeper
	# 2 - Sempre apagar os arquivos depois que forem transferidos porque não tem muito espaço disponível no gatekeeper

# 2. enviar do gatekeeper para o transfer:

# acessar o gatekeeper:

ssh -X fernanda@143.107.38.43

#dentro do gatekeeper rodar:

scp /home/fernanda/TRANSFER/meu_arquivo.txt fernanda@192.168.34.2:/home/fernanda/
	
```
##### 1.2 Transferir um diretório para o cluster:
Use a opção `-r` para transferir diretórios recursivamente.
```bash
# voltar para o seu computador
exit
logout
#1. Transferir para o gatekeeper: 
scp -r /home/fernanda/Desktop/uces_analises_teste/3_assembly_spades fernanda@143.107.38.43:/home/fernanda/TRANSFER

#2. Acessar o gatekeeper:
ssh -X fernanda@143.107.38.43

#3. Transferir do gatekeeper para o cluster:
scp -r /home/fernanda/TRANSFER/3_assembly_spades fernanda@192.168.34.2:/home/fernanda/

```

##### 1.3 Transferir arquivos do cluster para sua máquina local:
```bash
#1. Ir até o gatekeeper
exit
#2. Tranferir do cluster para o gatekeeper (dentro da pasta TRANSFER)

scp fernanda@192.168.34.2:/home/fernanda/meu_arquivo.txt /home/fernanda/TRANSFER

## Outra forma mais fácil de transferir:
# No gatekeeper vá até a pasta TRANSFER - local para onde você quer que o arquivo seja transferidos
cd TRANSFER
scp fernanda@192.168.34.2:/home/fernanda/meu_arquivo.txt .

# o . no final significa que você quer que o arquivo seja transferido exatamente para o local onde você está agora

# 3. Tranferir do gatekeeper para o seu computador

# saia do gatekeeper
logout
# vá até a pasta para onde você quer queo arquivo seja transferido no seu computador
cd /home/fernanda/Desktop/uces_analises_teste
# transfira o arquivo
scp fernanda@143.107.38.43:/home/fernanda/TRANSFER/meu_arquivo.txt .
#ou
scp fernanda@143.107.38.43:/home/fernanda/TRANSFER/meu_arquivo.txt /home/fernanda/Desktop/uces_analises_teste

```

## **2. Usando `rsync`**

O `rsync` é uma ferramenta poderosa que permite sincronizar arquivos e diretórios de forma eficiente. Ele transfere apenas as partes dos arquivos que mudaram, otimizando o processo.

Quando você estiver transferindo uma pasta com muitos arquivos pesados é preferível usar o `rsync` porque se a conexão cair no meio do processo (o que no museu acontece muito), quando você digitar o comando novamente ele irá coemçar de onde parou e sincronizar os arquivos.
### Sintaxe Básica
```bash
#1. Transferir para o gatekeeper: 
rsync -a -P /home/fernanda/Desktop/uces_analises_teste/3_assembly_spades fernanda@143.107.38.43:/home/fernanda/TRANSFER

#2. Acessar o gatekeeper:
ssh -X fernanda@143.107.38.43

#3. Transferir do gatekeeper para o cluster:
rsync -a -P /home/fernanda/TRANSFER/3_assembly_spades fernanda@192.168.34.2:/home/fernanda/
````
### Significado das opções usadas:
- **`-a`**: Modo de arquivamento (preserva permissões, datas e links simbólicos).
- **`-P`**: -P (progress + partial), combinação de:
	- **--progress**: Exibe o progresso detalhado da transferência, como percentual, taxa de transferência e tempo estimado.
	- **--partial**: Permite retomar transferências interrompidas sem perder o progresso já realizado.

##### Algumas regras para transferir diretórios (pastas inteiras):

- **Sem barra final:** Copia o diretório inteiro.
    ```bash
    rsync -r meu_diretorio user@cluster-endereco.com:/caminho/destino/
    ```
- **Com barra final:** Copia apenas o conteúdo do diretório.
    ```bash
    rsync -r meu_diretorio/ user@cluster-endereco.com:/caminho/destino/
    ```

---

