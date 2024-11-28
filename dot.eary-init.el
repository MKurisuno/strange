;;; package --- Summary
;;; Commentary:
;; ---
;; --- Nuc6i5 20241116 

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

(setq byte-compile-warnings '(cl-functions))




(setq column-number-mode t)
(global-display-line-numbers-mode t)

(defalias 'yes-or-no-p 'u-or-n-p) 
(setq initial-frame-alist
      (append   '((top . 5) (left . 1550) (width . 140) (height . 140)) initial-frame-alist)
      )

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)
