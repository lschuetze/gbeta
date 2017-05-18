;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;         Using emacs for GBETA single-stepping feedback         ;;;
;;;                  no restrictions, no warranty                  ;;;
;;;                                                           /EE  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'gud)

;; ======================================================================
;;      Taken from 'gud.el' in the standard GNU emacs distribution:
;; ======================================================================
;;
;; All debugger-specific information is collected here.
;; Here's how it works, in case you ever need to add a debugger to the mode.
;;
;; Each entry must define the following at startup:
;;
;;<name>
;; comint-prompt-regexp
;; gud-<name>-massage-args
;; gud-<name>-marker-filter
;; gud-<name>-find-file
;;
;; The job of the massage-args method is to modify the given list of
;; debugger arguments before running the debugger.
;;
;; The job of the marker-filter method is to detect file/line markers in
;; strings and set the global gud-last-frame to indicate what display
;; action (if any) should be triggered by the marker.  Note that only
;; whatever the method *returns* is displayed in the buffer; thus, you
;; can filter the debugger's output, interpreting some and passing on
;; the rest.
;;
;; The job of the find-file method is to visit and return the buffer indicated
;; by the car of gud-tag-frame.  This may be a file name, a tag name, or
;; something else.  It would be good if it also copied the Gud menubar entry.
;;
;; ======================================================================

;; look for the gbeta executable

;;(setq gbeta-basedir (getenv "GBETA_BASEDIR")) -- should be set in .emacs
(setq gbeta-binary (concat gbeta-basedir "/bin/gbeta"))

(setq gud-gbeta-marker-regexp
  "\032\032\\([a-z]:[^:]*\\|[^:]*\\)::\\([0-9]*\\):\\([0-9]*\\):.*\n")

(defun gbeta-getmatch (number offset)
  (interactive)
  (if (match-beginning number)
      (buffer-substring 
       (+ (match-beginning number) offset) 
       (match-end number))
    nil))

(defun gbeta-true-file-of-buffers (filename buffers)
  (if buffers
      (let ((buffer-filename (buffer-file-name (car buffers))))
        (if buffer-filename
            (if (string-match filename buffer-filename)
                buffer-filename
              (gbeta-true-file-of-buffers filename (cdr buffers)))
          ;; no file nmae for this buffer: *scratch* or similar
          (gbeta-true-file-of-buffers filename (cdr buffers))))
    filename))

(defun gbeta-true-file-of (filename)
  (interactive)
  (if (eq filename "")
      filename
    (gbeta-true-file-of-buffers filename (buffer-list))))

(defun gbeta-display-source-at-point ()
  (interactive)
  (progn
    (while (and (> (point) 1) (looking-at "[^`]")) 
      (goto-char (- (point) 1)))
    (if (or (looking-at "`\\([^ \t:]+\\):\\([0-9]+\\)\\(-[0-9]+\\)?")
	    (looking-at "`\\(\\)\\([0-9]+\\)\\(-[0-9]+\\)?"))
	(progn
	  (let ((spec (gbeta-getmatch 0 0)) 
		(filename (or (gbeta-getmatch 1 0) ""))
		(frompos (string-to-number (gbeta-getmatch 2 0)))
		(topos (string-to-number (gbeta-getmatch 3 1))))

	  ; using gbeta we can just do this:
	  ;   (gud-call (concat "display " spec) arg)
	  ; but we want to be able to look up source code things 
          ; even if the gbeta subprocess is dead:
	    (gud-display-line 
             (gbeta-true-file-of filename) 
             (cons frompos topos))))
      (message (concat "No source code position spec here! "
		       "(\"`[<group>:]<charpos>[-<charpos>]\" expected)")))))

(defun gbeta-display-source (arg)
  (interactive "e")
  (mouse-set-point arg)
  (gbeta-display-source-at-point))

;;;###autoload
(defun gbeta (command-line)
  "Run gbeta on program FILE in buffer *gud-FILE*.
The directory containing FILE becomes the initial working directory
and source-file directory for your debugger."
  (interactive
   (list (read-from-minibuffer 
	  "Run gbeta (like this): "
	  (let ((fname (buffer-name (current-buffer))))
	    (if (string-match "\*gud-.*\\.\\(bet\\|gb\\)\*" fname)
		(concat gbeta-binary " " (substring fname 5 -1))
	      (if (string-match ".*\\.\\(bet\\|gb\\)$" fname)
		  (concat gbeta-binary " " fname)
		(if (consp gud-gbeta-history)
		    (car gud-gbeta-history)
		  (concat gbeta-binary " ")))))
	  nil ; local map is default, i.e., minibuffer-local-map 
	  nil ; the 'READ' argument (not used)
	  '(gud-gbeta-history . 1) ; default value as (hist-list . position)
	  )))
  
  (gud-common-init command-line 'gud-gbeta-massage-args
                   'gud-gbeta-marker-filter 'gud-gbeta-find-file)

  (set (make-local-variable 'gud-minor-mode) 'gbeta)

  (gud-def gud-gbreak    "break %f:%l" "\C-b" "set Breakpoint.")
  (gud-def gud-abreak    "abreak %f:%l" "\C-a" "set breakpoint After.")
  (gud-def gud-tbreak    "tbreak %f:%l" "\C-t" "set Temporary breakpoint.")
  (gud-def gud-tabreak   "tabreak %f:%l" "\C-m" "set teMp. breakpoint after.")
  (gud-def gud-unbreak   "unbreak %f:%l" "\C-d" "Delete breakpoint.")
  (gud-def gud-skip      "skip %f:%l" "\C-i" "skIp around point.")
  (gud-def gud-unskip    "unskip %f:%l" "\C-p" "unskiP around point.")
  (gud-def gud-step      "step" "\C-s" "take one Step (into).")
  (gud-def gud-next      "next" "\C-n" "take the Next step (over).")
  (gud-def gud-finish    "finish" "\C-f" "Finish current construct.")
  (gud-def gud-go        "go" "\C-g" "Go (continue execution).")
  (gud-def gud-kill      "kill all" "\C-k" "Kill all threads.")
  (gud-def gud-gprint    "print %e" "p" "Print expression.")
  (gud-def gud-decl      "declaration %f:%l" "d" "show decLaration.")
  (gud-def gud-markeval  "markeval %f" "m" "mark evaluation Mode.")
  (gud-def gud-type      "type %f:%l" "t" "show Type.")
  (gud-def gud-substance "substance %f:%l" "s" "show Substance.")
  (gud-def gud-entertype "entertype %f:%l" "e" "show Enter-type.")
  (gud-def gud-exittype  "exittype %f:%l" "x" "show eXit-type.")
  (gud-def gud-bytecode  "bytecode %f:%l" "b" "print Bytecode at point.")

  ;; the standard GUD menu expects certain of these functions to have
  ;; certain names, so we create a few aliases for them
  (gud-def gud-cont      "go" "\C-c" "Continue.")
  (gud-def gud-remove    "unbreak" "\C-r" "Delete breakpoint.")
  (gud-def gud-break     "break" " " "set Breakpoint.")
  (gud-def gud-refresh   "display" "\C-l" "Show the current imperative.")
  (defun gud-stepi () (interactive)
    (message "Step instruction is not supported."))
  (defun gud-print () (interactive)
    (message "To print an expression, please use the command 'print ...'"))

  ;; the order is reversed for menu entries: they are added to the front
  (local-set-key [menu-bar debug bytecode]  '("Bytecode" . gud-bytecode))
  (local-set-key [menu-bar debug exittype]  '("Exit-type" . gud-exittype))
  (local-set-key [menu-bar debug entertype] '("Enter-type" . gud-entertype))
  (local-set-key [menu-bar debug substance] '("Substance" . gud-substance))
  (local-set-key [menu-bar debug type]      '("Type" . gud-type))
  (local-set-key [menu-bar debug decl]      '("Declaration" . gud-decl))
  (local-set-key [menu-bar debug markeval]  '("Mode of eval." . gud-markeval))
  ;(local-set-key [menu-bar debug gprint]   '("Print" . gud-gprint))
  ;(local-set-key [menu-bar debug kill]     '("Restart" . gud-kill))
  ;(local-set-key [menu-bar debug go]       '("Go (continue)" . gud-go))
  ;(local-set-key [menu-bar debug finish]   '("Finish construct" . gud-finish))
  ;(local-set-key [menu-bar debug next]     '("Next" . gud-next))
  ;(local-set-key [menu-bar debug step]     '("Step" . gud-step))
  (local-set-key [menu-bar debug unskip]    '("Unskip" . gud-unskip))
  (local-set-key [menu-bar debug skip]      '("Skip" . gud-skip))
  (local-set-key [menu-bar debug unbreak]   '("Remove Breakpt." . gud-unbreak))
  (local-set-key [menu-bar debug tabreak]   '("Tmp. Brk. After" . gud-tabreak))
  (local-set-key [menu-bar debug tbreak]    '("Temp. Breakpoint" . gud-tbreak))
  (local-set-key [menu-bar debug abreak]    '("Breakpoint After" . gud-abreak))
  (local-set-key [menu-bar debug break]     '("Breakpoint" . gud-gbreak))

  (local-set-key [double-down-mouse-1] 'gbeta-display-source)
  (local-set-key "\C-x\C-as" 'gbeta-display-source-at-point)

  (setq comint-prompt-regexp "^\\(executing\\|analyzing\\|terminated\\)> ")
  (setq paragraph-start comint-prompt-regexp)
  (run-hooks 'gbeta-mode-hook))

;;; History of argument lists passed to gbeta.
(defvar gud-gbeta-history nil)

(defun gud-gbeta-massage-args (file args)
 (interactive)
 (cons "-picn" args))

(defun gud-gbeta-marker-filter (string)
  (setq gud-marker-acc (concat gud-marker-acc string))
  (let ((output ""))

    ;; Process all the complete markers in this chunk.
    (while (string-match gud-gbeta-marker-regexp gud-marker-acc)
      (setq
       
       ;; Extract the frame position from the marker.
       gud-last-frame
       (cons (substring gud-marker-acc (match-beginning 1) (match-end 1))
             (cons (string-to-number (substring gud-marker-acc
						(match-beginning 2)
						(match-end 2)))
		   (string-to-number (substring gud-marker-acc
						(match-beginning 3)
						(match-end 3)))))

       ;; Append any text before the marker to the output we're going
       ;; to return - we don't include the marker in this text.
       output (concat output
                      (substring gud-marker-acc 0 (match-beginning 0)))

       ;; Set the accumulator to the remaining text.
       gud-marker-acc (substring gud-marker-acc (match-end 0)))
      
      ;; process gud-gbeta-eval-mark.. requests, rather than immediately
      ;; searching for the next gud-gbeta-marker-regexp and overwriting
      (let* ((evalmark (gud-gbeta-evalmark (car gud-last-frame)))
	     (filename (gud-gbeta-evalmark-strip (car gud-last-frame)))
	     (buffer (gud-find-file filename))
	     (range-from (car (cdr gud-last-frame)))
	     (range-to (cdr (cdr gud-last-frame))))
	(if evalmark
	    (save-excursion
	      (set-buffer buffer)
	      (save-restriction
		(widen)
		(cond
		 ((eq evalmark 'eval-mode)
		  (gud-gbeta-eval-mark-as-byval range-from range-to))
		 ((eq evalmark 'ref-mode)
		  (gud-gbeta-eval-mark-as-byref range-from range-to))
		 ((eq evalmark 'ptn-mode)
		  (gud-gbeta-eval-mark-as-byptn range-from range-to))
		 ((eq evalmark 'pref-mode)
		  (message "encountered pref-mode")
		  (gud-gbeta-eval-mark-as-bypref range-from range-to))
		 ((eq evalmark 'unknown-mode)
		  (gud-gbeta-eval-mark-as-unknown range-from range-to))
		 ((eq evalmark 'clear-mode)
		  (gud-gbeta-unmark-evaluation-mode))))))))

    ;; Does the remaining text look like it might end with the
    ;; beginning of another marker?  If it does, then keep it in
    ;; gud-marker-acc until we receive the rest of it.  Since we
    ;; know the full marker regexp above failed, it's pretty simple to
    ;; test for marker starts.
    (if (string-match "\032.*\\'" gud-marker-acc)
        (progn
          ;; Everything before the potential marker start can be output.
          (setq output (concat output (substring gud-marker-acc
                                                 0 (match-beginning 0))))

          ;; Everything after, we save, to combine with later input.
          (setq gud-marker-acc
                (substring gud-marker-acc (match-beginning 0))))

      (setq output (concat output gud-marker-acc)
            gud-marker-acc ""))

    output))

(defun gud-gbeta-find-decl (arg)
  (interactive "e")
  (mouse-set-point arg)
  (gud-decl arg)
  ;(pop-to-buffer gud-comint-buffer)
)

(defun gud-gbeta-unmark-evaluation-mode ()
  (interactive)
  (remove-overlays nil nil 'category 'gbeta-evaluation-mode))

(defun gud-gbeta-mark-evaluation-mode ()
  (interactive)
  (gud-gbeta-unmark-evaluation-mode)
  (gud-markeval (buffer-name)))

(defun gud-gbeta-eval-mark (start end face)
  (let ((ovl (make-overlay start (+ 1 end))))
    (overlay-put ovl 'category 'gbeta-evaluation-mode)
    (overlay-put ovl 'mouse-face face)))

(defun gud-gbeta-eval-mark-as-byval (start end)
  (gud-gbeta-eval-mark start end '(background-color . "red1")))
(defun gud-gbeta-eval-mark-as-byref (start end)
  (gud-gbeta-eval-mark start end '(background-color . "sky blue")))
(defun gud-gbeta-eval-mark-as-byptn (start end)
  (gud-gbeta-eval-mark start end '(background-color . "yellow1")))
(defun gud-gbeta-eval-mark-as-bypref (start end)
  (gud-gbeta-eval-mark start end '(background-color . "green yellow")))
(defun gud-gbeta-eval-mark-as-unknown (start end)
  (gud-gbeta-eval-mark start end '(background-color . "chocolate3")))

(defun gud-gbeta-find-file (f)
  (save-excursion
    (let ((buf (find-file-noselect f)))
      (set-buffer buf)
      ;; This seems to be obsolete (it does not produce a menu):
      ;;   (if (functionp 'gud-make-debug-menu)
      ;;     (funcall (symbol-function 'gud-make-debug-menu)))
      ;; So we do this:
      (define-key (current-local-map) [menu-bar debug]
        (cons "gbeta" (make-sparse-keymap "gbeta")))
      ;; Now define the entries:
      (local-set-key [menu-bar debug bytecode]
		     '("Bytecode" . gud-bytecode))
      (local-set-key [menu-bar debug exittype]
		     '("Show Exit-type" . gud-exittype))
      (local-set-key [menu-bar debug entertype]
		     '("Show Enter-type" . gud-entertype))
      (local-set-key [menu-bar debug substance]
		     '("Show Substance" . gud-substance))
      (local-set-key [menu-bar debug type]
		     '("Show Type" . gud-type))
      (local-set-key [menu-bar debug decl]
		     '("Show Declaration" . gud-decl))
      (local-set-key [menu-bar debug markeval]
		     '("Mark Evaluation Mode" . gud-markeval))
      ;(local-set-key [menu-bar debug print]
      ;              '("Evaluate/print Expression" . gud-print))
      ;(local-set-key [menu-bar debug kill]
      ;	             '("Restart" . gud-kill))
      ;(local-set-key [menu-bar debug go]
      ;	             '("Go (continue)" . gud-go))
      ;(local-set-key [menu-bar debug finish]
      ;	             '("Finish construct" . gud-finish))
      ;(local-set-key [menu-bar debug next]
      ;     	     '("Next" . gud-next))
      ;(local-set-key [menu-bar debug step]
      ;	             '("Step" . gud-step))
      (local-set-key [menu-bar debug unskip]
		     '("Unskip" . gud-unskip))
      (local-set-key [menu-bar debug skip]
		     '("Skip" . gud-skip))
      (local-set-key [menu-bar debug unbreak]
		     '("Delete Breakpoint" . gud-unbreak))
      (local-set-key [menu-bar debug tabreak]
		     '("Temporary Breakpoint After" . gud-tabreak))
      (local-set-key [menu-bar debug tbreak]
		     '("Temporary Breakpoint" . gud-tbreak))
      (local-set-key [menu-bar debug abreak]
		     '("Breakpoint After" . gud-abreak))
      (local-set-key [menu-bar debug break]
		     '("Breakpoint" . gud-gbreak))
      (local-set-key [C-down-mouse-1] 'gud-gbeta-find-decl)
      buf)))

(defun gud-gbeta-evalmark (filename)
  (cond ((= 0 (length filename))
	 nil)
	((string-match "^@" filename)
	 'eval-mode)
	((string-match "^^" filename)
	 'ref-mode)
	((string-match "^#" filename)
	 'ptn-mode)
	((string-match "^\\$" filename)
	 'pref-mode)
	((string-match "^_" filename)
	 'unknown-mode)
	((string-match "^-" filename)
	 'clear-mode)))

(defun gud-gbeta-evalmark-strip (filename)
  (cond ((= 0 (length filename))
	 filename)
	((string-match "^[@^#$_-]" filename)
	 (substring filename 1))
	(t
	filename)))

;; we want a goto-char version of display-line: 'line' _is_ really char-pos
(defun gud-display-line (true-file range)
  (if (equal true-file "")
      (progn
	(setq overlay-arrow-position nil)
	(if gbeta-secondary-overlay
	    (delete-overlay gbeta-secondary-overlay)))
    (let* ((last-nonmenu-event t)  ; Prevent use of dialog box for questions.
	   (range-from (car range))
	   (range-to (cdr range))
	   (evalmark (gud-gbeta-evalmark true-file))
	   (buffer (gud-find-file (gud-gbeta-evalmark-strip true-file)))
	   (window (display-buffer buffer))
	   (pos))
;;;    (if (equal buffer (current-buffer))
;;;     nil
;;;      (setq buffer-read-only nil))
      (save-excursion
;;;      (setq buffer-read-only t)
	(set-buffer buffer)
	(save-restriction
	  (widen)
	  (cond (evalmark (setq pos (point)))
		(t
		 ;; not evalmark, i.e., just show the current position
		 (if (and (= 0 range-from) (= 0 range-to))
		     ;; remove markers
		     (progn
		       ;; delete secondary selection
		       (if gbeta-secondary-overlay
			   (delete-overlay gbeta-secondary-overlay))
		       (setq pos 0)
		       (setq overlay-arrow-string ""))
		   ;; else: set up selection to show the exact statement
		   (gbeta-set-secondary range-from (+ 1 range-to))
		   ;; add the conventional arrow at the beginning of the line
		   (goto-char range-from)
		   (beginning-of-line 1)
		   (setq pos (point))
		   (setq overlay-arrow-string "=>")
		   (or overlay-arrow-position
		       (setq overlay-arrow-position (make-marker)))
		   (set-marker overlay-arrow-position (point) 
			       (current-buffer))))))
	(cond ((or (< pos (point-min)) (> pos (point-max)))
	       (widen)
	       (goto-char pos))))
      (if overlay-arrow-position
	  (set-window-point window overlay-arrow-position)))))

;; we also need to adjust gud-format-command
;; to give us char-pos in stead of line-number
(defun gud-format-command (str arg)
  (let ((insource (not (eq (current-buffer) gud-comint-buffer)))
        (frame (or gud-last-frame gud-last-last-frame))
        result)
    (while (and str (string-match "\\([^%]*\\)%\\([adeflp]\\)" str))
      (let ((key (string-to-char (substring str (match-beginning 2))))
            subst)
        (cond
         ((eq key ?f)
          (setq subst (file-name-nondirectory (if insource
                                                  (buffer-file-name)
                                                (car frame)))))
         ((eq key ?F)
          (setq subst (file-name-sans-extension
                       (file-name-nondirectory (if insource
                                                   (buffer-file-name)
                                                 (car frame))))))
         ((eq key ?d)
          (setq subst (file-name-directory (if insource
                                               (buffer-file-name)
                                             (car frame)))))
         ((eq key ?l)
          (setq subst (if insource
                            (save-restriction
                              (widen)
                              (int-to-string (point)))
                        (cdr frame))))
         ((eq key ?e)
          (setq subst (gud-find-c-expr)))
         ((eq key ?a)
          (setq subst (gud-read-address)))
         ((eq key ?p)
          (setq subst (if arg (int-to-string arg)))))
        (setq result (concat result (match-string 1 str) subst)))
      (setq str (substring str (match-end 2))))
    ;; There might be text left in STR when the loop ends.
    (concat result str)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Adjusted from mouse.el  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; An overlay which records the current secondary selection
;; or else is deleted when there is no secondary selection.
;; May be nil.
(defvar gbeta-secondary-overlay nil)

;; A marker which records the specified first end for a secondary selection.
;; May be nil.
(defvar gbeta-secondary-start nil)

(defun gbeta-set-secondary (start end)
  "Set the gbeta secondary selection to the given range from START to END"
  (interactive)
  (save-excursion
    (if gbeta-secondary-overlay
	(delete-overlay gbeta-secondary-overlay))
    (setq gbeta-secondary-overlay (make-overlay start end))
    (overlay-put gbeta-secondary-overlay 'face 'secondary-selection)))
