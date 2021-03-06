;;; misc.el --- Personal customizations for Emacs.

;;; Commentary:

(eval-when-compile
 (require 'cl-lib))

(require 'functions)

;;; Code:

;; Unnecessary.
(setq inhibit-startup-message t
      initial-scratch-message "")

;; Recent file mode.  you must set `recentf-save-file' before
;; requiring `recentf'
(setq-default recentf-save-file (my:privatize ".recentf"))
(require 'recentf)
(recentf-mode 1)

;; Saveplace - go to the last point when opening a previously closed
;; file.
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (my:privatize "places"))

;; UTF-8 everywhere
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Ignore all safe local variables.  The endless prompting is
;; annoying.
(setq-default enable-local-variables t)

;; Kill and yank use the clipboard.
(setq x-select-enable-clipboard t)

;; Disable tooltip help.  The mouse help is annoying and blocks the
;; minibuffer.
(setq show-help-function nil)

;; Follow symlinks to source controlled files without prompting.
(setq vc-follow-symlinks t)

;; Replace yes with y.
(fset 'yes-or-no-p 'y-or-n-p)

;; Disable cursor blinking
(blink-cursor-mode 0)

(setq-default bookmark-default-file (my:privatize "bookmarks"))

;; Set the path
;; (when (string-equal system-type "windows-nt")
;;   (let ((mypaths '("C:/msys64/bin")))
;;     (setenv "PATH" (concat (mapconcat 'identity mypaths ";")
;;                            ";"
;;                            (getenv "PATH")))
;;     (setq exec-path (append mypaths (list "." exec-directory)))))


;; Useful for regexps.
(put 'narrow-to-region 'disabled nil)

(put 'downcase-region 'disabled nil)

;; Helpful for csv files.
(put 'scroll-left 'disabled nil)

;; Scrolling goes back to the same place.  It's less jarring to figure
;; out where you are.
(setq scroll-preserve-screen-position 'keep)

;; Store our the position we last visited.
(require 'saveplace)
(setq save-place t
      save-place-file (my:privatize "save-place"))

(after 'windmove
  (defadvice windmove-do-window-select (around
                                        my:windmove-catch-errors
                                        activate)
    "Catch errors of `windmove' and just display the message."
    (condition-case error-info
        ad-do-it
      (error (message (nth 1 error-info))))))

(show-paren-mode 1)
(setq-default show-paren-style 'parenthesis)
;; Ido
(require 'ido)
(ido-mode t)
(setq ido-use-faces nil)

(setq ido-ignore-files
      '("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "\\`b~")
      ido-use-filename-at-point nil)
(setq ido-save-directory-list-file (my:privatize "ido.last"))
(add-to-list 'ido-ignore-buffers "*scratch*.*")
(add-to-list 'ido-ignore-buffers "^\*Messages\*")
;; Turn off the bell
(setq ring-bell-function 'ignore)

;; Tramp
(setq tramp-default-method "ssh"
      tramp-temp-name-prefix (my:privatize "tramp."))

;; Emacs backups
(setq-default auto-save-list-file-prefix
              (my:privatize "auto-save-list/.saves-")
              backup-by-copying t
              backup-directory-alist
              `(("." . ,(my:privatize ".emacs-backups")))
              kept-new-versions 3
              delete-old-versions t
              version-control t)

;; Completion options
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

(nconc completion-ignored-extensions
       '(".pyc" ".toc" ".aux" ".blg" ".ln" ".a" ".lnk" ".pif" ".ico" ".map"
         ".obj" ".bak" ".bin" "~" ".o"))

;; Never allow tabs
(setq-default indent-tabs-mode nil)

;; don't prompt for a compilation command, use make
(setq compilation-read-command nil)

(setq compilation-scroll-output 'first-error)

;; Hide the compilation buffer unless there are warnings
;; (defun my:maybe-show-compilation (buffer outstr)
;;   (unless (string-match "finished" outstr)
;;     (switch-to-buffer-other-window buffer))
;;   t)

;; (add-hook 'compilation-finish-functions 'my:maybe-show-compilation)

;; (defadvice compilation-start
;;   (around inhibit-display
;;       (command &optional mode name-function highlight-regexp))
;;   (if (not (string-match "^\\(find\\|grep\\)" command))
;;       (flet ((display-buffer)
;;          (set-window-point)
;;          (goto-char))
;;     (fset 'display-buffer 'ignore)
;;     (fset 'goto-char 'ignore)
;;     (fset 'set-window-point 'ignore)
;;     (save-window-excursion
;;       ad-do-it))
;;     ad-do-it))

;; (ad-activate 'compilation-start)
;; (ad-deactivate 'compilation-start)

;; (defvar my:ignore-successful-compilations nil
;;   "If non-nil, bury compilation buffers with no errors or
;;   warnings.")

;; (defun my:bury-compile-buffer-if-successful (buffer string)
;;   "Bury a compilation buffer if succeeded without warnings "
;;   (if (and
;;        (string-match "compilation" (buffer-name buffer))
;;        (string-match "finished" string)
;;        (not
;;         (with-current-buffer buffer
;;           (goto-char 0)
;;           (search-forward "warning" nil t))))
;;       (run-with-timer 1 nil
;;                       (lambda (buf)
;;                         (bury-buffer buf)
;;                         (switch-to-prev-buffer (get-buffer-window buf) 'kill))
;;                       buffer)))
;; (add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

;;; Usability tweaks

;; Toggle column number display in the mode line.
(column-number-mode 1)

;; Registers
(set-register ?i '(file . "~/.emacs.d/init.el"))
(set-register ?a '(file . "~/.emacs.d/lisp/autoloads.el"))
(set-register ?b '(file . "~/.emacs.d/lisp/base.el"))
(set-register ?f '(file . "~/.emacs.d/lisp/functions.el"))
(set-register ?c '(file . "~/.emacs.d/lisp/misc.el"))
(set-register ?p '(file . "~/.emacs.d/papercuts.org"))

(setq split-height-threshold 80)
(setq split-width-threshold 160)

(after 'dired
  (setq dired-listing-switches "-Alhk")
  (local-set-key "\C-\M-k" 'dired-kill-subdir))

(global-set-key (kbd "RET") 'newline-and-indent)

;; .dir-local.el tweaks
;;
;; See http://stackoverflow.com/questions/5147060/ for explanation of
;; why we're creating a new hook.  tl;dr: wierd interaction between
;; `set-auto-mode' and `hack-local-variables'
(add-hook 'hack-local-variables-hook 'my:run-local-vars-mode-hook)
(defun my:run-local-vars-mode-hook ()
  "Hook for all major-modes after processing local variables.
Creates a hook for all major modes.
e.g. `python-mode-local-vars-hook',
`emacs-lisp-mode-local-vars-hook'"
  (run-hooks (intern (format "%s-local-vars-hook" (symbol-name major-mode)))))

(defvar my:use-jinja-for-html-p nil
  "Use `jinja2-mode' if non-nil, otherwise `html-mode'.
Primarily for use in .dir-locals.el")

(defun my:maybe-choose-jinja2-mode ()
  (when my:use-jinja-for-html-p
    (jinja2-mode)))

(add-hook 'html-mode-local-vars-hook 'my:maybe-choose-jinja2-mode)

;; All programming modes
(my:add-hooks 'prog-mode-hook
  '(my:add-watchwords
    my:delete-trailing-whitespace-before-save
    my:local-comment-auto-fill))

(my:add-hooks 'rst-mode-hook
  '(my:add-watchwords
    my:delete-trailing-whitespace-before-save
    auto-fill-mode
    zotelo-minor-mode
    reftex-mode))

(my:add-hooks 'markdown-mode-hook
  '(my:add-watchwords
    my:delete-trailing-whitespace-before-save
    my:add-citations-to-sentence-end
    auto-fill-mode
    zotelo-minor-mode
    reftex-mode))


(my:add-hooks 'LaTeX-mode-hook
  '(my:add-watchwords
    my:delete-trailing-whitespace-before-save
    my:local-comment-auto-fill))

;; Emacs Lisp
(my:add-hooks 'emacs-lisp-mode-hook
              '(;; flycheck-mode
                hs-minor-mode
                my:maybe-byte-compile-after-save
                my:pretty-lambdas
                subword-mode
                turn-on-eldoc-mode))

;; Use C-x C-e to pretty print expressions
(global-set-key [remap eval-last-sexp] 'pp-eval-last-sexp)

(my:add-hooks 'org-mode-hook
              '(auto-fill-mode))

(my:add-hooks 'rst-mode-hook
              '(auto-fill-mode))
;; Ada mode
(setq ada-case-attribute 'ada-loose-case-word
      ada-case-exception-file '("~/.emacs.d/.ada_case_exceptions")
      ada-case-identifier 'ada-loose-case-word
      ada-clean-buffer-before-saving nil
      ada-label-indent 0
      ada-language-version 'ada2005
      ada-move-to-declaration t
      ada-search-directories  '("." "$ADA_INCLUDE_PATH")
      ada-xref-create-ali nil
      ada-xref-other-buffer t)

;; Python
(my:add-hooks 'python-mode-hook
  '(hs-minor-mode
    my:pretty-lambdas))

(after 'python
  (defvar my:python-oh-command-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "f") 'my:python-add-format-to-string)
      map)
    "A keymap for awesome Python shortcuts.")
  (fset 'my:python-oh-command-map my:python-oh-command-map)

  (define-key python-mode-map (kbd "C-c C-o") 'my:python-oh-command-map))

(after 'erc
  (setq erc-hide-list '("JOIN" "PART" "QUIT")))

;; Info customizations
(setenv "INFOPATH" (concat (expand-file-name "~/.emacs.d/info:")
                           (getenv "INFOPATH")))
(add-to-list 'Info-default-directory-list "~/.emacs.d/info")
(add-hook 'Info-mode-hook
          (lambda ()
            ;; Hide ^M, the carriage return
            (setq buffer-display-table (make-display-table))
            (aset buffer-display-table ?\^M [])
            (add-to-list 'Info-directory-list "~/.emacs.d/info")
    	    (setq Info-additional-directory-list Info-default-directory-list)))

;; Haskell
(my:add-hooks 'haskell-mode-hook
  '(turn-on-haskell-indentation))

;; LaTeX
(add-hook 'latex-mode-hook
          (lambda ()
            (turn-on-reftex)
            (set (make-local-variable sentence-end)
                 "[.?!][]\"')}]*\\($\\|     \\|  \\)[
]*")))

;; Automatically reload files when changed.
(global-auto-revert-mode 1)

;; Eshell
(setq-default eshell-directory-name (my:privatize "eshell"))

;; Misc
(global-set-key "\C-ha" 'apropos)
(global-set-key "\C-h\C-w" 'where-is)
(global-set-key (kbd "<f1>") 'menu-bar-mode)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(global-set-key (kbd "C-M-j") 'bs-cycle-next)
(global-set-key (kbd "C-M-k") 'bs-cycle-previous)

(after 'help-mode
  (define-key help-mode-map (kbd "L") 'help-go-back)
  (define-key help-mode-map (kbd "H") 'help-go-back)
  (define-key help-mode-map (kbd "<tab>") 'forward-button)
  (define-key help-mode-map (kbd "<shift>-<tab>") 'backward-button))

(setq eval-expression-print-level nil
      eval-expression-print-length nil)

(defvar my:mac-modifier-state 'usb
  "Toggle between BUILT-IN and USB")

(defun my:toggle-mac-modifiers ()
  (interactive)
  (cl-case my:mac-modifier-state
    ('usb
     (setq my:mac-modifier-state 'built-in
           mac-option-modifier 'control
           mac-command-modifier 'meta)
     (message "Mac modifier keys set for Mac keyboard."))

    ('built-in
     (setq my:mac-modifier-state 'usb
           mac-option-modifier 'meta
           mac-command-modifier 'super)
     (message "Mac modifier keys set for USB keyboard."))))

(global-set-key (kbd "S-SPC") '(lambda () (interactive) (insert "_")))

(when (eq system-type 'darwin)
  ;; Don't use option to input special chars, use it as alt like it
  ;; was meant to be.
  (my:toggle-mac-modifiers))

(when (eq system-type 'windows-nt)
  (add-to-list 'exec-path "~/bin"))

;; Use F-13 as compose key which I have bound to End via Karabiner
;; (Mac App)
;; (define-key key-translation-map (kbd "<f13>") 'iso-transl-ctl-x-8-map)

(defun my:fontawesome (text &optional color height)
  "Propertize TEXT using FontAwesome and COLOR."
  (propertize text
              'font-lock-face
              (append
               (when color `(:foreground ,color))
               (when height `(:height ,height))
               '(:family "FontAwesome"))))

(when (version< emacs-version "24.4")
  (global-set-key (kbd "M-SPC") 'cycle-spacing))

(provide 'misc)
;;; misc.el ends here
