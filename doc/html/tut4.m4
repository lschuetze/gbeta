m4_include(tutorialstd.m4)m4_dnl
begin_page(`Transparency and Coercion')

<p>
A very important, implicit, and pervasive aspect of the _gbeta
language is that there is a very consistent <EM>transparency</EM> of
entity category.  When used in a given context, whatever category of
entity is available will be transformed to the category requested by
the context.  Entity categories are object, pattern, object identity
and pattern identity, including concurrent variants.
</p>

_h3(`A statement is an object context')

<p>
A statement is an object context, and that means that whatever is
denoted by a name which occurs as a statement in a program will be
transformed into an object, implicitly and without special syntax
which reveals what it was before the transformation.  That information
is available by looking up the declaration anyway. 
</p>

<p>
This is good since it makes the syntax at the point of application
independent of the precise category of entity declared, and this means
that the declaration may be changed without affecting all the usages
of that declared name.
</p>

<p>
The most basic example of this is that a name which denotes an object
and a name which denotes an object reference (think "a pointer" if you
like) are used in the same way, 
</p>

program_box(cq[[
(# 
   i: @integer;
   ir: ^integer
do 
   ... (* some code here should initialize 'ir' *)
   1->i;
   2->ir;
   ...
#)]]nq)

<p>
If we decide to change <code>i</code> into an object reference, that
is a change which is local to the declaration; the rest of the program
works as before without changes.
</p>

<p>
Of course, this means that it is very un-BETA-like to give names like
<code>i</code> and <code>ir</code> which reveal the choice of
representation, but when presenting a transparency mechanism it is
necessary to focus on exactly that which is going to become invisible.
</p>

<p>
Since this transparency is a very basic property of the BETA family of
languages, the traditional BETA terminology is that <code>"@"</code>
declares a <EM>static reference</EM> and <code>"^"</code> declares a
<EM>dynamic reference</EM>.  Think of all substance-names as
"pointers"/"references" and then note that some of them are constant
(static) and others are variable (dynamic).  This might seem the most
natural perspective, if you are used to the "everything-is-a-pointer"
semantics of some other object-oriented languages.  When giving the
formal semantics of the language, however, the notion of a "constant
pointer" is an unnecessary complication compared to saying that a name
simply "is" an object.
</p>

_h3(`Method invocation is coercion!')

<p>
A very important example of the statement as an object context is
method invocation.  If a name which denotes a pattern occurs as a
statement, the pattern is coerced into an object (this transformation
from pattern to object is normally called "object instantiation"), and
the resulting, anonymous object is executed.  As an example:
</p>

program_box(cq[[
(# i: @integer;
   p: (# do i+1->i #);
   x: @(# j: @integer do j+i->i #)
do
   p;
   x;
#)]]nq)

<p>
In this example, it is not possible to detect syntactically at the
application of the names <code>p</code> and <code>x</code> that
<code>p</code> is a pattern (which is implicitly instantiated to
create a "procedure activation record"), whereas <code>x</code> is an
object which is simply executed (hence keeping its local state intact
between "invocations"). 
</p>

<p>
As a consequence of this, a pattern may be thought of as a procedure
or method, since applying them as a statement "works like" an
invocation as known in other imperative languages.
</p>

_h3(`An evaluation is also an object context')

<p>
Since an _tutref(6,evaluation) is also an object context, the
mechanism of the following examples are the same as explained above:
</p>

program_box(cq[[
(# i: @integer;
   ir: ^integer;
   p: (# enter ir do (if ir&lt;i then i-ir else i+ir if)->i 
      exit 2*i 
      #);
   x: @(# j: @integer enter j do j+i->i #)
do
   ...
   i+ir->putint;
   ((x,x),x)->(max,p)->min->putint;
   ...
#)]]nq)

<p>
When <code>i</code> is printed with the assignment evaluation
<code>i+ir->putint</code>, the transformation of <code>i</code> is a
no-op since it is already an object.  However, <code>ir</code> is
coerced from object reference to object.  You may think of it as
"dereferencing a pointer."  On the right hand side of the assignment
evaluation, <code>putint</code> is coerced from a pattern into an
object, i.e. an instance is created, and this instance is then
executed.
</p>

<p>
The next statement is a composite (multiple) assignment evaluation.
Everywhere, whether a name delivers a value (it occurs before
<code>-&gt;</code>), or a value is impressed upon it (it occurs after
<code>-&gt;</code>), or both (it occurs between two
<code>-&gt;</code>'s), patterns are instantiated and object references
are dereferenced implicitly.  The
_tutref(12,`<code>if</code> statement') in <code>p</code> is 
covered later.
</p>

<p>
The _next_tut_ref(next) section deals with a number of non-object contexts.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
