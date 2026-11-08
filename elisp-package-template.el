;;; elisp-package-template.el --- Short package description -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Abidán Brito

;; Author: Abidán Brito <abidan.brito@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: tools
;; URL: https://github.com/abidanBrito/elisp-package-template
;; SPDX-License-Identifier: MIT

;;; Commentary:

;; Describe what this package does and how to start using it.
;; What you write here is what `describe-package' shows.

;;; TODO:

;; - Write the `Commentary' section above.
;; - Set the `Keywords' header (run `finder-list-keywords' to see all
;;   valid options to choose from).

;;; Code:

(defgroup elisp-package-template nil
  "Short package description."
  :group 'tools
  :prefix "elisp-package-template-")

;; TODO: add your package's options here with `defcustom'.

;;;###autoload
(define-minor-mode elisp-package-template-mode
  "Toggle `elisp-package-template-mode'."
  :global t
  (if elisp-package-template-mode
      (message "elisp-package-template enabled")
    (message "elisp-package-template disabled")))

(provide 'elisp-package-template)
;;; elisp-package-template.el ends here
