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

;; maybe fixes problems with black cursor in daemon mode
(setq inhibit-x-resources 't)

;; backup
(custom-set-variables
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))
(make-directory "~/.emacs.d/autosaves" t)

;; performance tuning
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(setq lsp-idle-delay 0.500)

;; remove startup messages
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; set *scratch* message to empty string
(setq initial-scratch-message "")

;; fix paths
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; c defaults
(setq-default c-basic-offset 4
              tab-width 4
              tab-always-indent nil
              indent-tabs-mode nil)

;; highlight line
(global-hl-line-mode 1)

;; do not wrap lines
(set-default 'truncate-lines t)

;; smartparens
(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode))

(show-paren-mode 1)

;; paredit
(use-package paredit
  :ensure t)

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
  (setq projectile-enable-caching t)
  (setq projectile-use-git-grep t)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; helm-projectile
(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile)
  :config
  (setq treemacs-width 20))

;; scroll bar
(scroll-bar-mode -1)

;; top bar
(tool-bar-mode -1)
;;(menu-bar-mode -1)

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

;; yasnippet
(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

;; flycheck
(use-package flycheck
  :ensure t
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save new-line))
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
  :hook ((js2-mode . lsp)
         (c++-mode . lsp)
         (c-mode . lsp))
  :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  (advice-add #'lsp--auto-configure :override #'ignore))

;; lsp-ui
(use-package lsp-ui
  :ensure t
  :custom
  (lsp-ui-doc-max-height 20)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t))

;; company-mode
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :after (lsp-mode)
  :config
  (setq company-backends '(company-capf
                           company-cmake
                           company-files
                           company-keywords))
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-transformers '(company-sort-by-occurrence))
  (setq company-search-regexp-function (quote company-search-flex-regexp)))

;; rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)
         (c-mode . rainbow-delimiters-mode)
         (c++-mode . rainbow-delimiters-mode)
         (emacs-lisp-mode . rainbow-delimiters-mode)))

;; clang-format
(use-package clang-format
  :ensure t
  :config
  (global-set-key (kbd "C-M-l") #'clang-format-buffer)
  (global-set-key (kbd "C-M-r") #'clang-format-region))

;; helm-ctest
(use-package helm-ctest
  :ensure t
  :config
  (global-set-key (kbd "C-c t") #'helm-ctest))

;; atom-one-dark
(use-package atom-one-dark-theme
  :ensure t
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
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config))
  ;;(load-theme 'doom-vibrant t)
  ;;(load-theme 'atom-one-dark t))

;; doom-modeline
(use-package doom-modeline
  :ensure t
  :config
  (setq doom-modeline-icon (display-graphic-p))
  (setq doom-modeline-height 40)
  (setq doom-modeline-bar-width 3)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-indent-info t)
  (setq doom-modeline-lsp t)
  (doom-modeline-mode 1))

;; centaur-tabs
(use-package centaur-tabs
  :ensure t
  :demand
  :config
  (centaur-tabs-headline-match)
  (setq centaur-tabs-style "wave")
  (setq centaur-tabs-set-modified-marker t)
  (setq centaur-tabs-set-icons t)
  (centaur-tabs-mode t)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))

;; semantic-refactor
(use-package srefactor
  :ensure t
  :config
  (define-key c-mode-map (kbd "M-RET") #'srefactor-refactor-at-point)
  (define-key c++-mode-map (kbd "M-RET") #'srefactor-refactor-at-point))

;; tide
(use-package tide
  :ensure t)

;; js2-mode
(use-package js2-mode
  :ensure t)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;; typescript
(use-package typescript-mode
  :ensure t)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; tslint-fix
(defun tslint-fix ()
  (interactive)
  (shell-command (concat "tslint --fix " (buffer-file-name)))
  (revert-buffer t t))

;; clojure-mode
(use-package clojure-mode
  :ensure t)

;; clojure-mode-extra-font-locking
(use-package clojure-mode-extra-font-locking
  :ensure t)

;; cider
(use-package cider
  :ensure t)

;; clj-refactor
(use-package clj-refactor
  :ensure t
  :config
  (setq cljr-warn-on-eval nil)
  (cljr-add-keybindings-with-prefix "C-c C-m"))

;; idle-highlight-mode
(use-package idle-highlight-mode
  :ensure t
  :config
  (setq idle-highlight-idle-time 0.2))

;; origami
(use-package origami
  :ensure t
  :config
  (global-origami-mode)
  (global-set-key (kbd "<C-tab>") #'origami-toggle-node))

;; rust
(use-package rustic
  :ensure t
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)
  (setq lsp-rust-analyzer-server-display-inlay-hints t)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm
  (setq-local buffer-save-without-query t))

(defun lsp-find-definition-binding ()
  (local-set-key (kbd "C-c b") #'lsp-find-definition))

(defun lsp-find-references-binding ()
  (local-set-key (kbd "C-c C-r") #'lsp-treemacs-references))

;; c++ hooks
(defun my-cpp-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t)
  (electric-pair-mode t)
  (semantic-mode 1))
(add-hook 'c++-mode-hook #'my-cpp-hooks)

;; c hooks
(defun my-c-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t)
  (electric-pair-mode t)
  (semantic-mode 1))
(add-hook 'c-mode-hook #'my-c-hooks)

;; cmake hooks
(defun my-cmake-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t))
(add-hook 'cmake-mode-hook #'my-cmake-hooks)

;; emacs-lisp hooks
(defun my-emacs-lisp-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t))
(add-hook 'emacs-lisp-mode-hook #'my-emacs-lisp-hooks)

;; clojure hooks
(defun my-clojure-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t)
  (clj-refactor-mode 1)
  (yas-minor-mode 1)
  (enable-paredit-mode))
(add-hook 'clojure-mode-hook #'my-clojure-hooks)

;; lsp hooks
(defun my-lsp-hooks ()
  (lsp-find-definition-binding)
  (lsp-find-references-binding))
(add-hook 'lsp-mode-hook #'my-lsp-hooks)

;; prog-mode hooks
(defun my-prog-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t)
  (electric-pair-mode t))
(add-hook 'prog-mode-hook #'my-prog-hooks)

;; nxml hooks
(defun my-nxml-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t))
(add-hook 'nxml-mode-hook #'my-nxml-hooks)

;; Custom functions
(defun window-below-if-not-exist ()
  (interactive)
  (if (not (window-in-direction 'below))
      (progn (select-window (split-window-below))
             (shrink-window 15))
    (windmove-down)))

(defun open-eshell-below ()
  (interactive)
  (window-below-if-not-exist)
  (eshell))

(defun run-simple-program-in-eshell ()
  (interactive)
  (open-eshell-below)
  (insert "cd " custom-application-directory)
  (eshell-send-input)
  (insert custom-application-runnable)
  (eshell-send-input)
  (windmove-up))

(defun run-test-program-in-eshell ()
  (interactive)
  (open-eshell-below)
  (insert "cd " custom-application-test-directory)
  (eshell-send-input)
  (insert custom-application-test-runnable)
  (eshell-send-input)
  (windmove-up))

(defun resolve-scenario-name (line)
  (substring
   line
   (+ 10 (string-match "SCENARIO(\"" line))
   (string-match "\"" line (+ 10 (string-match "SCENARIO(" line)))))

(defun run-catch2-test-scenario ()
  (interactive)
  (let ((test-name (resolve-scenario-name (thing-at-point 'line))))
    (open-eshell-below)
    (insert "cd " custom-application-test-directory)
    (eshell-send-input)
    (insert custom-application-test-runnable " \"Scenario: " test-name "\"")
    (eshell-send-input)
    (windmove-up)))

;; global keybindings
(global-set-key (kbd "C-c k") #'run-simple-program-in-eshell)
(global-set-key (kbd "<f12>") #'run-test-program-in-eshell)
(global-set-key (kbd "C-<f12>") #'run-catch2-test-scenario)
(global-set-key (kbd "C-c 0") #'treemacs)
(global-set-key (kbd "C-c C-e") #'eval-buffer)
(global-set-key (kbd "C-c f") #'projectile-find-file)
(global-set-key (kbd "C-S-f") #'helm-projectile-grep)
(global-set-key (kbd "C-q") #'lsp-ui-doc-show)
(global-set-key (kbd "C-<f12>") #'helm-imenu)
(global-set-key (kbd "C-c r") #'cmake-ide-run-cmake)
(global-set-key (kbd "C-c c") #'cmake-ide-compile)

;; company-glsl
;; requires glsl-tools to be installed
(when (executable-find "glslangValidator")
  (load (expand-file-name "company-glsl/company-glsl.el" user-emacs-directory))
  (add-to-list 'company-backends 'company-glsl))

;; glsl hooks
(defun my-glsl-hooks ()
  (idle-highlight-mode t)
  (display-line-numbers-mode t))
(add-hook 'glsl-mode-hook #'my-glsl-hooks)

;; fix dead keys
(require 'iso-transl)

(provide 'init)
;;; init.el ends here
