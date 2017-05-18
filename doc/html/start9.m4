m4_include(startstd.m4)m4_dnl
begin_page(`GNU Emacs Integration (continued)')

This section describes a few remaining commands that did not fit into
the previous sections.

_h3(`Examining the stack etc.')

<p>
It is possible to print the current execution stack with: 
</p>

  code_box(`stack')

<p>
and to print only the topmost element on the stack with:
</p>

  code_box(`topofstack')

<p>
The topmost element on the stack is the "current" object, and one
particular part of this object is the "current object slice",
containing the state and executing the dopart from one particular
"MainPart" (which is the grammatical name of a declaration block, 
i.e., a piece of syntax enclosed by <code>{..}</code> and possibly
prepended by <code>%(..|..)</code> or just <code>%</code>).  The
current object slice can be printed with the command:
</p>

  code_box(`currentslice')

<p>
The outermost object in the nesting structure contains
everything in a _gbeta program execution, and this object can
be printed using the following command:
</p>

  code_box(`primaryobject')

<p>
The primary object is the only part of the state which can be
inspected in the <code>"terminated>"</code> state.
</p>

_h3(`Killing threads')

<p>
When executing a concurrent program, it may be convenient to be able
to kill the current thread, and this is done with:
</p>

  code_box(`kill')

<p>
If a given thread is not the active one when the prompt is printed,
there is no way to browse the set of threads and discover what
identity number a given thread has, and then kill it.  (This may be
fixed later, though.)  A special variant of the command: 
</p>

  code_box(`kill all')

<p>
will kill all threads, just like repeating <code>kill</code> enough
times, hence making it possible to restart the execution of the
program immediately.
</p>

_h3(`Name applications and declarations')

<p>
It is often necessary to look up the declaration associated with a
given application (i.e. non-declaring occurrence) of the name.  Since
the scope rules are complicated in a language with inheritance, and
already BETA has especially rich scope rules because of the combination
of general nesting and inheritance, and since _gbeta makes the
whole thing even more complicated by adding multiple inheritance and
also inheritance from virtual patterns (whose static type depends on
the position of the application), since all that (and even without 
it :-), it is very important to have tool support for interactive name
lookups.
</p>

<p>
In _gbeta, interactive name lookup is supported by means 
of the <code>declaration</code> command, like:
</p>

  code_box(`decl 376')

<p>
.. but since a character position argument is awkward (who knows the 
exact character position of a piece of source code when looking at
it?) this kind of invocation is seldom used.  Control-clicking on the
name application, on the other hand, 
</p>

  code_box(`[ control-click! ]')

<p>
does exactly the same thing, and this brings forward the source
code containing the declaration, even if it is in another file
than the application.
</p>

<p>
Please note that this is <EM>real</EM> name lookup, and it will not
confuse two name declarations even if the declared names are spelled
identically, nor will it find a name mentioned in the middle of a
comment.  It uses the information from static analysis which is
created and kept by _gbeta anyway.
</p>

<p>
This ends the description of the practical usage of _gbeta.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
