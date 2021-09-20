;; $Id: emacsrc,v 1.10 2021/09/20 15:40:09 manuel Exp edi $

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-guess-guessed-basic-offset 2 t)
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(gdb-many-windows t)
 '(global-display-line-numbers-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(next-line-add-newlines nil)
 '(package-selected-packages '(realgud))
 '(require-final-newline t)
 '(scroll-step 1)
 '(select-enable-clipboard t)
 '(tool-bar-mode nil)
 '(tool-bar-position 'right)
 '(vc-follow-symlinks t)
 ;;'(desktop-save-mode 1)
 '(x-select-enable-clipboard-manager nil))
 

;;  '(cua-mode t nil (cua-base))


;;; Fontin asetus oli emacs 25.1:ssä:
;(add-to-list 'default-frame-alist
;             '(font . "Consolas-9"))
;(add-to-list 'default-frame-alist
;             '(font . "Liberation Mono-9"))


;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
; '(default ((t (:family "Liberation Mono" :foundry "1ASC" :slant normal :weight normal :height 83 :width normal)))))

;(global-set-key (kbd "M-<down>") 'scroll-up-line)
;(global-set-key (kbd "M-<up>")   'scroll-down-line)
;(global-set-key (kbd "C-n")     'scroll-up-line)
;(global-set-key (kbd "C-p")     'scroll-down-line)

;(global-set-key (kbd "<mouse-3>")     'x-clipboard-yank)
;(setq w32-swap-mouse-buttons t)

(global-set-key (kbd "<mouse-3>")  'copy-region-as-kill)



;;;;;;;;;;;;;;;;;;;;;; MELPA  (see https://github.com/realgud/realgud)
 (require 'package)
 (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
 (package-initialize)

;;;;;;;;;;;;;;;;;;;;;; BASHDB helper for large bash files ;;;;;;;;;;;;;;;;;;;;;;;;
; See https://github.com/realgud/realgud/wiki/bashdb-notes
;
(defun bashdb-large (&optional opt-cmd-line no-reset)
  (interactive)
  (let ((cmd-buf
	 (realgud:run-debugger "bashdb"
			       'bashdb-query-cmdline
			       'bashdb-parse-cmd-args
			       'realgud:bashdb-minibuffer-history
			       opt-cmd-line no-reset)
	 ))
    (if cmd-buf
	(let ((process (get-buffer-process cmd-buf)))
	  (if (and process (eq 'run (process-status process)))
	      (with-current-buffer cmd-buf
		(sleep-for 0.1)   ; was 1
		(realgud-command "frame 0" nil nil nil)
		)))
      )
    ))

;; bash debug layout definition
;; https://emacs.stackexchange.com/questions/822/how-to-setup-default-windows-at-startup
;; https://emacs.stackexchange.com/questions/41242/how-to-autoscroll-a-window-to-always-show-the-end-of-a-growing-buffer
;; https://emacs.stackexchange.com/questions/582/how-to-change-size-of-split-screen-emacs-windows
(defun bash-debug-layout ()
 (interactive)
 (delete-other-windows)
 ;(split-window-horizontally) ;; -> |
 ;(next-multiframe-window)
 ;(find-file "~/.emacs.d/init.el")
 ;(split-window-vertically) ;;  -> --
 (split-window-below -10)
 (next-multiframe-window)
 ;(goto-char (point-max))
 ;(find-file "~/.emacs.d/init_settings.el")
 ;(next-multiframe-window)
 ;(dired "~")
 (realgud:bashdb-large)
 ;(end-of-buffer)
 (shrink-window-if-larger-than-buffer)
 (sleep-for 0.1)   ; was 1
 (goto-char (point-max))
)

(autoload 'realgud:bashdb-large "realgud")       ;(load-library "realgud")

(set-variable 'realgud-safe-mode nil)

;(global-set-key (kbd "<f2>")   'realgud:bashdb-large)
(global-set-key (kbd "<f2>")   'bash-debug-layout)

(global-set-key (kbd "<f4>")   'realgud:cmd-break)
(global-set-key (kbd "C-<f4>") 'realgud:cmd-clear)           ; removes breakpoint but visually does nothing!
(global-set-key (kbd "<f5>")   'realgud:cmd-continue)

(global-set-key (kbd "<f10>")  'realgud:cmd-next)
(global-set-key (kbd "<f11>")  'realgud:cmd-step)

(global-set-key (kbd "<f8>")  'delete-window)              ; meant for killing the bash command window

;;; This will be added automatically if you change default font:
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight normal :height 93 :width normal)))))

;;; Markdown mode:
;(autoload 'gfm-mode "markdown-mode.el"
;   "Major mode for editing Github Flavored Markdown files" t)
;(setq auto-mode-alist
;   (cons '("\.md" . gfm-mode) auto-mode-alist))
