# Pacotes ----

library(readxl)

library(tidyverse)

library(vegan)

library(betapart)

library(ggdendro)

library(ggtext)

library(flextable)

# Dados ----

## Composição ----

### Importar ----

comp <- readxl::read_xlsx("comunidades_taxonomicas.xlsx")

### Visualizar ----

comp

comp |> dplyr::glimpse()

## Grade das Florestas Ombrófilas Mistas ----

### Importar ----

grade <- sf::st_read("grade_fom.shp")

### Visualizar ----

grade

ggplot() +
  geom_sf(data = grade, color = "black")
