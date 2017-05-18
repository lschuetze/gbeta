m4_include(tutorialstd.m4)m4_dnl
begin_page(`Control Structures')

Now that all the interesting stuff has been dealt with, we have to
cover a few odds and ends.  This section is about the imperative
aspect of _gbeta, namely the built-in statements for unusual but
structured transfer of control.  Ah, by the way, <code>leave</code>
and <code>restart</code> are not boring, even though they are
imperative constructs.

_h3(`Standard control structure statements')

<p>
Since the 70'ties, all imperative languages (including the
object-oriented subset) have had built-in support for "structured"
versions of <code>GOTO</code>, now that <code>GOTO</code> had been
deemed harmful..
</p>

<p>
As a matter of fact, BETA was designed to have a minimal collection of
such constructs, since the generality of the pattern concept allows it
to support all kinds of customized control structures.  As an example,
look at <code>scan</code> in the <code>container</code> pattern of
_tutref(8,`example 6') in the section about virtual patterns, and the
<code>cycle</code> pattern of _tutref(10,`example 8').
</p>

<p>
The <code>if</code> statement comes in a compact version:
</p>

  code_box(`"(if" &lt;Evaluation&gt; "then" .. "else" .. "if)"')

<p>
and in a version which is similar in use to <code>"switch"</code> or
<code>"case"</code> statements in other languages:
</p>

  code_box(`"(if" &lt;Evaluation&gt;<BR>
            "//" &lt;Evaluation&gt; "then" ..<BR>
            "//" &lt;Evaluation&gt; "then" ..<BR>
            ..<BR>
            "else" ..<BR>
            "if)"')

<p>
The first <code>&lt;Evaluation&gt;</code> is computed and the value
compared for equality with the <code>&lt;Evaluation&gt;</code>s after
the <code>"//"</code> one by one, and the block of statements
(<code>".."</code>) after the first matching value is executed.  If no
equal values are found, the <code>else</code> statements are 
executed.
</p>

<p>
Finally, iterating a pre-computed number of times is supported with
the <code>for</code> statement which also comes in two variants: 
</p>

  code_box(`"(for" &lt;Evaluation&gt; "repeat" .. "for)"')

<p>
and 
</p>

  code_box(`"(for" &lt;Name&gt; ":" &lt;Evaluation&gt; 
            "repeat" .. "for)"') 

<p>
The first variant just repeats the body <code>".."</code> <code>
&lt;Evaluation&gt;</code> times, and the second does the same, with
&lt;Name&gt; denoting the number of the current iteration, i.e. 1 the
first time round, 2 the second etc.  <code>&lt;Name&gt;</code> is
<EM>not</EM> an object, it just denotes the value, so it cannot be
changed by assignment, and the type of it cannot be computed (using
<code>"##"</code>), and it is not allowed to ask for a reference to it
(using <code>"[]"</code>).
</p>

_h3(`Jumping around, and unwinding the stack')

<p>
The two last constructs for the transfer of control are very
expressive, even if they look rather ordinary at the first sight.
They are called <code>leave</code> and <code>restart</code>, and they
are used in connection with some kind of block, e.g. a 
_tutref(2,`main part'). 
</p>

<p>
The first one: 
</p>

  code_box(`"leave" &lt;Name&gt;')

<p>
jumps to the end of the block denoted by the
<code>&lt;Name&gt;</code>, i.e. it forces the execution of the block
to terminate earlier than it otherwise would.  The other one:
</p>

  code_box(`"restart" &lt;Name&gt;')

<p>
jumps to the beginning of the block denoted by the
<code>&lt;Name&gt;</code>, i.e. it forces the execution of the block
to start from the beginning again.
</p>

<p>
The reason why this is not entirely trivial is that we may have (due
to the _tutref(4,coercion)) objects on the stack between the one
associated with the enclosing block and the one which is currently
executing.  In other words, <code>leave</code> may imply a stack
unwinding which forcefully terminates the execution of any number of
objects before the target object (associated with the target position
in the source code) is at the top of the stack.  Moreover, the number
of objects to unwind off the stack may not be statically determinable.
</p>

<p>
This resembles the exception handling mechanisms of other languages,
e.g. the <code>try</code> and <code>catch</code> pair of C++.  The
most important difference is that the combination of coercion, block
structure, and <code>leave</code>/<code>restart</code> makes it
possible to have a statically determined target for the "long jump" in
BETA, whereas the stack unwinding in e.g. C++ only terminates in an
ordered fashion if a <code>catch</code>er happens to be on the
run-time stack.  In Java, this (missing) safety property has been
reinstated by using strict exception declarations on all methods.  On
the other hand, this pervades the entire program, even if lots of
intermediate routines would otherwise not have to depend on the 
given exception handling strategy.
</p>

_h3(`Example 10')

<p>
Here is an example which by the way also demonstrates how it is
possible to create a recursive procedure which will call the
specialized version of itself in specializations.  This is not a
problem with _gbeta, it's an obstacle which never occurs in languages
that do not support specialization of behavior in the first place,
such as anything but BETA and CLOS..  Anyway, we need a notion of
<EM>selfType</EM> or <EM>myType</EM> or whatever else that concept has
been designated in the literature, and again _tutref(4,coercion) comes
to the rescue, since <code>this(recur)</code> denotes the currently
enclosing object which is coerced into a pattern because it is used in
a pattern context.  As a result, <code>selfType</code> is declared to
denote the pattern of the enclosing object, and the type system
recognizes that this type is more specialized in the context of the
anonymous specialization of <code>recur</code> which occurs in the
main <code>do</code>-part of the program.
</p>

program_box(cq[[
(* FILE ex10.gb *)
-- betaenv:descriptor --
(# 
   recur:
     (# selfType: this(recur);
        enough:&lt; object;
        depth: @integer
     enter depth
     do (if depth&gt;4 then enough if);
        depth+1-&gt;&amp;selfType
     #)
do 
   L: recur(# enough::(# do leave L #)#)
#)]]nq)

<p>
You might want to compare this with the following slight variation:
</p>

program_box(cq[[
-- betaenv:descriptor --
(# 
   recur:
     (# enough:&lt; object;
        depth: @integer
     enter depth
     do (if depth&gt;4 then enough if);
        depth+1-&gt;&amp;recur
     #)
do 
   L: recur(# enough::(# do leave L #)#)
#)]]nq)

<p>
The <code>"&amp;"</code> operator which marks explicit object
instantiation is covered _tutref(14,later).  Just before that, the
_next_tut_ref(next) topic is repetitions.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
