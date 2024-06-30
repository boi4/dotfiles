(setq! bibtex-completion-bibliography '("~/Zotero/zotero_full.bib")
       bibtex-completion-library-path '("~/Zotero/storage/"))

(setq reftex-default-bibliography "~/Zotero/zotero_full.bib")

(setq! citar-bibliography '("~/Zotero/zotero_full.bib")
       citar-library-path '("~/Zotero/storage/"))


;; (setq citar-symbols
;;    `((file ,(all-the-icons-faicon "file-pdf-o" :face 'all-the-icons-red :v-adjust -0.1) . " ")
;;      (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . " ")
;;      (link ,(all-the-icons-material "link" :face 'all-the-icons-blue) . " "))
;; )

(setq citar-indicators
  (list citar-indicator-files-icons
        citar-indicator-links-icons
        citar-indicator-notes-icons
        citar-indicator-cited-icons))
(defvar citar-indicator-files-icons
  (citar-indicator-create
   :symbol (all-the-icons-faicon
            "file-o"
            :face 'all-the-icons-green
            :v-adjust -0.1)
   :function #'citar-has-files
   :padding "  " ; need this because the default padding is too low for these icons
   :tag "has:files"))

(defvar citar-indicator-links-icons
  (citar-indicator-create
   :symbol (all-the-icons-octicon
            "link"
            :face 'all-the-icons-orange
            :v-adjust 0.01)
   :function #'citar-has-links
   :padding "  "
   :tag "has:links"))

(defvar citar-indicator-notes-icons
  (citar-indicator-create
   :symbol (all-the-icons-material
            "speaker_notes"
            :face 'all-the-icons-blue
            :v-adjust -0.3)
   :function #'citar-has-notes
   :padding "  "
   :tag "has:notes"))

(defvar citar-indicator-cited-icons
  (citar-indicator-create
   :symbol (all-the-icons-faicon
            "circle-o"
            :face 'all-the-icon-green)
   :function #'citar-is-cited
   :padding "  "
   :tag "is:cited"))




(setq +latex-viewers '(zathura))


;; (add-hook 'LaTeX-mode-hook (lambda ()
;;                              (local-set-key (kbd "SPC i c") #'citar-insert-citation)))
(map! :map LaTeX-mode-map
      :n "SPC i c" #'citar-insert-citation)

(add-hook 'LaTeX-mode-hook #'citar-capf-setup)

(add-hook 'LaTeX-mode-hook (lambda () (add-to-list 'completion-at-point-functions 'citar-capf)))

(use-package! lsp-ltex
  :commands (+lsp-ltex-toggle
             +lsp-ltex-enable
             +lsp-ltex-disable
             +lsp-ltex-setup)
  :hook ((latex-mode LaTeX-mode org-mode markdown-mode html-mode bibtex-mode) . #'+lsp-ltex-setup)
  :init
  ;; There is some problematic modes when it comes to enabling LSP
  (defvar +lsp-ltex-disabled-modes '(org-msg-edit-mode))
  :config
  ;; Add doom-docs-mode to LSP language IDs
  (add-to-list 'lsp-language-id-configuration '(doom-docs-org-mode . "org"))
  :init
  (setq lsp-ltex-check-frequency "save"
        lsp-ltex-log-level "warning" ;; No need to log everything
        lsp-ltex-diagnostic-severity "warning"
        lsp-ltex-enabled ["bibtex" "context" "context.tex"
                          "html" "latex" "markdown" "org"
                          "restructuredtext" "rsweave"]
        ;; Path in which, interactively added words and rules will be stored.
        lsp-ltex-user-rules-path (expand-file-name "lsp-ltex" doom-data-dir))

  ;; When n-gram data sets are available, use them to detect errors with words
  ;; that are often confused (like their and there).
  (when (file-directory-p "/usr/share/ngrams")
    (setq lsp-ltex-additional-rules-language-model "/usr/share/ngrams"))

  (defun +lsp-ltex-setup ()
    "Load LTeX LSP server."
    (interactive)
    (require 'lsp-ltex)
    (when (and (+lsp-ltex--enabled-p)
               (not (memq major-mode +lsp-ltex-disabled-modes)))
      (lsp-deferred)))

  (defun +lsp-ltex--enabled-p ()
    (not (memq 'ltex-ls lsp-disabled-clients)))

  (defun +lsp-ltex-enable ()
    "Enable LTeX LSP for the current buffer."
    (interactive)
    (unless (+lsp-ltex--enabled-p)
      (setq-local lsp-disabled-clients (delq 'ltex-ls lsp-disabled-clients))
      (message "Enabled ltex-ls"))
    (+lsp-ltex-setup))

  (defun +lsp-ltex-disable ()
    "Disable LTeX LSP for the current buffer."
    (interactive)
    (when (+lsp-ltex--enabled-p)
      (setq-local lsp-disabled-clients (cons 'ltex-ls lsp-disabled-clients))
      (lsp-disconnect)
      (message "Disabled ltex-ls")))

  (defun +lsp-ltex-toggle ()
    "Toggle LTeX LSP for the current buffer."
    (interactive)
    (if (+lsp-ltex--enabled-p)
        (+lsp-ltex-disable)
      (+lsp-ltex-enable)))

  (map! :localleader
        :map (text-mode-map latex-mode-map LaTeX-mode-map org-mode-map markdown-mode-map)
        :desc "Toggle grammar check" "G" #'+lsp-ltex-toggle))
