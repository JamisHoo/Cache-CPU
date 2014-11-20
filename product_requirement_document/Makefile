all: compile

HEADER = header.tex

OUTPUTDIR = output/
JOBNAME = prd

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
compile: $(HEADER)
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
