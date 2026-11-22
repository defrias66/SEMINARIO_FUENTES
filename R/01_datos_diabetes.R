# 01_datos_diabetes.R -----------------------------------------------------
# Paso 2 (mejora 4). Prevalencia de diabetes por comunidad autónoma.
# Fuente: INE, Encuesta de Salud de España 2023, tabla 71554,
#         leída desde la API JSON del INE (servicio Tempus).
# Salida: OUTPUT/DATA/diabetes_ccaa_2023.csv

library(tidyverse)
library(jsonlite)

# * Importación desde la API del INE --------------------------------------
# El INE publica cada tabla también en JSON. Devuelve una serie por cada
# combinación de sexo, territorio, enfermedad y respuesta.
url_api <- "https://servicios.ine.es/wstempus/js/ES/DATOS_TABLA/71554?nult=1"

Diabetes_JSON <- fromJSON(url_api, simplifyVector = TRUE)

class(Diabetes_JSON)
names(Diabetes_JSON)
head(Diabetes_JSON$Nombre)

# * De JSON a tabla -------------------------------------------------------
# "Nombre" describe la serie y "Data" guarda el valor dentro de una lista.
Diabetes_INE <- tibble(
  nombre = Diabetes_JSON$Nombre,
  valor  = sapply(Diabetes_JSON$Data, function(x) x$Valor[1])
)

Diabetes_INE

# * Filtrado --------------------------------------------------------------
# Las series que buscamos empiezan por "AMBOS SEXOS," y terminan en
# ", Diabetes, Sí". No separamos el texto por comas porque algunos nombres
# de comunidad llevan coma dentro ("Asturias, Principado de").
Diabetes_CCAA <- 
  Diabetes_INE %>% 
  filter(str_detect(nombre, "^AMBOS SEXOS, "),
         str_detect(nombre, ", Diabetes, Sí$")) %>% 
  mutate(comunidad = str_remove(nombre, "^AMBOS SEXOS, "),
         comunidad = str_remove(comunidad, ", Diabetes, Sí$")) %>% 
  filter(comunidad != "TOTAL") %>% 
  select(comunidad, diabetes_pct = valor) %>% 
  arrange(comunidad)

# * Comprobación ----------------------------------------------------------
# 19 filas y Andalucía con 7.83, igual que al leer el CSV.
Diabetes_CCAA
summary(Diabetes_CCAA)
filter(Diabetes_CCAA, comunidad == "Andalucía")

# * Exportación -----------------------------------------------------------
write_csv(x = Diabetes_CCAA, file = "OUTPUT/DATA/diabetes_ccaa_2023.csv", col_names = TRUE)
