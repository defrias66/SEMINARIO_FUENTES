# 01_datos_diabetes.R -----------------------------------------------------
# Paso 2 (mejora 4). Prevalencia de diabetes por comunidad autónoma.
# Fuente: INE, Encuesta de Salud de España 2023, tabla 71554,
#         leída desde la API JSON del INE (servicio Tempus).
# Salida: OUTPUT/DATA/diabetes_ccaa_2023.csv

library(tidyverse)
library(jsonlite)
library(tidyjson)

# * Importación desde la API del INE --------------------------------------
# El INE publica cada tabla también en JSON. Devuelve una serie por cada
# combinación de sexo, territorio, enfermedad y respuesta.
# nult=1 pide solo el último dato y tip=AM añade los metadatos de cada serie.
url_api <- "https://servicios.ine.es/wstempus/js/ES/DATOS_TABLA/71554?nult=1&tip=AM"

Diabetes_JSON <- fromJSON(url_api, simplifyVector = FALSE)

class(Diabetes_JSON)
length(Diabetes_JSON)

# Miramos qué campos son escalares y cuáles son arrays (apartado 5.4.5)
Diabetes_JSON %>%
  gather_object() %>%
  json_types() %>%
  count(name, type)

# * De JSON a tabla con tidyjson ------------------------------------------
# Cada serie es un documento (document.id). Tiene dos arrays:
#  - MetaData: el sexo, la comunidad, la enfermedad y la respuesta
#  - Data: el valor
Metadatos <-
  Diabetes_JSON %>%
  enter_object(MetaData) %>%
  gather_array() %>%
  spread_all() %>%
  as_tibble() %>%
  select(document.id, T3_Variable, Nombre) %>%
  pivot_wider(names_from = T3_Variable, values_from = Nombre)

Valores <-
  Diabetes_JSON %>%
  enter_object(Data) %>%
  gather_array() %>%
  spread_all() %>%
  as_tibble() %>%
  select(document.id, Valor)

Diabetes_INE <- left_join(Metadatos, Valores, by = "document.id")

Diabetes_INE

# * Filtrado --------------------------------------------------------------
# Ambos sexos, diabetes, respuesta "Sí" y sin el total nacional.
# Los nombres de las columnas llevan espacios, por eso van entre comillas
# invertidas.
Diabetes_CCAA <-
  Diabetes_INE %>%
  filter(SEXO == "AMBOS SEXOS",
         ENFERMEDADES == "Diabetes",
         `SI O NO` == "Sí",
         `COMUNIDAD AUTÓNOMA` != "TOTAL") %>%
  select(comunidad = `COMUNIDAD AUTÓNOMA`, diabetes_pct = Valor) %>%
  arrange(comunidad)

# * Comprobación ----------------------------------------------------------
# 19 filas y Andalucía con 7.83, igual que al leer el CSV.
Diabetes_CCAA
summary(Diabetes_CCAA)
filter(Diabetes_CCAA, comunidad == "Andalucía")

# * Exportación -----------------------------------------------------------
write_csv(x = Diabetes_CCAA, file = "OUTPUT/DATA/diabetes_ccaa_2023.csv", col_names = TRUE)
