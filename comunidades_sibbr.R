# Pacotes ----

library(sf)

library(tidyverse)

library(sf)

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

occ_sibbr <- readr::read_csv2("sibbr.csv", quote = ";")

### Visualizando ----

occ_sibbr

occ_sibbr |>  dplyr::glimpse()

# Recortar para a FOM ----

## Transformando em shapefile ----

sibbr_sf <- occ_sibbr |> 
  dplyr::filter(!decimalLongitude |> is.na() &
                  !decimalLatitude |> is.na() &
                  !Species |> is.na()) |> 
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
               crs = 4674)

sibbr_sf

ggplot() +
  geom_sf(data = sibbr_sf)

## Intersectando para a FOM ----

sibbr_sf_fom <- sibbr_sf |> 
  sf::st_intersection(grade |> 
                        dplyr::summarise(geometry = geometry |> 
                                           sf::st_union()))

sibbr_sf_fom

ggplot() +
  geom_sf(data = grade) +
  geom_sf(data = sibbr_sf_fom)

# Matriz de composição ----

## Lista de espécies ----

sibbr_sf_fom |> 
  dplyr::pull(Species) |> 
  unique()

## tratando as espécies ----

sibbr_sf_fom <- sibbr_sf_fom |> 
  dplyr::mutate(Species = dplyr::case_match(
    Species,
    "Tomodon dorsatum"             ~ "Tomodon dorsatus",
    "Tupinambis merianae"          ~ "Salvator marianae",
    "Mabuya frenata"               ~ "Notomabuya frenata",
    "Anisiolepis grilli"           ~ "Urostrophus grilli",
    "Mabuya dorsivittata"          ~ "Aspronema dorsivittatum",
    "Sibynomorphus neuwiedi"       ~ "Dipsas neuwiedi",
    "Liotyphlops beui"             ~ "Liotyphlops ternetzii",
    "Amphisbaena darwini trachura" ~ "Amphisbaena darwinii",
    "Pantodactylus schreibersii"   ~ "Cercosaura schreibersii",
    "Bothrops neuwiedi diorus"     ~ "Bothrops neuwiedi",
    "Mastigodryas bifossatus"      ~ "Palusophis bifossatus",
    "Liophis miliaris"             ~ "Erythrolamprus miliaris",
    "Sibynomorphus mikanii"        ~ "Dipsas mikanii",
    "Liophis jaegeri"              ~ "Erythrolamprus jaegeri",
    "Phalotris iheringii"          ~ "Phalotris lemniscatus",
    "Thamnodynastes hypoconia"     ~ "Dryophylax hypoconia",
    "Thamnodynastes strigatus"     ~ "Mesotes strigatus",
    "Atractus taeniatus"           ~ "Atractus paraguayensis",
    "Crotalus durissus terrificus" ~ "Crotalus durissus",
    "Echinanthera affinis"         ~ "Dibernardia affinis",
    "Bothrops newwiedi"            ~ "Bothrops neuwiedi",
    c("Bothrops trigemina", 
      "Anolis philopunctatus", 
      "Lygophis lineatus", 
      "Tupinambis teguixin", 
      "Bothrops neuwiedi paranaensis", 
      "Heterodactylus imbricatus", 
      "Dipsas indica", 
      "Boiruna maculata", 
      "Clelia plúmbea", 
      "Xenodon biligonigerus")      ~ NA_character_,
    .default = Species
  ))

sibbr_sf_fom

## Montando a matriz de composição ----

sibbr_registros <- sibbr_sf_fom |> 
  sf::st_join(grade) |> 
  as.data.frame() |> 
  dplyr::mutate(Especies = Species,
                Presence =  1) |> 
  dplyr::select(ID, Especies, Presence) 

sibbr_registros

## Exportando ----

sibbr_registros |> writexl::write_xlsx("registros_sibbr.xslx")
