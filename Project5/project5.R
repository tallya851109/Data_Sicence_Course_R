library(datasets)
library(devtools)
library(nnet)
library(ggplot2)
library(magrittr)
source_url('https://gist.githubusercontent.com/Peque/41a9e20d6687f2f3108d/raw/85e14f3a292e126f1454864427e3a189c2fe33f3/nnet_plot_update.r')


# Load data from wine data set
data <- read.csv("wine.data.txt")
colnames(data) <- c("class", "Alcohol", "Malic_acid", "Ash", "Alcalinity_of_ash", "Magnesium", "Total_phenols", "Flavanoids", "Nonflavanoid_phenols", "Proanthocyanins", "Color_intensity", "Hue", "OD", "Proline")
data$class <- data$class %>% as.factor()

## 此資料對於wine的品質進行分等(共分三個等級class)，並去對於wine的特徵進行記錄
## 特徵包含"Alcohol", "Malic acid", "Ash", "Alcalinity of ash", "Magnesium", "Total phenols", "Flavanoids", "Nonflavanoid phenols", "Proanthocyanins", "Color intensity", "Hue", "OD280/OD315 of diluted wines", "Proline"
## 問題: 是否可以經由特徵推論wine的品質??
## 利用類神經網路模型進行學習，建立模型去預測wine的品質

# 資料切割: 將資料切成traindata(70%) -> 之後利用nnet套件進行學習
# 資料切割: 將剩餘資料列為testdata(30%)，並使用模型進行預測class(最後再來對答案)
n <- nrow(data)
t_size = round(0.7 * n)
t_idx <- sample(seq_len(n), size = t_size)

traindata <- data[t_idx,]
testdata <- data[ - t_idx,]



# 利用traindata建立類神經網路模型
nnetM <- nnet(formula = class ~ ., linout = T, size = 3, decay = 0.001, maxit = 1000, trace = T, data = traindata)
# 畫圖
plot.nnet(nnetM, wts.only = F)


# 對於testdata進行預測
prediction <- predict(nnetM, testdata, type = 'class')

# 預測結果與實際結果<對答案> 
cm <- table(x = testdata$class, y = prediction, dnn = c("實際", "預測"))
cm


