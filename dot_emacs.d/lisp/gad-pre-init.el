(defun gad-read-file-to-string (file-path)
  "Read the contents of FILE-PATH and return as a string."
  (with-temp-buffer
	(insert-file-contents file-path)
	(buffer-string)))

(defun gad-safe-file-content-equals (file-path comparison-string)
  "Safely check if the contents of FILE-PATH are equal to COMPARISON-STRING. Return nil if the file doesn't exist."
  (if (not (file-exists-p file-path))
	  (progn (message "File does not exist: %s" file-path) nil)
	(let ((file-content (string-trim (gad-read-file-to-string file-path))))
	  (string= file-content comparison-string))))

(defun gad-append-to-mode-line (text)
  "Append a custom TEXT to the mode line."
  (setq-default mode-line-format
				(append mode-line-format (list (format " | %s" text))))
  (force-mode-line-update))

(if (gad-safe-file-content-equals "~/.gad_user_type" "wrk")
	(progn (message (format "setup: wrk, email: %s" (getenv "GIT_AUTHOR_EMAIL")))
		   (gad-append-to-mode-line "wrk")
		   (setq gad-work-setup t))
  (progn
	(message (format "setup: prv, email: %s" (getenv "GIT_AUTHOR_EMAIL")))
	(gad-append-to-mode-line "prv")))
