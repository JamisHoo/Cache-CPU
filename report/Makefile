all: compile

HEADER = header.tex

SECTIONS = section1_introduction.tex \
           section2_functional.tex \
           section3_performance.tex \
           section4_environment.tex

OUTPUTDIR = output

# Please compile TWICE
compile: $(HEADER) $(SECTIONS)
	mkdir -p $(OUTPUTDIR)
	xelatex -output-directory=$(OUTPUTDIR) $< 


.PHONY: clean
clean:
	latexmk -c -outdir=$(OUTPUTDIR)
