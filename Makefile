#
# makefile for `deheader'
#
VERS=$(shell sed <deheader -n -e '/version\s*=\s*"\(.*\)"/s//\1/p')

SOURCES = README COPYING NEWS deheader deheader.xml deheader.1 Makefile control deheader-logo.png

all: deheader.1

deheader.1: deheader.xml
	xmlto man deheader.xml

deheader.html: deheader.xml
	xmlto html-nochunks deheader.xml

clean:
	rm -f *~ *.1 *.html test/*.o test/*~ MANIFEST SHIPPER.*

regress:
	cd test; make --quiet regress
makeregress:
	cd test; make --quiet makeregress

pychecker:
	@ln -f deheader deheader.py
	@-pychecker --quiet --only --limit 50 deheader.py
	@rm -f deheader.py*

version:
	@echo $(VERS)

deheader-$(VERS).tar.gz: $(SOURCES)
	@ls $(SOURCES) | sed s:^:deheader-$(VERS)/: >MANIFEST
	@(cd ..; ln -s deheader deheader-$(VERS))
	(cd ..; tar -czf deheader/deheader-$(VERS).tar.gz `cat deheader/MANIFEST`)
	@ls -l deheader-$(VERS).tar.gz
	@(cd ..; rm deheader-$(VERS))

dist: deheader-$(VERS).tar.gz

release: deheader-$(VERS).tar.gz deheader.html
	shipper -u -m -t; make clean
