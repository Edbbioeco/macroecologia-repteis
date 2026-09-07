# Pacotes ----

library(readxl)

library(tidyverse)

library(sf)

library(vegan)

library(ggtext)

library(betapart)

library(ggdendro)

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

### Visualizar ----

ggplot() +
  geom_sf(data = grade, 
          aes(color = Richness |> log(),
              fill = Richness |> log())) + 
  scale_color_viridis_c(na.value = "#440154FF",
                        guide = guide_colourbar(
                          title = "Log<sub>10</sub> Richness",
                          title.position = "top",
                          title.hjust = 0.5,
                          title.theme = ggtext::element_markdown(
                            size = 20, 
                            color = "black"),
                          barwidth = 30,
                          barheight = 2,
                          frame.colour = "black",
                          ticks.colour = "black"
                        )) +
  scale_fill_viridis_c(na.value = "#440154FF",
                       guide = guide_colourbar(
                         title = "Log<sub>10</sub> Richness",
                         title.position = "top",
                         title.hjust = 0.5,
                         title.theme = ggtext::element_markdown(
                           size = 20, 
                           color = "black"),
                         barwidth = 30,
                         barheight = 2,
                         frame.colour = "black",
                         ticks.colour = "black"
                       )) +
  theme_bw() +
  theme(axis.text = element_text(size = 20, color = "black"),
        legend.text = element_text(size = 20, color = "black"),
        legend.position = "bottom",
        panel.border = element_rect(color = "black", linewidth = 1)) +
  ggview::canvas(height = 10, width = 12)

ggsave(filename = "riqueza_fom.png",
       height = 10, width = 12)

## Dissimilaridade das comunidades ----

### Calcular a dissimilaridade global ----

dis_global <- purrr::map_vec(
  1:3,
  \(id){
    
    indice <- comp |> 
      tibble::column_to_rownames(var = "ID") |> 
      betapart::beta.multi(index.family = "jaccard")
    
    indice[[id]]
    
    },
  .progress = TRUE)

dis_global

### Calcular a dissimilaridade par-a-par ----

dis_par <- purrr::map2_dfr(
  1:3,
  c("Turnover", "Nestdeness", "Jaccard"),
  \(id, indice){
    
    dis <- comp |> 
      tibble::column_to_rownames(var = "ID") |> 
      betapart::beta.pair(index.family = "jaccard")
    
    dis_matrix <- dis[[id]] |> 
      as.matrix()
    
    dis_matrix[upper.tri(dis_matrix)] <- NA
    
    dis_matrix |> 
      reshape2::melt() |> 
      tidyr::drop_na() |> 
      dplyr::filter(Var1 != Var2) |> 
      dplyr::rename("Mean dissimilarity" = 3) |> 
      dplyr::mutate(`Mean dissimilarity` = `Mean dissimilarity` |> 
                      round(2),
                    Index = indice)
    
    },
  .progress = TRUE) |> 
  tidyr::pivot_wider(names_from = Index,
                     values_from = `Mean dissimilarity`)

dis_par

### Calcular a média por cada grid ----

dis_par_trat <- dis_par |> 
  dplyr::summarise(dplyr::across(.cols = dplyr::where(is.numeric),
                                 .fns = ~.x |> mean()),
                   .by = Var1) |> 
  dplyr::rename("ID" = 1)

dis_par_trat
