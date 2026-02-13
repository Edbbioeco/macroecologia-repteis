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

importar_ocorrencia <- function(arquivo, classe){
  
  occ <- readr::read_tsv(arquivo)
  
  assign(paste0("occ_", classe),
         occ,
         envir = globalenv())
  
}

arquivo <- list.files(pattern = "_gbif.csv")

arquivo

classe <- arquivo |> 
  stringr::str_replace("_", " ") |> 
  stringr::word(1)

classe

purrr::map2(arquivo, classe, importar_ocorrencia)

### Visualizando ----

ls(pattern = "occ_") |> 
  mget(envir = globalenv())

ls(pattern = "occ_") |> 
  mget(envir = globalenv()) |> 
  dplyr::glimpse()

### Unindo ----

gbif_occ <- ls(pattern = "occ_") |> 
  mget(envir = globalenv()) |> 
  dplyr::bind_rows() |> 
  dplyr::select(class, species, decimalLongitude, decimalLatitude) |> 
  tidyr::drop_na()

gbif_occ

# Recortar para a FOM ----

## Transformando em shapefile ----

## Intersectando para a FOM ----

# Matriz de composição ----

## Lista de espécies ----

## tratando as espécies ----

## Montando a matriz de composição ----

## Exportando ----