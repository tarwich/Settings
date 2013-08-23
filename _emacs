(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

; ==================================================
;
;
; El-Get
;
;
; ==================================================

; Install El-Get (Downloading if necessary)
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

; Add Marmalade to the package repository list. I don't know why I put this here. Don't know if it's being used. 
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

; Tell El-Get where to... get... things
(setq el-get-sources '(
		       (:name cedet :type http :url "http://downloads.sourceforge.net/project/cedet/cedet/cedet-1.1.tar.gz")
		       (:name color-theme-solarized :after (progn (load-theme 'solarized-dark t) (setq ecb-tip-of-the-day nil)))
		       (:name ecb :type github :url "https://github.com/alexott/ecb")
		       (:name hl-line :type builtin :after (global-hl-line-mode t))
		       (:name ido :type builtin :after (ido-mode t))
		       ))
; Install El-Get things
(el-get nil '(
	      cedet			; Needed for ECB
	      color-theme-solarized	; Solarized color theme
	      ecb			; IDE layout
	      el-get			; El-Get. I think this should keep El-Get upgraded, but I'm not sure
	      hl-line			; Highlight current line
	      ido			; Interactively do things
	      ido-ubiquitous		; Use IDO nearly everywhere
	      tabbar                    ; Bar to show buffer in tabs 
	      yaml-mode			; Interactively do things
	      php-mode                  ; PHP mode
))

; Completely disable backup files
(setq make-backup-files nil)
(setq-default make-backup-files nil)
(setq auto-save-default nil)
; Disable toolbar in XEmacs
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
; Replace audible bell with visual one
(setq visible-bell t)
; Highlite current line
(when (require 'hl-line)
  (global-hl-line-mode t))
; Disable wrapping of long lines
;(setq-default truncate-lines t)

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

; TODO: Learn how to define a key for a mode
(global-set-key (kbd "S-<return>") 'newline-after)
; Home + End
(global-set-key (kbd "s-<down>") 'end-of-buffer)
(global-set-key (kbd "s-<up>") 'beginning-of-buffer)
; Tabbar next / prev
(global-set-key (kbd "s-}") 'tabbar-forward)
(global-set-key (kbd "s-{") 'tabbar-backward)
; C-Tab --> Insert tab
; TODO: Learn how to define a key for a mode
(global-set-key (kbd "C-<tab>") (lambda () (interactive) (insert "\t")))
; Change RET to newline-and-indent
; TODO: Learn how to define a key for a mode
;(global-set-key (kbd "<return>") 'newline-and-indent)

