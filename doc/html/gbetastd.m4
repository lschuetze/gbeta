m4_dnl ======================================================================
m4_dnl
m4_define(`topic_colors',`text="`#'000080" background="marble.jpg"
  link="`#'0000FF" vlink="`#'0000FF" alink="`#'FF0000"')m4_dnl
m4_define(`number_colors',`text="#000080" background="marble.jpg"
  link="#0000FF" vlink="#0000FF" alink="#FF0000"')m4_dnl
m4_define(`page_colors',`text="`#'000000" bgcolor="`#'FFFFFF"
  link="`#'0000FF" vlink="`#'800080" alink="`#'FF00FF"')m4_dnl
m4_dnl
m4_define(`_style_link',
  `<link rel="stylesheet" type="text/css" href="style/gbeta.css"/>')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`begin_page_base',`
<html>
<!-- Generated with M4 on the date shown at the bottom of this page -->
<head><title>gbeta`'m4_ifelse(`',`$1',`',` $1:'): $2</title></head>
_style_link
<body class="page">
<table width="100%">
<tr><td align="right">$3</td></tr>
<tr><td align="left">m4_ifelse(`$1',`',`_h1($2)',`_h1(`$1:<br>$2')')</td></tr>
</table>
<p><hr></p>')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`this_site_url',`http://cs.au.dk/~eernst/gbeta/')m4_dnl
m4_define(`this_file_url',
 `this_site_url`''m4_esyscmd(`/bin/echo -n $FOCUS')`.html')m4_dnl
m4_define(`end_page_base',`<p><hr></p>
<address>
  <strong>Maintainer:</strong>
  Erik Ernst,
  <a href="mailto:eernst@cs.au.dk">eernst@cs.au.dk</a>.<br><br>
  This page was updated on 'm4_esyscmd(`date +"%e-%b-%Y"')`<br>
  URL - this_file_url
</address>
</body>
</html>')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`_lrref',`
<table><tr align="center">
  <td>_lref(`<img src="left.gif">')</td>
  <td>_rref(`<img src="right.gif">')</td>
</tr></table>')m4_dnl
m4_dnl
m4_define(`begin_page',`begin_page_base(`',`$1',`$2')')m4_dnl
m4_define(`end_page',`end_page_base')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`num_entry',
  `<tr><td><a href="$2" target="$1display">&lt;$3&gt;</a></td></tr>')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`code_box',`
<p>
  <div align="center">
    <table border=2 cellpadding=10 bgcolor="#FEFEFF">
      <tr><td><code>$1</code></td></tr>
    </table>
  </div>
</p>')m4_dnl
m4_define(`program_box',`
<p>
  <table border=2 cellpadding=10 width=90% bgcolor="#FFFFFF">
    <tr><td><pre>$1</pre></td></tr>
  </table>
</p>')m4_dnl
m4_define(`cq',`m4_changequote(`[[',`]]')')m4_dnl
m4_define(`nq',`m4_changequote')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`foreach',
  `m4_pushdef(`_witheach',`$1')_foreach(m4_shift($@))m4_popdef(`_witheach')')m4_dnl
m4_define(`_foreach',
  `_witheach($1)`'m4_ifelse($#,1,,$#,1,``$1'',`_foreach(m4_shift($@))')')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`adv_numbers',`1,2,3,4,5,6,7,8,9')m4_dnl
m4_define(`mod_numbers',`1,2,3,4,5')m4_dnl
m4_define(`start_numbers',`1,2,3,4,5,6,7,8,9')m4_dnl
m4_define(`tut_numbers',`1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`topic_list',``beta',`bugs',`compatibility',`compiling',
  `copyright',`download',`faq',`installation',`intro',`lazy',
  `news',`papers'')m4_dnl
m4_define(`subtopic_list',``advanced',`modularization',`start',
  `tutorial'')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`_gbeta',`<font class="gbeta">gbeta</font>')m4_dnl
m4_define(`_mjolner',
  `<a href="http://daimi.au.dk/~beta/Daimi/index.html" target="_top"
   >Mjolner BETA System</a>')m4_dnl
m4_define(`__mjolner',`Mjolner BETA System')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`_hl_base',`<h`$1' class="pagetitle">`$2'</h`$1'>')m4_dnl
m4_define(`_h1',_hl_base(1,`$1'))m4_dnl
m4_define(`_h2',_hl_base(2,`$1'))m4_dnl
m4_define(`_h3',_hl_base(3,`$1'))m4_dnl
m4_define(`_h4',_hl_base(4,`$1'))m4_dnl
m4_define(`_h5',_hl_base(5,`$1'))m4_dnl
m4_define(`_coords_base',`<center>
  <table class="schedule">
  <tr><td>Day</td><td>`$1'</td></tr>
  <tr><td>Time</td><td>`$2'</td></tr>
  <tr><td>Room</td><td>`$3'</td></tr>
  </table>
</center>')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`_topref',
  `<a href="javascript:top.topics.activate($3);">$2</a>')m4_dnl
m4_define(`_mailref',`<a href="mailto:$1">$2</a>')m4_dnl
m4_define(`_ref',`<a href="$1_index$2.html" target="display">$3</a>')m4_dnl
m4_define(`_xref',`<a href="$1" target="_blank">$2</a>')m4_dnl
m4_define(`_xxref',`_xref($1,$1)')m4_dnl
m4_dnl
m4_define(`_intro_ref',          `_topref(`intro',`$1',`0')')m4_dnl
m4_define(`_start_ref',          `_topref(`start',`$1',`1')')m4_dnl
m4_define(`_tutorial_ref',       `_topref(`tutorial',`$1',`2')')m4_dnl
m4_define(`_modularization_ref', `_topref(`modularization',`$1',`3')')m4_dnl
m4_define(`_lazy_ref',           `_topref(`lazy',`$1',`4')')m4_dnl
m4_define(`_advanced_ref',       `_topref(`advanced',`$1',`5')')m4_dnl
m4_define(`_papers_ref',         `_topref(`papers',`$1',`6')')m4_dnl
m4_define(`_download_ref',       `_topref(`download',`$1',`7')')m4_dnl
m4_define(`_installation_ref',   `_topref(`installation',`$1',`8')')m4_dnl
m4_define(`_compiling_ref',      `_topref(`compiling',`$1',`9')')m4_dnl
m4_define(`_faq_ref',            `_topref(`faq',`$1',`10')')m4_dnl
m4_define(`_bugs_ref',           `_topref(`bugs',`$1',`11')')m4_dnl
m4_define(`_copyright_ref',      `_topref(`copyright',`$1',`12')')m4_dnl
m4_define(`_news_ref',           `_topref(`news',`$1',`13')')m4_dnl
m4_define(`_beta_ref',           `_topref(`beta',`$1',`14')')m4_dnl
m4_define(`_compatibility_ref',  `_topref(`compatibility',`$1',`15')')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl Topic related
m4_dnl
m4_define(`topic_button',`<small>
    <b><input type=button value="`$2'"
              onClick="activate(`$1');"></b>
  </small>')m4_dnl
m4_define(`topic_entry',`  <tr>
    <td align=center width=5>
      <img src="bullet.gif" name="mark`$1'">
    </td>
    <td align=left>topic_button(`$1',`$2')</td>
  </tr>')m4_dnl
m4_define(`topic_headline',`  <tr>
    <td colspan=2 height=30>_hl_base(3,`$1')</td>
  </tr>')m4_dnl
m4_define(`topic_link_entry',`  <tr>
    <td></td>
    <td><font size=3>`$2'_xref(`$1',`$3')`$4'</font></td>
  </tr>')m4_dnl
m4_dnl
m4_define(`subtopic_button',`<small>
    <b><input type=button 
              value="`$3'"
              onClick="`$1'_activate(`$2');"></b>
  </small>')m4_dnl
m4_define(`subtopic_radio',`<small>
    <b><input type=radio 
              onClick="`$1'_activate(`$2');" 
              name="`$1'_mark`$2'">`$3'</b>
  </small>')m4_dnl
m4_define(`subtopic_entry',`<tr>
    <td align=left>subtopic_radio(`$1',`$2',`$3')</td>
  </tr>')m4_dnl
m4_define(`subtopic_buttons',`m4_dnl
<table class="pagetitle" align=center border=0 cellpadding=0>
  <form name="$1_form">
    foreach(`$1_entry('`$'1`)
    ',$1_numbers)

    <tr><td>&nbsp;</td></tr>
    <tr>
      <td align=right colspan=2>$1_button(`$1selected-1',`Pr')</td>
    </tr>
    <tr>
      <td align=right colspan=2>$1_button(`$1selected+1',`Nx')</td>
    </tr>
  </form>
</table>')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_define(`_notyet',`<p>
<img src="under-construction.gif" alt="Under construction">
(Not yet ready .. $1)
</p>')m4_dnl
m4_dnl
m4_dnl ======================================================================
m4_dnl
m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
