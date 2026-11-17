# 03_luz_por_comunidad.R --------------------------------------------------
# Paso 5. Luz artificial nocturna media por comunidad autónoma.
# Entrada: INPUT/DATA/luz_ESP_2023.csv  (provincias de España, 2023)
# Salida:  OUTPUT/DATA/luz_ccaa_2023.csv

library(tidyverse)

# * Cargar datos
Luz_ESP <- read_csv("INPUT/DATA/luz_ESP_2023.csv")

Luz_ESP
names(Luz_ESP)

# Los datos vienen por provincia (NAM_2) dentro de cada comunidad (NAM_1).
levels(factor(Luz_ESP$NAM_1))

# * renombrar ombres de las comunidadespara que coincidan  

  Luz_ESP %>% 
  mutate(comunidad = case_when(
    NAM_1 == "Principado de Asturias"     ~ "Asturias, Principado de",
    NAM_1 == "Illes Balears"              ~ "Balears, Illes",
    NAM_1 == "Cataluña/Catalunya"         ~ "Cataluña",
    NAM_1 == "Ceuta (Sp.)"                ~ "Ceuta",
    NAM_1 == "Comunidad de Madrid"        ~ "Madrid, Comunidad de",
    NAM_1 == "Melilla (Sp.)"              ~ "Melilla",
    NAM_1 == "Región de Murcia"           ~ "Murcia, Región de",
    NAM_1 == "Comunidad Foral de Navarra" ~ "Navarra, Comunidad Foral de",
    NAM_1 == "País Vasco/Euskadi"         ~ "País Vasco",
    NAM_1 == "La Rioja"                   ~ "Rioja, La",
    .default = NAM_1))

# * Añadimos Islas y peñones que estan sin dato en el INE pero si en el banco mundial

Luz_ESP <- 
  Luz_ESP %>% 
  filter(comunidad != "Las Islas Chafarinas (Sp.)",
         comunidad != "Peñón de Alhucaimas (Sp.)",
         comunidad != "Peñón de Vélez de la Gomera (Sp.)")

# * Agrupación por comunidad ----------------------------------------------
# Usamos ntl_mean, el brillo medio por píxel, y no ntl_sum, que suma todo el
# brillo del territorio y por tanto premia a las comunidades más grandes.
# Hacemos la media de las provincias de cada comunidad.
Luz_CCAA <- 
  Luz_ESP %>% 
  group_by(comunidad) %>% 
  summarise(luz_media = round(mean(ntl_mean), 2),
            n_provincias = n()) %>% 
  arrange(desc(luz_media))

# * Comprobación ----------------------------------------------------------
# Tienen que salir 19 comunidades.
Luz_CCAA
summary(Luz_CCAA)

# * Exportación -----------------------------------------------------------
write_csv(x = Luz_CCAA, file = "OUTPUT/DATA/luz_ccaa_2023.csv", col_names = TRUE)
