m4_include(startstd.m4)m4_dnl
begin_page(`Command Line Interaction')

<p>
Since _gbeta is biased towards language design and semantics, the
support for observation of program executions has a high priority.
When running interactively, i.e. when giving the <code>-i</code>
option:
</p>

  code_box(`gbeta -i ...')

<p>
the execution stops at the first statement of the program, and you can
investigate what is going on much like in a source level debugger.
You can print the state of objects, execute ad-hoc statements, and
retrieve static analysis information about program elements, e.g., the
statically known type of a reference attribute.  Moreover, you can
control the program execution by single-stepping, setting breakpoints,
and running the program. 
</p>

_h3(`Starting an interactive session')

<p>
Try to execute the program <code>hello2.gb</code> interactively: 
</p>

  code_box(`gbeta -i hello2')

<p>
The program looks like this:
</p>

program_box(cq[[-- universe:descriptor --
// FILE hello2.gb 
{
  s: string;
  hello: %(|'Hello')
#
  'world!\n' | s;
   hello+', '+s | stdio
}]] nq)

<p>
When _gbeta starts executing this program interactively, you
will have the usual startup message, and then:
</p>

program_box(cq[[====================
{&#x60;26-126
  s: string;
  hello: %(| 'Hello'){&#x60;70-80
    INNER
  }
#
  <u><b>'world!\n' | s</b></u>;
  hello+', '+s | stdio;
  INNER
}
====================

executing~1&gt; _]] nq)

<p>
The source code surrounding the currently executing statement
is pretty-printed before the interactive prompt
<code>"executing~1&gt; _"</code>.  Depending on the capabilities of the
terminal, the exact statement to execute next is emphasized one way
or another, in this case by an underlined and bold font.  The
<code>-c</code> option is used to select other color coding schemes;
in particular, option <code>-cc</code> selects the most expressive one
using ISO 6429 color escape sequences.  This is also an ANSI standard,
and it is often used e.g. under Linux to show color coded directory
listings.
</p>

<p>
As you can see, the pretty-printed version of the code is not
identical to the original source code, and the difference is not just
a matter white space.  It is annotated with source code locations
(character positions) marked by a backquote character ("&#x60;"),
which may be helpful in order to find the original source code again;
in particular, such a backquoted expression is convenient in Emacs
where you can click on it in order to find the code (more details
given later on).  Another difference is that certain implicit elements
have been made explicit; for instance, the <code>INNER</code> keyword
at the end is the implicitly added <code>INNER</code> which is added
by the compiler if the block does not contain an <code>INNER</code>.
For now, we will not go into these details, but the general message is
that the pretty-print provides a little bit more information about the
program than the original source code, and also that this type of
pretty-printed expressions occur in many contexts when using the
_gbeta compiler and virtual machine interactively.
</p>

_h3(`The interactive prompt')

<p>
There are two different interactive prompts, namely 
<code>"terminated&gt; _"</code> and prompts like 
<code>"executing~1&gt; _"</code>.  The first one indicates that no
threads are currently executing.  In this situation many commands are
disabled, but the program can e.g. be started with <code>run</code>
or <code>step</code>. 
</p>

<p>
The second kind of prompt, <code>"executing~1&gt; _"</code>, indicates
that the program is currently being executed, and it specifies the
identifying number for the thread which is the current run-time
context.  For programs without concurrency, the thread number is
always one.  For programs with concurrency it is nice to know just
what thread was trapped at a given breakpoint..
</p>

<p>
After these preparations, the _next_start_ref(next) section deals with the
actual execution of the program.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html 
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
