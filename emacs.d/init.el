;;; init.el -- John's Emacs setup file
;;;

(cd "~/src/theblacktux")
(setq exec-path (append exec-path '("/Users/johnm/venv/bin/"))) ;; for Pylint et al

;; ;(add-to-list 'load-path "~/.emacs.d/internet")
;; (when t
;;   (require 'package)
;;   (package-initialize)
;;   (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t))

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(global-set-key (kbd "<f7>") '(lambda () (interactive) (find-file "~/.emacs.d/init.el")))
(global-set-key (kbd "<f8>") 'bury-buffer)
(global-set-key (kbd "<f10>") 'highlight-regexp)
(global-set-key (kbd "C-x ;") 'comment-region)
(global-set-key (kbd "C-x c") 'compile)
(global-set-key (kbd "C-x g") 'grep)

;; OSX tweaks:
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

(require 'compile)			;; define recompile
(defun jm-recompile ()
  (interactive)
  (save-some-buffers t)
  (recompile))
(global-set-key (kbd "C-S-<return>") 'jm-recompile)

;; :::::::::::::::::::::::::::::::::::::::::::::::::: PACKAGE TWEAKS

;; package-install ack
(require 'ack)

;; ;; ........................................ Compilation
;; (setq compilation-scroll-output t)
;; ;; (setq compilation-scroll-output 'first-error)

;; ;; colorize compliation buffers
;; (ignore-errors
;;   (require 'ansi-color)
;;   (defun my-colorize-compilation-buffer ()
;;     (when (eq major-mode 'compilation-mode)
;;       (ansi-color-apply-on-region compilation-filter-start (point-max))))
;;   (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))


;; (when t
;;   (require 'dockerfile-mode)
;;   (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
;;   (add-to-list 'auto-mode-alist '("\\.docker\\'" . dockerfile-mode)))


;; ;; ........................................ Flycheck
;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; (require 'flycheck-color-mode-line)
;; (eval-after-load 'flycheck
;;   '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))
;; ;; (eval-after-load 'flycheck
;; ;;   '(custom-set-variables
;; ;;    '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

;; ;; ........................................ Ido
;; (when t
;;   (require 'ido)
;;   (setq ido-enable-flex-matching t)
;;   (ido-everywhere)
;;   (ido-mode t))

;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; (when t
;;   (add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode)))

;; (when t
;;   (add-to-list 'auto-mode-alist '("\\.ngx\\'" . nginx-mode)))

(which-function-mode)

;; (when t
;;   (require 'sass-mode)
;;   (add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode)))

;; (when t
;;   (autoload 'ssh-config-mode "ssh-config-mode" t)
;;   (add-to-list 'auto-mode-alist '(".ssh/config\\'"  . ssh-config-mode))
;;   (add-hook 'ssh-config-mode-hook 'turn-on-font-lock))

;; ;; Solarized: (load-theme "tango")
;; ;; http://pawelbx.github.io/emacs-theme-gallery/

;; (when t
;;   (require 'yaml-mode)
;;   (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode) '("\\.yml.tmpl$" . yaml-mode)))


;; ;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: CUSTOM
;; ;; TODO: flycheck-error



;; (defun jta-highlight-django-template ()
;;   (interactive)
;;   (highlight-regexp "{%.+%}" 'hi-yellow) ;;tags
;;   (highlight-regexp "{{.+?}}" 'underline)) ;;variables

;; ;; later:
;; ;; M-x package-install js2-refactor

;; ;; (custom-set-variables  
;; ;;  '(js2-basic-offset 2)  
;; ;;  '(js2-bounce-indent-p t)  
;; ;; )
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(flycheck-python-pylint-executable "/Users/johnm/venv/bin/pylint")
;;  '(inhibit-startup-screen t)
;;  '(python-shell-interpreter "/Users/johnm/venv/bin/python")
;;  '(tool-bar-mode nil))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
;; (put 'narrow-to-region 'disabled nil)
;; (put 'downcase-region 'disabled nil)


;; ;;; init.el ends here

