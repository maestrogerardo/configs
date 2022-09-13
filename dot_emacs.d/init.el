;; gad
(setq user-full-name "Gerhard A. Dittes"
      user-mail-address "maestro.gerardo@gmail.com")

(setq lsp-semantic-tokens-enable t)

(setq inhibit-startup-screen t)

(global-display-line-numbers-mode 1)
(menu-bar-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode 1)

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'git-commit-setup-hook 'git-commit-turn-on-flyspell)

;; Whitespace stuff
;; No marking, no extra handling of normal spaces, make tabs only slightly lighter
(setq whitespace-style '(face trailing tabs newline empty indentation space-after-tab space-before-tab))
(global-whitespace-mode 1)

;; Disable WS mode for certain special modes
(defun ab-enable-whitespace-mode () (not (derived-mode-p 'magit-mode)))
(add-function :before-while whitespace-enable-predicate 'ab-enable-whitespace-mode)

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

;; lsp C/C++
;; see: https://emacs-lsp.github.io/lsp-mode/tutorials/CPP-guide/
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))
