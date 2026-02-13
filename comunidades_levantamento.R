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
                      values_to = "presence",
                      names_to = "city")

lev_trat

# Georreferenciamento dos registros ----

## Coordenadas das cidades ----

## Transformando os pontos em shapefile ----

## Intersecção com a FOM ----

# Matriz de composição ----

## Montando a matriz ----

## Exportando ----

