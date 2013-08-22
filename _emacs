
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

; ==================================================
;
;
; El-Get
;
;
; ==================================================

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(setq el-get-sources '(
		       (:name cedet :type http :url "http://downloads.sourceforge.net/project/cedet/cedet/cedet-1.1.tar.gz"); Needed for ECB
		       (:name color-theme-solarized :after (progn (load-theme 'solarized-dark t) (setq ecb-tip-of-the-day nil)))				    ; Solarized color theme
		       (:name ecb :type github :url "https://github.com/alexott/ecb")					    ; IDE layout
		       (:name hl-line :type builtin :after (global-hl-line-mode t))					    ; Highlight current line
		       (:name ido :type builtin :after (ido-mode t))							    ; Interactively do things
		       ))

(el-get nil '(
	      ido
	      color-theme-solarized
	      cedet
	      ecb
	      hl-line
))

; Completely disable backup files
(setq make-backup-files nil)
; Disable toolbar in XEmacs
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
; Replace audible bell with visual one
(setq visible-bell t)
; Disable wrapping of long lines
;(setq-default truncate-lines t)



