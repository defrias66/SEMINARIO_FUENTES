# Iluminación artificial nocturna y diabetes en las comunidades autónomas de España (2023)

Trabajo de la asignatura *Fuentes de Datos Biomédicos y Web Semántica* (3.º del Grado en Ingeniería de la Salud, Universidad de Burgos, curso 2026-2027).

**Autores:** Diego Medel, Pablo de Frías y Mikel Lasa.

**Informe:** [SEMINARIO_FUENTES.html](SEMINARIO_FUENTES.html) (descargarlo y abrirlo en el navegador). El código está en [SEMINARIO_FUENTES.Rmd](SEMINARIO_FUENTES.Rmd).

## Pregunta

¿Las comunidades y ciudades autónomas con más luz artificial nocturna en 2023 son también las que tienen un mayor porcentaje de personas con diabetes?

Además, el trabajo describe la diabetes por sexo, la evolución de la luz entre 2012 y 2023 y la renta de cada territorio como posible factor asociado.

## Resultado principal

En los 19 territorios analizados (17 comunidades más Ceuta y Melilla) **no encontramos evidencia de que más luz nocturna se asocie con más diabetes**: los territorios con luz alta tienen una prevalencia media del 7,53 % y los de luz baja del 7,95 %, y los dos grupos se solapan por completo. La renta separa mejor: 6,64 % en los de renta alta frente a 8,75 % en los de renta baja. Es un estudio descriptivo y ecológico con solo 19 datos, por lo que no permite hablar de causa. Las limitaciones y la comparación con estudios previos están en el informe.

## Fuentes de datos

| Dato | Fuente | Formato | Cómo se obtiene |
|---|---|---|---|
| Diabetes por comunidad | INE, Encuesta de Salud de España 2023, tabla 71554 | JSON (API del INE) | Script `01` |
| Diabetes por comunidad y sexo | INE, Encuesta de Salud de España 2023, tabla 71554 | CSV | Script `06` |
| Luz artificial nocturna | Banco Mundial, *Space2Stats Monthly & Annual Black Marble Nighttime Lights* (NASA Black Marble), nivel ADM2 | CSV (unos 230 MB) | Scripts `02` y `05` |
| Renta neta media por persona | INE, Encuesta de Condiciones de Vida 2023, tabla 9947 (ingresos de 2022) | JSON (API del INE) | Script `07` |

## Estructura del repositorio

```
SEMINARIO_FUENTES/
├── R/                          Scripts, numerados en orden de ejecución
│   ├── 01_datos_diabetes.R
│   ├── 02_datos_luz.R
│   ├── 03_luz_por_comunidad.R
│   ├── 04_unir_tablas.R
│   ├── 05_luz_evolucion.R
│   ├── 06_diabetes_sexo.R
│   └── 07_datos_renta.R
├── INPUT/DATA/                 Datos descargados (el fichero grande no se sube a GitHub)
├── OUTPUT/DATA/                Tablas generadas por los scripts
├── SEMINARIO_FUENTES.Rmd       Informe en R Markdown
├── SEMINARIO_FUENTES.html      Informe final
└── SEMINARIO_FUENTES.Rproj     Proyecto de RStudio
```

## Qué hace cada script

| Script | Qué hace | Resultado |
|---|---|---|
| `01_datos_diabetes.R` | Lee la diabetes por comunidad (ambos sexos) desde la API JSON del INE | `OUTPUT/DATA/diabetes_ccaa_2023.csv` |
| `02_datos_luz.R` | Descarga la luz nocturna mundial y se queda con España en 2023 | `INPUT/DATA/luz_ESP_2023.csv` |
| `03_luz_por_comunidad.R` | Calcula la luz media de cada comunidad a partir de sus provincias | `OUTPUT/DATA/luz_ccaa_2023.csv` |
| `04_unir_tablas.R` | Une luz y diabetes (19 filas, sin NA) | `OUTPUT/DATA/luz_diabetes_ccaa_2023.csv` |
| `05_luz_evolucion.R` | Luz media por comunidad entre 2012 y 2023 (necesita haber ejecutado `02`) | `OUTPUT/DATA/luz_ccaa_2012_2023.csv` |
| `06_diabetes_sexo.R` | Descarga la diabetes por comunidad y sexo en CSV | `OUTPUT/DATA/diabetes_ccaa_sexo_2023.csv` |
| `07_datos_renta.R` | Lee la renta media por persona desde la API JSON del INE | `OUTPUT/DATA/renta_ccaa_2023.csv` |

## Cómo reproducirlo

1. Abrir `SEMINARIO_FUENTES.Rproj` en RStudio, para que las rutas funcionen desde la carpeta del proyecto.
2. Ejecutar los scripts de `R/` en orden (del `01` al `07`).
3. Abrir `SEMINARIO_FUENTES.Rmd` y pulsar Knit para generar el HTML.

## Paquetes necesarios

```r
install.packages(c("tidyverse", "jsonlite", "tidyjson", "ggrepel", "rmarkdown"))
```

`tidyverse` incluye `readr`, `dplyr`, `tidyr` y `ggplot2`. `jsonlite` y `tidyjson` leen los datos del INE en JSON y `ggrepel` coloca las etiquetas de los gráficos sin que se monten.
