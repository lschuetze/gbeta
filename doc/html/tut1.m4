m4_include(tutorialstd.m4)m4_dnl
begin_page(cq[[The Conceptual Framework]]nq)

_h3(`A little bit about navigation')

<p>
This tutorial is about the _gbeta language.  If you are looking for
information about the practical usage of _gbeta, such as the
interaction commands, help facilities, or the integration with Emacs,
take a look at the _start_ref(`Getting Started') section.
</p>

<p>
If you already know _beta_ref(`BETA') you may wish to start with
the section about _compatibility_ref(`compatibility').
</p>

_h3(`The conceptual framework')

<p>
The language _gbeta was created as a deeply generalized version of
the language BETA.  Despite the fact that the two languages differ in
numerous ways today, both syntactically and semantically, there is a
shared mindset in many respects, and in particular the conceptual
framework created along with the design of the language BETA is still
a good starting point for an understanding of the philosophical 
foundations of the _gbeta language design.  Because of this, we will
set out by giving just a few hints about the conceptual framework
of BETA.
</p>

<p>
BETA has always had a rich and explicit philosophical grounding,
providing a foundational explanation of and motivation for the
object-oriented perspective on system development, and hence the
design of object-oriented programming languages.  To learn more
about this, look into chapter 18 of
</p>

code_box(
`</tt>Ole Lehrmann Madsen, Birger M&oslash;ller-Pedersen, Kristen Nygaard:<br>
<i>"Object-Oriented Programming in the BETA Programming Language"</i><br>
Addison-Wesley and ACM Press, 1993<br>ISBN 0-201-62430-3<tt>')

<p>
which is available for free from the _mjolner web site.
Here, we'll just mention some important concepts, briefly, starting
with a quote from the
<a href="http://daimi.au.dk/~beta/index.html#tutorial"
   target="_top">BETA Language Tutorial</a>, p.8:

<blockquote>

  <p>
  BETA is intended for modeling and design as well as implementation.
  During the design of BETA the development of the underlying conceptual
  framework has been just as important as the language itself.
  </p>

  <p>
  BETA is a language for representing/modeling concepts and phenomena
  from the application domain and for implementing such concepts and
  phenomena on a computer system.  
  <!-- Part of a BETA program describes objects and patterns that
  represent phenomena and concepts from the application model.  This
  part is said to be representative since BETA elements at this level
  are meaningful with respect to the application domain.  Other parts of
  a BETA program are non-representative, since they do not correspond to
  elements of the application domain, but are intended for realizing the
  model as a computer system. -->
  </p>

</blockquote>

<p>
Starting from the concept of a <em>system</em>, which is a portion of
the world that somebody chooses to view as a whole, built from a
number of interacting components, and continuing with the concept of
an <em>information process</em>, which is a perspective on a process
that emphasizes the information content and its transformations over
time, a <em>program execution</em> may be described as an
information process considered as a system which is a <em>physical
model</em> of some real world or imagined process.
</p>

<p>
In other words, what happens in the computer is actually a physical
process, and this process corresponds to a similar process in the
real world or in some imagined world, focusing on the application
domain and choosing some perspective on this application domain.  It
is crucial that this is not just about mimicking real world
processes.  It is actually about taking advantage of the fact that
the human mind is superbly equipped to deal with real world
processes.  Hence, if we can construct software in such a way that
the human capability of understanding real world processes can be
applied, then this software will be more firmly in the hands of
human beings constructing or updating it, and it does not matter
whether it is actually a model of a real world process or not, as
long as it is can be understood as such.
</p>

<p>
This establishes the <em>modeling relation</em> between software and
selected parts of the real world (or something which is imagined,
but similar) as crucial, and that is the kernel of
object-orientation from the BETA and _gbeta perspective.  The fact
that many programming languages use constructs like inheritance,
polymorphism, genericity, encapsulation and whatnot is just a
technicality which might change as soon as other technical means for
supporting the "physical model" perspective emerge.
</p>

<p>
Enough philoso-babble ;-) The tutorial about the concrete language
starts on the _next_tut_ref(next) page!
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
