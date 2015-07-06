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



;; compare with Prelude
(global-set-key (kbd "<f7>") '(lambda () (interactive) (find-file "~/.emacs.d/personal/john.el")))

(global-set-key (kbd "<f8>") 'bury-buffer)
(global-set-key (kbd "<f10>") 'highlight-regexp)
;; (global-set-key (kbd "C-c i") 'magit-status)
(global-set-key (kbd "C-x ;") 'comment-region)
(global-set-key (kbd "C-x c") 'compile)

;; X: compare projectile-find-tag, prelude-goto-symbol, and tag-something
(global-set-key (kbd "M-.") 'find-tag)

;; Prelude with Tags
;; brew unlink ctags ; brew install ctags-exuberant

;; (defun jta-highlight-conflict ()
;;   (interactive)
;;   (highlight-regexp "<<<*" 'hi-yellow)
;;   (highlight-regexp ">>>*" 'hi-yellow)
;;   (highlight-regexp "===*" 'hi-yellow))

;; (defun jta-next-conflict ()
;;   (interactive)
;;   (search-forward "<<<"))
;; OSX tweaks:
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time


;; :::::::::::::::::::::::::::::::::::::::::::::::::: JohnTellsAll

(require 'compile)			;; define recompile
(defun jta-recompile ()
  (interactive)
  (save-some-buffers t)
  (recompile))

;; (defun jta-highlight-conflicts ()
;;   (interactive)
;;   (highlight-regexp "^[<>=].*" 'hi-yellow))

(define-key prelude-mode-map (kbd "C-S-<return>") 'jta-recompile)

(global-set-key (kbd "C-S-<return>") 'jta-recompile)


;;; :::::::::::::::::::::::::::::::::::::::::::::::::: PRELUDE
;; brew install ctags-exuberant
;; (package-install "flx-ido"

;; (require 'prelude-python) XXXX messes with C-right

;; split window horizontally by default
;; http://stackoverflow.com/questions/2081577/setting-emacs-split-to-horizontal
;; http://stackoverflow.com/questions/7997590/how-to-change-the-default-split-screen-direction
;; (setq split-width-threshold 1 ) ;; horizontal split
(setq split-width-threshold nil) ;; vertical split
 

;; :::::::::::::::::::::::::::::::::::::::::::::::::: PACKAGE TWEAKS


(autoload 'smerge-mode "smerge-mode" nil t)
(when t
  (defun sm-try-smerge ()
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward "^<<<<<<< " nil t)
        (smerge-mode 1))))
  (add-hook 'find-file-hooks 'sm-try-smerge t))
  

(setq python-fill-docstring-style 'django)
;; super-m m => Magit status
;; super-m l => Magit log

;; package-install ack

(global-set-key (kbd "C-x g") 'grep)    ;; TODO: use default Prelude ^xg => Magit status
;; compare with "C-c p s g" => Projectile grep
(when t
  (require 'ack)
  (global-set-key (kbd "C-x g") 'ack))

(when t
  (package-install (quote flx-ido))) ;; for IDO-Prelude

(defvar jta-projectile-mode-line
  '(:propertize
    (:eval (when (ignore-errors (projectile-project-root))
             (concat " " (projectile-project-name))))
    face font-lock-constant-face)
  "Mode line format for Projectile.")
(put 'jta-projectile-mode-line 'risky-local-variable t)


;; ;; ........................................ Compilation
(setq compilation-scroll-output t)
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

;; ........................................ Flycheck

;; (package-install (quote flycheck-color-mode-line))

(when t
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (global-flycheck-mode t)
  (require 'flycheck-color-mode-line)
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))
  (eval-after-load 'flycheck
    '(custom-set-variables
      '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))
(setq flycheck-python-pylint-executable "/Users/johnm/venv/bin/pylint")
                                         


;; ........................................ Ido
(when t
  (require 'ido)
  (setq ido-enable-flex-matching t)
  (ido-everywhere)
  (ido-mode t))

;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(when t
  (add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode)))

;
(which-function-mode)

;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: CUSTOM

;; http://emacs.stackexchange.com/a/3928
(when t
  (defvar hidden-minor-modes
    '(abbrev-mode
      auto-fill-function
      flycheck-mode
      flyspell-mode
      smooth-scroll-mode
      vc-mode
      vc-parent-buffer))

  (defun purge-minor-modes ()
    (interactive)
    (dolist (x hidden-minor-modes nil)
      (let ((trg (cdr (assoc x minor-mode-alist))))
        (when trg
          (setcar trg "")))))

  (add-hook 'after-change-major-mode-hook 'purge-minor-modes))

;; Mode Line with Diminish
(when t
  (require 'diminish)
  (eval-after-load "projectile" '(diminish 'projectile-mode "Prjl"))
  (eval-after-load "filladapt" '(diminish 'filladapt-mode))

  (setq-default mode-line-format
                '("%e" mode-line-front-space
                  mode-line-mule-info mode-line-client mode-line-modified
                  mode-line-remote mode-line-frame-identification
                  mode-line-buffer-identification " " mode-line-position
                  smartrep-mode-line-string
                  " " mode-line-misc-info mode-line-modes mode-line-end-spaces)))

;;; init.el ends here
