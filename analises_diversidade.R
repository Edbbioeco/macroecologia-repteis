# Pacotes ----

library(readxl)

library(tidyverse)

library(vegan)

library(betapart)

library(ggdendro)

library(ggtext)

library(flextable)

# Dados ----

## Composição ----

### Importante ----

comp <- readxl::read_xlsx("comunidades_taxonomicas.xlsx")
