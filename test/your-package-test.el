;;; your-package-test.el --- Tests for your-package -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Abidán Brito

;; Author: Abidán Brito <abidan.brito@gmail.com>
;; SPDX-License-Identifier: MIT

;;; Commentary:

;; Tests for your-package using ERT.

;;; Code:

(require 'ert)
(require 'your-package)

(ert-deftest your-package-test-mode-toggles ()
  "The minor mode turns on and off."
  (your-package-mode -1)
  (your-package-mode 1)
  (should your-package-mode)
  (your-package-mode -1)
  (should-not your-package-mode))

(ert-deftest your-package-test-mode-hook-runs ()
  "The mode hook runs when the mode is enabled."
  (your-package-mode -1)
  (let* ((hook-ran nil)
         (fn (lambda () (setq hook-ran t))))
    (add-hook 'your-package-mode-hook fn)
    (unwind-protect
        (progn
          (your-package-mode 1)
          (should hook-ran))
      (your-package-mode -1)
      (remove-hook 'your-package-mode-hook fn))))

;; TODO: add tests for your-package's functionality here.

(provide 'your-package-test)
;;; your-package-test.el ends here
