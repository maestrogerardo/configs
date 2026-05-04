(load "/home/gad/dvl/src/github/configs/dot_emacs.d/lisp/gad-pre-init.el")
(load "/home/gad/dvl/src/github/configs/dot_emacs.d/lisp/gad-package.el")

;; custom file for "M-x customize"
(setq custom-file "~/.emacs.d/lisp/custom.el")
(load custom-file 'noerror 'nomessage)

;; --- Core UI settings ---
(set-background-color "#f0f0f0")
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq inhibit-startup-screen t
      column-number-mode t
      compilation-scroll-output t
      backup-directory-alist '(("" . "~/.emacs.d/backup")))
(setq-default fill-column 72)

(menu-bar-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(xterm-mouse-mode 1)
(winner-mode 1)
(when (>= emacs-major-version 28) (context-menu-mode 1))
(when (>= emacs-major-version 29) (pixel-scroll-precision-mode 1))
(when (fboundp 'windmove-default-keybindings) (windmove-default-keybindings))

;; e.g. switch cpp <-> hpp
(global-set-key (kbd "C-<tab>") 'ff-find-other-file)
(global-set-key (kbd "C-4") 'gad_recompile)

;; --- User functions ---

(defun gad_activateCodingStuff ()
  (setq-default indent-tabs-mode t
                tab-width 4)
  (defvaralias 'c-basic-offset 'tab-width)
  (display-line-numbers-mode 1)
  (setq truncate-lines t)
  (advice-add 'eglot-rename :after (lambda (&rest _) (save-some-buffers t)))
  (rainbow-mode 1)
  (ignore-errors (rainbow-delimiters-mode)))

(defun gad_c-and-cpp-mode-hook ()
  (eglot-ensure)
  (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
  (copilot-mode 1))

(defun gad_recompile ()
  "Interrupt current compilation and recompile."
  (interactive)
  (ignore-errors (kill-compilation))
  (recompile))

(defun gad_magit-commit-add-log-insert (buffer file defun)
  (with-current-buffer buffer
    (magit-commit-add-log-insert buffer file defun)
    (if defun
        (cond ((re-search-backward (format "* %s (%s): " file defun) nil t)
               (replace-match (format "%s (%s): " file defun))))
      (cond ((re-search-backward (format "* %s: " file) nil t)
             (replace-match (format "%s: " file)))))))

(defun gad-gb ()
  "Set up my preferred initial window layout for gb dev."
  (interactive)
  (delete-other-windows)
  (let ((main-dir "/home/gad/dvl/src/lundgren/gb/"))
    (find-file main-dir)
    (split-window-right)
    (magit-status)
    (split-window-below)
    (other-window 1)
    (vterm)
    (treemacs)
    (find-file "src/Main.cpp"))
  (let ((default-directory "/home/gad/dvl/src/lundgren/gb/"))
    (compile "make -k -j$(nproc)")))

;; --- Global hooks not tied to a specific package ---

(add-hook 'prog-mode-hook #'gad_activateCodingStuff)
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

;; --- Packages ---

(use-package which-key
  :config (which-key-mode 1))

(use-package vertico
  :config (vertico-mode 1))

(use-package marginalia
  :config (marginalia-mode 1))

(use-package orderless
  :custom (completion-styles '(orderless)))

(use-package diff-hl
  :config (global-diff-hl-mode 1))

(use-package company
  :config (global-company-mode 1))

(use-package company-box
  :after company
  :if (display-graphic-p)
  :hook (company-mode . company-box-mode)
  :custom (company-box-frame-top-margin 20))

(use-package tree-sitter
  :config
  (global-tree-sitter-mode 1)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter)

(use-package vterm
  :custom
  (vterm-max-scrollback 100000)
  (vterm-kill-buffer-on-exit t))

(use-package flycheck
  :hook ((sh-mode
          autoconf-mode
          makefile-automake-mode
          makefile-mode
          makefile-gmake-mode) . flycheck-mode))

(use-package bash-completion
  ;; shell-dynamic-complete-functions ends in -functions so -hook is not appended
  :hook (shell-dynamic-complete-functions . bash-completion-dynamic-complete))

(use-package go-mode
  :custom (gofmt-command "goimports")
  :hook (go-mode . (lambda ()
                     (add-hook 'before-save-hook #'gofmt-before-save nil t))))

(use-package cc-mode
  :ensure nil
  :hook
  (c-mode   . gad_c-and-cpp-mode-hook)
  (c++-mode . gad_c-and-cpp-mode-hook))

(use-package magit
  :config (setq magit-commit-add-log-insert-function #'gad_magit-commit-add-log-insert)
  :hook   (git-commit-setup . git-commit-turn-on-flyspell))

(use-package copilot
  :commands copilot-mode
  :bind (:map copilot-completion-map
              ("<tab>" . copilot-accept-completion)
              ("TAB"   . copilot-accept-completion)))

(use-package org
  :ensure nil
  :config
  (require 'ox-md nil t)
  (load "/home/gad/dvl/src/github/ox-jira.el/ox-jira.el" "missing-ok"))

(use-package ispell
  :ensure nil
  :config
  (ignore-errors
    (setq ispell-program-name "hunspell"
          ispell-dictionary "en_US,de_DE,es_ES")
    (ispell-set-spellchecker-params)
    (ispell-hunspell-add-multi-dic "en_US,de_DE,es_ES")))

(use-package dictionary
  :ensure nil
  :bind    ("C-c l" . dictionary-lookup-definition)
  :custom  (dictionary-server "dict.org"))

(use-package whitespace
  :ensure nil
  :custom (whitespace-style '(face trailing tabs newline empty indentation
                                   space-after-tab space-before-tab))
  :config
  (global-whitespace-mode 1)
  (defun ab-enable-whitespace-mode ()
    (not (derived-mode-p 'magit-mode)))
  (add-function :before-while whitespace-enable-predicate #'ab-enable-whitespace-mode))

;; Packages installed but not yet actively configured
(use-package editorconfig)
(use-package consult)
(use-package projectile)
(use-package treemacs)
(use-package treemacs-magit :after (treemacs magit))
(use-package yascroll)
(use-package markdown-mode)
(use-package php-mode)
(use-package web-mode)
(use-package rainbow-mode)
(use-package rainbow-delimiters)
(use-package debian-el)
(use-package dpkg-dev-el)
(use-package langtool)
(use-package copilot-chat)

;; mini-buildd support
(setq mbd-archives '(ui))
(load "/home/gad/dvl/src/salsa/mini-buildd/mini-buildd/share/emacs/site-lisp/mini-buildd-changelog-mode.el" "missing-ok")
(load "/home/gad/dvl/src/salsa/mini-buildd/mini-buildd/share/emacs/site-lisp/mini-buildd-web-mode.el" "missing-ok")
