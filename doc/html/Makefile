WWWDIR=$(HOME)/public_html/gbeta

PAGES = \
	beta.html \
	bugs.html \
	compatibility.html \
	compiling.html \
	copyright.html \
	download.html \
	faq.html \
	installation.html \
	intro.html \
	lazy.html \
	news.html \
	papers.html \
	advanced.html \
	modularization.html \
	start.html \
	tutorial.html 

ADVPAGES = advtopics.html \
	adv1.html \
	adv2.html \
	adv3.html \
	adv4.html \
	adv5.html \
	adv6.html \
	adv7.html \
	adv8.html \
	adv9.html 

MODPAGES = modtopics.html \
	mod1.html \
	mod2.html \
	mod3.html \
	mod4.html \
	mod5.html 

STARTPAGES = starttopics.html \
	start1.html \
	start2.html \
	start3.html \
	start4.html \
	start5.html \
	start6.html \
	start7.html \
	start8.html \
	start9.html 

TUTPAGES = tuttopics.html \
	tut1.html \
	tut2.html \
	tut3.html \
	tut4.html \
	tut5.html \
	tut6.html \
	tut7.html \
	tut8.html \
	tut9.html \
	tut10.html \
	tut11.html \
	tut12.html \
	tut13.html \
	tut14.html \
	tut15.html \
	tut16.html 

SUBPAGES = $(ADVPAGES) $(MODPAGES) $(STARTPAGES) $(TUTPAGES)

%.html: %.m4 Makefile gbetastd.m4
	( export FOCUS; FOCUS=$*; m4 -P $< > $*.html )
	chmod 644 $*.html

default: all
	@make -s install

##### Dependency rules for subpages

adv1.html: advancedstd.m4
adv2.html: advancedstd.m4
adv3.html: advancedstd.m4
adv4.html: advancedstd.m4
adv5.html: advancedstd.m4
adv6.html: advancedstd.m4
adv7.html: advancedstd.m4
adv8.html: advancedstd.m4
adv9.html: advancedstd.m4

mod1.html: modularizationstd.m4
mod2.html: modularizationstd.m4
mod3.html: modularizationstd.m4
mod4.html: modularizationstd.m4
mod5.html: modularizationstd.m4

start1.html: startstd.m4
start2.html: startstd.m4
start3.html: startstd.m4
start4.html: startstd.m4
start5.html: startstd.m4
start6.html: startstd.m4
start7.html: startstd.m4
start8.html: startstd.m4
start9.html: startstd.m4

tut1.html: tutorialstd.m4
tut2.html: tutorialstd.m4
tut3.html: tutorialstd.m4
tut4.html: tutorialstd.m4
tut5.html: tutorialstd.m4
tut6.html: tutorialstd.m4
tut7.html: tutorialstd.m4
tut8.html: tutorialstd.m4
tut9.html: tutorialstd.m4
tut10.html: tutorialstd.m4
tut11.html: tutorialstd.m4
tut12.html: tutorialstd.m4
tut13.html: tutorialstd.m4
tut14.html: tutorialstd.m4
tut15.html: tutorialstd.m4
tut16.html: tutorialstd.m4


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
