m4_include(gbetastd.m4)m4_dnl
m4_define(`start_entry',`subtopic_entry(`start',`$1',`$1')')m4_dnl
m4_define(`start_button',`subtopic_button(`start',`$1',`$2')')m4_dnl
<html>
<!-- Generated with M4 on the date shown at the bottom of this page -->
<head><title></title></head>
<link rel="stylesheet" type="text/css" href="style/gbeta.css"/>
<body class="topics">

subtopic_buttons(`start')

<script>
var startCount = 9;
var startselected = 1;

var startFile = Array(startCount);
for (var i=1; i<=startCount; i++) {
  startFile[i] ="start" + i;
}

startRadio = new Array(startCount);
foreach(`startRadio[$1] = document.start_form.start_mark$1;
',start_numbers)

startRadio[1].checked = true;
for (var i=2; i<=startCount; i++) {
  startRadio[i].checked = false;
}

function start_activate(nr) {
  if (nr<1) nr = 1;
  if (nr>=startCount) nr=startCount;
  oldselected = startselected;
  startselected = nr;
  startRadio[oldselected].checked = false; // deactivate old selection
  startRadio[startselected].checked = true; // activate new selection  
  parent.frames[1].location = startFile[startselected] + ".html";
}

function start_next() {
  start_activate(startselected+1);
}

function start_prev() {
  start_activate(startselected-1);
}
</script>

</body>
</html>

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
