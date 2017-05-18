m4_include(startstd.m4)m4_dnl
begin_page(`GNU Emacs Integration (continued)')

_h3(`The two windows')

<p>
After having invoked _gbeta on the <code>beer.gb</code> source
code file, you get the familiar prompt in one window:
</p>

program_box(`executing~1&gt; _')

<p>
and the first statement of the program (which happens to reside in the
file <code>gbetaenv.gb</code>) emphasized in the middle of the other
window:
</p>

program_box(cq [[<small>...
  min: %(i:int,j:int | if i&lt;j then i else j);

  theProgram: @&lt;&lt;SLOT program:merge&gt;&gt;
#
  <b class="currentstatement">theProgram</b>
}</small>]] nq)

<p>
The <rm class="currentstatement">current statement</rm> is
emphasized in two ways.  At the leftmost 
column of the window, an small triangle (not shown here) enables
a quick scan to find the line containing the current statement,
and somewhere in the middle of that line or spanning multiple
lines, a block is highlighted, e.g., by using a yellow
background color.
</p>

_h3(`Some unchanged features, and a better display')

<p>
Printing the state of objects or the structure of patterns, or static
information about program elements works the same as in the command
line environment.  Showing a position in the source code works a lot
better, because the <code>display</code> command can exploit Emacs to
show the given source code position in the source code window.  Try:
</p>

  code_box(`print -v theProgram')

<p>
This produces a rather large response, specifying the state of the
object <code>theProgram</code>:
</p>

program_box(cq[[<small>Printing eval:   theProgram
Resulting value:
   object, composite object slice~4~3 "theProgram" =
     {&#x60;beer.gb:45-606
       line: P=InMix CsMix-&#x60;beer.gb:144-393
       long: P=InMix CsMix-&#x60;beer.gb:144-393 CsMix-&#x60;beer.gb:407-438
       period: P=InMix CsMix-&#x60;beer.gb:144-393 CsMix-&#x60;beer.gb:454-477
       take: P=InMix CsMix-&#x60;beer.gb:144-393 CsMix-&#x60;beer.gb:454-477 CsMix-&#x60;beer.gb:493-544 
     }</small>]] nq)

<p>
In fact, <code>theProgram</code> does not contain state, because
we have not declared any mutable features (such as instance
variables) at the top level in the file <code>beer.gb</code>,
which is the place where it is defined
what <code>theProgram</code> is (the module system is described
in the section on _modularization_ref(`modularization')).
Consequently, if we just use a plain <code>print
theProgram</code> command then we will get only a small amount
of information because it omits nested patterns (i.e., nested
classes and methods).  So we add the option <code>-v</code> to
get a more verbose output, which means that the nested patterns
are included in the output.  This means that we can inspect the
methods of the object.
</p>

<p>
Go up and find the annotation at the top of the "state block": it
will be a backquote followed by a filename, a colon, and an integer range
which specifies a node in the abstract syntax tree, in
this case <code>&#096;beer.gb:45-606</code>.  Now give that (without the
backquote) as an argument to the <code>display</code> command:
</p>

  code_box(`display beer.gb:45-606')

<p>
Actually, <code>dis beer:45</code> would be sufficient,
or <code>dis 45</code> when the current statement is in the
file <code>beer.gb</code>, because this uniquely determines the
same syntax node (when the file name is not given the current
file is assumed, and at character position 45 there is a left
brace character which is not part of a smaller construct
than the entire block).  An even easier way is double-clicking
with the mouse on the text <code>&#096;beer.gb:45-606</code> (or
closely after it).
</p>

  code_box(`[ click-click! ]')

<p>
You can use this to inspect the source code (declarations)
associated with the program state which 
<code>"print <i>something</i>"</code> delivers.  Try to double-click on
<code>&#096;beer.gb:144-393</code> or similar.  Now consider all
the information given about the method <code>long</code>:
</p>

  code_box(`long: P=InMix CsMix-&#x60;beer.gb:144-393 CsMix-&#x60;beer.gb:407-438')

<p>
This means that <code>long</code> is a method (i.e., a
pattern, marked by <code>P=..</code>) which contains three
mixins, each of them marked by <code>Mix</code>.  The first
(most general) one is an integer mixin (<code>InMix</code>),
i.e., a part of the object which is capable of holding an
integer value.  The next mixin is a composite mixin
(<code>CsMix</code>); a composite mixin is a mixin which is
defined by user code, i.e., by a declaration block
(<code>%{..}</code>, possibly including an enter/exit
part, <code>%(..|..){..}</code>).  For composite mixins it is
possible to inspect the declaring source code by double-clicking
on the position marker which follows the <code>CsMix</code>
keyword.  So you may inspect what code <code>long</code> will
run when executed by double-clicking in this line.  You will see
that it runs the code for <code>line</code>
(because <code>line</code> is the superpattern
of <code>long</code>), and then runs the code in the declaration
of <code>long</code>, except that the latter does not add any
statements&mdash;it just further-binds a nested
method, <code>a</code>.  But the latter is called by the body of
the <code>line</code>, so this further-binding will change the
behavior after all.  You may wish to single-step an execution
of <code>long</code> in order to see how this plays out, but
that is actually part of the plan for the next section.
</p>

<p>
Remember that if you get lost because you have looked at lots of
places in the source code browsing the state of the program, you can
always display the statement which will be executed next by:
</p>

  code_box(`display')

<p>
without any arguments (or the shortest possible abbreviation: 
<code>d</code>).
</p>

<p>
In the _next_start_ref(next) section we will start executing the program,
and begin to use breakpoints.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
