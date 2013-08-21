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
; Disable toolbar in XEmacs
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
; Replace audible bell with visual one
(setq visible-bell t)
; ==================================================
; Package repositories
; ==================================================
(when (require 'package)
  ; ==================================================
  ; Marmalade
  ; ==================================================
  (add-to-list 'package-archives '("marmalade" . "http:/marlalade-repo.org/packages/"))
  ; ==================================================
  ; MELPA
  ; ==================================================
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  ; -- After all package managers have been added
  (package-initialize)
)
; Highlite current line
(when (require 'hl-line)
  (global-hl-line-mode t))
; Disable wrapping of long lines
;(setq-default truncate-lines t)
; Setup solarized theme (dark)
(load-theme 'solarized-dark t)
; ==================================================
; Auto Complete
; ==================================================
(add-to-list 'load-path "~/.emacs.d")
; Activate autocomplete mode
(when (require 'auto-complete nil t)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (when (require 'auto-complete-config)
    (ac-config-default))
  (ac-set-trigger-key "\t"))
; ==================================================
; IDO - Interactively Do Things
; ==================================================
(when (require 'ido) nil t) (ido-mode t))
; Load CEDET (For ECB)
; ==================================================
; CEDET     (For ECB)
; ==================================================
(add-to-list 'load-path "~/.emacs.d/cedet")
(when (require 'cedet "cedet/common/cedet.el" t)
  ; Recommended fix from: http://sourceforge.net/mailarchive/forum.php?thread_name=87mxl9lx0w.fsf%40randomsample.de&forum_name=cedet-semantic
  (semantic-mode t)
  (global-ede-mode 1))
; ==================================================
; ECB
; ==================================================
(add-to-list 'load-path "~/.emacs.d/ecb")
(setq-default ecb-tree-incremental-search (quote substring))
(when (require 'ecb nil t) ; Attempt to load ECB, failing gracefully
  ; Incremental search (substring / prefix)
  ;(require 'ecb-autoloads)
)

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


