install:
	javac7 rmixer.java || javac rmixer.java
	install -m 644 rmixer*.class ${DESTDIR}/usr/bin/
	install -m 755 rmixer ${DESTDIR}/usr/bin/ > ${DESTDIR}/usr/bin/rmixer

uninstall:
	unlink ${DESTDIR}/usr/bin/rmixer
