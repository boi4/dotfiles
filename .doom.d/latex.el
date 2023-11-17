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
