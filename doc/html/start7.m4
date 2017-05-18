m4_include(startstd.m4)m4_dnl
begin_page(`GNU Emacs Integration (continued)')

Execute a few steps of the program by typing:
</p>

  code_box(`step[ENTER][ENTER][ENTER]')

<p>
at the interactive prompt.  This should bring you to the following
statement: 
</p>

program_box(cq[[line: int %{
    a:< string; b:< string; end:< bool;
    plural: %(|if value=1 then '' else 's');
    punct: %(|if end then '.' else ',');
  # 
    <b class="currentstatement">if value=0 do { 'no more'|puttext } else { value|putint }</b>;
    ' bottle'+plural+' of beer'+a+punct+b|putline
  }]] nq)

<p>
Now take a look at the <code>value</code>:
</p>

  code_box(`print value')

<p>
.. and try to execute an ad-hoc statement (which assigns the lesser
of zero and <code>value</code> to <code>value</code> and then prints
the result): 
</p>

  code_box(`do (0,value) | min | value | putint')

<p>
Give the command <code>step</code> and press <code>[ENTER]</code>
several times to see the program execute step-by-step.  As you can
see, the program is affected by the changes introduced by the
execution of the ad-hoc statement, and since any statement is
allowed (as long as it is statically correct) the <code>do</code>
command is a strong tool.
</p>

<p>
If you get tired of stepping through the same code again and again,
you may instruct _gbeta to skip over specific pieces of code even
during single-stepping by means of the <code>skip</code> command:
</p>

   code_box(`skip gbetaenv:*')

<p>
which lets you concentrate on the beer and ignore the printing.
</p>

_h3(`Basic breakpoints')

<p>
At some point, when the source code window shows the file
<code>beer.bg</code>, click in the source code window on the
pipe symbol "<code>|</code>" of
cq<code>value|putint</code>nq, to ensure that the source
code window is the active window and that the point (cursor,
insertion point) is at that pipe symbol.  Since the pipe is
syntactically a top-level constituent of the assignment
cq<code>value|putint</code>nq, this position is identified
with the assignment itself, and that is useful because you
can select the menu item <code>Breakpoint</code> from
the <code>gbeta</code> context menu which is called up by a
control-right click, thus setting a permanent breakpoint at
that assignment.
</p>

<p>
Now execute the command:
</p>

  code_box(`go')

<p>
to continue running until the execution would reach
that assignment.  Press <code>[ENTER]</code> a couple of times to
watch what happens between each time the program reaches that point,
for example:
</p>

program_box(`executing~1&gt;
96 bottles of beer.
Take one down, pass it around,

executing~1&gt; _')

program_box(cq [[<small>line: int %{
    a:< string; b:< string; end:< bool;
    plural: %(|if value=1 then '' else 's');
    punct: %(|if end then '.' else ',');
  # 
    if value=0 do { 'no more'|puttext } else { <b class="currentstatement">value|putint</b> };
    ' bottle'+plural+' of beer'+a+punct+b|putline
  }</small>]] nq)

<p>
By now the default command is <code>go</code>, so every
<code>[ENTER]</code> continues the execution in the running, not
single-stepping, mode.
</p>

_h3(`Other kinds of breakpoints')

<p>
There are some other variants of breakpoints, namely <EM>temporary
breakpoints</EM> and <EM>"after-breakpoints"</EM>.  A temporary
breakpoint simply gets deleted the first time it causes a break, and
this is sometimes convenient .. think of it as a way to "run until you
hit this spot" without changing the properties of "this spot."
</p>

<p>
Sometimes it is hard to say exactly what statement will execute after
the execution of a given statement finishes, perhaps because it is
the last statement in the body of a method (pattern) which might be
invoked from many different places.  In these cases it is convenient
to stop <EM>after</EM> the execution of a statement, not before the
next one.  This is the motivation for the 
<code>"Breakpoint After"</code> and <code>"Tmp. Brk. After"</code>
menu entries, corresponding to the <code>abreak</code> and
<code>tabreak</code> commands. 
</p>

<p>
The _next_start_ref(next) section summarizes the execution control commands.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
