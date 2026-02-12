# Pacote ----

library(usethis)

# Iniciando Git ----

usethis::use_git()

# Configurando usuário e email ----

usethis::use_git_config(user.name = "Edbbioeco",
                        user.email = "edsonbbiologia@gmail.com")

# Projeto utilizado ----

usethis::proj_get()

# Settando o repositório ----

## Público ----

usethis::use_git_remote(name = "publico",
                        url = "https://github.com/Edbbioeco/macroecologia-repteis.git",
                        overwrite = TRUE)

## Privado ----

usethis::use_git_remote(name = "privado",
                        url = "https://github.com/Edbbioeco/artigo_repteis.git",
                        overwrite = TRUE)

# Criando a branch main ----

usethis::git_default_branch_configure()

# Renomear o branch do master para main ----

usethis::git_default_branch_rename(from = "master", to = "main")
