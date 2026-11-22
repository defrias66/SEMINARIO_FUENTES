# 01b_diabetes_sexo.R -----------------------------------------------------
# Prevalencia de diabetes por comunidad autónoma y sexo.
# Fuente: INE, Encuesta de Salud de España 2023, tabla 71554.
# Salida: OUTPUT/DATA/diabetes_ccaa_sexo_2023.csv

library(tidyverse)

# * Importación desde la web ----------------------------------------------
Diabetes_INE <- read_delim("https://www.ine.es/jaxi/files/tpx/es/csv_bdsc/71554.csv",
                           delim = ";", escape_double = FALSE, trim_ws = TRUE,
                           locale = locale(decimal_mark = ","))

names(Diabetes_INE) <- c("sexo", "comunidad", "enfermedad", "respuesta", "valor")

# Cómo se escriben las categorías de sexo (para el filtro)
table(Diabetes_INE$sexo)

# * Filtrado --------------------------------------------------------------
# Diabetes, respuesta "Sí", hombres y mujeres, sin el total nacional
Diabetes_sexo <- 
  Diabetes_INE %>% 
  filter(enfermedad == "Diabetes",
         sexo %in% c("Hombres", "Mujeres"),
         respuesta == "Sí",
         comunidad != "TOTAL") %>% 
  select(comunidad, sexo, diabetes_pct = valor) %>% 
  arrange(comunidad, sexo)

# * De texto a número -----------------------------------------------------
Diabetes_sexo <- 
  Diabetes_sexo %>% 
  mutate(diabetes_pct = round(parse_number(diabetes_pct,
                                           locale = locale(decimal_mark = ",")), 2))

# * Comprobación ----------------------------------------------------------
Diabetes_sexo
nrow(Diabetes_sexo)            # 38 (19 comunidades x 2 sexos)
table(Diabetes_sexo$sexo)      # 19 y 19
summary(Diabetes_sexo)         # mirar si hay NA en diabetes_pct
filter(Diabetes_sexo, is.na(diabetes_pct))

# * Exportación -----------------------------------------------------------
write_csv(x = Diabetes_sexo, file = "OUTPUT/DATA/diabetes_ccaa_sexo_2023.csv", col_names = TRUE)
