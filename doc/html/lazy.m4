m4_include(gbetastd.m4)m4_dnl
begin_page(`Lazy Analysis')

<p>
When the <code>-l</code> option is given:
</p>

  code_box(`gbeta -l ...')

<p>
_gbeta will execute in the <em>lazy analysis</em> mode.  This means
that static analysis is only carried out to an extent which is
sufficient to determine the semantics of the program, and it is 
done lazily, i.e. on demand.  In general, you get faster response and
less safety.  If your program does not give any problems during a normal
static analysis (non-lazy), then you can run it (unchanged) lazily and
have the normal safety guarantees.
</p>

_h3(`Analysis happens later, and only where you go')

<p>
When running in the lazy analysis mode, _gbeta only obtains
static information, such as the type of a declared name, at the time
when it is first needed.  This means e.g. that you can go through a
session which only uses a small part of a big program (perhaps because
it includes a lot of libraries), and only that small part of the
program will be analyzed statically.  The rest of the program may have
all kinds of flaws (except bad syntax), and it will not be discovered,
but on the other hand you get a much faster startup process.
</p>

_h3(`Fewer things are checked')

<p>
Not only unused parts of a program are not analyzed.  Several other
aspects of static analysis are not needed in order to choose the
semantically correct actions to take during execution.  For example,
the number and type of arguments given in a method call are not
checked statically in lazy analysis mode.  This means that an
invocation which e.g. gives a wrong number of arguments in a method
call will give rise to a run-time error in stead of a (err .. also
run-time, since it is late) type-checking error.  
</p>

<p>
As an example, the program:
</p>

program_box(cq[[
-- betaenv:descriptor:gbeta --
(#
   p: @integer
do 
   (1,2)->p
#)]]nq)

<p>
will give the following response:
</p>

program_box(cq[[<small>gbeta -l late
GBETA version 1.9.11, copyright (C) 1997-2011 Erik Ernst.
...
**** Run-time error; offending thread killed.
ibetaTwoEvalbody.bet/118, the exit list produced too many values for the enter list!
Look at ./late.dump<small>]]nq)

<p>
As you can see, there is a reference to a specific position in the
source code of the implementation of _gbeta.  This is because the
errors encountered because of the incomplete analysis in lazy mode
used to be internal errors (bugs!) in _gbeta.  As a consequence, the
response in case of a run-time error encountered in lazy mode may be a
little rough.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
