m4_include(tutorialstd.m4)m4_dnl
begin_page(`Transparency and Coercion (continued)')

_h3(`Some non-object contexts')

<p>
There are cases where the category of entity we want is not an
object.  In these cases, various syntactic "tails" are available to
tell the language processing system that we want e.g. a pattern.  Note
that there is still transparency of the declared category of entity,
since we are specifying what we want, not how we get it or what we
have. 

_h3(`Object reference wanted!')

<p>
When we want to obtain an object reference from a given entity, we
must annotate the entity with the "box" suffix:
</p>

  code_box(`[]')

<p>
For example, when making an object reference refer to another object,
we need to access an entity as an object reference both to obtain the
future state of the target and to assign to the target <EM>as an
object reference</EM>:
</p>

program_box(cq[[
(#
   i: @integer;
   ir: ^integer
do
   i[]->ir[]
#)]]nq)

<p>
After executing the _tutref(6,`reference assignment')
<code>i[]->ir[]</code>, <code>ir</code> refers to the object which
<code>i</code> (invariably) denotes.
</p>

_h4(`<EM>Not</EM> executing')

<p>
Note that the request for an object reference does not imply
that the object should be executed.  Consequently, the
<code>"[]"</code> box marker can be used to <EM>avoid the execution of
an object</EM> when that is required.  
</p>

<p>
For example, assume that <code>"p[]"</code> is used as a statement,
i.e. not occurring in an <code>enter</code>- or
<code>exit</code>-list, and not before or after an
<code>"-&gt;"</code> _tutref(6,evaluation) arrow.  Moreover, assume
that <code>p</code> denotes a pattern.  In that case it means: create
an instance of the pattern <code>p</code> and obtain and then ignore a
reference to it.  This might e.g. have desirable side-effects in a
concrete situation.  Even more useful is the situation where
<code>or</code> denotes an object reference attribute and and the
_tutref(14,`"new" operator') <code>"&amp;"</code> is added,
<code>"&amp;or[]"</code>.  This means: create an instance of the
declared type of <code>or</code> and make <code>or</code> refer to it.
</p>

_h3(`Pattern reference wanted!')

<p>
It is possible to compare the types of entities directly, and to do
this we must be able to obtain a pattern reference from any entity,
e.g. an object or an object reference.  We also need to obtain a
pattern reference in order to assign a new value to a 
_tutref(9,`pattern reference attribute').  For these purposes we use
the suffix:
</p>

  code_box(`##')

<p>
As an example:
</p>

program_box(cq[[
(#
   p: (# #);
   or: ^object;
   pr: ^p;
   var_p: ##p;
do
   (if ro## &lt;= p## then ro[]->rp[] else NONE->rp[] if);
   p## -> var_p##
#)]]nq)

<p>
The first statement is an example of type-casing.  Even if frowned
upon, the notion of type-casing keeps emerging as something
object-oriented programmers cannot do entirely without.  The 
_tutref(12,`<code>if</code> statement') compares the type of
<code>ro</code> (it is the pattern from which the actual, run-time
object denoted by <code>ro</code> were originally instantiated) with
<code>p</code> <EM>as a pattern</EM> (implying the "empty" coercion),
and iff <code>ro</code> is actually an instance of a specialization of
<code>p</code>, the body <code>ro[]->rp[]</code> will be executed,
otherwise <code>NONE->rp[]</code> is executed, making <code>rp</code>
void.  Afterwards, <code>rp</code> refers to the same object as
referred by <code>ro</code> iff that is a type-correct thing to do.
</p>

<p>
The second statement, <code>p##->var_p##</code>, is a 
_tutref(6,`pattern reference assignment') which gives
<code>var_p</code> the pattern <code>p</code> as value.
</p>

_h4('A super-pattern is a pattern context, too')

<p>
_tutref(7,Specialization) is expressed in its most basic form by a
super-pattern and a main part.  The super-pattern is the basis on
which a new pattern is created, and the main part specifies the
differences and additions.  Whatever occurs in the position of a
super-pattern will be coerced into a pattern.  The following example
contains a named and an anonymous pattern created with the aid of a
super-pattern:
</p>

program_box(cq[[
(#
   p: q(# .. #);
do
   boolean(# .. #)
#)]]nq)

<p>
Note that the expression <code>`boolean(# .. #)'</code> contains
super-pattern syntax, _tutref(16,`<code>boolean</code>'), and is itself
used as a statement.  As a consequence, there is both the coercion
(in this case a no-op) from pattern to pattern for
<code>boolean</code>, and the coercion from pattern to object
(instantiation), followed by execution, for the syntax
<code>`boolean(# .. #)'</code>.
</p>

_h3(`Example 2')

<p>
Here is an example which is ever so slightly less artificial (one does
rather easily get tired of <code>x-y-z-p-q</code> examples, doesn't
one? ;-).  The idea is that you start an interactive _gbeta session on
it, single-step through some of the code and think about the coercions
involved in the execution as it happens.  You can always check out the
category of <code>XXX</code> using <code>"print&nbsp;XXX"</code>,
usually abbreviated as in e.g. <code>"p&nbsp;thyself.init"</code>.
</p>

<p>
The example looks like this:
</p>

program_box(cq[[<small>
(* FILE ex2.gb *)
-- betaenv:descriptor --
(# 
   putline: (# enter stdio do '\n'-&gt;stdio #);
   person: 
     (# init: (# enter (name,height) #);
        name: @string;
        height: @real;
        loves: (* we _love_ small persons *)
          (# other: ^person;
             value: @boolean
          enter other[] 
          do (other.height&lt;=height)-&gt;value
          exit value 
          #);
        thumpOnHead: (# do height-0.1 -&gt; height; 'Ouch!!'-&gt;putline #);
        greet:
          (# other: ^person
          enter other[]
          do 'Hi, '+other.name+'!'-&gt;putline
          #)
     #);
   thyNeighbor,thySelf: @person;
do 
   ('me!',6.5)-&gt;thySelf.init;
   ('pal',6.7)-&gt;thyNeighbor.init;
   
   L: (if (thyNeighbor[]-&gt;thySelf.loves)=(thySelf[]-&gt;thySelf.loves) then 
          thyNeighbor[]-&gt;thySelf.greet
       else
          thyNeighbor.thumpOnHead;
          restart L
      if)
#)</small>]]nq)

<p>
_next_tut_ref(Next), we'll present some more details about evaluations.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
