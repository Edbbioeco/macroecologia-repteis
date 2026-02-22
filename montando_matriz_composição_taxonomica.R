# Pacotes ----

library(tidyverse)

library(readxl)

library(writxl)

# Dados ----

## Importando ----

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

## Visualizando ----

ls(pattern = "comunidade_") |> 
  mget(envir = globalenv())

## Unindo ----

comunidades <- ls(pattern = "comunidade_") |> 
  mget(envir = globalenv()) |> 
  dplyr::bind_rows()

comunidades

# Matriz de composição taxonomica ----

## Montando a matriz ----

comunidades |> 
  tidyr::pivot_wider(names_from = Especies,
                     values_from = Presence,
                     values_fill = 0,
                     values_fn = max)
