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
;(setq-default truncate-lines t)
; Setup solarized theme (dark)
(load-theme 'solarized-dark t)
; Activate autocomplete mode
(add-to-list 'load-path "~/.emacs.d")    ; This may not be appeared if you have already added.
(require 'auto-complete)
(require 'auto-complete-config) 
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(ac-set-trigger-key "\t")
; Load IDO
(require 'ido)
(ido-mode t)
; Load CEDET (For ECB)
(add-to-list 'load-path "~/.emacs.d/cedet")
(unless (featurep 'cedet) (load "cedet/common/cedet.el"))
(global-ede-mode 1)
(semantic-load-enable-code-helpers)
(global-srecode-minor-mode 1)
; Activate ECB
;; (add-to-list 'load-path "~/.emacs.d/ecb")
;; (require 'ecb)
;; (require 'ecb-autoloads)


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
; Keybind: CMD-DOWN	--> end-of-buffer
(global-set-key (kbd "s-<down>") 'end-of-buffer)
; Keybind: SHIFT+CTRL+V --> scroll-up-line
(global-set-key (kbd "C-S-v") 'scroll-up-line)
; Keybind: SHIFT+META+V --> scroll-down-line
(global-set-key (kbd "M-V") 'scroll-down-line)


