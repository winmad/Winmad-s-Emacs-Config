;; @see http://cx4a.org/software/auto-complete/manual.html
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4.0")
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-clang-20140409.52")
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq ac-expand-on-auto-complete nil)
(setq ac-auto-start nil)
(setq ac-dwim nil) ; To get pop-ups with docs even if a word is uniquely completed
(ac-set-trigger-key "TAB") ; AFTER input prefix, press TAB key ASAP

;; Use C-n/C-p to select candidate ONLY when completion menu is displayed
;; Below code is copied from official manual
(setq ac-use-menu-map t)
;; Default settings
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)
;; extra modes auto-complete must support
(dolist (mode '(magit-log-edit-mode log-edit-mode org-mode text-mode haml-mode
                                                    sass-mode yaml-mode csv-mode espresso-mode haskell-mode
                                                                    html-mode web-mode sh-mode smarty-mode clojure-mode
                                                                                    lisp-mode textile-mode markdown-mode tuareg-mode
                                                                                                    js2-mode css-mode less-css-mode))
    (add-to-list 'ac-modes mode))

;; Exclude very large buffers from dabbrev
(defun sanityinc/dabbrev-friend-buffer (other-buffer)
    (< (buffer-size other-buffer) (* 1 1024 1024)))

(setq dabbrev-friend-buffer-function 'sanityinc/dabbrev-friend-buffer)

;; clang stuff
;; @see https://github.com/brianjcj/auto-complete-clang
(defun my-ac-cc-mode-setup ()
    (add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-1.4.0")
    (require 'auto-complete-clang)
      (when (and (not *cygwin*) (not *win32*))
            ; I don't do C++ stuff with cygwin+clang
            (setq ac-sources (append '(ac-source-clang) ac-sources))
                )
        (setq clang-include-dir-str
                      (cond
                                (*is-a-mac* "
/usr/llvm-gcc-4.2/bin/../lib/gcc/i686-apple-darwin11/4.2.1/include
/usr/include/c++/4.2.1
/usr/include/c++/4.2.1/backward
/usr/local/include
/Applications/Xcode.app/Contents/Developer/usr/llvm-gcc-4.2/lib/gcc/i686-apple-darwin11/4.2.1/include
/usr/include
")                                    )
                              )
          (setq ac-clang-flags
                        (mapcar (lambda (item) (concat "-I" item))
                                                (split-string clang-include-dir-str)))

            (cppcm-reload-all)
              ; fixed rinari's bug
              (remove-hook 'find-file-hook 'rinari-launch)

                (setq ac-clang-auto-save t)
                  )
(add-hook 'c-mode-hook 'my-ac-cc-mode-setup)
(add-hook 'c++-mode-hook 'my-ac-cc-mode-setup)

(ac-config-default)

(provide 'init-auto-complete)