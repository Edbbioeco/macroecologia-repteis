# Pacotes ----

library(sf)

library(tidyverse)

library(writexl)

# Dados ----

## Shapefile da grade ----

### Importando ----

grade <- sf::st_read("grade_fom.shp")

### Visualizando ----

grade

ggplot() +
  geom_sf(data = grade)

## Registros de ocorrência ----

### Importando ----

occ_sibbr <- readr::read_csv2("sibbr.csv", quote = ";")

### Visualizando ----

occ_sibbr

occ_sibbr |>  dplyr::glimpse()

# Recortar para a FOM ----

## Transformando em shapefile ----

gbif_sf <- gbif_occ |> 
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
               crs = 4674)

gbif_sf

ggplot() +
  geom_sf(data = gbif_sf)

## Intersectando para a FOM ----

gbif_sf_fom <- gbif_sf |> 
  sf::st_intersection(grade |> 
                        dplyr::summarise(geometry = geometry |> 
                                           sf::st_union()))

gbif_sf_fom

ggplot() +
  geom_sf(data = grade) +
  geom_sf(data = gbif_sf_fom)

# Matriz de composição ----

## Lista de espécies ----

gbif_sf_fom |> 
  dplyr::pull(species) |> 
  unique()

## tratando as espécies ----

# Matriz de composição ----

## Montando a matriz de composição ----

## Exportando ----