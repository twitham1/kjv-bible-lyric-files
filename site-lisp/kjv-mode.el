;;; kjv-mode.el --- GNU Emacs mode for reading the King James Bible

;; @(#)$Id: kjv-mode.el,v 1.3 2022/07/15 05:24:24 twitham Exp $
;; Copyright (C) 2005 Timothy D. Witham

;; Author: Tim Witham <twitham@sbcglobal.net>
;; Created: 01 January 2005
;; Version: $Revision: 1.3 $
;; Keywords: king james bible text mode

;; This file is not currently part of GNU Emacs but is licensed the same:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; * You need accessory program `kjvmp3' installed on $PATH for audio.

;; * You need sword and `kjv' to generate the compatible text (or get
;;   it from twitham)

;;; Code:

(require 'bookmark)			; to load reading position

(defface kjv-invisible-face
  '((t (:height 1)))
  "Face used to make []s invisible in `kjv-mode'.")

(defconst kjv-font-lock-keywords-1
  ;; syntax fontification automatically does strings (words of Christ)
  (list
   '("{[^}]+}" 0 'bold prepend)
   '("\\(L\\)ORD" 1 'bold prepend)	; divine name
   ;;       '("\\[" 0 '(italic invisible t))
   '("\\(\\[\\)[^[]+\\(\\]\\)" (0 'italic prepend)
     (1 'kjv-invisible-face t) (2 'kjv-invisible-face t))
   '("^\\w+ [0-9]+:\\([0-9]+\\):" . 1)
   )
  "Subdued level highlighting for KJV mode.")

(defconst kjv-font-lock-keywords-2
  (append
   (list
    )
   kjv-font-lock-keywords-1)
  "Gaudy level highlighting for KJV mode.")

(defconst kjv-bookmark-string "KJV - Daily Reading Position"
  "Name of current reading positon bookmark.")

(defvar kjv-font-lock-keywords kjv-font-lock-keywords-1
  "Default expressions to highlight in KJV mode.")

(defvar kjv-time (float-time)
  "Seconds since the epoch for the daily bible reading schedule.")

(defvar kjv-times-per-year 1
  "*Number of times to read through the bible each year.
This determines the daily bible reading schedule.")

(defvar kjv-mode-map ()
  "Keymap used in KJV mode.")

(if nil					;kjv-mode-map
    ()
  (setq kjv-mode-map (make-sparse-keymap))
  (define-key kjv-mode-map "{" 'backward-paragraph)
  (define-key kjv-mode-map "}" 'forward-paragraph)
  (define-key kjv-mode-map "[" 'kjv-backward-day)
  (define-key kjv-mode-map "]" 'kjv-forward-day)
  (define-key kjv-mode-map ";" 'kjv-today)
  (define-key kjv-mode-map "b" 'kjv-set-bookmark)
  (define-key kjv-mode-map "t" 'kjv-read-today)
  (define-key kjv-mode-map "a" 'kjv-audio-chapter)
  (define-key kjv-mode-map "i" 'imenu)

  (define-key kjv-mode-map [menu-bar] (make-sparse-keymap))
  (define-key kjv-mode-map [menu-bar kjv]
    (cons "KJV" (make-sparse-keymap "KJV")))

  (define-key kjv-mode-map [menu-bar kjv kjv-schedule]
    '("Show Yearly Reading Schedule" . kjv-schedule))
  (define-key kjv-mode-map [menu-bar kjv imenu]
    '("Chapter Index" . imenu))
  (define-key kjv-mode-map [menu-bar kjv kjv-audio-chapter]
    '("Read Chapter Audibly" . kjv-audio-chapter))
  (define-key kjv-mode-map [menu-bar kjv kjv-backward-day]
    '("Previous Day" . kjv-backward-day))
  (define-key kjv-mode-map [menu-bar kjv kjv-forward-day]
    '("Next Day" . kjv-forward-day))
  (define-key kjv-mode-map [menu-bar kjv kjv-today]
    '("Go to End of today" . kjv-today))
  (define-key kjv-mode-map [menu-bar kjv kjv-set-bookmark]
    '("Bookmark to Point as Read" . kjv-set-bookmark))
  (define-key kjv-mode-map [menu-bar kjv kjv-read-today]
    '("Show Today's Reading" . kjv-read-today)))

(defvar kjv-mode-syntax-table nil
  "Syntax table in use in kjv-mode buffers.")

(defvar kjv-audio-program "kjvmp3"
  "Program to use for playing a chapter of audio.")

(defvar kjv-audio-buffer nil
  "Buffer to use for playing a chapter of audio.")

;; to let C-u C-s ignore punctuation as if it was whitespace
(if kjv-mode-syntax-table
    ()
  (setq kjv-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?\. " " kjv-mode-syntax-table)
  (modify-syntax-entry ?\, " " kjv-mode-syntax-table)
  (modify-syntax-entry ?\: " " kjv-mode-syntax-table)
  (modify-syntax-entry ?\; " " kjv-mode-syntax-table)
  (modify-syntax-entry ?\! " " kjv-mode-syntax-table)
  (modify-syntax-entry ?\? " " kjv-mode-syntax-table)
  (modify-syntax-entry ?\' " " kjv-mode-syntax-table)
  (modify-syntax-entry ?\[ " " kjv-mode-syntax-table)
  (modify-syntax-entry ?\] " " kjv-mode-syntax-table))

;;;###autoload
(defun kjv-mode ()
  "Major mode for reading and studying the KJV Holy Bible.
`kjv-times-per-year' determines the daily bible reading schedule.

\\{kjv-mode-map}

Turning on KJV mode runs the normal hook `kjv-mode-hook'."
  (interactive)
  (kill-all-local-variables)
  (use-local-map kjv-mode-map)
  (setq major-mode 'kjv-mode)
  (setq mode-name "KJV")
  (set-syntax-table kjv-mode-syntax-table)
  (make-local-variable 'paragraph-start)
  (setq paragraph-start "\n")
  (make-local-variable 'bidi-display-reordering)
  (setq bidi-display-reordering nil)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '((kjv-font-lock-keywords
			      kjv-font-lock-keywords-1
			      kjv-font-lock-keywords-2)
			     nil nil nil
			     backward-paragraph
			     (font-lock-mark-block-function . mark-paragraph)))
  ;; Tell imenu.el how to handle KJV.
  (make-local-variable 'imenu-prev-index-position-function)
  (setq imenu-prev-index-position-function 'kjv-prev-index-position)
  (make-local-variable 'imenu-extract-index-name-function)
  (setq imenu-extract-index-name-function 'kjv-extract-index-name)
  (imenu-add-to-menubar "Chapters")
  (toggle-read-only 1)
  (outline-minor-mode)
  (kjv-today)
  (bookmark-maybe-load-default-file)
  (bookmark-jump kjv-bookmark-string)
  (run-hooks 'kjv-mode-hook))

;;; two functions to find named objects for imenu
(defun kjv-prev-index-position ()
  (when (progn (beginning-of-line)
	     (search-backward "{ The Book of " 0 t))
    (forward-char 14)
    (point)))

(defun kjv-extract-index-name ()
  (let ((beg (point))
	(end (progn (search-forward " }") (forward-char -2) (point))))
    (buffer-substring beg end)))

(defun kjv-date (&optional time)
  "Move point just past the given time's position and show what day it is."
  (or time (setq time (float-time)))
  (let* ((ltime (seconds-to-time time))
	 (list (decode-time ltime))
	 (day (nth 3 list))
	 (mon (nth 4 list))
	 (year (nth 5 list))
	 (days (/ 365 kjv-times-per-year)))
    (widen)
    (goto-char (* (/ (point-max) days)
		  (% (calendar-day-number (list mon day year)) days)))
;;;    (set-mark (point))		; uncomment to see actual divisions
    (let ((before (save-excursion (or (search-backward "**\t\t" 1 t)
				      1)))
	  (after  (save-excursion (or (search-forward "**\t\t" nil t)
				      (point-max)))))
      (goto-char (if (< (- (point) before) (- after (point)))
		     before		; go to closest chapter break
		   after)))
    (when (= (point) 1)
      (goto-char (point-max)))
    (beginning-of-line)
    (message "%s  %s" (format-time-string "%B %d, %Y" ltime)
	     (buffer-substring (point-at-bol) (point-at-eol)))))

(defun kjv-schedule ()
  "Display one year's bible reading schedule."
  (interactive)
  (let ((orig (current-buffer))
	(schedule (get-buffer-create "*kjv-schedule*"))
	(time (float-time (encode-time 0 0 12 1 1 2005)))
	(last (float-time (encode-time 0 0 12 1 1 2006))))
    (save-current-buffer
      (while (< time last)
	(set-buffer orig)
	(kjv-date time)
	(set-buffer schedule)
	(insert (format-time-string "\n%10B %d  " (seconds-to-time time)))
	(set-buffer orig)
	(append-to-buffer schedule (point-at-bol) (point-at-eol))
	(setq time (+ time 86400)))
      (set-buffer schedule)
      (insert "**\t\t{ The End }\n"))
    (switch-to-buffer-other-window schedule)))

(defun kjv-today ()
  "Move point to just after today's reading position."
  (interactive)
  (setq kjv-time (float-time))		; current time
  (kjv-date kjv-time))

(defun kjv-forward-day (&optional n)
  "Move point forward N day's chapters (backward if N is negative)."
  (interactive "p")
  (or n (setq n 1))
  (setq kjv-time (+ kjv-time (* 86400 n)))
  (kjv-date kjv-time))

(defun kjv-backward-day (&optional n)
  "Move point backward N day's chapters (forward if N is negative)."
  (interactive "p")
  (or n (setq n 1))
  (kjv-forward-day (* -1 n)))

(defun kjv-set-bookmark ()
  "Set the current reading bookmark to point."
  (interactive)
  (bookmark-set kjv-bookmark-string)
  (bookmark-save))

(defun kjv-read-today ()
  "Narrow from the reading bookmark to today's reading position."
  (interactive)
  (bookmark-jump kjv-bookmark-string)
  (let ((begin	(point)))
    (kjv-today)
    (narrow-to-region begin (point))
    (goto-char begin)))

(defun kjv-audio-chapter (&optional stop)
  "Read the current chapter audibly via external program `kjv-audio-program'.
With prefix arg, stop audio playback."
  (interactive "P")
  (if stop
      (kill-buffer kjv-audio-buffer)
    (let ((end (progn (forward-line 1)
		      (search-backward " Chapter " 0 t)
		      (search-forward " }")
		      (forward-char -2)
		      (point)))
	  (beg (progn (search-backward "{ ")
		      (forward-char 2)
		      (point))))
      (beginning-of-line)
      (when (not (not kjv-audio-buffer))
	(kill-buffer kjv-audio-buffer))
      (setq kjv-audio-buffer (generate-new-buffer "kjv-audio"))
      (start-process "kjv-audio" kjv-audio-buffer kjv-audio-program
		     (buffer-substring beg end)))))

(provide 'kjv-mode)

;;; kjv-mode.el ends here
