# Copyright © 2012, 2013  Mattias Andrée (maandree@member.fsf.org)
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
# 
# [GNU All Permissive License]


PREFIX=/usr
BIN=/bin
DATA=/share

PROGRAM=rmixer
BOOK=$(PROGRAM)
BOOKDIR=./


all: rmixer.class info

rmixer.class: rmixer.java
	javac7 rmixer.java || javac rmixer.java


info: $(BOOK).info.gz
%.info: $(BOOKDIR)%.texinfo
	$(MAKEINFO) "$<"
%.info.gz: %.info
	gzip -9c < "$<" > "$@"


pdf: $(BOOK).pdf
%.pdf: $(BOOKDIR)%.texinfo
	texi2pdf "$<"

pdf.gz: $(BOOK).pdf.gz
%.pdf.gz: %.pdf
	gzip -9c < "$<" > "$@"

pdf.xz: $(BOOK).pdf.xz
%.pdf.xz: %.pdf
	xz -e9 < "$<" > "$@"


dvi: $(BOOK).dvi
%.dvi: $(BOOKDIR)%.texinfo
	$(TEXI2DVI) "$<"

dvi.gz: $(BOOK).dvi.gz
%.dvi.gz: %.dvi
	gzip -9c < "$<" > "$@"

dvi.xz: $(BOOK).dvi.xz
%.dvi.xz: %.dvi
	xz -e9 < "$<" > "$@"


install: all
	mkdir -p "$(PREFIX)$(BIN)"
	install -m 644 rmixer*.class "${DESTDIR}$(PREFIX)$(BIN)"
	install -m 755 rmixer "${DESTDIR}$(PREFIX)$(BIN)"
	install -m 644 COPYING "$(DESTDIR)$(PREFIX)$(DATA)/licenses/$(PROGRAM)"
	install -m 644 "$(BOOK).info.gz" "$(DESTDIR)$(PREFIX)$(DATA)/info"


uninstall:
	unlink "${DESTDIR}/usr/bin/rmixer"
	rm -r "$(DESTDIR)$(PREFIX)$(DATA)/licenses/$(PROGRAM)"
	unlink "$(DESTDIR)$(PREFIX)$(DATA)/info/$(BOOK).info.gz"


clean:
	rm -r *.{t2d,aux,cp,cps,fn,ky,log,pg,pgs,toc,tp,vr,vrs,op,ops,bak,info,pdf,ps,dvi,gz,class} 2>/dev/null || exit 0

.PHONY: clean uninstall install

