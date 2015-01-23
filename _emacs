
;; ==================================================
;;
;;
;; El-Get
;;
;;
;; ==================================================

;; Install El-Get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

;; Install packages
(el-get-bundle color-theme-solarized)
(el-get-bundle ido-ubiquitous)

;; ==================================================
;;
;; 
;; Configure General Settings
;;
;; 
;; ==================================================

;; Completely disable backup files
(setq make-backup-files nil)
(setq-default make-backup-files nil)
(setq auto-save-default nil)
;; Disable toolbar in XEmacs
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; Replace audible bell with visual one
(setq visible-bell t)
;; Highlite current line
(when (require 'hl-line)
  (global-hl-line-mode t))
;; Disable wrapping of long lines
;;(setq-default truncate-lines t)
;; Set tab width to 4 spaces ... globally
(setq-default tab-width 4)
;; Don't let align-regexp use tabs
(defadvice align-regexp (around align-regexp-with-spaces activate)
  (let ((indent-tabs-mode nil))
    ad-do-it))
;; Globally enable IDO-Mode (Interactively do things)
(ido-mode 1)
(ido-ubiquitous-mode 1)
;; Enable the solarized theme
;(color-theme-initialize)
;(setq color-theme-is-global t)
;(require 'color-theme-solarized)
(setq solarized-termcolors 256)
(color-theme-solarized-dark)
;(load-theme 'solarized-dark t)
;; Set the hl-line background
(set-face-background 'hl-line "#e4e4e4")
;(set-face-background 'default "#262626")



;; ==================================================
;;
;;
;; Functions
;;
;;
;; ==================================================

;; ==================================================
;; newline-after
;; --------------------------------------------------
;; Function for adding a newline after current
;; ==================================================
(defun newline-after ()
  (interactive)
  (end-of-line)
  (newline-and-indent)
  )


;; ==================================================
;;
;;
;; Keybinds
;;
;;
;; ==================================================

										; TODO: Learn how to define a key for a mode
(global-set-key (kbd "S-<return>") 'newline-after)
										; Home + End
(global-set-key (kbd "s-<down>") 'end-of-buffer)
(global-set-key (kbd "s-<up>") 'beginning-of-buffer)
										; Tabbar next / prev
(global-set-key (kbd "s-}") 'tabbar-forward)
(global-set-key (kbd "s-{") 'tabbar-backward)
										; C-Tab --> Insert tab
(global-set-key (kbd "C-<tab>") (lambda () (interactive) (insert "\t")))
										; Change RET to newline-and-indent
;;(global-set-key (kbd "<return>") 'newline-and-indent)



