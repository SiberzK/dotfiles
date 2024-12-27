;;;; PACKAGE.EL ;;;;

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(unless package--initialized (package-initialize))

;;;; USE-PACKAGE ;;;;

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;;;; SLY ;;;;

(add-to-list 'load-path "~/git/sly")
(require 'sly-autoloads)

(with-eval-after-load 'sly
  (add-to-list 'sly-lisp-implementations
               '(sbcl ("sbcl"))))

;;;; CODE COMPLETION ;;;;

(use-package company
  :ensure t
  :config
  (global-company-mode)
  (setq company-require-match nil))

(use-package company-quickhelp
  :ensure t
  :after company
  :config
  (company-quickhelp-mode))

;;;; EMACS COMPLETION ;;;;

(use-package ivy
  :ensure t
  :diminish
  :bind (("C-s" . swiper)            ;; Use swiper for incremental search
         ("M-x" . counsel-M-x)      ;; Enhanced M-x
         ("C-x C-f" . counsel-find-file) ;; Enhanced find-file
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done))    ;; Use TAB for completion
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)  ;; Show recent files in completion
  (setq ivy-count-format "(%d/%d) ") ;; Display counts
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t      . ivy--regex-fuzzy))))

(use-package counsel
  :ensure t
  :after ivy
  :config
  (counsel-mode 1)) ;; Enable counsel-enhanced commands

(use-package counsel-projectile
  :ensure t
  :after (counsel projectile)
  :config
  (counsel-projectile-mode))

;;;; RIPGREP ;;;;

(use-package rg
  :init
  (rg-enable-default-bindings))

;;;; GIT ;;;;

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;;;; RUST ;;;;

(setenv "PATH" (concat (getenv "PATH") ":" (getenv "HOME") "/.cargo/bin"))
(setq exec-path (append exec-path '("~/.cargo/bin")))

(use-package rustic
  :ensure t
  :config
  (setq rustic-format-on-save t)
  :custom
  (rustic-cargo-use-last-stored-arguments t))

(use-package lsp-mode
  :ensure t
  :commands lsp)

;;;; CUSTOM ;;;;

;; Upcase/downcase region
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
;; Lisp mode in .cl files
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))
;; Auto-revert buffers
(global-auto-revert-mode t)
;; Default browser is Emacs built-in browser
(setq browse-url-browser-function 'eww-browse-url)
;; Delimiter matching
(electric-pair-mode 1)
;; Find file in git project
(global-set-key (kbd "C-c p") 'project-find-file)
;; Typing over selection re-writes it
(delete-selection-mode)
;; Indentation and trailing whitespace
(setq-default indent-tabs-mode nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; Disable easy suspension (use M-x suspend-emacs)
(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "C-M-z") nil)
;; Save history across sessions
(savehist-mode 1)

;;;; APPEARANCE ;;;;

(setq inhibit-startup-screen t)
(show-paren-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-frame-maximized)

(setq custom-file "/tmp/emacs-custom-file-that-i-despise.el")

(use-package atom-one-dark-theme
  :ensure t
  :config
  (load-theme 'atom-one-dark t))

(set-frame-font "Terminus-16" nil t)

;; Pretty lambda
(add-hook 'emacs-lisp-mode-hook 'prettify-symbols-mode)
(add-hook 'lisp-mode-hook 'prettify-symbols-mode)
(add-hook 'sly-mode-hook 'prettify-symbols-mode)
