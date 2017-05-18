m4_include(modularizationstd.m4)m4_dnl
begin_page(`A Concrete Example')

<p>
Many object oriented languages have a basic inheritance hierarchy
where ordered entities inherit from an <code>Ordered</code> class, such 
that the commonalities for all classes of ordered entities can be
factored out.  There is no tradition to do this in the BETA family of
languages, but it is possible to write some patterns that implement
such a hierarchy.  The following example does just that (in _gbeta, of
course).
</p>

<p>
First we must establish a universe wherein everything can be placed:
</p>

program_box(cq[[(* FILE betaenv.gb *)
-- betaenv:descriptor --
(#
   &lt;&lt;SLOT lib:attributes&gt;&gt;;
   puttext: (# enter stdio do INNER #);
   putline: puttext(# do '\n'->stdio #);
   theProgram: @&lt;&lt;SLOT program:merge&gt;&gt;
do
   theProgram
#)]]nq)

<p>
This is a minimal basic library; this would normally be provided as
part of the language implementation, but there is nothing magic about
it so we show it here along with the other files.  For brevity we just
include the few 
things which are actually used, and we even leave out methods to print 
numbers.  The name <code>stdio</code> denotes a primitive (built-in)
entity which provides access to the standard input and standard
output.  Note the <code>lib:attributes</code> slot; such a slot is
conventionally defined in <code>betaenv</code>, and it provides us 
with a "global" namespace.  We also have a <code>program:merge</code>
slot; this slot is a placeholder for the program, so all we need to do
when we write programs is to claim this place.  The following fragment
does just that:
</p>

program_box(cq[[(* FILE orderedUser.gb *)
ORIGIN 'betaenv';
INCLUDE 'orderedNumber' 'orderedText' 'orderedAsString'

-- program:merge --

(# 
   t1,t2: ^text;
   n1,n2: ^number;
   r: @real;
do
   'Hello, '->(&t1).init;
   'world!'->(&t2).init;
   (if t1[]->t2.lessEqual then t1.asString->puttext if);
   (t1[]->t2.max).asString->putline;
   
   3.14159->float.init->n1[]; 
   4->int.init->n2[];
   (n1[]->n2.max).asString->putline
#)]]nq)

<p>
The <code>--program:merge--</code> syntax means "Here comes the piece of
code which is called <code>program</code> (and it is syntactically a merge
construct)".  The INCLUDE properties ensure that the other fragments
we need will be included, and the ORIGIN property specifies that the
place where the piece of code called <code>program</code> is used is in
<code>betaenv</code>.  This is the main program, in the sense that it is
the intended argument to <code>gbeta</code>, it contains the application
code which uses the libraries (the remaining files), and it ties all
the pieces together.  The _next_mod_ref(next) section presents the missing
pieces.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
