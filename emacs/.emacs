;;----------------------------------------------------------------------
;; Settings
  (setq make-backup-files nil)

;;----------------------------------------------------------------------
;; Shortcut Keys
  (global-set-key [C-f8] 'compile)
  (global-set-key (kbd "C-z") 'undo)
;;  (global-unset-key [C-z])
;;  (global-unset-key [C-Z])

;;----------------------------------------------------------------------
;; Plugins
  ;; AUCTeX
    (load "auctex.el" nil t t)
    ;; preview-latex
      (load "preview-latex.el" nil t t)

  ;; Interactively Do Things [IDO]
    (require 'ido)  
    (ido-mode t)
    (setq ido-enable-flex-matching t) ;; enable fuzzy matching

  ;; auto-complete
    (add-to-list 'load-path "~/.emacs.d/plugins/auto-complete/")
    (require 'auto-complete-config)
    (add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete//ac-dict")
    (ac-config-default)

  ;; line-number
    (add-hook 'find-file-hook (lambda() (linum-mode 1)))
    (global-linum-mode 1)

;;----------------------------------------------------------------------
;; gnuplot-mode
  (autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
  (autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)
  (setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))
  (global-set-key [(f9)] 'gnuplot-make-buffer)
;;----------------------------------------------------------------------

(custom-set-variables '(inhibit-startup-screen t))
(custom-set-faces)

;;----------------------------------------------------------------------
;; LFG mode
;; (load-library "/home/rho/xle/emacs/lfg-mode")

;;----------------------------------------------------------------------
;; Arch pkg-build mode
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)
(setq auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))

;;----------------------------------------------------------------------
;; Python mode
(autoload 'python-mode "python-mode.el" "Python mode." t)
(setq auto-mode-alist (append '(("/*.\.py$" . python-mode)) auto-mode-alist))

;;----------------------------------------------------------------------
;; php mode
(autoload 'php-mode "php-mode.el" "Php mode." t)
(setq auto-mode-alist (append '(("/*.\.php[345]?$" . php-mode)) auto-mode-alist))
