# Pacote ----

library(geobr)

library(tidyverse)

library(sf)

library(readxl)

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
  tidyr::pivot_wider(names_from = Especies,
                     values_from = Presence)

sps_trat

## Coordenadas dos locais ----

### Importar ----

coord <- readxl::read_xlsx("DADOS COPILADOS DA FOM 2026.xlsx",
                           sheet = 2)

### Visualizar ----

coord

coord |> dplyr::glimpse()
