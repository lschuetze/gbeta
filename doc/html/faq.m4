m4_include(gbetastd.m4)m4_dnl
m4_define(`_question',`<p><hr></p><p>
<a name="Q$1"><strong>Q$1: $2</strong>
<p><strong>A: </strong>$3</p>')
m4_define(`_qref',`<a href="Q$1">$2</a>')
begin_page(FAQ for _gbeta)

<p>
This is a list of Frequently Asked Questions for _gbeta, both
the language and the environment.  
</p>

<p>
I'll put more questions &amp; answers in here as soon as they
get frequent ;-), hence: Don't hesitate to 
<a href="mailto:eernst@cs.au.dk">tell me</a> when you think
something is missing!
</p>

<!------------------------------------------------------------------------>
cq
_question(1,[[Why can't I run my existing BETA program 
              under _gbeta?]], [[There are some low-level differences
between the _mjolner implementation of BETA and the _gbeta
implementation which makes it impossible to run Mjolner BETA code
directly with _gbeta.  Check out the
_compatibility_ref(`compatibility') section for details.  A future 
release will contain a slightly adapted version of the Mjolner basic
libraries that will work with _gbeta.  Even then, however, support for
calling external code (such as compiled C) is probably not ready, and
lots of the libraries of the __mjolner use externals, e.g. to create
BETA-bindings for GUI APIs.]])
nq

<!------------------------------------------------------------------------>
_question(2,cq[[Why doesn't _gbeta discover my source code changes?]],
[[During an interactive session, e.g. under Emacs, it is possible and
often relevant to change the source code of the program being
executed, but _gbeta will not notice the changes, and the
color coding in the source code window will still correspond to the
original program, as when the execution started.  It probably
looks as if the colored block is an arbitrary part of the source code,
and not the currently executing statement.  Even <code>kill</code>ing
and <code>restart</code>ing the execution does not solve the
problem. 
</p>

<p>
This is because _gbeta reads the source code at startup, then builds
an internal representation of the program, an abstract syntax tree,
and then decorates this abstract syntax tree with static analysis
information and executes.  It never looks at the text files after
the startup phase. 
</p>

<p>
To refresh _gbeta's picture of the program, <code>quit</code> the
session and start a new one.  In Emacs you should kill the _gbeta
interactive buffer (<code>C-xk</code>) and execute the 
<code>M-x gbeta</code> command from the main source code buffer
again: the debugger framework of Emacs, which is used for the _gbeta
Emacs integration, does not support running the "debugger" (here:
_gbeta) more than once in a given buffer.
]]nq)

<!------------------------------------------------------------------------>
_question(3,cq[[Why doesn't it work to <code>finish</code> a
<code>for</code>-statement?]],
[[When single-stepping through a piece of code like:

program_box(
cq[[(# i: @integer
do something;
   (for 200000 repeat 1-&gt;i for);
   something_else
#)]]nq)

it is tempting to skip all those iterations of the
<code>for</code>-statement, because single-stepping them is not
likely to reveal any new information.  If you haven't stepped into the
<code>for</code>-statement yet, the <code>next</code> command will
execute all of it in one go.  But if you have already stepped into the
body of the <code>for</code>-statement, you have to do something else.
</p>

<p>
This looks like a job for <code>finish</code>, but since
<code>finish</code> only executes to the end of the current block of
statements, it just executes one of the many iterations of the
<code>for</code>-statement.  We still have to press
<code>[ENTER]</code> 200000 times.  Moreover, <code>"finish 2"</code>
will execute to the end of the enclosing do-part, but we might want
to single-step into <code>something_else</code>.
</p>

<p>
The solution is to put a temporary breakpoint after the
<code>for</code>-statement.  In Emacs you can this by clicking on
<code>for</code> and selecting the <code>"Tmp. Brk. After"</code>
entry in the <code>Gud</code> menu.]]nq)

<!------------------------------------------------------------------------>

_question(4,cq[[How do I get a list of breakpoints?]],
[[The currently installed breakpoints can be printed with the command
<code>"show breakpoints"</code> (possibly abbreviated to something
like <code>"sh b"</code>).  To view the associated source code, when
running under Emacs, double-click near the end of the line specifying
the source code file and position for the breakpoint in question.]]nq)

<!------------------------------------------------------------------------>
<!------------------------------------------------------------------------>
<hr>
<a name="other"><h3>Other sources</h3>
<p>
If you cannot find an answer to your question here, there are a few
other possibilities.  For questions about the language, consider the
general <a href="http://daimi.au.dk/~beta/FAQ/"
target="_top">BETA FAQ</a>.  Except for a few, small
_compatibility_ref(`changes'), the language _gbeta is a backwards
compatible superset of the traditional BETA language.  Consequently, a
large number of questions about _gbeta could as well be seen as
questions about BETA.
</p>

<p>
For questions about the practical usage of and interaction
with the current _gbeta implementation, check out the section
_start_ref(`"Getting Started"').
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
