m4_include(modularizationstd.m4)m4_dnl
begin_page(`Basic Concepts')

<p>
The <em>fragment language</em> provides support for creating a 
program as the combination of several independent or interdependent
modules.  It is a language in its own right, and it could be used for
the modularization of any programmming language whose syntax can
be described by a context free grammar (well, with the current tools:
a LALR(1) grammar). 
</p>

<p>
A _gbeta program, as well as a traditional BETA program, is
written in a mixture of the fragment language and the (_gbeta or
BETA) programming language.  The fragment language defines the
top-level structure, and the programming language syntax occurs as
fragments of varying size, inserted into the fragment language
constructs at certain places.
</p>

<p>
The fragment language also defines some bottom-level expressions, i.e.
small pieces of syntax that do not contain any syntax from the
programming language.  These bottom-level expressions are inserted
into the programming language syntax as place-holders.
</p>

<p>
The following sections will add the missing details to this
description.  The basic concepts can be introduced without considering
multi-file programs, so we commence with a one-file situation. 
</p> 

_h3(`Declarations and applications of SLOTs')

<p>
First, let us take a look at the top-level construct where the
fragment language construct encloses some programming language syntax
(<code><i>piece-of-code</i></code> is written in the programming 
language).  The basic purpose of this is to give a
<code><i>name</i></code> to a <code><i>piece-of-code</i></code>:  
</p>

program_box(cq[[
(* SLOT declaration *)
-- <i>name</i>:<i>non-terminal</i>:<i>grammar</i> --
<i>piece-of-code</i>
]]nq)

<p>
The <code><i>piece-of-code</i></code> must be syntactically derived
from the given <code><i>non-terminal</i></code>.  If for example the
<code><i>non-terminal</i></code> is <code>dopart</code>, then the
<code><i>piece-of-code</i></code> must be a <code>dopart</code>, i.e.
<code>"do"</code> followed by a number of statements.
</p>

<p>
Such a named piece of code can then be used (applied) in other places
by referring to the name:
</p>

program_box(cq[[...
(* SLOT application *)
&lt;&lt;SLOT <i>name</i>:<i>non-terminal</i>&gt;&gt;
...]]nq)

<p>
This is the bottom-level construct of the fragment language.  The 
<code>&lt;&lt;SLOT ..&gt;&gt;</code> syntax appears in the middle of
some programming language syntax. 
</p>

<p>
There is an analogy to constants in ordinary programming languages:
The slot declaration says that the given <code><i>name</i></code> is 
declared to be a constant whose value is the associated
<code><i>piece-of-code</i></code>.  The slot application instructs the
language processing system (compiler, interpreter, analyzer, ..) to
look up the piece of code with the given <code><i>name</i></code> and
put it right here, in stead of the 
<code>&lt;&lt;SLOT ..&gt;&gt;</code>.  
</p>

<p>
Think of it as a kind of search-and-replace operation which will
substitute away slot applications until the entire program is written
in the programming language and all of the fragment language syntax
has been eliminated.
</p>

<p>
Here's an example:
</p>

program_box(cq[[
-- betaenv:descriptor --
(# s: @string
&lt;&lt;SLOT main:dopart&gt;&gt;
#)

-- main:dopart --
do '"s" can be accessed from here'-&gt;s
]]nq)

<p>
The <code>betaenv:descriptor</code> slot is special.  Since we
cannot substitute pieces of code into each other ad infinitum, we must
choose a distinguished piece of code to be the root of the system.
That is a <code>descriptor</code> with the name <code>betaenv</code>.
_modref(2,Later) we'll add one more constraint to this. 
</p>

<p>
If we perform the search-and-replace process on the above example, we
get the following program:
</p>

program_box(cq[[
(# s: @string
do '"s" can be accessed from here'-&gt;s
#)]]nq)

_h3(`Separate compilation vs. generality')

<p>
The semantics of slots is described by the search-and-replace
scenario, but a language processing system would normally not be
appropriate for real-world use if it actually did modify the source
code in such a way.  The problem is that compilation of almost any
BETA program would imply changes in very basic (highly depended-upon)
files, and hence almost any BETA compilation would be a recompilation
of "the entire universe" (including various standard libraries).
</p>

<p>
Luckily, it does not have to be like that.  As long as a BETA compiler
is able to compile the code in such a way that resulting programs
behave <em>as if</em> the search-and-replace operations had taken
place, the semantics will be correct, the basic files will remain
unaffected, and compilation will take time roughly proportional to the
size of the program, not to the size of the "universe." 
</p>

<p>
So, in practice (in particular in the __mjolner),
separate compilation is achieved by supporting some non-terminals
as slots (notably <code>dopart</code>, <code>descriptor</code>, and 
<code>attributes</code>) for which separate compilation has been
implemented, and reject programs using other non-terminals as slots.
Moreover, there are some restrictions on the usage of the supported
non-terminals.  Look into the standard 
<a href="http://daimi.au.dk/~beta/FAQ/index.html#SectionI" 
TARGET="_top">BETA FAQ</a>
for details about this.  As practical experience shows, even those few
supported non-terminals are sufficient to establish a very expressive
and flexible module system. 
</p>

<p>
Nevertheless, it's interesting to be able to experiment with all 
non-terminals of the grammar, as well as being relieved of those
restrictions which the __mjolner puts on the usage of the supported
non-terminals.  Notably, it is a serious constraint that no substance
can be declared in an <code>attributes</code> slot, even though there
is a reasonable work-around.
</p>

<p>
Because of this, and because _gbeta would
look at all of the source code anyway, _gbeta was designed in such a
way that all non-terminals are supported, and there are no
special restrictions on their usage.  On the other hand there is no
"separate compilation" in _gbeta: even for programs expressed in terms
of many different source code files (which is supported), the compilation
process will load all the files and translate them from scratch (except
for parsing and building abstract syntax trees, which are saved on disk 
between executions).  Note that the visibility relations determined 
by the fragment structure <em>are</em> implemented and strictly 
enforced.  It is a future project to reconcile the generality 
of the fragment language in _gbeta and full separateness 
and persistence of static analysis results in the _gbeta 
translation implementation.  Note, however, that for a restricted version
of the fragment language where only the same non-terminals are available
as in BETA, and with the same restrictions, it should not be 
significantly harder to compile _gbeta fragments separately than it is
to compile BETA fragments separately, and the latter has been done
for more than 20 years.
</p>

_h3(`How many files?')

<p>
Everything said sofar can be tried out using programs consisting of
only one source code file, but it basically also holds in the general
case where there are several files involved.  However, with several
files we have to consider visibility ("privateness") issues and issues
concerning the relations between those several files.  The 
_next_mod_ref(next) section deals with this.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
