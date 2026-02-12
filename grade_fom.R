## Pacotes ----

library(geobr)

library(sf)

library(tidyverse)

# Dados ----

## Brasil ----

### Importando ----

br <- geobr::read_state()

### Visualizando ----

br

ggplot() +
  geom_sf(data = br, color = "black")

## Florestas Ombrófilas Mistas ----

### Importando ----

fom <- sf::st_read("fom.shp")

### Visualizando ----

fom

ggplot() +
  geom_sf(data = br, color = "black") +
  geom_sf(data = fom, color = "forestgreen", fill = "forestgreen", alpha = 0.3)

# Grade ----

## Recortando a FOM apenas para o Sul ----

fom_recortada <- fom |> 
  sf::st_join(br |> dplyr::filter(name_region == "Sul")) |> 
  dplyr::filter(!name_region |> is.na())

fom_recortada

ggplot() +
  geom_sf(data = br, color = "black") +
  geom_sf(data = fom_recortada, color = "forestgreen", fill = "forestgreen", 
          alpha = 0.3)
Blz chefe