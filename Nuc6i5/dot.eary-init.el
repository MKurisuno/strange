;;; package --- Summary
;;; Commentary:
;; ---
;; ---

(setq inhibit-startup-message t)	   ;Spulash off
(setq inhibit-startup-echo-area-message t) ;Erase strings on initial *scratch* buffer 
(setq initial-scratch-message "")
(toggle-scroll-bar nil)              ;; For making scroll bar invisible
(setq tool-bar-mode nil)                  ;; For making tool bar invisible



(setq column-number-mode t)
(global-display-line-numbers-mode t)
;;(setq linum-format "%12d")


(defalias 'yes-or-no-p 'u-or-n-p) 




(setq initial-frame-alist
      (append   '((top . 5) (left . 1550) (width . 140) (height . 140)) initial-frame-alist)
      )


;;(set-language-environment 'utf-8)
;;(set-default-coding-systems 'utf-8-unix)
;;(prefer-coding-system 'japanese-shift-jis)
;;(prefer-coding-system 'utf-8) 


(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)
