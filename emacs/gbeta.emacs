;;
;; Add this to your ~/.emacs
;;
(defvar gbeta-version (getenv "GBETA_VERSION"))
(if (not gbeta-version) (setq gbeta-version "1.9.11"))
(defvar gbeta-basedir (getenv "GBETA_BASEDIR"))
(if (not gbeta-basedir) (setq gbeta-basedir (concat "~/gbeta-" gbeta-version)))
(setq load-path (append (list (concat gbeta-basedir "/emacs")) load-path))
(load-library "gud-gbeta")
(load-library "gbeta-mode")
(load-library "gbeta-font-lock")
(setq auto-mode-alist (append '(("\\.gb$" . gbeta-mode)) auto-mode-alist))

