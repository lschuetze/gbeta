m4_include(tutorialstd.m4)m4_dnl
begin_page(`Specialization (Inheritance)')

<p>
The language mechanism which is often called "inheritance" in other
languages is normally called <em>specialization</em> in BETA
terminology and hence also in _gbeta.  This reflects the importance
of concepts and their
relations in the _tutref(1,`conceptual framework'): specialization is a
relation between a more general concept and a more special concept,
the opposite of generalization.
</p>

<p>
The term <em>inheritance</em> focuses more on the fact that individual
attributes are "inherited" from a base class, and it does not very
much support the consideration that each involved class as a whole is
associated with a concept in the minds of designers and programmers,
and that those concepts are related in the real world.
</p>

<p>
In other words, the term specialization gives priority to the
<em>modeling</em> relation between program executions and the
application domain.  Consequently, words like "inherited" are used
below exactly when the focus is on those individual attributes.
</p>

_h3(`How does it look?')

<p>
Single inheritance is expressed by putting an
<code>&lt;AttributeDenotation&gt;</code> (e.g. an identifier) in front
of a _tutref(2,`main part'), like this:
</p>

  code_box(`&lt;ObjectDescriptor&gt; ::= &lt;AttributeDenotation&gt;
            &lt;MainPart&gt;')

<p>
The <code>&lt;AttributeDenotation&gt;</code> denotes the
super-pattern, i.e. the pattern which is being specialized.  An
example is:
</p>

program_box(cq[[
p: boolean(# a: (# #)#);
q: p(# b: a(# #)#);]]nq)

_h3(`How does it work?')

<p>
Many things are well-known.  Attributes are inherited from the
super-pattern.  If a name is declared both in the super-pattern and in
the new main part, the declaration in the main part shadows the one in
the super-pattern when the statically known type includes both.  This
is just like all other statically typed object-oriented languages.  
</p>

<p>
For <em>changing</em> an inherited declaration in stead of shadowing
it, the inherited declaration must have been marked as changeable,
similar to C++ and different from Eiffel.  It must be a
_tutref(8,`virtual pattern').  This means that changeability must be
designed into attributes, which might be a bad thing (as uttered by
Eiffelists), but in return the type system is safe without a global
analysis (as suffered by Eiffelists ;-).  For those few places where
you want covariance, you can get it, and the type-checker will give
you a warning at precisely the dangerous statements.  For normal
programming without covariance, it can be checked locally that type
errors cannot occur at run-time.
</p>

<p>
Please note, however, that the notion of virtual patterns is a lot
more expressive than the notion of virtual methods.
</p>

_h3(`The <code>INNER</code> statement, and the BETA inheritance "style"')

<p>
Specialization can be viewed as adding up main parts, and main parts
have an associated behavior, specified in the <code>do</code>-parts.
This behavior is <em>combined</em> by the specialization mechanism,
not overridden.
</p>

<p>
The way it is combined may be viewed as a search-and-replace process
which puts the more special <code>do</code>-part into the more general
one (i.e. the super-pattern <code>do</code>-part), one copy for each
occurrence of the <code>INNER</code> statement.  In this way, the
<code>INNER</code> statement may be described as "the opposite of a
super-call," because the super-pattern can execute <code>INNER</code>
wherever it wants the behavior from the sub-pattern to be inserted,
not the other way round.
</p>

<p>
Please note that actually doing the search-and-replace as described
above would not give the right semantics for name lookup:  Names are
looked up from the actual position in the syntax, and the
search-and-replace process will generally put code in a place where
some declarations are missing or different.  For the pure behavior,
however, the search-and-replace description is accurate.
</p>

<p>
Another point of view is that the specialization process (from the
most general to the most special pattern) is a process which gradually
<em>completes</em> the behavior.  Each level can leave some
unspecified place holders (in the form of <code>INNER</code>) which
can be filled in differently in different sub-patterns.
</p>

<p>
Using <code>INNER</code> can be wonderful, self-evident, expressive,
just right, and simple, but probably it seems backward and complicated
if "super" and overriding semantics is your normal universe.  It
probably takes months or years to adjust the entire design approach
and programming habits to one or the other.  
</p>

<p>
One important aspect is: Since you cannot "throw away" the
super-pattern behavior, you <em>will</em> have to design in a very
clean way, writing only the behavior in your super-patterns which is
relevant in all cases.  This also goes against a very ad-hoc oriented
philosophy, where the modification of existing classes to work in a
new context is viewed as very important, for "reuse".  In this
philosophy, it should be possible to take whatever code which
resembles what we need and tweak it by inheritance in such a way that
it does what we want. 
</p>

<p>
The BETA (and in general, Scandinavian) point of view is that a
specialization hierarchy should be designed as a conceptually sound
totality, with commonalities expressed in as general a position as
possible.  In principle the entire hierarchy should be conceptually
well-formed, and we should never need to "adjust" a super-pattern
because it wasn't designed for this particular usage.
"Un-inheritance," such as overriding a behavior (or for that matter,
if supported, discarding some inherited attributes), is viewed as a
messy business which pollutes the pattern (or class) universe with
contradictions.  In general, discarding attributes makes the type
system unsafe, so it is seldom supported.  Discarding behavior
introduces a similar breach of safety, since the super-pattern can
never rely on certain actions taking place.  Typical examples are
known from the interplay of concurrency control and inheritance, often
termed the "inheritance anomaly."
</p>

<p>
As a consequence, there are more abstract patterns in BETA programs,
because we should not commit to things that we don't want to keep
anyway. 
</p>

<p>
Give it a chance, it <em>does</em> work in practice!
</p>

_h3(`Specialization and evaluation')

<p>
Just like attributes and behavior is collected and added up from the
contributing main parts, input/output properties are added up by
concatenating the <code>enter</code>-lists and the
<code>exit</code>-lists.  The example below shows how, in the
<code>init</code> method.
</p>

_h3(`Example 4')

<p>
This example shows how specialization and <code>INNER</code> plays
together to create more complex behaviors from less complex ones by
"filling in the blanks."
</p>

program_box(cq[[<small>
(* FILE ex4.gb *)
-- betaenv:descriptor --
(# 
   putline: (# enter stdio do '\n'-&gt;stdio #);
   person: 
     (# initPerson: (# enter name #);
        name: @string;
        printPerson: (# do 'Name: '+name-&gt;putline; INNER #);
     #);
   student: person
     (# initStudent: initPerson(# enter id #);
        id: @string;
        printStudent: printPerson(# do 'ID: '+id-&gt;putline; INNER #);
     #);
   freshman: student
     (# initFreshman: initStudent(# enter nickname #);
        nickname: @string;
        printFreshman: printStudent
          (# do 'Also-known-as: '+nickname-&gt;putline; INNER #);
     #);
   Smith: @freshman;
do 
   ('Smith','533987/26B','Bunny')-&gt;Smith.initFreshman;
   Smith.printFreshman;
#)</small>]]nq)

<p>
Of course, this example will get nicer when we get to virtual patterns
in the _next_tut_ref(next) section. 
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
