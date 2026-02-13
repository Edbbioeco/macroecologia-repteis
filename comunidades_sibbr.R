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

sibbr_sf <- occ_sibbr |> 
  dplyr::filter(!decimalLongitude |> is.na() &
                  !decimalLatitude |> is.na() &
                  !Species |> is.na()) |> 
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
               crs = 4674)

sibbr_sf

ggplot() +
  geom_sf(data = sibbr_sf)

## Intersectando para a FOM ----

sibbr_sf_fom <- sibbr_sf |> 
  sf::st_intersection(grade |> 
                        dplyr::summarise(geometry = geometry |> 
                                           sf::st_union()))

sibbr_sf_fom

ggplot() +
  geom_sf(data = grade) +
  geom_sf(data = sibbr_sf_fom)

# Matriz de composição ----

## Lista de espécies ----

sibbr_sf_fom |> 
  dplyr::pull(Species) |> 
  unique()

## tratando as espécies ----

# Matriz de composição ----

## Montando a matriz de composição ----

## Exportando ----