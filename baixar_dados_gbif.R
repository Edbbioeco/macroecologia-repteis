# Pacotes ----

library(sf)

library(rgbif)

library(tidyverse)

library(faunabr)

library(writexl)

# Dados ----

## Grade da FOM ----

### Importando ----

fom_grade <- sf::st_read("grade_fom.shp")

### Visualizando ----

fom_grade

ggplot() +
  geom_sf(data = fom_grade)

## Dados de ocorrência ----

### Checando o taxonkey dos répteis ----

chaves_repteis <- function(classe){
  
  chave <- rgbif::name_backbone(name = classe, 
                                rank = "class") |> 
    dplyr::pull(usageKey)
  
  chaves <<- c(chaves, chave)
  
}

chaves <- c()

classe <- c("Squamata",
            "Crocodylia",
            "Testudines")

classe

purrr::map(classe, chaves_repteis)

chaves

### Baixando ----

registros <- rgbif::occ_data(classKey = c(11592253, 11418114),
                             country = "BR",
                             hasCoordinate = TRUE,
                             limit = 1000)

### Visualizando ----

# Tratando dados ----

## Corrigindo coordenadas ----

## Filtrando coordenadas ----

## Corrigindo a taxonomia ----
