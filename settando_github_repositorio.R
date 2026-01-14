# Pacote ----

library(usethis)

# Iniciando Git ----

usethis::use_git()

# Configurando usuário e email ----

usethis::use_git_config(user.name = "Edbbioeco",
                        user.email = "edsonbbiologia@gmail.com")

# Settando o repositório ----

usethis::proj_get()

usethis::use_git_remote(name = "origin",
                        url = "https://github.com/Edbbioeco/artigo_repteis.git",
                        overwrite = TRUE)

# Renomear o branch do master para main ----

usethis::git_default_branch_configure(name = "main")

usethis::git_default_branch_rename(from = "master", to = "main")
