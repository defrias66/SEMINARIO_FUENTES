# RELACIÓN ENTRE ILUMINACIÓN ARTIFICIAL NOCTURNA Y DIABETES POR COMUNIDADES AUTÓNOMAS EN ESPAÑA

S# Iluminación artificial nocturna y diabetes en las comunidades autónomas de España (2023)

Trabajo de la asignatura *Fuentes de Datos Biomédicos y Web Semántica* (3.º del Grado en Ingeniería de la Salud, Universidad de Burgos, curso 2026-2027).

**Autores:** Diego Medel, Pablo de Frías y Mikel Lasa.

📄 **Informe:** [SEMINARIO_FUENTES.html](ENLACE_AL_HTML)

## Pregunta

¿Las comunidades y ciudades autónomas con más luz artificial nocturna en 2023 son también las que tienen un mayor porcentaje de personas con diabetes?

Además, el trabajo describe la diabetes por sexo, la evolución de la luz entre 2012 y 2023 y la renta de cada territorio como posible factor asociado.

## Resultado principal

En los 19 territorios analizados (17 comunidades más Ceuta y Melilla) **no encontramos evidencia de que más luz nocturna se asocie con más diabetes**: los territorios con luz alta tienen una prevalencia media del 7,53 % y los de luz baja del 7,95 %, y los dos grupos se solapan por completo. La renta separa mejor: 6,64 % en los de renta alta frente a 8,75 % en los de renta baja. Es un estudio descriptivo y ecológico con solo 19 datos, por lo que no permite hablar de causa. Las limitaciones y la comparación con estudios previos están en el informe.

## Fuentes de datos

| Dato | Fuente | Cómo se obtiene |
|---|---|---|
| Diabetes por comunidad y sexo | INE, Encuesta de Salud de España 2023, tabla 71554 | Se descarga desde la web del INE en los scripts `01` y `01b` |
| Luz artificial nocturna | Banco Mundial, *Space2Stats Monthly & Annual Black Marble Nighttime Lights* (NASA Black Marble), nivel ADM2 | Se descarga en `02` y `05` (fichero de unos 220 MB) |
| Renta neta media por persona | INE, Encuesta de Condiciones de Vida, 2023 | Se descarga en `07` |

## Estructura del repositorio

```
SEMINARIO_FUENTES/
├── R/                          Scripts, numerados en orden de ejecución
│   ├── 01_datos_diabetes.R
│   ├── 01b_diabetes_sexo.R
│   ├── 02_datos_luz.R
│   ├── 03_luz_por_comunidad.R
│   ├── 04_unir_tablas.R
│   ├── 05_luz_evolucion.R
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
| `01_datos_diabetes.R` | Prevalencia de diabetes por comunidad (ambos sexos) | `OUTPUT/DATA/diabetes_ccaa_2023.csv` |
| `01b_diabetes_sexo.R` | Prevalencia de diabetes por comunidad y sexo | `OUTPUT/DATA/diabetes_ccaa_sexo_2023.csv` |
| `02_datos_luz.R` | Descarga la luz nocturna mundial y se queda con España en 2023 | `INPUT/DATA/luz_ESP_2023.csv` |
| `03_luz_por_comunidad.R` | Calcula la luz media de cada comunidad a partir de sus provincias | `OUTPUT/DATA/luz_ccaa_2023.csv` |
| `04_unir_tablas.R` | Une luz y diabetes (19 filas, sin NA) | `OUTPUT/DATA/luz_diabetes_ccaa_2023.csv` |
| `05_luz_evolucion.R` | Luz media por comunidad entre 2012 y 2023 | `OUTPUT/DATA/luz_ccaa_2012_2023.csv` |
| `07_datos_renta.R` | Descarga la renta media por persona | `OUTPUT/DATA/renta_ccaa_2023.csv` |

## Paquetes necesarios

```r
install.packages(c("tidyverse", "ggrepel", "rmarkdown", "knitr"))
```

`tidyverse` incluye `readr`, `dplyr`, `ggplot2` y `tidyr`. `ggrepel` se usa para las etiquetas de los gráficos de dispersión.

## Cómo reproducirlo

1. Clona el repositorio y abre `SEMINARIO_FUENTES.Rproj` con RStudio, para que las rutas relativas funcionen.
2. Instala los paquetes (comando de arriba, una sola vez).
3. Ejecuta los scripts de la carpeta `R/` **en este orden**: `01`, `01b`, `02`, `03`, `04`, `05`, `07`. Hace falta conexión a internet: `02` y `05` descargan un fichero de unos 220 MB y tardan unos minutos.
4. Abre `SEMINARIO_FUENTES.Rmd` y pulsa **Knit** para generar `SEMINARIO_FUENTES.html`.