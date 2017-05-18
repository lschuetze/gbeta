m4_include(gbetastd.m4)m4_dnl
begin_page(`Compiling _gbeta`,' Creating Variants')

<p>
If you have _download_ref(`downloaded') the soure code, and you have
access to a _mjolner compiler, you can compile _gbeta, and
hence you can perform language design experiments with it.  Since I'd
enjoy cooperating about such endeavors, don't hesitate to
<a href="mailto:eernst@cs.au.dk">ask me</a> if you experience
problems in doing so!
</p>

<p>
Note that some special considerations are needed in connection with
<a href="`#'windows">compilation on Windows</a> platforms.
</p>

<p>
Assuming you have installed _gbeta in your home directory, you
can compile _gbeta like this:
</p>

  code_box(`cd $HOME/gbeta-1.9.11/src/main<br>beta -lq gbeta')

<p>
This will take some time.  The binary created by this compilation must
be moved to the <code>bin</code> directory of your _gbeta
installation, and it must be named in a way which shows what platform
it belongs to, i.e. you must execute one of the following commands:
</p>

<p>
On Linux: code_box(`mv gbeta ../../bin/gbeta-1.9.11-i386-linux-elf-bin')
</p>

<p>
On Sun: code_box(`mv gbeta ../../bin/gbeta-1.9.11-sparc-sun-solaris-bin')
</p>

m4_dnl <p>
m4_dnl On HP: code_box(`mv gbeta ../../bin/gbeta-1.9.11-hppa1.1-hp-hpux9-bin')
m4_dnl </p>
m4_dnl 
m4_dnl <p>
m4_dnl On the SGI platform it is necessary to move a number of auxiliary
m4_dnl dynamically loaded libraries, in order to ensure that the dynamic link
m4_dnl process succeeds: 
m4_dnl 
m4_dnl   code_box(`mv gbeta ../../bin/gbeta-1.9.11-mips-sgi-irix6-bin<br>
m4_dnl             mv sgi/gbeta*..so ../../bin')
m4_dnl </p>

<p>
That's it!  Now, assuming that you have adjusted your path to include
the _gbeta executable as explained under _installation_ref(`installation'),
you can _start_ref(`try out') your new _gbeta,
to see if your installation is basically sound.
</p>

<a name="windows">_h3(`Special Considerations on Windows')

<p>
Note that the Windows version of the source code can <em>not</em>
co-exist with versions for other platforms since Windows
does not distinguish between upper and lower case letters in
filenames, and generated filenames (sitting inside some generated
files) will consequently have modified case, and then the other
platforms cannot use those files.  To avoid these problems, just
install the Windows version in its own directory or on another disk,
keeping the files entirely separate.  This will typically be
the case for most installations under Windows, because a Windows disk
is often not shared with computers running other operating systems.
</p>

<p>
Other than that, the approach is similar to the other platforms:
</p>

  code_box(`cd c:\gbeta-1.9.11\src\main<br>beta -lq gbeta')

<p>
and:
</p>

  code_box(`mv gbeta ..\..\bin\gbetabin.exe')

_h3(`Creating Variants')

<p>
Of course there could be myriads of different ways to modify
_gbeta.  If you want to experiment with the grammar of the
language, you need the <code>dogram</code> tool which is delivered
with the __mjolner.  This tool will generate grammar tables
from your customized version of the involved grammars, and
_gbeta cannot use a changed grammar without having these
generated files.  The script <code>$GBETA_ROOT/bin/dogrammar</code>
will help you getting this right.
</p>

<p>
Changing the grammar of the language is of course potentially a very
deep change which requires a lot of changes to the static analysis and
run-time system of _gbeta.  Don't hesitate to tell me about your
adventures if you are doing such things!
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
