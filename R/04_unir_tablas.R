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
  mutate(comunidad = recode(NAM_1,
                            "Principado de Asturias"     = "Asturias, Principado de",
                            "Illes Balears"              = "Balears, Illes",
                            "Comunidad de Madrid"        = "Madrid, Comunidad de",
                            "Región de Murcia"           = "Murcia, Región de",
                            "Comunidad Foral de Navarra" = "Navarra, Comunidad Foral de",
                            "La Rioja"                   = "Rioja, La",
                            "Cataluña/Catalunya"         = "Cataluña",
                            "País Vasco/Euskadi"         = "País Vasco",
                            "Ceuta (Sp.)"                = "Ceuta",
                            "Melilla (Sp.)"              = "Melilla")) %>%
  group_by(comunidad) %>%
  summarise(ntl_sum  = sum(ntl_sum, na.rm = TRUE),
            ntl_mean = mean(ntl_mean, na.rm = TRUE),
            .groups = "drop")
luz_ccaa

# 3. Comprobar que los nombres cuadran ANTES de unir
setdiff(diabetes$comunidad, luz_ccaa$comunidad) 
# Si sale character(0), todos los nombres cuadran. 
# Si sale algún nombre, es uno que no coincide y hay que corregirlo.

# 4. Unión: se parte de diabetes (19 filas), así sobran los 3 peñones/islas
luz_diabetes <- diabetes %>%
  left_join(luz_ccaa, by = "comunidad")

# 5. Comprobaciones: 19 filas y sin NA
nrow(luz_diabetes)
sum(is.na(luz_diabetes))
stopifnot(nrow(luz_diabetes) == 19, sum(is.na(luz_diabetes)) == 0)

# 6. Guardar
write_csv(luz_diabetes, "OUTPUT/DATA/luz_diabetes_ccaa_2023.csv")