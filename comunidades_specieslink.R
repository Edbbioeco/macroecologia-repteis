# Pacotes ----

library(sf)

library(tidyverse)

library(readxl)

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

occ_specieslink <- readxl::read_xlsx("specieslink.xlsx")

### Visualizando ----

occ_specieslink

occ_specieslink |>  dplyr::glimpse()

# Recortar para a FOM ----

## Transformando em shapefile ----

specieslink_sf <- occ_specieslink |> 
  dplyr::filter(!decimalLongitude |> is.na() &
                  !decimalLatitude |> is.na() &
                  !Species |> is.na()) |> 
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
               crs = 4674)

specieslink_sf

ggplot() +
  geom_sf(data = specieslink_sf)

## Intersectando para a FOM ----

specieslink_sf_fom <- specieslink_sf |> 
  sf::st_intersection(grade |> 
                        dplyr::summarise(geometry = geometry |> 
                                           sf::st_union()))

specieslink_sf_fom

ggplot() +
  geom_sf(data = grade) +
  geom_sf(data = specieslink_sf_fom)

# Matriz de composição ----

## Lista de espécies ----

specieslink_sf_fom |> 
  dplyr::pull(Species) |> 
  unique()

## tratando as espécies ----

# Matriz de composição ----

## Montando a matriz de composição ----

## Exportando ----