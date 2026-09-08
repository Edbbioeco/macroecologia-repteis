# Pacotes ----

library(geobr)

library(tidyverse)

library(sf)

library(ggview)

# Shapefile dos estados do Brasil ----

## Importar ----

br <- geobr::read_state(year = 2025)

## Visualizar ----

br

ggplot() +
  geom_sf(data = br, color = "black")

# Shapefile das Florestas Ombrófilas Densas ----

## Importar ----

fom <- sf::st_read("fom.shp")

## Visualizar ----

fom

ggplot() +
  geom_sf(data = br, color = "black") +
  geom_sf(data = fom, color = "forestgreen")
