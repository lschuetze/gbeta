m4_include(gbetastd.m4)m4_dnl
m4_dnl
WWWDIR=$(HOME)/public_html/gbeta

PAGES = foreach(`\
	$1.html ',topic_list,subtopic_list)

ADVPAGES = advtopics.html foreach(`\
	adv$1.html ',adv_numbers)

MODPAGES = modtopics.html foreach(`\
	mod$1.html ',mod_numbers)

STARTPAGES = starttopics.html foreach(`\
	start$1.html ',start_numbers)

TUTPAGES = tuttopics.html foreach(`\
	tut$1.html ',tut_numbers)

SUBPAGES = $(ADVPAGES) $(MODPAGES) $(STARTPAGES) $(TUTPAGES)

%.html: %.m4 Makefile gbetastd.m4
	( export FOCUS; FOCUS=$*; m4 -P $< > $*.html )
	chmod 644 $*.html

default: all
	@make -s install

##### Dependency rules for subpages

foreach(`adv$1.html: advancedstd.m4
',adv_numbers)
foreach(`mod$1.html: modularizationstd.m4
',mod_numbers)
foreach(`start$1.html: startstd.m4
',start_numbers)
foreach(`tut$1.html: tutorialstd.m4
',tut_numbers)

##### Auxiliary rules

all: make_file index.html topics.html $(PAGES) $(SUBPAGES)

make_file: Makefile.m4
	m4 -P Makefile.m4 > make_file
	cp -f make_file Makefile
	chmod 644 Makefile

showtopics:
	ls *.m4 | grep -ve '[0-9A-G]\.m4' | grep -ve numbers

install:
	if [ -d $(WWWDIR) ]; then make -s uninstall; fi
	mkdir $(WWWDIR){,/style,/download}
	cp *.html *.jpg *.gif ../../COPYING $(WWWDIR)
	find style -type f ! -path '*/.svn/*' -exec cp {} $(WWWDIR)/{} \;
	cp ../../../releases/gbeta-1.9.11* $(WWWDIR)/download
	find $(WWWDIR) -type f -exec chmod 444 {} \;
	find $(WWWDIR) -type d -exec chmod 755 {} \;

uninstall:
	find $(WWWDIR) -type d -exec chmod 755 {} \;
	rm -rf $(WWWDIR)

rsync:
	make -s install
	../../bin/rsync_html gbeta
