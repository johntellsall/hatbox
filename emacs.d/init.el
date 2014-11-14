(when t
  (require 'ido)
  (setq ido-enable-flex-matching t
	ido-everywhere t)
  (ido-mode t))

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(global-set-key (kbd "<f7>") '(lambda () (interactive) (find-file "~/.emacs.d/init.el")))
(global-set-key (kbd "<f8>") 'bury-buffer)
(global-set-key (kbd "<f10>") 'highlight-regexp)
(global-set-key (kbd "C-x ;") 'comment-region)
(global-set-key (kbd "C-x c") 'compile)
(global-set-key (kbd "C-x g") 'grep)

(defun jm-recompile ()
  (interactive)
  (save-some-buffers t)
  (recompile))

(global-set-key (kbd "C-S-<return>") 'jm-recompile)


;; OSX tweaks:
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

;; later:
;; M-x package-install js2-refactor

;; (custom-set-variables  
;;  '(js2-basic-offset 2)  
;;  '(js2-bounce-indent-p t)  
;; )
