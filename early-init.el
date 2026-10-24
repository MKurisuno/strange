;;; package --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;; ---
;; ---  20241116

;;; Code:


; 起動時のGC閾値を極限まで引き上げ
(setq gc-cons-threshold most-positive-fixnum)
(setq garbage-collection-messages nil)

;; 起動時のファイル名ハンドラを一時無効化（ファイル読み込みを高速化）(マジックファイルネーム)
(defvar my-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; 起動完了後に上記の2個の設定を元に戻す
(add-hook 'emacs-startup-hook
          (lambda ()
            ;; GC閾値を実用的なサイズ（例: 16MB〜32MB）に戻す
            (setq gc-cons-threshold (* 34 1024 1024))
            ;; ファイルハンドラを復元
            (setq file-name-handler-alist my-file-name-handler-alist)
            (message "Emacs ready in %s with %d GCs." (emacs-init-time) gcs-done)))

;; 起動時のGUIのちらつき防止（フレーム描画前に行うべき設定）
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'fundamental-mode)
(toggle-scroll-bar nil)
(push '(tool-bar-lines . 0) default-frame-alist)
;;(push '(menu-bar-lines . 0) default-frame-alist)
(setq create-lockfiles nil)


;; Windows11 MSYS2 の設定
;; 絶対PATHが無難
(when (eq system-type 'windows-nt)
  (dolist (path '("C:/msys64/ucrt64/bin"
                  "C:/msys64/usr/bin"))
    (when (file-directory-p path)
      (add-to-list 'exec-path path)
      (setenv "PATH"
              (concat path path-separator (getenv "PATH"))))))


;;--- Set initial frame size and position
;;(setq initial-frame-alist
;;      (append   '((top . 0) (left . 1000) (width . 115) (height . 1100)) initial-frame-alist)
;;      )
;;--- Launch maximized on the monitor to the left.
;; A negative "left" value is measured from the right edge.
;;;(push '(left       .        -1) initial-frame-alist)
(push '(left       .        1) initial-frame-alist)
(push '(fullscreen . maximized) default-frame-alist)
(setq resize-mini-windows nil)


(provide 'early-init)
;;; early-init.el ends here
