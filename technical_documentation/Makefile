all: compile

HEADER = header.tex

SECTIONS = section1_introduction.tex \
		   section2_modules.tex \
		   section3_topEntity.tex \
		   section4_dirtree.tex

OUTPUTDIR = output/
JOBNAME = td

UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
	OPEN = xdg-open
endif
ifeq ($(UNAME), Darwin)
	OPEN = open
endif

ifeq ($(OPEN),)
	OPEN = @echo OS $(UNAME) not supported. Target file is
endif

# Please compile TWICE
compile: $(HEADER) $(SECTIONS)
	mkdir -p $(OUTPUTDIR)
	xelatex -output-directory=$(OUTPUTDIR) -jobname=$(JOBNAME) $< 

.PHONY: open
open:
	$(OPEN) $(OUTPUTDIR)$(JOBNAME).pdf

.PHONY: clean
clean:
	latexmk -c -outdir=$(OUTPUTDIR) -jobname=$(JOBNAME) $(HEADER)

.PHONY: cleanall
cleanall: clean
	$(RM) -r $(OUTPUTDIR)
