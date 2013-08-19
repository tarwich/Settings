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
