# 01_datos_diabetes.R -----------------------------------------------------
# Paso 2. Prevalencia de diabetes por comunidad autónoma.
# Fuente: INE, Encuesta de Salud de España 2023, tabla 71554.
# Salida: OUTPUT/DATA/diabetes_ccaa_2023.csv

library(tidyverse)

# * Importación desde la web ----------------------------------------------
# El INE separa las columnas con ";" y escribe los decimales con coma (7,83).
# Con locale(decimal_mark = ",") le decimos a R que la coma es el decimal;
# sin eso, lee 7,83 como 783.
Diabetes_INE <- read_delim("https://www.ine.es/jaxi/files/tpx/es/csv_bdsc/71554.csv",
                           delim = ";", escape_double = FALSE, trim_ws = TRUE,
                           locale = locale(decimal_mark = ","))

Diabetes_INE
str(Diabetes_INE)
summary(Diabetes_INE)

# * Nombres de las columnas -----------------------------------------------
# La tabla trae 5 columnas con nombres largos. Les ponemos nombres cortos,
# en el mismo orden en que vienen.
names(Diabetes_INE)
names(Diabetes_INE) <- c("sexo", "comunidad", "enfermedad", "respuesta", "valor")
names(Diabetes_INE)

# Categorías de cada columna (para escribir bien los filtros)
table(Diabetes_INE$sexo)
table(Diabetes_INE$respuesta)
levels(factor(Diabetes_INE$comunidad))

# * Filtrado --------------------------------------------------------------
# Nos quedamos con Diabetes, ambos sexos y respuesta "Sí",
# y quitamos la fila del total nacional.
Diabetes_CCAA <- 
  Diabetes_INE %>% 
  filter(enfermedad == "Diabetes",
         sexo == "AMBOS SEXOS",
         respuesta == "Sí",
         comunidad != "TOTAL") %>% 
  select(comunidad, diabetes_pct = valor) %>% 
  arrange(comunidad)


# * De texto a número -----------------------------------------------------
# La columna llega como texto porque la tabla del INE usa ".." en las casillas
# sin muestra suficiente, y eso obliga a R a leer toda la columna como texto.
# parse_number() la convierte a número indicando que la coma es el decimal.
class(Diabetes_CCAA$diabetes_pct)

Diabetes_CCAA <- 
  Diabetes_CCAA %>% 
  mutate(diabetes_pct = round(parse_number(diabetes_pct,
                                           locale = locale(decimal_mark = ",")), 2))

class(Diabetes_CCAA$diabetes_pct)

# * Comprobación ----------------------------------------------------------
# Tienen que salir 19 filas (17 comunidades + Ceuta + Melilla)
# y Andalucía con 7.83.
Diabetes_CCAA
summary(Diabetes_CCAA)
filter(Diabetes_CCAA, comunidad == "Andalucía")

# * Exportación -----------------------------------------------------------
write_csv(x = Diabetes_CCAA, file = "OUTPUT/DATA/diabetes_ccaa_2023.csv", col_names = TRUE)