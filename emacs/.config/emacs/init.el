;;; package --- init Personal Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; Personal Emacs configuration.
;; M.Kurisuno emacs/init.el
;;
;;
;;
;; 2024.12.16
;; 2025.06.20 Update
;; 2026.11.10Xtg Update
;;
;;
;;

;;; Code:

;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;; Initial Setting.
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
(when (version< emacs-version "30.0")  (error "This requires Emacs 30.0 and above!"))
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(setq inhibit-compacting-font-caches t)
(setq history-delete-duplicates t)
(setq vc-follow-symlinks t)
(setq column-number-mode t)
(global-display-line-numbers-mode t)
(defalias 'yes-or-no-p 'y-or-n-p)
;; スクロールした際のカーソルの移動行数
(setq scroll-conservatively 1)
;; スクロール開始のマージンの行数
(setq scroll-margin 3)
;; 1 画面スクロール時に重複させる行数
(setq next-screen-context-lines 4)
;; 1 画面スクロール時にカーソルの画面上の位置をなるべく変えない
(setq scroll-preserve-screen-position t)



;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;; Font Setting.
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
(set-face-attribute 'default nil :family "JetBrains Mono" :height 105)
(dolist (charset '(kana han cjk-misc japanese-jisx0208 japanese-jisx0213.2004-1))
  (set-fontset-font t charset (font-spec :family "Noto Sans CJK JP") nil 'prepend)
  (set-fontset-font t 'emoji  (font-spec :family "Noto Color Emoji") nil 'append))
;; 日本語の高さ調整
(setopt face-font-rescale-alist '(("Noto Sans CJK JP" . 1.2)))


;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;;   Leaf Initial Setting.
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
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
    (leaf-keywords-init)))

(leaf leaf-convert
  :doc "Convert many format to leaf format"
  :ensure t)

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))


;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;;  Introduce doom-themes not doom-emacs.
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
(leaf nerd-icons
  :ensure t  )

(leaf doom-themes
  :ensure t
  :custom ((doom-themes-enable-bold . t)
           (doom-themes-enable-italic . t))
  ;; for treemacs users
  ;;(doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  :config
  (load-theme 'doom-dracula t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  (doom-themes-org-config)
  (doom-themes-treemacs-config)
  ;; コメントのカラーを明るめに変更
  (set-face-attribute 'font-lock-comment-face nil :foreground "#9aa8c7"))

(leaf doom-modeline
  :ensure t
  :hook ((after-init-hook . doom-modeline-mode)
         (after-init-hook . display-time-mode))
  :custom
  ;;時刻・日付の表示
  (display-time-format . "%Y-%m-%d %H:%M")
  (display-time-default-load-average . nil)
  :config
  ;; モデルラインのバーの色を変更
  (set-face-attribute 'doom-modeline-bar nil :background "#6272a4"))


;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;;  emacs defaults setting.
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
(leaf files
  :doc "file input and output commands for Emacs"
  :global-minor-mode auto-save-visited-mode
  :custom `((auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)
            (auto-save-visited-interval . 1)))
(leaf startup
  :doc "process Emacs shell arguments"
  ;; to recover session,  M-x recover-session .save-xxx
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))
(leaf savehist
  :doc "Save minibuffer history"
  :custom `((savehist-file . ,(locate-user-emacs-file "savehist")))
  :global-minor-mode t)
(leaf org
  :custom ((org-directory . "~/org/")
           (org-startup-indented . t)
           (org-hide-emphasis-markers . t)
           (org-ellipsis . " ▾")
           (org-log-done . 'time)
           (org-src-fontify-natively . t)
           (org-src-tab-acts-natively . t)))
(leaf org-modern
  :ensure t
  :after org
  :hook ((org-mode-hook . org-modern-mode)
         (org-agenda-finalize-hook . org-modern-agenda)))
(leaf org-appear
  :ensure t
  :after org
  :hook (org-mode-hook . org-appear-mode))

(leaf tab-bar
  :ensure nil
  :custom
  ((tab-bar-close-button-show . t)
   (tab-bar-new-button-show   . t)
   (tab-bar-tab-hints         . t)
   (tab-bar-auto-width        . nil)
   (tab-bar-separator         . " ")
   (tab-bar-tab-name-format-function
    . (lambda (tab i)
        (let* ((face (funcall tab-bar-tab-face-function tab))
               (name (truncate-string-to-width
                      (alist-get 'name tab) 12 nil ?\s "…"))
               (text (propertize (format " (%d) %s" i name) 'face face)))
          (concat text
                  (when (and tab-bar-close-button-show
                             (or (not (eq tab-bar-close-button-show 'non-selected))
                                 (not (eq (car tab) 'current-tab))))
                    (propertize tab-bar-close-button
                                'face face))))))
   (tab-bar-format . '(tab-bar-format-tabs-groups
                       ;;tab-bar-format-tabs
                       tab-bar-separator
                       tab-bar-format-add-tab))
   )
  :bind (("C-x t P" . emacs-solo/tab-group-from-project)
         ("C-x t g" . emacs-solo/tab-switch-to-group))
  :init
  (defun tab-bar-tab-group-format-default (tab _i &optional current-p)
    (propertize
     (funcall tab-bar-tab-group-function tab)
     'face (if current-p 'tab-bar-tab-group-current 'tab-bar-tab-group-inactive)))
  (defun emacs-solo/tab-group-from-project ()
    "Call `tab-group' with the current project(project.el) name as the group."
    (interactive)
    (when-let* ((proj (project-current))
                (name (file-name-nondirectory
                       (directory-file-name (project-root proj)))))
      (tab-group (format "[%s]" name))))
  (defun emacs-solo/tab-switch-to-group ()
    "Prompt for a tab group and switch to its first tab."
    (interactive)
    (let* ((tabs (funcall tab-bar-tabs-function))
           (groups (delete-dups
                    (mapcar (lambda (tab) (funcall tab-bar-tab-group-function tab))
                            tabs)))
           (group (completing-read "Switch to group: " groups nil t))
           (i 1) found)
      (dolist (tab tabs)
        (when (and (not found)
                   (string= (funcall tab-bar-tab-group-function tab) group))
          (setq found t)
          (tab-bar-select-tab i))
        (setq i (1+ i)))))
  :config
  (tab-bar-mode 1)
  (set-face-attribute 'tab-bar-tab nil
                      :foreground "#818EB6"
                      :background "#282A36")
  (set-face-attribute   'tab-bar-tab-inactive nil
                        :foreground "#484A56"
                        :background "#1C1D27")
  )

;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;; `mh-e'
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
(setopt mh-x-face-file "~/.mh-x-face" )

;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;;  mozc color setting
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
(leaf mozc
  :ensure t
  :custom
  (default-input-method . "japanese-mozc")
  (mozc-helper-program-name . "mozc_emacs_helper")
  (mozc-leim-title . "かな")
  :config  ;; after-load mozc でないと読み込まない
  (with-eval-after-load 'mozc
    (set-face-attribute 'mozc-preedit-face nil
                        :height 0.95
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

;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;;
;;--- --- --- --- --- --- --- --- --- --- --- --- ---

(leaf autorevert
  :doc "Revert buffers automatically when underlying files change"
  :tag "builtin"
  ;;  :require t
  :custom
  (auto-revert-check-vc-info . t)
  (global-auto-revert-non-file-buffers . t)
  (auto-revert-interval . 1)
  (auto-revert-verbose . nil)
  :global-minor-mode global-auto-revert-mode)

(leaf delsel
  :doc "delete selection if you insert"
  :global-minor-mode delete-selection-mode)

(leaf simple
  :doc "basic editing commands for Emacs"
  :custom ((kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))
(with-eval-after-load 'simple  (setopt idle-update-delay 1.0))

(leaf which-key
  :doc "Display available keybindings in popup"
  :ensure t
  :global-minor-mode t)

(when (eq system-type 'gnu/linux)
  (leaf exec-path-from-shell
    :doc "Get environment variables such as $PATH from the shell"
    :ensure t
    :defun (exec-path-from-shell-initialize)
    :custom ((exec-path-from-shell-check-startup-files)
             (exec-path-from-shell-variables . '("PATH" "GOPATH" "JAVA_HOME")))
    :config
    (exec-path-from-shell-initialize))
  )



;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;; macrostep paren delimiter highlight-indent-guides
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
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

(leaf highlight-indent-guides
  :ensure t
  :hook (yaml-ts-mode-hook . highlight-indent-guides-mode)
  :hook (python-ts-mode-hook . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method . 'column)
  (highlight-indent-guides-auto-enabled . nil) ; 自動色計算をオフにしてカスタムカラーを使用
  (highlight-indent-guides-responsive . 'top)   ; カーソル位置のガイドをアクティブ強調
  :config
  ;; --- Dracula風 4色カラーパレット設定 --- #f1fa8c
  (set-face-background 'highlight-indent-guides-odd-face "#FFFF00")
  (set-face-background 'highlight-indent-guides-even-face "#39FF14")
  (set-face-background 'highlight-indent-guides-top-even-face "#FF69B4")
  (set-face-background 'highlight-indent-guides-top-odd-face "#BD93F9") )


(leaf puni
  :doc "Parentheses Universalistic"
  :ensure t
  :global-minor-mode puni-global-mode
  :bind (:puni-mode-map
         ;; default mapping  sexp = Symbolic-Expression
         ;; ("C-M-f" . puni-forward-sexp)      ;次のSexpの末尾まで進む
         ;; ("C-M-b" . puni-backward-sexp)     ;前のSexpのまで戻る
         ;; ("C-M-a" . puni-beginning-of-sexp) ;(S式)の先頭まで移動
         ;; ("C-M-e" . puni-end-of-sexp)       ;(S式)の末尾まで移動
         ;; ("C-M-u" . backward-up-list)       ;( )内にあるとき( )の先頭に移動
         ;; ("C-M-d" . backward-down-list)     ;次の( )内に移動
         ;; ("M-)"   . puni-syntactic-forward-punct)  ;次の句読点(punctuation)までJamp
         ;; ("M-("   . puni-syntactic-backward-punct) ;前の句読点(punctuation)までJamp
         ;; (global-map) M-f or ESC<right>  forward-word
         ;; (global-map) M-b or ESC<left>   backward-word
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


;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;;  Syntax and Spell checher
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
(leaf flymake
  :doc "A universal on-the-fly syntax checker"
  :hook (emacs-lisp-mode-hook . flymake-mode)
  :bind ((prog-mode-map
          ("M-n" . flymake-goto-next-error)
          ("M-p" . flymake-goto-prev-error))))

(leaf jinx
  :doc "Enchanted Spell Checker. Ubuntu needs libenchant-2-dev, pkgconf."
  :ensure t
  :hook (emacs-startup-mode-hook . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :custom
  ;; target language（デフォルトは "en" や OS の言語設定依存）
  (jinx-languages . "en"))

;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;;  Completion settings.
;;  -- vertico marginalia corfu cape etc...
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
(leaf vertico
  :doc "VERTical Interactive COmpletion"
  :ensure t
  :global-minor-mode t
  :bind (:vertico-map
         ("RET" . vertico-directory-enter)
         ("DEL"   . vertico-directory-delete-char)
         ("M-DEL" . vertico-directory-delete-word))
  :hook (emacs-startup-hook . vertico-mode))

;;(leaf vertico-directory
;;  :after vertico
;;  :ensure nil
;;  :bind (:vertico-map
;;         ("DEL"   . vertico-directory-delete-char)
;;         ("M-DEL" . vertico-directory-delete-word))
;;  )

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
         ("C-M-s r" . consult-ripgrep)
         ("C-M-s d" . consult-fd)
         )
  ;;
  ;; C-r     : consult-history  in MiniBuffer-mode-map
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
  ;; C-M-s d   : consult-fd
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

(leaf cape
  :doc "Completion At Point Extensions"
  :ensure t
  :init
  ;; プログラミングモード全体で有効にする
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-dabbrev)
              (add-to-list 'completion-at-point-functions #'cape-file)
              (add-to-list 'completion-at-point-functions #'cape-keyword)))

  ;; Emacs Lispを書くとき（設定ファイル編集時など）にシンボル補完を追加
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)))
  )

(leaf corfu
  :doc "COmpletion in Region FUnction"
  :ensure t
  :require t
  :global-minor-mode (global-corfu-mode corfu-popupinfo-mode)
  :custom ((corfu-auto . t)
           (corfu-auto-delay . 0.1)         ; お好みで 0.1 ~ 0.2 にしても快適です
           (corfu-auto-prefix . 1)
           (corfu-popupinfo-delay . nil)   ; 自動ポップアップを抑制する場合
           (corfu-cycle . t)
           (corfu-quit-no-match . 'separator))
  :bind ((corfu-map
          ("C-s" . corfu-insert-separator)))
  :init   ;; 各種補完ソースを Capf に追加するフック
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-file)
              (add-to-list 'completion-at-point-functions #'cape-dabbrev)
              (add-to-list 'completion-at-point-functions #'yasnippet-capf 'append)))
  )

(leaf svg-lib
  :doc "Emacs SVG library that allows to create and display various SVG objects."
  :ensure t)

(defvar corfu-margin-formatters nil)
(leaf nerd-icons-corfu
  :ensure t
  :after (nerd-icons corfu)
  :config
  ;; Corfuのアイコン表示バックエンドとして nerd-icons-corfu を設定
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(leaf yasnippet
  :ensure t
  :global-minor-mode   yas-global-mode )
(leaf yasnippet-snippets
  :ensure t
  :after yasnippet)
(leaf yasnippet-capf
  :doc "Yasnippet Completion-At-Point-Function."
  :ensure t
  :after (yasnippet cape)
  ;;Yasnippetの優先順位をCompletionより下げておく.
  :hook (prog-mode-hook . (lambda ()
                            (add-to-list 'completion-at-point-functions #'cape-dabbrev)
                            (add-to-list 'completion-at-point-functions #'cape-file)
                            (add-to-list 'completion-at-point-functions #'yasnippet-capf 'append))))

(leaf embark
  :ensure t
  :bind (("C-."   . embark-act)
         ("C-;"   . embark-dwim)
         ("C-h B" . embark-bindings)))

(leaf embark-consult
  :doc "Consult integration for Embark"
  :ensure t
  :bind ((minibuffer-mode-map
          :package emacs
          ("M-." . embark-dwim)
          ("C-." . embark-act))))


;;--- --- --- --- --- --- --- --- --- --- --- ---
;;  git
;;--- --- --- --- --- --- --- --- --- --- --- ---
(leaf  magit
  :ensure t
  :bind (("C-x g" . magit-status))
  :commands (magit-status))

(leaf git-gutter
  :ensure t
  :global-minor-mode global-git-gutter-mode
  :custom
  ((git-gutter:added-sign . "+")
   (git-gutter:deleted-sign . "-")
   (git-gutter:modified-sign . "=")))

;;--- --- --- --- --- --- --- --- --- --- --- ---
;; Editorconfig and Formatter.
;;--- --- --- --- --- --- --- --- --- --- --- ---
(leaf editorconfig
  :doc "a file format for defining coding styles and a collection"
  :ensure t
  :config
  (editorconfig-mode 1))

(leaf format-all
  :ensure t
  :bind (("C-c f" . format-all-buffer))
  :hook (prog-mode . format-all-mode))

;;--- --- --- --- --- --- --- --- --- --- --- ---
;; tree-sitter and Language-server setting
;;--- --- --- --- --- --- --- --- --- --- --- ---
(leaf *treesit
  :custom ((treesit-font-lock-level . 4))
  :config
  (require 'treesit)
  (defvar treesit-language-source-alist)
  ;;  (add-to-list 'auto-mode-alist '("\\.clj[sc]?\\'" . clojure-mode))
  ;;  (add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))
  (add-to-list 'treesit-language-source-alist '(yaml "https://github.com/ikatyang/tree-sitter-yaml"))
  (add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.cmake\\'"         . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.py\\'"    . python-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . html-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.json\\'"  . js-json-mode))
  (add-to-list 'auto-mode-alist '("\\.php\\'"   . php-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.y?ml\\'"  . yaml-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.toml\\'"  . toml-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.\\(?:m\\|c\\)?js\\'"  . js-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.ts\\'"   . typescript-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'"  . tsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.c\\'"    . c-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.h\\'"    . c++-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.cpp\\'"  . c++-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.c\\+\\+\\'"  . c++-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.hpp\\'"  . c++-ts-mode))

  (add-to-list 'auto-mode-alist '("\\.clang\\(?:d\\|-tidy\\|-format\\)\\'" . yaml-ts-mode)) ;;Clangd の設定file
  )


;; --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- --
;;       Eglot + eldoc + eldocbox.
;; --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- --
(leaf eldoc
  :ensure nil
  :config
  ;; MiniBuffer へのHoverからのechoの文字の大きさを調節 下の設定は間違ってないけど読み込まない。
  ;;(custom-set-faces  '(markdown-header-face-3 ((t (:height 0.85)))))
  ;; なので、`with-eval-after-load'で読み込ませる.
  (with-eval-after-load 'markdown-mode (set-face-attribute 'markdown-header-face-3 nil :height 1.0))
  :hook
  ((prog-mode-hook . eldoc-mode)))

(leaf eldoc-box
  :ensure t
  :bind  (("C-c d" . eldoc-box-help-at-point))
  ;;  :hook  ((eglot-managed-mode-hook . (lambda () (eldoc-box-hover-at-point-mode 1) )))
  ;;  custom での設定はとりあえずは有効になるが、ブロック最後のwith-eval-after-load で読み込ませる.
  ;;  :custom ((eldoc-box-max-pixel-width . 600) (eldoc-box-max-pixel-height . 120))
  :custom-face
  (eldoc-box-body . ' ((t (:background "#282A36" :foreground "#f8f8f2" :family "JetBrains Mono" :height 0.95 :weight normal :slant normal :alpha 70))))
  (eldoc-box-border . '((t (:background "#44475a" ))))
  :config
  ;;次の設定は結果としてEmacsを透過して壁紙が見える
  ;;(setf (alist-get 'alpha-background eldoc-box-frame-parameters) 88)
                                        ;HoverからのEchoの一行目の文字の大きさを調節
  (with-eval-after-load 'markdown-mode (set-face-attribute 'markdown-header-face-3 nil :height 0.95))
  (defvar eldoc-box-max-pixel-width)
  (defvar eldoc-box-max-pixel-height)
  (defvar eldoc-box-frame-parameters)
  (with-eval-after-load 'eldoc-box
    (setq eldoc-box-max-pixel-width 600 eldoc-box-max-pixel-height 120)
    (setf (alist-get 'min-width eldoc-box-frame-parameters) 40
          (alist-get 'min-height eldoc-box-frame-parameters) 5) ))

(leaf eglot
  :doc "The Emacs Client for LSP servers"
  :ensure t
  :config
  (defvar eglot-server-programs)
  (defvar eglot-ignored-server-capabilities)
  ;; 
  (add-to-list 'eglot-server-programs '((c++-ts-mode) "clangd"))
  (add-to-list 'eglot-server-programs '((c-ts-mode) "clangd"))
  ;;(add-to-list 'eglot-server-programs '((php-ts-mode) . ("intelephense" "--stdio")))
  (add-to-list 'eglot-server-programs '((php-ts-mode) . ("phpactor" "language-server")))
  (add-to-list 'eglot-server-programs '((python-ts-mode) . ("pyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs '((typescript-ts-mode) . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '((js-ts-mode tsx-ts-mode) . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '((web-mode) . ("vscode-html-language-server" "--stdio")))


  ;;--- xref-find-reference の時の強調背景が明るすぎるため ---
  (with-eval-after-load 'xref
    (set-face-attribute 'xref-match nil :foreground "#FFFFFF" :background "#44475a" :weight 'bold))
  :bind (("C-c i" . completion-at-point)
         ("C-c r" . eglot-rename)
         ("C-c o" . eglot-code-action-organize-imports))
  ;;; --- --- Eglot key bind --- ---
  ;; M-.   : xref-find-definitions
  ;; M-,   : xref-go-back
  ;; M-?   : xref-find-reference
  ;; C-M-. : xref-apropos
  ;; C-h-. : Display-local-help
  ;; C-c i : Completion at point
  ;; C-c a : Rename
  :hook
  (;;(c-ts-mode-hook   . eglot-ensure)    Written with formatter setting in next block.
   ;;(c++-ts-mode-hook . eglot-ensure)
   ;;(php-ts-mode-hook . eglot-ensure)
   (python-ts-mode-hook     . eglot-ensure)
   (typescript-ts-mode-hook . eglot-ensure)
   (tsx-ts-mode-hook  . eglot-ensure)
   (js-ts-mode-hook   . eglot-ensure)
   (web-mode-hook     . eglot-ensure)
   )
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

;;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;;    Setting for Formatters with Language Servers.
;;     clangd and phpactor.       他のサーバーでも出来なくはない
;;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

(eval-when-compile  (require 'eglot))
(declare-function eglot-format-buffer "eglot")

;;  Clangd for fotmat needs '.clang-format' in ProjectRoot.
(add-hook 'c++-ts-mode-hook
          (lambda ()
            (eglot-ensure)
            (add-hook 'before-save-hook #'eglot-format-buffer nil t)
            (message "[  EGLOT-format-buffer  ] [ 'clangd-format' applied !! ]")))

(add-hook 'cc-ts-mode-hook
          (lambda ()
            (eglot-ensure)
            (add-hook 'before-save-hook #'eglot-format-buffer nil t)
            (message "[  EGLOT-format-buffer  ] [ 'clangd-format' applied !! ]")))

;;  PHP Langage Server needs 'php-cs-fixer' and 'php-cs-fixer.dist'  in Symfony.
(add-hook 'php-ts-mode-hook
          (lambda ()
            (eglot-ensure)
            (add-hook 'before-save-hook #'eglot-format-buffer nil t)
            (message "[---EGLOT-format-buffer---] [ -- php-cs-fixer with php-cs-fixer.dist executed !! -- ]")))


;;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;; Formatter Apheleia
;;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
(defvar apheleia-mode-alist)
(leaf apheleia
  :ensure t
  :global-minor-mode apheleia-global-mode
  :config
  ;; Prettier がインストールされているプロジェクト/パスを確認して自動適用されます
  (with-eval-after-load `apheleia
    (setf (alist-get 'typescript-ts-mode apheleia-mode-alist) 'prettier)
    (setf (alist-get 'json-ts-mode apheleia-mode-alist) 'prettier)
    (setf (alist-get 'python-ts-mode apheleia-mode-alist) '(ruff-isort ruff)))
  )




;;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
;; Treemacs and Projectile
;;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
(leaf projectile
  :ensure t
  :init
  (projectile-mode +1)
  ;; Recommended keymap prefix on Windows/Linux
  :bind-keymap (("C-c p" . 'projectile-command-map)) )

(leaf ag
  :doc "The Silver Searcher"
  :ensure t)
(leaf rg
  :doc "ripgrep"
  :ensure t)

(leaf treemacs
  :ensure t
  :bind
  ;;((define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
  (:treemacs-mode-map ([mouse-1] . #'treemacs-single-click-expand-action))
  (("C-x t t"   . treemacs)
   ("C-x t 1"       . treemacs-select-window)
   )
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



(leaf treemacs-projectile
  :after (treemacs projectile)
  :ensure t)
(leaf treemacs-magit
  :after (treemacs magit)
  :ensure t)
(leaf treemacs-nerd-icons
  :doc "Need 'M-x nerd-icons-install-fonts' "
  :ensure t
  :after treemacs
  :defun treemacs-load-theme
  :require t
  :config
  (treemacs-load-theme "nerd-icons"))

;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;; vterm-toggle
;;--- --- --- --- --- --- --- --- --- --- --- --- ---

(leaf vterm
  :ensure t)

(leaf vterm-toggle
  :ensure t
  :bind
  (("C-c v"   . vterm-toggle)
   ("C-c C-v" . vterm-toggle-cd)
   ("C-c n"   . vterm-toggle-forward)
   ("C-c b"   . vterm-toggle-backward)
   )
  :custom
  ((vterm-toggle-scope . 'project)) ; プロジェクトごとにターミナルを分離
  :config
  ;; 画面下部に高さを抑えてポップアップ表示させる設定
  (add-to-list 'display-buffer-alist
               '("\\*vterm\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (slot . 0)
                 (window-height . 0.25)  ;;or (window-hight . 15) means 15columns.
                 (dedicated . t))))


;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;;    Ligature for JetBrains mono.
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
(leaf ligature
  :doc " リガチャしてみた．Setting for JetBrains Mono. "
  :ensure t
  :config
  (ligature-set-ligatures 'prog-mode '("--" "---" "==" "===" "!=" "!==" "=!="
                                       "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++" "***" ";;" "!!"
                                       "??" "???" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<:<" "<>" "<<<" ">>>"
                                       "<<" ">>" "||" "-|" "_|_" "|-" "||-" "|=" "||=" "##" "###" "####"
                                       "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#=" "^=" "<$>" "<$"
                                       "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</" "</>" "/>" "<!--" "<#--"
                                       "-->" "->" "->>" "<<-" "<-" "<=<" "=<<" "<<=" "<==" "<=>" "<==>"
                                       "==>" "=>" "=>>" ">=>" ">>=" ">>-" ">-" "-<" "-<<" ">->" "<-<" "<-|"
                                       "<=|" "|=>" "|->" "<->" "<~~" "<~" "<~>" "~~" "~~>" "~>" "~-" "-~"
                                       "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]" "|>" "<|" "||>" "<||"
                                       "|||>" "<|||" "<|>" "..." ".." ".=" "..<" ".?" "::" ":::" ":=" "::="
                                       ":?" ":?>" "//" "///" "/*" "*/" "/=" "//=" "/==" "@_" "__" "???"
                                       "<:<" ";;;"))
  (global-ligature-mode t))

;;--- --- --- --- --- --- --- --- --- --- --- --- ---
;; Markdown-Mode
;;--- --- --- --- --- --- --- --- --- --- --- --- ---
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
   (markdown-url-compose-char . nil)
   (markdown-list-indent-width . 2)
   (markdown-indent-on-enter . t)
   (indent-tabs-mode . nil))
  :custom-face
  (markdown-header-face-1 . '((t (:weight bold :height 1.3))))
  (markdown-header-face-2 . '((t (:weight bold :height 1.2))))
  (markdown-header-face-3 . '((t (:weight bold :height 1.1))))
  (markdown-header-face-4 . '((t (:weight bold :height 1.0))))
  :hook
  ((markdown-mode-hook . visual-line-mode)
   (markdown-mode-hook . jinx-mode))
  :bind
  (:markdown-mode-map
   ("C-c C-t" . markdown-toc-generate-toc)
   ("C-c C-p" . markdown-preview))
  )




(provide 'init)
;;; init.el ends here
