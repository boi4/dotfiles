;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; TODO: check if file exists
(load "~/.doom.d/secrets.el")


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jan Fecht"
      user-mail-address "mail@fecht.cc")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 15 :weight 'normal)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 15))
;; (setq doom-font (font-spec :family "Source Code Pro" :size 15 :weight 'normal)
;;       doom-variable-pitch-font (font-spec :family "Source Code Pro" :size 15))
;; (setq doom-font "-ADBO-Source Code Pro-normal-normal-normal-*-18-*-*-*-m-0-iso10646-1")
;; (setq doom-font "Source Code Pro Medium")
(setq doom-font (font-spec :family "Source Code Pro" :size 15 :weight 'normal :slant 'normal)
      doom-serif-font (font-spec :family "Noto Serif" :size: 15 :weight 'normal :slant 'normal)
      ;;doom-variable-pitch-font (font-spec :family "Comfortaa" :size 15 :weight 'normal :slant 'normal)
      doom-big-font (font-spec :family "Source Code Pro" :size 24 :weight 'normal :slant 'normal))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;;(setq doom-theme 'doom-miramare)
;; (setq doom-theme 'doom-ir-black)
;;(setq doom-theme 'night-owl)
;;(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/notes/org/")


;; (load "~/.doom.d/latex.el")

(setq +latex-viewers '(zathura))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Use the `orderless' completion style for vertico
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))



;; accept completion from copilot and fallback to company
;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;               ("<tab>" . 'copilot-accept-completion)
;;               ("TAB" . 'copilot-accept-completion)
;;               ("C-TAB" . 'copilot-accept-completion-by-word)
;;               ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; openai config
;; (setq codegpt-tunnel 'chat            ; The default is 'completion
;;       codegpt-model "gpt-4")  ; You can pick any model you want!
;; (setq chatgpt-model "gpt-4")  ; You can pick any model you want!
;; (setq codegpt-tunnel 'chat            ; The default is 'completion
;;       codegpt-model "gpt-3.5-turbo")
;; (setq chatgpt-model "gpt-4")  ; You can pick any model you want!
;; (map! :leader
;;       :v "ll" 'codegpt)

;; disable jk escape
(after! evil-escape
  (evil-escape-mode -1))
;; make "s" do subsitute like in vim
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)


;; Comment/Uncomment
;; (map! :leader
;;       :v "/" 'comment-or-uncomment-region)
;; (map! :leader
;;       :n "/" 'comment-or-uncomment-region)
(map! :leader
      :v "cL" 'comment-or-uncomment-region)
(map! :leader
      :n "cL" 'comment-or-uncomment-region)
;; split
(map! :leader
      :n "w-" 'evil-window-split)
;; space space mx
(map! :leader
      :n "<SPC>" 'execute-extended-command)

;; Don't use tabs per default
(setq-default indent-tabs-mode nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; PYTHON
(use-package pyvenv
:ensure t
:defer t
:diminish
:config

;    (setenv "WORKON_HOME" <your-pyworkon-venvs-folder>)
    ; Show python venv name in modeline
    (setq pyvenv-mode-line-indicator '(pyvenv-virtual-env-name ("[venv:" pyvenv-virtual-env-name "] ")))
    (pyvenv-mode t))


(add-hook! python-mode
  (setq python-shell-interpreter "ipython --no-banner --no-confirm-exit"))

(add-hook 'python-mode 'lsp)

;; ZOOMING
;; (map! :n "C-+" 'text-scale-increase
;;       :n "C-_" 'text-scale-decrease)
(map! :n "C-+" 'doom/increase-font-size
      :n "C-_" 'doom/decrease-font-size)

;; old: doom/increase-font-size
;; old: doom/decrease-font-size

(map! :n "C-<S-V>" 'evil-paste-after)

;(call-process "kitty" nil 0 nil)
;(call-process "kitty" nil 0 nil)
;
(use-package! gptel
 :config
(setq
 gptel-model "llama3:latest"
 gptel-backend (gptel-make-ollama "Ollama"
                 :host "ollama.fecht.cc"
                 :stream t
                 :models '("llama3:latest"))))



(map! :leader
      :n "ok" (lambda () (interactive) (call-process "kitty" nil 0 nil)))
(map! :leader
      :n "ow" (lambda () (interactive) (call-process "kitty" nil 0 nil "-e" "zsh" "-c" "make work")))
(map! :leader
      :n "k" (lambda () (interactive) (call-process "kitty" nil 0 nil)))


(global-clipetty-mode)


;; (add-hook 'fortran-mode-hook #'lsp-mode)
;; (add-hook 'f90-mode-hook 'eglot-ensure)
;; (add-hook 'f90-mode-hook 'lsp)



;; disable auto-closing of parenthesis
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)


(after! ruby-mode
  (setq ruby-indent-level 2))

;; ; sphinx doc
(use-package! sphinx-doc
:ensure t
:defer t
:diminish
:config
(map! :localleader
      :n "d" 'sphinx-doc)
)

(add-hook 'python-mode-hook (lambda ()
                                (require 'sphinx-doc)
                                (sphinx-doc-mode t)))
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\venv\\'"))



;; (use-package lsp-grammarly
;;   :ensure t
;;   :hook (LaTeX-mode . (lambda ()
;;                        (require 'lsp-grammarly)
;;                        (lsp))))  ; or lsp-deferred

;; (use-package lsp-ltex
;;   :ensure t
;;   :hook (text-mode . (lambda ()
;;                        (require 'lsp-ltex)
;;                        (lsp)))  ; or lsp-deferred
;;   :init
;;   (setq lsp-ltex-version "15.2.0"))





;; (after! flycheck
;;   (flycheck-define-checker proselint
;;     "A linter for prose."
;;     :command ("proselint" source-inplace)
;;     :error-patterns
;;     ((warning line-start (file-name) ":" line ":" column ": "
;;               (id (one-or-more (not (any " "))))
;;               (message) line-end))
;;     :modes (latex-mode)))


;; (use-package! lsp-grammarly
;;   :commands (+lsp-grammarly-load +lsp-grammarly-toggle)
;;   :init
;;   (defun +lsp-grammarly-load ()
;;     "Load Grammarly LSP server for LSP Mode."
;;     (interactive)
;;     (require 'lsp-grammarly)
;;     (lsp-deferred)) ;; or (lsp)

;;   (defun +lsp-grammarly-enabled-p ()
;;     (not (member 'grammarly-ls lsp-disabled-clients)))

;;   (defun +lsp-grammarly-enable ()
;;     "Enable Grammarly LSP."
;;     (interactive)
;;     (when (not (+lsp-grammarly-enabled-p))
;;       (setq lsp-disabled-clients (remove 'grammarly-ls lsp-disabled-clients))
;;       (message "Enabled grammarly-ls"))
;;     (+lsp-grammarly-load))

;;   (defun +lsp-grammarly-disable ()
;;     "Disable Grammarly LSP."
;;     (interactive)
;;     (when (+lsp-grammarly-enabled-p)
;;       (add-to-list 'lsp-disabled-clients 'grammarly-ls)
;;       (lsp-disconnect)
;;       (message "Disabled grammarly-ls")))

;;   (defun +lsp-grammarly-toggle ()
;;     "Enable/disable Grammarly LSP."
;;     (interactive)
;;     (if (+lsp-grammarly-enabled-p)
;;         (+lsp-grammarly-disable)
;;       (+lsp-grammarly-enable)))

;;   ;; (after! lsp-mode
;;   ;;   ;; Disable by default
;;   ;;   (add-to-list 'lsp-disabled-clients 'grammarly-ls))

;;   :config
;;   (set-lsp-priority! 'grammarly-ls 1))

;; (use-package flycheck
;;   :config
;;   (flycheck-add-mode 'proselint 'latex-mode)
;;   (flycheck-add-next-checker 'lsp 'proselint))

;; (add-to-list 'flycheck-checkers 'proselint)
;; (flycheck-add-next-checker 'lsp 'proselint)

;; (with-eval-after-load 'flycheck
;;   (flycheck-grammarly-setup))
;; (use-package flycheck-grammarly
;;   :ensure t
;;   :hook (LaTeX-mode . flymake-grammarly-load
;;                        (require 'flycheck-grammarly)
;;                        (lsp)))  ; or lsp-deferred

;; ;; Isabelle setup
;; (use-package! isar-mode
;;   :mode "\\.thy\\'"
;;   :config
;;   ;; (add-hook 'isar-mode-hook 'turn-on-highlight-indentation-mode)
;;   ;; (add-hook 'isar-mode-hook 'flycheck-mode)
;;   (add-hook 'isar-mode-hook 'company-mode)
;;   (add-hook 'isar-mode-hook
;;             (lambda ()
;;               (set (make-local-variable 'company-backends)
;;                    '((company-dabbrev-code company-yasnippet)))))
;;   (add-hook 'isar-mode-hook
;;             (lambda ()
;;               (set (make-local-variable 'indent-tabs-mode) nil)))
;;   (add-hook 'isar-mode-hook
;;             (lambda ()
;;               (yas-minor-mode)))
;;   )

;; (use-package! lsp-isar-parse-args
;;   :custom
;;   (lsp-isar-parse-args-nollvm nil))

;; (use-package! lsp-isar
;;   :commands lsp-isar-define-client-and-start
;;   :custom
;;   (lsp-isar-output-use-async t)
;;   (lsp-isar-output-time-before-printing-goal nil)
;;   (lsp-isar-experimental t)
;;   (lsp-isar-split-pattern 'lsp-isar-split-pattern-two-columns)
;;   (lsp-isar-decorations-delayed-printing t)
;;   :init
;;   (add-hook 'lsp-isar-init-hook 'lsp-isar-open-output-and-progress-right-spacemacs)
;;   (add-hook 'isar-mode-hook #'lsp-isar-define-client-and-start)

;;   (push (concat "~/src/isabelle-emacs/src/Tools/emacs-lsp/yasnippet")
;;    yas-snippet-dirs)
;;   (setq lsp-isar-path-to-isabelle "~/src/isabelle-emacs")
;;   )


  ;; https://github.com/m-fleury/isabelle-release/issues/21
(defun ~/evil-motion-range--wrapper (fn &rest args)
  "Like `evil-motion-range', but override field-beginning for performance.
     See URL `https://github.com/ProofGeneral/PG/issues/427'."
          (cl-letf (((symbol-function 'field-beginning)
                                  (lambda (&rest args) 1)))
                       (apply fn args)))

            (advice-add #'evil-motion-range :around #'~/evil-motion-range--wrapper)


(use-package! disaster
:ensure t
:defer t
:diminish
:config
(map! :localleader
      :v "d" 'disaster)
(setq disaster-objdump (concat disaster-objdump " -M intel"))
)
;; (setq disaster-objdump (concat disaster-objdump " -M intel"))
;; (map! :localleader
;;       :v "d" 'disaster)



;; load further scripts from additional.d
(let ((additional-dir (expand-file-name "~/.doom.d/additional.d")))
  ;; Check if the directory exists
  (when (file-directory-p additional-dir)
    ;; Iterate over each .el file in the directory
    (dolist (file (directory-files additional-dir t "\\.el$"))
      ;; Load the file
      (load file))))
