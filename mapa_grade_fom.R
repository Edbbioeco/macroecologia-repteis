# Pacotes ----

library(geobr)

library(tidyverse)

library(sf)

library(ggview)

# Shapefile dos Estados do Brasil ----

## Importar ----

br <- geobr::read_state(year = 2025)

## Visualizar ----

br

ggplot() +
  geom_sf(data = br, color = "black")

# Shapefile da Mata Atlântica ----

## Importar ----

ma <- geobr::read_biomes(year = 2025) |> 
  dplyr::filter(name_biome == "Mata Atlântica")
