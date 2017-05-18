m4_include(gbetastd.m4)m4_dnl
begin_page(`',`<center><img src="cupper.jpg" alt="gbeta"></center>')

_h1(`What is _gbeta?')

<p>
<big>
  _gbeta is a programming language in the Scandinavian
  tradition starting with Simula, initially created as a deep
  generalization of the language _beta_ref(`BETA').  It
  supports a fully general version of family polymorphism,
  as well as propagating combination of classes and methods
  (also known as deep mixin composition), and many other powerful
  language mechanisms.  You can _download_ref(`download') a 
  compiler and execution environment for _gbeta, and the source
  code of this implementation is freely available under the
  _copyright_ref(`GPL') license.
</big>
</p>

m4_define(`_small_logo',
<div align="center">
  <table border=0 cellpadding=0 cellspacing=0 bgcolor="`#'DDDDFF">
    <tr><td><img src="logo-small.jpg" alt="small gbeta logo"></td></tr>
  </table>
</div>)m4_dnl

<p>&nbsp;</p> 
_small_logo

_h3(`Here are some features of the language')

<p>
The language _gbeta emphasizes orthogonality and generality in the
sense that it offers few, but powerful language mechanisms, which
may in turn be combined freely.  In particular, it enables defined
entities such as classes and methods to be extended and refined by
filling in placeholders as defined by the language or indicated by
keywords.  At this point we will describe some of these mechanisms
briefly; the details may be looked up elsewhere on this website,
e.g., in the tutorial.
</p>

<p>
Starting with a very well-known incarnation of this principle, one
type of open placeholder is the list of declarations of features in a
class.  Using this extension feature simply means adding new
declarations in a subclass, e.g., such that a <code>ColorPoint</code>
class can have a <code>getColor</code> feature in addition to the
features of its superclass <code>Point</code>.  It is of course
possible to do exactly the same thing in essentially every
object-oriented language today, but in _gbeta it is just one out of
several modes of extension, and they are not all equally mainstream.
</p>

<p> 
One type of open placeholder in _gbeta which is less well-known is
concerned with a list of statements in the body of a method.  By
default, extra statements can be added at the end of such a list,
which means that a method in a subclass will do what the superclass
does, and then proceed to execute additional statements specific to
the subclass.  An explicit keyword, <code>INNER</code>, may be used to
indicate that an arbitrary location in the method body should be used
as the open placeholder rather than the end of the method.  Note that
this means that the behavior of a method in a subclass is an
<em>extension</em> of the behavior of the method in the superclass,
rather than a <em>replacement</em>.  It is as if the code in a method
is accumulated when traversing the inheritance path from the place
where the method is first declared down to the run-time class of the
object whose behavior is being considered, and then every inheritance
level gets the opportunity to "fill in the blank" with its method
body, where "the blank" is the (single or multiple) occurrence of
<code>INNER</code>, or the end of the method if no <code>INNER</code>
is present.
</p>

<p>
An old controversy lies herein.  In fact, it takes some time to get
used to the idea that methods should not override other methods, they
should <em>refine</em> them by adding new behavior to the placeholder
locations.  This philosophy is strictly enforced in BETA, but in
_gbeta it is possible to force a replacement (as in a standard
override semantics of method redefinitions), by means of the flexible
support for mixin composition and even reordering in _gbeta.
Nevertheless, the fundamental structure of the language emphasizes
extensions and refinements, and it is indeed possible to achieve a
style of programming where this structure is put to good use.  Other
parts of the language design help in this respect, because they enable
flexible management of definitions whereby the need to override (i.e.,
regret and undo) inherited behavior may be avoided in almost all
cases, because the amount of boilerplate code it takes to request a
certain (default) behavior exactly where it is needed is much smaller
than in most other languages.  As you may already have guessed, this
language is non-standard in a number of ways, and it may be necessary
to rethink some programming habits in order to get "into" this kind of
programming.
</p>

<p>
A third type of open placeholder is an inner class.  Such a class may
be declared as a feature of its enclosing object, and it may be
refined (to a subclass) in a subclass of the enclosing class.  This
mechanism is commonly known as a <em>virtual class</em>, and _gbeta
supports a very general notion of virtual classes where a refinement
declaration (traditionally known as a <em>further-binding</em> of the
virtual class) may refine that class by means of a mixin-based
combination process that recursively propagates into the block
structure.  In other words, a virtual further-binding may change that
virtual class to a subclass containing virtual classes which are
themselves further-bound to subclasses of their previous values, and
so on.
</p>

<p>
Finally, _gbeta unifies classes, methods, and many other language
constructs into a single abstraction mechanism, the <em>pattern</em>.
This means that everything said about methods above applies to
classes as well, and vice versa.  So, for instance, the recursively
propagating combination process mentioned above applies to methods
inside classes, and classes inside methods, and classes inside classes
inside classes, and all other nesting sequences, because they are
technically just patterns all of them, and only their intended style
of use makes it natural to prefer the word "class" when talking about
some of the patterns and "method" when talking about others.  An
"object" is just an instance of a pattern which is kept around for a
while because its state and identity is useful, whereas a "method
invocation" is an instance of a pattern which is useful primarily
because of its side-effects on the enclosing object or its returned
results.  In any case, it is a property of objects that they may have
a declared communication interface (traditionally known as the
<code>enter</code>- and <code>exit</code>-list), and this may be used
as the argument list and returned-results list of the "method
invocation" if the object is being used as a method invocation, or it
may be interpreted as a user-defined assignment/evaluation semantics
for the logical state of the object, if it is used as a traditional
"object".
</p>

<p>
The _gbeta language is statically typed, and the core of the type
system has been proven sound (NB: the literature about such things is
listed on the _papers_ref(`papers') page, but the text of this website
does not in general include literature references, because it is
oriented towards practical use of the language and tools).  The type
system is special in that it deals with run-time values; in
particular, types depend on their enclosing objects such that "the
same type" inside two distinct objects are in fact distinct types.
Inclusion of run-time values into the type domain is commonly known
as dependent types, and in this case they are quite simple because
they are only concerned with object identity.  A type is considered to
be inside an object in the same sense as an instance of a Java inner
class is considered to be inside an enclosing object.  This is known
as <em>family polymorphism</em>, and another terminology which
specifically puts the focus on the value dependency is
<em>path-dependent types</em>, which was coined by Martin Odersky
when he introduced a variant of this kind of types in the language
Scala.  Together with propagating combination this enables
<em>higher-order hierarchies</em>, which is the ability to use
inheritance to create extensions and variants of entire inheritance
hierarchies rather than single classes.
</p>

<p>
Inheritance in _gbeta is based on mixin composition, which is again
governed by a linearization algorithm.  A class is (conceptually,
though not necessarily in the implementation) just a list of mixins.
A type, however, is a set of mixins, because the ordering is
irrelevant from the typing point of view.  Being a subtype is the same
as being a superset in terms of mixins, and this means that the
subtype hierarchy is the full lattice of all the possible sets of
mixins, connected by subtype edges according to whether or not there
is this superset relation among their mixins.  In other words, _gbeta
subtyping is structural with mixins as the basic granularity.  It is
nominal with respect to individual declarations, because I found
it natural to associate a group of declarations in a declaration block
(which is just a brace-enclosed block, <code>{..}</code>) with a
certain interpretation or contract, such that we do not mess up the
<code>draw</code> method which means "put some pixels on the screen"
with the <code>draw</code> method which means "get ready to shoot
somebody".  We do not care, however, exactly which inheritance (or
class combination) expressions were used to provide us with one or the
other of those <code>draw</code> methods (or both, indeed, because
they may actually co-exist in the same object and still be both
individually callable and dynamically dispatched).
</p>

<p>
A special concept in _gbeta is that of an <em>invisible mixin</em>.
An invisible mixin is a mixin that contains only private declarations,
which may also be additions of invisible mixins to nested classes or
methods.  The point is that the presence or absence of an invisible
mixin in a class makes no difference for the accessible features of
its instances, or the accessible features of instances obtained
indirectly, e.g., as the returned result from a method.  Hence,
invisible mixins may be added or even removed from classes or objects
without affecting their type properties.  Typically, invisible mixins
are used to express the implementation layer of a class.
</p>

<p>
In _gbeta, <em>object metamorphosis</em> coexists with strict,
static type-checking:  It is possible to take an existing object and
modify its structure such that it becomes an instance of a given
class, which is possibly only known or even constructed at run-time.
In general, the new class of the object must be a subtype of the old
class of the object, such that it never gets a smaller set of defined
features (which could lead to a message-not-understood error at
run-time).  Hence, the static analysis ensures run-time type safety,
even in such a dynamic scenario as that of objects changing their
class.
</p>

<p>
It is possible to define relations between virtual classes, e.g., to
specify that the class <code>MyPoint</code> must be a subclass of
<code>YourPoint</code> (without committing to exactly what classes they
are).  This makes it possible to define a kind of <em>constraint graph
of classes</em>.  It ensures that certain relations hold, such that
one inheritance operation may give rise to a complex but orderly
propagation of type changes in a framework of classes.  These
inter-virtual-class subtype constraints are not a new mechanism in the
language, they are just the natural explanation of the effect of using
one virtual class as the superclass of another one.
</p>

<p>
Moreover, _gbeta supports inheritance hierarchies not only for
classes but also for methods.  This can be used together with dynamic
inheritance to build <em>dynamic control structures</em>; dynamic
control structures enable your algorithms to be parameterized with
e.g. a while statement, an iteration through all elements of a given
list, or reading input from a file.  Note that a control structure as
a parameter is richer than a procedure or function parameter, because
the control structure can provide a name space to its body, just like a
built-in <code>.
</p>

<p> 
There are many other features in _gbeta which are innovative compared
with the mainstream, and some of them are discussed in the pages of
this website.  As mentioned, the scientific literature discusses the
things mentioned above in more detail, but this website does not
include literature references at the level expected in a research
paper because of its orientation towards practical programming.
Please consult the papers mentioned in _papers_ref(`papers') for a
more detailed treatment.
</p>

_h3(`A Bit of History')

<p>
The language _gbeta was originally created in order to try out
the language design space around the language _beta_ref(`BETA'), 
i.e., to try out different design choices than the ones which
have been made in BETA, and in particular to generalize the basic
concepts.  To this day, _gbeta shares a number of fundamental
properties with BETA, so if you have knowledge about BETA, or even
BETA programming experience, it will be usable in an indirect manner
in a _gbeta context.  For instance, the radical unification and the
pattern concept were invented for BETA, but they have been deeply
generalized in _gbeta.  Moreover, the _gbeta syntax has a similar
structure as the BETA syntax, but it probably takes a careful
analysis of the very different looks of actual programs to see
how much they have in common.  For instance, arguments passed to a
method and results returned are declared in very different
locations in a BETA and a _gbeta method declaration, but it is still
the case that both are capable of declaring a list (tuple) of results
to return, and both use a recursive semantics for argument and return
specifications that enable abstraction (which means that argument list
structures and types may be reused as a named abstraction rather than
by copy-paste operations on actual lists of declared names).
</p>

<p>
Already BETA has strong support for <em>co-evolution of classes</em>,
expressed as mutually dependent virtual patterns.
For example, the classes <code>Vehicle</code> and
<code>Operator</code> might depend on each other, and they should
"know" each other's enhancement to <code>Car</code> respectively
<code>Driver</code>.   The support for class co-evolution is even
more powerful and flexible in the generalized language _gbeta,
because of its support for general, mixin-based, propagating class
combination, where BETA is restricted to strict, static
single-inheritance.  In this way, and in many other ways, BETA
experience may give hints about what _gbeta can do, but it may also
lead to some confusion because of the generalizations and lifted
restrictions in _gbeta compared to BETA.
</p>

_small_logo

_h3(`Who does not want it, then?')
<p>
There is currently no support for calling external code, such as C
or Java libraries, and this prevents the direct use of standard
libraries from various other sources.  The virtual machine is special
to _gbeta, so there is no JVM or CLR or similar well-known platform
running underneath, either.  Another limitation is in program size.  It
would cost too much memory and take too long to run e.g. a 100,000
line program (using many libraries pushes the effective line-count
up); up to 3000 lines is more realistic.  The current _gbeta
implementation is more for the (academic) geek who is interested in
programming language design and type systems, and less for the
no-nonsense practical programmer who wants to write large
mission-critical applications. In other words, it's slow but it uses a
lot of memory. <code>;-)</code>
</p>

_small_logo

_h3(`<a href="mailto:eernst@cs.au.dk">Feed-back</a>')

<p>
is always welcome, about the language and/or its implementation, about the
language design effort that it incarnates, and about this web site.
</p>

_small_logo

_h3(`Aahhh, yes...')

<p>
...the funny symbol on the many colored background is the
_gbeta logo, a stylized version of the letters "gb".  You are
welcome to use this logo on your own web pages if you want to refer to _gbeta.
And here is a picture which shows a situation during a _gbeta session hosted in
GNU Emacs (click on it to see more):
</p>

<div align="center">
<table align="center" border=1 bordercolor="navy" cellpadding=0 cellspacing=0>
<tr><td>
  <a href="gbeta-screen.jpg" target="top">
  <img src="gbeta-small-screen.jpg" alt="screen shot"></a>
</td></tr>
</table>
</div>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
