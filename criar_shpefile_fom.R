# Pacotes ----

library(geobr)

library(sf)

library(tidyverse)

# Dados ----

## Brasil ----

### Importando ----

### Visualizando ----

## Formações vegetais do Brasil ----

### Importando ----

veg <- sf::st_read("vege_area.shp")

### Visualizando ----

veg

veg |> dplyr::glimpse()

# Filtrando apenas para a FOM ----

## Filtrando ----

fom <- veg |> dplyr::filter(nm_pretet == "Floresta Ombrófila Mista")

## Visualizando -----

# Exportando ----