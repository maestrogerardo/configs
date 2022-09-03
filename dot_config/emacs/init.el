;; gad
(setq user-full-name "Gerhard A. Dittes"
      user-mail-address "maestro.gerardo@gmail.com")

(setq lsp-semantic-tokens-enable t)

(setq inhibit-startup-screen t)

(global-display-line-numbers-mode 1)
(menu-bar-mode 1)
(scroll-bar-mode 1)

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'git-commit-setup-hook 'git-commit-turn-on-flyspell)

;; custom "magit capital C"
(setq magit-commit-add-log-insert-function 'gad_magit-commit-add-log-insert)

(defun gad_magit-commit-add-log-insert (buffer file defun)
  (with-current-buffer buffer
    (magit-commit-add-log-insert buffer file defun)
    (cond ((re-search-backward (format "* %s: " file) nil t) (replace-match (format "%s: " file))))))
