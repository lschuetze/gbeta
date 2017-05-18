m4_include(startstd.m4)m4_dnl
begin_page(`GNU Emacs Integration (continued)')

_h3(`Overview of execution control commands')

<p>
To execute one single step of a program execution, use the command:
</p>

  code_box(`step')

<p>
and to execute all of the next statement (not stopping at statements
executed indirectly by method invocation etc.) use the command:
</p>

  code_box(`next')

<p>
To execute until the end of an enclosing block is reached, use: 
</p>

  code_box(`finish <i>N</i>')

<p>
where <code><i>N</i></code> is an integer specifying the number of
nesting levels to go out.  This makes it possible to run the
execution, e.g., until a method invocation terminates, also in the
case where the pattern declaration specifying that method invocation
is more than one nesting level further out than the current
statement.  
</p>

<p>
It is possible to let the execution continue in the running mode (not
single-stepping), using:  
</p>

  code_box(`go')

<p>
Finally, the commands 
</p>

  code_box(`restart')

<p>
and 
</p>

  code_box(`run')

<p>
are used to initiate an execution from the <code>"terminated>"</code>
state, in the single-stepping respectively running mode.
</p>

<p>
Finally, the _next_start_ref(`next and last') section explains a few odds and
ends.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
