<div align="center">
<img src="img\\Score.jpg" />
</div>

## Introdução

Este é um projeto end-to-end de Data Science com um modelo de regressão. Esse modelo prevê o score de crédito de um cliente a partir de uma série de combinações já passadas e treinadas por um modelo de regressão linear. Este projeto é um combinado de aprendizados das aulas da Comunidade DS (planejamento de execução), Didatica Tech (machine learning com R) e as ideias de projeto do canal Nerd dos Dados. Esses conhecimentos unidos forneceram insumos para a execução de todas as etapas do projeto.

Obs.: É importante observar que este cenário é usado com o intuito de aprendizagem.

### Plano de desenvolvimento do projeto Data Science

O projeto foi desenvolvido com o objetivo de prever o score de crédito de clientes, com base em dados históricos, a fim de atribuir este score a novos clientes a partir do modelo criado, para facilitar essa implementação nos novos dados, será utilizada uma aplicação web.

#### Planejamento

1. Descrição do problema de negócio
2. Plano de solução
3. Modelo de Machine learning
4. Aplicação Web
5. Conclusão

_________________________________

### 1. Descrição do problema de negócio

#### 1.1 Objetivo do modelo

Previsões para determinar o score de crédito dos clientes são muito utilizadas em bancos e principalmente nos bancos digitais, quando eles vão determinar se uma pessoa pode aumentar o limite de crédito, se a pessoa tem possibilidade de fazer um empréstimo bancário e várias outras coisas. Os bancos utilizam muito esse tipo de modelo preditivo. Com isso, o objetivo é fazer a previsão do score de crédito de clientes.

#### 1.2 Problema de negócio

Visando as necessidades que muitas instituições bancárias têm em tomar decisões baseadas no comportamento de clientes, foi feito um modelo de machine learning a fim de prever o score de crédito dos clientes, podendo ser usado para liberação de crédito, empréstimos, consórcios, entre outros produtos do tema bancário.

#### 1.3 Missão

Com as informações da base de dados fornecidas, é necessário realizar uma análise prévia dos dados dos clientes fornecidos, criar o modelo que preveja o score de clientes e esse mesmo modelo seja aplicado em novos clientes, depois disso, uma aplicação web para facilitar a visualização desses dados aplicados. Ou seja, tal ação pode entregar às instituições financeiras uma previsão do score de crédito dos clientes a fim de tomada de decisões nas concessões de qualquer forma de crédito.

_________________________________

### 2. Plano de solução

#### 2.1 Coleta de dados

- Entendimento dos dados disponibilizados no canal do Nerd dos Dados ([Link do canal](https://www.youtube.com/@nerddosdados))
- Coleta dos dados

#### 2.2 Análise de dados

### Inspeção dos dados

| **Atributo**              | **Descrição**                             |
|---------------------------|-------------------------------------------|
| CODIGO_CLIENTE            | Código do cliente                         |
| UF                        | Estado do cliente                         |
| IDADE                     | Idade do cliente                          |
| ESCOLARIDADE              | Escolaridade do cliente                   |
| ESTADO_CIVIL              | Estado civil do cliente                   |
| QT_FILHOS                 | Quantidade de filhos do cliente           |
| CASA_PROPRIA              | Possui casa própria?                      |
| QT_IMOVEIS                | Quantidade de imóveis do cliente          |
| VL_IMOVEIS                | Valor total dos imóveis do cliente        |
| OUTRA_RENDA               | Possui outra fonte de renda?              |
| OUTRA_RENDA_VALOR         | Valor da outra renda                      |
| TEMPO_ULTIMO_EMPREGO_MESES| Tempo em meses do último emprego          |
| TRABALHANDO_ATUALMENTE    | Está trabalhando atualmente?              |
| ULTIMO_SALARIO            | Valor do último salário                   |
| QT_CARROS                 | Quantidade de carros do cliente           |
| VALOR_TABELA_CARROS       | Valor total dos carros do cliente         |
| SCORE                     | Score do cliente                          |


### Análise exploratória dos dados

* Variáveis numéricas

* Resumo estatístico das variáveis numéricas

| Variável                   | Min.   | 1st Qu. | Median | Mean    | 3rd Qu. | Max.    |
|----------------------------|--------|---------|--------|---------|---------|---------|
| IDADE                      | 19.00  | 28.00   | 42.00  | 41.05   | 53.00   | 65.00   |
| QT_FILHOS                  | 0.000  | 0.000   | 1.000  | 1.115   | 2.000   | 3.000   |
| QT_IMOVEIS                 | 0.000  | 0.000   | 1.000  | 0.847   | 1.000   | 3.000   |
| VL_IMOVEIS                 | 0      | 0       | 185000 | 238421  | 370000  | 900000  |
| OUTRA_RENDA_VALOR          | 0.0    | 0.0     | 0.0    | 641.4   | 0.0     | 4000.0  |
| TEMPO_ULTIMO_EMPREGO_MESES | 8.00   | 14.00   | 22.00  | 43.08   | 75.00   | 150.00  |
| ULTIMO_SALARIO             | 1800   | 3900    | 6100   | 8286    | 11500   | 22000   |
| QT_CARROS                  | 0.0000 | 0.0000  | 1.0000 | 0.9363  | 2.0000  | 2.0000  |
| VALOR_TABELA_CARROS        | 0      | 0       | 35000  | 40995   | 50000   | 180000  |
| SCORE                      | 12.00  | 28.67   | 45.17  | 51.06   | 72.67   | 98.00   |


Nesta primeira análise, podemos obter os seguintes insights:

Inicialmente, vemos que os clientes têm idade em torno de 42 anos, têm no máximo 3 filhos, há no mínimo 8 meses em seu último emprego, entre outras análises gerais. É importante destacar a alta discrepância entre os valores dessas variáveis numéricas, indicando que pode ser necessário uma normalização ou padronização dos dados futuramente.


* Correlação de variáveis

<div align="center">
<img src="img\\correlacao.jpeg" />
</div>

Nota-se que há pouca influência de resposta de acordo com a combinação de cada variável numérica. Entretanto, outras variáveis se explicam bastante entre si, o que pode influenciar numa redução de variáveis.


* Variáveis de auxílio

Para fins de contribuição com o estudo, algumas ideias de acréscimo de variável foram observadas, como a faixa etária de idade, já que há um intervalo considerável de valores entre 19 a 65 anos nessa base de dados. A distribuição por faixa etária pode ser uma das variáveis complementares para este modelo, sendo separadas da seguinte forma:

| Faixa etária   | Quantidade |
|----------------|------------|
| Até 30         | 3552       |
| 31 a 40        | 1270       |
| 41 a 50        | 2070       |
| Maior que 50   | 3582       |

Tendo a opção de visualizar o score sobre essas faixas etárias por alguma medida de tendência central, como a mediana:

| Faixa etária   | Mediana SCORE |
|----------------|---------------|
| Até 30         | 34.2          |
| 31 a 40        | 45.2          |
| 41 a 50        | 56.2          |
| Maior que 50   | 61.7          |

* Variáveis categóricas

* Histograma das variáveis categóricas

<div align="center">
<img src="img\\histograma_categoricas.jpeg" />
</div>

Neste gráfico das variáveis categóricas, observamos alguns insights importantes também, tais como:

- A uma maior concentração de clientes no Rio de Janeiro e São Paulo;

- A maior parte dos clientes tem superior completo ou estão cursando;

- Há um maior número de clientes que são casados

- A maior parcela dos clientes não possuem uma segunda renda, mas trabalham atualmente, têm idade menor ou igual a 30, ou maiores que 50 anos.

Entre outras análises que podem ser feitas nesses gráficos.

_________________________________

### 3. Modelo de Machine learning

Dado o desempenho e estilo que os dados estão disponíveis, e ainda após ter realizado alguns testes com outros modelos, foi utilizado uma [Regressão Linear](https://search.r-project.org/R/refmans/stats/html/lm.html).

Inicialmente, para fins de treinar e testar o modelo, os dados foram divididos em treino e teste na proporção de 70% e 30%, respectivamente. Em seguida, foi feita uma normalização destes dados, exceto da variável resposta, para que os dados de diferentes escalas não impactem no modelo de previsão.

Com os dados inicialmente preparados, foi aplicado o modelo de regressão linear nos dados de treino e este modelo nos devolveu algumas estatísticas descritivas sobre as variáveis preditoras e a variável resposta destes dados:

| Estatística            | Valor     |
|------------------------|-----------|
| Residual standard error| 12.36     |
| Multiple R-squared     | 0.7952    |
| Adjusted R-squared     | 0.7947    |
| F-statistic            | 1775      |
| p-value                | < 2.2e-16 |

_________________________________

| Variável                    | Estimativa | Erro Padrão | Valor t | Valor p   |
|-----------------------------|------------|-------------|---------|-----------|
| (Intercepto)                | 51.0480    | 0.1443      | 353.805 | < 2e-16 *** |
| UF                          | 1.6740     | 0.1501      | 11.150  | < 2e-16 *** |
| IDADE                       | -3.5926    | 0.5430      | -6.616  | 3.94e-11 *** |
| ESCOLARIDADE                | -0.0252    | 0.1987      | -0.127  | 0.8991    |
| ESTADO_CIVIL                | -0.3665    | 0.1711      | -2.142  | 0.0322 *  |
| QT_FILHOS                   | 0.4900     | 0.1958      | 2.503   | 0.0123 *  |
| CASA_PROPRIA                | 1.2293     | 0.1968      | 6.247   | 4.41e-10 *** |
| QT_IMOVEIS                  | -8.4084    | 0.7278      | -11.554 | < 2e-16 *** |
| VL_IMOVEIS                  | 9.8966     | 0.7128      | 13.884  | < 2e-16 *** |
| OUTRA_RENDA                 | -31.6885   | 1.1446      | -27.685 | < 2e-16 *** |
| OUTRA_RENDA_VALOR           | 42.1347    | 1.2204      | 34.525  | < 2e-16 *** |
| TEMPO_ULTIMO_EMPREGO_MESES  | 8.7355     | 0.2928      | 29.830  | < 2e-16 *** |
| TRABALHANDO_ATUALMENTE      | -2.1449    | 0.2234      | -9.603  | < 2e-16 *** |
| ULTIMO_SALARIO              | 21.0197    | 0.5202      | 40.410  | < 2e-16 *** |
| QT_CARROS                   | 10.3185    | 0.3158      | 32.676  | < 2e-16 *** |
| VALOR_TABELA_CARROS         | -17.5587   | 0.4372      | -40.159 | < 2e-16 *** |
| FAIXA_ETARIA                | 4.8136     | 0.5377      | 8.952   | < 2e-16 *** |


Com um R² do modelo aplicado aos dados de treino de aproximadamente 80%, foi aplicado aos dados não vistos ainda pelo modelo, com intuito de evitar dados viciados aplicamos o modelo aos dados de teste e o R² também foi próximo de 80%. Foi mantido este modelo pela acurácia de certa forma aceitável aos dados, sem um ajuste fino neste momento sobre o modelo, porém é uma pauta de estudos futuros.
Algumas variáveis não se mostraram estatisticamente significativas ao modelo, entretanto, foram mantidas as variáveis neste algoritmo.

_________________________________

### 4. Aplicação Web: Shiny 

Shiny é uma biblioteca (um conjunto de funções adicionais) para a linguagem de programação R. O seu objetivo é facilitar o desenvolvimento de aplicações Web, que permitem que um usuário interaja com o código R usando elementos da Interface do Utilizador (UI) num navegador Web, como controlos deslizantes, menus suspensos e assim por diante. ([Link do tutorial](https://programminghistorian.org/pt/licoes/aplicacao-web-interativa-r-shiny-leaflet))

O intuito aqui é que ao aplicar o modelo em novos dados, eu tenha o retorno dos possíveis score desses novos clientes (dado o retorno de que o modelo é capaz de explicar cerca de 80% da variabilidade dos dados, o que sugere um ajuste bastante bom) em um visual mais performático e prático numa aplicação cotidiana.
Após ter salvo o modelo e as normalizações a serem aplicadas em novos dados, esta aplicação web retorna o possível score desse novo cliente, como demonstrado no vídeo abaixo:

<div align="center">
<img src="img\\video_projeot.gif" />
</div>
_________________________________

### 5. Conclusão

Este projeto foi desenvolvido simulando um contexto do mundo real, onde podem ser aplicados em modelos próprios de score de clientes, dado um conjunto de variáveis, ou numa pontuação de possíveis empréstimos segmentados por um determinado valor, dados o retorno de score do público abordado, níveis de risco de crédito dados as condições do cliente.

Lembrando que, as variáveis podem ser alteradas para que se traga o contexto a ser analisado em um modelo de previsão. Adicionalmente, é importante notar que este projeto pode ser expandido com a inclusão de mais variáveis ou testes com outros algoritmos de machine learning para aprimorar a precisão da previsão.
