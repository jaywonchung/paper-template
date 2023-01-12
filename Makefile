FILE = perseus-nsdi24
TARGET = $(FILE).pdf

OPEN_COMMAND :=
ifeq ($(shell uname -s),Linux)
	OPEN_COMMAND += xdg-open
else ifeq ($(shell which zathura),)
	OPEN_COMMAND += open -a Preview
else
	OPEN_COMMAND += zathura
endif

.PHONY: clean view

$(TARGET): *.tex *.bib figures/**
	rm -f $(FILE).aux $(FILE).bbl $(FILE).blg $(FILE).log $(FILE).dvi $(FILE).ps $(FILE).out $(FILE).thm $(FILE).fls $(FILE).fdb_latexmk
	pdflatex -synctex=1 $(FILE)
	bibtex $(FILE)
	pdflatex -synctex=1 $(FILE)
	pdflatex -synctex=1 $(FILE)
	# Split into maintext and appendices
	# qpdf $(TARGET) --pages . 1-17 -- $(FILE)-main-ref.pdf
	# qpdf $(TARGET) --pages . 18-z -- $(FILE)-apdx.pdf
	# Embed fonts
	# gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=perseus-nsdi24-embedded.pdf perseus-nsdi24.pdf

clean:
	rm -f $(FILE).aux $(FILE).bbl $(FILE).blg $(FILE).log $(TARGET) $(FILE).dvi $(FILE).ps $(FILE).out $(FILE).fls $(FILE).fdb_latexmk $(FILE).synctex.gz

view: $(FILE)-view.pdf
	$(OPEN_COMMAND) $(TARGET) &
	disown

continuous:
	latexmk -pdf -bibtex perseus-nsdi24.tex -pvc
