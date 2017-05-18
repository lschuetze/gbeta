m4_include(startstd.m4)m4_dnl
begin_page(`Running a Program')

<p>
Now try to run the program <code>hello.gb</code> (you didn't expect
this, did you?&nbsp;;-)

  code_box(`gbeta hello')

The program looks like this:

program_box(cq[[-- universe:descriptor --
// FILE hello.gb
{
  'Hello, world!\n' | stdio
}]]nq)

The output from the execution is just the text "Hello, world!", but 
if we add option <code>-v</code> it gets quite verbose:

program_box(cq[[<small>GBETA version 1.9.11, copyright (C) 1997-2011 Erik Ernst.
This is free software, and you are welcome to redistribute it 
under certain conditions; this software comes with ABSOLUTELY NO WARRANTY.
For details please see the file COPYING.

Setting option `v': Print startup messages etc.

Main source code file: "hello"

------------------------------ Analyze program

------------------------------ Execute primary object
Hello, world!</small>]] nq)

The verbose variant may be useful because it provides a greater amount
of information about what is going on (in particular if you want to
see a short description of each option selected), but the default
behavior is to avoid too much noise, just like most UNIX style
utilities.
</p>

<p>
Also note that the <code>gbeta</code> tool by default works as a
combination of a compiler and a virtual machine:  It will compile the
program given as a command line argument (as well as the files
included directly or indirectly) to bytecodes, and then the built-in
virtual machine will execute the bytecodes.  You may use option 
<code>-g</code> to request bytecode generation only, but this will not be
necessary for this tutorial so we will not go into details.
</p>

<p>
The _next_start_ref(next) subject is interactive execution, not unlike a
debugging session.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
