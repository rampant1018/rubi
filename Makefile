CFLAGS = -Wall -m32 -mstackrealign -std=gnu99 -O2
C = $(CC) $(CFLAGS)

rubi: engine.o parser.o
	$(C) -o $@ $^

engine.o: rubi.h
	$(C) -o $@ -c engine.c

parser.o: parser.h parser.c expr.c stdlib.c
	type parser.c expr.c stdlib.c > dasm.$(ARCH).c
	minilua dynasm/dynasm.lua -o parser.$(ARCH).c -D $(ARCH) dasm.$(ARCH).c
	$(C) -o $@ -c parser.$(ARCH).c

clean:
	$(RM) a.out rubi *.o *~ text *.$(ARCH).c
