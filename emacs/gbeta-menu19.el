;; Menu for gbeta-mode in emacs 19

;; This code is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY.  No author or distributor
;; accepts responsibility to anyone for the consequences of using it
;; or for whether it serves any particular purpose or works at all,
;; unless he says so in writing.  Refer to the GNU Emacs General Public
;; License for full details.

;; Everyone is granted permission to copy, modify and redistribute
;; this code, but only under the conditions described in the
;; GNU Emacs General Public License.   A copy of this license is
;; supposed to have been given to you along with GNU Emacs so you
;; can know your rights and responsibilities.  It should be in a
;; file named COPYING.  Among other things, the copyright notice
;; and this notice must be preserved on all copies.

(defun gbeta-hilit-off ()
  "Turn of highlight"
  (interactive)
  (require 'gbeta-hilit19)
  (hilit-unhighlight-region (point-min) (point-max))
  (setq hilit-auto-rehighlight nil)
  (setq hilit-auto-highlight nil))

(defun gbeta-hilit-on ()
  "Turn on highlight"
  (interactive)
  (require 'gbeta-hilit19)
  (hilit-highlight-region (point-min) (point-max))
  (setq hilit-auto-rehighlight t)
  (setq hilit-auto-highlight t))

;;; Insert new gbeta code
(defun gbeta-new-program ()
  (interactive)
  (goto-char (point-min))
  ;(insert "ORIGIN '~gbeta/basiclib/gbetaenv';\n")
  (insert "--PROGRAM: descriptor--\n")
  (insert "{ \n")
  (insert "# \n")
  (insert "}\n")
  (previous-line 2)
  (end-of-line)
  )

(defun gbeta-new-library ()
  (interactive)
  (goto-char (point-min))
;  (insert "ORIGIN '~gbeta/basiclib/gbetaenv';\n")
  (insert "--LIB: attributes--\n")
  )

(cond (window-system
       (require 'gbeta-mode)
       
       (define-key gbeta-mode-map [menu-bar] (make-sparse-keymap))
       
       (define-key gbeta-mode-map [menu-bar gbeta]
	 (cons "gbeta" (make-sparse-keymap "gbeta")))

;;        (define-key gbeta-mode-map [menu-bar gbeta gbeta-hilit-on]
;; 	 '("Enable Hilit" . gbeta-hilit-on))
;;        (define-key gbeta-mode-map [menu-bar gbeta gbeta-hilit-off]
;; 	 '("Disable Hilit" . gbeta-hilit-off))       

       (define-key gbeta-mode-map [menu-bar gbeta gbeta-beginning-of-construct]
	 '("Beginning of Construct" . gbeta-beginning-of-construct))

       (define-key gbeta-mode-map [menu-bar gbeta gbeta-close-pattern]
	 '("Close Construct" . gbeta-close-pattern))
       (define-key gbeta-mode-map [menu-bar gbeta gbeta-open-pattern]
	 '("Open Pattern" . gbeta-open-pattern))

       (define-key gbeta-mode-map [menu-bar gbeta gbeta-tab]
	 '("Indent Line" . gbeta-tab))
       (define-key gbeta-mode-map [menu-bar gbeta indent-buffer]
	 '("Indent Buffer" . indent-buffer))

;;        (define-key gbeta-mode-map [menu-bar gbeta gbeta-remove-comment]
;; 	 '("Remove Comment" . gbeta-remove-comment))
;;        (define-key gbeta-mode-map [menu-bar gbeta gbeta-convert-region-to-comment]
;; 	 '("Comment Out Region" . gbeta-convert-region-to-comment))
;;        (define-key gbeta-mode-map [menu-bar gbeta gbeta-comment-justify]
;; 	 '("Justify Comment" . gbeta-comment-justify))
;;        (define-key gbeta-mode-map [menu-bar gbeta gbeta-prettyprint]
;; 	 '("Prettyprint current buffer" . gbeta-prettyprint))

;;        (define-key gbeta-mode-map [menu-bar gbeta gbeta-execute]
;; 	 '("Execute current buffer" . gbeta-execute))
       (define-key gbeta-mode-map [menu-bar gbeta gbeta-check]
	 '("Check current buffer" . gbeta-check))
       (define-key gbeta-mode-map [menu-bar gbeta gbeta-compile]
	 '("Compile current buffer" . gbeta-compile))

       (define-key gbeta-mode-map [menu-bar gbeta gbeta-new-library]
	 '("Library skeleton" . gbeta-new-library))
       (define-key gbeta-mode-map [menu-bar gbeta gbeta-new-program]
	 '("Program skeleton" . gbeta-new-program))


       ))

(provide 'gbeta-menu19)