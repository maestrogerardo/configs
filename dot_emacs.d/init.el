(load "/home/gad/dvl/src/github/configs/dot_emacs.d/lisp/gad-package.el")

(setq inhibit-startup-screen t)
(setq column-number-mode t)
(setq compilation-scroll-output t)

;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

(setq-default fill-column 72)

;; one line scrolling
;; keep cursor at same position when scrolling
(setq scroll-preserve-screen-position 1)
;; scroll window up/down by one line
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))

(menu-bar-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode 1)
(xterm-mouse-mode 1)
(which-key-mode 1)
(vertico-mode 1)

;; auto-dim-other-buffers
(add-hook 'after-init-hook (lambda ()
							 (when (fboundp 'auto-dim-other-buffers-mode)
							   (auto-dim-other-buffers-mode t))))

;; Eamcs >= 29
(if (>= emacs-major-version 29) (pixel-scroll-precision-mode 1))

;; restore split winodows settings
(winner-mode 1)

;; e.g. switch cpp <-> hpp
(global-set-key (kbd "C-<tab>") 'ff-find-other-file)

;; langtool
(setq langtool-language-tool-jar "~/dvl/progs/languagetool/languagetool-commandline.jar")
(global-set-key "\C-x4w" 'langtool-check)
(global-set-key "\C-x4W" 'langtool-check-done)
(global-set-key "\C-x4l" 'langtool-switch-default-language)
(global-set-key "\C-x44" 'langtool-show-message-at-point)
(global-set-key "\C-x4c" 'langtool-interactive-correction)

;; dictionary
(global-set-key (kbd "C-c l") #'dictionary-lookup-definition)
(setq dictionary-server "dict.org")

;; auto completion
(global-company-mode 1)

;; tree-sitter
(global-tree-sitter-mode 1)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; * * * C O D I N G   S T U F F * * *
;; activate coding stuff automatically in most programming modes
(add-hook 'prog-mode-hook #'gad_activateCodingStuff)

(defun gad_activateCodingStuff ()
  ;; use real tabs
  (setq-default indent-tabs-mode t)
  (setq-default tab-width 4)
  (defvaralias 'c-basic-offset 'tab-width)

  (setq truncate-lines t)
  (rainbow-mode)
  (ignore-errors
    (rainbow-delimiters-mode))
  )

(defun gad_c-and-cpp-mode-hook ()
  (eglot-ensure)
  (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
  )

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
(add-hook 'shell-dynamic-complete-functions
          'bash-completion-dynamic-complete)

;; org mode
;;(setq org-log-done t)
(eval-after-load "org" '(require 'ox-md nil t))
(load "/home/gad/dvl/src/github/ox-jira.el/ox-jira.el" "missing-ok")

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

;; chatgpt-shell; use "pass" password manager to retrieve api key
(setq chatgpt-shell-openai-key
      (lambda ()
        (nth 0 (process-lines "pass" "show" "openai/key"))))

;; mini-buildd support
(setq mbd-archives '(ui))
(load "/home/gad/dvl/src/salsa/mini-buildd/mini-buildd/share/emacs/site-lisp/mini-buildd-changelog-mode.el" "missing-ok")
(load "/home/gad/dvl/src/salsa/mini-buildd/mini-buildd/share/emacs/site-lisp/mini-buildd-web-mode.el" "missing-ok")

(custom-set-faces
 '(default ((t (:family "Noto Mono" :foundry "GOOG" :slant normal :weight regular :height 95 :width normal))))
 '(auto-dim-other-buffers-face ((t (:background "#f0f0f0"))))
 '(whitespace-indentation ((t (:background "#ebebeb"))))
 '(whitespace-space-after-tab ((t (:background "#ebebeb"))))
 '(whitespace-space-before-tab ((t (:background "#ebebeb"))))
 '(whitespace-tab ((t (:background "#f7f7f7")))))
