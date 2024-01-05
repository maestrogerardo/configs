(require 'package)
(add-to-list 'package-archives '("MELPA" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("MELPA Stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(defvar gad-selected-packages)
(setq gad-selected-packages
      '(
		auto-dim-other-buffers
		bash-completion
		chatgpt-shell
		company
		debian-el
		dpkg-dev-el
		flycheck
		go-mode
		langtool
		magit
		php-mode
		projectile
		rainbow-delimiters
		rainbow-mode
		request
		tree-sitter-langs
		treemacs
		treemacs-magit
		vertico
		web-mode
		which-key
		yascroll
		))
(defvar gad-selected-packages-lt-emacs-29)
(setq gad-selected-packages-lt-emacs-29
	  '(
		eglot
		git-gutter
		tree-sitter
		))

(if (>= emacs-major-version 29)
    (setq package-selected-packages gad-selected-packages)
  (setq package-selected-packages (append gad-selected-packages gad-selected-packages-lt-emacs-29)))
