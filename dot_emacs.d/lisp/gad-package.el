(require 'package)
(add-to-list 'package-archives '("MELPA" . "https://melpa.org/packages/") t)
(package-initialize)

;; use-package is built-in since Emacs 29
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
