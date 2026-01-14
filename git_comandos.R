# Pacotes ----

library(gert)

# Listando arquivos ----

list.files(pattern = ".R$")

gert::git_status() |> 
  as.data.frame() |> 
  dplyr::filter(file |> stringr::str_detect(".R$"))

# Adicionando arquivo ----

gert::git_add(list.files(pattern = "registros_repteis.R")) |> 
  as.data.frame()

# Commitando ----

gert::git_commit("Script para organizar os dados de registros de répteis")

# Pushando ----

gert::git_push(remote = "origin", force = TRUE)

# Pullando ----

gert::git_pull()

# Resetando ----

gert::git_reset_soft(ref = "HEAD~1")

gert::git_reset_hard(ref = "HEAD~1")