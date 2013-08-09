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
COMMAND=rmixer
PKGNAME=rmixer
BINCLASS=$(DATA)/misc

PROGRAM=rmixer
BOOK=rmixer
BOOKDIR=info/


all: code info shell

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

shell:  bash fish zsh

bash: rmixer.bash-completion
zsh: rmixer.zsh-completion
fish: rmixer.fish-completion

rmixer.%sh-completion: rmixer.auto-completion
	auto-auto-complete "$*sh" --output "$@" --source "$<"



install: install-cmd install-license install-info install-shell

install-cmd: code
	install -dm755 -- "$(DESTDIR)$(PREFIX)$(BIN)"
	install -dm755 -- "$(DESTDIR)$(PREFIX)$(BINCLASS)"
	install -m755 -- rmixer.install "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	install -m644 -- rmixer*.class "$(DESTDIR)$(PREFIX)$(BINCLASS)"

install-license:
	install -dm755 -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	install -m644 -- COPYING "$(DESTDIR)$(LICENSES)/$(PKGNAME)"

install-info: info
	install -dm755 -- "$(DESTDIR)$(PREFIX)$(DATA)/info"
	install -m644 -- "$(BOOK).info.gz" "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

install-shell: install-bash install-fish install-zsh

install-bash: bash
	install -Dm644 -- rmixer.bash-completion "$(DESTDIR)$(PREFIX)$(DATA)/bash-completion/completions"/rmixer

install-zsh: zsh
	install -Dm644 -- rmixer.zsh-completion "$(DESTDIR)$(PREFIX)$(DATA)/zsh/site-functions"/_rmixer

install-fish: fish
	install -Dm644 -- rmixer.fish-completion "$(DESTDIR)$(PREFIX)$(DATA)/fish/completions"/rmixer.fish



uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(PREFIX)$(BINCLASS)/rmixer"*.class
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/COPYING"
	-rmdir -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"
	-rm    -- "$(DESTDIR)$(PREFIX)$(DATA)/bash-completion/completions"/rmixer
	-rm    -- "$(DESTDIR)$(PREFIX)$(DATA)/zsh/site-functions"/_rmixer
	-rm    -- "$(DESTDIR)$(PREFIX)$(DATA)/fish/completions"/rmixer.fish



clean:
	-rm -r *.{t2d,aux,cp,cps,fn,ky,log,pg,pgs,toc,tp,vr,vrs,op,ops,bak,info,pdf,ps,dvi,gz,class,install,*sh-completion} 2>/dev/null

.PHONY: clean uninstall install-zsh install-fish install-bash install-shell install-license install-cmd install zsh fish bash shell dvi pdf info code all

