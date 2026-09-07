# Pacotes ----

library(tidyverse)

library(readxl)

library(writxl)

# Dados ----

## Importando ----

comunidades <- purrr::map_dfr(
  c("gbif", 
    "specieslink", 
    "sibbr", 
    "levantamento"), 
  \(registro){
    
    readxl::read_xlsx(paste0("./registros_", registro, ".xlsx")) |> 
      dplyr::mutate(Source = registro)
    
    },
  .progress = TRUE)

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

comunidades_trat <- comunidades |> 
  tidyr::pivot_wider(names_from = Especies,
                     values_from = Presence,
                     values_fill = 0,
                     values_fn = max)

comunidades_trat

## Exportando ----

comunidades_trat |> writexl::write_xlsx("comunidades_taxonomicas.xlsx")
