library(readr)
library(dplyr)

# 1. Leer las dos tablas
diabetes <- read_csv("OUTPUT/DATA/diabetes_ccaa_2023.csv",
                     na = c("", "NA", ".."))
luz_esp  <- read_csv("INPUT/DATA/luz_ESP_2023.csv")

# Comprobar que la diabetes es numérica 
class(diabetes$diabetes_pct)

# 2. Pasar la luz de provincias (55 filas) a comunidades y unificar los nombres con los del INE
luz_ccaa <- luz_esp %>%
  mutate(comunidad = case_when(
    NAM_1 == "Principado de Asturias"     ~ "Asturias, Principado de",
    NAM_1 == "Illes Balears"              ~ "Balears, Illes",
    NAM_1 == "Comunidad de Madrid"        ~ "Madrid, Comunidad de",
    NAM_1 == "Región de Murcia"           ~ "Murcia, Región de",
    NAM_1 == "Comunidad Foral de Navarra" ~ "Navarra, Comunidad Foral de",
    NAM_1 == "La Rioja"                   ~ "Rioja, La",
    NAM_1 == "Cataluña/Catalunya"         ~ "Cataluña",
    NAM_1 == "País Vasco/Euskadi"         ~ "País Vasco",
    NAM_1 == "Ceuta (Sp.)"                ~ "Ceuta",
    NAM_1 == "Melilla (Sp.)"              ~ "Melilla",
    .default = NAM_1)) %>%
  group_by(comunidad) %>%
  summarise(ntl_sum  = sum(ntl_sum, na.rm = TRUE),
            ntl_mean = mean(ntl_mean, na.rm = TRUE))
luz_ccaa

# 3. Comprobar que los nombres cuadran ANTES de unir
anti_join(diabetes, luz_ccaa, by = "comunidad")
# Si sale una tabla con 0 filas, todos los nombres cuadran.
# Si sale alguna fila, es una comunidad que no coincide y hay que corregirla.

# 4. Unión: se parte de diabetes (19 filas), así sobran los 3 peñones/islas
luz_diabetes <- diabetes %>%
  left_join(luz_ccaa, by = "comunidad")

# 5. Comprobaciones: 19 filas y sin NA (summary() avisa si hay algún NA)
luz_diabetes
summary(luz_diabetes)

# 6. Guardar
write_csv(luz_diabetes, "OUTPUT/DATA/luz_diabetes_ccaa_2023.csv")