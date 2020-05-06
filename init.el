(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; custom.el
(setq-default custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

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

;; window numbering
(use-package window-numbering
  :ensure t
  :config
  (window-numbering-mode))

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
  :ensure t)

;; company-mode
(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

;; cmake-ide
(use-package cmake-ide
  :ensure t
  :config
  (cmake-ide-setup))

;; treemacs
(use-package lsp-treemacs
  :ensure t)

;; lsp-mode
(use-package lsp-mode
  :ensure t
  :hook ((c++-mode . lsp)
         (c-mode . lsp))
  :config
  (setq lsp-keymap-prefix "s-l"))

;; irony
(use-package irony
  :ensure t
  :hook ((c++-mode . irony-mode)
         (c-mode . irony-mode)
         (irony-mode . irony-cdb-autosetup-compile-options)))

;; company-irony
(use-package company-irony
  :ensure t
  :after company
  :config
  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-irony)))

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

;; keybindings
(global-set-key (kbd "C-c 0") #'treemacs)
(global-set-key (kbd "C-c e") #'eval-buffer)

(defun run-cmake-binding ()
  (local-set-key (kbd "C-c r") #'cmake-ide-run-cmake))

(defun cmake-compile-binding ()
  (local-set-key (kbd "C-c c") #'cmake-ide-compile))

(defun lsp-find-definition-binding ()
  (local-set-key (kbd "C-c b") #'lsp-find-definition))

(defun lsp-find-references-binding ()
  (local-set-key (kbd "C-c f") #'lsp-find-references))

(add-hook 'c++-mode-hook (lambda () (run-cmake-binding)))
(add-hook 'c-mode-hook (lambda () (run-cmake-binding)))
(add-hook 'cmake-mode-hook (lambda () (run-cmake-binding)))

(add-hook 'c++-mode-hook (lambda () (cmake-compile-binding)))
(add-hook 'c-mode-hook (lambda () (cmake-compile-binding)))
(add-hook 'cmake-mode-hook (lambda () (cmake-compile-binding)))

(add-hook 'c++-mode-hook (lambda () (lsp-find-definition-binding)))
(add-hook 'c-mode-hook (lambda () (lsp-find-definition-binding)))
(add-hook 'c++-mode-hook (lambda () (lsp-find-references-binding)))
(add-hook 'c-mode-hook (lambda () (lsp-find-references-binding)))
