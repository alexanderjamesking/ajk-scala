;; see https://scalameta.org/metals/docs/editors/emacs.html

(message "scala.el")

(require 'sbt-mode)


(defun sbt-test-wildcard (wildcard)
  "Run `testOnly *BUFFER-NAME -- -z WILDCARD`."
  (interactive "sWildcard: ")

  ;; TODO - need to look at current file name, project filename - work out if we're in a sub module (e.g. `it`)
  ;; test:testOnly vs it:testOnly
  (let* ((command (concat "testOnly *" (car (split-string (buffer-name) ".scala")) " -- -z \"" wildcard "\"")))
    (message command)
    (sbt:command command)))

(defun run-single-test ()
  "Run single test (based on cursor position / highlighted region)."
  (interactive)
  (let ((wildcard (if (use-region-p)
                      ;; use whatever is in the region - it's up to the user to get this correct
                      (buffer-substring-no-properties (mark) (point))
                      ;; TODO: we should expand this to get the whole string up to but not including the quotes
                    (current-word))))
    (sbt-test-wildcard wildcard)))

(defun run-tests-in-file ()
  "Run all tests in the current file name."
  (interactive)
  (sbt-test-wildcard ""))

(defun sbt-test-buffer-file-region ()
  "Run `testOnly *BUFFER-NAME -- -z REGION`."
  (interactive)
  ;; need to find class name under cursor

  ;; TODO: read https://www.scalatest.org/user_guide/using_scalatest_with_sbt


  ;; TODO - check it's a test file
  ;; TODO - situation where differs from buffer name

  ;; TODO - ability to run a subset of a test by passing a string
  ;;(sbt:command "test:testOnly *BookingQuerySpec -- -z ajk")

  (let* ((region-text (message (buffer-substring-no-properties (mark) (point)))))

    (sbt-test-wildcard region-text)))

;; TODO - sort lines in a region

(define-minor-mode ajk-scala-mode
  "My custom Scala mode."
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-t C-t") 'run-single-test)
            (define-key map (kbd "C-c C-t C-f") 'run-tests-in-file)
            map))

(message "ajk-scala-mode defined")

(add-hook 'scala-mode-hook 'ajk-scala-mode)

(message "ajk-scala-mode hook added to scala-mode-hook")

(provide 'ajk-scala)
;;; ajk-scala.el ends here
