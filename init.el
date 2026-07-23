;;-*- lexical-binding: t; -*-
;;;M-x elisp-enable-lexical-binding RET
;;
;;
;; 2024.12.16
;; 2025.06.20 Update 
;;
;;
;;
;;



(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")))
  (package-initialize)
  (use-package leaf :ensure t)

  (leaf leaf-keywords
    :ensure t
    :init
    (leaf blackout :ensure t)
    :config
    (leaf-keywords-init)))

(leaf leaf-convert
  :doc "Convert many format to leaf format"
  :ensure t)

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf mozc
  :ensure t
  :config
  :custom
  (default-input-method . "japanese-mozc")
  (mozc-helper-program-name  . "mozc_emacs_helper")
  (mozc-leim-title . "♡かな")
)


(leaf autorevert
  :doc "revert buffers when files on disk change"
  :global-minor-mode global-auto-revert-mode)

(leaf delsel
  :doc "delete selection if you insert"
  :global-minor-mode delete-selection-mode)


;;
;; macrostep. paren.delimiter.higtlight
;;


(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))


(leaf rainbow-delimiters
  :ensure t
  :hook
  (prog-mode-hook . rainbow-delimiters-mode)
  )

(leaf paren
  :ensure t
  :hook
  (after-init-hook . show-paren-mode)
  :custom-face
  (show-paren-match . '((nil (:background "#44475a" :foreground "#f1fa8c"))))  
  :custom ((show-paren-style . 'mixed)
           (show-paren-when-point-inside-paren . t)
           (show-paren-when-point-in-periphery . t))
  )

;;(leaf  highlight-indent-guides
;;  :ensure t
;;  :custom
;;  (highlight-indent-guides-method  . 'character)
;;  (highlight-indent-guides-auto-enabled . nil)
;;  (highlight-indent-guides-responsive . t)
;;  (highlight-indent-guides-character . ?\|)
;;  (highlight-indent-guides-delay . 0)
;;  :hook
;;  (prog-mode-hook . highlight-indent-guides-mode)
;;  :config
  ;;  (set-face-background 'highlight-indent-guides-odd-face "Dimgrey")
  ;;  (set-face-background 'highlight-indent-guides-even-face "DimGrey")
;;  (set-face-foreground 'highlight-indent-guides-character-face "dimgrey")
;;  )


(leaf simple
  :doc "basic editing commands for Emacs"
  :custom ((kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

(leaf flymake
  :doc "A universal on-the-fly syntax checker"
  :bind ((prog-mode-map
          ("M-n" . flymake-goto-next-error)
          ("M-p" . flymake-goto-prev-error))))

(leaf which-key
  :doc "Display available keybindings in popup"
  :ensure t
  :global-minor-mode t)


(leaf exec-path-from-shell
  :doc "Get environment variables such as $PATH from the shell"
  :ensure t
  :defun (exec-path-from-shell-initialize)
  :custom ((exec-path-from-shell-check-startup-files)
           (exec-path-from-shell-variables . '("PATH" "GOPATH" "JAVA_HOME")))
  :config
  (exec-path-from-shell-initialize))

(leaf vertico
  :doc "VERTical Interactive COmpletion"
  :ensure t
  :global-minor-mode t)

(leaf marginalia
  :doc "Enrich existing commands with completion annotations"
  :ensure t
  :global-minor-mode t)

(leaf consult
  :doc "Consulting completing-read"
  :ensure t
  :hook (completion-list-mode-hook . consult-preview-at-point-mode)
  :defun consult-line
  :preface
  (defun c/consult-line (&optional at-point)
    "Consult-line uses things-at-point if set C-u prefix."
    (interactive "P")
    (if at-point
        (consult-line (thing-at-point 'symbol))
      (consult-line)))
  :custom ((xref-show-xrefs-function . #'consult-xref)
           (xref-show-definitions-function . #'consult-xref)
           (consult-line-start-from-top . t))
  :bind (;; C-c bindings (mode-specific-map)
         ([remap switch-to-buffer] . consult-buffer) ; C-x b
         ([remap project-switch-to-buffer] . consult-project-buffer) ; C-x p b

         ;; M-g bindings (goto-map)
         ([remap goto-line] . consult-goto-line)    ; M-g g
         ([remap imenu] . consult-imenu)            ; M-g i
         ("M-g f" . consult-flymake)

         ;; C-M-s bindings
         ("C-s" . c/consult-line)       ; isearch-forward
         ("C-M-s" . nil)                ; isearch-forward-regexp
         ("C-M-s s" . isearch-forward)
         ("C-M-s C-s" . isearch-forward-regexp)
         ("C-M-s r" . consult-ripgrep)

         (minibuffer-local-map
          :package emacs
          ("C-r" . consult-history))))



(leaf affe
  :doc "Asynchronous Fuzzy Finder for Emacs"
  :ensure t
  :custom ((affe-highlight-function . 'orderless-highlight-matches)
           (affe-regexp-function . 'orderless-pattern-compiler))
  :bind (("C-M-s r" . affe-grep)
         ("C-M-s f" . affe-find)))


(leaf orderless
  :doc "Completion style for matching regexps in any order"
  :ensure t
  :custom ((completion-styles . '(orderless))
           (completion-category-defaults . nil)
           (completion-category-overrides . '((file (styles partial-completion))))))

(leaf embark-consult
  :doc "Consult integration for Embark"
  :ensure t
  :bind ((minibuffer-mode-map
          :package emacs
          ("M-." . embark-dwim)
          ("C-." . embark-act))))

(leaf corfu
  :doc "Completion in Region FUnction"
  :ensure t
  :global-minor-mode global-corfu-mode corfu-popupinfo-mode
  :custom ((corfu-auto . t)
           (corfu-auto-delay . 0)
           (corfu-auto-prefix . 1)
           (corfu-popupinfo-delay . nil)) ; manual
  :bind ((corfu-map
          ("C-s" . corfu-insert-separator))))

(leaf cape
  :doc "Completion At Point Extensions"
  :ensure t
  :config
  (add-to-list 'completion-at-point-functions #'cape-file))





(leaf puni
  :doc "Parentheses Universalistic"
  :ensure t
  :global-minor-mode puni-global-mode
  :bind (puni-mode-map
         ;; default mapping
         ;; ("C-M-f" . puni-forward-sexp)
         ;; ("C-M-b" . puni-backward-sexp)
         ;; ("C-M-a" . puni-beginning-of-sexp)
         ;; ("C-M-e" . puni-end-of-sexp)
         ;; ("M-)" . puni-syntactic-forward-punct)
         ;; ("C-M-u" . backward-up-list)
         ;; ("C-M-d" . backward-down-list)
         ("C-)" . puni-slurp-forward)
         ("C-}" . puni-barf-forward)
         ("M-(" . puni-wrap-round)
         ("M-s" . puni-splice)
         ("M-r" . puni-raise)
         ("M-U" . puni-splice-killing-backward)
         ("M-z" . puni-squeeze))
  :config
  
  (leaf elec-pair
    :doc "Automatic parenthesis pairing"
    :global-minor-mode electric-pair-mode))




(leaf *treesit
         ;;(setq treesit-font-lock-level 4)
  :custom ((treesit-font-lock-level . 4)
	   )
  :config
  (require 'treesit)
  ;;  (add-to-list 'auto-mode-alist '("\\.clj[sc]?\\'" . clojure-mode))
  ;;  (add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))
  ;;  (add-to-list 'treesit-language-source-alist
  ;;             '(conao3-clojure "https://github.com/conao3-playground/tree-sitter-conao3-clojure"))
  (add-to-list 'treesit-language-source-alist
	       '(yaml "https://github.com/ikatyang/tree-sitter-yaml"))
   ;; 
  (add-to-list 'auto-mode-alist '( "CMakeLists\\.txt\\'" . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '( "\\.cmake\\'". cmake-ts-mode))
  (add-to-list 'auto-mode-alist '( "\\.py$'". python-mode))
  (add-to-list 'auto-mode-alist '( "\\.json\\'". js-json-mode))
  (add-to-list 'auto-mode-alist '( "\\.php\\'". php-ts-mode))
  (add-to-list 'auto-mode-alist '( "\\.yaml\\'". yaml-ts-mode))
  (add-to-list 'auto-mode-alist '( "\\.yam\\'". yaml-ts-mode))
  ;;
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))  
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-to-list 'major-mode-remap-alist '(cmake-mode . cmake-ts-mode))
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  (add-to-list 'major-mode-remap-alist '(js-json-mode . json-ts-mode))
  (add-to-list 'major-mode-remap-alist '(php-mode . php-ts-mode))
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode))
  )



;;
;;
;; Set indent off set = 4 
;; Set tab-width      = 4 
;;
(add-hook 'c++-ts-mode-hook
          (lambda ()
	    
            (setq-local tab-width 4)
            (setq-local indent-tabs-mode t) ; Tab文字で揃えるなら t
            ;; 行頭インデント幅（tree-sitter系で効くことが多い）
            (setq-local c-ts-mode-indent-offset 4)
            (setq-local c-basic-offset 4)
	    (setq-local c-auto-newline t)
	    ))

;;
;; eglot
;;
(leaf eglot
  :doc "The Emacs Client for LSP servers"
  :ensure t
  :config
  ;;(add-to-list 'eglot-server-programs '(python-mode "pylsp"))
  ;;(add-to-list 'eglot-server-programs '(cmake-ts-mode "cmake-language-server"))
  ;;(add-to-list 'eglot-server-programs '((c++-mode c-mode) "ccls"))
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
  
  ;; eglot  と　clangd のインデント設定を無効化する
  (with-eval-after-load 'eglot  (add-to-list 'eglot-ignored-server-capabilities :documentFormattingProvider))
  (with-eval-after-load 'eglot  (add-to-list 'eglot-ignored-server-capabilities :documentRangeFormattingProvider))
  
  :hook ((c-ts-mode-hook . eglot-ensure)
	 (c++-ts-mode-hook . eglot-ensure)
	 ;;(python-ts-mode-hook . eglot-ensure)
	 ;;(cmake-ts-mode-hook . eglot-ensure)
	 )
  :custom ((eldoc-echo-area-use-multiline-p . nil)
           (eglot-connect-timeout . 600) )
  )






(leaf eglot-booster
  :when (executable-find "emacs-lsp-booster")
  :vc ( :url "https://github.com/jdtsmith/eglot-booster")
  :global-minor-mode t)




(leaf projectile
  :ensure t
  :config
  (projectile-mode +1)
  ;; Recommended keymap prefix on Windows/Linux
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  )


(leaf ag
  :ensure t)
(leaf rg
  :ensure t)

;;
;; Treemacs 
;;
;;
(leaf treemacs
  :ensure t
  :bind
  ;;((define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
  (:treemacs-mode-map ([mouse-1] . #'treemacs-single-click-expand-action))
  (("C-x t t"   . treemacs)
   ("M-0"       . treemacs-select-window)
   ("C-x t 1"   . treemacs-delete-other-windows)
   ("C-x t d"   . treemacs-select-directory)
   ("C-x t B"   . treemacs-bookmark)
   ("C-x t C-t" . treemacs-find-file)
   ("C-x t M-t" . treemacs-find-tag))
  :custom
  
  (progn 'treemacs
	 (custom-set-variables
	  '(treemacs-collapse-dirs                   (if (executable-find "python3") 3 0) )
	  '(treemacs-collapse-dirs                   (if treemacs-python-executable 3 0) )
	  '(treemacs-deferred-git-apply-delay        0.5)
	  '(treemacs-directory-name-transformer      #'identity)
	  '(treemacs-display-in-side-window          t	)
          '(treemacs-eldoc-display                   'simple)
          '(treemacs-file-event-delay                2000)
          '(treemacs-file-extension-regex            treemacs-last-period-regex-value)
          '(treemacs-file-follow-delay               0.2)
	  '(treemacs-file-name-transformer           #'identity)
          '(treemacs-follow-after-init               t)
          '(treemacs-expand-after-init               t)
          '(treemacs-find-workspace-method           'find-for-file-or-pick-first)
          '(treemacs-goto-tag-strategy               'refetch-index)
          '(treemacs-header-scroll-indicators        '(nil . "^^^^^^"))
          '(treemacs-hide-dot-git-directory          t)
          '(treemacs-indentation                     2)
          '(treemacs-indentation-string              " ")
          '(treemacs-is-never-other-window           nil)
          '(treemacs-max-git-entries                 5000)
          '(treemacs-missing-project-action          'ask)
          '(treemacs-move-files-by-mouse-dragging    t)
          '(treemacs-move-forward-on-expand          nil)
          '(treemacs-no-png-images                   nil)
          '(treemacs-no-delete-other-windows         t)
          '(treemacs-project-follow-cleanup          nil)
          '(treemacs-persist-file       (expand-file-name ".cache/treemacs-persist" user-emacs-directory))
          '(treemacs-position                        'left)
          '(treemacs-read-string-input               'from-child-frame)
          '(treemacs-recenter-distance               0.1)
          '(treemacs-recenter-after-file-follow      nil)
          '(treemacs-recenter-after-tag-follow       nil)
          '(treemacs-recenter-after-project-jump     'always)
          '(treemacs-recenter-after-project-expand   'on-distance)
          '(treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask"))
          '(treemacs-project-follow-into-home        nil)
          '(treemacs-show-cursor                     nil)
          '(treemacs-show-hidden-files               t)
          '(treemacs-silent-filewatch                nil)
          '(treemacs-silent-refresh                  nil)
          '(treemacs-sorting                         'alphabetic-asc)
          '(treemacs-select-when-already-in-treemacs 'move-back)
          '(treemacs-space-between-root-nodes        t)
          '(treemacs-tag-follow-cleanup              t)
          '(treemacs-tag-follow-delay                1.5)
          '(treemacs-text-scale                      nil)
          '(treemacs-user-mode-line-format           nil)
          '(treemacs-user-header-line-format         nil)
          '(treemacs-wide-toggle-width               70)
          '(treemacs-width                           35)
          '(treemacs-width-increment                 1)
          '(treemacs-width-is-initially-locked       t)
          '(treemacs-workspace-switch-cleanup        nil)
	  ;;
	  '(foo-package-to-enable t "Customized with leaf in foo-package block")
          '(foo-package-to-disable nil "Customized with leaf in foo-package block")
          '(foo-package-to-symbol 'symbol "Customized with leaf in foo-package block")
          '(foo-package-to-function #'ignore "Customized with leaf in foo-package block")
          '(foo-package-to-lambda (lambda (elm) (message elm)) "Customized with leaf in foo-package block"))
	 ;;
	 ;; The default width and height of the icons is 22 pixels. If you are
	 ;; using a Hi-DPI display, uncomment this to double the icon size.
	 ;;(treemacs-resize-icons 44)
	 (treemacs-follow-mode . t)
	 (treemacs-filewatch-mode . t)
	 (treemacs-fringe-indicator-mode . 'always)
	 ;;(treemacs-fringe-indicator-mode . 'only-when-focused)
	 ;;(treemacs-git-mode . 'deferred)	 
	 (treemacs-git-mode . 'simple)
	 )
  :hook
  (treemacs-mode-hook . (lambda ()
			  (setq mode-line-format nil)
			  (display-line-numbers-mode 0)))
)


(leaf treemacs-evil
  :after (treemacs evil)
  :ensure t)

(leaf treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(leaf treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(leaf treemacs-magit
  :after (treemacs magit)
  :ensure t)



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


