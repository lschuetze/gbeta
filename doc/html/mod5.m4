m4_include(modularizationstd.m4)m4_dnl
begin_page(`A Concrete Example (continued)')

<p>
In the last section we promised to explain how the
<code>asString</code> method can be provided even though the
declarations of the <code>ordered</code> patterns and its subpatterns
contain no such method.  An important precondition is the declaration
of the slots named <code>OrderedLib</code>, <code>TextLib</code>,
<code>NumberLib</code>, <code>IntLib</code>, and
<code>FloatLib</code>.  These slots are of the syntactic category
<code>attributes</code>.  This means that we can provide attribute
declarations to these patterns by means of these slots, thereby, e.g.,
adding new methods to the patterns.  That is exactly what we need to
do.
</p>

<p>
Note that there is nothing new in this compared with the fragment
system in the language BETA; however, there is a difference between
the (ideal) definition of the fragment system and the actual
implementation in the _mjolner, so the following would not compile
under Mjolner BETA, but it <em>is</em> supported in the implementation
of _gbeta. 
</p>

<p>
So, to return to the concrete example, we add an extra method to many
of the patterns, so we can obtain a printable representation of a
given <code>ordered</code> entity:
</p>

program_box(cq[[(* FILE orderedAsString.gb *)
ORIGIN 'ordered'; 
ORIGIN 'orderedText';
ORIGIN 'orderedNumber'

-- OrderedLib:attributes --

asString:&lt; (# s: @string do INNER exit s #)

-- TextLib:attributes --

asString::(# do value-&gt;s #)

-- IntLib:attributes --

asString::(# do '&lt;anInt&gt;'-&gt;s #)

-- FloatLib:attributes --

asString::(# do '&lt;aFloat&gt;'-&gt;s #)]]nq)

<p>
In order to keep the example short and complete we have skipped over
the problem of printing numbers and just return the string
<code>&lt;anInt&gt;</code> for all <code>int</code> objects and
<code>&lt;aFloat&gt;</code> for all <code>float</code> objects.
</p>

<p>
With these definitions the example is complete.  It is worth
considering the type properties of this inheritance hierarchy.
Usually it would give rise to typing problems to have both
<code>text</code> and <code>number</code> derived from
<code>ordered</code>.  The problem is that if <code>ordered</code> is
an ordinary class then this implies that any two <code>ordered</code>
objects can be compared, and this is probably not meaningful for a
<code>text</code> and a <code>number</code>; we would like to be able
to compare <code>number</code>s and <code>text</code>s with their own
kind, but the type system ought to complain if the two groups of
<code>ordered</code> things are mixed.
</p>

<p>
To obtain this level of correctness check we could use something else
than a class for <code>ordered</code>.  In languages with
parameterized classes (C++, Eiffel, Cecil, GJ, Pizza, ..) it would be
possible to make <code>ordered</code> a parameterized class.  This
normally means that <code>text</code> and <code>number</code> would
become <em>unrelated</em> classes, and that would ensure that the two
kinds of <code>ordered</code> objects would be kept separate by the
type system.  With F-bounded polymorphism and explicit co-variance and
contra-variance declarations, as in Cecil, it is even possible to
allow comparisons of subclasses of instances of <code>ordered</code>,
such as <code>int</code> and <code>float</code>.  However, it is not
possible in these languages to refer polymorphically to an arbitrary
<code>ordered</code> object and call such a method as
<code>asString</code>.  The problem is that <code>ordered</code> is
not a class, and hence there is no way to declare a polymorphic
reference (variable, field, pointer, whatever it's called in the given
language) to such objects.
</p>

<p>
The BETA and _gbeta type systems handle this problem in a more general
manner.  The approach taken is not to uncritically make all the
subpatterns subtypes (which leads to the confusion problem mentioned
above), and it is not to make <code>ordered</code> a non-class (which
leads to the cannot-call-<code>asString</code>-polymorphically
problem), but to use <em>computed types</em>.  Types in BETA and
_gbeta do not have an explicit representation in the program, they are
all inferred.  Patterns are explicit, but types differ from patterns
in that they include a description of what properties all the possible
patterns in a given context might have.  One of the consequences of
this is that it is recognized as safe by the type system to call
<code>asString</code> on an object which is only known as being an
instance of a pattern which is less than or equal to
<code>ordered</code>.  At the same time, the type system recognizes
that it would <em>not</em> be safe to compare two objects of which the
same is known.  Comparison is only safe when the objects are both
known to be less-equal than <code>number</code>, or when they are both
known to be less-equal than <code>text</code>.  (Note that the
<em>final</em> bound on <code>cmpType</code> in <code>number</code>
and in <code>text</code> plays a crucial role in this connection).
</p>

<p>
In this approach, individual methods are marked as "OK" or "Nope, not
safe" to call by the type system, depending on the level of knowledge
about the involved objects.  Compared to the approaches where types
are explicit (and generally constant as seen from all points in the
program), this approach based on computed types allows for a greater
freedom for programmers, because more of the safe actions are
recognized as safe by the type analysis.  The dynamically typed
approaches (e.g. Smalltalk) also allow all the safe actions, but that
is just because <em>everything</em> is allowed, including such things
as comparing a <code>text</code> with a <code>number</code>, which is,
rightfully, caught as a type error in all the statically typed
approaches.
</p>

<p>
As expected, the patterns in our example have the desired type
properties: <code>number</code> is specialized to <code>int</code> and
to <code>float</code>, and the final bound on <code>cmpType</code> in
<code>number</code> ensures that all kinds of numbers can be compared.
Similarly, <code>text</code> objects can be compared.  However, if a
<code>text</code> and a <code>number</code> are compared with each
other, the static analysis will complain that this is not typesafe, as
it should.  Finally, the method <code>asString</code> can be called on
any <code>ordered</code> object, even if we do not know whether it is
a <code>text</code>, or a <code>number</code>, or yet another
subpattern of <code>ordered</code>.
</p>

<p>
A more detailed presentation of these issues is given in
the _papers_ref(`PhD thesis').
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
