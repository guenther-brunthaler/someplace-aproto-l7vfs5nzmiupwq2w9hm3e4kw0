TARGETS = aproto.html

.PHONY: all clean
.SUFFIXES: .txt .sh .html

all: $(TARGETS)

clean:
	-rm $(TARGETS)

.txt.html:
	asciidoc $<


.sh.txt:
	sh $*.sh

aproto.html: aproto.txt
