# Pacote ----

library(geobr)

library(tidyverse)

library(sf)

library(readxl)

library(parzer)

library(writexl)

# Dados ----

## Grade -----

### Importando ----

grade <- sf::st_read("grade_fom.shp")

### Visualizando ----

grade

ggplot() +
  geom_sf(data = grade)

## Registros das espécies -----

### Importando ----

sps <- readxl::read_xlsx("DADOS COPILADOS DA FOM 2026.xlsx")

### Visualizando ----

sps

sps |> dplyr::glimpse()

### Tratando ----

sps_trat <- sps |> 
  tidyr::pivot_longer(cols = dplyr::where(is.numeric),
                      values_to = "Presence",
                      names_to = "Local") |> 
  dplyr::filter(Presence == 1)

sps_trat

## Coordenadas dos locais ----

### Importar ----

coord <- readxl::read_xlsx("DADOS COPILADOS DA FOM 2026.xlsx",
                           sheet = 2)

### Visualizar ----

coord

coord |> dplyr::glimpse()

### Tratar ----

coord_sf <- coord |> 
  dplyr::mutate(Longitude = Longitude |> 
                  parzer::parse_lon(),
                Latitude = Latitude |> 
                  parzer::parse_lat()) |> 
  dplyr::select(Local, dplyr::contains("tude")) |> 
  sf::st_as_sf(coords = c("Longitude", "Latitude"),
               crs = grade |> sf::st_crs())

coord_sf

ggplot() +
  geom_sf(data = grade) +
  geom_sf(data = coord_sf)

# Recortar para a FOM ----

## Intersectando para a FOM ----

coord_sf_fom <- coord_sf |> 
  sf::st_intersection(grade |> 
                        dplyr::summarise(geometry = geometry |> 
                                           sf::st_union()))

coord_sf_fom

ggplot() +
  geom_sf(data = grade) +
  geom_sf(data = coord_sf_fom)

## Extrair as informações da grade ----

df_id_fom <- coord_sf_fom |> 
  sf::st_join(grade) |> 
  dplyr::select(Local, ID) |> as.data.frame()

df_id_fom
