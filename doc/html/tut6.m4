m4_include(tutorialstd.m4)m4_dnl
begin_page(`Evaluations')

<p>
Evaluations are related to the input/output properties of various
entities, and that has to do with "extracting the value from" or
"impressing a value upon" an entity.  Syntactically, we're talking
about expressions and about the following syntactic elements:
</p>

  code_box(`<div align="center">..-&gt;..<br>enter ..<br>exit ..</div>')

<p>
One very important property of _gbeta evaluations is that they are
determined by the static analysis information.  Even though a
specialization hierarchy may have a different number of arguments at
different levels of specialization, it is always the statically known
types of the entities being evaluated or assigned to that determines
the structure of the values delivered and accepted.
</p>

_h3(`Evaluation lists')

<p>
In general, expressions may be composed into tuples in _gbeta.
If <code><i>X1</i>..<i>Xn</i></code> are expressions, then the
following is also an expression:
</p>

  code_box(`(<i>X1</i>, .. ,<i>Xn</i>)')

<p>
Moreover, if <code><i>T1</i>..<i>Tn</i></code> are assignable (the
grammar term is <code>&lt;Transaction&gt;</code>) then 
</p>

  code_box(`(<i>T1</i>, .. ,<i>Tn</i>)')

<p>
is assignable.  As an example, if you could do:
</p>

  code_box(`a-&gt;x; b-&gt;y; c-&gt;z')

<p>
then you can also do:
</p>

  code_box(`(a,(b,c))-&gt;(x,(y,z))')

<p>
It is important to note, however, that this does <em>not</em> imply a
"parallel assignment" semantics, which computes the composite value of
the entire left hand side of the arrow, and then impresses this value
on the right hand side.  In contrast, the assignments are executed
sequentially, left-to-right and depth-first (as in the first box
above), but as a matter of style and clarity programmers should 
not rely on a particular ordering in the value transfers.
</p>

<p>
The reason why the language has such a "messy" semantics is
performance.  If the semantics was the "pure" parallel assignment,
every single assignment and method call in a _gbeta program would
give rise to the allocation of temporary data, and presumably only a
very small fraction (though an undecidable fraction) of the program
would actually rely on this semantics.  Consequently, all programs
would have twice as bad performance, just because we wanted the
proverbial "swap" to look good:
</p>

  code_box(`(x,y)->(y,x) (* NB: <em>not</em> a swap! *)')

<p>
The message is: if you need temporary variables for swap-like actions,
declare them! 
</p>

_h3(`Assignments and method invocations')

<p>
As mentioned before, assignment looks like this: 
</p>

  code_box(`LHS -&gt; RHS')

<p>
Syntactically, this is an assignment evaluation.  <code>LHS</code> is
evaluated, that is: the current value is extracted from it.
<code>RHS</code> gets this value impressed upon it. 
</p>

<p>
In the special case where <code>RHS</code> is an object, this has the
effect which is known as (value) assignment in many languages.  It
changes the state of the object denoted by <code>RHS</code>.
</p>

<p>
In the case where <code>RHS</code> is a pattern (which is then by
_tutref(4,coercion) instantiated), the effect is known as method
invocation or procedure call in many languages.  The amonymous object
which is created by coercion receives the given value and is then
executed, corresponding to the transfer of actual arguments to a
method or procedure followed by the execution of its body.  Note that
this means that "arguments are moved in front of the method name in
_gbeta."  What looks similar to this in other languages:
</p>

  code_box(`obj.aMethod(arg1,arg2,..) // NB: not gbeta syntax')

<p>
looks like this in _gbeta: 
</p>

  code_box(`(arg1,arg2,..)->obj.aMethod')

<p>
You might even agree that this syntax is more consistent and readable:
</p>

program_box(cq[[
// in an ordinary programming language ;-)
// assume "type result = {result1:type1; result2:type2;};"

var res: result;

res = proc3(proc2(proc1(arg1),arg2))
result1 = res.result1;
proc4(res.result2);]]nq)

program_box(cq[[
(* in gbeta syntax *)

(arg1->proc1,arg2)->proc2->proc3->(result1,proc4)
]]nq)

_h3(`Reference assignments')

<p>
As mentioned above, the default assignment semantics in _gbeta is
<em>value assignment</em>, i.e. the transfer of some representation of
the state of one object into another object, changing the state of the
other object but not changing the object identity.
</p>

<p>
Another important kind of assignment is the <em>reference
assignment</em>, which is the default assignment semantics in many
object-oriented languages, e.g. Smalltalk and Eiffel (for non-expanded
types).  This implies a change of object identity, and hence it is
only possible in _gbeta for attributes which denote object references
(i.e. attributes declared with the <code>"^"</code> declaration flag,
i.e. dynamic references in traditional BETA terminology).
</p>

<p>
When <code>LHS</code> evaluates to an object reference with an
acceptable type, an <em>(object) reference assignment</em> to the
object reference denoted by <code>or</code> can be written as:
</p>

  code_box(`LHS -&gt; or[]')

<p>
There is an analogous case for patterns: When <code>LHS</code>
evaluates to a pattern reference with an acceptable type, a
<em>pattern reference assignment</em> to the pattern reference denoted
by <code>pr</code> can be written as: 
</p>

  code_box(`LHS -&gt; pr##')

<p>
After this, the value of <code>pr</code> will be the pattern reference
resulting from the evaluation of <code>LHS</code>.
</p>

<p>
In fact, this is just a special case of the _tutref(5,coercion)
described earlier, since we are really requesting that <code>or</code>
should be impressed a value <em>as an object reference</em>, and
similarly for <code>pr</code>.  The specialty is that this is only
allowed when the coercion is trivial (e.g. <code>or</code> is already
an object reference).  Consider coercing something into a temporary
entity (e.g. from pattern to object reference) and then assigning that
entity, and immediately discarding the temporary; the assignment would
simply "disappear!"  Since this is not a desirable scenario,
non-trivial coercions are forbidden on the receiving side of a
reference assignment.
</p>

<p>
For example:
</p>

program_box(cq[[
(#
   p: (# #);
   pr: ^p;
   opr: ##object
   x: @p;
   give_x: (# exit x[] #);
   give_typeof_x: (# exit x## #);
do
   x[]->pr[]; 
   give_x->pr[];
   x##->opr##;
   give_typeof_x->opr##;
   pr[]->x[]; (* rejected! non-trivial coercion of 'x' *)
#)]]nq)

_h3(`Enter- and exit-parts')

<p>
The input/output properties of _tutref(16,`basic patterns') like
<code>boolean</code> and <code>integer</code> are predefined and
simple: an <code>integer</code> is able to accept one value from the
set of integer values supported in the language, and it will deliver
one such value when evaluated; similarly for the other basic patterns.
</p>

<p>
Attribute denotations (e.g. names) with the explicit coercion
markers <code>"[]"</code> and <code>"##"</code> also have atomic
input/output properties, e.g. if <code>or</code> were an object
reference, <code>or[]</code> would deliver and accept one value
belonging to the set of object references with a type that matches the
declaration. 
</p>

<p>
The input/output properties associated with a _tutref(2,`main part')
are defined in terms of the <code>enter</code>- and
<code>exit</code>-parts.  An <code>enter</code>-part (and an
<code>exit</code>-part) may contain a single evaluation or an
evaluation list (a tuple).  The input (resp. output) properties are
computed by looking up the entities mentioned in the evaluation
recursively, until atomic entities have been found.  In general this
process computes a nested tuple of primitive input (output) types.
</p>

<p>
An assignment is accepted by the type-checker iff the left hand side
and right hand side have identical nested tuples of value types as
output rsp. input properties.  Interactively, you can inspect these
tuples using the commands <code>assigninfo</code> and
<code>evalinfo</code>.
</p>

_h3(`Do-parts')

<p>
The <code>do</code>-part of a _tutref(2,`main part') participates in
input/output.  The simple (and complete) rule is that the
<code>do</code>-part is always executed.  This means that the
<code>do</code>-part is executed before an <code>exit</code>-part is
evaluated, and the <code>do</code>-part is executed after an
<code>enter</code>-part has been assigned to, and the
<code>do</code>-part is executed between the assignment to the
<code>enter</code>-part and the evaluation of the
<code>exit</code>-part if both processes are taking place.
</p>

_h3(`Example 3')

<p>
Here is an example of this recursive lookup process:
</p>

program_box(cq[[<small>
(* FILE ex3.gb *)
-- betaenv:descriptor --
(# 
   point: 
     (# x,y: @integer 
     enter (x,y) 
     do INNER 
     exit (x,y) 
     #);
   rectangle: (# ul,lr: @point enter (ul,lr) exit (ul,lr) #);
   
   i,j,k,l: @integer;
   p1,p2: @point;
   r1,r2: @rectangle
do 
   (3,4)-&gt;p1-&gt;(i,j);
   p1-&gt;p2;
   (p2.x+i,p2.y+j)-&gt;p2;
   (p1,p2)-&gt;r1-&gt;((i,j),(k,l));
   r1-&gt;r2
#)</small>]]nq)

<p>
Note that one useful way to use <code>enter</code>- and
<code>exit</code>-parts is to define the semantics of value assignment
for a pattern.  The <code>do</code>-part in <code>point</code> is only
there to annoy you when single-stepping: generally,
<code>do</code>-parts take place in everything, as you will see! ;-)
</p>

<p>
The _next_tut_ref(next) section presents the BETA concept of inheritance,
designated <em>specialization</em>.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
