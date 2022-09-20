;; gad
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
