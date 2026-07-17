;;; package --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;; ---
;; ---  20241116 

(setq package-enable-at-startup nil)

(toggle-scroll-bar nil)              ;; For making scroll bar invisible
;;(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)


(setq inhibit-startup-message t)	   ;Spulash off
(setq initial-scratch-message nil)
(setq initial-major-mode 'fundamental-mode)
;;(setq inhibit-startup-echo-area-message t) ;Erase strings on initial *scratch* buffer 
;;(setq initial-scratch-message "")

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)
(setq create-lockfiles nil)

;;(setq gc-cons-threshold (* 10 128 1024 1024))
(setq gc-cons-threshold (* 40 gc-cons-threshold)) ; 800K * n
(setq garbage-collection-messages nil)


;;(setq read-process-output-max (* 8 1024 1024))

(setq inhibit-compacting-font-caches t)

(setq history-delete-duplicates t)

(setq vc-follow-symlinks t)



(define-key key-translation-map [?\C-h] [?\C-?])



;;
;; display and set global line number
;;
(setq column-number-mode t)
(global-display-line-numbers-mode t)

;; asking (yes or no) exchange to (y or n)
(defalias 'yes-or-no-p 'y-or-n-p)
;; Set initial frame size and position
(setq initial-frame-alist
      (append   '((top . 0) (left . 1000) (width . 115) (height . 1280)) initial-frame-alist)
      )



 ;; スクロールした際のカーソルの移動行数
 (setq scroll-conservatively 1)
 
 ;; スクロール開始のマージンの行数
(setq scroll-margin 5)

 
 
 ;; 1 画面スクロール時に重複させる行数
(setq next-screen-context-lines 5) 
 
 ;; 1 画面スクロール時にカーソルの画面上の位置をなるべく変えない
 (setq scroll-preserve-screen-position t)
 









;; 
;; Dracula theme  
;;               github dracula/emacs
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)
;; Don't change the font size for some headings and titles (default t)
;;(setq dracula-enlarge-headings nil)
;; Adjust font size of titles level 1 (default 1.3)
(setq dracula-height-title-1 1.25)
;; Adjust font size of titles level 2 (default 1.1)
(setq dracula-height-title-2 1.15)
;; Adjust font size of titles level 3 (default 1.0)
(setq dracula-height-title-3 1.05)
;; Adjust font size of document titles (default 1.44)
(setq dracula-height-doc-title 1.4)
;; Use less pink and bold on the mode-line and minibuffer (default nil)
(setq dracula-alternate-mode-line-and-minibuffer t)
;; Use normal weight for syntax faces like keywords, functions, and variables (default t)
(setq dracula-bolder-keywords nil)
