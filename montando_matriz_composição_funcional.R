# Pacotes ----

library(tidyverse)

library(readxl)

library(writexl)

# Dados ----

## Dados taxonômicos ----

### Importando ----

importar_comunidades <- function(registro){
  
  comunidade <- readxl::read_xlsx(paste0("registros_",
                                         registro,
                                         ".xlsx"))
  
  assign(paste0("comunidade_", registro),
         comunidade,
         envir = globalenv())
  
}

registro <- c("gbif", "specieslink", "sibbr", "levantamento")

registro

purrr::map(registro, importar_comunidades)

### Visualizando ----

ls(pattern = "comunidade_") |> 
  mget(envir = globalenv())

### Unindo ----

comunidades <- ls(pattern = "comunidade_") |> 
  mget(envir = globalenv()) |> 
  dplyr::bind_rows()

comunidades

## Dados funcionais ----

### Importando ----

reptrat <- readxl::read_xlsx("ReptTraits dataset v1-1.xlsx")

### Visualizando ----

reptrat |> dplyr::glimpse()

reptrat

# Matriz de composição taxonomica ----

## Conferindo as especies que não estão na base de dados ----

sps <- comunidades |> dplyr::pull(Especies) |> unique()

sps

sps2 <- reptrat |> 
  dplyr::filter(Species %in% sps) |> 
  dplyr::pull(Species)

setdiff(sps, sps2)
