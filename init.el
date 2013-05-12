;; Joe Schafer's .emacs

;; Use a decent font. 
(modify-all-frames-parameters
 '((font . "Consolas 12")))

;; Remove distractions.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Add the default-directory and all subdirectories to the load path.
(let ((default-directory "~/.emacs.d/"))
  (setq load-path (cons default-directory load-path))
  (normal-top-level-add-subdirs-to-load-path))

;; Start in a reasonable directory.
(setq default-directory "~/")

;;; Code Load
(setq custom-file "~/.emacs.d/.emacs-custom")
(load custom-file)
(load "autoloads")
(load "functions")
(load "custom")
(load-theme 'solarized-light t)

;; Update smex command cache after all the loads.
(smex-update)

(require 'server)
(or (server-running-p)
    (server-start))
