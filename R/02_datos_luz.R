library(readr)
library(dplyr)

options(timeout = 1800)

url <- "https://datacatalogfiles.worldbank.org/ddh-published/0066940/DR0095685/ntl_adm2_annual.csv"

download.file(url = url,
              destfile = "INPUT/DATA/ntl_adm2_annual.csv",
              mode = "wb")

luz_mundo <- read_csv(url)

names(luz_mundo)

luz_esp_2023 <- luz_mundo %>%
  filter(ISO_A3 == "ESP", year == 2023)
sort(unique(luz_esp_2023$NAM_1))
