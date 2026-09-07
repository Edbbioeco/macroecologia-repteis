# Pacotes ----

library(readxl)

library(tidyverse)

library(sf)

library(vegan)

library(betapart)

library(ggdendro)

library(ggtext)

library(flextable)

# Dados ----

## Composição ----

### Importar ----

comp <- readxl::read_xlsx("comunidades_taxonomicas.xlsx")

### Visualizar ----

comp

comp |> dplyr::glimpse()

## Grade das Florestas Ombrófilas Mistas ----

### Importar ----

grade <- sf::st_read("grade_fom.shp")

### Visualizar ----

grade

ggplot() +
  geom_sf(data = grade, color = "black")

# Diversidade ----

## Riqueza ----

### Calcular riqueza ----

riq <- comp |> 
  tibble::column_to_rownames(var = "ID") |> 
  vegan::specnumber() |> 
  as.data.frame() |> 
  tibble::rownames_to_column() |> 
  dplyr::rename("ID" = 1,
                "Richness" = 2)

riq

### Adicionar as informações de riqueza na grade ----

grade <- grade |> 
  dplyr::left_join(riq, by = "ID") |> 
  dplyr::mutate(Richness = dplyr::case_when(
    
    Richness |> is.na() ~ 0,
    .default = Richness
    
    ))

grade
