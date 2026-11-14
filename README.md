# Curso de SQL

Repositório dedicado ao aprendizado e à prática de **SQL (Structured Query Language)**, reunindo materiais de estudo, scripts, exercícios e atividades desenvolvidas ao longo de um curso de banco de dados.

O projeto tem como objetivo consolidar conhecimentos em SQL, desde os conceitos fundamentais até a aplicação prática em operações de manipulação e consulta de dados.

## Objetivos

- Desenvolver conhecimentos em SQL e bancos de dados relacionais.
- Aprender a criar e estruturar tabelas.
- Praticar consultas e manipulação de dados.
- Compreender a utilização de comandos SQL em cenários práticos.
- Desenvolver habilidades para trabalhar com bancos de dados, especialmente no contexto de Engenharia de Dados.

## Tecnologias utilizadas

- **SQL:** linguagem utilizada para definição, consulta e manipulação de dados.
- **PostgreSQL 13.2:** sistema gerenciador de banco de dados relacional utilizado no ambiente de estudos.
- **Docker Compose:** para subir o banco de dados
- **DBeaver / pqAdmin:** para rodar os scripts de SQL

## Estrutura do repositório

```text
Curso_de_sql/
│
├── Aulas/
│   └── Materiais e conteúdos das aulas
│
├── Dados/
│   └── Arquivos e dados utilizados nas atividades
│
├── DDL das Tabelas/
│   └── Scripts de definição e criação de tabelas
│
├── Exercícios/
│   └── Exercícios práticos de SQL
│
├── postgres/
│   └── Arquivos relacionados ao PostgreSQL
│
├── Projeto Final/
│   └── Arquivos e scripts do projeto de conclusão
│
├── LICENSE
└── README.md
```

## Assuntos por arquivos


| Arquivo | Conteúdo |
|---|---|
| `01_select_basico.sql` | SELECT, WHERE, LIKE, LIMIT |
| `02_colunas_alias_ordenacao.sql` | Colunas calculadas, ALIAS, CAST, ORDER BY |
| `03_case_when.sql` | CASE WHEN (classes por pontos) |
| `04_agregacoes.sql` | COUNT, DISTINCT, SUM, AVG, MIN, MAX |
| `05_group_by_having.sql` | GROUP BY e HAVING |
| `06_joins.sql` | JOINs |
| `07_subqueries.sql` | Subqueries |
| `08_cte.sql` | CTEs (Common Table Expressions) |
| `09_row_number_window_functions.sql` | ROW_NUMBER, SUM OVER, LAG |
| `10_ddl_dml.sql` | CREATE, DROP, TRUNCATE, INSERT, UPDATE, DELETE |
| `projeto_final.sql` | Construção da tabela `feature_store_cliente` |

## Conteúdos e atividades

O repositório está organizado para acompanhar o processo de aprendizado, contemplando:

- **Aulas:** materiais utilizados durante o curso.
- **DDL (Data Definition Language):** scripts relacionados à definição da estrutura do banco de dados.
- **Dados:** arquivos utilizados para popular e trabalhar com as tabelas.
- **Exercícios:** atividades práticas para fixação dos conhecimentos.
- **Projeto Final:** aplicação dos conhecimentos adquiridos durante o curso.

## Como utilizar

Para acessar os materiais e executar os exercícios localmente:

### Clone o repositório:

```bash
git clone https://github.com/lucasvmartins/Curso_de_sql.git
```

### 1. Subir o banco

```bash
docker-compose up -d
```

O `docker-compose.yaml` sobe um container PostgreSQL com a seguinte configuração (apenas para uso local/estudo):

| Item | Valor |
|---|---|
| Container | `curso-sql` |
| Porta | `5432` |
| Usuário | `postgres` |
| Senha | `postgres` |

### 2. Criar as tabelas

```sql
CREATE TABLE clientes (
    idCliente       VARCHAR(36),
    flEmail         INT,
    flTwitch        INT,
    flYouTube       INT,
    flBlueSky       INT,
    flInstagram     INT,
    qtdePontos      INT,
    DtCriacao       TIMESTAMP,
    DtAtualizacao   TIMESTAMP
);

CREATE TABLE produtos (
    IdProduto               VARCHAR(100),
    DescNomeProduto         VARCHAR(255),
    DescDescricaoProduto    TEXT,
    DescCategoriaProduto    VARCHAR(100)
);

CREATE TABLE transacoes (
    IdTransacao         VARCHAR(36),
    IdCliente           VARCHAR(36),
    DtCriacao           TIMESTAMP,
    QtdePontos          INT,
    DescSistemaOrigem   VARCHAR(100)
);

CREATE TABLE transacao_produto (
    idTransacaoProduto  VARCHAR(36),
    IdTransacao         VARCHAR(36),
    IdProduto           VARCHAR(100),
    QtdeProduto         INT,
    vlProduto           NUMERIC
);
```

> `IdProduto` é `VARCHAR` porque a coluna mistura números, nomes de itens e identificadores de cursos (ex.: `sql-2025`).

### 3. Carregar os dados

Os arquivos CSV usam **`;`** como delimitador e possuem cabeçalho.

**Pelo DBeaver/pgAdmin:** botão direito na tabela → **Import Data**, com *Header* ativado e delimitador `;`.

**Pela linha de comando:**

```bash
docker cp clientes.csv curso-sql:/tmp/clientes.csv
docker cp produtos.csv curso-sql:/tmp/produtos.csv
docker cp transacoes.csv curso-sql:/tmp/transacoes.csv
docker cp transacao_produto.csv curso-sql:/tmp/transacao_produto.csv
```

```sql
COPY clientes FROM '/tmp/clientes.csv' DELIMITER ';' CSV HEADER;
COPY produtos FROM '/tmp/produtos.csv' DELIMITER ';' CSV HEADER;
COPY transacoes FROM '/tmp/transacoes.csv' DELIMITER ';' CSV HEADER;
COPY transacao_produto FROM '/tmp/transacao_produto.csv' DELIMITER ';' CSV HEADER;
```

## Modelo de dados

| Tabela | Descrição |
|---|---|
| `clientes` | Cadastro dos clientes, pontos e canais vinculados (e-mail, Twitch, YouTube, BlueSky, Instagram) |
| `produtos` | Catálogo de produtos, com nome, descrição e categoria |
| `transacoes` | Transações de pontos por cliente, com data, quantidade e sistema de origem |
| `transacao_produto` | Relação entre transações e produtos, com quantidade e valor |


## Projeto final: perfil comportamental de clientes

O projeto final constrói a tabela `feature_store_cliente`, com o perfil comportamental de cada cliente:

1. Quantidade de transações (total, D7, D14, D28, D56)
2. Dias desde a última transação
3. Tempo na base
4. Produto mais usado (total, D7, D14, D28, D56)
5. Saldo de pontos atual
6. Pontos acumulados positivos (total, D7, D14, D28, D56)
7. Pontos acumulados negativos (total, D7, D14, D28, D56)
8. Dia da semana mais ativo
9. Período do dia mais ativo (manhã, tarde, noite, madrugada)
10. Engajamento em D28 em relação ao total

A consulta usa CTEs encadeadas, *window functions* (`ROW_NUMBER`) para ranquear produto, dia e período mais frequentes por cliente, e `LEFT JOIN`s para consolidar tudo em uma única linha por cliente.

## Conceitos praticados

- Filtros e ordenação (`WHERE`, `ORDER BY`, `LIMIT`, `LIKE`)
- Funções de agregação e `GROUP BY` / `HAVING`
- `CASE WHEN` para classificação e contagens condicionais
- `JOIN`s e subqueries
- CTEs para organizar consultas complexas
- Window functions: `ROW_NUMBER`, `SUM() OVER`, `LAG`
- Funções de data: `EXTRACT`, `DATE`, `TO_CHAR`, `CURRENT_DATE`
- DDL e DML: `CREATE TABLE AS`, `DROP`, `TRUNCATE`, `INSERT`, `UPDATE`, `DELETE`

## Sobre o curso

Este repositório faz parte da minha jornada de aprendizado e fixação de conhecimento na área de dados, reunindo práticas e conhecimentos desenvolvidos durante meus estudos de SQL e bancos de dados.

O objetivo é manter um histórico da minha evolução técnica, documentar os conhecimentos adquiridos e construir uma base de consulta para projetos futuros relacionados à **Análise de Dados e Engenharia de Dados**.

---

Se este repositório for útil para seus estudos, fique à vontade para explorá-lo!
