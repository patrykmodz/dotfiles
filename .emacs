(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;;so shit can get found
(add-to-list 'load-path "~/code/third-party")

(setq make-backup-files nil)
(setq create-lockfiles nil)

(set-face-attribute 'default nil
:family "JetBrains Mono"
:height 170)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;;find file at point (go to file at define?)
(global-set-key(kbd"C-c f")'find-file-at-point)

;; ido
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t
      ido-show-dot-for-dired t)
;;smex - ido for mx
  (require 'smex) ; Not needed if you use package.el
  (smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                                        ; when Smex is auto-initialized on its first run.
;;keybinding bs copied straight from the repo's readme
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; simpc mode idk
(require 'simpc-mode)
;; Automatically enabling simpc-mode on files with extensions like .h, .c, .cpp, .hpp
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(add-hook 'minibuffer-setup-hook
(lambda ()
(setq-local line-spacing 0.5)))

(load-theme 'gruber-darker t)

(setq display-line-numbers-type 'relative)

(global-display-line-numbers-mode 1)

(defun my-display-line-numbers-current-line ()
  (setq-local display-line-numbers-width
              (max 4 (length (number-to-string (line-number-at-pos))))))

(add-hook 'display-line-numbers-mode-hook
          #'my-display-line-numbers-current-line)

(setq ring-bell-function 'ignore)

(defun my-delete-line ()
"delete the current line without killing it."
(interactive)
(delete-region (line-beginning-position)
(line-beginning-position 2)))

(global-set-key (kbd "C-c d") #'my-delete-line)

(global-set-key (kbd "C-'") #'undo-redo)

(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default indent-tabs-mode nil)

(defun my-move-line-up ()
(interactive)
(transpose-lines 1)
(forward-line -2))

(defun my-move-line-down ()
(interactive)
(forward-line 1)
(transpose-lines 1)
(forward-line -1))

(global-set-key (kbd "M-p") #'my-move-line-up)
(global-set-key (kbd "M-n") #'my-move-line-down)

(setq whitespace-style
'(face
tabs
spaces
space-mark
tab-mark))

(global-whitespace-mode 1)
(defun my-backward-delete-word ()
  "Delete backwards using editor-style word and punctuation rules."
  (interactive)
  (cond
   ;; Beginning of line: delete newline
   ((bolp)
    (when (> (point) (point-min))
      (delete-char -1)))

   ;; Whitespace: delete up to four spaces
    ((looking-back "[ \t]" 1)
     (let* ((end (point))
            (start (save-excursion
                     (skip-chars-backward " \t")
                     (max (point) (- end 4)))))
       (delete-region start end)
       (goto-char start)))

   ;; Punctuation: delete one character
   ((looking-back "[^[:alnum:]_ \t]" 1)
    (delete-char -1))

   ;; Otherwise: delete previous word
   (t
    (let ((end (point)))
      (skip-chars-backward "[:alnum:]_")
      (delete-region (point) end)))))
(global-set-key (kbd "C-<backspace>") #'my-backward-delete-word)

;; keybind fixed by setq-local <func>
(defun my-tab ()
"Insert four spaces."
(interactive)
(insert "    "))
;; (add-hook 'simpc-mode-hook
;;           (lambda ()
;;             (setq-local indent-line-function #'my-tab)))

;;(global-set-key (kbd "TAB") #'my-tab)
;;(global-set-key (kbd "<tab>") #'my-tab)

(defun my-indent ()
"Indent the current line or selected lines by four spaces."
(interactive)
(if (use-region-p)
(let ((deactivate-mark nil))
(indent-rigidly (region-beginning) (region-end) 4))
(beginning-of-line)
(insert "    ")))

(defun my-unindent ()
"Unindent the current line or selected lines by four spaces."
(interactive)
(if (use-region-p)
(let ((deactivate-mark nil))
(indent-rigidly (region-beginning) (region-end) -4))
(beginning-of-line)
(let ((start (point)))
(skip-chars-forward " " (min (+ start 4) (line-end-position)))
(delete-region start (point)))))

(global-set-key (kbd "M-[") #'my-unindent)
(global-set-key (kbd "M-]") #'my-indent)

;;; -*- lexical-binding: t -*-

(custom-set-variables
'(custom-safe-themes
'("e13beeb34b932f309fb2c360a04a460821ca99fe58f69e65557d6c1b10ba18c7"
default))
'(package-selected-packages '(gruber-darker-theme linum-relative)))

(custom-set-faces
'(whitespace-space ((t nil)))
'(whitespace-tab ((t nil))))

