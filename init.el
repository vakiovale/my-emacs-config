(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;; (package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; custom.el
(setq-default custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; backup
(custom-set-variables
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))
(make-directory "~/.emacs.d/autosaves" t)

;; c defaults
(setq-default c-basic-offset 4
              tab-width 4
              tab-always-indent nil
              indent-tabs-mode nil)

;; smartparens
(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode))

(show-paren-mode 1)

;; window numbering
(use-package window-numbering
  :ensure t
  :config
  (window-numbering-mode))

;; projectile
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile))

;; scroll bar
(scroll-bar-mode -1)

;; top bar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; magit
(use-package magit
  :ensure t)

;; diff-hl
(use-package diff-hl
  :ensure t
  :after (magit)
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (global-diff-hl-mode))

;; flycheck
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

;; cmake-ide
(use-package cmake-ide
  :ensure t
  :config
  (cmake-ide-setup))

;; cmake-mode
(use-package cmake-mode
  :ensure t)

;; glsl
(use-package glsl-mode
  :ensure t)

;; treemacs
(use-package lsp-treemacs
  :ensure t)

;; lsp-mode
(use-package lsp-mode
  :ensure t
  :hook ((c++-mode . lsp)
         (c-mode . lsp))
  :config
  (setq lsp-keymap-prefix "s-l")
  (advice-add #'lsp--auto-configure :override #'ignore))

;; lsp-ui
(use-package lsp-ui
  :ensure t)

;; company-mode
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :after (lsp-mode)
  :config
  (setq company-backends '((company-clang
                            company-capf
                            company-cmake
                            company-files
                            company-keywords)))
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (setq company-search-regexp-function (quote company-search-flex-regexp)))


;; rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook ((c-mode . rainbow-delimiters-mode)
         (c++-mode . rainbow-delimiters-mode)
         (emacs-lisp-mode . rainbow-delimiters-mode)))

;; clang-format
(use-package clang-format
  :ensure t
  :config
  (global-set-key (kbd "C-M-f") #'clang-format-buffer)
  (global-set-key (kbd "C-M-r") #'clang-format-region))

;; helm-ctest
(use-package helm-ctest
  :ensure t
  :config
  (global-set-key (kbd "C-c t") #'helm-ctest))

;; atom-one-dark
(use-package atom-one-dark-theme
  :disabled
  :config
  (load-theme 'atom-one-dark t))

;; all-the-icons
(use-package all-the-icons
  :disabled ;; to not prompt icon install every time
  :config
  (all-the-icons-install-fonts))

;; doom-themes
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config))

;; doom-modeline
(use-package doom-modeline
  :ensure t
  :config
  (setq doom-modeline-icon (display-graphic-p))
  (doom-modeline-mode 1))

;; semantic-refactor
(use-package srefactor
  :ensure t
  :config
  (semantic-mode 1)
  (define-key c-mode-map (kbd "M-RET") #'srefactor-refactor-at-point)
  (define-key c++-mode-map (kbd "M-RET") #'srefactor-refactor-at-point))

;; typescript
(use-package typescript-mode
  :ensure t)

;; clojure-mode
(use-package clojure-mode
  :ensure t)

;; clojure-mode-extra-font-locking
(use-package clojure-mode-extra-font-locking
  :ensure t)

;; cider
(use-package cider
  :ensure t)

;; idle-highlight-mode
(use-package idle-highlight-mode
  :ensure t
  :config
  (setq idle-highlight-idle-time 0.2))

(defun run-cmake-binding ()
  (local-set-key (kbd "C-c r") #'cmake-ide-run-cmake))

(defun cmake-compile-binding ()
  (local-set-key (kbd "C-c c") #'cmake-ide-compile))

(defun lsp-find-definition-binding ()
  (local-set-key (kbd "C-c b") #'lsp-find-definition))

(defun lsp-find-references-binding ()
  (local-set-key (kbd "C-c f") #'lsp-find-references))

;; c++ hooks
(defun my-cpp-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t)
  (electric-pair-mode t)
  (run-cmake-binding)
  (cmake-compile-binding))
(add-hook 'c++-mode-hook #'my-cpp-hooks)

;; c hooks
(defun my-c-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t)
  (electric-pair-mode t)
  (run-cmake-binding)
  (cmake-compile-binding))
(add-hook 'c-mode-hook #'my-c-hooks)

;; cmake hooks
(defun my-cmake-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t)
  (run-cmake-binding)
  (cmake-compile-binding))
(add-hook 'cmake-mode-hook #'my-cmake-hooks)

;; emacs-lisp hooks
(defun my-emacs-lisp-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t))
(add-hook 'emacs-lisp-mode-hook #'my-emacs-lisp-hooks)

;; clojure hooks
(defun my-clojure-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t))
(add-hook 'clojure-mode-hook #'my-clojure-hooks)

;; lsp hooks
(defun my-lsp-hooks ()
  (lsp-find-definition-binding)
  (lsp-find-references-binding))
(add-hook 'lsp-mode-hook #'my-lsp-hooks)

;; Custom functions
(defun run-simple-program-in-eshell ()
  (interactive)
  (eshell)
  (insert "cd " custom-application-directory)
  (eshell-send-input)
  (insert custom-application-runnable)
  (eshell-send-input))

;; global keybindings
(global-set-key (kbd "C-c k") #'run-simple-program-in-eshell)
(global-set-key (kbd "C-c 0") #'treemacs)
(global-set-key (kbd "C-c C-e") #'eval-buffer)
(global-set-key (kbd "C-c e") #'projectile-find-file)

;; company-glsl
;; requires glsl-tools to be installed
(when (executable-find "glslangValidator")
  (load (expand-file-name "company-glsl/company-glsl.el" user-emacs-directory))
  (add-to-list 'company-backends 'company-glsl))

;; glsl hooks
(defun my-glsl-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t)
  (run-cmake-binding)
  (cmake-compile-binding))
(add-hook 'glsl-mode-hook #'my-glsl-hooks)
