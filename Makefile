PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

CC = cc
CFLAGS = -std=c99 -Wall -pedantic -Os -D_POSIX_C_SOURCE=200809L
LIBS = -lX11 -lXrandr

all: emonc waitmonc

waitmonc: waitmonc.c
	${CC} ${CFLAGS} ${LIBS} $< -o $@

clean:
	rm -f waitmonc

install: all
	mkdir -p ${PREFIX}/bin
	cp -f emonc ${PREFIX}/bin
	chmod 755 ${PREFIX}/bin/emonc
	cp -f waitmonc ${PREFIX}/bin
	chmod 755 ${PREFIX}/bin/waitmonc
	mkdir -p ${MANPREFIX}/man1
	cp -f emonc.1 ${MANPREFIX}/man1
	chmod 644 ${MANPREFIX}/man1/emonc.1

uninstall:
	rm -f ${PREFIX}/bin/emonc
	rm -f ${PREFIX}/bin/waitmonc
	rm -f ${MANPREFIX}/man1/emonc.1

.PHONY: all clean install uninstall
