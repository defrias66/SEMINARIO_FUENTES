# 07_datos_renta.R --------------------------------------------------------
# Mejora 5. Renta media por persona de cada comunidad autónoma.
# Fuente: INE, Encuesta de Condiciones de Vida, tabla 9947.
# Salida: OUTPUT/DATA/renta_ccaa_2023.csv

library(tidyverse)

# * Importación desde la web ----------------------------------------------
# Igual que la tabla de diabetes: separador ";" y decimales con coma.
# Aquí además las cifras llevan punto de millares (14.082 son 14.082 euros).
Renta_INE <- read_delim("https://www.ine.es/jaxiT3/files/t/es/csv_bdsc/9947.csv",
                        delim = ";", escape_double = FALSE, trim_ws = TRUE,
                        locale = locale(decimal_mark = ",", grouping_mark = "."))

Renta_INE
names(Renta_INE)
names(Renta_INE) <- c("comunidad", "medida", "periodo", "valor")

table(Renta_INE$medida)
table(Renta_INE$periodo)

# * Filtrado --------------------------------------------------------------
# Nos quedamos con la renta neta media por persona de 2023, el mismo año
# que la diabetes y la luz, y quitamos el total nacional.
Renta_CCAA <- 
  Renta_INE %>% 
  filter(medida == "Renta neta media por persona",
         periodo == 2023,
         comunidad != "Total Nacional") %>% 
  select(comunidad, renta_euros = valor)

# * Nombres de las comunidades --------------------------------------------
# El INE los escribe aquí con un número delante ("01 Andalucía") y usa
# "Castilla - La Mancha" con espacios, al contrario que en la tabla de
# diabetes. Los dejamos igual que allí para que luego cuadre el join.
Renta_CCAA <- 
  Renta_CCAA %>% 
  mutate(comunidad = str_remove(comunidad, "^[0-9]+ "),
         comunidad = str_replace(comunidad, "Castilla - La Mancha", "Castilla-La Mancha")) %>% 
  arrange(comunidad)

# * Comprobación ----------------------------------------------------------
# 19 territorios y la renta como número, no como texto.
Renta_CCAA
class(Renta_CCAA$renta_euros)
summary(Renta_CCAA)

# * Exportación -----------------------------------------------------------
write_csv(x = Renta_CCAA, file = "OUTPUT/DATA/renta_ccaa_2023.csv", col_names = TRUE)
