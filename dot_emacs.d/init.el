(load "/home/gad/dvl/src/github/configs/dot_emacs.d/lisp/gad-pre-init.el")
(load "/home/gad/dvl/src/github/configs/dot_emacs.d/lisp/gad-package.el")

;; custom file for "M-x customize"
(setq custom-file "~/.emacs.d/lisp/custom.el")
(load custom-file 'noerror 'nomessage)

;; colors
(set-background-color "#f0f0f0")

;; start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq inhibit-startup-screen t)
(setq column-number-mode t)
(setq compilation-scroll-output t)
(setq completion-styles '(orderless))

;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

(setq-default fill-column 72)

;; some modes for everywhere
(menu-bar-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(xterm-mouse-mode 1)
(which-key-mode 1)
(vertico-mode 1)
(marginalia-mode 1)
(global-diff-hl-mode 1)

;; enable hl-line for all programming major modes and modes derived from text-mode
;; kudos to https://emacsredux.com/blog/2020/11/21/disable-global-hl-line-mode-for-specific-modes/
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

;; Emacs >= 28
(if (>= emacs-major-version 28) (context-menu-mode 1))

;; Eamcs >= 29
(if (>= emacs-major-version 29) (pixel-scroll-precision-mode 1))

;; restore split windows settings
(winner-mode 1)

;; windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; e.g. switch cpp <-> hpp
(global-set-key (kbd "C-<tab>") 'ff-find-other-file)

;; dictionary
(global-set-key (kbd "C-c l") #'dictionary-lookup-definition)
(setq dictionary-server "dict.org")

;; auto completion
;; use company-box if running in graphical mode
(if (display-graphic-p)
    (progn (add-hook 'company-mode-hook 'company-box-mode)
		   (setq company-box-frame-top-margin 20)))

(global-company-mode 1)

;; tree-sitter
(global-tree-sitter-mode 1)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; vterm
(setq vterm-max-scrollback 100000)
(setq vterm-kill-buffer-on-exit t)

;; * * * C O D I N G   S T U F F * * *
;; activate coding stuff automatically in most programming modes
(add-hook 'prog-mode-hook #'gad_activateCodingStuff)

(defun gad_activateCodingStuff ()
  ;; use real tabs
  (setq-default indent-tabs-mode t)
  (setq-default tab-width 4)
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

;; C, C++
(add-hook 'c-mode-hook #'gad_c-and-cpp-mode-hook)
(add-hook 'c++-mode-hook #'gad_c-and-cpp-mode-hook)

;; Go
(setq gofmt-command "goimports") ;; also add imports automatically
(defun gad_go-mode-hook ()
  ;; run gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save))
(add-hook 'go-mode-hook 'gad_go-mode-hook)

;; Shell
(add-hook 'sh-mode-hook 'flycheck-mode)

;; autoconf; automake; makefile, makefile-gmake
(add-hook 'autoconf-mode-hook 'flycheck-mode)
(add-hook 'makefile-automake-mode-hook 'flycheck-mode)
(add-hook 'makefile-mode-hook 'flycheck-mode)
(add-hook 'makefile-gmake-mode-hook 'flycheck-mode)

;; recompile shortcut
(global-set-key (kbd "C-4") 'gad_recompile)
(defun gad_recompile ()
  "Interrupt current compilation and recompile."
  (interactive)
  (ignore-errors (kill-compilation))
  (recompile))

;; Git
(add-hook 'git-commit-setup-hook 'git-commit-turn-on-flyspell)

;; Bash completion (eg. for "M-x shell")
(autoload 'bash-completion-dynamic-complete
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions 'bash-completion-dynamic-complete)

;; org mode
;;(setq org-log-done t)
(eval-after-load "org" '(require 'ox-md nil t))
(load "/home/gad/dvl/src/github/ox-jira.el/ox-jira.el" "missing-ok")

;; Use English, German and Spanish in parallel for spell checking
(ignore-errors
  (with-eval-after-load "ispell"
	(setq ispell-program-name "hunspell")
	(setq ispell-dictionary "en_US,de_DE,es_ES")
	(ispell-set-spellchecker-params)
	(ispell-hunspell-add-multi-dic "en_US,de_DE,es_ES")))

;; always use flycheck
;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; custom "magit capital C"
(defun gad_magit-commit-add-log-insert (buffer file defun)
  (with-current-buffer buffer
	(magit-commit-add-log-insert buffer file defun)
	(if defun
		(cond ((re-search-backward (format "* %s (%s): " file defun) nil t)
			   ;; (message (format "gad: buffer %s -> replacing \"* %s (%s): \"..." buffer file defun))
			   (replace-match (format "%s (%s): " file defun))))
	  (cond ((re-search-backward (format "* %s: " file) nil t)
			 ;; (message (format "gad: buffer %s -> replacing \"* %s: \"..." buffer file))
			 (replace-match (format "%s: " file)))))))
(setq magit-commit-add-log-insert-function 'gad_magit-commit-add-log-insert)

;; Whitespace stuff
;; No marking, no extra handling of normal spaces, make tabs only slightly lighter
(setq whitespace-style '(face trailing tabs newline empty indentation space-after-tab space-before-tab))
(global-whitespace-mode 1)

;; Disable WS mode for certain special modes
(defun ab-enable-whitespace-mode () (not (derived-mode-p 'magit-mode)))
(add-function :before-while whitespace-enable-predicate 'ab-enable-whitespace-mode)

;; Potential use of copilot
(require 'copilot)
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

;; mini-buildd support
(setq mbd-archives '(ui))
(load "/home/gad/dvl/src/salsa/mini-buildd/mini-buildd/share/emacs/site-lisp/mini-buildd-changelog-mode.el" "missing-ok")
(load "/home/gad/dvl/src/salsa/mini-buildd/mini-buildd/share/emacs/site-lisp/mini-buildd-web-mode.el" "missing-ok")

;; gb
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
