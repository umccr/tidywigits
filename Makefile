readme:
	@quarto render README.qmd

air:
	@air format

pkgdown:
	@R -e "pkgdown::build_site()" --quiet --no-restore --no-save

readme-pkgdown: readme pkgdown

roxydoc:
	@R -e "devtools::document()" --quiet --no-restore --no-save

build:
	@R -e "pak::local_install(upgrade = FALSE)" --quiet --no-restore --no-save

build-readme: build readme

web-preview:
	@quarto preview inst/website/index.qmd --port 4242 --no-browser --no-watch-inputs --output-dir nogit/website-tmp --embed-resources

web-render:
	@quarto render inst/website/
