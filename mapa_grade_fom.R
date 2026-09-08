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

## Visualizar ----

ma

ggplot() +
  geom_sf(data = ma, color = "green", fill = "green") +
  geom_sf(data = br, color = "black", fill = "transparent")

# Shapefile das Florestas Ombrófilas Densas ----

## Importar ----

fom <- sf::st_read("fom.shp")

## Visualizar ----

fom

ggplot() +
  geom_sf(data = ma, color = "green", fill = "green") +
  geom_sf(data = fom, color = "darkgreen", fill = "darkgreen") +
  geom_sf(data = br, color = "black", fill = "transparent")

# Shapefile da grade ----

## Importar ----

grade <- sf::st_read("grade_fom.shp")

