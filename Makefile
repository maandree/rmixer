install:
	javac rmixer.java || javac7 rmixer.java
	install -m 644 rmixer.class ${DESTDIR}/usr/bin/rmixer.class
	echo '(java -cp /usr/bin/ rmixer || java7 -cp /usr/bin/ rmixer)' > ${DESTDIR}/usr/bin/rmixer

uninstall:
	unlink ${DESTDIR}/usr/bin/rmixer
