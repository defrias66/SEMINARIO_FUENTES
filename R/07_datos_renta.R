# 07_datos_renta.R --------------------------------------------------------
# Mejora 5. Renta media por persona de cada comunidad autónoma.
# Fuente: INE, Encuesta de Condiciones de Vida, tabla 9947, leída desde la
#         API JSON del INE igual que la diabetes (R/01_datos_diabetes.R).
# Salida: OUTPUT/DATA/renta_ccaa_2023.csv
#
# Ojo: en esta encuesta la renta de cada año es la del año anterior a la
# entrevista. La de la encuesta de 2023 es la renta de 2022.

library(tidyverse)
library(jsonlite)
library(tidyjson)

# * Importación desde la API del INE --------------------------------------
# tip=AM añade los metadatos de cada serie (territorio y tipo de renta).
url_api <- "https://servicios.ine.es/wstempus/js/ES/DATOS_TABLA/9947?tip=AM"

Renta_JSON <- fromJSON(url_api, simplifyVector = FALSE)

length(Renta_JSON)

Renta_JSON %>%
  gather_object() %>%
  json_types() %>%
  count(name, type)

# * De JSON a tabla con tidyjson ------------------------------------------
Metadatos <-
  Renta_JSON %>%
  enter_object(MetaData) %>%
  gather_array() %>%
  spread_all() %>%
  as_tibble() %>%
  select(document.id, T3_Variable, Nombre)

count(Metadatos, T3_Variable)

# Territorio de cada serie. Las del total nacional no tienen esta
# variable, así que quedan fuera.
Territorio <-
  Metadatos %>%
  filter(T3_Variable == "Comunidades y Ciudades Autónomas") %>%
  select(document.id, comunidad = Nombre)

# Tipo de renta de cada serie
Medida <-
  Metadatos %>%
  filter(T3_Variable == "SALDOS CONTABLES") %>%
  select(document.id, medida = Nombre)

Valores <-
  Renta_JSON %>%
  enter_object(Data) %>%
  gather_array() %>%
  spread_all() %>%
  as_tibble() %>%
  select(document.id, Anyo, Valor)

Renta_INE <-
  Territorio %>%
  left_join(Medida, by = "document.id") %>%
  left_join(Valores, by = "document.id")

Renta_INE

# * Filtrado --------------------------------------------------------------
# Renta neta media por persona de la encuesta de 2023, el mismo año que la
# diabetes y la luz.
Renta_CCAA <-
  Renta_INE %>%
  filter(medida == "Renta neta media por persona",
         Anyo == 2023) %>%
  select(comunidad, renta_euros = Valor)

# * Nombres de las comunidades --------------------------------------------
# El INE escribe aquí "Castilla - La Mancha" con espacios, al contrario que
# en la tabla de diabetes. Lo dejamos igual que allí para que cuadre el join.
Renta_CCAA <-
  Renta_CCAA %>%
  mutate(comunidad = case_when(
    comunidad == "Castilla - La Mancha" ~ "Castilla-La Mancha",
    .default = comunidad)) %>%
  arrange(comunidad)

# * Comprobación ----------------------------------------------------------
# 19 territorios y la renta como número, no como texto.
Renta_CCAA
class(Renta_CCAA$renta_euros)
summary(Renta_CCAA)

# * Exportación -----------------------------------------------------------
write_csv(x = Renta_CCAA, file = "OUTPUT/DATA/renta_ccaa_2023.csv", col_names = TRUE)
