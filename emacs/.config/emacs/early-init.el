;;; package --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;; ---
;; ---  20241116
;; ---  last update 2026.11.01
;;; Code:


                                        ; 起動時のGC閾値を極限まで引き上げ
(setq gc-cons-threshold most-positive-fixnum)
(setq garbage-collection-messages nil)

;; 起動時のファイル名ハンドラを一時無効化（ファイル読み込みを高速化）(マジックファイルネーム)
(defvar my-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; 起動完了後に上記の2個の設定を元に戻す
;;(add-hook 'emacs-startup-hook
;;          (lambda ()
;;            ;; GC閾値を実用的なサイズ（例: 16MB〜32MB）に戻す
;;            (setq gc-cons-threshold (* 64 1024 1024))
;;            ;; ファイルハンドラを復元
;;            (setq file-name-handler-alist my-file-name-handler-alist)
;;            (message "Emacs ready in %s with %d GCs." (emacs-init-time) gcs-done)))

;; 起動完了後に上記の2個の設定を元に戻す
(add-hook 'emacs-startup-hook
          (lambda ()
            ;; GC閾値を実用的なサイズに戻す
            (setq gc-cons-threshold (* 64 1024 1024))
            ;; ファイルハンドラを安全に結合して復元
            (setq file-name-handler-alist
                  (delete-dups (append file-name-handler-alist my-file-name-handler-alist)))
            (message "Emacs ready in %s with %d GCs." (emacs-init-time) gcs-done)))

;; 起動時のGUIのちらつき防止（フレーム描画前に行うべき設定）
(setq frame-inhibit-implied-resize t)
(setq initial-frame-alist
      (append '((background-color . "#282a36")
                (foreground-color . "#f8f8f2"))
              initial-frame-alist))
(setq default-frame-alist
      (append '((background-color . "#282a36")
                (foreground-color . "#f8f8f2"))
              default-frame-alist))

(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

(scroll-bar-mode 1)
;;(toggle-scroll-bar nil)

(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(global-set-key [f10] 'menu-bar-mode)
(setq create-lockfiles nil)

(push '(left . 1) initial-frame-alist)
(push '(fullscreen . maximized) default-frame-alist)
(setq resize-mini-windows nil)

(setq initial-major-mode 'fundamental-mode)


;; Windows11 MSYS2 の設定
;; 絶対PATHが無難
(when (eq system-type 'windows-nt)
  (dolist (path '("C:/msys64/ucrt64/bin"
                  "C:/msys64/usr/bin"))
    (when (file-directory-p path)
      (add-to-list 'exec-path path)
      (setenv "PATH"
              (concat path path-separator (getenv "PATH"))))))


(provide 'early-init)
;;; early-init.el ends here
