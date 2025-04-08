FILE = paper-osdi17
TARGET = $(FILE).pdf
EMBEDDED_TARGET = $(FILE)-embedded.pdf
FIGS := $(shell find figures -type f -name '*.pdf')

.PHONY: clean

$(TARGET): *.tex sections/*.tex *.bib $(FIGS)
	rm -f $(FILE).aux $(FILE).bbl $(FILE).blg $(FILE).log $(FILE).dvi $(FILE).ps $(FILE).out $(FILE).thm $(FILE).fls $(FILE).fdb_latexmk
	pdflatex -synctex=1 $(FILE)
	bibtex $(FILE)
	pdflatex -synctex=1 $(FILE)
	pdflatex -synctex=1 $(FILE)
	# Split into maintext and appendices
	qpdf $(TARGET) --pages . 1-15 -- $(FILE)-main.pdf
	qpdf $(TARGET) --pages . 16-z -- $(FILE)-apdx.pdf
	# Embed fonts
	# gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=$(EMBEDDED_TARGET) $(TARGET)

clean:
	rm -f $(FILE).aux $(FILE).bbl $(FILE).blg $(FILE).log $(TARGET) $(FILE).dvi $(FILE).ps $(FILE).out $(FILE).fls $(FILE).fdb_latexmk $(FILE).synctex.gz *.pdf
