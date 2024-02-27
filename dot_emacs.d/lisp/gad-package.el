(require 'package)
(add-to-list 'package-archives '("MELPA" . "https://melpa.org/packages/") t)
(package-initialize)

;; default packages
(defvar gad-selected-packages)
(setq gad-selected-packages
      '(
		bash-completion
		chatgpt-shell
		company
		consult
		debian-el
		diff-hl
		dpkg-dev-el
		flycheck
		go-mode
		langtool
		magit
		marginalia
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

;; packages only necessary for "work purposes)
(defvar gad-selected-packages-work)
(setq gad-selected-packages-work
	  '(
		f
		editorconfig
		jsonrpc
		))

(if (boundp 'gad-work-setup)
    (progn (message "%s" "using packages for \"work setup\"...")
	   (setq package-selected-packages (append gad-selected-packages gad-selected-packages-work)))
  (progn (message "%s" "using packages for \"default setup\"...")))
