readme-render:
	@quarto render README.qmd

air:
	@air format

doc:
	@R -e "devtools::document()" --quiet --no-restore --no-save

build:
	@R -e "pak::local_install(upgrade = FALSE)" --quiet --no-restore --no-save

load:
	@R -e "devtools::load_all()" --quiet --no-restore --no-save
