# Configuração de um Cluster Apache Spark com Docker

Este guia detalha como configurar um cluster Apache Spark utilizando Docker. O cluster inclui um Spark Master e múltiplos Workers, permitindo a execução de aplicações Spark distribuídas.

## Pré-requisitos

Certifique-se de ter os seguintes itens instalados:

- [Docker](https://docs.docker.com/get-docker/) (versão 20.10 ou superior)
- [Docker Compose](https://docs.docker.com/compose/install/) (versão 1.25 ou superior)

## Importante

Antes de iniciar, **lembre-se de atualizar o IP do host** onde o Spark Master será configurado nos Dockerfiles dos Workers.

## Estrutura do Projeto

Este projeto inclui os seguintes arquivos de configuração:

- `compose-host.yaml`: Arquivo Docker Compose para iniciar o Spark Master e um Worker no mesmo host.
- `compose-outside.yaml`: Arquivo Docker Compose para iniciar um Worker em outro host.

## Passo a Passo para Configuração

### 1. Iniciar o Spark Master e Worker no Host Principal

No terminal, navegue até o diretório onde está o arquivo `compose-host.yaml` e execute o comando:

```bash
docker compose -f compose-host.yaml up -d
````
Este comando irá iniciar o Spark Master e um Worker no mesmo host.

### 2. Adicionar um Worker em Outro Host

Em um segundo host, onde você deseja adicionar um Worker ao cluster, execute o comando:

```bash
docker compose -f compose-outside.yaml up -d
```
Isso adicionará um Worker ao cluster existente.

### 3. Interagir com o Cluster via Jupyter Notebook

Para interagir com o cluster a partir de um Jupyter Notebook em outro host, você deve mapear as portas ao rodar a imagem Docker:

- **7077**: Porta do Spark Master
- **4040**: Porta da Web UI do Spark
- **33139**: Porta do Driver
- **45029**: Porta do Block Manager

#### Exemplo de Comando para Rodar a Imagem Docker

```bash
docker run -p 4040:4040 -p 7077:7077 -p 33139:33139 -p 45029:45029 <imagem-do-jupyter>
```
### 4. Configuração do PySpark Driver

No Jupyter Notebook, use a seguinte configuração para conectar ao Spark Master:

```python
from pyspark.sql import SparkSession
from pyspark import SparkConf

conf = SparkConf().setMaster("spark://192.168.0.101:7077")  # Altere para o IP do seu Spark Master
conf.set("spark.executor.memory", "6g")
conf.set("spark.driver.memory", "12g")
conf.set("spark.executor.cores", "3")
conf.set("spark.driver.cores", "6")
conf.set("spark.driver.bindAddress", "0.0.0.0") # Manter, ip interno docker
conf.set('spark.driver.host', '192.168.0.210') # Altere para o ip do host do jupyter
```
