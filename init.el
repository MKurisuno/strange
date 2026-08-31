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

(when (version< emacs-version "30.0")
  (error "This requires Emacs 30.0 and above!"))

(defvar default-handlers file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist default-handlers)
            (setq gc-cons-threshold (* 16 1024 1024))
            (setq inhibit-message nil)
            (message "Emacs ready in %s with %d GCs."
                     (emacs-init-time) gcs-done)))


(set-face-attribute 'default nil :font (font-spec :family "JetBrains Mono" :size 14))
;;(set-face-attribute 'default nil :font (font-spec :family "Fira Code" :size 14))
(set-fontset-font t 'japanese-jisx0208
                  (font-spec :name "Noto Sans JP" :size 12 :height 85) nil 'prepend)
(set-fontset-font t 'cjk-misc
                  (font-spec :name "Noto Sans JP" :size 12 :height 85) nil 'prepend)



(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")))
  (package-initialize)
  (use-package leaf :ensure t)
  
  (leaf leaf-keywords
    :ensure t
    :init
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)
    :config
    (leaf-keywords-init))
  )




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
  (mozc-leim-title . "かな")
  (custom-set-faces
   '(mozc-preedit-selected-face
     ((t (:background "#1E2029" :foreground "#bd93f9" :weight bold)))))
  )

(with-eval-after-load 'mozc
  (set-face-attribute 'mozc-preedit-face nil :height 0.85
		      :foreground "#8BE9FD" :background "#28sA36" :weight 'bold)
  (set-face-attribute 'mozc-preedit-selected-face nil :height 0.90
		      :foreground "#8BE9FD" :background "#191A21" :weight 'bold)
  (set-face-attribute 'mozc-cand-overlay-focused-face nil :height 0.85
		      :foreground "#21222C":background "#BD93F9" :weight 'bold)
  (set-face-attribute 'mozc-cand-overlay-odd-face nil :height 0.85
		      :foreground "#FFFFFF" :background "#6272A4" ) 
  (set-face-attribute 'mozc-cand-overlay-even-face nil :height 0.85
		      :foreground "F8F8F2" :background "#282A36" ) 
  (set-face-attribute 'mozc-cand-overlay-footer-face nil :height 0.80
		      :foreground "#50FA7B" :background "#333844")
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
;;  (highlight-indent-guides-method  . 'column)
;;  (highlight-indent-guides-auto-enabled . t)
;;  (highlight-indent-guides-responsive . 'top)
;;  (highlight-indent-guides-delay . 0)
;;  :hook
;;  (prog-mode-hook . highlight-indent-guides-mode)
;;  :config
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
  :doc "VERTical Interactive Completion"
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
			  ("C-r" . consult-history))
	)
)



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
           (corfu-popupinfo-delay . nil)
	   ) ; manual
  :bind ((corfu-map
          ("C-s" . corfu-insert-separator)
	  ))
  )


(leaf cape
  :doc "Completion At Point Extensions"
  :ensure t
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-file)
  )





(leaf puni
  :doc "Parentheses Universalistic"
  :ensure t
  :global-minor-mode puni-global-mode
  :bind (:puni-mode-map
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


(leaf magit
  :when (version<= "25.1" emacs-version)
  :ensure t
  :preface
  (defun c/git-commit-a ()
    "Commit after add anything."
    (interactive)
    (shell-command "git add .")
    (magit-commit-create))
  :bind (("M-=" . hydra-magit/body))
  :hydra (hydra-magit
          (:hint nil :exit t)
          "
^^         hydra-magit
^^------------------------------
 _s_   magit-status
 _C_   magit-clone
 _c_   magit-commit
 _d_   magit-diff-working-tree
 _M-=_ magit-commit-create"
          ("s" magit-status)
          ("C" magit-clone)
          ("c" magit-commit)
          ("d" magit-diff-working-tree)
          ("M-=" c/git-commit-a)))







(leaf *treesit
  :custom ((treesit-font-lock-level . 4)
	   )
  :config
  (require 'treesit)
  ;;  (add-to-list 'auto-mode-alist '("\\.clj[sc]?\\'" . clojure-mode))
  ;;  (add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))
  (add-to-list 'treesit-language-source-alist
	       '(yaml "https://github.com/ikatyang/tree-sitter-yaml"))
   ;; 
  (add-to-list 'auto-mode-alist '( "CMakeLists\\.txt\\'" . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '( "\\.cmake\\'" . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '( "\\.py\\'" . python-mode))
  (add-to-list 'auto-mode-alist '( "\\.json\\'" . js-json-mode))
  (add-to-list 'auto-mode-alist '( "\\.php\\'". php-ts-mode))
  (add-to-list 'auto-mode-alist '( "\\.y?ml\\'". yaml-ts-mode))

  (add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-ts-mode))
  )



;; インデントの設定 c++-ts-mode 
(add-hook 'c++-ts-mode-hook
          (lambda ()
            (electric-indent-mode -1)
            (setq-local default-tab-width 4)
            (setq-local tab-width 4)
            (setq-local indent-tabs-mode t) 
	    (setq-local c-ts-mode-indent-offset 4)
            (setq-local c-basic-offset 4)))
(add-hook 'c-ts-mode-hook
          (lambda ()
            (electric-indent-mode -1)
            (setq-local default-tab-width 4)
            (setq-local tab-width 4)
            (setq-local indent-tabs-mode t) 
	    (setq-local c-ts-mode-indent-offset 4)
            (setq-local c-basic-offset 4)))



;;
;; eglot
;;
(leaf eglot
  :doc "The Emacs Client for LSP servers"
  :ensure t
  :config
  ;;(add-to-list 'eglot-server-programs '(cmake-ts-mode "cmake-language-server"))
  ;;(add-to-list 'eglot-server-programs '((c++-ts-mode c-ts-mode) "ccls"))
  (add-to-list 'eglot-server-programs '((c++-ts-mode) "clangd"))
  (add-to-list 'eglot-server-programs '((c-ts-mode) "clangd"))
  (add-to-list 'eglot-server-programs '(php-mode . ("intelephense" "--stdio")))
  (add-to-list 'eglot-server-programs   '(python-mode . ("pyright-langserver" "--stdio")))
  (setopt eglot-autoshutwon t)
  (setopt eglot-sync-connect 0)
  ;; eglotとclangd のインデント設定を無効化する
  (with-eval-after-load 'eglot (add-to-list 'eglot-ignored-server-capabilities 
					    :documentFormattingProvider))
  (with-eval-after-load 'eglot (add-to-list 'eglot-ignored-server-capabilities 
					    :documentRangeFormattingProvider))
  (with-eval-after-load 'eglot (add-to-list 'eglot-ignored-server-capabilities 
					    :documentOnTypeFormattingProvider))
  ;;Key-bind 
  (define-key eglot-mode-map (kbd "<f6>") 'xref-find-definitions)
  (define-key eglot-mode-map (kbd "<f7>") 'xref-find-reference)
  (define-key eglot-mode-map (kbd "<f8>") 'eglot-momentary-inlay-hints)
  ;; M-.  : xref-find-definitions
  ;; M-,  : xref-go-back
  ;; M-?  : xref-find-reference
  ;; C-h. : Display Symbol's Document 
  ;; C-c i : Completion at point 
  :hook ((c-ts-mode-hook . eglot-ensure)
	 (c++-ts-mode-hook . eglot-ensure)
	 (php-ts-mode-hook . eglot-ensure)
	 ;;(cmake-ts-mode-hook . eglot-ensure)
	 )
  :custom ((eldoc-echo-area-use-multiline-p . nil)
           (eglot-connect-timeout . 600) )
  :bind (
	 ("C-c i" . 'completion-at-point)
         ("C-c r" . 'eglot-rename) 
         ("C-c o" . 'eglot-code-action-organize-imports)
	 ) 

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
  :bind (:projectile-mode-map 
	("C-c p" . 'projectile-command-map))
  )

(leaf ag
  :ensure t)
(leaf rg
  :ensure t)

(leaf markdown-mode
  :ensure t
 :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'"       . markdown-mode))
  :bind (:markdown-mode-map
	 ("C-c RET" . markdown-follow-link-at-point)
         ("C-c C-c" . markdown-do-command)
         ("M-RET"   . markdown-insert-list-item))
  :config
  (setopt markdown-command                    "pandoc -f markdown+header_attributes-raw_html -t html5")
  (setopt markdown-fontify-code-blocks-natively t)  ; コードブロックにシンタックスハイライト
  (setopt markdown-header-scaling              t)    ; 見出しのサイズを段階的に
  (setopt markdown-hide-markup                 nil)  ; マークアップを表示 (t で隠す)
  (setopt markdown-command-needs-filename      t)
  (setopt markdown-preview-use-browser         t)
  (setopt browse-url-browser-function         'browse-url-generic)
  (setopt browse-url-generic-program          "google-chrome")
  (setopt markdown-content-type               "application/xhtml+xml")
  (setopt markdown-css-paths
  (list (expand-file-name "~/.emacs.d/elisp/css/markdown-cream.css")))

  (define-key markdown-mode-map (kbd "<S-tab>") #'markdown-shifttab)

  )


;;
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
	  '(treemacs-display-in-side-window          t)
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
	  '(treemacs-wide-toggle-width               50)
	  '(treemacs-width                           30) ;;default 35 
	  '(treemacs-width-increment                 1)
	  '(treemacs-width-is-initially-locked       t)
	  '(treemacs-workspace-switch-cleanup        nil)
	  '(foo-package-to-enable t "Customized with leaf in foo-package block")
	  '(foo-package-to-disable nil "Customized with leaf in foo-package block")
	  '(foo-package-to-symbol 'symbol "Customized with leaf in foo-package block")
	  '(foo-package-to-function #'ignore "Customized with leaf in foo-package block")
	  '(foo-package-to-lambda (lambda (elm) (message elm)) "Customized with leaf in foo-package block")
	  )
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




(with-eval-after-load 'treemacs
  (defun my/treemacs-layout ()
    (let ((treemacs-side 'left))
      ;; 1) まず左右分割を作る（右側を用意）
      (when (not (window-at-side-p nil 'left))
        (split-window-horizontally))
      ;; 2) 左側(Treemacs側)を確実に選ぶ
      (when (window-at-side-p nil 'left)
        (select-window (next-window))) ; selectedを右へ寄せる保険（次で「右」操作するため）
      ;; 3) 今のselectedが右側になっている前提で右側を左右分割
      ;;    その後、いちばん右へ寄せて上下分割
      (when (window-at-side-p nil 'right)
        ;; 右側を左右に分割
        (split-window-horizontally)
        ;; いちばん右へ移動（環境差があるので once で寄せる）
        (other-window 1)
        ;; いちばん右だけ上下分割
        (split-window-vertically)
        ;; 右側操作の後、Treemacs側へ戻す（任意だけど崩れにくい）
        (other-window -1))))

  (advice-add 'treemacs :before
              (lambda (&rest _args)
                (my/treemacs-layout))))


;; リガチャを有効にする

(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))






(provide 'init)




;;;
;;; This will enable emacs to compile a simple cpp single file without any makefile by just pressing [f9] key
;;;
(defun code-compile()
  (interactive)
  (unless (file-exists-p "Makefile")
    (set (make-local-variable 'compile-command)
	 (let ((file (file-name-nondirectory buffer-file-name)))
	   (format "%s -std=c++20 -o %s %s"
		   (if (equal (file-name-extension file) "cpp") "g++" "gcc")
		   (file-name-sans-extension file)
		   file)))
    (compile compile-command)))
(global-set-key [f9] 'code-compile)


