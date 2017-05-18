DST=gud-gbeta.elc gbeta-mode.elc gbeta-font-lock.elc \
	gbeta-menu.elc gbeta-menu19.elc

default: all

all: $(DST)

%.elc: %.el
	@./compile-elisp $<

clean:
	rm *.elc
