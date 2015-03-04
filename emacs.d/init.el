;;; init.el -- John's Emacs setup file
;;;

(cd "~/src/theblacktux")
(add-to-list 'load-path "~/.emacs.d/internet")

(when t
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t))

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

(require 'ack)

;; colorize compliation buffers
(ignore-errors
  (require 'ansi-color)
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))


(add-hook 'after-init-hook #'global-flycheck-mode)

(when t
  (require 'ido)
  (setq ido-enable-flex-matching t)
  (ido-everywhere)
  (ido-mode t))

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(when t
  (add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-nmake-mode) auto-mode-alist))

(when t
  (add-to-list 'auto-mode-alist '("\\.ngx\\'" . nginx-mode)))


(which-function-mode)



;; (when t
;;   (require 'dockerfile-mode)
;;   (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(when t
  (require 'sass-mode)
  (add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode)))

(when t
  (autoload 'ssh-config-mode "ssh-config-mode" t)
  (add-to-list 'auto-mode-alist '(".ssh/config\\'"  . ssh-config-mode))
  (add-hook 'ssh-config-mode-hook 'turn-on-font-lock))

(when t
  (require 'yaml-mode)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)))

;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: CUSTOM
;; TODO: flycheck-error



(defun jta-highlight-django-template ()
  (interactive)
  (highlight-regexp "{%.+%}" 'hi-yellow) ;;tags
  (highlight-regexp "{{.+?}}" 'underline)) ;;variables

;; later:
;; M-x package-install js2-refactor

;; (custom-set-variables  
;;  '(js2-basic-offset 2)  
;;  '(js2-bounce-indent-p t)  
;; )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-python-pylint-executable "/Users/johnm/src/venv/bin/pylint")
 '(inhibit-startup-screen t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)


;; highlight Django model references:
;; # Hi-lock: (("through" (0 (quote hi-pink) prepend)))
;; # Hi-lock: (("ManyToManyField" (0 (quote hi-yellow) prepend)))
;; # Hi-lock: (("related_name" (0 (quote hi-pink) prepend)))
;; # Hi-lock: (("ForeignKey" (0 (quote hi-yellow) prepend)))


;; XXXX
;; (defface font-lock-operator-face
;;   '((((class color)
;;       :background "darkseagreen2")))
;;   "Basic face for highlighting."
;;   :group 'basic-faces)
