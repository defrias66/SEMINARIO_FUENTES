library(readr)
library(dplyr)

options(timeout = 1800)

url <- "OUTPUT/DATA/diabetes_ccaa_2023.csv"

luz_mundo <- read_csv(url)

names(luz_mundo)