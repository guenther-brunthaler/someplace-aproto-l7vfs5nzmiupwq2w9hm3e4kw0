TARGETS = new_encoding.html aproto_opcodes.txt

.PHONY: all clean
.SUFFIXES: txt sh html

all: $(TARGETS)

clean:
	-rm $(TARGETS)

.txt.html:
	asciidoc $<


.sh.txt:
	$*.sh

new_encoding.html: new_encoding.txt aproto_opcodes.txt
