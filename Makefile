install:
	javac7 rmixer.java || javac rmixer.java
	install -m 644 rmixer*.class ${DESTDIR}/usr/bin/
	echo '(java7 -cp /usr/bin/ rmixer || java -cp /usr/bin/ rmixer)' > ${DESTDIR}/usr/bin/rmixer
	chmod 755 ${DESTDIR}/usr/bin/rmixer

uninstall:
	unlink ${DESTDIR}/usr/bin/rmixer
