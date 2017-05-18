m4_include(tutorialstd.m4)m4_dnl
begin_page(`The "new" (&amp;) Operator')

<p>
Sometimes it is desirable to explicitly request that a new object is
instantiated, instead of relying on the _tutref(4,coercion) mechanism
to create objects tranparently whenever an object is required and the
denoted entity is a pattern or a pattern reference.  
</p>

<p>
One reason why the transparency might be unwanted is that the
semantics may depend on having fresh objects.  This is actually mostly
a matter of convenience and performance, since it is typically because
the implementation of a pattern depends on the initialization values
for instances of _tutref(16,`basic patterns').  E.g. a new
<code>integer</code> has the value zero, and a new <code>string</code>
is empty. 
</p>

<p>
If some piece of syntax (&lt;Merge&gt;, actually), should denote a
fresh, newly instantiated object, then just put the "new" operator in
front of it:
</p>

  code_box(`"&amp;" &lt;Merge&gt;')

<p>
As usual, there is a "_tutref(11,concurrent) version" creating an
object which is also a <code>component</code>:
</p>

  code_box(`"&amp;" "|" &lt;Merge&gt;')

<p>
If you are explicitly requesting a new object and the given syntax
denotes an existing object, there is a compile-time error and the 
program is rejected.
</p>

_h3(`Renewing an object reference')

<p>
One extension in _gbeta compared to traditional BETA is the
possibility to use the <code>"&amp;"</code> operator with a name which
denotes an object reference (a "dynamic reference,"
declared with the _tutref(3,`<code>"^"</code> marker')).  This used to
be a static semantic error.
</p>

<p>
The semantics in _gbeta is that a new instance of the declared type is
created, and the object reference is made to refer to that new
object.  This is similar to the creation syntax <code>"!!"</code> in
Eiffel.  It is nothing but syntactic sugar for an explicit object
instantiation followed by a reference assignment, e.g.
</p>

program_box(cq[[
(#
   ir: ^integer
do 
   (* This: *)
   <font color="blue"><b>&iref[]</b></font>;
   (* .. is the same as: *)
   &integer[]-&gt;iref[];

   (* And this: *)
   <font color="blue"><b>&iref</b></font>;
   (* .. is the same as: *)
   &integer[]-&gt;iref[]; 
   iref;
#)]]nq)

<p>
Whether or not the (newly created) object should be executed is
determined by the _tutref(5,`<code>"[]"</code> marker'): when this marker is
present in a statement (or in an evaluation), the denoted entity is
identified ("a pointer to it is computed") but nothing more happens.
When it is not present, the <code>do</code>-part is executed, as
always.  Since the execution of an _tutref(16,integer) is a no-op,
nobody would notice in this particular example, though.
</p>

_h3(`Caching')

<p>
One special reason why it might be important to explicitly request a
fresh object is that, traditionally, BETA allows a compiler to set up
caching for all objects which are not explicitly requested to be new.
This only applies to objects created as a result of coercion from
pattern or pattern reference to object in a statement. 
This is normally known by the term <EM>inserted item</EM> even
though that is also the name of a syntactic category which does not
cover all the cases where caching is allowed.  As an example:
</p>

program_box(cq[[
(#
   p: (# value: @integer do value+1-&gt;value exit value #)
do 
   (for 3 repeat <font color="blue"><b>p</b></font>-&gt;putint for)
#)]]nq)

<p>
This is should print "123" with caching, since the (same) statement
mentioning <code>p</code> will use the same instance of the pattern
denoted by <code>p</code> which was created by coercion.  In _gbeta
(and in the _mjolner) it prints "111".  In contrast: 
</p>
  
program_box(cq[[
(#
   p: (# value: @integer do value+1-&gt;value exit value #)
do 
   (for 3 repeat <font color="blue"><b>&amp;p</b></font>-&gt;putint for)
#)]]nq)

<p>
This must definitely print "111", even according to _tutref(1,`"the
BETA book."')
</p>

<p>
However, this has never been implemented for any cases where it could
be detected (in terms of program state), and it is generally frowned
upon, so it is not (and will not be) implemented to do caching of
inserted items in _gbeta.  Think of it as a non-issue.
</p>

<p>
On the other hand, it might very well be interesting to provide this
functionality explicitly, such that:
</p>

program_box(cq[[
(#
   p: (# value: @integer do value+1-&gt;value exit value #)
do 
   (for 3 repeat <font color="blue"><b>@p</b></font>-&gt;putint for)
#)]]nq)

<p>
will print "123" thus making caching an explicit choice by the
programmer.  This has not been implemented, and the grammar does not
even allow it.
</p>

<p>
The _next_tut_ref(next) topic is general block structure, which might seem
somewhat alien to users of many other languages.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
