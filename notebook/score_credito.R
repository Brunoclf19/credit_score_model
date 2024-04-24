
setwd("C:\\Users\\Giovanna\\OneDrive\\Documentos\\Modelos Preditivos\\ScoreCredito")

# Biblioteca que permite leitura de arquivos em excel
library(readxl)
# Carregar o pacote dplyr
library(dplyr)
# Carregar o pacote ggplot2
library(ggplot2)
# Carregar tidyr para manipulação de dados
library(tidyr)
# Ajuste de gráficos
library(patchwork)
# Pacote de gráfico de correlação
library(corrplot)
# Pacote de modelos de machine learning
library(caret)
# Carregar o pacote necessário
library(glmnet)
library(rpart)
library(randomForest)
library(gbm)
library(shiny)
library(doParallel)

# Leitura do arquivo
df_dados <- read_excel("dados_credito.xlsx")

# Verificando a dimmensão (linha e coluna) do meu dataframe
dim(df_dados)
colnames(df_dados)
# Verificando linhas iniciais e finais do dataframe
head(df_dados)
tail(df_dados)

# Verificando os tipos das colunas do dataframe
str(df_dados)

# Resumo estatistico das colunas do dataframe
summary(df_dados)

# Dado que a coluna código cliente se diferencia a cada cliente, será
# excluida do dataframe

df_dados['CODIGO_CLIENTE'] <- NULL

# Analisando dados agrupados com intuito de identificar valores discrepantes
df_dados %>% 
  group_by(ULTIMO_SALARIO) %>% # Variável que contém NA no dataframe
  summarise(Count = n())

# Verificando o valor médio da coluna na qual contém os valores NAs e substi_
# _tuindo pela sua mediana

df_dados <- df_dados %>% 
  mutate(ULTIMO_SALARIO = replace(ULTIMO_SALARIO, is.na(ULTIMO_SALARIO),
                                  median(ULTIMO_SALARIO, na.rm = TRUE)))


# Analisando (novamente) dados agrupados com intuito de identificar valores
# discrepantes
df_dados %>% 
  group_by(ULTIMO_SALARIO) %>% # Variável que contém NA no dataframe
  summarise(Count = n())

# Verificando se meu dataframe contém dados nulos
anyNA(df_dados)

# Analisando variáveis: descritivo estatistivo e seu tipo
str(df_dados)
summary(df_dados)


# Analisando outliers em variáveis numéricas
# Identificando colunas numéricas
is_numeric <- sapply(df_dados[, 1:16], function(x) is.numeric(x))

# Filtrando os nomes das colunas numéricas
variaveis_numericas <- names(is_numeric[is_numeric])

# Imprimindo os nomes das colunas e o seu tipo
for (var in variaveis_numericas) {
  cat(var, ":", class(df_dados[[var]]), "\n")
}

variaveis_numericas

# Filtrando somente as variáveis numéricas do meu dataframe
df_numeric <- df_dados[variaveis_numericas]
summary(df_numeric)

# Criar individualmente cada box plot e armazenar em uma lista:
plots_list <- list()
for (var in variaveis_numericas) {
  p <- ggplot(df_numeric, aes_string(y = var)) +
    geom_boxplot() +
    labs(title = var)
  plots_list[[length(plots_list) + 1]] <- p
}


# Iniciar o layout de patchwork
plot_layout <- plots_list[[1]]

# Adicionar o restante dos plots ao layout
for (i in 2:length(plots_list)){
  plot_layout <- plot_layout + plots_list[[i]]
}

# Definir o layout para ter 2 linhas e 5 colunas
plot_layout <- plot_layout + plot_layout(ncol = 5, nrow = 2)

print(plot_layout)

# Aqui, é possível identificar alguns outliers, como por exemplo:
#  Quantidade de filhos: acima de 30 filhos (pode ser um erro na digitação)

# Meio de verificar, é usando o resumo estatistico e filtrando os dados
df_dados[df_dados$QT_FILHOS > 4,]
df_numeric[df_numeric$QT_FILHOS > 4,]
# Como são apenas duas linhas de aproximadamente 10k, iremos excluir
df_dados <- df_dados[df_dados$QT_FILHOS <= 4, ]
df_numeric <- df_numeric[df_numeric$QT_FILHOS <= 4, ]

summary(df_dados)
summary(df_numeric)
# Analisando (novamente) dados agrupados com intuito de identificar valores
# discrepantes
df_dados %>% 
  group_by(OUTRA_RENDA_VALOR) %>% # Possível outlier
  summarise(Count = n())
# Padrão muito comum, ou seja, podem haver pessoas com o valor de outra renda
# como o especificado


# Analisando (novamente) dados agrupados com intuito de identificar valores
# discrepantes
df_dados %>% 
  group_by(VALOR_TABELA_CARROS) %>% # Possível outlier
  summarise(Count = n())
# Podem haver pessoas com valor alto de carro (importados)


# Analisando (novamente) dados agrupados com intuito de identificar valores
# discrepantes
df_dados %>% 
  group_by(QT_IMOVEIS) %>% # Possível outlier
  summarise(Count = n())
# Podem haver pessoas com mais do que 1 imóvel no nome


# Avaliando a distribuição dos dados em histograma

# Criar os histogramas individualmente e armazená-los em uma lista:
plots_list <- list()
for (var in variaveis_numericas) {
  p <- ggplot(df_dados, aes_string(x = var)) +
    geom_histogram(bins = 30) +  # ou ajuste a quantidade de bins conforme necessário
    labs(title = var)
  plots_list[[length(plots_list) + 1]] <- p
}

# Organizar os gráficos em um layout de 4x3 usando patchwork:
plot_layout <- NULL
for (p in plots_list) {
  if (is.null(plot_layout)) {
    plot_layout <- p
  } else {
    plot_layout <- plot_layout + p
  }
}

plot_layout <- plot_layout + plot_layout(ncol = 3, nrow = 4)  # Definir as dimensões do grid

# Ajustar opções de plotagem global e exibir o resultado:
options(repr.plot.width=15, repr.plot.height=12)  # Ajustar o tamanho da figura
print(plot_layout)

# Remover as variáveis "ULTIMO_SALARIO" e "QT_IMOVEIS"
#df_numeric <- select(df_numeric, -ULTIMO_SALARIO, -QT_IMOVEIS)

#colnames(df_numeric)
summary(df_numeric)

# Calculando a matriz de correlação
correlacao <- cor(df_numeric)

# Abrir uma nova janela gráfica
windows(width=10, height=6)  # valores em polegadas

options(repr.plot.width=8, repr.plot.height=8)


# Usando corrplot
corrplot(correlacao, method = "color", type = "upper", 
         order = "hclust", tl.col = "black", tl.cex = 0.8, 
         cl.cex = 0.8, addCoef.col = "black", 
         number.cex = 0.7)  # Ajusta o tamanho dos coeficientes de correlação

# A variáveis quantidade de imóveis e valor de imóveis estão bem
# correlacionadas, indicando que uma variável explica muito bem a outra.
# De modo semelhante, ocorre com ultimo salário e quantidade de imóveis

# Deixar apenas uma das variáveis.

# Abrir uma nova janela gráfica
windows(width=10, height=6)  # valores em polegadas

# Observando a dispersão de alguns dados e suas correlações
ggplot(data = df_dados, aes(x = VL_IMOVEIS, y = SCORE))+
  geom_point() + # Adiciona os pontos de dispersão
  geom_smooth(method = "lm", se = TRUE, color = "red") + # Adicionando a linha de regressão linear
  theme_minimal() # Tema mais limpo

# Abrir uma nova janela gráfica
windows(width=10, height=6)
# valores em polegadas

# Observando a dispersão de alguns dados e suas correlações
ggplot(data = df_dados, aes(x = ULTIMO_SALARIO, y = SCORE))+
  geom_point() + # Adiciona os pontos de dispersão
  geom_smooth(method = "lm", se = TRUE, color = "blue") + # Adicionando a linha de regressão linear
  theme_minimal() # Tema mais limpo

# Abrir uma nova janela gráfica
windows(width=10, height=6)  # valores em polegadas

# Observando a dispersão de alguns dados e suas correlações
ggplot(data = df_dados, aes(x = TEMPO_ULTIMO_EMPREGO_MESES, y = SCORE))+
  geom_point() + # Adiciona os pontos de dispersão
  geom_smooth(method = "lm", se = TRUE, color = "green") + # Adicionando a linha de regressão linear
  theme_minimal() # Tema mais limpo

# Há um leve indício de correlação entre as variáveis apresentadas e a
# variável target.

# Adicionando Faixa Etaria para a coluna IDADE
idade_max <- max(df_dados$IDADE)
idade_min <- min(df_dados$IDADE)

idade_max
idade_min

# Adicionando Faixa Etária - engenharia de atributos

# Resumo estatístico
summary(df_dados$IDADE) 

# Verificando presença de NA
table(is.na(df_dados$IDADE))

# Defina os intervalos de idade e as etiquetas associadas
idade_bins <- c(-Inf, 30, 40, 50, Inf)
idade_categoria <- c("Até 30", "31 a 40", "41 a 50", "Maior que 50")

# Classificar as idades nas categorias
df_dados$FAIXA_ETARIA <- cut(df_dados$IDADE, breaks = idade_bins,
                             labels = idade_categoria, right = TRUE)

# Frequência das Faixas Etarias
table(df_dados$FAIXA_ETARIA)

# Agrupando por FAIXA ETARIA e calculando a mediana do SCORE para cada
mediana_score_faixa <- df_dados %>% 
  group_by(FAIXA_ETARIA) %>% 
  summarise(Mediana_SCORE = median(SCORE, na.rm = TRUE)) # na.rm = TRUE remove os NA da média

mediana_score_faixa

# Agrupando por FAIXA ETARIA e calculando a média do SCORE para cada
media_score_faixa <- df_dados %>% 
  group_by(FAIXA_ETARIA) %>% 
  summarise(Media_SCORE = mean(SCORE, na.rm = TRUE)) # na.rm = TRUE remove os NA da média

media_score_faixa


################################################
####  Analisando as variáveis categóricas  #####
################################################

# Identificando variáveis categóricas dentro do número de colunas do dataframe
variaveis_categoricas <- names(df_dados)[sapply(df_dados,
                                                function(col) is.factor(col) 
                                                || is.character(col))]

# Imprimindo os nomes e tipos de dados das variáveis categóricas
for (var in variaveis_categoricas) {
  print(paste(var, ':', class(df_dados[[var]])))
}

# Lista para armazenar cada plot
plot_list <- list()

# Gerar um gráfico de barras para cada variável categórica
for (i in variaveis_categoricas) {
  p <- ggplot(df_dados, aes_string(x = i)) +
    geom_bar() +
    theme_minimal() +
    labs(title = i)
  
  plot_list[[i]] <- p
}

# Combina todos os plots em uma grade de plots
plot_grid <- wrap_plots(plot_list, ncol = 2)

# Ajusta o tamanho da janela de visualização
options(repr.plot.width = 15, repr.plot.height = 22)

# Mostra os gráficos
print(plot_grid)


####################################################
##########    PRÉ PROCESSAMENTO DOS DADOS ##########
####################################################

# Convertendo variáveis categóricas em fatores e depois para inteiros
df_dados$FAIXA_ETARIA <- as.integer(factor(df_dados$FAIXA_ETARIA))
df_dados$OUTRA_RENDA <- as.integer(factor(df_dados$OUTRA_RENDA))
df_dados$TRABALHANDO_ATUALMENTE <- as.integer(factor(df_dados$TRABALHANDO_ATUALMENTE))
df_dados$ESTADO_CIVIL <- as.integer(factor(df_dados$ESTADO_CIVIL))
df_dados$CASA_PROPRIA <- as.integer(factor(df_dados$CASA_PROPRIA))
df_dados$ESCOLARIDADE <- as.integer(factor(df_dados$ESCOLARIDADE))
df_dados$UF <- as.integer(factor(df_dados$UF))

# Removendo valores ausentes
df_dados <- na.omit(df_dados)

str(df_dados)

# # Separando a variável target dos dados para realizar o treinamento
# preditoras <- df_dados
# preditoras <- preditoras %>% 
#   select(-SCORE)
# 
# # Definindo a variável target
# target <- df_dados$SCORE
# 
# # Definindo semente aleatória
# set.seed(42)
# 
# # Indice de divisão 70%, 30%
# indices <- createDataPartition(y = target, p = 0.7, list = FALSE)
# 
# # Dividindo os dados entre treino e teste
# X_treino <- preditoras[indices, ]
# X_teste  <- preditoras[-indices, ]
# y_treino <- target[indices]
# y_teste  <- target[-indices]
#y_treino
#y_teste

# # Melhorando o desempenho da execusão do modelo, usando mais núcleos
# registerDoParallel(makePSOCKcluster(5))
# 
# # Criando o modelo de Random Forest
# modelo <- train(x = X_treino, y = y_treino, method = "rf")
# 
# # Detalhamento
# print(modelo)
# 
# # Fazer predições
# predicoes <- predict(modelo, 
#                      newdata = X_teste)
# 
# # Calcular R^2 para os dados de teste
# r2_teste <- cor(y_teste, predicoes)^2
# cat("O R² para os dados de teste é:", r2_teste, "\n")
# 
# # Predições para os dados de treino
# predicoes_treino <- predict(modelo, newdata = X_treino)
# # Calcular R^2 para os dados de treino
# r2_treino <- cor(y_treino, predicoes_treino)^2
# cat("O R² para os dados de treino é:", r2_treino, "\n")
# 
# # Parar o cluster quando terminar de usar
# stopCluster(makePSOCKcluster(5))







# Separando a variável target dos dados para realizar o treinamento
preditoras <- df_dados
preditoras <- preditoras %>%
  select(-SCORE)

# Definindo a variável target
target <- df_dados$SCORE

# Definindo semente aleatória
set.seed(42)

# Indice de divisão 70%, 30%
indices <- createDataPartition(y = target, p = 0.7, list = FALSE)

# Dividindo os dados entre treino e teste
X_treino <- preditoras[indices, ]
X_teste  <- preditoras[-indices, ]
y_treino <- target[indices]
y_teste  <- target[-indices]
#y_treino
#y_teste

# # Normalização dos dados de treino e extração dos parâmetros de escala
X_treino_scaled <- scale(X_treino)
X_treino_normalizados <- as.data.frame(X_treino_scaled)
means <- attr(X_treino_scaled, "scaled:center")
sds <- attr(X_treino_scaled, "scaled:scale")
#
# # Normalização dos dados de teste usando os parâmetros do treino
X_teste_normalizados <- as.data.frame(scale(X_teste, center = means, scale = sds))


# Criando o modelo de regressão
modelo <- lm(y_treino ~ .,
             data = X_treino_normalizados)

# detalhamento
summary(modelo)

# Fazer predições
predicoes <- predict(modelo,
                     newdata = X_teste_normalizados)


# Calcular R^2 para os dados de teste
r2_teste <- cor(y_teste, predicoes)^2
cat("O R² para os dados de teste é:", r2_teste, "\n")

# Predições para os dados de treino
predicoes_treino <- predict(modelo, newdata = X_treino_normalizados)
# Calcular R^2 para os dados de treino
r2_treino <- cor(y_treino, predicoes_treino)^2
cat("O R² para os dados de treino é:", r2_treino, "\n")

# Salvando os parâmetros de normalização e o modelo
save(modelo, file = "modelo.rda")
save(means, sds, file = "norm_params.rda")

# Carregando o modelo e os parâmetros de normalização
load("modelo.rda")
load("norm_params.rda")

# Definir a interface do usuário
ui <- fluidPage(
  titlePanel("Previsão de SCORE de Crédito"),
  sidebarLayout(
    sidebarPanel(
      numericInput("UF", "Unidade Federativa (1 a 5):", min = 1, max = 5, value = 0),
      numericInput("IDADE", "Idade:", min = 19, max = 65, value = 0),
      numericInput("ESCOLARIDADE", "Escolaridade (1 a 3):", min = 1, max = 3, value = 0),
      numericInput("ESTADO_CIVIL", "Estado Civil (1 a 4):", min = 1, max = 4, value = 0),
      numericInput("QT_FILHOS", "Quantidade de Filhos:", min = 0, max = 3, value = 0),
      numericInput("CASA_PROPRIA", "Casa Própria (1 ou 2):", min = 1, max = 2, value = 0),
      numericInput("QT_IMOVEIS", "Quantos imóveis no nome:", min = 0, max = 3, value = 0),
      numericInput("VL_IMOVEIS", "Qual valor dos imóveis somados:", min = 0, max = 900000, value = 0),
      numericInput("OUTRA_RENDA", "Tem uma segunda renda (1 ou 2):", min = 1, max = 2, value = 0),
      numericInput("OUTRA_RENDA_VALOR", "Valor da segunda renda:", min = 0, max = 4000, value = 0),
      numericInput("TEMPO_ULTIMO_EMPREGO_MESES", "Tempo no último emprego (meses):", min = 8, max = 150, value = 0),
      numericInput("TRABALHANDO_ATUALMENTE", "Trabalha atualmente (1 ou 2):", min = 1, max = 2, value = 0),
      numericInput("ULTIMO_SALARIO", "Último Salário (R$):", min = 1800, max = 22000, value = 0),
      numericInput("QT_CARROS", "Quantos carros:", min = 0, max = 2, value = 0),
      numericInput("VALOR_TABELA_CARROS", "Somados qual é o valor dos carros:", min = 0, max = 180000, value = 0),
      numericInput("FAIXA_ETARIA", "Faixa etária (1 a 4):", min = 1, max = 4, value = 0),
      actionButton("predict", "Calcular SCORE")
    ),
    mainPanel(
      textOutput("scoreOutput")
    )
  )
)

# Definir o servidor
server <- function(input, output) {
  observeEvent(input$predict, {
    # Suponha que temos um dataframe com nomes de colunas correspondentes
    newdata <- data.frame(
      UF = input$UF,
      IDADE = input$IDADE,
      ESCOLARIDADE = input$ESCOLARIDADE,
      ESTADO_CIVIL = input$ESTADO_CIVIL,
      QT_FILHOS = input$QT_FILHOS,
      CASA_PROPRIA = input$CASA_PROPRIA,
      QT_IMOVEIS = input$QT_IMOVEIS,
      VL_IMOVEIS = input$VL_IMOVEIS,
      OUTRA_RENDA = input$OUTRA_RENDA,
      OUTRA_RENDA_VALOR = input$OUTRA_RENDA_VALOR,
      TEMPO_ULTIMO_EMPREGO_MESES = input$TEMPO_ULTIMO_EMPREGO_MESES,
      TRABALHANDO_ATUALMENTE = input$TRABALHANDO_ATUALMENTE,
      ULTIMO_SALARIO = input$ULTIMO_SALARIO,
      QT_CARROS = input$QT_CARROS,
      VALOR_TABELA_CARROS = input$VALOR_TABELA_CARROS,
      FAIXA_ETARIA = input$FAIXA_ETARIA
    )
    
    # Normalizar ou padronizar newdata conforme feito no treinamento
    # (Implementar como foi feito para o treinamento)
    
    # Normalizar newdata conforme feito no treinamento
    newdata_scaled <- as.data.frame(scale(newdata, center = means, scale = sds))
    
    # Predição usando o modelo
    predicted_score <- predict(modelo, newdata = newdata_scaled)
    
    # Mostrar o resultado
    output$scoreOutput <- renderText({
      paste("O SCORE previsto é:", round(predicted_score, 2))
    })
  })
}

# Rodar a aplicação
shinyApp(ui = ui, server = server)
