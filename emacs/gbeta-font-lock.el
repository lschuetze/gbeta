;;; gbeta-font-lock.el --- using font-lock-mode with gbeta.

;;; Copyright (C) 2001-2005 Erik Ernst.

;;; Author: Erik Ernst <eernst@daimi.au.dk>
;;; Version: 1.0
;;; Requires: GNU Emacs 20.7 or newer

;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2, or (at your option)
;;; any later version.

;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to
;;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                  Using font-lock with gbeta                    ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Adds support for font-lock decoration of gbeta source code.
;;;
;;; To use this library, simply 'require' it in your mode hook 
;;; for gbeta, '(require 'gbeta-font-lock)'.
;;;
;;; You must use 'add-hook' in stead of 'setq' when installing your
;;; gbeta-mode-hook; the facilities in this file are installed with 
;;; 'add-hook', and a subsequent '(setq gbeta-mode-hook ...)' will simply
;;; overwrite all previously added hooks.  So your normal gbeta-mode 
;;; customizations should be loaded with something like 
;;; '(add-hook 'gbeta-mode-hook 'mygbeta)'.
;;;
;;; To make it possible for emacs to find this file, you must have the 
;;; path to it in your 'load-path'.  This might already be the case, 
;;; otherwise you can use something like
;;; '(setq load-path (cons "/usr/local/lib/beta/emacs/v1.6" load-path))'.
;;;
;;; NB: If you _do_not_ want to use "beta-menu19" you can execute
;;; '(setq gbeta-font-lock-insert-menus-p nil)'.  By default,
;;; beta-menu19 will be loaded if not already present, and 
;;; a few beta font lock specific menu items will be inserted 
;;; to allow selection between different font-lock styles.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Executive summary:
;;;
;;;  (setq load-path (cons "/users/beta/emacs/v1.7" load-path)); if needed
;;; 
;;;  (defun mygbeta () 
;;;    (interactive)
;;;    (require 'gbeta-font-lock)
;;;    <<your-usual-stuff-to-initialize-gbeta-mode>>)
;;;
;;;  (add-hook 'gbeta-mode-hook 'mygbeta) ; NB: 'add-hook', not 'setq'
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'gbeta-mode)
(require 'font-lock)
(require 'regexp-opt)

(provide 'gbeta-font-lock)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Some regexps useful in defining
;; highlighting specifications; each
;; regexp selects a set of strings which
;; is somewhat ;-) well-defined in terms
;; of gbeta and the fragment language
;; constructs
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fragment language
(defconst gbeta-font-lock-property-regexp
  (eval-when-compile
    (concat "^\\("
	    (regexp-opt '("ORIGIN" "BODY" "MDBODY" "INCLUDE"
			   "LIBFILE" "LINKOPT" "OBJFILE" "MAKE" "BUILD"))
	    "\\)\\b\\(\\s *\\w*\\s '[^']*'\\)+;?")))
(defconst gbeta-font-lock-slotdecl-regexp
  ;; safer but slower: "--+\\s *\\w+\\s *:\\s *\\w+\\s *--+"
  "--+ *\\w+: *\\w+ *--+")
(defconst gbeta-font-lock-slotappl-regexp
  ;; safer but slower: "<<\\s *SLOT\\s *\\w+\\s *:\\s *\\w+\\s *>>"
  "<<SLOT +\\w+: *\\w+>>")
(defconst gbeta-font-lock-fragment-regexp
  ;; FIXME: check if some kinds are missing
  (eval-when-compile
    (concat "\\(^\\("
	    (regexp-opt '("ORIGIN" "BODY" "MDBODY" "INCLUDE"
			   "LIBFILE" "LINKOPT" "OBJFILE" "MAKE" "BUILD"))
	    "\\)\\b\\)\\|"
	    "\\(--+[a-z_0-9: \\t]*--+\\)\\|"
	    "\\(<<SLOT [a-z_0-9:]*>>\\)")))

;; many-line construct markers: object descriptors, control structure stm.s
(defconst gbeta-font-lock-scope-regexp
  ;; includes a couple of gbeta things; should not affect gbeta code
  (eval-when-compile
    (regexp-opt '( "%?{" "};?" "%?(" ");?" ;"(#" "#)"
		   "if\\>"              ;"(if\\>" "\\<if)"
		   "for\\>"             ;"(for\\>" "\\<for)"
		   "when\\>"            ;"(when\\>" "\\<when)"
		   "while\\>"           ;"(while\\>" "\\<while)"
		   "code\\>"            ;"(code\\>" "\\<code)"
		   "\\<then\\>" "\\<else\\>" "\\<repeat\\>" ;; "//"
		   ))))

;; important for understanding overall structure
(defconst gbeta-font-lock-structurekeyword-regexp
  (eval-when-compile
    (concat "\\<\\("
	    (regexp-opt '("do" "for" "while" "case" "if" "else" "then"))
	    "\\)\\>")))

(defconst gbeta-font-lock-structurestatement-regexp
  (eval-when-compile
    (concat "\\<\\("
	    (regexp-opt '("leave" "restart" "suspend" "inner" "label" "new"))
	    "\\)\\>")))

;; other keywords
(defconst gbeta-font-lock-keyword-regexp
  (eval-when-compile
    (concat "\\<\\("
	    (regexp-opt '("this" "not" "div" "mod" "or" "xor" "and"))
	    "\\)\\>"
	    "\\|\\+\\|-\\|\\*\\|/\\|=\\|>\\|<")))

;; basic patterns and values
(defconst gbeta-font-lock-basic-regexp
  (eval-when-compile
    (concat "\\<\\("
	    (regexp-opt '("int" "char" "bool" "float" "string"
			   "shortint" "data" "true" "false" "none"))
	    "\\)\\>")))

;; declaration markers

(eval-when-compile 
  ;; safer but slower: "\\(\\(\\w+\\s *,\\s *\\)*\\w+\\s *\\):"
  (defconst gbeta-font-lock-declbase-regexp "\\(\\(\\w+, *\\)*\\w+\\):"))

(defconst gbeta-font-lock-decl-regexp
  (eval-when-compile gbeta-font-lock-declbase-regexp))
(defconst gbeta-font-lock-patterndecl-regexp
  (eval-when-compile
    (concat gbeta-font-lock-declbase-regexp "\\s *\\((#\\|(\\*\\|\\w\\)")))
(defconst gbeta-font-lock-virtualdecl-regexp
  (eval-when-compile
    (concat gbeta-font-lock-declbase-regexp "<")))
(defconst gbeta-font-lock-furtherdecl-regexp
  (eval-when-compile
    (concat gbeta-font-lock-declbase-regexp "\\(:<\\|:\\)")))
(defconst gbeta-font-lock-substancedecl-regexp
  (eval-when-compile
    (concat gbeta-font-lock-declbase-regexp "\\s *\\(@\\|\\^\\|##\\|\\[\\)")))

;; Coercion -- "get me a reference value", "get me a pattern value"
(defconst gbeta-font-lock-coercion-regexp
  "\\w+\\s *\\(##\\|\\[\\]\\)")

;; dynamic instance creation
(defconst gbeta-font-lock-new-regexp
  ;; safer but slower: "\&\\s *\\(\\w+\\|(#\\)"
  "\&\\(w+\\|(#\\)")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  A few faces special for gbeta
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar gbeta-font-lock-fragment-face
  'gbeta-font-lock-fragment-face
  "Face to use for fragment language expressions")

(defvar gbeta-font-lock-fragmentdecl-face
  'gbeta-font-lock-fragmentdecl-face
  "Face to use for fragment language declarations")

(defvar gbeta-font-lock-fragmentappl-face
  'gbeta-font-lock-fragmentappl-face
  "Face to use for fragment language references")

(defvar gbeta-font-lock-block-face
  'gbeta-font-lock-block-face
  "Face to use for block/scope delimiters")

(defvar gbeta-font-lock-structurestatement-face
  'gbeta-font-lock-structurestatement-face
  "Face to use for structurally important statements")

(defvar gbeta-font-lock-basic-face
  'gbeta-font-lock-basic-face
  "Face to use for names of basic types and values")

(defvar gbeta-font-lock-pdecl-face
  'gbeta-font-lock-pdecl-face
  "Face to use for pattern declarations")

(defvar gbeta-font-lock-vdecl-face
  'gbeta-font-lock-vdecl-face
  "Face to ude for virtual declarations")

(defvar gbeta-font-lock-fdecl-face
  'gbeta-font-lock-fdecl-face
  "Face to ude for virtual further binding or final declarations")

(defvar gbeta-font-lock-sdecl-face
  'gbeta-font-lock-sdecl-face
  "Face to use for declarations of substance")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  General choice of meaning for the 
;;;  standard faces
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; font-lock-comment-face:           for comments
;; font-lock-string-face:            for strings
;; font-lock-keyword-face:           for keyword, structure{keyword,statement}
;; font-lock-type-face:              for virtual patterns
;; font-lock-warning-face:           reserved for user
;; font-lock-builtin-face:           for object/integer/.. and true/false
;; font-lock-function-name-face:     for patterns
;; font-lock-variable-name-face:     for substance (@,##,^)
;; font-lock-constant-face:          for properties (INCLUDE etc.)
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  A sparse ('thin') highlighting
;;;  specification, a more gorgeous
;;;  one, and a hilit19-wannabee
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst gbeta-font-lock-keywords-sparse
  (list
   
   ;; Properties
   (list gbeta-font-lock-fragment-regexp 0 font-lock-constant-face t)
   
   ;; Structural clues when reading a descriptor
   (list gbeta-font-lock-structurekeyword-regexp 0 font-lock-keyword-face)
   (list gbeta-font-lock-structurestatement-regexp 0 font-lock-keyword-face)
   
   ;; Declared names
   (list gbeta-font-lock-decl-regexp 1 font-lock-function-name-face))
  
  "Font-lock specification: simple, fast")
  
(defconst gbeta-font-lock-keywords-fruitcake
  (list
   
   ;; Properties
   (list gbeta-font-lock-property-regexp 0 font-lock-constant-face t)
   
   ;; Form decl/appl
   (list gbeta-font-lock-slotdecl-regexp 0 font-lock-constant-face)
   (list gbeta-font-lock-slotappl-regexp 0 font-lock-constant-face)
   
   ;; Blocks
   (list gbeta-font-lock-scope-regexp 0 font-lock-keyword-face)
   
   ;; Structural clues when reading a descriptor
   (list gbeta-font-lock-structurekeyword-regexp 0 font-lock-keyword-face)
   (list gbeta-font-lock-structurestatement-regexp 0 font-lock-keyword-face)
   (list gbeta-font-lock-keyword-regexp 0 font-lock-keyword-face)
   (list gbeta-font-lock-coercion-regexp 1 font-lock-keyword-face)
   
   ;; Basic patterns and special values
   (list gbeta-font-lock-basic-regexp 0 font-lock-builtin-face)
   
   ;; Declared names
   (list gbeta-font-lock-patterndecl-regexp 1 font-lock-function-name-face)
   (list gbeta-font-lock-virtualdecl-regexp 1 font-lock-type-face)
   (list gbeta-font-lock-furtherdecl-regexp 1 font-lock-type-face)
   (list gbeta-font-lock-substancedecl-regexp 1 font-lock-variable-name-face))
  
  "Font-lock specification: heavy decoration, rather slow")

(defconst gbeta-font-lock-keywords-hilit-like
  (list

   ;; Properties
   (list gbeta-font-lock-property-regexp 0 font-lock-constant-face t)

   ;; Form decl/appl
   (list gbeta-font-lock-slotdecl-regexp 0 font-lock-constant-face)
   (list gbeta-font-lock-slotappl-regexp 0 font-lock-constant-face)

   ;; Blocks
   (list gbeta-font-lock-scope-regexp 0 font-lock-keyword-face)

   ;; Structural clues when reading a descriptor
   (list gbeta-font-lock-structurekeyword-regexp 0 font-lock-keyword-face)
   (list gbeta-font-lock-structurestatement-regexp 0 font-lock-keyword-face)
   (list gbeta-font-lock-keyword-regexp 0 font-lock-keyword-face)
   (list gbeta-font-lock-coercion-regexp 1 font-lock-keyword-face)

   ;; Declared names
   (list gbeta-font-lock-decl-regexp 1 font-lock-variable-name-face))

  "Font-lock specification: used to be somewhat like beta-hilit19.")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  gbeta mode menu related functions
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun gbeta-font-lock-choose-sparse ()
  (interactive)
  (gbeta-font-lock-change-specification gbeta-font-lock-keywords-sparse))

(defun gbeta-font-lock-choose-hilit-like ()
  (interactive)
  (gbeta-font-lock-change-specification gbeta-font-lock-keywords-hilit-like))

(defun gbeta-font-lock-choose-fruitcake ()
  (interactive)
  (gbeta-font-lock-change-specification gbeta-font-lock-keywords-fruitcake))

(defvar gbeta-font-lock-map (make-sparse-keymap "gbeta Font Lock Styles")
  "Local keymap for sub-menu entries to choose gbeta-font-lock style")
(defalias 'gbeta-font-lock-map (symbol-value 'gbeta-font-lock-map))

(defun gbeta-font-lock-insert-menu-entries ()
  (interactive)
  (require 'gbeta-menu19)

  (define-key gbeta-mode-map [menu-bar gbeta gbeta-font-lock-map]
    '("Font Lock Styles" . gbeta-font-lock-map))
  
  (define-key gbeta-font-lock-map [hilit] 
    '("Hilit-like" . gbeta-font-lock-choose-hilit-like))
  
  (define-key gbeta-font-lock-map [fruit-cake] 
    '("Fruit Cake" . gbeta-font-lock-choose-fruitcake))

  (define-key gbeta-font-lock-map [sparse] 
    '("Sparse but Fast" . gbeta-font-lock-choose-sparse)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Choose a specification
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun gbeta-font-lock-syntax-begin ()
  (re-search-backward "^\\S \\|\\`"))

(defvar gbeta-font-lock-keywords gbeta-font-lock-keywords-sparse
  "The default font lock specification being used")

(defvar gbeta-font-lock-insert-menus-p t
  "Should 'gbeta-font-lock-install' also insert menu items in the gbeta menu?")

;; arrange for font-lock mode to be initialized along with gbeta-mode
(defun gbeta-font-lock-install ()
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
        (list
         'gbeta-font-lock-keywords
         nil           ; (KEYWORDS-ONLY) yes to strings/comments
         t             ; (CASE-FOLD) keywords case-insensitive
         '((?_ . "w"))  ; (SYNTAX-ALIST) allow '_'in words
         'gbeta-font-lock-syntax-begin ; (SYNTAX-BEGIN)
         ))
  ;; insert menus
  (if gbeta-font-lock-insert-menus-p
      (gbeta-font-lock-insert-menu-entries))
  ;; ensure that font-lock is in fact used
  (turn-on-font-lock))

;; just to save people who hate menu bars..
(defun gbeta-font-lock-change-specification (spec)
  (interactive "SChoose a gbeta font-lock spec: ")
  (setq gbeta-font-lock-keywords spec)
  (font-lock-mode nil)
  (gbeta-mode)
  (font-lock-mode t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Tell 'em
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'gbeta-mode-hook 'gbeta-font-lock-install)

;; we expect to be loaded by 'require' in a mode-hook, so first execution 
;; must be manual (the hook isn't called before the next file is loaded):
(if (equal mode-name "gbeta")
    (gbeta-font-lock-install))
