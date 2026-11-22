# 05_luz_evolucion.R ------------------------------------------------------
# Mejora 2 (issue #17). Luz artificial nocturna por comunidad autónoma
# de 2012 a 2023.
# Entrada: INPUT/DATA/ntl_adm2_annual.csv (tabla mundial del Banco Mundial,
#          unos 233 MB; la descarga R/02_datos_luz.R y no se sube a GitHub)
# Salida:  OUTPUT/DATA/luz_ccaa_2012_2023.csv

library(readr)
library(dplyr)

# * Cargar datos ----------------------------------------------------------
# Si la tabla mundial no está en INPUT/DATA, se descarga (tarda un rato).
options(timeout = 1800)
archivo <- "INPUT/DATA/ntl_adm2_annual.csv"
if (!file.exists(archivo)) {
  download.file(url = "https://datacatalogfiles.worldbank.org/ddh-published/0066940/DR0095685/ntl_adm2_annual.csv",
                destfile = archivo,
                mode = "wb")
}

luz_mundo <- read_csv(archivo)

# * Filtrar España y los años del estudio ----------------------------------
luz_esp <- luz_mundo %>%
  filter(ISO_A3 == "ESP", year >= 2012, year <= 2023)

# Quitamos las islas y peñones que no tienen datos en el INE
luz_esp <- luz_esp %>%
  filter(NAM_1 != "Las Islas Chafarinas (Sp.)",
         NAM_1 != "Peñón de Alhucaimas (Sp.)",
         NAM_1 != "Peñón de Vélez de la Gomera (Sp.)")

# * Nombres de las comunidades como en el INE ------------------------------
luz_esp <- luz_esp %>%
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

# * Agrupación por comunidad y año ----------------------------------------
# Igual que en el paso 5: brillo medio por píxel (ntl_mean) y media de las
# provincias de cada comunidad.
luz_evolucion <- luz_esp %>%
  group_by(comunidad, year) %>%
  summarise(luz_media = round(mean(ntl_mean), 2),
            n_provincias = n(),
            .groups = "drop") %>%
  rename(anio = year) %>%
  arrange(comunidad, anio)

# * Comprobación ----------------------------------------------------------
# Tienen que salir 19 comunidades x 12 años = 228 filas, sin NA.
nrow(luz_evolucion)
sum(is.na(luz_evolucion))

# * Exportación -----------------------------------------------------------
write_csv(x = luz_evolucion, file = "OUTPUT/DATA/luz_ccaa_2012_2023.csv", col_names = TRUE)
