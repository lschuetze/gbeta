;; Menu for gbeta-mode
;; Built using the easymenu package

(require 'easymenu)
(require 'gbeta-mode)

(require 'gbeta-font-lock)

(defun test ()
  (interactive)
  (message "Hello, World!"))

(easy-menu-define gbeta-menu gbeta-mode-map "gbeta"
  '("gbeta"
    ("gbeta mode commands"
     ["Indent line" gbeta-indent-line t]
     ["Am I within a comment?" gbeta-within-comment t]
     ["Go to beginning of current construct" gbeta-beginning-of-construct t]
     )
    ("Font lock styles"
     ["Sparse, but fast" gbeta-font-lock-choose-sparse]
     ["Fruitcake" gbeta-font-lock-choose-fruitcake]
     ["Hilit-like" gbeta-font-lock-choose-hilit-like]
     )
    ["Compile current buffer" gbeta-compile]
    ["Test" test]
    )
  )

(provide 'gbeta-menu) 