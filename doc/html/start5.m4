m4_include(startstd.m4)m4_dnl
begin_page(`GNU Emacs Integration')

<p>
To obtain an environment which has much better scalability for
programs consisting of many fragment groups (source code files),
try to run _gbeta from GNU Emacs.  This environment offers a
more "visually" oriented interaction as well.
</p>

_h3(`Setting up Emacs')

<p>
Assuming that you have access to GNU Emacs and already use it, you
probably have a file <code>~/.emacs</code> which contains your
personal Emacs initialization code, or possibly some other file
such as <code>~/.gnu-emacs</code> which is used for GNU Emacs
initialization.  If you do not have this file, just create it
with the contents given below, otherwise add these few lines
somewhere in the file, e.g., at the end.
</p>

program_box(cq[[(defvar gbeta-version (getenv "GBETA_VERSION"))
(if (not gbeta-version) (setq gbeta-version "1.9.11"))
(defvar gbeta-basedir (getenv "GBETA_BASEDIR"))
(if (not gbeta-basedir) (setq gbeta-basedir (concat "~/gbeta-" gbeta-version)))
(setq load-path (append (list (concat gbeta-basedir "/emacs")) load-path))
(load-library "gud-gbeta")
(load-library "gbeta-mode")
(load-library "gbeta-font-lock")
(setq auto-mode-alist (append '(("\\.gb$" . gbeta-mode)) auto-mode-alist))]]nq)

<p>
By the way, you can also find this in the file
<code>gbeta.emacs</code> in the distribution.  For Windows, there
is a variant of this file called <code>gbeta.msemacs</code>.
</p>

_h3(`Starting Emacs, under X..')

<p>
Initially, go to the <code>start</code> directory, i.e. with a
standard installation:
</p>

  code_box(`cd $HOME/gbeta-1.9.11/examples/start')

<p>
Now you can start up Emacs and load a source code file:
</p>

  code_box(`emacs beer.gb &amp;')

<p>
It is assumed that you are running under X Windows, such that Emacs is
able to point out selected portions of the source code by changing a
visual attribute such as the background color of the text within that
region.  This is very important for the interaction.  Of course you
can load the source code file from within an already running instance
of Emacs if you prefer.
</p>

_h3(`Some Emacs terminology')

<p>
Emacs may have more than one "frame," and each frame may have more
than one "window."  Since the Emacs terminology collides with the
general terminology of common GUIs, we'll shortly recapitulate the
Emacs terms here:  An Emacs <em>frame</em> is the graphical unit which
is decorated by the window manager (e.g. with a titlebar and a
border), and which can be moved, resized, iconified, raised, lowered,
and so on.  An Emacs <em>window</em> is a vertical or horizontal band
of an Emacs frame, showing a portion of one buffer.  These concepts
are important because there is normally an execution window showing
a debugging buffer, and a source code
window showing one of a number of source code buffers containing the
program being executed.  The interaction is different when the
execution window is active and when the source code window is
active. 
</p>

_h3(`Starting the execution')

<p>
To initiate an interactive execution of the program in the newly
loaded buffer, ensure that the window showing that buffer is the
currently active window (click in it).  Then do:
</p>

  code_box(`M-x gbeta')

<p>
This is standard Emacs notation for pressing the Meta-modifier
(possibly labeled with "Alt", "AltGr" or a small rhombus) along with
the "x" key and then typing <code>"gbeta[ENTER]"</code>.  This leads
to a prompt in the bottommost line of the frame (the "minibuffer"):
</p>

  code_box(`Run gbeta (like this): /.../gbeta beer.gb')

<p>
where <code>...</code> stands for the full path to the gbeta script.
At this prompt you can edit the command line for invoking
_gbeta to e.g. add various options, but normally accepting the
default by pressing <code>[ENTER]</code> is appropriate.
</p>

<p>
This starts up an interactive _gbeta session in one window and
shows the source code file containing the first statement of the
program in another window.  The file shown is not necessarily the same
as the argument given to _gbeta, since the
_modularization_ref(`fragment system') makes it possible to insert
your program into some larger context. 
</p>

<p>
The _next_start_ref(next) section deals with the interaction within an
Emacs-based _gbeta session.  As a rule of thumb, however, you can just
start using what you already know from the command line interaction.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
