(defun read-file-to-string (file-path)
  "Read the contents of FILE-PATH and return as a string."
  (with-temp-buffer
	(insert-file-contents file-path)
	(buffer-string)))

(defun safe-file-content-equals (file-path comparison-string)
  "Safely check if the contents of FILE-PATH are equal to COMPARISON-STRING. Return nil if the file doesn't exist."
  (if (not (file-exists-p file-path))
	  (progn (message "File does not exist: %s" file-path) nil)
	(let ((file-content (string-trim (read-file-to-string file-path))))
	  (string= file-content comparison-string))))

(if (safe-file-content-equals "~/.gad_user_type" "wrk")
	(progn (message (format "setup: wrk, email: %s" (getenv "GIT_AUTHOR_EMAIL")))
		   (setq gad-work-setup t))
  (message (format "setup: prv, email: %s" (getenv "GIT_AUTHOR_EMAIL"))))
