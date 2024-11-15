;;; package --- Summary
;;; Commentary:
;;; Code:

;;(require 'profiler)
;;(profiler-start 'cpu)



;;; For Warnig  cl deprecated .....
(setq byte-compile-warnings '(not cl-functions obsolete))


;;; mozc 
(require 'mozc)
(setq default-input-method "japanese-mozc")
;;(set-input-method "japanese-mozc")
;;(setq mozc-candidate-style 'overlay)



;; Leaf 
;;  this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
  (package-refresh-contents)
  (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
       (leaf hydra :ensure t)
    ;; (leaf el-get :ensure t) 
       (leaf blackout :ensure t)
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init))
  )



;; Now you can use leaf!

(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left)))
  )

;;(leaf macrostep
;;  :ensure t
;;  :bind (("C-c e" . macrostep-expand))
;;  )

;;(leaf transient-dwim
;;  :ensure t
;;  :bind (("M-=" . transient-dwim-dispatch))
;;  )

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :custom ((flycheck-emacs-lisp-initialize-packages . t))
  :hook (emacs-lisp-mode-hook lisp-interaction-mode-hook)
  :config
  (leaf flycheck-package
    :doc "A Flycheck checker for elisp package authors"
    :ensure t
    :config
    (flycheck-package-setup))

  (leaf flycheck-elsa
    :doc "Flycheck for Elsa."
    :emacs>= 25
    :ensure t
    :config
    (flycheck-elsa-setup))
  )

;;
;; For lsp-mode
;;
(leaf *lsp-basic-settings  
  :url "https://github.com/emacs-lsp/lsp-mode#supported-languages"
  :url "https://github.com/MaskRay/ccls/wiki/lsp-mode#find-definitionsreferences"
  :doc "lsp is language server protocol"
  ;;:when (version<= "25.1" emacs-version)
  :config

  ;; lsp-mode
  (leaf lsp-mode
    :ensure t
    :commands lsp
    :custom
    (
    ;; (lsp-enable-snippet . t)
    ;; (lsp-enable-indentation . nil)
    ;; (lsp-prefer-flymake . nil)
    ;; (lsp-document-sync-method . 'incremental)
    ;; (lsp-inhibit-message . t)
    ;; (lsp-message-project-root-warning . t)
    ;; (create-lockfiles . nil)
     (lsp-file-watch-threshold . nil)
    ;; (lsp-completion-enable-additional-text-edit . nil)
     )
    :preface (global-unset-key (kbd "C-l"))
    :bind
    (
     ("C-l C-l"  . lsp)
    ;; ("C-l h"    . lsp-describe-session)
    ;; ("C-l t"    . lsp-goto-type-definition)
    ;; ("C-l r"    . lsp-rename)
    ;; ("C-l <f5>" . lsp-workspace-restart)
    ;; ("C-l l"    . lsp-lens-mode)
     )
    :hook
    (prog-major-mode-hook . lsp-prog-major-mode-enable)
    )

  (leaf lsp-ui
    :ensure t
    :commands lsp-ui-mode
    :after lsp-mode
    :custom
    :hook (lsp-mode-hook . lsp-ui-mode)
    :bind
    :config
    )

  (leaf lsp-treemacs
    :ensure t
    :after treemacs lsp-mode
    )

  (leaf *lsp-setting
    :config
    ;; ccls
    ;; c,c++のLSP server
    (leaf ccls
      :doc "Ccls client for lsp-mode."
      :req "emacs-27.1" "lsp-mode-6.3.1" "dash-2.14.1"
      :tag "c++" "lsp" "languages" "emacs>=27.1"
      :url "https://github.com/emacs-lsp/emacs-ccls"
      :added "2024-11-01"
      :emacs>= 27.1
      :ensure t
      :custom
      (ccls-executable .  "/usr/local/bin/ccls")
      (ccls-sem-highlight-method . 'font-lock)
      (ccls-use-default-rainbow-sem-highlight .)
      :hook ((c-mode-hook c++-mode-hook objc-mode-hook) .
            (lambda () (require 'ccls) (lsp)))
      :after lsp-mode
      )
    )
  )




(leaf yasnippet
  :ensure t
  :config (yas-global-mode))

;;(leaf which-key
;;  :ensure t
;;  :config (which-key-mode))


(leaf electric
  :doc "window maker and Command loop for `electric' modes"
  :tag "builtin"
  :added "2024-11-01"
  :init (electric-pair-mode 1))

(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t)
  )

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)
  
(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)


(provide 'init)




;;;
;;; This will enable emacs to compile a simple cpp single file without any makefile by just pressing [f9] key
;;;
(defun code-compile()
  (interactive)
  (unless (file-exists-p "Makefile")
    (set (make-local-variable 'compile-command)
	 (let ((file (file-name-nondirectory buffer-file-name)))
	   (format "%s -o %s %s"
		   (if (equal (file-name-extension file) "cpp") "g++" "gcc")
		   (file-name-sans-extension file)
		   file)))
    (compile compile-command)))
(global-set-key [f9] 'code-compile)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;'(column-number-mode t)
 ;;'(global-display-line-numbers-mode t)
 
 '(package-selected-packages
   '(yasnippet-snippets flycheck-elsa flycheck-package ivy-prescient prescient counsel swiper ivy which-key yasnippet ccls lsp-treemacs lsp-ui lsp-mode flycheck transient-dwim macrostep leaf-tree leaf-convert blackout hydra leaf-keywords))
 '(tool-bar-mode nil))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "NasuM" :foundry "Mig " :slant normal :weight regular :height 113 :width normal)))))


;;(profiler-report)
;;(profiler-stop)

