TARGETS = aproto.html aproto_opcodes.txt

.PHONY: all clean
.SUFFIXES: .txt .sh .html

all: $(TARGETS)

clean:
	-rm $(TARGETS)

.txt.html:
	asciidoc $<


.sh.txt:
	sh $*.sh

aproto.html: aproto.txt aproto_opcodes.txt
