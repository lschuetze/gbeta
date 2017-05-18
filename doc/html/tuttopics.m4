m4_include(gbetastd.m4)m4_dnl
m4_define(`tut_entry',`subtopic_entry(`tut',`$1',`$1')')m4_dnl
m4_define(`tut_button',`subtopic_button(`tut',`$1',`$2')')m4_dnl
<html>
<!-- Generated with M4 on the date shown at the bottom of this page -->
<head><title></title></head>
<link rel="stylesheet" type="text/css" href="style/gbeta.css"/>
<body class="topics">

subtopic_buttons(`tut')

<script>
var tutCount = 16;
var tutselected = 1;

var tutFile = Array(tutCount);
for (var i=1; i<=tutCount; i++) {
  tutFile[i] ="tut" + i;
}

tutRadio = new Array(tutCount);
tutRadio = new Array(tutCount);
foreach(`tutRadio[$1] = document.tut_form.tut_mark$1;
',tut_numbers)

tutRadio[1].checked = true;
for (var i=2; i<=tutCount; i++) {
  tutRadio[i].checked = false;
}

function tut_activate(nr) {
  if (nr<1) nr = 1;
  if (nr>=tutCount) nr=tutCount;
  oldselected = tutselected;
  tutselected = nr;
  tutRadio[oldselected].checked = false; // deactivate old selection
  tutRadio[tutselected].checked = true; // activate new selection
  parent.frames[1].location = tutFile[tutselected] + ".html";
}

function tut_next() {
  tut_activate(tutselected+1);
}

function tut_prev() {
  tut_activate(tutselected-1);
}

</script>

</body>
</html>

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
