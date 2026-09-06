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

inaturalist <- readr::read_csv("inaturalist.csv")

### Visualizando ----

inaturalist

inaturalist |> dplyr::glimpse()

# Recortar para a FOM ----

## Transformando em shapefile ----

inaturalist_sf <- inaturalist |> 
  dplyr::filter(!longitude |> is.na() &
                  !latitude |> is.na() &
                  !scientific_name |> is.na() &
                  !scientific_name |> 
                  stringr::str_detect(" sp$| sp.$| sp,$| sp | aff| cf,") &
                  !scientific_name |>
                  stringr::str_count(stringr::boundary("word")) == 1) |> 
  dplyr::mutate(latitude = latitude |> as.numeric(),
                scientific_name = scientific_name |> 
                  stringr::str_replace("^(\\S+\\s+\\S+)\\s+\\S+(.*)", 
                                       "\\1\\2")) |> 
  sf::st_as_sf(coords = c("longitude", "latitude"),
               crs = grade |> sf::st_crs())

inaturalist_sf

ggplot() +
  geom_sf(data = inaturalist_sf)

## Intersectando para a FOM ----

inaturalist_sf_fom <- inaturalist_sf |> 
  sf::st_intersection(grade |> 
                        dplyr::summarise(geometry = geometry |> 
                                           sf::st_union()))

inaturalist_sf_fom

ggplot() +
  geom_sf(data = grade) +
  geom_sf(data = inaturalist_sf_fom)
