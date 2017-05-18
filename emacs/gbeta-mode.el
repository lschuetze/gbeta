;; gbeta-mode.el --- gbeta source code editing mode for Emacs,
;;                   made by adapting the BETA mode slightly.

;; Copyright (C) 1997-2005 Erik Ernst
;;
;; This file is part of "gbeta" -- a generalized version of the
;; programming language BETA.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.
;;
;; This program is destributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; Among other things, the copyright notice and this notice must be
;; preserved on all copies.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program, probably in a file named COPYING; if not,
;; write to the Free Software Foundation, Inc., 675 Mass Ave,
;; Cambridge, MA 02139, USA.
;;
;; To contact the author by email: eernst@cs.au.dk
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'gbeta-mode)

(defvar gbeta-mode-abbrev-table nil
  "Abbrev table in use in beta-mode buffers.")
(define-abbrev-table 'gbeta-mode-abbrev-table ())

(defvar gbeta-mode-map ()
  "Keymap used in gbeta-mode.")
(if gbeta-mode-map
    ()
  (setq gbeta-mode-map (make-sparse-keymap))
  (define-key gbeta-mode-map "{" 'gbeta-open-pattern)
  (define-key gbeta-mode-map "}" 'gbeta-close-pattern)
  ;;(define-key gbeta-mode-map ")" 'gbeta-right-paren)
  (define-key gbeta-mode-map "#" 'gbeta-insert-do)
  (define-key gbeta-mode-map "\177" 'backward-delete-char-untabify)
  (define-key gbeta-mode-map "\t" 'gbeta-tab)
  (define-key gbeta-mode-map "\^m" 'gbeta-newline)
  )

(autoload 'c-macro-expand "cmacexp"
  "Display the result of expanding all C macros occurring in the region.
The expansion is entirely correct because it uses the C preprocessor."
  t)

(defvar gbeta-mode-syntax-table nil
  "Syntax table in use in beta-mode buffers.")

(if gbeta-mode-syntax-table
    ()
  (setq gbeta-mode-syntax-table (make-syntax-table (standard-syntax-table)))
  (modify-syntax-entry ?\( "()1" gbeta-mode-syntax-table)
  (modify-syntax-entry ?\) ")(4" gbeta-mode-syntax-table)
;;;  (modify-syntax-entry ?\( ". 1" gbeta-mode-syntax-table)
;;;  (modify-syntax-entry ?\) ". 4" gbeta-mode-syntax-table)
  (modify-syntax-entry ?* ". 23" gbeta-mode-syntax-table)
  (modify-syntax-entry ?% "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?{ "(" gbeta-mode-syntax-table)
  (modify-syntax-entry ?} ")" gbeta-mode-syntax-table)
  (modify-syntax-entry ?& "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?+ "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?- "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?_ "w" gbeta-mode-syntax-table)
  (modify-syntax-entry ?/ "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?< "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?= "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?> "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?| "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?@ "." gbeta-mode-syntax-table)
  (modify-syntax-entry ?' "\"" gbeta-mode-syntax-table)
  (modify-syntax-entry ?/ "< 12" gbeta-mode-syntax-table)
  (modify-syntax-entry ?\n ">" gbeta-mode-syntax-table)
  )

;; A function with the natural name for setting up the gbeta mode 

(defun gbeta-mode () 
  "Major mode for editing gbeta code.

This mode is a modified version of the BETA mode.  For this
reason, many functions and variables are named \"beta-..\" and not
\"gbeta-..\", and documentation of functions will use \"BETA\" where 
\"gbeta\" would otherwise be expected.

Tab indents the current line of gbeta code.
To get an ordinary tab-character use C-q TAB
<Return> indents the current line and the new line.
A \{ opens a new pattern \{.
A \} closes the innermost construct with the appropriate end marker like
\}.
<Delete> converts tabs to spaces as it moves back.

gbeta-comments:
===============

Comments start with // and end at end-of-line.
Four useful functions exist for manipulating comments:
 beta-comment-justify 
   Formats a gbeta comment according to the gbeta recommandations (i.e. with '*'
   in front of each new line in the comment).  Furthermore, the comment is
   formatted to fill as little as possible. Assumes that the cursor is 
   positioned within a gbeta comment.  If not, the first comment found before
   the cursor is justified.  If no comment is found before the cursor position,
   the first comment following the cursor position will be affected.
 beta-comment-justify-region
   Like beta-comment-justify, except that the marked region is expected to be
   part of some gbeta comment, and that only that part of the region is to be
   reformatted.
 beta-convert-region-to-comment
   Takes the marked region and surrounds it with gbeta comment symbols, and
   formats the new comment according to the gbeta comment recommandations.  Any
   comment symbols in the marked region will be converted into {*, 
   respectively *} to avoid spurious problems with nested comments (not
   supported by the gbeta compiler).
 beta-remove-comment
   Is the 'inverse' of beta-convert-region-to-comment'.  Removes the gbeta
   comment symbols at the either end of the region, restoring any nested
   comment symbols, enclosed in this comment.

Also the function indent-buffer is supplied as an alternative to indent-region.

Local key map:
==============
\\{gbeta-mode-map}
Variables controlling indentation style:
========================================

 gbeta-tab-to-comment
    Non-nil means that for lines which don't need indenting, TAB will
    either delete an empty comment, indent an existing comment, move 
    to end-of-line, or if at end-of-line already, create a new comment.
 gbeta-auto-indent
    Non-nil means that NEWLINE at the end of a line will auto-indent to
    the 'correct' position on the new line.
 beta-space-after-star
    Non-nil means, that if beta-auto-indent is t, \"* \" is inserted after NEWLINE within 
    comments instead of only \"*\".
 beta-semicolon-after-closing
    Non-nil means that a semicolon is inserted after the closing construction 
   (if needed) by beta-close-pattern.
 gbeta-indent-level
    Indentation of gbeta statements within surrounding block.
    The surrounding block's indentation is the indentation
    of the line on which an open-construct like appears (like \{).
 gbeta-separator-indent-level
    Indentation of an enter-, do- or exit-line with respect
    to the containing block. ;; updated for gbeta to just '#'
 gbeta-case-indent-level
    Indentation of the ? lines in case-blocks with respect to the
    containing block.
 gbeta-below-separator-indent
    Extra indentation of lines belonging to the do-, enter- or
    exit-part of a pattern.
 gbeta-comment-indent-level
    Indentation of comment-lines after the first one, with respect
    to the containing block.
 (g)beta-if-indent-level
    Indentation of lines within an \(if-block except lines starting
    with // or else (tl: unused).
 (g)beta-else-indent-level
   Indentation of else-lines in if-blocks with respect to containing
   if block (tl: unused).
 (g)beta-for-indent-level
    Indentation of lines within a for-block (tl: unused).
 (g)gbeta-block-indent-level
    Extra indentation of a new block (tl: unused).
 (g)beta-evaluation-indent-level
    Extra indentation of a line beginning with -> (tl: unused).
 gbeta-combined-indent
    If non-nil, multiple closing constructors  on the same line
    (e.g. if)for)#) ) will be indented relative to the opening constructor 
    corresponding to the *last* closing constructor

Invoking gbeta-mode:
===================

Add the following to your .emacs file to automatically go into gbeta-mode when
the name of the buffer ends in \".gb\". Make sure GBETA_ROOT is set to
point to the root of your gbeta installation. Otherwise, it is assumed
that gbeta is installed in \"~/gbeta\".

(setq gbeta-root (getenv \"GBETA_ROOT\"))
(if (not gbeta-root) (setq gbeta-root \"~/gbeta\") (message \"GBETA_ROOT=%s\" gbeta-root))
(load-file (concat gbeta-root \"/emacs/gud-gbeta.elc\"))
(setq load-path (append (list (concat gbeta-root \"/emacs\")) load-path))
(load-library \"gud-gbeta\")
(load-library \"gbeta-mode\")
;;(load-library \"gbeta-font-lock\")
(setq auto-mode-alist (append '((\"\\.gb$\" . gbeta-mode)) auto-mode-alist))

gbeta-mode-hook:
================

Turning on gbeta-mode calls the value of the variable gbeta-mode-hook with no
args, if that value is non-nil. For instance, adding the following in your
.emacs file will bind some of the often used functions in beta-mode to
key-sequences prefixed by C-xC-r:

 (defun mygbeta ()
   \"Make the following local bindings in gbeta-mode:
C-xC-rj calls beta-comment-justify
C-xC-rr calls beta-comment-justify-region
C-xC-rc calls beta-convert-region-to-comment
C-xC-ru calls beta-remove-comment
C-xC-ri calls indent-buffer.\"
   (interactive)
   (local-unset-key \"\\C-x\\C-r\")
   (local-set-key \"\\C-x\\C-rj\" 'beta-comment-justify)
   (local-set-key \"\\C-x\\C-rr\" 'beta-comment-justify-region)
   (local-set-key \"\\C-x\\C-rc\" 'beta-convert-region-to-comment)
   (local-set-key \"\\C-x\\C-ru\" 'beta-remove-comment)
   (local-set-key \"\\C-x\\C-ri\" 'indent-buffer))

 (add-hook 'gbeta-mode-hook 'mygbeta) " 

  (interactive)
  (kill-all-local-variables)
  (use-local-map gbeta-mode-map)

  (make-local-variable 'gbeta-mode-version)
  (make-local-variable 'paragraph-start)
  (make-local-variable 'paragraph-separate)
  (make-local-variable 'paragraph-ignore-fill-prefix)
  (make-local-variable 'indent-line-function)
  (make-local-variable 'require-final-newline)
  (make-local-variable 'comment-start)
  (make-local-variable 'comment-column)
  (make-local-variable 'gbeta-construct-start)
  (make-local-variable 'gbeta-construct-end)
  (make-local-variable 'gbeta-construct-delimiters)
  (make-local-variable 'gbeta-separator)
  (make-local-variable 'comment-indent-function)
  (make-local-variable 'parse-sexp-ignore-comments)

  (setq local-abbrev-table gbeta-mode-abbrev-table)
  (set-syntax-table gbeta-mode-syntax-table)
  (setq paragraph-ignore-fill-prefix t)
  (setq require-final-newline t)

  (setq major-mode                      'gbeta-mode
	mode-name                       "gbeta"
	gbeta-mode-version              "2"
	comment-start                   "//"
	indent-line-function            'gbeta-indent-line
	require-final-newline           t
	comment-column                  40
	paragraph-start                 (concat "^$\\|" page-delimiter)
	paragraph-separate              paragraph-start
	gbeta-construct-start           "%?{\\|%?("
	gbeta-construct-end             "\\(\);?\\|};?\\)"
	gbeta-construct-delimiters      (concat 
					 gbeta-construct-start "\\|"
					 gbeta-construct-end   "\\|"
					 "\\(^\-\-\\)"
					 )
	;; gbeta-construct-delimiters: this should be both gbeta-construct-start and gbeta-construct-end
	gbeta-separator                 "\\(\\b#\\b\\|\\belse\\b\\|\\bdo\\b\\)"
	comment-indent-function         'c-comment-indent
	parse-sexp-ignore-comments      nil
	)
  ;; Leftovers:
  ;;   (make-local-variable 'comment-end)
  ;;   (setq comment-end "")
    (make-local-variable 'comment-start-skip)
    (setq comment-start-skip "//.*$" ;; "\(\\*+ *"
	  )
  ()
  (run-hooks 'gbeta-mode-hook))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                    ;;
;; gbeta indentation related functions and constants  ;;
;;                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst gbeta-separator-indent-level 0
  "*Indentation of enter-, do-, and exit-lines with respect to containing
block.") 

(defconst gbeta-indent-level 2
  "*Indentation of gbeta statements with respect to containing block.")

(defconst gbeta-combined-indent t
  "*If non-nil, multiple closing constructors  on the same line
(e.g. if)for)#) ) will be indented relative to the opening constructor 
corresponding to the *last* closing constructor")

(defconst gbeta-comment-indent-level 0
  "*Indentation of comment-lines after the first one.")

(defconst gbeta-case-indent-level 0
  "*Indentation of ?-lines in case-blocks with respect to containing
case block.")

(defconst gbeta-block-indent-level 0
  "*Extra indentation of a new block, with respect to the containing block.")

(defconst gbeta-construct-start
  (concat
   "\\<\\(if\\|else\\|for\\|while\\|case\\)\\>" "\\|"
   ;; "%?{" "\\|"
   "%?(" "\\|"
   ;; "%{" "\\|"
   "\w:.*%?{"))

(defconst gbeta-below-separator-indent 0
  "*Extra indentation of statements belonging to the enter-, do-, or
exit-part of a pattern. /, repeat are handled as separators
as well.")  

(defconst gbeta-tab-to-comment nil
  "*Non-nil means that a TAB at the end of a non-empty line will start
a comment at beginning at comment-column.")

(defconst gbeta-evaluation-indent-level 2
  "*Extra indentation of a line beginning with '->', with respect to the 
containing block.")

(defconst gbeta-auto-indent t
  "*Non-nil means that NEWLINE at the end of a line will auto-indent to
the 'correct' position on the new line.")

(defconst gbeta-space-after-star t
  "*Non-nil means, that if beta-auto-indent is t, \"* \" is inserted after NEWLINE within 
comments instead of only \"*\".")

(defun gbeta-tab ()
  "Indent current line as gbeta code.
If at end of line, and gbeta-tab-to-comment is t, then moves to
comment-column, and begins gbeta comment."
  (interactive)
  (if (and (eolp) (< (current-indentation) (current-column))
	   gbeta-tab-to-comment)
      (beta-indent-to-comment)) 
  (if (<= (current-column) (current-indentation))
      (gbeta-indent-line)
    (save-excursion (gbeta-indent-line))))

;; the main function indenting the current line
(defun gbeta-indent-line ()
  "Indent current line as gbeta code."
  (interactive)
  (let ((indent-tabs-mode nil) 
	(ilevel 0)
	(olevel 0) 
	(gbeta-frag nil)
	(dopart-frag nil)
	(beta-inside-if nil)
	(beta-inside-for nil)
	(beg 0)
	(beginning-construct-at-point-min nil)
	(skip 0)
	(lin 0)
	(col 0)
	(incode nil)
	(after-colon nil)
	(case-fold-search t))
    ;; Added 9-Apr-92 by datpete
    (beginning-of-line)
    (setq beg (point))
    (skip-chars-forward " \t")
    (if (and (not (looking-at comment-start)) (gbeta-within-comment))
	(progn ; Not looking at comment nor within comment
	  (save-excursion
	    (goto-char (match-beginning 0))
	    (setq ilevel (+ gbeta-comment-indent-level (current-column))))
	  
	  ;; do the indentation of the comment line
	  (if (>= ilevel (current-column))
	      (indent-to ilevel)
	    (progn
	      (delete-region beg (point))
	      (indent-to ilevel)))
	  )
      
      ;; Not within comment
      (progn
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;; Save excursion and search back for the beginning contructor.     ;;
	;; Choose the current indentation for the surrounding contructor as ;;
        ;; basis for the indentation of the current line.                   ;;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(save-excursion
	  (if gbeta-combined-indent
	      (if (gbeta-ending-constructor-on-line)
		  (progn
		    (setq skip 1)
		    (setq lin (line-no))
		    (end-of-line))
		(progn
		  (setq skip 0)
		  (beginning-of-line)))
	    (progn
	      (setq skip 0)
	      (beginning-of-line)))

	  (setq beg (point))
	  (gbeta-beginning-of-construct skip)
	  (setq col -1)
	  (if (= skip 1)
	      (while (and (= lin (line-no)) (not (= (current-column) col)))
		;; opening construct was on same line, go back one more
		(setq col (current-column))
		(gbeta-beginning-of-construct 0)))

	  (setq olevel (current-column))
          (setq ilevel olevel)
	
	  (if (and (= (point) (point-min)) (not (looking-at "\\bdo\\b")))
	      (setq gbeta-frag t))
          
	  (if (= (point) beg)
	      (setq beginning-construct-at-point-min t)
;; 	    (cond 
;; 	     ((looking-at "\\bif\\b")
;; 	      (setq beta-inside-if t))
;; 	     ((looking-at "\\bfor\\b")
;; 	      (setq beta-inside-for t)))
	    )

	  (if (looking-at "--")
	      (progn 
		(setq gbeta-frag t)
		(if (looking-at "---*\\s-*\\w+\\s-*:\\s-*dopart") 
		    (setq dopart-frag t)))))
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Now we are back on the line to indent: Do the indentation ;;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(beginning-of-line)
	(setq beg (point))
	(skip-chars-forward " \t")
	
	(setq after-colon (gbeta-after-colon))
	
	;; Check special fragment indentation.
	(cond
	 ;; if beginning-of-construct found dopart-frag, use normal indentation
	 (dopart-frag 
	  (if (not (looking-at "\\bdo\\b"))
	      (setq ilevel (+ ilevel gbeta-indent-level))))
	 
	 ;; if beginning-of-construct found "--", use zero indentation
	 (gbeta-frag (setq ilevel 0)))

	;; check special indentation inside constructs
	(cond
	 ;; tl Nogle af de her conditions er måske ikke mere nødvendige...

	 ;; if looking at an ?-line use special indentation
	 ((looking-at "\\?")
	  (setq ilevel (+ ilevel gbeta-case-indent-level)))
	 
;; 	 ;; if looking at an else-line use special indentation
;; 	 ((looking-at "\\belse\\b")
;; 	  (setq ilevel (+ ilevel beta-else-indent-level)))
	 
;; 	 ;; if inside an if-block, not looking at '//' or else, use special...
;; 	 (beta-inside-if
;; 	  (setq ilevel (+ ilevel beta-if-indent-level)))
	 
;; 	 ;; if inside a for-block, use special...
;; 	 (beta-inside-for
;; 	  (setq ilevel (+ ilevel beta-for-indent-level)))
	 
	 ;; if looking at a fragment use special indentation
	 ((looking-at "--")
	  (setq ilevel 0))
	 
;; 	 ;; if looking at dopart-slot, use special...
;; 	 ((looking-at "<<\\s-*slot\\s-+\\w+\\s-*:\\s-*dopart")
;; 	  (progn
;; 	    (setq ilevel (+ ilevel gbeta-separator-indent-level))))
	 
	 ;; if looking at an enter-,do- or exit-line use special...
	 ((single-hash-line)	; tl this doesn't work properly? UPDATE: "\\b#\\b" doesn't match a solitary # (why not?)
	  (progn
	    (setq ilevel (- ilevel gbeta-separator-indent-level))
	    (setq after-colon nil)));; No special indentation, see below.

	 ;; else
	 ((and (not gbeta-frag)
	       (not beginning-construct-at-point-min))
	  (setq ilevel (+ ilevel gbeta-indent-level)))
	 );;cond
	
	(cond
	 ;; if looking at construct-start after colon, indent some more
	 ;;((and after-colon (looking-at gbeta-construct-start))
	 ;; (setq ilevel (+ ilevel gbeta-block-indent-level)))
	 
	 ;; if looking at beginning of comment after colon, indent some more
	 ;;((and after-colon (looking-at "\(\\*"))
	 ;; (setq ilevel (+ ilevel gbeta-block-indent-level)))
	 
;; 	 ;;if positioned after colon, indent some more.
;; 	 (after-colon
;; 	  (setq ilevel (+ ilevel gbeta-block-indent-level)))
	 
;; 	 ;; if looking at '->' indent some more
;; 	 ((looking-at "|")
;; 	  (setq ilevel (+ ilevel gbeta-evaluation-indent-level)))
	 
	 ;; if below a separator indent some more.
	 ((and (not (looking-at gbeta-separator))
	       (setq incode (gbeta-below-separator)))
	  (setq ilevel (+ ilevel gbeta-below-separator-indent)))
	 );; cond
	
	;; if a  gbeta-construct-end start the line
	;; don't indent so much
	(if (looking-at gbeta-construct-end)
	    (setq ilevel olevel))
	
	;; do the indentation
	(if (>= ilevel (current-column))
	    (indent-to ilevel)
	  (progn
	    (delete-region beg (point))
	    (indent-to ilevel))))))
 0)

;; gbeta comments are '//' (single line comments)
(defun gbeta-within-comment ()
  "Return t if within a gbeta comment, nil otherwise."
  (interactive)
  (save-excursion
    ;(beginning-of-line)      
    (if (= (point) 1)
	nil;; optimization
      (progn
	(if (looking-at "/") (forward-char 1))
	(let ((end (point)))
	  (if (re-search-backward "\\(//\\)"
				  (- (point) (current-column)) t)
	      (if (looking-at comment-start)
		  t;;(not (beta-within-string end))
		nil)
	    nil))))))

;; Added 8-Oct-2009 by laumann
(defun single-hash-line ()
  "Function to determine if the first non-whitespace character on the line is a '#'"
  (interactive)
  (let ((res nil))
  (save-excursion
      (beginning-of-line)
      (setq res (looking-at "^[ \t]*#.*$")))
  res))

(defun gbeta-ending-constructor-on-line ()
  "Are there any ending constructors on current line?"
  (interactive "p")
  (beginning-of-line)
  (let ( (begin (point)) (result nil) (done nil) (case-fold-search t) )
    (end-of-line)
    (while (not done)
      (setq result (re-search-backward gbeta-construct-end begin 'move))
      (setq done t))
    result))

(defun gbeta-beginning-of-construct (&optional arg)
  "Move backward to the beginning of this construct, or to start of buffer.
With argument, ignore that many closing constructors.
Returns new value of point in all cases."
  (interactive "p")
  (or arg (setq arg 0))
  (let ((end (point)) (cont nil) (cnt 0) (case-fold-search t) (p 0) (itr 0))
    ;; cnt is the number of non-matched beginning constructs to skip backwards
    (if (>= arg 0)
	(while (>= cnt 0)
	  (re-search-backward gbeta-construct-delimiters 1 'move)
	  ;; check that it was a real beginning construct:
	  (setq cont t)
	  (while cont
	    (if nil;;(beta-within-string end)
		(progn
		  (setq p (point))
		  (re-search-backward gbeta-construct-delimiters 1 'move)
		  (setq cont (not(= p (point)))))
	      (if (gbeta-within-comment)
		  (progn
		    (setq p (point))
		    (re-search-backward gbeta-construct-delimiters 1 'move)
		    (setq cont (not(= p (point)))))
		(setq cont nil))))
	  (if (looking-at "--") 
	      (setq cnt -1)
	    (progn
	      (if (= (point) 1)
		  ;; beginning of buffer reached
		  (setq cnt -1)
		(if (looking-at gbeta-construct-end)
		    ;; this looks like an ending construct
		    (if (not (gbeta-within-comment))
			;; looking at a real ending construct
			(if (> arg 0)
			    ;; Still some endings left to skip
			    (setq arg (1- arg))
			  ;; looking at real ending construct, and no more to skip
			  (setq cnt (1+ cnt))))
		  ;; looking at real beginning construct: one less to match
		  (setq cnt (1- cnt)))))))
	(point))
    (point))
  ;; laumann: The first point that is a non-whitespace is actually the beginning of the construct                      
  ;;          Return that point...
  (first-nonwhite-point))

;; Added 8-Oct-2009 by laumann
(defun first-nonwhite-point ()
  "Skip to first non-white-space char on the current line"
  (interactive)
  (progn
    (beginning-of-line)
    (skip-chars-forward " \t")
    (point)))

;; added 9-Apr-92 by datpete
(defun line-no ()
  "Return current line number in buffer"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (1+ (count-lines 1 (point)))))

(defun gbeta-after-colon ()
  "Returns t if point is after a colon, possibly with <, @, ^, # white space, 
a prefix and/or a comment in between."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (gbeta-skip-comment-backward)
    (skip-chars-backward " \t\n")
    (skip-chars-backward "_A-Za-z0-9().");; prefix
    (skip-chars-backward " \t\n<@^#");; whitespace and instantiation
    (if (> (point) 1) (backward-char 1))
    (looking-at ":")))

;; Added 15-Oct-2009 by laumann
(defun eol ()
  "Returns the char number of the end of the current line"
  (interactive)
  (save-excursion
    (end-of-line)
    (point)))

;; Added 15-Oct-2009 by laumann
(defun gbeta-skip-comment-backward ()
  "Latest version of skipping"
  (interactive)
  (let ((p (point))
	(cont t))
    (skip-chars-backward " \t")
    (backward-char 1)
    (if (not (looking-at "\n"))
	(forward-char 1))
    (if (looking-at "[ \t]*\n")		; Vilkårligt whitespace før newline
	(progn
	  (beginning-of-line)
	  (while cont
	    (skip-chars-forward "^//\n")
	    (if (and (looking-at comment-start) (not (gbeta-within-string (eol)))) ;; strings
		(setq p  (point)	; save point
		      cont  nil)	; and quit
	      (if (looking-at "\n") ;; no comments in line
		  (setq cont nil)))   ; don't save point! (but quit)
	    (forward-char 2))))		; skip the comment in string...
    (goto-char p)))

(defun gbeta-within-string (end)
  (interactive "p")
  (save-excursion
    (save-restriction
      (if (= end 1)
	  nil;; optimization
	(progn
	  (narrow-to-region (point) end)
;;	  (message "Occurrences: %d" (beta-count-matches "\\([^\\]\\|\\\\\\\\\\)'"))
	  (> (mod (gbeta-count-matches "\\([^\\]\\|\\\\\\\\\\)'") 2) 0))))))

(defun gbeta-count-matches (regexp)
  "Returns number of matches for REGEXP following point.
Based on the standard how-many function"
  (interactive "sHow many matches for (regexp): ")
  (let ((count 0) (opoint -1))
    (save-excursion
      ;; If we did forward-char on the previous loop,
      ;; and that brought us to eof, search anyway.
      (while (and (or (not (eobp)) (/= opoint (point)))
                  (re-search-forward regexp nil t))
        (if (prog1 (= opoint (point)) (setq opoint (point)))
            (forward-char 1)
          (setq count (1+ count))))
     count)))

(defun gbeta-below-separator ()
  "Returns t if point is below a separator as enter, exit, or //."
  (interactive)
  (save-excursion
    (let ( (col 0) (case-fold-search t) )
      (re-search-backward 
       (concat "\\(" gbeta-separator "\\|" gbeta-construct-delimiters "\\)")
       nil 'move 1)
      (goto-char (match-beginning 0))
      (setq col -1)
      (while (and (looking-at gbeta-construct-end) (not (= (current-column) col)))
	(setq col (current-column))
	(gbeta-beginning-of-construct) 
	(re-search-backward 
	 (concat "\\(" gbeta-separator "\\|" gbeta-construct-delimiters "\\)")
	 nil 'move 1)
	(goto-char (match-beginning 0)))
      (not (looking-at gbeta-construct-start)))))

;; This function replaces beta-newline, because there is no need to
;; determine whether or not we are inside a comment anymore
(defun gbeta-newline ()
  "Insert newline and indent current and following line."
  (interactive)
  (if gbeta-auto-indent
      (progn
	(newline)
	(save-excursion
	  (backward-char 1)
	  (gbeta-indent-line))
	(gbeta-indent-line))))

(defun gbeta-insert-do ()
  "Insert dopart separator '#', and indents line"
  (interactive)
  (insert "#")
  (gbeta-tab))

;; gbeta open and close pattern functions
(defun gbeta-open-pattern ()
  "Insert pattern start {, and indent line."
  (interactive)
  (insert "{ ")
  (gbeta-tab))

;; Large parts of the original beta-close-pattern commented out
(defun gbeta-close-pattern ()
  "Insert end marker for current construct"
  (interactive)
  (insert "}")
  (save-excursion 
    (beginning-of-line)
    (gbeta-indent-line))
;;   "Insert end marker for current construct plus semicolon (if needed) and indent the line."
;;   (interactive)
;;   (let ((c "") (d "") (case-fold-search t))
;;     (if (gbeta-within-comment)
;; 	(save-excursion
;; 	  (setq c "\*\)")
;; 	  (skip-chars-backward " \t")
;; 	  (if (> (current-column) 1)
;; 	      (progn
;; 		(backward-char 2)
;; 		(if (not (looking-at "\(\\*"))
;; 		    (progn
;; 		      (forward-char 1)
;; 		      (if (looking-at "\\*") (delete-char 1)))))))

;;       (save-excursion
;; 	(beta-beginning-of-construct)
;; 	(cond
;; 	 ((looking-at "\(#")   (setq c "#\)"))
;; 	 ((looking-at "\(for\\b") (setq c "for\)"))
;; 	 ((looking-at "\(if\\b")  (setq c "if\)"))
;; 	 ((looking-at "\(")    (setq c "\)")))
;; 	(if (> (current-column) 1)
;; 	    ;; current-column is 1 if this is a descriptor fragment
;; 	    (setq d ";"))
;; 	))
;;     (if (equal c "")
;; 	(error "beta-mode error: Not inside construct")
;;       (insert c)(blink-matching-open)
;;       (if beta-semicolon-after-closing
;; 	  (if (not (looking-at ";"))(insert d))))
;;     (save-excursion
;;       (beginning-of-line)
;;       (beta-indent-line)))
  )

(defun indent-buffer ( )
  "Indent the entire buffer according to mode."
  (interactive "*")
  (save-excursion
    (if (> (point-max) 10000)
	(message "Indenting the entire buffer ... (be patient)")
      (message "Indenting the entire buffer ..."))
    (indent-region (point-min) (point-max) nil)
    (message "Indenting the entire buffer ... done")))

;;;; Execution related variables and functions
(defvar gbeta-compiler-options nil
  "Options supplied to the compiler in gbeta-compile function.")

(defvar gbeta-compiler-command
  (if (getenv "GBETA_ROOT") (concat (getenv "GBETA_ROOT") "/bin/gbeta") "gbeta")
  "gbeta compiler command.")

;;;;; This is left out, because gbeta programs aren't compiled to
;; executable binaries as BETA programs (at least not by default)
;; (defvar gbeta-compile ()
;;   (interactive)
;;   (compile (concat gbeta-compiler-command " " gbeta-compiler-options " " buffer-file-name)))

(defun gbeta-compile ()
  "Possibly a replacement \"compile\" function for gbeta"
  (interactive)
  (compile (concat gbeta-compiler-command " " gbeta-compiler-options " " buffer-file-name)))

(defun gbeta-execute ()
  (interactive)
  (require 'comint)
  (pop-to-buffer
   (make-comint "gbeta Execution" 
		gbeta-compiler-command
		nil
		(concat gbeta-compiler-options " -v ")
		buffer-file-name)))

;; -*- End of gbeta-mode.el -*-