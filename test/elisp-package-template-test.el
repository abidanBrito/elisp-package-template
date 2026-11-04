;;; elisp-package-template-test.el --- Tests for elisp-package-template -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Abidán Brito

;; Author: Abidán Brito <abidan.brito@gmail.com>
;; SPDX-License-Identifier: MIT

;;; Commentary:

;; Tests for elisp-package-template using ERT.

;;; Code:

(require 'ert)
(require 'elisp-package-template)

(ert-deftest elisp-package-template-test-mode-toggles ()
  "The minor mode turns on and off."
  (elisp-package-template-mode -1)
  (elisp-package-template-mode 1)
  (should elisp-package-template-mode)
  (elisp-package-template-mode -1)
  (should-not elisp-package-template-mode))

(ert-deftest elisp-package-template-test-mode-hook-runs ()
  "The mode hook runs when the mode is enabled."
  (elisp-package-template-mode -1)
  (let* ((hook-ran nil)
         (fn (lambda () (setq hook-ran t))))
    (add-hook 'elisp-package-template-mode-hook fn)
    (unwind-protect
        (progn
          (elisp-package-template-mode 1)
          (should hook-ran))
      (elisp-package-template-mode -1)
      (remove-hook 'elisp-package-template-mode-hook fn))))

;; TODO: add tests for elisp-package-template's functionality here.

(provide 'elisp-package-template-test)
;;; elisp-package-template-test.el ends here
