# Pacotes ----

library(geobr)

library(rgbif)

library(tidyverse)

library(sf)

library(faunabr)

library(writexl)

# Dados ----

## Sul do Brasil ----

### Importando ----

### Visualizando ----

## Dados de ocorrência ----

### Checando o taxonkey dos répteis ----

chave <- rgbif::name_backbone(name = "Reptilia", rank = "class") |> 
  dplyr::pull(usageKey)

chave

### Baixando ----

registros <- rgbif::occ_data(taxonKey = chave,
                country = "BR",
                hasCoordinate = TRUE,
                limit = 20000)

### Visualizando ----

registros

registros |> dplyr::glimpse()

# Tratando dados ----

## Corrigindo coordenadas ----

## Filtrando coordenadas ----

## Corrigindo a taxonomia ----