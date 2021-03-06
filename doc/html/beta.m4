m4_include(gbetastd.m4)m4_dnl
begin_page(`What is BETA?')

<p>
The programming language 
<a href="http://cs.au.dk/~beta" target="_top">BETA</A>
is an old, but very innovative member of the Scandinavian
family of object-oriented
languages.  The first member of this family was Simula, the first
object-oriented language of them all.  BETA preserves the important
concepts from Simula, such as inheritance, virtuals, general block
structure (nesting), and concurrency as a well-integrated aspect.
Many of these concepts are well-known from various newer
object-oriented languages.
</p>

<p>
BETA generalizes Simula in various respects, by lifting a
number of restrictions on allowed combinations of language elements.
In BETA it is, e.g., possible to inherit across enclosing-object
boundaries, whereas a derived class in Simula must "live in the same
context" as its super-class.  This is an example of a restriction
which might seem superficial, but in fact it has very deep
implications for the universe of possibilities experienced by
programmers, and for the implementation of the language. 
</p>

<p>
Compared to other, modern object-oriented languages with static
typing, BETA is a very general and at the same time minimal language:
Few constructs with lots of expressive power.
</p>

_h3(`Unification and Orthogonality')

<p>
BETA simplifies and unifies the language constructs to an
unusual extent.  Descriptions of substance are made 
using <em>patterns</em>, and substance is realized in the shape of
<em>objects</em>, instantiated from patterns.
</p>

<p>
As a result, there is no separate notion of "classes" and "procedures"
or "methods."  If a pattern is instantiated, and the resulting object
is executed and then forgotten (ignored), the substance works like the
invocation record for a procedure call: a place to keep some local,
short-lived state during the execution of a series of actions.
</p>

<p>
Assume that a pattern is instantiated in such a procedure-call like 
scenario, and that it is nested within an object and affects the state
of that object.  In this case, a natural way to describe it would be
as a method invocation:  A series of actions is executed in the context
of some object in order to investigate or change the state of that
object.
</p>

<p>
Syntactically it turns out to look rather conventional:
<code>anObject.aMethod</code> would describe this method-call scenario,
assuming that <code>anObject</code> is an object and
<code>aMethod</code> is a pattern whose declaration is textually
nested in the declaration of the pattern of <code>anObject</code>.
</p>

<p>
Patterns, objects, and nesting together are versatile enough to define
the notion of method calls, and we get two main benefits compared to
the traditional approach where a method is a primitive (irreducible)
concept.  Firstly, it is more general, since there is no need to
invent new language constructs in order to support such concepts as
reference to method (also known as <em>closure</em>) or reference
to method invocation (known in Smalltalk as <em>context</em>).  
Another concept that the generality gives us is that of
method inheritance, or  <em>pre-methoding</em>, which is a very useful
concept, almost only supported by BETA, but related to method
combination in CLOS (based on <code>:before</code> methods,
<code>:after</code> methods, and <code>call-next-method</code>). 
Secondly, the language is kept small, tight, and hence easier to get
to know well.
</p>

<p>
BETA is very orthogonal, i.e. it is possible to combine these very
general language elements freely, with only few exceptions.  Using
many separate language constructs, each less general than BETA's,
might yield a similar expressive power, but with countless dark corners
of unexplored interactions and special cases.  Creating one special
case in a language is the certain way to breed lots of other special
cases, when integrating the first special case with the rest of the
language.
</p>

_h3(`Inspiring other languages')

<p>
Recently, the basic concept of general block-structure (i.e. nested
classes) has emerged in such a trendy language as Java.  Since nesting
has only been an integral part of the Scandinavian object-oriented
languages since the sixties, it is tempting to see it as an
inspiration from Scandinavia.  However, functional programming
languages have also had the notion of (true) closures for many years,
and blocks in Smalltalk, Self, and Cecil are also related to the
notion of closures.  Anyway, it's an important step forward.
Moreover, there is active work in the Java world in the direction of
introducing concepts inspired by virtual classes.  Virtual classes is 
a contribution of BETA which has been well-defined and implemented 
since around 1980, and _gbeta now provides a generalized version of
this concept.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
