m4_include(startstd.m4)m4_dnl
begin_page(`Command Line Interaction (continued)')

_h3(`Taking one step')

<p>
With BETA assignment syntax, data flows from the left to the right
just like we read from the left to the right.  This is very unusual,
but after a while you might think  (like me :-) that it is
<em>the</em> most natural way to do it.  Anyway, the syntax:
</p>

  code_box(cq [[ 'world!\n' | s ]] nq)

<p>
is an assignment which takes the literal string value
<code>'world!\n'</code> (where <code>'\n'</code> stands for a
newline character as in C, Java, and many other languages) and 
puts it into the object <code>s</code>.  In
many programming languages, this would look more like: 
</p>

  code_box(cq [[ s = "world!\n"; // NB: this is not gbeta syntax]] nq)

<p>
To execute this statement, just press <code>[ENTER]</code>, giving
the response: 
</p>

program_box(cq[[====================
{&#x60;26-126
  s: string;
  hello: %(| 'Hello'){&#x60;70-80
    INNER
  }
#
  'world!\n' | s;
  <b><u>hello+', '+s | stdio</u></b>;
  INNER
}
====================

executing~1&gt; _]] nq)

<p>
Note that it is the second statement which is emphasized now.  To
check that something actually happened, try to look at <code>s</code>:
</p>

program_box(cq[[executing~1&gt; print s

Printing eval:   s
Resulting value: "world!
"

executing~1&gt; _]] nq)

<p>
This basically says that, as seen from the current statement and in
the current execution state, the name <code>s</code> denotes a string
object, and the state of this object is the string value
<code>"world!\n"</code>, where the final newline is shown directly
rather than encoded as an escape sequence.  We can investigate
information known from static analysis:
</p>

program_box(cq[[executing~1&gt; assigninfo s

Assign type of:  s
Assignment type: s

Detailed info:
  string static transient


executing~1&gt; _]] nq)

<p>
This tells us that <code>s</code> can accept a string value in
assignments.  Note that the first <code>s</code> is the name
of the variable, and the next <code>s</code> is a concise
notation for the longer explanation, <code>string static 
transient</code>, which is given
below.  Consequently, anything whose <code>evalinfo</code> is
also a <code>string static transient</code> can be assigned to it
(try <code>"help evalinfo"</code>).  An example could be a string
literal:
</p>

program_box(cq[[executing~1&gt; evalinfo 'Hello'

Eval type of:    'Hello'
Evaluation type: s

Detailed info:
   string static transient

executing~1&gt; _]] nq)

_h3(`A constant, an expression, and a primitive')

<p>
The _gbeta way to express a constant is to declare a pattern which
simply delivers a value, like the pattern <code>hello</code>:
</p>

  code_box(cq [[ hello: %(|'Hello') ]] nq)

<p>
In fact, <code>hello</code> is declared to be a pattern which
has an empty enter-list, i.e., it accepts the empty list of
arguments, and then it returns the result of
evaluating <code>'Hello'</code>, which is just a string
literal.  The pipe symbol, "<code>|</code>", is used for
several purposes associated with communication among
objects.  We have already seen it in use for assignments
(such as <code>'x'|s</code>), but in the declaration of the
communication interface of a pattern, i.e.,
the <code>%(..)</code> part, it is used to separate the
enter-list (the argument list) from the exit-list (the list
of returned results):
</p>

  code_box(cq [[%(&lt;<em>arguments</em>&gt;|&lt;<em>results</em>&gt;)]] nq)

<p>
For instance, <code>%(x:int|x+1)</code> is the anonymous function
which accepts an argument of type int and returns the same
value plus one, and <code>%(|'Hello')</code> is the anonymous
zero-argument function which returns the string
value <code>"Hello"</code>.
</p>

<p>
This constant, a literal string, and the string object <code>s</code>
are used in an expression whose value is "inserted into"
<code>stdio</code>:
</p>

  code_box(cq [[ hello+', '+s | stdio ]] nq)

<p>
<code>stdio</code> is the primitive entity which makes it possible to
read the standard input and write to the standard output.  Again, the
pipe, "<code>|</code>", signals data flow, and the values flow in
the reading direction, into <code>stdio</code>.  In this case
the communication entails sending a (string) value into a
primitive, but this primitive is essentially a built-in
method so we may consider the whole expression to be a method
call.  This means that method calls in general have the
following shape:
</p>

  code_box(cq [[ &lt;<em>arguments</em>&gt; | &lt;<em>method</em>&gt; ]] nq)

<p>
where parentheses may be omitted around the arguments when
there is only one.  If you execute this statement by giving
the interactive command <code>step</code>:
</p>

program_box(cq[[executing~1&gt; step
Hello, world!


terminated&gt; _]] nq)

<p>
then you can see that the statement was executed (the expression was
evaluated and the computed string value <code>"Hello, world!\n"</code>
was delivered to the standard output), and since we reached the end of
the program, _gbeta entered the terminated state.
</p>

_h3(`Modern conveniences...')

<p>
Often you can just press <code>[ENTER]</code> when executing a program
interactively.  The reason why we have to type <code>step</code> in
some situations similar to the one above is that the default command
is the most recently executed command from a set of often executed
commands.  Since in this case the previous command was <code>"print
s"</code>, the <code>step</code> command would still be the default
command and we could have used <code>[ENTER]</code> to resume
stepping, but if the previous command had been <code>next</code>
(which steps over an entire method call rather than stepping into it)
then the default command would have been <code>next</code> and we
would have to type <code>step</code> in order to single-step again.
For convenience, the default command is <code>step</code> initially,
so we could choose to type <code>step</code> or just press
<code>[ENTER]</code> at the first step of execution.
</p>

<p>
In general, commands can be abbreviated.  If an abbreviated command
matches more than one command name, the first matching command is
executed (no warning about ambiguities!).  To find out what command
matches a given abbreviation, e.g. <code>"n"</code>, use the
<code>help</code> command: 
</p>

  code_box(`help n')

<p>
The response tells you that <code>n</code> abbreviates the command 
<code>next</code>, and it gives some general information about the
<code>next</code> command as well.
</p>

_h3(`This is best for one-file programs')

<p>
At the command line, _gbeta can only pretty-print the enclosing source
code to show you what part of the program is currently being executed.
Since pretty-printing drops all comments and reshapes the source code
formatting to a strictly regular style, lots of information is lost,
and this approach gets tedious and confusing when running any but the
smallest programs interactively. The _next_start_ref(next) section
presents the integration of _gbeta with GNU Emacs which gives a much
more useful environment for larger programs.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html 
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
