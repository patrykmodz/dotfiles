;;; -*- lexical-binding: t -*-
(add-to-list 'load-path "~/code/third-party")
;; theme
(load-theme 'gruber-darker t)
;;appearance
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
;; (add-to-list 'default-frame-alist '(width . 100))
;; (add-to-list 'default-frame-alist '(height . 30))
;; (set-frame-position (selected-frame) 250 73)
(setq ring-bell-function 'ignore) ; fucks off that annoying beep
;; disable bs emacs files
(setq make-backup-files nil)
(setq create-lockfiles nil)
;; splash
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
;;lines
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq-default truncate-lines t) ; make lines continue horizontally off-screen
(setq-default column-number-mode t) ; show line-column in statusbar
;; font
(set-face-attribute 'default nil
                    :family "JetBrains Mono"
                    :height 170)
;; whitespacing
(global-whitespace-mode 1)
; exclude newline
(setq whitespace-style
      '(face
        tabs
        spaces
        space-mark
        tab-mark))

;; tab
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default indent-tabs-mode nil)

;; ido
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t
      ido-show-dot-for-dired t)

;;smex - ido for mx
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; old m-x
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;simpc-mode
(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

;; custom keybindings
;find file at point
(global-set-key(kbd"C-c f")'find-file-at-point)
;other
(global-set-key (kbd "M-p") #'my-move-line-up)
(global-set-key (kbd "M-n") #'my-move-line-down)
(global-set-key (kbd "C-c d") #'my-delete-line)
(global-set-key (kbd "C-'") #'undo-redo)
(global-set-key (kbd "C-<backspace>") #'my-backward-delete-word)
(global-set-key (kbd "M-[") #'my-unindent)
(global-set-key (kbd "M-]") #'my-indent)
(global-set-key (kbd "C-,") #'duplicate-line)

;; custom functions
(defun my-move-line-up ()
(interactive)
(transpose-lines 1)
(forward-line -2))

(defun my-move-line-down ()
(interactive)
(forward-line 1)
(transpose-lines 1)
(forward-line -1))

(defun my-delete-line ()
"delete the current line without killing it."
(interactive)
(delete-region (line-beginning-position)
(line-beginning-position 2)))

(defun my-backward-delete-word ()
  "delete backwards using editor-style word and punctuation rules."
  (interactive)
  (cond
   ; beginning of line: delete newline
   ((bolp)
    (when (> (point) (point-min))
      (delete-char -1)))

   ; whitespace: delete up to four spaces
   ((looking-back "[ \t]" 1)
    (let* ((end (point))
           (start (save-excursion
                    (skip-chars-backward " \t")
                    (max (point) (- end 4)))))
      (delete-region start end)
      (goto-char start)))

   ; punctuation: delete one character
   ((looking-back "[^[:alnum:] \t]" 1)
    (delete-char -1))

   ; otherwise: delete previous word
   (t
    (let ((end (point)))
      (skip-chars-backward "[:alnum:]")
      (delete-region (point) end)))))

(defun my-indent ()
  "indent the current line or selected lines by four spaces."
  (interactive)
  (if (use-region-p)
      (let ((deactivate-mark nil))
        (indent-rigidly (region-beginning) (region-end) 4))
    (save-excursion
      (beginning-of-line)
      (insert "    "))
    (when (= (current-column) 0)
      (forward-char 4))))

(defun my-unindent ()
  "unindent the current line or selected lines by four spaces."
  (interactive)
  (if (use-region-p)
      (let ((deactivate-mark nil))
        (indent-rigidly (region-beginning) (region-end) -4))
    (let ((column (current-column)))
      (save-excursion
        (beginning-of-line)
        (let ((start (point)))
          (skip-chars-forward " " (min (+ start 4) (line-end-position)))
          (delete-region start (point))))
      (when (<= column 4)
        (back-to-indentation)))))

(defun generate-tags ()
  "Generate a TAGS file for C source and header files."
  (interactive)
  (shell-command "find . -type f \\( -name '*.c' -o -name '*.h' \\) -print0 | xargs -0 etags"))

;; custom set variables
(custom-set-variables
 '(custom-safe-themes
   '("e13beeb34b932f309fb2c360a04a460821ca99fe58f69e65557d6c1b10ba18c7"
     default))
 '(package-selected-packages '(gruber-darker-theme linum-relative)))
