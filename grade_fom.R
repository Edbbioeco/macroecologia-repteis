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

## Resolução em graus para 10km ----

res <- (10 * 1) / 111.3194 

res

## Gerando a grade -----

grade <- fom_recortada |> 
  sf::st_make_valid() |> 
  dplyr::group_by(name_region) |> 
  dplyr::summarise(geometry = geometry |> sf::st_union()) |> 
  sf::st_convex_hull() |>
  sf::st_make_grid(cellsize = res) |>
  sf::st_sf() |> 
  sf::st_join(fom_recortada |> 
                sf::st_make_valid() |> 
                dplyr::group_by(name_region) |> 
                dplyr::summarise(geometry = geometry |> sf::st_union()) |> 
                sf::st_convex_hull()) |> 
  dplyr::filter(!name_region |> is.na()) |>
  dplyr::mutate(ID = dplyr::row_number())

grade 

ggplot() +
  geom_sf(data = fom_recortada, color = "forestgreen", fill = "forestgreen", 
          alpha = 0.3) +
  geom_sf(data = grade, color = "darkred", fill = NA)

# Exportando ----

grade |> sf::st_write("grade_fom.shp")
