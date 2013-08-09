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
COMMAND=ponymenu
PKGNAME=ponymenu
BINCLASS=$(DATA)/misc

PROGRAM=rmixer
BOOK=rmixer
BOOKDIR=info/


all: code info

code: rmixer.class rmixer.install
rmixer.install: rmixer
	cp "$<" "$@"
	sed -i 's:-cp \.:-cp $(PREFIX)$(BINCLASS):g' "$@"
rmixer.class: rmixer.java
	javac rmixer.java


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


install: install-cmd install-license install-info

install-cmd:
	install -dm755 -- "$(DESTDIR)$(PREFIX)$(BIN)"
	install -dm755 -- "$(DESTDIR)$(PREFIX)$(BINCLASS)"
	install -m755 -- rmixer.install "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	install -m644 -- rmixer*.class "$(DESTDIR)$(PREFIX)$(BINCLASS)"

install-license:
	install -dm755 -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	install -m644 -- COPYING "$(DESTDIR)$(LICENSES)/$(PKGNAME)"

install-info: $(BOOK).info.gz
	install -dm755 -- "$(DESTDIR)$(PREFIX)$(DATA)/info"
	install -m644 -- "$(BOOK).info.gz" "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

install: all


uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(PREFIX)$(BINCLASS)/rmixer"*.class
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/COPYING"
	-rmdir -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"


clean:
	-rm -r *.{t2d,aux,cp,cps,fn,ky,log,pg,pgs,toc,tp,vr,vrs,op,ops,bak,info,pdf,ps,dvi,gz,class,install} 2>/dev/null

.PHONY: clean uninstall install

