(require 'package)
(add-to-list 'package-archives '("MELPA" . "https://melpa.org/packages/") t)
(package-initialize)

;; default packages (emacs >= 30)
(defvar gad-selected-packages)
(setq gad-selected-packages
      '(
		bash-completion
		company
		company-box
		consult
		copilot
		copilot-chat
		debian-el
		diff-hl
		dpkg-dev-el
		eldoc-box
		f
		flycheck
		go-mode
		jsonrpc
		langtool
		magit
		marginalia
		markdown-mode
		orderless
		php-mode
		projectile
		rainbow-delimiters
		rainbow-mode
		request
		transient
		tree-sitter-langs
		treemacs
		treemacs-magit
		vertico
		vterm
		web-mode
		yascroll
		))

;; packages for emacs = 29
(defvar gad-selected-packages-emacs-29)
(setq gad-selected-packages-emacs-29-extra
	  '(
		editorconfig
		which-key
		))

;; packages for emacs < 29
(defvar gad-selected-packages-lt-emacs-29-extra)
(setq gad-selected-packages-lt-emacs-29-extra
	  '(
		editorconfig
		eglot
		tree-sitter
		which-key
		))

(if (>= emacs-major-version 30)
    (setq package-selected-packages gad-selected-packages)
  (if (= emacs-major-version 29)
	  (setq package-selected-packages (append gad-selected-packages gad-selected-packages-emacs-29-extra))
	(if (< emacs-major-version 29)
		(setq package-selected-packages (append gad-selected-packages gad-selected-packages-lt-emacs-29-extra)))))
