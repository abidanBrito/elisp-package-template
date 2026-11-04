;;; your-package.el --- Short package description -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Abidán Brito

;; Author: Abidán Brito <abidan.brito@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: tools
;; URL: https://github.com/abidanBrito/elisp-package-template
;; SPDX-License-Identifier: MIT

;;; Commentary:

;; TODO: describe what this package does and how to start using it.
;;       What you write here is what `describe-package' shows.
;;
;; TODO: set the `Keywords' header above (run `finder-list-keywords'
;;       to see all valid options to choose from).

;;; Code:

(defgroup your-package nil
  "Short package description."
  :group 'tools
  :prefix "your-package-")

;; TODO: add your package's options here with `defcustom'.

;;;###autoload
(define-minor-mode your-package-mode
  "Toggle `your-package-mode'."
  :global t
  (if your-package-mode
      (message "your-package enabled")
    (message "your-package disabled")))

(provide 'your-package)
;;; your-package.el ends here
