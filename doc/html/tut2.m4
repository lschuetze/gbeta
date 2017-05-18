m4_include(tutorialstd.m4)m4_dnl
begin_page(`The Concept of a MainPart')

_h3(`What it means')

<p>
A <em>main part</em> is the syntactic construct which declares a
mixin, which may again be considered as the building block from
which classes are built, but because of the unification of classes
and methods it is also a building block for behavior composition.
These semantic aspects will be discussed in various ways along the
way, but we will start with the syntax in order to make main parts
entirely concrete.
</p>

_h3(`How it looks')

<p>
A <em>main part</em> is a syntactic construct, so you can just look
it up in the grammar (the file gbeta-meta.gram in the distribution).
Roughly, it looks like this:
</p>

  code_box(cq[[%(&lt;enter-list&gt; | &lt;exit-list&gt;){<BR>
&nbsp;&nbsp;&lt;declarations&gt;<BR>
#<BR>
&nbsp;&nbsp;&lt;statements&gt;<BR>
}]]nq)

<p>
The <code>&lt;declarations&gt;</code> section is a list of
declarations of local features such as local variables, local
methods, or local classes.
The <code>enter-list</code> specifies input properties, i.e. arguments
accepted for the purposes of a method call or a user-defined
assignment.  The <code>statements</code> part is a list
of statements which defines the behavior associated with this main
part.  Finally, the <code>exit-list</code> specifies the output
properties, i.e. values delivered when evaluating the main part,
which could be interpreted as return values from a method call or as
a user-defined representation of the object state in connection with
state evaluation or assignment.
</p>

<p>
All the elements are optional, so the list of declarations may be
empty, and any selection of the <code>enter-list</code>,
<code>statements</code>, and <code>exit-list</code> may be absent.
The syntactic separator "<code>|</code>" between input and output
specifications is omitted when at the end, i.e., when
the <code>exit-list</code> is empty, and the syntactic separator
"<code>#</code>" between declarations and statements is omitted if
the list of <code>declarations</code> and/or the list
of <code>statements</code> is empty.  The entire parenthesis 
<code>(&lt;enter-list&gt;|&lt;exit-list&gt;)</code> is omitted if
there is no support for input and output, and in this case the
initial "<code>%</code>" may also be omitted, which means that the
main part is invisible, i.e., that all features declared in there
are private.
</p>

<p>
All in all, this means that the main part is both a
quite light-weight construct when only a few of the basic elements
are present, and it is a very rich construct when everything is
there.  This is a consequence of the high degree of language
construct unification in _gbeta; in fact, the main part is the only
syntactic construct there is for the declaration of abstractions,
e.g., methods and classes.  Another way to say this is that main
parts are the building bricks used to construct substance in _gbeta
programs.  Either something is _tutref(16,predefined) (like the
basic pattern <code>int</code>), or it was constructed using a
number of main parts.  Like a recursive set, there are atomic
elements, the predefined patterns, and composite elements, built
from "smaller" elements using main parts.
</p>

_h3(`Related syntax in other languages')

<p>
Main parts are related to declaration blocks in other languages, such
as e.g. the brace-enclosed blocks used to derive a new class from an
existing one in C++,  
</p>

  code_box(`class D : public B <font color="blue"><b>{ .. }</b></font>;')

<p>
or the similar Java syntax, or the keyword-enclosed feature block used
in Eiffel.  They are also related to behavior specification blocks,
such as the brace-enclosed function bodies of a C or C++ or Java
program 
</p>

  code_box(`int my_func(float *arg) <font color="blue"><b>{ .. }</b></font>')

<p>
or the keyword-based Eiffel equivalent.  Finally, they include
the specification of input/output properties, for instance in a
parenthesized argument list, or in a specification of the type of a
returned value.
</p>

_h3(`Main parts can do it all!')

<p>
Main parts are very versatile, supporting both the description of
substance (declarations) and behavior (statements), and specifying
input/output properties (enter-/exit-lists), and this allows them to
support the unification of classes, methods, co-routines, control
structures, exceptions, and a lot more.  Since main parts are so
feature-rich and self-contained, they enable _gbeta to support
anonymous entities of many kinds.  For instance, the anonymous
function that squares an integer is
simply <code>%(i:int|i*i)</code>.
</p>

<p>
The trade-off is that it is a matter of convention how a given main
part is used in a program.  It may be constructed in such a way that
usage as a method is the only reasonable choice, and it may be
designed specifically to support a class-like usage.  In practice it
is rarely a problem to understand the intended use, and often the
generality allows a natural and valuable usage which was
nevertheless unforeseen.
</p>

_h3(`Example 1')

<p>
The first example is a program which is similar to the
<code>hello2.gb</code> program introduced in the "Getting Started"
section:
</p>

program_box(cq[[(* FILE ex1.gb *)
-- betaenv:descriptor --
(# 
   hello: (# exit 'Hello' #);
   print: (# enter stdio #)
do 
   hello+', world!\n'-&gt;print
#)]]nq)

<p>
Until you start looking into the 
_modularization_ref(`module system'), you may consider the 
</p>

  code_box(`-- betaenv:descriptor --')

<p>
to be "standard magic" which is necessary to make _gbeta accept the
program..  
</p>

<p>
Declarations are associated with a colon and possibly some other
characters, with the declared names to the left of the colon, and the
value or type contraint to the right.
</p>

  code_box(`</TT>Declaration: 
            <TT>&lt;names&gt; ":" .. &lt;valueOrConstraint&gt;')

<p>
A _gbeta program is ultimately a main part, the outermost block, and
this block encloses everything in the program except for the few
_tutref(16,predefined) entities.  That is the main part which
constitutes the whole program.  Inside this main part, the patterns
<code>hello</code> and <code>print</code> are declared as declarations,
and there is a do-part which uses these declarations.
</p>

<p>
The pattern <code>hello</code> uses only the exit-part, and this is
used for delivering values.  When the value is a constant, the whole
pattern may be considered a constant function, or simply "a constant."
If this exit-part had contained a complex evaluation, much activity
could have been the result of evaluating <code>hello</code>, such as
it happens in the plus-expression in the do-part.
</p>

<p>
The pattern <code>print</code> uses only the enter-part, i.e. it has
input properties but no declarations, behaviour, nor output properties.
The input properties are directly taken over from <code>stdio</code>,
which is a _tutref(16,predefined) entity that enables _gbeta programs
to read from the standard input and write to the standard output.
Please note that <code>stdio</code> is not an example of careful
language design, it was simply a quick, easy solution to the problem
that _gbeta had to be able to communicate with the rest of the world.
Anyway, putting a value into <code>print</code> is exactly the same as
putting a value into <code>stdio</code>, and that means printing it on
the standard output.
</p>

<p>
Finally, the statement in the do-part, 
</p>

  code_box(cq[[hello + ', world!\n' -&gt; print]]nq)

<p>
specifies the behavior that the operands of the addition are
evaluated, the resulting value is computed, and this value is
impressed upon <code>print</code>.  As mentioned in the 
"Getting Started" section, the arrow: 
</p>

  code_box(`-&gt')

<p>
is associated with flow of values, and the values flow in the
direction of the arrow.  This means that it is used to express
assignment, argument delivery in method/procedure/function calls, and
return value delivery from method/function calls and evaluation of the
state of objects.  
</p>

<p>
Think of it as an instruction to "extract a value"
from whatever is on the left hand side of the arrow, and an
instruction to impress a value upon whatever is on the right hand side
of the arrow.  The value may be arbitrarily complex, expressed by
nested, parenthesized lists, and the recursive "take-over" semantics
which ensures that impressing a value upon <code>print</code> and upon
<code>stdio</code> is the same thing.
</p>

<p>
_next_tut_ref(Next), we'll look at different kinds of declarations.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
