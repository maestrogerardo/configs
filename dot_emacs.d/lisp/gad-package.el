(require 'package)
(add-to-list 'package-archives '("MELPA" . "https://melpa.org/packages/") t)
(package-initialize)

;; default packages
(defvar gad-selected-packages)
(setq gad-selected-packages
      '(
		bash-completion
		company
		company-box
		consult
		copilot-chat
		debian-el
		diff-hl
		dpkg-dev-el
		editorconfig
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
		tree-sitter-langs
		treemacs
		treemacs-magit
		vertico
		vterm
		web-mode
		which-key
		yascroll
		))

;; packages for emacs < 29
(defvar gad-selected-packages-lt-emacs-29)
(setq gad-selected-packages-lt-emacs-29
	  '(
		eglot
		tree-sitter
		))

(if (>= emacs-major-version 29)
    (setq package-selected-packages gad-selected-packages)
  (setq package-selected-packages (append gad-selected-packages gad-selected-packages-lt-emacs-29)))
