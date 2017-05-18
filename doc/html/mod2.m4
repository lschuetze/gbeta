m4_include(modularizationstd.m4)m4_dnl
begin_page(`Using Several Files')

_h3(`Fragment groups, forms, and properties')

<p>
A source file is called a <em>fragment group</em>, because it contains
a number of <em>fragment forms</em> along with the specification of
the relation to other fragment groups, the <em>fragment
properties</em>: 
</p>

program_box(cq[[
<i>fragment-group</i> ::= <i>fragment-property</i>* <i>fragment-form</i>*;
<i>fragment-property</i> ::= <i>property-kind</i> <i>group-spec</i> ";";
<i>property-kind</i> ::| "ORIGIN" | "INCLUDE" | "BODY";
<i>group-spec</i> ::= <i>pathname</i>;
<i>fragment-form</i> ::= <i>form-head</i> <i>form-body</i>;
<i>form-head</i> ::= "--" <i>form-name</i> ":" <i>non-terminal-name</i> "--";
]]nq)

<p>
This is a simplified grammar for the fragment language, but since it
describes a language which is a large subset of the actual fragment
language you can use it as it is.  Certain non-terminals are left
unspecified, namely:

<ul>
<li><code><i>non-terminal-name</i></code>: an identifier which occurs in the
  grammar of the language as a non-terminal (i.e. at the left hand side
  of a "::=", "::|", "::+", or "::*" symbol),
  e.g. <code>"dopart"</code></li> 
<li><code><i>form-name</i></code>: an identifier,
  e.g. <code>"aNameForAPieceOfCode"</code></li>
<li><code><i>pathname</i></code>: the name of a file in the file
  system, without the extension (such as ".gb") and enclosed in single
  quotes, e.g. <code>"'private/myImplementation'"</code>; a user
  specification like <code>"~beta/"</code> in the beginning of a path
  can be treated specially as specified in some configuration files,
  but you shouldn't need to worry about this when using _gbeta</li>
<li><code><i>form-body</i></code>: a sentential form (a syntactic
  derivation, partial or complete) in the grammar of the programming
  language, derived from the the <code><i>non-terminal-name</i></code>
  of the fragment form.  If it is complete (no non-terminals), it is
  simply a piece of syntax in the programming language; if it still
  contains non-terminals, they must be written as slot applications:

  code_box(`"&lt;&lt;" "SLOT" 
           <i>form-name</i> ":" <i>non-terminal-name</i> "&gt;&gt;"')</li> 
</ul>

<p>
Here is an example of a full-fledged fragment group in _gbeta: 
</p>

program_box(cq[[
ORIGIN 'betaenv';
INCLUDE 'myLib';

-- program:merge --
(# anObject: &lt;&lt;SLOT anObject:staticItem&gt;&gt;
&lt;&lt;SLOT mainProgram:dopart&gt;&gt;
#)

-- anObject:staticItem --
@(# x: @integer #)

-- mainProgram:dopart --
do 2-&gt;anObject.x
   aLibMethod (* presumably declared in 'myLib' *)]]nq)

_h3(`Fragment graphs')

<p>
When we have several fragment groups in a program, we must have a way
to specify which groups are included, and what the relations are
within this set of fragment groups.  This is done by constructing a
<em>fragment graph</em> according to the <em>fragment properties</em>
of the groups. 
</p>

<p>
The starting point is always one distinguished fragment group, the
<em>seed</em> of the fragment graph.  This is the fragment group
which is specified as "the file to execute" when starting _gbeta,
probably what you think of as the "main file" of the program.
Starting from the seed, we construct two graphs whose nodes are
fragment groups and whose edges are properties.  The following two
paragraphs give a precise definition of the concepts of extent and
domain, and the third paragraph gives a more understandable
explanation (depending on your attitude to math ;-).
</p>

<p>
The first graph, the <em>extent</em> graph, contains the groups which
are reachable from the seed via some number of <code>ORIGIN</code>,
<code>INCLUDE</code>, or <code>BODY</code> links (i.e. all properties
are used).  It is, hence, the transitive closure of all property links
from the seed.  This graph determines what fragment groups are
included in the program, i.e. it determines the overall "content" of
the program.
</p>

<p>
Starting from any fragment group <code><i>G</i></code> in the graph,
the subgraph of the extent which is induced by the <code>ORIGIN</code>
and <code>INCLUDE</code> links is called the <em>domain</em> graph of
<code><i>G</i></code> (with respect to the seed).  The domain graph
determines visibility, as explained below. 
</p>

<p>
Another way to explain this is that the <em>extent</em> contains all
the source code you can find by looking into fragment groups mentioned
in properties of the seed group, or of groups looked up that way, or
of groups looked up from there etc.etc.  When you have outlined the
extent, you can determine the <em>domain</em> of each group by a
similar, repeated lookup process, but this time you are not allowed to
use the <code>BODY</code> properties.
</p>

<p>
The basic intuition is that you use a <code>"BODY 'aGroup';"</code>
property to request that the source code in <code>aGroup</code> is
included into the program; and you use to 
<code>"INCLUDE 'aGroup';"</code> to request that the source code in
<code>aGroup</code> is included into the program <em>and</em> made
visible such that the source code in this fragment may depend on it.
In other words, 
</p>

  code_box(`INCLUDE </tt>means "I need this!"')

<p>
and: 
</p>

  code_box(cq[[BODY </tt>means "I need this, but I don't want to see it!"]]nq)

<p>
The <code>ORIGIN</code> properties, apart from the fact that they
imply the same things as <code>INCLUDE</code>, are used to define the
<em>scope rules</em> for <i>form-names</i>.  The rule is:
</p>

code_box(`</tt>A slot application can be associated with a slot
declaration iff they have the same name and there is a path of
<code>ORIGIN</code> links from the fragment group that contains the
declaration to the fragment group that contains the application') 

<p>
A useful intuition about this is that an <code>ORIGIN</code> property
tells in what <em>direction</em> the fragment forms in this group must
travel to find their ultimate destination.  This intuition reaches
back to the search-and-replace semantics of slots, and when several
groups (files) are involved and the search-and-replace process must
cross group borders, the source code which gets inserted to 
replace the <code>&lt;&lt;SLOT ..&gt;&gt;</code> expressions must
travel exclusively along <code>ORIGIN</code> edges in the extent
graph.  In other words, 
</p>

  code_box(cq[[ORIGIN </tt>means INCLUDE, and also "Home is this way!"]]nq)

_h3(`How to handle this?')

<p>
The fact that graphs and lots of transitive closures are at the heart
of the definition of the module system of _gbeta (and traditional BETA
as well) may make it seem counter-intuitive and unmanageable in
practice.  However, having worked with this system for years (as a
student programmer using BETA for many tasks), I find it very
intuitive and extremely expressive.  Moreover, the fragment system has
been taught to second year C.S. students at &Aring;rhus University
every year for many years, so it should be manageable to achieve a
working knowledge of it in a reasonable time.  Looking at concrete 
examples is surely a good approach.
</p>

<p>
Expanding a little on the expressiveness:  It is trivial, for example,
to set up a visibility-scheme which hides certain aspects of the
implementation of one pattern from its sub-patterns (similar to C++
<code>private</code>), or allows them to depend on those aspects
(similar to C++ <code>protected</code>), or allows certain other
patterns to see some aspects (similar to the selective export
mechanism in Eiffel), or allows certain sub-patterns but not others to
see something (not covered in C++ or Eiffel), etcetc.
</p>

<p>
An important difference is that this scheme is much more fine-grained
than the others.  It is e.g. possible to allow one particular
statement from one particular method of a pattern to depend on (have
access to) some subset of another pattern, possibly a super-pattern.
And, equally important, since interface and implementation can be kept
in different files, patterns depending on the interface of a given
pattern <code>P</code> will not need recompilation if (only) the
implementation of <code>P</code> changes. 
</p>

<p>
Another important difference is that access is <em>seized</em> by the
party which "depends-on," not granted by the party which is being
"depended-on."  This means that tool support is needed to detect
whether "somebody are looking at something they shouldn't see," but on
the other hand there is no need to change the code being "depended-on"
when some other code wishes to "depend-on" it.  The philosophy is
that the vulnerable party (which breaks if the other party changes)
declares the vulnerability.  Intuitively, if somebody is looking at
a piece of code that they should not depend on, then it is <em>their</em>
problem when/if it breaks.  The tool support would then be used to
find such "ill-behaved" pieces of code, and luckily it is a rather
trivial task because we just need to find all the <code>INCLUDE</code>
or <code>ORIGIN</code> links to fragment groups from other fragment groups
which are not, by the privacy policy, allowed to depend on them.  As
an example of a very simple policy, we might disallow such links
going into any fragment group whose path includes a directory named
<code>private</code>.
</p>

<p>
Finally, we're ready to look at a complete, concrete example in the 
_next_mod_ref(next) section.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
