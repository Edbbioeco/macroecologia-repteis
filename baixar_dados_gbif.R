# Pacotes ----

library(geobr)

library(rgbif)

library(tidyverse)

library(sf)

library(faunabr)

library(writexl)

# Dados de ocorrência ----

## Checando o taxonkey dos répteis ----

chave <- rgbif::name_backbone(name = "Reptilia", rank = "class") |> 
  dplyr::pull(usageKey)

chave

## Baixando dados ----

registros <- rgbif::occ_data(taxonKey = chave,
                country = "BR",
                hasCoordinate = TRUE,
                limit = 20000)

registros

# Tratando dados ----

## Corrigindo coordenadas ----

## Filtrando coordenadas ----

## Corrigindo a taxonomia ----