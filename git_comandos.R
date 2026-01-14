# Pacotes ----

library(gert)

# Listando arquivos ----

list.files(pattern = "")

gert::git_status() |> as.data.frame()

# Adicionando arquivo ----

gert::git_add(list.files(pattern = "analises_div")) |> 
  as.data.frame()

# Commitando ----

gert::git_commit("Script para analisar a diversidade biológica")

# Pushando ----

gert::git_push(remote = "origin", force = TRUE)

# Pullando ----

gert::git_pull()

# Resetando ----

gert::git_reset_soft(ref = "HEAD~1")

gert::git_reset_hard(ref = "HEAD~1")