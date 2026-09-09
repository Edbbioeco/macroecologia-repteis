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

herpetohelp <- readxl::read_xlsx("herptohelp.xlsx",,
                                 sheet = 2)

### Visualizando ----

herpetohelp

herpetohelp |> dplyr::glimpse()

# Recortar para a FOM ----

## Transformando em shapefile ----

herpetohelp_sf <- herpetohelp |>
  dplyr::filter(Grupo == "Répteis") |>  
  dplyr::filter(!`Longitude no mapa (SIRGAS 2000)` |> is.na() &
                  !`Latitude no mapa (SIRGAS 2000)` |> is.na() &
                  !Espécie |> is.na() &
                  !Espécie |> 
                  stringr::str_detect(" sp$| sp.$| sp,$| sp | aff| cf,") &
                  !Espécie |>
                  stringr::str_count(stringr::boundary("word")) == 1) |> 
  dplyr::mutate(`Latitude no mapa (SIRGAS 2000)` = `Latitude no mapa (SIRGAS 2000)` |> as.numeric(),
                Espécie = Espécie |> 
                  stringr::str_replace("^(\\S+\\s+\\S+)\\s+\\S+(.*)", 
                                       "\\1\\2")) |> 
  sf::st_as_sf(coords = c("Longitude no mapa (SIRGAS 2000)", "Latitude no mapa (SIRGAS 2000)"),
               crs = grade |> sf::st_crs())

herpetohelp_sf

ggplot() +
  geom_sf(data = herpetohelp_sf)

## Intersectando para a FOM ----
herpetohelp_sf_fom <- herpetohelp_sf |> 
  sf::st_intersection(grade |> 
                        dplyr::summarise(geometry = geometry |> 
                                           sf::st_union()))

herpetohelp_sf_fom

ggplot() +
  geom_sf(data = grade) +
  geom_sf(data = herpetohelp_sf_fom)
