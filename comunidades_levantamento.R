# Pacote ----

library(geobr)

library(tidyverse)

library(sf)

library(readxl)

library(writexl)

# Dados ----

## Cidades ----

### Importando ----

cidades <- geobr::read_municipality(year = 2019)

### Visualizando ----

cidades

ggplot() +
  geom_sf(data = cidades)

## Grade -----

### Importando ----

grade <- sf::st_read("grade_fom.shp")

### Visualizando ----

grade

ggplot() +
  geom_sf(data = grade)

## Registros -----

### Importando ----

lev <- readxl::read_xlsx("dados copilados.xlsx")

### Visualizando ----

lev

lev |> dplyr::glimpse()

### Tratando ----

lev_trat <- lev |> 
  tidyr::pivot_longer(cols = dplyr::where(is.numeric),
                      values_to = "Presence",
                      names_to = "city")

lev_trat

# Georreferenciamento dos registros ----

## Coordenadas das cidades ----

coord_cidades <- cidades |> 
  dplyr::filter(name_muni %in% unique(lev_trat$city)) |> 
  sf::st_centroid() |> 
  sf::st_coordinates() |> 
  as.data.frame() |> 
  dplyr::rename("Longitude" = X,
                "Latitude" = Y) |> 
  dplyr::mutate(city = unique(lev_trat$city))

coord_cidades

## Transformando os pontos em shapefile ----

lev_sf <- lev_trat |> 
  dplyr::left_join(coord_cidades,
                   by = "city") |> 
  sf::st_as_sf(coords = c("Longitude", "Latitude"),
               crs = 4674)

lev_sf

ggplot() +
  geom_sf(data = grade) +
  geom_sf(data = lev_sf)

# Matriz de composição ----

## Montando a matriz ----

lev_registros <- lev_sf |> 
  sf::st_join(grade) |> 
  as.data.frame() |> 
  dplyr::select(ID, Especies, Presence) |> 
  dplyr::filter(Presence == 1)

lev_registros

## Exportando ----

