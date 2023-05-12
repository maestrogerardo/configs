;; MELPA stuff
(require 'package)
(add-to-list 'package-archives '("MELPA Stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(setq package-selected-packages
      '(
		bash-completion
		company
		dpkg-dev-el
		eglot
		flycheck
		git-gutter
		magit
		projectile
		tree-sitter
		tree-sitter-langs
		yascroll
		))

(setq inhibit-startup-screen t)
(setq column-number-mode t)

;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

(setq-default fill-column 72)

(menu-bar-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode 1)
(xterm-mouse-mode 1)

;; non-GUI scroll bar
;;(global-yascroll-bar-mode 1)
;;(setq yascroll:delay-to-hide nil)

;; restore split winodows settings
(winner-mode 1)

;; auto completion
(global-company-mode 1)

;; tree-sitter
(global-tree-sitter-mode 1)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; Recompiling
(global-set-key (kbd "C-4") 'gad_recompile)
(defun gad_recompile ()
  "Interrupt current compilation and recompile."
  (interactive)
  (ignore-errors (kill-compilation))
  (recompile))

(defun gad_activateCodingStuff ()
  (setq truncate-lines t)
  (display-line-numbers-mode 1)
  (eglot-ensure))

;; Elisp
(add-hook 'lisp-mode-hook 'gad_activateCodingStuff)

;; C, C++
(add-hook 'c-mode-hook 'gad_activateCodingStuff)
(add-hook 'c++-mode-hook 'gad_activateCodingStuff)

;; Go
(setq gofmt-command "goimports") ;; also add imports automatically
(defun gad_go-mode-hook ()
  ;; run gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save))
(add-hook 'go-mode-hook 'gad_go-mode-hook)
(add-hook 'go-mode-hook 'gad_activateCodingStuff)

;; Python
(add-hook 'python-mode-hook 'gad_activateCodingStuff)

;; Git
(add-hook 'git-commit-setup-hook 'git-commit-turn-on-flyspell)

;; git-gutter
(global-git-gutter-mode +1)
 ;; better recognizable using light backgrounds
(set-face-foreground 'git-gutter:added "darkgreen")

;; Bash completion (eg. for "M-x shell")
(autoload 'bash-completion-dynamic-complete
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
          'bash-completion-dynamic-complete)

;; Use English and German in parallel for spell cheking
(with-eval-after-load "ispell"
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US,de_DE")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,de_DE"))

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

;; use real tabs
(setq-default indent-tabs-mode t)
(setq-default tab-width 4) ; Assuming you want your tabs to be four spaces wide
(defvaralias 'c-basic-offset 'tab-width)

;; mini-buildd support
(setq mbd-archives '(ui))
(load "/home/gad/dvl/src/salsa/mini-buildd/mini-buildd/examples/mini-buildd-utils/mini-buildd.el" "missing-ok")

;; font
(set-face-attribute 'default nil :font "DejaVu Sans Mono-9.5")

;; mode-line font
(set-face-attribute 'mode-line nil :font "DejaVu Sans Mono-10")
