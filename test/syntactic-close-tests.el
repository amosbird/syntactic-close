;;; syntactic-close-tests.el ---  Tests

;; Authored and maintained by
;; Emacs User Group Berlin <emacs-berlin@emacs-berlin.org>

;; Keywords: languages, lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary: A still naive implementation of a syntactic-close command

;;

;;; Code:


(defvar syntactic-close-debug-p nil
  "Avoid error")


(defmacro syntactic-close-test (contents mode verbose &rest body)
  "Create temp buffer inserting CONTENTS.

BODY is code to be executed within the temp buffer "
  (declare (indent 1) (debug t))
  `(with-temp-buffer
     (let (hs-minor-mode)
       (insert ,contents)
       (funcall ,mode)
       (when ,verbose
	 (switch-to-buffer (current-buffer))
	 (font-lock-fontify-region (point-min)(point-max))
       ,@body))
  ;; (sit-for 0.1)
  ))

(defmacro syntactic-close-test-point-min (contents mode verbose &rest body)
  "Create temp buffer inserting CONTENTS.
BODY is code to be executed within the temp buffer.  Point is
 at the beginning of buffer."
  (declare (indent 1) (debug t))
  `(with-temp-buffer
     (let (hs-minor-mode)
       (funcall ,mode)
       (insert ,contents)
       (goto-char (point-min))
       (when ,verbose
	 (switch-to-buffer (current-buffer))
	 (font-lock-fontify-region (point-min)(point-max)))
       ,@body)))

(ert-deftest syntactic-close-close-elisp-nested-bracket-paren-test ()
  (syntactic-close-test
    "(list ([\n;;{123\n;;{123\n"
    'emacs-lisp-mode
    syntactic-close-debug-p    
    (syntactic-close)
    (should (eq (char-before) ?\]))
    (syntactic-close)
    (should (eq (char-before) ?\)))
    (syntactic-close)
    (should (eq (char-before) ?\)))))


(provide 'syntactic-close-tests)
;;; syntactic-close-tests.el ends here
