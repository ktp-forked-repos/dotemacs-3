;; Joe Schafer's .emacs

;; Use a decent font. 
(modify-all-frames-parameters
 '((font . "Consolas 11")))

;; Remove distractions.
(menu-bar-mode nil)
(tool-bar-mode nil)
(scroll-bar-mode nil)

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
(load "funcs")
(load "custom")
(load "colors")

(load-ranger-ranger-theme)
;; Update smex command cache after all the loads.
(smex-update)

(server-start)
