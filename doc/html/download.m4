m4_include(gbetastd.m4)m4_dnl
m4_define(`gbeta_ftp',`"download/$1"')m4_dnl
m4_define(`ftp_entry',
  `<a href=gbeta_ftp(`gbeta-1.9.11-$1-bin.tgz')>$2</a>
   <small>($3)</small>')m4_dnl
m4_define(`ftp_zip_entry',
  `<a href=gbeta_ftp(`gbeta-1.9.11-$1-bin.zip')>$2</a>
   <small>($3)</small>')m4_dnl
begin_page(`Downloading _gbeta')

_h3(`Binaries')

A number of binary versions are available, for the following
platforms (with a few details from the command <code>uname</code>
given in the parentheses):

<ul>
  <li>
    ftp_entry(`i386-linux-elf',`Linux/x86',
	      `Linux 2.4.23 i686 unknown')
  </li>
  <li>
    ftp_entry(`sparc-sun-solaris',`Solaris',
	      `SunOS 5.8 sun4u sparc')
  </li>
  <li>
    ftp_zip_entry(`windows',`Windows',`XP')
  </li>
</ul>

<p>
You need one or more of the above binary distributions unless you want
to compile _gbeta.  The binary for Linux should work on almost all
versions of Linux running on an i386 platform, and the binary for
Solaris should work on a wide range of SPARC/Solaris platforms.  The
binary for Windows is tested on XP but should work on NT/2000, too.
Unfortunately, there is no exact list of platforms where it works,
because I do not have access to many platforms for testing.
</p>

<p>
If you get binaries for more than one platform, they can coexist in the
same directories (except for Windows which must be installed
separately).  A shell script is used to detect what platform is
currently being used, and the relevant binary is executed (this
shell script does not work on Windows, but an MS-DOS style batch file
is provided).
</p>

<p>
When you have fetched the files you need, you can proceed with the
_installation_ref(`installation').
</p>

_h3(`Source Code')

<p>
You can download the _gbeta
<a href=gbeta_ftp(`gbeta-1.9.11-src.tgz')>source code</a> (or, for
Windows, the <a href=gbeta_ftp(`gbeta-1.9.11-src.zip')>source code in a
zip-file</a>), and this will enable you to compile _gbeta and to make
whatever experiments with it you want.  Moreover, the source code can
give you detailed information if you want to know more about how such
a language can be statically analyzed, and how it can be executed.

Since _gbeta was implemented in (standard) _beta_ref(`BETA'), you
will need a BETA compiler if you want to _compiling_ref(`compile')
your own version of _gbeta.
</p>

<p>
You can now proceed with the _installation_ref(`installation').
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
