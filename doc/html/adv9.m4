m4_include(advancedstd.m4)m4_dnl
begin_page(`Using the Code Twice')

<p>
The _modularization_ref(`module system') in _gbeta is basically the
same as in the _mjolner, i.e. it is based on the fragment language
and the notion of a fragment graph whose edges are specified using
properties at the top of source code files such as 
<code>ORIGIN 'betaenv'</code>.  A few changes have been introduced,
though, because it was so easy in the given setting. 
</p>

<p>
Firstly, since the implementation of the fragment language builds on a
search-and-replace semantics with added checks in the fragment graph
for correct visibility decisions, the fragment system in _gbeta allows
all non-terminals in the grammar as slots.  However, the parser does
not allow slot applications in all positions of the syntax, and the
error checking which should detect inconsistencies is incomplete.
Hence, you can use a very large subset of the (ideal) fragment
language, much more than supported by the __mjolner, but real separate
compilation would require significant changes in the current
implementation of _gbeta, and there are some glitches.  If things
start behaving in strange ways, please go back and use the fragment
language in more conventional ways..
</p>

<p>
One of the genuinely new properties of the _gbeta fragment language is
that it is possible to have more than one <code>ORIGIN</code> property
in one fragment group (i.e. source code file), and it is possible to
have more than one slot application for a given slot declaration. 
</p>

<p>
This is the reason for the title of this section.  It looks like
this, e.g.:
</p>

program_box(cq[[
-- program:merge --
(#
   p: (# x:< object &lt;&lt;SLOT doSomething:dopart&gt;&gt; #);
   q: (# x: @integer &lt;&lt;SLOT doSomething:dopart&gt;&gt; #);
do 
   ..
#)

-- doSomething:dopart --
do x]]nq)

<p>
As you can see, the name application <code>"x"</code> ends up in two
different contexts, and this means that two entirely separate sets of
information from static analysis ("semantic attributes") must be
maintained.  The reason why this might be useful is that it makes it
possible to express and exploit the fact that two implementations of
something may be different when it comes to the type system, but still
so related at some (conceptual) level that the source code is
syntactically identical.
</p>

_h3(`Example 10')
<p>
Here's a runnable example of that: 
</p>

program_box(cq[[
(* FILE aex10.gb *)
-- betaenv:descriptor --
(#
   p: (# x,y,z: @integer 
      do (2,3)-&gt;(x,y); 
         &lt;&lt;SLOT xplusy:expression&gt;&gt; -&gt; z;
         (if z=5 then 'Hello'-&gt;stdio if)
      #);
   q: (# x:&lt; string; y: (# exit 'world!\n' #)
      do p; &lt;&lt;SLOT xplusy:expression&gt;&gt; -&gt; stdio
      #);
   r: q(# x::(# do ', '-&gt;value #)#)
do
   r
#)

-- xplusy:expression --
x+y]]nq)

<p>
You might prefer to single-step this program on the command line,
since the pretty printing shows the resulting program, after the
search-and-replace process which eliminates all fragment forms except
<code>betaenv</code>.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
