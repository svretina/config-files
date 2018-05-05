;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;  '(custom-enabled-themes (quote (tango-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(tool-bar-mode -1)
;; Clear the scratch buffer
(setq initial-scratch-message nil)

(setq visible-bell nil)
(setq package-enable-at-startup nil)
(setq confirm-kill-emacs nil)
(package-initialize)

;; Setup package manager
(require 'package)

(setq package-archives
      '(("GNU ELPA" .
   "http://elpa.gnu.org/packages/")
  ("MELPA Stable" .
   "https://stable.melpa.org/packages/")
  ("MELPA" .
   "https://melpa.org/packages/"))
      package-archive-priorities
      '(("GNU ELPA" . 10)
  ("MELPA Stable" . 5)
  ("MELPA" . 0)))
;; Setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))   
   
;; Start emacs server

(require 'server)
;; Visually indicate matching pairs of parentheses
(show-paren-mode t)
(setq show-paren-delay 0.0)

;; Enable prettification everywhere
;;(global-prettify-symbols-mode t)

(unless (server-running-p)
  (server-start))

;; Look and Feel
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(global-hl-line-mode)
;; Highlight line where the point is
(global-hl-line-mode)
(show-paren-mode t)
(setq show-paren-delay 0.0)
(winner-mode t)
(windmove-default-keybindings 'meta)
(use-package color-theme-sanityinc-solarized
  :ensure t
  :init
  (load-theme 'sanityinc-solarized-dark t)
  )

;;(use-package whole-line-or-region) i need to download it
(delete-selection-mode 1)
(electric-pair-mode 1)
(setq-default tab-stop-list (number-sequence 4 200 4))


;; Misc configurations

(setq vc-follow-symlink t)

;; When saving a file that starts with `#!', make it executable.
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; Backups

(setq backup-directory-alist    '(("." . "~/.emacs.d/backup"))
     vc-make-backup-files t ;; Use version control for backups
      version-control t     ;; Use version numbers for backups.
      kept-new-versions 2 ;; Number of newest versions to keep.
      kept-old-versions 1 ;; Number of oldest versions to keep.
      delete-old-versions t ;; Don't ask to delete excess backup versions.
      backup-by-copying t) ;; Copy all files, don't rename them.


;; Swiper for searching

(global-set-key "\C-s" 'swiper)
(global-set-key "\C-r" 'swiper)

;; Undo-tree

(use-package undo-tree
  :ensure t
  :bind (("\C-x u" . undo-tree-visualize))
  )
;; Ivy

(use-package counsel
  :diminish counsel-mode
  :ensure t
  :init
  (setq-default counsel-mode-override-describe-bindings t)
  (add-hook 'after-init-hook 'counsel-mode)
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  )
(use-package ivy
  :diminish ivy-mode
  :ensure t
  :bind
  (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq-default ivy-use-virtual-buffers t
                ivy-count-format ""
                ivy-display-style 'fancy
                projectile-completion-system 'ivy
                ivy-initial-inputs-alist
                '((counsel-M-x . "^")
                  (man . "^")
                  (woman . "^")))
  ;; IDO-style directory navigation
  (define-key ivy-minibuffer-map (kbd "C-j") #'ivy-immediate-done)
  (define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
  )

;; Company

(use-package company
  :diminish company-mode
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq completion-cycle-threshold 5)
  ;; To have completion with TAB
  (setq tab-always-indent 'complete)
  )

(use-package company-c-headers
  :diminish company-c-headers
  :ensure t
  :config
  (add-to-list 'company-backends 'company-c-headers)
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (pdf-tools auctex ledger-mode ess 0xc use-package undo-tree counsel company-c-headers color-theme-sanityinc-solarized)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(setq ring-bell-function 'ignore)


(use-package ess
  :ensure t
  :init (require 'ess-site))


;;octave mode
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))


(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))



(fset 'yes-or-no-p 'y-or-n-p)


;; When saving a file in a directory that doesn't exist, offer
;; to (recursively) create the file's parent directories.
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))

;; Kill the buffer withouth asking
(defun kill-this-buffer ()	; for the menu bar
  "Kill the current buffer overrided to work always."
  (interactive)
  (kill-buffer (current-buffer))
  )
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;; When opening a new buffer change to focus to it
;; (Taken from [[http://stackoverflow.com/questions/6464738/how-can-i-switch-focus-after-buffer-split-in-emacs][StackExchange]])
(setq split-window-preferred-function 'my/split-window-func)
(defun my/split-window-func (&optional window)
  (let ((new-window (split-window-sensibly window)))
    (if (not (active-minibuffer-window))
        (select-window new-window))))
;; Fix for man-mode
(defadvice man
    (before man activate)
  (setq split-window-preferred-function 'split-window-sensibly))
(defadvice man
    (after man activate)
  (setq split-window-preferred-function 'my/split-window-func)
  )




;; PDF-tools
(use-package pdf-tools
  :ensure t
  :mode (("\\.pdf\\'" . pdf-view-mode))
;; Don't use swyper in pdf-tools
  :bind (:map pdf-view-mode-map
              ("C-s" . isearch-forward)
              ("C-r" . isearch-backward)
        )
  :config
  ;; Ensure pdf-tools is installed
  (pdf-tools-install)

  (setq-default pdf-view-display-size 'fit-page)

  ;; Sync tex and pdf
  (defun th/pdf-view-revert-buffer-maybe (file)
    (let ((buf (find-buffer-visiting file)))
      (when buf
        (with-current-buffer buf
          (when (derived-mode-p 'pdf-view-mode)
            (pdf-view-revert-buffer nil t))))))
  (add-hook 'TeX-after-TeX-LaTeX-command-finished-hook
            #'th/pdf-view-revert-buffer-maybe)
  )


