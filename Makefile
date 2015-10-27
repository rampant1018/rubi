CFLAGS = -Wall -m32 -mstackrealign -std=gnu99 -O2
C = $(CC) $(CFLAGS)

rubi: engine.o expr.o parser.o stdlib.o
	$(C) -o $@ $^

%.$(ARCH).c: %.c
	minilua dynasm/dynasm.lua -o $@ -D $(ARCH) $<

engine.o: rubi.h engine.$(ARCH).c
	$(C) -o $@ -c engine.$(ARCH).c

expr.o: expr.h expr.$(ARCH).c asm.h
	$(C) -o $@ -c expr.$(ARCH).c

parser.o: parser.h parser.$(ARCH).c asm.h
	$(C) -o $@ -c parser.$(ARCH).c

stdlib.o: stdlib.c asm.h expr.h
	$(C) -c stdlib.c

clean:
	$(RM) a.out rubi *.o *~ text *.$(ARCH).c
