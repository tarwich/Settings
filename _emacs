; -*- mode: ELisp ;-*-


; ==================================================
; 
; 
; Settings
; 
; 
; ==================================================

; Completely disable backup files
(setq make-backup-files nil)
; Replace audible bell with visual one
(setq visible-bell t)
; Add marmalade to package manager
(require 'package)
(add-to-list 'package-archives '("marlalade" . "http:/marlalade-repo.org/packages/"))
(package-initialize)
; Add MELPA to package manager
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
; Highlite current line
(require 'hl-line)
(global-hl-line-mode t)
; Disable wrapping of long lines
(toggle-truncate-lines t)

; ==================================================
; 
; 
; Functions
; 
; 
; ==================================================

; ==================================================
; newline-after
; --------------------------------------------------
; Function for adding a newline after current
; ==================================================
(defun newline-after ()
  (interactive)
  (end-of-line)
  (newline-and-indent)
)


; ==================================================
; 
; 
; Keybinds
; 
; 
; ==================================================

; Keybind: SHIFT+RETURN --> newline-after
(global-set-key (kbd "S-<return>") 'newline-after)
; Keybind: CMD-UP	--> beginning-of-buffer
(global-set-key (kbd "s-<up>") 'beginning-of-buffer)
; Keybing: CMD-DOWN	--> end-of-buffer
(global-set-key (kbd "s-<down>") 'end-of-buffer)
