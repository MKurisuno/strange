;;; init --- Personal Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; Personal Emacs configuration.
;; M.Kurisuno .emacs/init.el
;;
;;
;;
;; 2024.12.16
;; 2025.06.20 Update
;; 2026.09.08 Update
;;
;;
;;



;;; Code:
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
(set-fontset-font t 'japanese-jisx0208 (font-spec :name "Noto Sans JP" :size 12 :height 85) nil 'prepend)
(set-fontset-font t 'cjk-misc          (font-spec :name "Noto Sans JP" :size 12 :height 85) nil 'prepend)



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
  :custom
  (default-input-method . "japanese-mozc")
  (mozc-helper-program-name . "mozc_emacs_helper")
  (mozc-leim-title . "あ")
  :config  ;; after-load mozc でないと読み込まない
  (with-eval-after-load 'mozc
    (set-face-attribute 'mozc-preedit-face nil
                        :height 0.85
                        :foreground "#8BE9FD"
                        :background "#282A36"
                        :weight 'bold)
    (set-face-attribute 'mozc-preedit-selected-face nil
                        :height 0.90
                        :foreground "#282A36"
                        :background "#8BE9FD"
                        :weight 'bold)
    (set-face-attribute 'mozc-cand-overlay-focused-face nil
                        :height 0.85
                        :foreground "#282A36"
                        :background "#BD93F9"
                        :weight 'bold)
    (set-face-attribute 'mozc-cand-overlay-odd-face nil
                        :height 0.85
                        :foreground "#F8F8F2"
                        :background "#44475A")
    (set-face-attribute 'mozc-cand-overlay-even-face nil
                        :height 0.85
                        :foreground "#F8F8F2"
                        :background "#282A36")
    (set-face-attribute 'mozc-cand-overlay-footer-face nil
                        :height 0.80
                        :foreground "#50FA7B"
                        :background "#282A36")))

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :global-minor-mode global-auto-revert-mode)

(leaf delsel
  :doc "delete selection if you insert"
  :global-minor-mode delete-selection-mode)

;;
;; macrostep. paren. delimiter. higtlight
;;
(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf rainbow-delimiters
  :ensure t
  :hook
  (prog-mode-hook . rainbow-delimiters-mode))

(leaf paren
  :ensure t
  :hook
  (after-init-hook . show-paren-mode)
  :custom-face
  (show-paren-match . '((nil (:background "#44475a" :foreground "#f1fa8c"))))
  :custom ((show-paren-style . 'mixed)
           (show-paren-when-point-inside-paren . t)
           (show-paren-when-point-in-periphery . t)))

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
  :hook (emacs-lisp-mode-hook . flymake-mode)
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
         ("C-s"   . c/consult-line)       ; isearch-forward
	 (minibuffer-local-map :package emacs ("C-r" . consult-history))
         ;;  C-M-s bindings
         ("C-M-s"   . nil)                ; isearch-forward-regexp
         ("C-M-s s" . isearch-forward)
         ("C-M-s C-s" . isearch-forward-regexp)
         ("C-M-s r" . consult-ripgrep))
         ;;
         ;; C-r     : consult-history  minibuffer-mode-map
         ;; C-s     : consult-line     c/consult-line
         ;; C-x b   : consult-buffer
         ;; C-x p b : consult-project-buffer
         ;; M-g g   : consult-goto-line
         ;; M-g i   : consult-imenu
         ;; M-g f   : consult-flymake
         ;; C-u C-s : at-point iserch-forward
         ;; C-M-s s   : iserch-forward
         ;; C-M-s C-s : iserch-forward-regexp
         ;; C-M-s r   : consult-ripgrep
         ;; C-M-s g   : affe-grep
         ;; C-M-s f   : affe-find
  )


(leaf affe
  :doc "Asynchronous Fuzzy Finder for Emacs"
  :ensure t
  :custom ((affe-highlight-function . 'orderless-highlight-matches)
           (affe-regexp-function . 'orderless-pattern-compiler))
  :bind (("C-M-s g" . affe-grep)
         ("C-M-s f" . affe-find)))

(leaf orderless
  :doc "Completion style for matching regexps in any order"
  :ensure t
  :custom ((completion-styles . '(orderless))
           (completion-category-defaults . nil)
           (completion-category-overrides . '((file (styles partial-completion))))))



(leaf embark
  :ensure t
  :bind
  (("C-."   . embark-act)
   ("C-;"   . embark-dwim)
   ("C-h B" . embark-bindings)))


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
	       (corfu-popupinfo-mode . t)
	       (corfu-popupinfo-delay . nil)
	       (corfu-cycle . t)
	       (corfu-quit-no-match 'separator)
	       ;; 補完ソースの順序を指定
	       (corfu-sources . '(corfu-lsp corfu-dabbrev corfu-dict corfu-yasnippet)))
  :bind   ((corfu-map
          ("C-s" . corfu-insert-separator))))

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
         ;; ("M-)"   . puni-syntactic-forward-punct)
         ;; ("M-("   . puni-syntactic-backward-punct)
         ;; (global-map) M-f or ESC<right>  forward-word
         ;; (global-map) M-b or ESC<left>   backward-word
         ;; ("C-M-u" . backward-up-list)
         ;; ("C-M-d" . backward-down-list)
         ;; ("M-{")  . backword-paragraph)  ;;次のパラグラフ先頭へ  Ctrl+<up>
         ;; ("M-}")  . forward-paragraph)   ;;前のパラグラフ先頭へ  Ctrl+<down>
         ("C-c }" . puni-slurp-forward)   ;; (a) b  -> (a  b)   ; slurp = 括弧内へ取り込む
         ("C-c {" . puni-slurp-backward)  ;;  a (b) -> (a  b)   ;
         ("C-c <" . puni-barf-forward)    ;; (a  b) -> (a) b    ; barf  = 括弧外へ出す
         ("C-c >" . puni-barf-backward)   ;; (a  b) ->  a (b)   ;
         ("C-c )" . puni-wrap-round)      ;;   a    ->  (a)     ; wrap  = 括弧を付ける
         ("C-c (" . puni-splice)          ;;  (a)   ->   a      ; splice = 括弧を外す
         ("M-r" . puni-raise)             ;; A(b(x),y) -> b(x)  ; raise = 親のS式を現在のS式で置き換える
         ("M-U" . puni-splice-killing-backward)
         ("M-z" . puni-squeeze)           ;; foo (bar) baz -> { + C-y + } -> foo {bar} baz
                                          ;; squeeze = 中身を一時退避して括弧を付け替える
	 )
  :config
  (leaf elec-pair
    :doc "Automatic parenthesis pairing"
    :global-minor-mode electric-pair-mode))

(leaf yasnippet
  :ensure t
  :global-minor-mode   yas-global-mode )

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
  (defvar treesit-language-source-alist)
  ;;  (add-to-list 'auto-mode-alist '("\\.clj[sc]?\\'" . clojure-mode))
  ;;  (add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))
  (add-to-list 'treesit-language-source-alist '(yaml "https://github.com/ikatyang/tree-sitter-yaml"))
  (add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.json\\'" . js-json-mode))
  (add-to-list 'auto-mode-alist '("\\.php\\'". php-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.y?ml\\'". yaml-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.clang\\(?:d\\|-tidy\\|-format\\)\\'" . yaml-ts-mode)) ;;Clangd の設定file
  )

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

(leaf eldoc
  :ensure nil
  :config
  ;; MiniBuffer へのechoの文字の大きさを調節 下の設定は間違ってないけど読み込まない。
  ;;(custom-set-faces  '(markdown-header-face-3 ((t (:height 0.85)))))
  (with-eval-after-load 'markdown-mode (set-face-attribute 'markdown-header-face-3 nil :height 1.0))
  :hook
  ((prog-mode-hook . eldoc-mode)))


(leaf eldoc-box
  :ensure t
  :bind  (("C-c d" . eldoc-box-help-at-point))
;;  :hook  ((eglot-managed-mode-hook . (lambda () (eldoc-box-hover-at-point-mode 1) )))
  :custom ((eldoc-box-max-pixel-width . 600) (eldoc-box-max-pixel-height . 120))
  :custom-face
  (eldoc-box-body . ' ((t (:background "#282A36" :foreground "#f8f8f2" :family "JetBrains Mono" :height 0.90 :weight normal :slant normal :alpha 70))))
  (eldoc-box-border . '((t (:background "#44475a" ))))
  :config
  ;;次の設定は結果としてEmacsを透過して壁紙が見える
  ;;(setf (alist-get 'alpha-background eldoc-box-frame-parameters) 88)
  ;HoverからのEchoの一行目の文字の大きさを調節
  (with-eval-after-load 'markdown-mode (set-face-attribute 'markdown-header-face-3 nil :height 0.95))
)



;;
;; eglot
;;
(leaf eglot
  :doc "The Emacs Client for LSP servers"
  :ensure t
  :config
  ;;(add-to-list 'eglot-server-programs '(cmake-ts-mode "cmake-language-server"))
  ;;(add-to-list 'eglot-server-programs '((c++-ts-mode c-ts-mode) "ccls"))
  (defvar eglot-server-programs)
  (defvar eglot-ignored-server-capabilities)

  (add-to-list 'eglot-server-programs '((c++-ts-mode) "clangd"))
  (add-to-list 'eglot-server-programs '((c-ts-mode) "clangd"))
  (add-to-list 'eglot-server-programs '((php-ts-mode) . ("intelephense" "--stdio")))
  (add-to-list 'eglot-server-programs '((python-ts-mode) . ("pyright-langserver" "--stdio")))
  ;; eglotとclangd のインデント設定を無効化する
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-ignored-server-capabilities :documentFormattingProvider)
    (add-to-list 'eglot-ignored-server-capabilities :documentRangeFormattingProvider)
    (add-to-list 'eglot-ignored-server-capabilities :documentOnTypeFormattingProvider))
  :bind (("C-c i" . completion-at-point)
         ("C-c r" . eglot-rename)
         ("C-c o" . eglot-code-action-organize-imports))
  ;; M-.   : xref-find-definitions
  ;; M-,   : xref-go-back
  ;; M-?   : xref-find-reference
  ;; C-M-. : xref-apropros
  ;; C-h-. : Display-local-help
  ;; C-c i : Completion at point
  ;; C-c a : Rename
  :hook
  ((c-ts-mode-hook . eglot-ensure)
   (c++-ts-mode-hook . eglot-ensure)
   (php-ts-mode-hook . eglot-ensure)
   (python-ts-mode-hook . eglot-ensure))
  :custom
  ((eldoc-echo-area-use-multiline-p . nil)
   (eglot-connect-timeout . 600)
   (eglot-autoshutwon . t)
   (eglot-sync-connect . 0))
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
	("C-c p" . 'projectile-command-map)))

(leaf ag
  :ensure t)
(leaf rg
  :ensure t)




(leaf markdown-mode
  :ensure t
  :mode
  (("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))
  :custom
  ((markdown-command . "pandoc -f markdown+header_attributes-raw_html -t html5")
   (markdown-fontify-code-blocks-natively . t)
   (markdown-header-scaling . t)
   (markdown-enable-math . t)
   (markdown-url-compose-char . nil))
  :custom-face
  (markdown-header-face-1 . '((t (:weight bold :height 1.3))))
  (markdown-header-face-2 . '((t (:weight bold :height 1.2))))
  (markdown-header-face-3 . '((t (:weight bold :height 1.1))))
  (markdown-header-face-4 . '((t (:weight bold :height 1.0))))
  :hook
  ((markdown-mode-hook . visual-line-mode)
   (markdown-mode-hook . flyspell-mode))
  :bind
  (:markdown-mode-map
   ("C-c C-t" . markdown-toc-generate-toc)
   ("C-c C-p" . markdown-preview))
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



(defun my/treemacs-layout ()
  "左側にウィンドウがなければ左右分割し、右側を上下に分割する."
  ;;左側にウィンドウがなければ左右分割
  (unless (window-at-side-p nil 'left)
    (split-window-horizontally))
  ;; 右側へ移動
  (when (window-at-side-p nil 'left)
    (select-window (next-window)))
  ;; 右側をさらに左右分割し、最右側を上下分割
  (when (window-at-side-p nil 'right)
    (split-window-horizontally)
    (other-window 1)
    (split-window-vertically)
    (other-window -1)))
(defun my/treemacs-before (&rest _args)
  "Treemacs の起動前にウィンドウレイアウトを設定する."
  (my/treemacs-layout))

(with-eval-after-load 'treemacs
  (advice-add #'treemacs :before #'my/treemacs-before))



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










;;;
;;; This will enable emacs to compile a simple cpp single file without any makefile by just pressing [f9] key
;;;
;;(defun code-compile()
;;  (interactive)
;;  (unless (file-exists-p "Makefile")
;;    (set (make-local-variable 'compile-command)
;;	 (let ((file (file-name-nondirectory buffer-file-name)))
;;	   (format "%s -std=c++20 -o %s %s"
;;		   (if (equal (file-name-extension file) "cpp") "g++" "gcc")
;;		   (file-name-sans-extension file)
;;		   file)))
;;    (compile compile-command)))
;;(global-set-key [f9] 'code-compile)

(provide 'init)
;;; init.el ends here
