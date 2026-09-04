# Pacotes ----

library(geobr)

library(tidyverse)

library(sf)

library(readxl)

# Dados -----

## Shapefile do Brasil ----

### Importando ----

br <- geobr::read_state(year = 2019)

### Visualizando ----

br

ggplot() +
  geom_sf(data = br, color = "black")

## Florestas Umbrófilas mistas ----

### Importando ----

fom <- sf::st_read("./fom.shp")

### Visualizando ----

fom

ggplot() +
  geom_sf(data = fom, color = "black")

## Gerar um polígono côncavo ----

fom_con <- fom |> 
  sf::st_union() |> 
  sf::st_concave_hull(ratio = 0.45)

fom_con

ggplot() +
  geom_sf(data = fom_con, color = "black")

## GBIF ----

### Importando ----

gbif <- readr::read_csv2("gbif.csv")

### Visualizando ----

gbif 

gbif |> dplyr::glimpse()

### Tratando -----

gbif_trat <- gbif |> 
  dplyr::rename("Longitude" = decimalLongitude,
                "Latitude" = decimalLatitude) |> 
  dplyr::mutate(dplyr::across(
    .cols = dplyr::contains("tude"),
    .fns = ~.x |> 
      as.character() |> 
      (\(x){
        
        paste0(stringr::str_sub(x, 1, 3), 
               ".", 
               stringr::str_sub(x, 4))
        
        })() |> 
      as.numeric())) |> 
  dplyr::filter(!species |> is.na() &
                  !Latitude |> is.na() &
                  !Longitude |> is.na()) |> 
  dplyr::select(species, Latitude:Longitude) |> 
  sf::st_as_sf(coords = c("Longitude", "Latitude"),
               crs = fom |> sf::st_crs())

gbif_trat

ggplot() +
  geom_sf(data = br, color = "black") +
  geom_sf(data = gbif_trat, color = "black")

## SpeciesLink ----

### Importando ----

specieslink <- readxl::read_xlsx("specieslink.xlsx")

### Visualizando ----

specieslink

specieslink |> dplyr::glimpse()

### Tratando ----

specieslink_trat <- specieslink |> 
  dplyr::rename("species" = scientificname,
                "epípeto" = species,
                "Longitude" = longitude,
                "Latitude" = latitude) |> 
  dplyr::mutate(Latitude = Latitude |> as.numeric()) |> 
  dplyr::filter(!epípeto |> is.na() &
                  !Latitude |> is.na() &
                  !Longitude |> is.na()) |> 
  dplyr::select(c(species, Longitude:Latitude)) |> 
  sf::st_as_sf(coords = c("Longitude", "Latitude"),
               crs = fom |> sf::st_crs())

specieslink_trat

ggplot() +
  geom_sf(data = br, color = "black") +
  geom_sf(data = specieslink_trat, color = "black")

## SiBBr ----

### Importando ----

sibbr <- readr::read_csv2("sibbr.csv")

### Visualizando ----

sibbr

sibbr |> dplyr::glimpse()

### Tratando ----

sibbr_trat <- sibbr |> 
  dplyr::rename("species" = Species,
                "Longitude" = decimalLongitude,
                "Latitude" = decimalLatitude) |> 
  dplyr::filter(!species |> is.na() &
                  !Latitude |> is.na() &
                  !Longitude |> is.na()) |> 
  dplyr::select(c(species, Longitude:Latitude)) |> 
  dplyr::mutate(Longitude = Longitude  |> 
                  stringr::str_replace(
                    "^(-?\\d{2})(\\d+)$", "\\1.\\2") |>
                  as.numeric(),
                Longitude = dplyr::case_when(
                  Longitude >= 0 ~ Longitude * -1,
                  .default = Longitude),
                Latitude = case_when(stringr::str_detect(
                  as.character(Latitude), 
                  "^(-?[1-2])") ~ str_replace(
                    as.character(Latitude),
                    "^(-?\\d{2})(\\d+)$", "\\1.\\2"),
                  stringr::str_detect(
                    as.character(Latitude), 
                    "^(-?[3-9])") ~ stringr::str_replace(
                      as.character(Latitude), 
                      "^(-?\\d{1})(\\d+)$", "\\1.\\2"),
                  TRUE ~ as.character(Latitude)) |>
                  as.numeric(),
                Latitude = dplyr::case_when(
                  Latitude >= 0 ~ Latitude * -1,
                  .default = Latitude)) |> 
  tidyr::drop_na() |> 
  sf::st_as_sf(coords = c("Longitude", "Latitude"),
               crs = fom |> sf::st_crs())

sibbr_trat

ggplot() +
  geom_sf(data = br, color = "black") +
  geom_sf(data = sibbr_trat, color = "black")

# Unindo os dados ----

coords <- ls(pattern = "_trat") |> 
  mget(envir = globalenv()) |> 
  dplyr::bind_rows()

coords

# Intersecção ----

## Shapefile ----

especies <- coords |> 
  sf::st_intersection(fom_con |> 
                        sf::st_as_sf()) |> 
  tidyr::drop_na() |> 
  dplyr::select(species) 

especies

ggplot() +
  geom_sf(data = fom_con |> 
            sf::st_as_sf(), color = "black") +
  geom_sf(data = especies)

## Lista de espécies ----

especies |> 
  dplyr::pull(species) |> 
  unique()

# a lista de espécies está ok

## Exportando -----

especies |> 
  dplyr::rename("Município" = name_muni,
                "Espécie" = species) |> 
  dplyr::mutate(Presença = 1) |> 
  as.data.frame() |> 
  dplyr::select(1:2, 4) |> 
  
  writexl::write_xlsx("matriz_registros.xlsx")

