(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

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
(require 'smartparens-config)
(smartparens-global-mode)

;; window numbering
(window-numbering-mode)

;; scroll bar
(scroll-bar-mode -1)

;; top bar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; evil mode
(require 'evil)
(evil-mode 0)

;; magit
(require 'magit)

;; diff-hl
(require 'diff-hl)
(global-diff-hl-mode)
(add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;; flycheck
(require 'flycheck)

;; company-mode
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; cmake-ide
(require 'cmake-ide)
(cmake-ide-setup)

;; treemacs
(require 'lsp-treemacs)

;; lsp-mode
(setq lsp-keymap-prefix "s-l")
(require 'lsp-mode)
(add-hook 'c++-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)

;; irony
(require 'irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; company-irony
(require 'company)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;; rainbow-delimiters
(require 'rainbow-delimiters)
(add-hook 'c-mode-hook #'rainbow-delimiters-mode)
(add-hook 'c++-mode-hook #'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)

;; clang-format
(require 'clang-format)
(global-set-key (kbd "C-M-f") #'clang-format-buffer)
(global-set-key (kbd "C-M-r") #'clang-format-region)

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
