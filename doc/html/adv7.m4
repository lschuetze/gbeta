m4_include(advancedstd.m4)m4_dnl
begin_page(`Combination of Patterns Everywhere')

<p>
First we must realize that patterns in _gbeta are lists.  Every
pattern in a _gbeta program is one particular list, and there is
nothing to know about the pattern except what elements it contains and
in what order.  The elements of such a list are mixins, and each mixin
is associated with a <code>MainPart</code>.  Each mixin contributes a
number of attributes, namely the ones that are declared in the
<code>MainPart</code>.  As a consequence, patterns are values (not
objects) and that again ensures that the computations on patterns 
have a well-defined meaning.  Combination of patterns can be described
as a <EM>pattern algebra</EM>: taking two patterns and computing their
combination is quite similar to taking two natural numbers and
computing their sum (though pattern combination is not commutative).
</p>

<p>
The mechanism which allows us to combine patterns is based on a
linearization algorithm, i.e., an algorithm which creates one list
from two given lists.  Since patterns are values, the combination of
two patterns yields a new pattern and does not change the operand
patterns.. just like the computation of "3+4" yields "7" but does not
change the meaning of "3" or "4".  The pure functional semantics of
pattern computations is a primary reason why it is possible to ensure
static type correctness in _gbeta even though the language supports
pattern computations also at run-time.
</p>

<p>
When two patterns are combined like in <code>a&amp;b</code> the resulting
pattern will be computed by means of an algorithm which takes two
lists (for <code>a</code> and for <code>b</code>), and produces one new list
which contains both of the argument lists as sublists, preserving the
order of the elements.  For example, [x] &amp; [y] = [x,y], and
[x,y,z] &amp; [w,z] = [x,y,w,z].  Intuitively, the algorithm merges
the two lists in such a way that the elements from the most specific
operand (the rightmost operand) is inserted as far as possible to the
right (the most specific end of the result list).  The technical
details are described in the ECOOP'99 paper and the PhD thesis, which
are described on the _papers_ref(`papers') page.  
</p>

<p>
The grammar allows pattern expressions almost everywhere a single
pattern is required, so it is not necessary to invent a name for a
combination of patterns which is only used in one place.  This is the 
most direct example of the combinations everywhere that the title
of this page talks about.
</p>

<p>
Combinations of patterns in _gbeta can also be characterized as
ubiquitous in a deeper and more powerful sense.  This is associated 
with the concept of <EM>propagating</EM> pattern combination, which
is the topic of the ECOOP'99 _papers_ref(`paper').  The basic  
motivation behind propagating combination is that it allows an 
encapsulated design whereby systems of classes can be combined 
at the top level, and an unlimited number of internal 
(encapsulated) combination operations determined by the structure 
of the class system will automatically and implicitly be performed.
</p>

<p>
As an example, consider a family of classes such as a
<code>Graph</code> which contains the members <code>Node</code> and
<code>Edge</code>.  From the abstract family <code>Graph</code> it is
now possible to create two sub-families <code>WeightedGraph</code> and
<code>ColoredGraph</code>, both inheriting from the <code>Graph</code>
family, and both adding state and further-binding methods as needed.
Now, the two subfamilies can be combined with a single operation, with
an expression like <code>ColoredGraph&amp;WeightedGraph</code>, and
the result will be a graph which supports both weighted edges and
graph coloring facilities.
</p>

<p>
The point is that the single toplevel combination operation,
syntactically specified by the simple expression
<code>ColoredGraph&amp;WeightedGraph</code>, is applied
<EM>recursively</EM>, such that the combination of the two families
propagates into the block structure.  In other words, the explicit
combination of two class families is implicitly propagated to each of
the members of the family, and again implicitly propagated to the
methods of each member.  In this way, a <code>print</code> method,
say, in the <code>Edge</code> class of the combined family may have
some behavior from the <code>print</code> method in <code>Edge</code>
in <code>ColoredGraph</code>, and some other behavior from the
<code>print</code> method in <code>Edge</code> in
<code>WeightedGraph</code>.  A programmer who wants to use a graph
with a given set of features simply merges some suitable sub-families
of <code>Graph</code>, and all the internal merging operations take
place automatically and implicitly.  Of course, just like inheritance
can be misused and inheritance hierarchies must be designed carefully
in order to work well, this kind of effortless combination is only
possible when the propagation mechanism is used well.
</p>

<p>
With the powerful tool that propagating combination is, a whole new
world of reuse and abstraction opportunities is opened, because things
which could not otherwise be combined can now be combined, and
therefore it makes sense to write them separately in the first place,
like <code>ColoredGraph</code> and <code>WeightedGraph</code>.  The
propagation mechanism could be described as a language integrated
mechanism which supports aspect oriented programming, and indeed this
has been an important source of inspiration, along with other
approaches including subject oriented programming and adaptive
plug-and-play components.  However, it differs in many respects, in
particular in the area of typing where the _gbeta propagation is
tightly integrated with the type system whereas other approaches do
not support the combination of types (you can do such things as
putting statements into methods with the other approaches, but not,
e.g., change the type of an argument of a method).  Again, more
detailed descriptions are given in the _papers_ref(`papers').
</p>

<p>
The _next_adv_ref(next) topic is much more mundane, it is about
<code>if</code>-statement and such.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
