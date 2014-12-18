(cd "~/src/theblacktux")
;; (cd "~/src/tux_wip")
(add-to-list 'load-path "~/.emacs.d/internet")

;; (when t
;;   (setq tramp-default-method "ssh"))

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

(require 'compile)			;; define recompile
(defun jm-recompile ()
  (interactive)
  (save-some-buffers t)
  (recompile))
(global-set-key (kbd "C-S-<return>") 'jm-recompile)

;; (when t
;;   (require 'dockerfile-mode)
;;   (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(when t
  (autoload 'ssh-config-mode "ssh-config-mode" t)
  (add-to-list 'auto-mode-alist '(".ssh/config\\'"  . ssh-config-mode))
  (add-hook 'ssh-config-mode-hook 'turn-on-font-lock))

(when t
  (require 'yaml-mode)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)))

;; OSX tweaks:
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

;; later:
;; M-x package-install js2-refactor
(when t
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t))


(add-hook 'after-init-hook #'global-flycheck-mode)

(when t
  (require 'sass-mode)
  (add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode)))

(require 'ack)

;; (custom-set-variables  
;;  '(js2-basic-offset 2)  
;;  '(js2-bounce-indent-p t)  
;; )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
