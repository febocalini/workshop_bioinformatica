### Criando um ambiente do conda para EEMS - unica forma de funcionar no cluster

#criando o ambiente
conda create -n eems_env python=3.9
conda activate eems_env

#Instalar Dependências
#Instale o Boost e o Eigen dentro do ambiente Conda:

conda install -c conda-forge boost eigen

#Verifique os caminhos das bibliotecas:

python -c "import boost; print(boost.__file__)"

#Caso precise de um compilador, instale o GCC no Conda (precisa, vai aparecer None)

conda install -c conda-forge gxx_linux-64


# Baixar e Compilar o EEMS
# Clone o repositório e entre no diretório:

git clone https://github.com/dipetkov/eems.git
cd eems/runeems_snps/src


#Agora, edite o Makefile para apontar para o Conda:

nano Makefile
#abra o Makefile substitua esses caminhos:

EIGEN_INC = $(CONDA_PREFIX)/include/eigen3
BOOST_INC = $(CONDA_PREFIX)/include
BOOST_LIB = $(CONDA_PREFIX)/lib

#Faca um teste:

./runeems_snps



