m4_include(tutorialstd.m4)m4_dnl
begin_page(`Primitive Entities')

<p>
An important idea behind BETA was to create such a general,
orthogonal, and minimal language that it would be easy to get to know
well, and still it would be so expressive that anything could be
written in it in an elegant and maintainable form.
</p>

<p>
Because of this, there should not be many predefined languge
entities.  However, a few are needed, and they are presented here.
</p>

_h3(`Basic patterns')

<p>
All patterns are either constructed from other patterns (using
_tutref(7,specialization) and _tutref(2,`main parts')) or predefined.
The set of predefined patterns may be viewed as a parameter, defining
a family of languages which differ only in the choice of
predefined patterns.  Because of this, it has not been given that much
attention what selection of basic patterns are present in _gbeta, it
simply supports the same basic patterns as the _mjolner as well as a
few extras.  It would be nice to have different widths of integers,
unicode characters, and infinite precision arithmetic types as well,
but that remains a future project.  In __mjolner, by the way, some
changes are being introduced in this area right now.
</p>

<p>
The basic patterns for simple values are <code>boolean</code>,
<code>char</code>, <code>integer</code>, <code>real</code>, and
<code>string</code>.  The <code>string</code> basic pattern is new
compared to __mjolner, and it will be described below.  The others are
well-known.  Each <code>integer</code> object, e.g., is a container
for one value from the set of integer values supported (again a
language family parameter).  In evaluations, an	<code>integer</code>
object will deliver one integer value ("its value"), and when assigned
to it will accept one integer value.  Similarly with the others.  All
these basic patterns have a primitive <code>value</code> attribute.
It is not an object, and you cannot obtain a reference to it or ask
for its type or inherit from it.  It is used for access to the value
of primitive objects in specializations, e.g.:
</p>

program_box(cq[[
(#
   talking_integer: @integer
     (# do 'Hi, mom, I''m '-&gt;stdio; 
        value-&gt;putint; 
        ' now!\n'-&gt;stdio
     #)
do 
   5-&gt;talking_integer
#)]]nq)

<p>
These input/output properties are the atomic (irreducible) elements in
the recursive definition of _tutref(6,input/output) properties: Any
object will deliver a (possibly composite) value when evaluated, and
this value is computed by looking up <code>exit</code>-lists
recursively until a primitive pattern or an object reference
 or a pattern reference
(_tutref(5,`<code>"[]"</code>, <code>"##"</code>')), or a literal
expression (like <code>"3.1415926"</code> or <code>"'Ho! Ho!
Ho!'"</code>), or a primitive value (like the index variable of a
<code>for</code> statement) is encountered.
</p>

<p>
A <code>string</code> contains a string of characters as a value,
i.e. it is immutable.  This provides a nice compromise between sharing
references to (heavy) "text" objects and copying these objects all the
time.  The problem is that copying a text object everytime it is used
as an argument is too expensive, and sharing it by tranferring an
object reference gives rise to aliasing. This is bad aliasing, because
it is not motivated by the modeling relation (there is no analogous
sharing in the conceptual model of the application domain), but
exclusively motivated by performance considerations.  It is possible
that the problem lies in the fact that the standard <code>text</code>
pattern in the __mjolner basic libraries uses repetitions in the
<code>enter</code>- and <code>exit</code>-lists, and repetitions of
instances of basic patterns are a too low-level construct in the
__mjolner to support read-only access (which is normally achieved
using a pattern that has only an <code>exit</code>-part and which
exits whatever we want to have read-only access to).
</p>

<p>
Anyway, the<code>string</code> basic pattern provides a solution
because it allows sharing at the implementation level (value
assignment of a	<code>string</code> can be just an assignment of a
pointer) and semantically works like other values: If you have a "7"
in an integer variable, nobody will ever be able to change "7" into
anything else, and hence the variable will not change because of
"internal aliasing" (somebody else referring to the contents).  As a
result, a <code>string</code> is both fast and safe.  On the other
hand, it cannot be "edited", so if you want to change the individual
characters a lot, copy the <code>string</code> into an oldfashioned
repetition of <code>char</code>, and change the contents as you like,
then possibly copy it back into a <code>string</code>.
</p>

<p>
There are three primitive operations on <code>string</code>s: 
<code>aString.length</code> delivers the length of the string,
<code>aString.at</code> accepts an <code>integer</code> value and
delivers the character at that position.  In the future, there will
possibly be some substring support, but	<code>string</code> generally
should remain a simple thing.  Finally, <code>string</code> has a
<code>value</code> attribute like the other basic (value) patterns.
As an example: 
</p>

program_box(cq[[
(# 
   s: @string
do
   'test'-&gt;s;
   s.length-&gt;putint;
   2-&gt;s.at-&gt;stdio
#)]]nq)

_h3(`Concurrency')

<p>
As mentioned in the _tutref(10,co-routine) and _tutref(11,concurrency)
sections, concurrency has been re-defined from being a basic property
(distinguishing "objects" and "components") into being a matter of
types.  An object has its own stack of execution iff it is a
specialization of <code>component</code>, which is one more basic
pattern.  Along with <code>component</code> goes
<code>semaphore</code>, since concurrency control is needed as soon as
there is concurrency.
</p>

<p>
The primitive commands available with <code>component</code> have been
mentioned in the _tutref(11,concurrency) section, and the primitive
commands of <code>semaphore</code> are 
</p>

   code_box(`p, v, tryp, </tt>and<tt> count')

<p>
e.g. <code>aSem.p</code>, <code>aSem.v</code>, <code>aSem.tryp</code>, 
and <code>aSem.count</code>.  These command are standard semaphore
commands as defined by Dijkstra.  The <code>p</code> command and the
<code>v</code> command are executed by the run-time system in such a
way the the number of <code>v</code> commands on any given
<code>semaphore</code> is at all times greater than or equal to the
number of <code>p</code> commands.  This means that a thread can be
delayed when it attempts to execute a <code>p</code> command, and it
will not continue the execution before "somebody else" executes the
<code>v</code> command on the same <code>semaphore</code>.  This
concurrency control primitive is sufficient to create higher level
concurrency control abstractions, such as monitors and ports.  Lots of
details about this can be read in _tutref(1,"the Beta book.")  Finally
<code>aSem.count</code> evaluates to the number of threads waiting to
execute because of the <code>p/v</code> command count constraint.
</p>

<p>
This concludes the _gbeta tutorial.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
