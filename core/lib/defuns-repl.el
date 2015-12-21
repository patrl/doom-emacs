;;; defuns-repl.el

(defvar narf--repl-buffer nil)
;;;###autoload  (autoload 'narf:repl "defuns-repl" nil t)
(evil-define-command narf:repl (&optional bang)
  :repeat nil
  (interactive "<!>")
  (if (and narf--repl-buffer (buffer-live-p narf--repl-buffer))
      (if (popwin:popup-window-live-p)
          (popwin:select-popup-window)
        (popwin:pop-to-buffer narf--repl-buffer))
    (rtog/toggle-repl (if (use-region-p) 4))
    (setq narf--repl-buffer (current-buffer))))

;;;###autoload  (autoload 'narf:repl-eval "defuns-repl" nil t)
(evil-define-operator narf:repl-eval (&optional beg end bang)
  :type inclusive
  :repeat nil
  (interactive "<r><!>")
  (let ((region-p (use-region-p))
        (selection (s-trim (buffer-substring-no-properties beg end))))
    (narf:repl bang)
    (when (and region-p beg end)
      (let* ((buf narf--repl-buffer)
             (win (get-buffer-window buf)))
        (unless (eq buf popwin:popup-buffer)
          (popwin:pop-to-buffer buf nil t))
        (when (and narf--repl-buffer (buffer-live-p narf--repl-buffer))
          (with-current-buffer narf--repl-buffer
            (goto-char (point-max))
            (insert selection)))))))


(provide 'defuns-repl)
;;; defuns-repl.el ends here
