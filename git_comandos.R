# Pacotes ----

library(gert)

# Listando arquivos ----

list.files(pattern = "")

# Adicionando arquivo ----

gert::git_add(list.files(pattern = "settando_")) |> 
  as.data.frame()

# Commitando ----

gert::git_commit("Script para settar repositório git")

# Pushando ----

gert::git_push(remote = "origin", force = TRUE)

# Pullando ----

gert::git_pull()

# Resetando ----

gert::git_reset_soft(ref = "HEAD~1")

gert::git_reset_hard(ref = "HEAD~1")

gert::git_merge(ref = "master")
