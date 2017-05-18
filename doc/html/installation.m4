m4_include(gbetastd.m4)m4_dnl
begin_page(Installation of _gbeta)

<p>
Installation has several aspects.  First installation of
<a href="`#'source">source code</a> is covered, and then
the <a href="`#'binary">binary distributions</a> are treated.  
The Windows platforms are discussed <a href="`#'windows">separately</a>.
</p>

<p>
If you want to install in <a href="`#'nonstandard">another place than your
home</a> directory, e.g., because you are an administrator of a
multi-user system, you must adjust a few things.  Finally, no matter
what platform you're using and no matter where you installed, you must
<a href="`#'path">enhance your path</a> to include the place where the
_gbeta script is located, and you are ready to
<a href="`#'check">check</a> that your installation works.
</p>

<a name="source">_h3(`Source Code')

<p>
If you have _download_ref(`downloaded') the source code, i.e. the
file <code>gbeta-1.9.11-src.tgz</code>, then you probably wish to
unpack it, otherwise you may skip directly to the <a
href="`#'binary">installation of binaries</a>.
</p>

<p>
You will get a standard installation of the source code by unpacking
it in your home directory:
</p>

  code_box(`cd $HOME')

<p>
For installations elsewhere, see <a href="`#'nonstandard">below</a>.
Assuming that you have put <code>gbeta-1.9.11-src.tgz</code> in your
home directory, you can unpack the archive with:
</p>

  code_box(`gtar xzf gbeta-1.9.11-src.tgz')

<p>
If you are running Linux, <code>gtar</code> is available as
<code>tar</code>:
</p>

  code_box(`tar xzf gbeta-1.9.11-src.tgz')

<p>
and if you are running on another platform where <code>gtar</code> is
not available, the following should work:
</p>

  code_box(`gunzip gbeta-1.9.11-src.tgz<BR>tar xf gbeta-1.9.11-src.tar')

<p>
There are a couple of things you might like to know if you want to
_compiling_ref(`compile') your own version of _gbeta.
<p>

<a name="binary">_h3(`Binaries')

<p>
If you have _download_ref(`downloaded') one or more binary
distributions of _gbeta, you'll need to unpack them, and the standard
place to do this is your home directory: 
</p>

  code_box(`cd $HOME<br>')

<p>
Again, <a href="`#'nonstandard">alternative placements</a> are possible.
Then, on Linux:  
</p>

  code_box(`tar xzf gbeta-1.9.11-i386-linux-elf-bin.tgz')

<p>
On Sun:
</p>

  code_box(`gtar xzf gbeta-1.9.11-sparc-sun-solaris-bin.tgz')

<p>
You may have to use slightly different versions of these commands,
just like <a href="`#'source">above</a>, depending on the kind of
<code>tar</code> your system provides.
</p>

<a name="path">_h3(`Adjusting the <code>PATH</code>')

<p>
The <code>PATH</code> environment variable must be enhanced to include
the position of the script <code>gbeta</code> which is used to invoke
_gbeta.  Since _gbeta needs a few environment
variables you cannot just run it on its own, and the script is there
to select the right platform and to provide the correct environment.
In a standard installation, this could be achieved by adding one extra
statement in your shell startup script:
</p>

  code_box(``#' users of sh family shells (sh,bash,ksh,pdksh,ash..)<BR>
            `#' would add this to ~/.profile or ~/.bash_profile or ..<BR>
            PATH=$PATH:$HOME/gbeta-1.9.11/bin')

<p>
or 
</p>

  code_box(``#' users of csh family shells (csh,tcsh)<BR>
            `#' would add this to ~/.login<BR>
            setenv PATH $PATH:$HOME/gbeta-1.9.11/bin')

<p>
If you prefer that, it is of course possible to use other approaches
than changing your path, e.g.
</p>

  code_box(`alias gbeta=$HOME/gbeta-1.9.11/bin/gbeta')

<p>
Now you are ready to _start_ref(`try out') your installation by
using _gbeta for some basic tasks. 
</p>

<a name="windows">_h3(`Special issues with the Windows version')

<p>
On the Windows platforms, special considerations are needed because of
the file system (which is case insensitive, and uses "drive letters"
such as <code>C:</code> or <code>D:</code>),
because the shell script language is different and less capable,
and because tools like <code>tar</code> cannot be assumed to be
available.
</p>

<p>
First, you will need to _download_ref(`download') the _gbeta
distribution for Windows.  It is a <code>zip</code>-file, and the
standard place to unpack it is in <code>C:\</code>.  This will create
a directory <code>C:\gbeta-1.9.11</code>, with the _gbeta executable
and all the support and example files in various subdirectories
thereof.
</p>

<p>
If you unpack the _gbeta distribution some other place than
<code>C:\</code> then you will need to edit the file
<code><i>installdir</i>\gbeta-1.9.11\bin\gbeta.bat</code>, in order to
ensure that the environment variable <code>GBETA_ROOT</code> actually
points to the root directory of the installation, 
<code><i>installdir</i>\gbeta-1.9.11</code>.  It is indicated
inside <code>gbeta.bat</code> where to make this change, and it only
involves editing one line of the file.
</p>

<p>
Next, copy <code>%GBETA_ROOT%\bin\gbeta.bat</code> into some directory
in your <code>PATH</code>, such that you can execute _gbeta simply as
<code>gbeta</code>, without giving the full path to it.
</p>

<p>
Note that there is a problem with source code highlighting in the
command prompt on newer Windows platforms, and this means that a
_gbeta debugging or exploration session (using option <code>-i</code>)
is impractical in a command prompt window.  Hence, _gbeta debugging
and exploration sessions on Windows platforms should be carried out
under Emacs.  The problem is that there is no support for ANSI escape
sequences in newer versions of the Windows command prompt.  Under
older versions of Windows, ANSI escape sequences can be enabled by
having a <code>device=c:\windows\system32\ansi.sys</code> command in
the <code>CONFIG.SYS</code>.  If in doubt, try to add such a command
(note that the exact path to <code>ansi.sys</code> may need to be
adjusted to match your installation of Windows).
For the initial experiments described in _start_ref(`"Getting
Started"'), it should be manageable to run _gbeta from the command
prompt with option <code>-cn</code> which does not use escape
sequences, but it is recommended to use Emacs as soon as possible.
</p>

<p>
A Windows version of GNU Emacs can be downloaded from here:
_xxref(`ftp://ftp.cs.washington.edu/pub/ntemacs/latest/').  This
version of _gbeta (1.9.11) was tested with version 20.7 of GNU Emacs
on Windows XP.
</p>

<p>
Now you are ready to _start_ref(`try out') your installation by
using _gbeta for some basic tasks. 
</p>

<a name="nonstandard">_h3(`Installing Elsewhere')

<p>
It is possible to install _gbeta in a different place than your home
directory.  Assuming that you have unpacked the files in the directory
<code><i>MYDIR</i></code>, you must edit the script which is used to
invoke _gbeta.  With e.g. emacs as the editor that amounts to:
</p>

  code_box(`cd <i>MYDIR</i>/gbeta-1.9.11/bin<BR>
            chmod u+w gbeta<BR>emacs gbeta')

<p>
In the editor you should change the assignment of
<code>GBETA_ROOT</code> to:
</p>

program_box(cq[[...
GBETA_ROOT=${GBETA_ROOT:-<i>MYDIR</i>/gbeta-$GBETA_VERSION}

`#' ----- INSTALL END ----- 
...]]nq)

<p>
Alternatively, you can leave the <code>gbeta</code> script unchanged
and assign to the evironment variable <code>GBETA_ROOT</code>, by
putting the following into your shell startup file:
</p>

program_box(`
`#' for sh-family shells:
export GBETA_ROOT=<i>MYDIR</i>/gbeta-1.9.11

`#' for csh-family shells:
setenv GBETA_ROOT <i>MYDIR</i>/gbeta-1.9.11')

<p>
Please note that creating an alias or similar to make it possible to
execute the <code>gbeta</code> script is not sufficient when
_gbeta is installed in another place than your home directory:
the grammar specifications can not be found if <code>GBETA_ROOT</code>
does not point to the right directory.
</p>

<p>
<strong>For system administrators</strong> of UNIX-like multi-user
systems wishing to install _gbeta such that all users on the system
can use it, the following should work:

<ul>
  <li>Untar the binary distribution in a suitable place, e.g.,
      in <code>/opt</code> or in <code>/usr/local</code>.</li>
  <li>Change the owner and permissions such that all users may
      execute the scripts in the <code>bin</code> directory of
      the _gbeta installation and read all files
      everywhere in the installation, but no file in there
      is writable by anybody but the owner. 
      The owner could be a fresh owner named <code>gbeta</code>.</li>
  <li>Instruct users to set <code>$GBETA_ROOT</code>, and to add the 
      directory <code>$GBETA_ROOT/bin</code> to their
      <code>$PATH</code>.  Alternatively, put up a link somewhere in
      the <code>$PATH</code> that people already have, pointing to
      <code>$GBETA_ROOT/bin/gbeta</code>, but note that people must
      still set the variable <code>$GBETA_ROOT</code> unless this is
      done in <code>/etc/profile</code> or elsewhere globally.
  <li>Since _gbeta source files are translated to files containing
      abstract syntax trees in the same location, ordinary users cannot
      run the example programs where they are installed (because they
      get a permission violation error when the abstract syntax
      files are generated), so they must be instructed to copy the 
      examples to their home directories before running them.
  <li>Off they go!</li>
</ul>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
