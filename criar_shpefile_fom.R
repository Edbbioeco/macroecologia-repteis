# Pacotes ----

library(geobr)

library(sf)

library(tidyverse)

# Dados ----

## Brasil ----

### Importando ----

br <- geobr::read_state()

### Visualizando ----

br

ggplot() +
  geom_sf(data = br, color = "black")

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

fom

fom |> dplyr::glimpse()

ggplot() +
  geom_sf(data = br, color = "black") +
  geom_sf(data = fom, color = "forestgreen", fill = "forestgreen", alpha = 0.3)

# Exportando ----

fom |> sf::st_write("fom.shp")
