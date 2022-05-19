;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/notes/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)



;; Comment/Uncomment
(map! :leader
      :v "/" 'comment-or-uncomment-region)
(map! :leader
      :n "/" 'comment-or-uncomment-region)
(map! :leader
      :v "cl" 'comment-or-uncomment-region)
(map! :leader
      :n "cl" 'comment-or-uncomment-region)
;; split
(map! :leader
      :n "w-" 'evil-window-split)
;; space space mx
(map! :leader
      :n "<SPC>" 'execute-extended-command)

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


;; ZOOMING
(map! :n "C-+" 'doom/increase-font-size
      :n "C-_" 'doom/decrease-font-size)

;(call-process "kitty" nil 0 nil)
;(call-process "kitty" nil 0 nil)

(map! :leader
      :n "k" (lambda () (interactive) (call-process "kitty" nil 0 nil)))


;; make "s" do subsitute like in vim
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)












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
