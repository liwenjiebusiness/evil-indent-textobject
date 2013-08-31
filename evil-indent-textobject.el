;;; evil-indent-textobject.el --- evil textobjects based on indentation

;; Copyright (C) 2013 Michael Markert
;; Author: Michael Markert <markert.michael@gmail.com>
;; Created: 2013-08-31
;; Version:
;; Keywords: convenience evil
;; URL: http://github.com/cofi/evil-indent-textobject
;;
;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;;; Code:

(require 'cl-lib)
(require 'evil)

(defun evil-indent--current-indentation ()
  "Return the indentation of the current line.
Moves point."
  (buffer-substring-no-properties (point-at-bol)
                                  (progn (back-to-indentation)
                                         (point))))

(defun evil-indent--same-indent-range (&optional point)
  "Return the point at the begin and end of the text block with the same indentation.
If `point' is supplied and non-nil it will return the begin and
end of the block surrounding point."
  (save-excursion
    (when point
      (goto-char point))
    (let ((start (point))
          (indent (evil-indent--current-indentation))
          begin end)
      (loop while (string= (evil-indent--current-indentation) indent)
            do (progn
                 (setq begin (point-at-bol))
                 (forward-line -1)))
      (goto-char start)
      (loop while (string= (evil-indent--current-indentation) indent)
            do (progn
                 (setq end (point-at-eol))
                 (forward-line 1)))
      (list begin end))))

(evil-define-text-object evil-indent-a-indent (&optional count beg end type)
  "Text object describing the block with the same indentation as
the current line and the line above."
  :type line
  (let ((range (evil-indent--same-indent-range)))
    (evil-range (save-excursion
                  (goto-char (first (evil-indent--same-indent-range)))
                  (forward-line -1)
                  (point-at-bol))
                (second range) 'line)))

(evil-define-text-object evil-indent-a-indent-lines (&optional count beg end type)
  "Text object describing the block with the same indentation as
the current line and the lines above and below."
  :type line
  (let ((range (evil-indent--same-indent-range)))
    (evil-range (save-excursion
                  (goto-char (first range))
                  (forward-line -1)
                  (point-at-bol))
                (save-excursion
                  (goto-char (second range))
                  (forward-line 1)
                  (point-at-eol)) 'line)))

(evil-define-text-object evil-indent-i-indent (&optional count beg end type)
  "Text object describing the block with the same indentation as
the current line."
  :type line
  (let ((range (evil-indent--same-indent-range)))
    (evil-range (first range) (second range) 'line)))

(provide 'evil-indent-textobject)
;;; evil-indent-textobject.el ends here
