# Pacotes ----

library(gert)

# Listando arquivos ----

gert::git_status() |> 
  as.data.frame() |> 
  dplyr::filter(file |> stringr::str_detect(".R$"))

# Adicionando arquivo ----

gert::git_add(list.files(pattern = "git_comandos.R")) |> 
  as.data.frame()

# Commitando ----

gert::git_commit("Script para comandos de Git")

# Pushando ----

## Público ----

gert::git_push(remote = "publico", force = TRUE)

## Privado ----

gert::git_push(remote = "privado", force = TRUE)

# Pullando ----

## Público ----

gert::git_pull(remote = "publico")

## Privado ----

gert::git_pull(remote = "privado")

# Resetando ----

gert::git_reset_soft(ref = "HEAD~1")

gert::git_reset_mixed()

# Removendo arquivos ----

## Removendo ----

gert::git_rm(list.files(pattern = ".xlsx$|.csv$|.png$")) |> 
  as.data.frame()

## Commitando ----

gert::git_commit("Remover arquivos")

## Pusahndo ----

gert::git_push(remote = "publico", force = TRUE)

## Pullando ----

gert::git_pull(remote = "publico")
