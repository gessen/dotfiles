;;; init.el --- Load the full configuration -*- lexical-binding: t -*-

;;; Commentary:

;; This file bootstraps the whole configuration.

;;; Code:

(defconst my-minimum-emacs-version "30.0"
  "This Emacs configuration does not support any Emacs version below this.")

;; Make sure we are running a modern enough Emacs, otherwise abort init.
(when (version< emacs-version my-minimum-emacs-version)
  (error (concat "This Emacs configuration requires at least Emacs %s, "
                 "but you are running Emacs %s")
         my-minimum-emacs-version emacs-version))

;;; Load built-in utility libraries

(require 'cl-lib)
(require 'map)
(require 'subr-x)

;;; Define utility functions and variables

(defmacro defadvice! (name arglist where place docstring &rest body)
  "Define an advice called NAME and add it to a function.
ARGLIST is as in `defun'. WHERE is a keyword as passed to
`advice-add' and PLACE is the function to which to add the
advice, like in `advice-add'. PLACE should be sharp-quoted.
DOCSTRING and BODY are as in `defun'."
  (declare (indent 2)
           (doc-string 5))
  (unless (stringp docstring)
    (error "Advice `%S' not documented'" name))
  (unless (and (listp place)
               (= 2 (length place))
               (eq (nth 0 place) 'function)
               (symbolp (nth 1 place)))
    (error "Advice `%S' does not sharp-quote place `%S'" name place))
  `(progn
     (defun ,name ,arglist
       ,(let ((article (if (string-match-p "^:[aeiou]" (symbol-name where))
                           "an"
                         "a")))
          (format "%s\n\nThis is %s `%S' advice for\n`%S'."
                  docstring article where
                  (if (and (listp place)
                           (memq (car place) ''function))
                      (cadr place)
                    place)))
       ,@body)
     (eval-when-compile
       (declare-function ,name nil))
     (advice-add ,place ',where #',name)
     ',name))

(defmacro defhook! (name arglist hooks docstring &rest body)
  "Define a function called NAME and add it to a hook.
ARGLIST is as in `defun'. HOOKS is a list of hooks to which to
add the function, or just a single hook. DOCSTRING and BODY are
as in `defun'."
  (declare (indent 2)
           (doc-string 4))
  (unless (listp hooks)
    (setq hooks (list hooks)))
  (dolist (hook hooks)
    (unless (string-match-p "-\\(hook\\|functions\\)$" (symbol-name hook))
      (error "Symbol `%S' is not a hook" hook)))
  (unless (stringp docstring)
    (error "No docstring provided for `my-defhook'"))
  (let ((hooks-str (format "`%S'" (car hooks))))
    (dolist (hook (cdr hooks))
      (setq hooks-str (format "%s\nand `%S'" hooks-str hook)))
    `(progn
       (defun ,name ,arglist
         ,(format "%s\n\nThis function is for use in %s."
                  docstring hooks-str)
         ,@body)
       (dolist (hook ',hooks)
         (add-hook hook ',name)))))

(defun advice-silence-messages! (func &rest args)
  "Invoke FUNC with ARGS, silencing all messages.
This is an `:around' advice for many different functions."
  (let ((message-log-max nil)
        (inhibit-message t))
    (apply func args)))

(defvar my--with-display-graphic-list '()
  "List of functions to be run after the display system is initialized.")

(defvar my--without-display-graphic-list '()
  "List of functions to be run when the display system is not initialized.")

(defhook! my--with-display-graphic ()
  server-after-make-frame-hook
  "After Emacs server creates a frame, run queued functions.
Run queued function in `my--with-display-graphic-list' to do any
setup that needs to have the display system initialized."
  (when (display-graphic-p)
    (dolist (fn (reverse my--with-display-graphic-list))
      (funcall fn))))

(defhook! my--without-display-graphic ()
  server-after-make-frame-hook
  "After Emacs server creates a frame, run queued functions.
Run queued function in `my--without-display-graphic-list' to do
any setup that is needed for terminal Emacs."
  (unless (display-graphic-p)
    (dolist (fn (reverse my--without-display-graphic-list))
      (funcall fn))))

(defmacro with-display-graphic! (&rest body)
  "Run `BODY' after display graphic is initialised.
If the display-graphic is initialized, run `BODY', otherwise, add
it to a queue of actions to perform after the first graphical
frame is created."
  (declare (indent defun))
  `(let ((init-with-graphic
          (cond
           ((boundp 'x-initialized) x-initialized)
           ;; Fallback to standard check only if Xorg was enabled.
           (t (display-graphic-p)))))
     (if init-with-graphic
         (progn
           ,@body)
       (push (lambda () ,@body) my--with-display-graphic-list))))

(defmacro without-display-graphic! (&rest body)
  "Run `BODY' when display graphic is not initialised.
If the display-graphic is not initialized, run `BODY', otherwise,
add it to a queue of actions to perform after the first non
graphical frame is created."
  (declare (indent defun))
  `(let ((init-without-graphic
          (cond
           ((boundp 'x-initialized) (not x-initialized))
           ;; Fallback to standard check only if Xorg was enabled.
           (t (not (display-graphic-p))))))
     (if init-without-graphic
         (progn
           ,@body)
       (push (lambda () ,@body) my--without-display-graphic-list))))

;;; Startup optimizations

(defvar my--initial-file-name-handler-alist
  (copy-sequence file-name-handler-alist)
  "List of initial FILE-NAME-HANDLER-ALIST to restore it later.")

;; Disable `file-name-handler-alist' during init to improve load time.
(setq file-name-handler-alist nil)

;; Decrease frequency of GC. This helps performance both during init and after
;; init. Value is in bytes so this is 100MiB.
(setq gc-cons-threshold (* 100 1024 1024))

;; After we enabled `load-prefer-newer' in early-init.el, disable it again.
;; Presumably, it slows things down and we shouldn't need it for anything but
;; loading init.el itself.
(setq load-prefer-newer nil)

;; Remove command line options that aren't relevant to our current OS - means
;; slightly less to process at startup.
(setq command-line-ns-option-alist nil)

;;; Package management

;; Disable warnings from obsolete advice system. They don't provide useful
;; diagnostic information and often they can't be fixed except by changing
;; packages upstream.
(setq ad-redefinition-action 'accept)

;; Inhibit popping up *Warnings* buffer when compiling natively.
(setq native-comp-async-report-warnings-errors 'silent)

;; Define this variable for native compilation disabled Emacs.
(setq native-comp-jit-compilation-deny-list '())

;;;; straight.el

(eval-and-compile
  ;; Get the latest version of straight.el from the develop branch, rather than
  ;; the default master which is updated less frequently
  (setq straight-repository-branch "develop")

  ;; Disable checks for package modifications to save up time during startup
  (setq straight-check-for-modifications nil)

  ;; Clear out recipe overrides (in case of re-init).
  (setq straight-recipe-overrides nil))

;; Bootstrap the package manager, straight.el.
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;;; use-package

;; Package `use-package' provides a handy macro by the same name which is
;; essentially a wrapper around `with-eval-after-load' with a lot of handy
;; syntactic sugar and useful features.
(straight-use-package 'use-package)

(eval-and-compile
  ;; When configuring a feature with `use-package', also tell straight.el to
  ;; install a package of the same name, unless otherwise specified using the
  ;; `:straight' keyword.
  (setq straight-use-package-by-default t)

  ;; Tell `use-package' to always load features lazily unless told otherwise.
  ;; It's nicer to have this kind of thing be deterministic: if `:demand' is
  ;; present, the loading is eager; otherwise, the loading is lazy.
  (setq use-package-always-defer t)

  ;; Do not automatically add -hook prefix to all hooks mentioned in :hook.
  ;; It inhibits a simple introspection of hooks by Emacs.
  (setq use-package-hook-name-suffix nil))

;; Explicitly require `use-package' when compiling to keep Flymake happy.
(eval-when-compile
  (require 'use-package))

(defmacro use-feature! (name &rest args)
  "Like `use-package', but with `straight-use-package-by-default' disabled.
NAME and ARGS are as in `use-package'."
  (declare (indent defun))
  `(use-package ,name
     :straight nil
     ,@args))

(defmacro use-package! (name &rest args)
  "Wrap `use-package'.
NAME and ARGS are as in `use-package'."
  (declare (indent defun))
  `(use-package ,name
     ,@args))

;; Package `blackout' provides a convenient function for customizing mode
;; lighters. It supports both major and minor modes with the same interface, and
;; includes `use-package' integration. The features are a strict superset of
;; those provided by similar packages `diminish', `delight' and `dim'.
(use-package! blackout
  :demand t)

;;;; straight.el configuration

;; Feature `straight-x' from package `straight' provides experimental/unstable
;; extensions to straight.el which are not yet ready for official inclusion.
(use-feature! straight-x
  ;; Add an autoload for this extremely useful command.
  :commands (straight-x-fetch-all))

;;; Keybindings

(defvar-keymap my-leader-key-map
  :doc "Keymap for all common leader key commands."
  "a" `("applications" . ,(make-sparse-keymap)) ;
  "b" `("buffers" . ,(make-sparse-keymap))
  "c" `("compile" . ,(make-sparse-keymap))
  "e" `("errors" . ,(make-sparse-keymap))
  "g" `("git" . ,(make-sparse-keymap))
  "f" `("files" . ,(make-sparse-keymap))
  "F" `("frames" . ,(make-sparse-keymap))
  "h" `("help" . ,(make-sparse-keymap))
  "i" `("insert" . ,(make-sparse-keymap))
  "j" `("jump" . ,(make-sparse-keymap))
  "k" `("macros" . ,(make-sparse-keymap))
  "o" `("org" . ,(make-sparse-keymap))
  "p" `("projects" . ,(make-sparse-keymap))
  "q" `("quit" . ,(make-sparse-keymap))
  "r" `("registers/rings" . ,(make-sparse-keymap))
  "s" `("search" . ,(make-sparse-keymap))
  "S" `("spellcheck" . ,(make-sparse-keymap))
  "t" `("toggle" . ,(make-sparse-keymap))
  "T" `("tabs" . ,(make-sparse-keymap))
  "u" `("undo" . ,(make-sparse-keymap))
  "v" `("multiple cursors" . ,(make-sparse-keymap))
  "w" `("windows" . ,(make-sparse-keymap))
  "x" `("text" . ,(make-sparse-keymap))
  "z" `("zoom" . ,(make-sparse-keymap))
  "p m" `("manage" . ,(make-sparse-keymap))
  "t h" `("highlight" . ,(make-sparse-keymap)))

(defconst my-leader-key "M-m"
  "The leader key.")

(defconst my-major-mode-leader-key "C-M-m"
  "Major mode leader key.")

(defconst my-major-mode-leader-key-alt "M-m m"
  "Alternative major mode leader key.")

(defconst my-major-mode-leader-key-alt2 "M-m M-m"
  "Another alternative major mode leader key.")

(defvar my-major-modes-alist '()
  "Each element takes the form (MAP-ACTIVE . MAJOR-MODE). The car is
the variable used to activate a map when the major mode is an
element of the cdr.")

(defhook! my--change-major-mode-after-body-hook ()
  change-major-mode-after-body-hook
  "Called to activate major mode maps in a buffer."
  (dolist (entry my-major-modes-alist) ;
    (if (boundp (car entry))
        (setf (symbol-value (car entry))
              (eq major-mode (cdr entry)))
      (message "%s is void in change major mode hook" (car entry)))))

(defmacro my--init-mode-map (map &rest args)
  "Bind keymap MAP in multiple locations.
this will create a new sparse keymap with the name MAP. Supports
conditioning the bindings on major or minor modes being active.
The options are controlled through the keyword arguments ARGS"
  (declare (indent defun))
  (let* ((root-map (intern (format "%s-root" map)))
         (active (intern (format "%s-active" map)))
         (keys '(my-major-mode-leader-key
                 my-major-mode-leader-key-alt
                 my-major-mode-leader-key-alt2))
         (minor (plist-get args :minor-mode))
         (major (plist-get args :major-mode)))
    (append
     '(progn)
     `((defvar-keymap ,map)
       (defvar-keymap ,root-map))
     (when (and (not minor) (not major))
       (error "Must use either :minor-mode or :major-mode"))
     (when minor
       `((push (cons ',minor ,root-map) minor-mode-map-alist)))
     (when major
       `((defvar-local ,active nil)
         (push (cons ',active ,root-map) minor-mode-map-alist)
         (push (cons ',active ',major) my-major-modes-alist)))
     `((dolist (key (list ,@keys))
         (keymap-set ,root-map key ,map)))
     `(',map))))

(defun set-prefixes-for-mode! (mode is-minor prefix name &rest more)
  "Declares a series of prefixes to `my-mode-map'.
MODE should be a quoted symbol corresponding to a valid mode.
IS-MINOR denotes whether that MODE is minor. PREFIX is a string
that satisfies `key-valid-p' while NAME is its displayed name."
  (declare (indent defun))
  (let ((map (intern (format "my-%s-map" mode))))
    (unless (boundp map)
      (eval `(my--init-mode-map ,map
               ,(if is-minor :minor-mode :major-mode) ,mode)))
    (while prefix
      (let* ((map (symbol-value map))
             (definition (cons name (or (keymap-lookup map prefix)
                                        (make-sparse-keymap)))))
        (keymap-set map prefix definition)
        (setq prefix (pop more)
              name (pop more))))))

(defun set-prefixes-for-minor-mode! (mode prefix name &rest more)
  "Declares a series of prefixes to `my-mode-map'.
MODE should be a quoted symbol corresponding to a valid minor
mode. PREFIX is a string that satisfies `key-valid-p' while NAME
is its displayed name."
  (declare (indent defun))
  (apply #'set-prefixes-for-mode! mode t prefix name more))

(defun set-prefixes-for-major-mode! (mode prefix name &rest more)
  "Declares a series of prefixes to `my-mode-map'.
MODE should be a quoted symbol corresponding to a valid major
mode. PREFIX is a string that satisfies `key-valid-p' while NAME
is its displayed name."
  (declare (indent defun))
  (apply #'set-prefixes-for-mode! mode nil prefix name more))

(defun set-prefixes! (prefix name &rest more)
  "Declares a series of prefixes to `my-leader-key-map'.
PREFIX is a string that satisfies `key-valid-p' while NAME is its
displayed name."
  (declare (indent defun))
  (while prefix
    (let* ((map my-leader-key-map)
           (definition (cons name (or (keymap-lookup map prefix)
                                      (make-sparse-keymap)))))
      (keymap-set map prefix definition))
    (setq prefix (pop more)
          name (pop more))))

(defun set-leader-keys-for-mode! (mode is-minor key definition &rest more)
  "Add a series of keybindings to `my-mode-map'.
MODE should be a quoted symbol corresponding to a valid mode.
IS-MINOR denotes whether that MODE is minor. KEY is a string that
satisfies `key-valid-p' while DEFINITION is anything that can be
a key's definition."
  (declare (indent defun))
  (let ((map (intern (format "my-%s-map" mode))))
    (unless (boundp map)
      (eval `(my--init-mode-map ,map
               ,(if is-minor :minor-mode :major-mode) ,mode)))
    (while key
      (keymap-set (symbol-value map) key definition)
      (setq key (pop more)
            definition (pop more)))))

(defun set-leader-keys-for-minor-mode! (mode key definition &rest more)
  "Add a series of keybindings to `my-mode-map'.
MODE should be a quoted symbol corresponding to a valid minor
mode. KEY is a string that satisfies `key-valid-p' while
DEFINITION is anything that can be a key's definition."
  (declare (indent defun))
  (apply #'set-leader-keys-for-mode! mode t key definition more))

(defun set-leader-keys-for-major-mode! (mode key definition &rest more)
  "Add a series of keybindings to `my-mode-map'.
MODE should be a quoted symbol corresponding to a valid major
mode. KEY is a string that satisfies `key-valid-p' while
DEFINITION is anything that can be a key's definition."
  (declare (indent defun))
  (apply #'set-leader-keys-for-mode! mode nil key definition more))

(defun set-leader-keys! (key definition &rest more)
  "Add a series of keybindings to `my-leader-key-map'.
KEY is a string that satisfies `key-valid-p' while DEFINITION is
anything that can be a key's definition."
  (declare (indent defun))
  (while key
    (keymap-set my-leader-key-map key definition)
    (setq key (pop more)
          definition (pop more))))

;; Bind `my-leader-key' to `my-leader-key-map'.
(keymap-global-set my-leader-key my-leader-key-map)

;; Package `which-key' displays the key bindings and associated commands
;; following the currently-entered key prefix in a popup.
(use-package! which-key
  :demand t
  :config

  ;; Replace major/minor mode prefix with a single common text.
  (dolist (key `(,my-major-mode-leader-key-alt
                 ,my-major-mode-leader-key-alt2))
    (push `((,(concat "\\`" key "\\'") . nil) . (nil . "major mode"))
          which-key-replacement-alist))

  ;; Allow a key binding to match and be modified by multiple elements in
  ;; `which-key-replacement-alist'
  (setq which-key-allow-multiple-replacements t)

  ;; Show remapped command if a command has been remapped given the currently
  ;; active keymaps
  (setq which-key-compute-remaps t)

  ;; Turn off displaying the current prefix sequence.
  (setq which-key-show-prefix nil)

  ;; Echo keystrokes almost instantly. It needs to be less than
  ;; `which-key-idle-delay' or else the keystroke echo will erase the
  ;; `which-key' popup.
  (setq which-key-echo-keystrokes 0.02)

  ;; Show first popup after 0.4 seconds and all consecutive ones almost
  ;; immediately.
  (setq which-key-idle-delay 0.4
        which-key-idle-secondary-delay 0.01)

  ;; Maximum length of key description before truncating
  (setq which-key-max-description-length 32)

  ;; Disable `help-char' override as we use `embark' for that.
  (setq which-key-use-C-h-commands nil)

  ;; Sort by key using alphabetical order, with lowercase keys having higher
  ;; priority
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-sort-uppercase-first nil)

  (which-key-mode +1)

  :blackout t)

;; Package `hydra' can be used to tie related commands into a family of short
;; bindings with a common prefix - a Hydra. Once you summon the Hydra (through
;; the prefixed binding), all the heads can be called in succession with only a
;; short extension - it's like a minor mode that disables itself automagically.
(use-package! hydra
  :demand t)

;;; Load some packages early
(use-package! nerd-icons)

;; `magit' will complain about loading built-in version of `transient'
(use-package! transient)

;;; Configure ~/.emacs.d paths

(require 'xdg)

(defconst my-config-dir user-emacs-directory
  "Directory for Emacs configuration. Must end with slash.")

(defconst my-cache-dir (concat (xdg-cache-home) "/emacs/")
  "Directory for volatile local storage. Must end with slash.")

(defconst my-data-dir (concat (xdg-data-home) "/emacs/")
  "Directory for non-volatile local storage. Must end with slash.")

;;; Environment
;;;; Encoding

;; Set encoding to UTF-8
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))

;; Explicitly set the preferred coding systems to avoid annoying prompt from
;; Emacs
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq selection-coding-system 'utf-8)

;;;; Clipboard integration

;; If you have something on the system clipboard, and then kill something in
;; Emacs, then by default whatever you had on the system clipboard is gone and
;; there is no way to get it back. Setting the following option makes it so that
;; when you kill something in Emacs, whatever was previously on the system
;; clipboard is pushed into the kill ring. This way, you can paste it with
;; `yank-pop'.
(setq save-interprogram-paste-before-kill t)

;; Package `clipetty' allows Emacs to send ANSI "Operating System Command"
;; (OSC) 52 escape sequences, to manipulate the Operating System's Clipboard
;; from an Emacs TTY frame.
(use-package! clipetty
  :if (not (display-graphic-p))
  :init

  (global-clipetty-mode +1)

  :blackout t)

;;;; Mouse integration

;; Clicking `down-mouse-3' (usually, the right mouse button) anywhere in the
;; buffer pops up a menu whose contents depends on surrounding context near the
;; mouse click.
(context-menu-mode +1)

;; Toggle pixel scrolling which allows to scroll the display precisely,
;; according to the turning of the mouse wheel
(with-display-graphic!
  (pixel-scroll-precision-mode +1)
  (keymap-unset pixel-scroll-precision-mode-map "<prior>")
  (keymap-unset pixel-scroll-precision-mode-map "<next>"))

;; Mouse integration works out of the box in windowed mode but not terminal mode
(without-display-graphic!
  ;; Enable basic mouse support (click and drag).
  (xterm-mouse-mode t))

;;;; Keyboard integration

;; Package `kpp' provides support for the Kitty Keyboard Protocol. KKP defines
;; an alternative way to handle keyboard input for programs running in the
;; terminal. This allows, if the terminal (and intermediaries such as terminal
;; multiplexers) support the protocol as well, the transmission of more detailed
;; information about a key event from the terminal to Emacs, e.g., it transmits
;; "<tab>" and "C-i" differently. Currently, there exists another solution which
;; solves the same problem, xterm’s "modifyOtherKeys", which is already
;; supported by Emacs (and activated by default if the terminal supports it).
;; KKP has the advantage of supporting more keys (e.g., "<menu>" or
;; "<Scroll_Lock>"), more key combinations (e.g., "C-M-S-z") and more modifiers,
;; i.e., the Hyper and Super keys. It can also dynamically detect if a terminal
;; supports the protocol, whereas Emacs has to deduce "modifyOtherKeys" support
;; from the TERM variable.
(use-package! kkp
  :init

  (global-kkp-mode +1))

;;;; Encryption

;; Feature `epg-config' is a basic configuration for EasyPG Emacs library.
(use-feature! epg-config
  :config

  ;; Redirect all Pinentry queries to the caller, so Emacs can query passphrase
  ;; through the minibuffer, instead of external Pinentry program.
  (setq epg-pinentry-mode 'loopback))

;;;; Miscellaneous

(defun my--command-error-function (data context signal)
  "Ignore some errors.
Ignore the `buffer-read-only', `beginning-of-buffer',
`end-of-buffer' SIGNALs; pass the rest to the default handler.
For details on DATA, CONTEXT, and signal, see
`command-error-function'."
  (when (not (memq (car data) '(buffer-read-only
                                beginning-of-buffer
                                end-of-buffer)))
    (command-error-default-function data context signal)))

(setq command-error-function #'my--command-error-function)

;; Simple 'y' or 'n' is enough
(setq use-short-answers t)

;; When exiting, kill processes without asking.
(setopt confirm-kill-processes nil)

;; Prevent Custom from modifying this file.
(setopt custom-file (expand-file-name "custom.el" my-cache-dir))

;; Silence Emacs in terminal.
(setq ring-bell-function #'ignore)

;; Disable ESC key as a modifier.
(keymap-global-set "<escape>" #'keyboard-escape-quit)

;;; Windows management

(defun maximize-buffer ()
  "Maximize buffer, use again to undo it."
  (interactive)
  (save-excursion
    (if (and (= 1 (length (window-list)))
             (assoc ?_ register-alist))
        (jump-to-register ?_)
      (progn
        (window-configuration-to-register ?_)
        (delete-other-windows)))))

(defun split-window-below-and-focus ()
  "Split the window vertically and focus the new window."
  (interactive)
  (split-window-below)
  (windmove-down))

(defun split-window-right-and-focus ()
  "Split the window horizontally and focus the new window."
  (interactive)
  (split-window-right)
  (windmove-right))

(defun split-window-single ()
  "Set the window layout to a single column."
  (interactive)
  (maximize-buffer))

(defun split-window-double (&optional keep)
  "Set the window layout to two columns.
When called with a prefix argument KEEP it splits the current
window instead."
  (interactive "P")
  (unless keep
    (maximize-buffer))
  (let* ((other-files (seq-filter #'buffer-file-name
                                  (delq (current-buffer) (buffer-list))))
         (second (split-window-right)))
    (set-window-buffer second (or (car other-files) "*scratch*"))
    (balance-windows)))

(defun split-window-triple (&optional keep)
  "Set the window layout to two columns with the right one split horizontally.
When called with a prefix argument KEEP it splits the current
window instead."
  (interactive "P")
  (unless keep
    (maximize-buffer))
  (let* ((other-files (seq-filter #'buffer-file-name
                                  (delq (current-buffer) (buffer-list))))
         (second (split-window-right))
         (third (split-window second nil 'below)))
    (set-window-buffer second (or (car other-files) "*scratch*"))
    (set-window-buffer third (or (cadr other-files) "*scratch*"))
    (balance-windows)))

(defun split-window-grid (&optional keep)
  "Set the window layout to the grid.
When called with a prefix argument KEEP it splits the current
window instead."
  (interactive "P")
  (unless keep
    (maximize-buffer))
  (let* ((other-files (seq-filter #'buffer-file-name
                                  (delq (current-buffer) (buffer-list))))
         (second (split-window-below))
         (third (split-window-right))
         (fourth (split-window second nil 'right)))
    (set-window-buffer third (or (car other-files) "*scratch*"))
    (set-window-buffer second (or (cadr other-files) "*scratch*"))
    (set-window-buffer fourth (or (caddr other-files) "*scratch*"))
    (balance-windows)))

(defun switch-to-minibuffer-window ()
  "Switch to minibuffer window (if active)."
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))

;; Set basic window management commands
(set-leader-keys!
  "b d" #'kill-current-buffer
  "b x" #'kill-buffer-and-window
  "w 0" #'delete-window
  "w 1" #'split-window-single
  "w 2" #'split-window-double
  "w 3" #'split-window-triple
  "w 4" #'split-window-grid
  "w b" #'switch-to-minibuffer-window
  "w e" #'balance-windows-area
  "w m" #'maximize-buffer
  "w s" #'split-window-below
  "w S" #'split-window-below-and-focus
  "w v" #'split-window-right
  "w V" #'split-window-right-and-focus
  "w x" #'kill-buffer-and-window)

;; Overwrite default `delete-other-windows' maximize-buffer
(keymap-global-set "<remap> <delete-other-windows>" #'maximize-buffer)

;; Shorter binding to `kill-current-buffer', overwrites `quoted-insert'.
(keymap-global-set "C-q" #'kill-current-buffer)

;; Bind keys for multi-frame management
(set-leader-keys!
  "F d" #'delete-frame
  "F D" #'delete-other-frames
  "F n" #'make-frame
  "F o" #'other-frame)

;; Remove `suspend-frame' bindings.
(keymap-global-unset "C-z")
(keymap-global-unset "C-x C-z")

;; Feature `follow' makes two windows, both showing the same buffer, scroll as a
;; single tall virtual window. In Follow mode, if you move point outside the
;; portion visible in one window and into the portion visible in the other
;; window, that selects the other window—again, treating the two as if they were
;; parts of one large window.
(use-feature! follow
  :init
  (set-leader-keys! "w F" #'follow-mode)
  :blackout t)

;; Feature `ibuffer' provides a more modern replacement for the `list-buffers'
;; command.
(use-feature! ibuffer
  :init

  (set-leader-keys! "b l" #'ibuffer-other-window)

  :bind ([remap list-buffers] . #'ibuffer-other-window))

;; Feature `windmove' provides keybindings S-left, S-right, S-up, and S-down to
;; move between windows. This is much more convenient and efficient than using
;; the default binding, C-x o, to cycle through all of them in an essentially
;; unpredictable order.
(use-feature! windmove
  ;; Avoid using `windmove-default-keybindings' as they are established in a
  ;; minor mode map and take precedence over `minibuffer-local-map'.
  :bind (("S-<left>"  . #'windmove-left)
         ("S-<right>" . #'windmove-right)
         ("S-<up>"    . #'windmove-up)
         ("S-<down>"  . #'windmove-down)))

;; Feature `winner' provides an undo/redo stack for window configurations, with
;; undo and redo being C-c left and C-c right, respectively. (Actually "redo"
;; doesn't revert a single undo, but rather a whole sequence of them.) For
;; instance, you can use C-x 1 to focus on a particular window, then return to
;; your previous layout with C-c left.
(use-feature! winner
  :demand t
  :config

  (set-leader-keys!
    "w u" #'winner-undo
    "w U" #'winner-redo)

  (setq winner-boring-buffer '("*Completions*"
                               "*Compile-Log*"
                               "*inferior-lisp*"
                               "*Fuzzy Completions*"
                               "*Apropos*"
                               "*Help*"
                               "*cvs*"
                               "*Buffer List*"
                               "*Ibuffer*"
                               "*esh command on file*"))

  ;; For some reason `winner-mode' must be delayed, otherwise launching
  ;; emacsclient in GUI may work strangely.
  (with-display-graphic! (winner-mode +1)))

;; Package `ace-window' provides a function, `ace-window' which is meant to
;; replace `other-window' by assigning each window a short, unique label. When
;; there are only two windows present, `other-window' is called. If there are
;; more, each window will have its first label character highlighted. Once a
;; unique label is typed, ace-window will switch to that window.
(use-package! ace-window
  :init

  (set-leader-keys!
    "w d" #'ace-delete-window
    "w D" #'ace-delete-other-windows
    "w M" #'ace-swap-window
    "w w" #'ace-window)
  :bind ("M-o" . #'ace-window)

  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; Package `golden-ratio' automatically resizes Emacs windows to the golden
;; ratio. The window that has the main focus will have the perfect size for
;; editing, while the ones that are not being actively edited will be re-sized
;; to a smaller size that doesn't get in the way, but at the same time will be
;; readable enough to know it's content.
(use-package! golden-ratio
  :demand t
  :config
  (set-leader-keys! "t g" #'golden-ratio-mode)

  (dolist (mode '("bs-mode"
                  "calc-mode"
                  "ediff-mode"
                  "gud-mode"
                  "gdb-locals-mode"
                  "gdb-registers-mode"
                  "gdb-breakpoints-mode"
                  "gdb-threads-mode"
                  "gdb-frames-mode"
                  "gdb-inferior-io-mode"
                  "gdb-disassembly-mode"
                  "gdb-memory-mode"
                  "speedbar-mode"
                  "vundo-mode"
                  "vundo-diff-mode"))
    (push mode golden-ratio-exclude-modes))

  (dolist (cmd '(ace-window
                 ace-delete-window
                 ace-select-window
                 ace-swap-window
                 ace-maximize-window
                 avy-pop-mark
                 next-multiframe-window
                 previous-multiframe-window
                 quit-window
                 winum-select-window-0-or-10
                 winum-select-window-1
                 winum-select-window-2
                 winum-select-window-3
                 winum-select-window-4
                 winum-select-window-5
                 winum-select-window-6
                 winum-select-window-7
                 winum-select-window-8
                 winum-select-window-9
                 windmove-left
                 windmove-right
                 windmove-up
                 windmove-down))
    (push cmd golden-ratio-extra-commands))

  (defun which-key-buffer-p ()
    "Check whether the visible buffer is a part of `which-key'."
    (and (get-buffer " *which-key*")
         (get-buffer-window " *which-key*" 'visible)))
  (push 'which-key-buffer-p golden-ratio-inhibit-functions)

  (golden-ratio-mode +1)

  :blackout t)

;; Package `ibuffer-project' provides IBuffer filtering and sorting functions to
;; group buffers by function or regexp applied to `default-directory'. By
;; default buffers are grouped by `project-current' or by `default-directory'.
(use-package! ibuffer-project
  :init

  (defhook! my--ibuffer-group-by-projects ()
    ibuffer-hook
    "Group buffers by projects."
    (setq ibuffer-filter-groups (ibuffer-project-generate-filter-groups)))

  :config

  ;; Avoid calculating project root each time by caching it.
  (setopt ibuffer-project-use-cache t))

;; Package `nerd-icons-ibuffer' provides icons for IBuffer that work in GUI
;; and in terminal.
(use-package! nerd-icons-ibuffer
  :hook (ibuffer-mode-hook . nerd-icons-ibuffer-mode))

;; Package `popper' is a minor-mode to tame the flood of ephemeral windows Emacs
;; produces, while still keeping them within arm's reach. Designate any buffer
;; to "popup" status, and it will stay out of your way. Dismiss or summon it
;; easily with one key. Cycle through all your "popups" or just the ones
;; relevant to your current buffer. Useful for many things, including toggling
;; display of REPLs, documentation, compilation or shell output, etc.
(use-package! popper
  :init

  ;; Treat help, compilation and terminal modes as popups.
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "^\\*eldoc.*\\*$"
          compilation-mode
          "\\*devdocs.*\\*$" devdocs-mode
          help-mode
          helpful-mode
          flymake-diagnostics-buffer-mode
          flymake-project-diagnostics-mode
          "^\\*eshell.*\\*$" eshell-mode
          "^\\*shell.*\\*$"  shell-mode
          "^\\*term.*\\*$"  term-mode
          "^\\*vterm.*\\*$"  vterm-mode))

  (popper-mode +1)
  (popper-echo-mode +1)

  :bind (("M-`"   . popper-toggle)
         ("C-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))

  :config

  ;; Group popups by project.el buffers.
  (setq popper-group-function 'popper-group-by-project))

;; Package `winum' helps with navigating windows and frames using numbers. It is
;; an extended and actively maintained version of the `window-numbering'
;; package. This version brings, among other things, support for number sets
;; across multiple frames, giving the user a smoother experience of multi-screen
;; Emacs.
(use-package! winum
  :demand t
  :init

  ;; Disable default keymap, it is already taken by built-in Emacs commands.
  (setq winum-keymap (make-sparse-keymap))

  :bind ( :map winum-keymap
          ("C-M-1" . #'winum-select-window-1)
          ("C-M-2" . #'winum-select-window-2)
          ("C-M-3" . #'winum-select-window-3)
          ("C-M-4" . #'winum-select-window-4)
          ("C-M-5" . #'winum-select-window-5)
          ("C-M-6" . #'winum-select-window-6)
          ("C-M-7" . #'winum-select-window-7)
          ("C-M-8" . #'winum-select-window-8)
          ("C-M-9" . #'winum-select-window-9))

  :config

  ;; Do not assign minibuffer to buffer 0 when it is active
  (setq winum-auto-assign-0-to-minibuffer nil)

  ;; Avoid modyfing modeline - we're going to do that later
  (setq winum-auto-setup-mode-line nil)

  (winum-mode +1))

;;; Files management

(defun find-user-init-file ()
  "Edit the `user-init-file' in the current window."
  (interactive)
  (find-file-existing user-init-file))

(defun find-user-emacs-directory ()
  "Open the `user-emacs-directory' in the current window."
  (interactive)
  (find-file-existing user-emacs-directory))

(defun safe-erase-buffer ()
  "Prompt before erasing the content of the file."
  (interactive)
  (if (y-or-n-p (format "Erase content of buffer %s? " (current-buffer)))
      (erase-buffer)))

(defun safe-revert-buffer ()
  "Prompt before reverting the file."
  (interactive)
  (revert-buffer nil nil))

(defun delete-current-buffer-file ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless (and filename (file-exists-p filename))
      (user-error "Buffer '%s' is not visiting a file" name))
    (if (y-or-n-p (concat "Delete file " filename " ?"))
        (progn
          (delete-file filename)
          (kill-buffer)
          (recentf-remove-if-non-kept filename)
          (message "File '%s' deleted" filename)))))

(defun open-in-external-app ()
  "Open current file in external application."
  (interactive)
  (let* ((filename (if (derived-mode-p 'dired-mode)
                       (dired-get-file-for-visit)
                     (buffer-file-name)))
         (filepath (expand-file-name (read-file-name "Open file: " filename))))
    (unless (and filepath (file-exists-p filepath))
      (user-error "File '%s' does not exist" filepath))
    (let ((process-connection-type nil))
      (start-process "" nil "xdg-open" filepath))))

;; Follow symlinks when opening files. This has the concrete impact, for
;; instance, that when you edit real init.el with M-m f e i and then later do
;; C-x C-f, you will be in the repository instead of your home directory.
(setq find-file-visit-truename t)

;; Disable the warning "X and Y are the same file" which normally appears when
;; you visit a symlinked file by the same name. Doing this isn't dangerous, as
;; it will just redirect you to the existing buffer.
(setq find-file-suppress-same-file-warnings t)

(set-prefixes! "f e" "emacs")

(set-leader-keys!
  "b e"   #'safe-erase-buffer
  "b R"   #'safe-revert-buffer
  "f A"   #'find-alternate-file
  "f c"   #'write-file
  "f D"   #'delete-current-buffer-file
  "f e i" #'find-user-init-file
  "f e d" #'find-user-emacs-directory
  "f f"   #'find-file
  "f i"   #'insert-file
  "f l"   #'find-file-literally
  "f m"   #'rename-visited-file
  "f o"   #'open-in-external-app
  "f s"   #'save-buffer
  "f S"   #'save-some-buffers
  "F f"   #'find-file-other-frame
  "T f"   #'find-file-other-tab
  "w f"   #'find-file-other-window)

;; Feature `files-x' extends file handling with local persistent variables.
(use-feature! files-x
  :init

  (set-prefixes! "f v" "variables")

  (set-leader-keys!
    "f v d" #'add-dir-local-variable
    "f v f" #'add-file-local-variable
    "f v p" #'add-file-local-variable-prop-line))

;; Feature `mule' provides basic commands for multilingual environment
(use-feature! mule
  :commands (dos2unix unix2dox)
  :init

  (set-prefixes! "f C" "convert")

  (set-leader-keys!
    "f C u" #'dos2unix
    "f C d" #'unix2dos)

  :config

  (defun dos2unix ()
    "Convert the current buffer to UNIX file format."
    (interactive)
    (set-buffer-file-coding-system 'undecided-unix nil))

  (defun unix2dos ()
    "Convert the current buffer to DOS file format."
    (interactive)
    (set-buffer-file-coding-system 'undecided-dos nil)))

;; Feature `project' provides simple operations on the current project. It
;; contains generic infrastructure for dealing with projects, some utility
;; functions, and commands using that infrastructure. The goal is to make it
;; easier for Lisp programs to operate on the current project, without having to
;; know which package handles detection of that project type, parsing its config
;; files, etc.
(use-feature! project
  :config

  (defun project-vterm ()
    "Start Vterm in the current project's root directory.
If a buffer already exists for running Vterm in the project's
root, switch to it. Otherwise, create a new vterm buffer."
    (interactive)
    (let ((default-directory (project-root (project-current t))))
      (vterm)))

  ;; Mark C++-based projects without any supported version control as projects.
  (setopt project-vc-extra-root-markers '("compile_commands.json"
                                          ".dir-locals.el"))

  ;; Use `ibuffer' for `project-list-buffers'.
  (setopt project-buffers-viewer 'project-list-buffers-ibuffer)

  ;; Show list of buffers to kill before killing project buffers.
  (setopt project-kill-buffers-display-buffer-list t)

  ;; Prefix compilation buffers with project name.
  (setopt project-compilation-buffer-name-function
          #'project-prefixed-buffer-name)

  ;; Include Dired, Magit and Vterm.
  (setopt project-switch-commands
          '((project-find-file "Find file" ?f)
            (project-find-regexp "Find regexp" ?g)
            (project-find-dir "Find directory" ?d)
            (project-dired "Dired" ?D)
            (magit-project-status "Magit" ?m)
            (project-vc-dir "VC-Dir" ?v)
            (project-vterm "Term" ?s)
            (project-eshell "Eshell" ?e)
            (project-any-command "Other" ?o)))

  ;; Do not litter `user-emacs-directory' with Project persistent history.
  (setopt project-list-file (expand-file-name "projects.el" my-cache-dir))

  (set-leader-keys!
    "p !" #'project-shell-command
    "p %" #'project-query-replace-regexp
    "p &" #'project-async-shell-command
    "p /" #'project-search
    "p b" #'project-switch-to-buffer
    "p B" #'project-display-buffer
    "p c" #'project-compile
    "p C" #'project-recompile ;; r?
    "p d" #'project-find-dir
    "p D" #'project-dired
    "p e" #'project-eshell
    "p f" #'project-find-file
    "p F" #'project-or-external-find-file
    "p g" #'project-find-regexp
    "p G" #'project-or-external-find-regexp
    "p k" #'project-kill-buffers
    "p l" #'project-list-buffers
    "p o" #'project-any-command
    "p p" #'project-switch-project
    "p s" #'project-vterm
    "p v" #'project-vc-dir
    "p x" #'project-execute-extended-command

    "p m f" #'project-forget-project
    "p m F" #'project-forget-projects-under
    "p m z" #'project-forget-zombie-projects
    "p m r" #'project-remember-projects-under

    "F p" #'project-display-buffer-other-frame))

;; Feature `recentf' maintains a menu for visiting files that were operated on
;; recently. The recent files list is automatically saved across Emacs sessions.
(use-feature! recentf
  :demand t
  :config

  ;; Never perform auto-cleanup, especially at the start.
  (setq recentf-auto-cleanup 'never)

  ;; Increase the maximum number of items of the recent list that will be saved.
  (setq recentf-max-saved-items 300)

  ;; Do not litter `user-emacs-directory' with recentf persistent history.
  (setq recentf-save-file (expand-file-name "recentf.el" my-cache-dir))

  ;; List of regexps and predicates for filenames excluded from the recent list.
  (setq recentf-exclude
        (list
         "COMMIT_EDITMSG\\'"
         my-cache-dir
         (file-truename (expand-file-name "straight" straight-base-dir))))

  ;; Suppress messages saying the recentf file was either loaded or saved.
  (dolist (func '(recentf-load-list recentf-save-list))
    (advice-add func :around #'advice-silence-messages!))

  (recentf-mode +1))

;; Feature `saveplace' automatically saves place in files, so that visiting them
;; later (even during a different Emacs session) automatically moves point to
;; the saved position, when the file is first found.
(use-feature! saveplace
  :init

  (defadvice! my--save-place-quickly-and-silently
      (save-place-alist-to-file &rest args)
    :around #'save-place-alist-to-file
    "Make `save-place' save more quickly and silently."
    (cl-letf (((symbol-function #'pp) #'prin1))
      (let ((message-log-max nil)
            (inhibit-message t))
        (apply save-place-alist-to-file args))))

  ;; Do not litter `user-emacs-directory' with persistent history file.
  (setq save-place-file (expand-file-name "places.el" my-cache-dir))

  (save-place-mode +1))

;; Feature `tramp' provides remote file editing, similar to ange-ftp. The
;; difference is that ange-ftp uses FTP to transfer files between the local and
;; the remote host, whereas tramp.el uses a combination of rsh and rcp or other
;; work-alike programs, such as ssh/scp.
(use-feature! tramp
  :config

  ;; Use ssh instead of default scp in order to utilize control master.
  (setq tramp-default-method "ssh")

  ;; Let ssh_config define them.
  (setq tramp-ssh-controlmaster-options "")

  ;; Do not litter `user-emacs-directory' with tramp files.
  (setq tramp-auto-save-directory (expand-file-name
                                   "tramp-auto-save"
                                   my-cache-dir)
        tramp-persistency-file-name (expand-file-name "tramp.el" my-cache-dir)
        tramp-backup-directory-alist backup-directory-alist))

;; Feature `uniquify' replaces Emacs's traditional method for making buffer
;; names unique with uniquification that adds parts of the file name until the
;; buffer names are unique.
(use-feature! uniquify
  :config

  ;; Use forward slashes to construct unique buffer names with the shortest
  ;; unique file path.
  (setq uniquify-buffer-name-style 'forward)

  ;; Regular expression matching buffer names that should not be uniquified.
  ;; Basically, avoid uniquifing buffers with asterisk at the start which
  ;; usually are special buffers like *Compile Log*.
  (setq uniquify-ignore-buffers-re "^\\*"))

;; Package `consult-dir' implements commands to easily switch between "active"
;; directories. The directory candidates are collected from user bookmarks,
;; project.el project roots and recentf file locations.
(use-package! consult-dir
  :after vertico
  :init

  (defun consult-dir--zoxide-dirs ()
    "Return list of zoxide dirs."
    (split-string (shell-command-to-string "zoxide query --list") "\n" t))

  (defvar consult-dir--source-zoxide
    `( :name     "Zoxide dirs"
       :narrow   ?z
       :category file
       :face     consult-file
       :history  file-name-history
       :enabled  ,(lambda () (executable-find "zoxide"))
       :items    ,#'consult-dir--zoxide-dirs)
    "Fasd directory source for `consult-dir'.")

  (set-leader-keys! "f d" #'consult-dir)

  :bind ( :map vertico-map
          ("M-l" . #'consult-dir)
          ("M-k" . #'consult-dir-jump-file))

  :config

  (add-to-list 'consult-dir-sources 'consult-dir--source-zoxide t)

  ;; Use `consult-fd' for finding.
  (setopt consult-dir-jump-file-command 'consult-fd))

;; Package `sudo-edit' allows to open files as another user, by default "root".
(use-package! sudo-edit
  :init

  (set-leader-keys! "f E" #'sudo-edit)

  (with-eval-after-load 'embark
    (keymap-set embark-file-map "s" #'sudo-edit)))

;; Package `treemacs' is a file and project explorer similar to NeoTree or vim’s
;; NerdTree, but largely inspired by the Project Explorer in Eclipse. It shows
;; the file system outlines of your projects in a simple tree layout allowing
;; quick navigation and exploration, while also possessing basic file management
;; utilities.
(use-package! treemacs
  :commands (treemacs-git-mode)
  :init

  ;; Always find and focus the current file after Treemacs is first initialised.
  (setq treemacs-follow-after-init t)

  ;; Treemacs will use the `no-other-window' parameter, in practice means that
  ;; it will become invisible to commands like `other-window'.
  (setq treemacs-is-never-other-window t)

  ;; Sort files and directories alphabetically but with case insensitive.
  (setq treemacs-sorting 'alphabetic-case-insensitive-asc)

  ;; Do not litter `user-emacs-directory' with treemacs persistent files.
  (setq treemacs-persist-file (expand-file-name
                               "treemacs-persist.el"
                               my-cache-dir)
        treemacs-last-error-persist-file (expand-file-name
                                          "treemacs-last-error-persist.el"
                                          my-cache-dir))

  (set-leader-keys!
    "p m a" #'treemacs-add-and-display-current-project-exclusively
    "p m A" #'treemacs-add-and-display-current-project)

  :bind ("M-0" . #'treemacs-select-window)

  :config

  ;; Focus currently selected file.
  (treemacs-follow-mode +1)

  ;; Check files' git status and highlight them accordingly. The simple variant
  ;; will start a git status process whose output is parsed in elisp. This
  ;; version is simpler and slightly faster, but incomplete - it will highlight
  ;; only files, not directories.
  (treemacs-git-mode 'simple)

  (with-eval-after-load 'ace-window
    ;; Let `ace-window' consider treemacs as normal window.
    (setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers))))

;; Package `treemacs-nerd-icons' provides icons for Treemacs that work in GUI
;; and in terminal.
(use-package! treemacs-nerd-icons
  :after treemacs
  :demand t
  :config

  (treemacs-load-theme "nerd-icons"))

;;; Saving files

;; Don't make backup files.
(setq make-backup-files nil)

;; Disable lockfiles (those pesky .# symlinks).
(setq create-lockfiles nil)

;; Do not litter `user-emacs-directory with auto-save files.
(setq auto-save-list-file-prefix (expand-file-name "auto-save/" my-cache-dir))
(let ((autosave-dir (expand-file-name "auto-save/site/" my-cache-dir))
      (tramp-autosave-dir (expand-file-name "auto-save/dist/" my-cache-dir)))
  (setq auto-save-file-name-transforms
        `((".*" ,autosave-dir t)
          ("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'" ,tramp-autosave-dir t)))
  (unless (file-directory-p autosave-dir)
    (make-directory autosave-dir t))
  (unless (file-directory-p tramp-autosave-dir)
    (make-directory tramp-autosave-dir t)))

;; Check `auto-mode-alist' only once with case-sensitivity
(setq auto-mode-case-fold nil)

;; Add a newline automatically at the end of the file when the file is about to
;; be saved
(setq require-final-newline t)

;; Offer to delete any autosave file when killing a buffer.
(setq kill-buffer-delete-auto-save-files t)

;;; Editing
;;;; Text formatting

;; When region is active, make `capitalize-word' and friends act on it.
(keymap-global-set "M-i" #'capitalize-dwim)
(keymap-global-set "M-l" #'downcase-dwim)
(keymap-global-set "M-u" #'upcase-dwim)

;; Rebind `quoted-insert' as C-q will be used by `kill-buffer'
(keymap-global-set "C-z" #'quoted-insert)

;; Use M-delete and M-backspace to remove word in terminal like in GUI where
;; they are automatically translated from M-DEL.
(keymap-global-set "M-<delete>"    #'backward-kill-word)
(keymap-global-set "M-<backspace>" #'backward-kill-word)

(set-leader-keys!
  "t C-f" #'auto-fill-mode
  "t t"   #'toggle-truncate-lines
  "t l"   #'visual-line-mode
  "t L"   #'global-visual-line-mode
  "x b"   #'delete-blank-lines
  "x f"   #'fill-paragraph
  "x t"   #'delete-trailing-whitespace)

;; Make `kill-line' delete the whole line when the cursor is at start of a line.
(setq kill-whole-line t)

;; Kill entire line.
(keymap-global-set "C-S-k" #'kill-whole-line)

;; When filling paragraphs, assume that sentences end with one space rather than
;; two.
(setq-default sentence-end-double-space nil)

;; Turn on `word-wrap' globally and make simple editing commands redefined to
;; act on visual lines, not logical lines.
(global-visual-line-mode +1)

;; Trigger auto-fill after punctuation characters, not just whitespace.
(mapc
 (lambda (c)
   (set-char-table-range auto-fill-chars c t))
 "!-=+]};:'\",.?")

(blackout #'auto-fill-mode " Ⓕ")
(blackout #'visual-line-mode)

;; Feature `whitespace' provides a minor mode for highlighting whitespace in
;; various special ways.
(use-feature! whitespace
  :init
  (set-leader-keys!
    "t w" #'whitespace-mode
    "t W" #'global-whitespace-mode)

  (defhook! my--whitespace-setup ()
    prog-mode-hook
    "Highlight trailing whitespaces in programming modes."
    (setq-local show-trailing-whitespace t))

  :hook (diff-mode-hook . whitespace-mode)

  :config

  ;; Remove highlighting of too long lines as another package does it better.
  (setq whitespace-style (delq 'lines whitespace-style))

  :blackout t)

;; This package provides a replacement for `comment-dwim' called
;; `comment-dwim-2', which includes more features and allows you to comment /
;; uncomment / insert comment / kill comment and indent comment depending on the
;; context. The command can be repeated several times to switch between the
;; different possible behaviors.
(use-package! comment-dwim-2
  :bind ([remap comment-dwim] . #'comment-dwim-2))

;; Package `string-inflection' allows to convert names to various other styles:
;; snake_case, UPPERCASE, PascalCase, camelCase and elisp-case.
(use-package! string-inflection
  :init

  ;; Define hydra with pink head to allow navigating buffer with the hydra
  ;; turned on.
  (defhydra hydra-string-inflection (:color pink :hint nil)
    "
[_c_] camelCase  [_s_] snake__case [_k_] elisp-case
[_p_] PascalCase [_u_] UPPER__CASE [_q_] quit
"
    ("c" string-inflection-lower-camelcase)
    ("k" string-inflection-kebab-case)
    ("p" string-inflection-camelcase)
    ("s" string-inflection-underscore)
    ("u" string-inflection-upcase)
    ("q" nil :exit t)
    ("C-g" nil :exit t))

  (set-leader-keys!
    "x c" (cons "inflection-camelcase" #'string-inflection-lower-camelcase)
    "x k" (cons "inflection-kebabcase" #'string-inflection-kebab-case)
    "x p" (cons "inflection-pascalcase" #'string-inflection-camelcase)
    "x s" (cons "inflection-snakecase" #'string-inflection-underscore)
    "x u" (cons "inflection-uppercase" #'string-inflection-upcase)
    "x x" (cons "inflections" #'hydra-string-inflection/body))

  (with-eval-after-load 'embark
    (keymap-set embark-identifier-map "x"
                '("inflections" . hydra-string-inflection/body))))

;; Package `ws-butler' unobtrusively remove trailing whitespace. What this means
;; is that only lines touched get trimmed. If the whitespace at end of buffer is
;; changed, then blank lines at the end of buffer are truncated respecting
;; `require-final-newline'. All of this happens only when saving.
(use-package! ws-butler
  :hook (prog-mode-hook . ws-butler-mode)

  :init
  (set-leader-keys! "t C-w" #'ws-butler-mode)

  :blackout t)

;;;; Indentation

;; 80 columns char limit by default, beyond that wrap lines.
(setq-default fill-column 80)

;; Distance between tab stops in columns (not the size of an indentation step)
(setq-default tab-width 2)

;; Don't use tabs for indentation, use only spaces. Otherwise, whenever the
;; indent level does not equal the tab width (e.g. in Emacs Lisp code, the
;; indent level is 2 and the tab width is 8), *both* tabs and spaces will be
;; used for indentation.
(setq-default indent-tabs-mode nil)

;; Feature `indent' contains commands for making and changing indentation in
;; text.
(use-feature! indent
  :commands (indent-rigidly
             indent-rigidly-right
             indent-rigidly-left
             indent-rigidly-right-to-tab-stop
             indent-rigidly-left-to-tab-stop)

  :init
  ;; Indent all lines interactively starting in the region.
  (set-leader-keys! "x TAB" #'indent-rigidly)
  :bind ( :map indent-rigidly-map
          ("f"   . #'indent-rigidly-right)
          ("b"   . #'indent-rigidly-left)
          ("M-f" . #'indent-rigidly-right-to-tab-stop)
          ("M-b" . #'indent-rigidly-left-to-tab-stop)))

;; Package `visual-fill-column' brings a small minor mode that mimics the effect
;; of `fill-column' in `visual-line-mode'. Instead of wrapping lines at the
;; window edge, which is the standard behaviour of `visual-line-mode', it wraps
;; lines at `fill-column'. If `fill-column' is too large for the window, the
;; text is wrapped at the window edge.
(use-package! visual-fill-column
  :init

  (set-leader-keys! "t C-l" #'visual-fill-column-mode))

;;;; Kill and yank

(defun copy-buffer-to-clipboard ()
  "Copy entire buffer to clipboard."
  (interactive)
  (clipboard-kill-ring-save (point-min) (point-max)))

(defun copy-clipboard-to-buffer ()
  "Copy clipboard and replace buffer with its content."
  (interactive)
  (delete-region (point-min) (point-max))
  (clipboard-yank)
  (deactivate-mark))

;; Move point to the first new line after `duplicate-line' or `duplicate-dwim'.
(setq duplicate-line-final-position 1)

(keymap-global-set "M-c" #'duplicate-dwim)

(set-leader-keys!
  "b i" #'clone-indirect-buffer
  "b I" #'clone-indirect-buffer-other-window
  "b y" #'copy-clipboard-to-buffer
  "b w" #'copy-buffer-to-clipboard
  "i b" #'insert-buffer)

;; Eliminate duplicates in the kill ring. That is, if you kill the same thing
;; twice, you won't have to use M-y twice to get past it to older entries in the
;; kill ring.
(setq kill-do-not-save-duplicates t)

;; Remove indentation from text saved to the kill ring.
(kill-ring-deindent-mode +1)

;; Feature `delsel' provides an alternative behaviour for certain actions when
;; you have a selection active. Namely: if you start typing when you have
;; something selected, then the selection will be deleted; and if you press DEL
;; while you have something selected, it will be deleted rather than killed.
;; (Otherwise, in both cases the selection is deselected and the normal function
;; of the key is performed.)
(use-feature! delsel
  :demand t
  :config

  (delete-selection-mode +1))

;; Package `drag-stuff' is a minor mode for dragging stuff around in Emacs. You
;; can drag lines, words and region.
(use-package! drag-stuff
  :bind (("M-<down>"  . #'drag-stuff-down)
         ("M-<up>"    . #'drag-stuff-up)
         ("M-<right>" . #'drag-stuff-right)
         ("M-<left>"  . #'drag-stuff-left)))

;; Package `easy-kill' provides commands `easy-kill' and `easy-mark' to let
;; users kill or mark things easily. `easy-kill' aims to be a drop-in
;; replacement for `kill-ring-save'.
(use-package! easy-kill
  :bind ([remap kill-ring-save] . #'easy-kill))

;; Package `hungry-delete' borrows its implementation from `cc-mode' so that
;; hungry deletion can be used in all modes.
(use-package! hungry-delete
  :demand t
  :config

  (set-leader-keys!
    "t d" #'hungry-delete-mode
    "t D" #'global-hungry-delete-mode)

  ;; Leave words separated by a single space if they would have been joined.
  (setq hungry-delete-join-reluctantly t)

  ;; Do not auto-delete LF and CR.
  (setq-default hungry-delete-chars-to-skip " \t\f\v")

  ;; Enable `hungry-delete-mode' everywhere.
  (global-hungry-delete-mode +1)

  :blackout t)

;; Package `zop-to-char' is a visual `zap-to-char' command for Emacs. It works
;; in minibuffer and you can change direction with C-b and C-f. You can also use
;; `zop-to-char' to move to a place with C-q.
(use-package! zop-to-char
  ;; Rebind `zap-to-char' to `zop-up-to-char' and bind `zop-to-char'.
  :bind (("M-z" . #'zop-up-to-char)
         ("M-Z" . #'zop-to-char)))

;;;; Selection

(defun set-mark-command-dwim ()
  "Call the mark command you want (Do What I Mean).
If you call this command multiple times at the same position, it
expands selected region.
Else, if you move from the mark and call this command, it select
the region rectangular.
Else, if you move from the mark and call this command at same
column as mark, it add cursor to each line."
  (interactive)
  (cond
   ;; Region does not exist - call `set-mark-command'
   ((not (region-active-p))
    (setq this-command 'set-mark-command)
    (call-interactively 'set-mark-command))
   ;; Region exists and is a single line - call `expreg-expand'
   ((= (line-number-at-pos) (line-number-at-pos (mark)))
    (call-interactively 'expreg-expand))
   ;; Region exists and is a multi line - either call `mc/edit-lines' or
   ;; `rectangle-mark-mode'
   (t
    (let ((column-of-mark
           (save-excursion
             (goto-char (mark))
             (current-column))))
      (if (eq column-of-mark (current-column))
          (call-interactively 'mc/edit-lines)
        (call-interactively 'rectangle-mark-mode))))))

;; Overwrite default `set-mark-command' with dwim version.
(keymap-global-set "<remap> <set-mark-command>" #'set-mark-command-dwim)

(set-leader-keys! "b a" #'mark-whole-buffer)

;; Package `easy-kill-extras' contains extra functions for `easy-kill' and
;; `easy-mark'.
(use-package! easy-kill-extras
  :demand t
  :after easy-kill
  :bind ([remap mark-word] . #'easy-mark-word)
  :config

  ;; Add more ways to select with `easy-kill'/`easy-mark'.
  (require 'extra-things)
  (push '(?W  WORD " ") easy-kill-alist)
  (push '(?\' squoted-string "") easy-kill-alist)
  (push '(?\" dquoted-string "") easy-kill-alist)
  (push '(?\` bquoted-string "") easy-kill-alist)
  (push '(?q  quoted-string "") easy-kill-alist)
  (push '(?Q  quoted-string-universal "") easy-kill-alist)
  (push '(?\( parentheses-pair-content "\n") easy-kill-alist)
  (push '(?\) parentheses-pair "\n") easy-kill-alist)
  (push '(?\[ brackets-pair-content "\n") easy-kill-alist)
  (push '(?\] brackets-pair "\n") easy-kill-alist)
  (push '(?{  curlies-pair-content "\n") easy-kill-alist)
  (push '(?}  curlies-pair "\n") easy-kill-alist)
  (push '(?<  angles-pair-content "\n") easy-kill-alist)
  (push '(?>  angles-pair "\n") easy-kill-alist))

;; Package `expreg' increases selected region by semantic units.
(use-package! expreg
  :bind ("C-=" . #'expreg-expand)
  :config

  (defvar-keymap expreg-repeat-map
    :doc "Support Expreg based selection with repeats."
    :repeat t
    "="   #'expreg-expand
    "-"   #'expreg-contract))

;;;; Multiple selection

;; Package `ace-mc' allows you to quickly add and remove `multiple-cursors' mode
;; cursors using `ace-jump'.
(use-package! ace-mc
  :init

  (set-leader-keys!
    "v j" #'ace-mc-add-multiple-cursors
    "v J" #'ace-mc-add-single-cursor))

;; Package `multiple-cursors' implements multiple cursors for Emacs in a similar
;; way in other text editors.
(use-package! multiple-cursors
  :functions (mc/mmlte--down
              mc/mmlte--up
              mc/mmlte--right
              mc/mmlte--left)
  :init

  (set-leader-keys!
    "v a" #'mc/mark-all-dwim
    "v A" #'mc/mark-all-like-this
    "v b" #'mc/edit-beginnings-of-lines
    "v e" #'mc/edit-ends-of-lines
    "v g" #'mc/vertical-align-with-space
    "v G" #'mc/vertical-align
    "v l" #'mc/edit-lines
    "v n" #'mc/mark-next-like-this
    "v p" #'mc/mark-previous-like-this
    "v r" #'mc/mark-all-in-region
    "v R" #'mc/mark-all-in-region-regexp
    "v s" #'mc/skip-to-next-like-this
    "v S" #'mc/skip-to-previous-like-this
    "v u" #'mc/unmark-next-like-this
    "v U" #'mc/unmark-previous-like-this
    "v v" #'mc/mark-more-like-this-extended
    "v w" #'mc/mark-all-words-like-this)

  (with-eval-after-load 'multiple-cursors-core
    ;; Load other `multiple-cursors' libraries.
    (require 'mc-mark-more)

    ;; Do not litter `user-emacs-directory' with settings.
    (setq mc/list-file (expand-file-name "mc-lists.el" my-data-dir))

    ;; Do not leave `multiple-cursors-mode' with RET.
    (keymap-unset mc/keymap "<return>")

    ;; Show only selected lines with `M-\''.
    (keymap-set mc/keymap "M-'" #'mc-hide-unmatched-lines-mode)

    ;; Add additional bindings for `mc/mark-more-like-this-extended' in order
    ;; to not use keyboard arrows.
    (keymap-set mc/mark-more-like-this-extended-keymap "C-n" #'mc/mmlte--down)
    (keymap-set mc/mark-more-like-this-extended-keymap "C-p" #'mc/mmlte--up)
    (keymap-set mc/mark-more-like-this-extended-keymap "C-s" #'mc/mmlte--right)
    (keymap-set mc/mark-more-like-this-extended-keymap "C-r" #'mc/mmlte--left))

  :bind (("M-}" . #'mc/mark-next-like-this-word)
         ("M-{" . #'mc/mark-previous-like-this-word)
         ("M-|" . #'mc/mark-more-like-this-extended)
         ;; Mirror other text editors to add cursor on mouse-click
         ("C-S-<mouse-1>" . #'mc/toggle-cursor-on-click)))

;;;; Rectangular selection

;; Feature `rect' provides the operations on rectangles.
(use-feature! rect
  :commands (copy-rectangle-to-register
             rectangle-exchange-point-and-mark)

  :init

  (set-prefixes! "s r" "rectangular")

  (set-leader-keys!
    "s r c" #'delete-whitespace-rectangle
    "s r d" #'delete-rectangle
    "s r e" #'rectangle-exchange-point-and-mark
    "s r i" #'copy-rectangle-to-register
    "s r k" #'kill-rectangle
    "s r m" #'rectangle-mark-mode
    "s r N" #'rectangle-number-lines
    "s r o" #'open-rectangle
    "s r s" #'string-rectangle
    "s r x" #'clear-rectangle
    "s r y" #'yank-rectangle))

;;;; Undo/redo

(set-leader-keys!
  "u r" #'undo-redo
  "u u" #'undo)

(keymap-set undo-repeat-map "/" #'undo)
(keymap-set undo-repeat-map "r" #'undo-redo)

;; Feature `warnings' allows us to enable and disable warnings.
(use-feature! warnings
  :config

  ;; Ignore the warning we get when a huge buffer is reverted and the undo
  ;; information is too large to be recorded.
  (push '(undo discard-info) warning-suppress-log-types))

;; Package `vundo' (visual undo) displays the undo history as a tree and lets
;; you move in the tree to go back to previous buffer states. To use vundo, type
;; M-x vundo RET in the buffer you want to undo. An undo tree buffer should pop
;; up.
(use-package! vundo
  :init

  (set-leader-keys!
    "a u" #'vundo
    "u v" #'vundo)

  :config

  ;; Use modern unicode symbols rather than ascii.
  (setq vundo-glyph-alist vundo-unicode-symbols))

;;;; Navigation

(defun new-empty-buffer ()
  "Create a new buffer called \"untitled<n>\"."
  (interactive)
  (let ((buffer (generate-new-buffer "untitled")))
    (set-buffer-major-mode buffer)
    ;; Prompt to save on `save-some-buffers' with positive PRED
    (with-current-buffer buffer
      (setq-local buffer-offer-save t))
    ;; Pass non-nil force-same-window to prevent `switch-to-buffer' from
    ;; displaying buffer in another window
    (switch-to-buffer buffer nil 'force-same-window)))

(defun switch-to-messages-buffer (&optional arg)
  "Switch to the `*Messages*' buffer.
If prefix argument ARG is given, switch to it in an other,
possibly new window."
  (interactive "P")
  (with-current-buffer (messages-buffer)
    (goto-char (point-max))
    (if arg
        (switch-to-buffer-other-window (current-buffer))
      (switch-to-buffer (current-buffer)))))

(set-leader-keys!
  "b m" #'switch-to-messages-buffer
  "b n" #'new-empty-buffer)

;; Keep point screen position unchanged when scrolling
(setq scroll-preserve-screen-position t)

;; More performant rapid scrolling over unfontified regions. May cause brief
;; spells of inaccurate syntax highlighting right after scrolling, which should
;; quickly self-correct.
(setq fast-but-imprecise-scrolling t)

;; Overrides the default behavior of Emacs which recenters point when it reaches
;; the top or bottom of the screen.
(setq scroll-conservatively 101)

;; Open buffers visiting read-only files in `view-mode'.
(setq view-read-only t)

(set-leader-keys! "b v" #'view-mode)

;; Feature `bookmark' provides a way to mark places in a buffer. Some other
;; packages use this package
(use-feature! bookmark
  :config

  ;; Do not litter `user-emacs-directory' with bookmarks file.
  (setq bookmark-default-file (expand-file-name "bookmarks.el" my-data-dir))

  ;; Suppress messages saying the bookmark file was either loaded or saved.
  (dolist (func '(bookmark-load bookmark-write-file))
    (advice-add func :around #'advice-silence-messages!)))

;; Feature `subword' provides a minor mode which causes the `forward-word' and
;; `backward-word' commands to stop at capitalization changes within a word, so
;; that you can step through the components of PascalCase symbols one at a time.
(use-feature! subword
  :demand t
  :config

  (set-leader-keys!
    "t c" #'subword-mode
    "t C" #'global-subword-mode)

  (global-subword-mode +1)

  :blackout t)

;; Package `golden-ratio-scroll-screen' scrolls screen down or up and highlights
;; current line before or after scrolling. The lines it scrolls is
;; scren_height * 0.618.
(use-package! golden-ratio-scroll-screen
  :bind (([remap scroll-down-command] . #'golden-ratio-scroll-screen-down)
         ([remap scroll-up-command]   . #'golden-ratio-scroll-screen-up))

  :config

  ;; Leave highlighting to `pulsar' instead.
  (setq golden-ratio-scroll-highlight-flag nil))

;; Package `avy' can move point to any position in Emacs – even in a different
;; window – using very few keystrokes. For this, you look at the position where
;; you want point to be, invoke Avy, and then enter the sequence of characters
;; displayed at that position.
(use-package! avy
  :init

  ;; Unbind `M-j' to and use it for `avy'
  (keymap-global-unset "M-j")

  :bind (("M-'"     . #'avy-goto-char)
         ("M-\""    . #'avy-goto-subword-1)
         ("M-j j"   . #'avy-goto-char-timer)
         ("M-j M-j" . #'avy-goto-char-timer)
         ("M-j k"   . #'avy-goto-char-2)
         ("M-j M-k" . #'avy-goto-char-2)
         ("M-j l"   . #'avy-goto-line)
         ("M-j M-l" . #'avy-goto-line)
         ("M-j n"   . #'avy-goto-end-of-line)
         ("M-j M-n" . #'avy-goto-end-of-line)
         ("M-j m"   . #'avy-goto-subword-1)
         ("M-j M-m" . #'avy-goto-subword-1)
         ("M-j z"   . #'avy-move-line)
         ("M-j M-z" . #'avy-move-line)
         ("M-j x"   . #'avy-move-region)
         ("M-j M-x" . #'avy-move-region)
         ("M-j a"   . #'avy-copy-line)
         ("M-j M-a" . #'avy-copy-line)
         ("M-j s"   . #'avy-copy-region)
         ("M-j M-s" . #'avy-copy-region)
         ("M-j q"   . #'avy-kill-whole-line)
         ("M-j M-q" . #'avy-kill-whole-line)
         ("M-j w"   . #'avy-kill-region)
         ("M-j M-w" . #'avy-kill-region)
         ("M-j o"   . #'avy-kill-ring-save-whole-line)
         ("M-j M-o" . #'avy-kill-ring-save-whole-line)
         ("M-j p"   . #'avy-kill-ring-save-region)
         ("M-j M-p" . #'avy-kill-ring-save-region))

  :config

  ;; Add a gray background during the selection.
  (setq avy-background t))

;; Package `beginend' redefines M-< and M-> for some modes, e.g in `dired-mode'
;; M-< goes to first line and in `prog-mode' it goes to the first line after
;; comments
(use-package! beginend
  :demand t
  :config

  (beginend-global-mode +1)

  ;; Blackout each of the defined `beginend-modes'.
  (dolist (mode beginend-modes)
    (blackout (cdr mode)))

  :blackout beginend-global-mode)

;; Package `centered-cursor-mode' Makes the cursor stay vertically in a defined
;; position, usually centered.
(use-package! centered-cursor-mode
  :init

  (set-leader-keys!
    "t -" #'centered-cursor-mode
    "t _" #'global-centered-cursor-mode)

  :config

  ;; Make the end of the file recentered.
  (setq ccm-recenter-at-end-of-file t)

  :blackout t)

;; Package `frog-jump-buffer allows you to hop to any Emacs buffer in 2-3 key
;; strokes. The buffers appear in order of most recent display or selection
;; while selecting the `avy' character next to a buffer switches to that buffer.
;; Use `0' to toggle between opening in the same window or `(other-window)'. The
;; numbers 1 through 6 will cycle through the default buffer filters.
(use-package! frog-jump-buffer
  :config

  ;; Use numbers instead of capital letters for the default filters.
  (setq frog-jump-buffer-default-filters-capital-letters nil)

  ;; Remove the current buffer from always being the first option.
  (setq frog-jump-buffer-include-current-buffer nil)

  :bind ("C-o" . #'frog-jump-buffer))

;; Package `goto-chg' allows to go to the point of the most recent edit in the
;; buffer. When repeated, go to the second most recent edit, etc. It works by
;; looking into buffer-undo-list to find points of edit.
(use-package! goto-chg
  :init

  (set-leader-keys! "j c" #'goto-last-change))

;; Package `mwim' stands for "Move Where I Mean".  It provides commands to
;; switch between various positions on the current line (particularly, to move
;; to the beginning/end of code, line or comment).
(use-package! mwim
  :bind (("C-a" . #'mwim-beginning)
         ("C-e" . #'mwim-end)
         ;; Not really using `forward-sentence' and `backward-sentence'.
         ("M-a" . #'mwim-beginning)
         ("M-e" . #'mwim-end)))

;;;; Highlighting

;; Allow to disable font colouring when needed.
(set-leader-keys!
  "t h f" #'font-lock-mode
  "t h F" #'global-font-lock-mode)

;; Feature `hl-line' provides minor mode to highlight, on a suitable terminal,
;; the line on which point is. The global mode highlights the current line in
;; the selected window only (except when the minibuffer window is selected). The
;; local mode is sticky - it highlights the line about the buffer's point even
;; if the buffer's window is not selected.
(use-feature! hl-line
  :demand t
  :config

  (set-leader-keys!
    "t h l" #'hl-line-mode
    "t h L" #'global-hl-line-mode)

  (global-hl-line-mode +1))

;; Package `column-enforce-mode' highlights text that extends beyond a column
;; limit set by various modes.
(use-package! column-enforce-mode
  :init

  (defadvice! my--set-fill-column (_)
    :after
    #'set-fill-column
    "Refresh `column-enforce-mode' after changing `fill-column'
via `set-fill-column'. Changing `fill-column' via other means
will not refresh `column-number-mode."
    (require 'column-enforce-mode)
    (when column-enforce-mode
      (column-enforce-mode -1)
      (column-enforce-mode +1)))

  (set-leader-keys!
    "t 8" #'column-enforce-mode
    "t *" #'global-column-enforce-mode)

  ;; Set the column limit with the same limit as `fill-column'.
  (setq column-enforce-column nil)

  :hook (prog-mode-hook . column-enforce-mode)

  :blackout t)

;; Package `highlight-indent-guides' highlights indentation levels via
;; `font-lock'. Indent widths are dynamically discovered, which means this
;; correctly highlights in any mode, regardless of indent width, even in
;; languages with non-uniform indentation such as Haskell. This mode works
;; properly around hard tabs and mixed indentation, and it behaves well in large
;; buffers.
(use-package! highlight-indent-guides
  :init

  (set-leader-keys! "t h i" #'highlight-indent-guides-mode)

  :config

  ;; Use normal '|' character to display guides.
  (setq highlight-indent-guides-method 'character)

  ;; Let indent level of the current line be coloured distinctly.
  (setq highlight-indent-guides-responsive 'top)

  ;; Suppress the error that sometimes prints when calculating faces by using
  ;; `highlight-indent-guides-auto-set-faces'.
  (setq highlight-indent-guides-suppress-auto-error t)

  ;; Calculate reasonable values for the indent guide colors based on the
  ;; current theme's colorscheme, and set them appropriately.
  (highlight-indent-guides-auto-set-faces)

  :blackout t)

;; Package `highlight-numbers' provides syntax highlighting of numeric literals
;; in source code, like what many editors provide by default.
(use-package! highlight-numbers
  :init

  (set-leader-keys! "t h n" #'highlight-numbers-mode)

  :hook (prog-mode-hook . highlight-numbers-mode))

;; Package `highlight-parentheses' highlights surrounding parentheses in Emacs.
(use-package! highlight-parentheses
  :init

  (set-leader-keys!
    "t h p" #'highlight-parentheses-mode
    "t h P" #'global-highlight-parentheses-mode)

  :hook (prog-mode-hook . highlight-parentheses-mode)
  :config

  ;; Make parentheses a bit more visible.
  (set-face-attribute 'highlight-parentheses-highlight nil :weight 'ultrabold)

  ;; Make most inside parentheses greenish.
  (setq highlight-parentheses-colors '("Springgreen3"
                                       "IndianRed1"
                                       "IndianRed3"
                                       "IndianRed4"))

  :blackout t)

;; Package `hl-todo' highlights TODO and similar keywords in comments and
;; strings. also provides commands for moving to the next or previous keyword,
;; to invoke `occur' with a regexp that matches all known keywords, and to
;; insert a keyword.
(use-package! hl-todo
  :demand t
  :config

  (set-prefixes! "s t" "todo")

  (set-leader-keys!
    "i t"   #'hl-todo-insert
    "s t n" #'hl-todo-next
    "s t o" #'hl-todo-occur
    "s t p" #'hl-todo-previous
    "t h t" #'hl-todo-mode
    "t h T" #'global-hl-todo-mode)

  (global-hl-todo-mode +1))

;; Package `prism' disperses lisp forms (and other languages) into a spectrum of
;; color by depth.
(use-package! prism
  :init

  (set-leader-keys!
    "t h s" #'prism-mode
    "t h S" #'prism-whitespace-mode)

  (defun prism-shuffle-colors ()
    "Shuffle random number of theme faces."
    (interactive)
    (prism-set-colors
     :num 24
     :colors (let* ((faces (list
                            'font-lock-regexp-grouping-backslash
                            'font-lock-regexp-grouping-construct
                            'font-lock-negation-char-face
                            'font-lock-preprocessor-face
                            'font-lock-function-name-face
                            'font-lock-keyword-face
                            'font-lock-variable-name-face
                            'font-lock-warning-face
                            'font-lock-builtin-face
                            'font-lock-constant-face
                            'font-lock-string-face
                            'font-lock-type-face))
                    (colors (->> faces
                                 (--map (face-attribute it :foreground))
                                 (--remove (eq 'unspecified it))
                                 -uniq))
                    (num (max 3 (random (1+ (length colors))))))
               (prism-shuffle (seq-take colors num))))))

;; Package `pulsar' temporarily highlights the current line after a given
;; function is invoked.
(use-package! pulsar
  :demand t
  :config

  ;; Pulse a line when jumping with `next-error', `consult' and `imenu' and when
  ;; opening a minibuffer.
  (dolist (hook '(next-error-hook
                  imenu-after-jump-hook
                  minibuffer-setup-hook))
    (add-hook hook #'pulsar-pulse-line))

  (with-eval-after-load 'consult
    (add-hook 'consult-after-jump-hook #'pulsar-pulse-line))

  ;; Pulse a line when jumping with `flymake' and `golden-ratio-scroll-screen'.
  (dolist (func '(flymake-goto-next-error
                  flymake-goto-prev-error
                  golden-ratio-scroll-screen-down
                  golden-ratio-scroll-screen-up))
    (push func pulsar-pulse-functions))

  (pulsar-global-mode +1))

;; Package `rainbow-delimiters' is a "rainbow parentheses"-like mode which
;; highlights parentheses, brackets, and braces according to their depth. Each
;; successive level is highlighted in a different color. This makes it easy to
;; spot matching delimiters, orient yourself in the code, and tell which
;; statements are at a given level.
(use-package! rainbow-delimiters
  :init

  (set-leader-keys! "t h r" #'rainbow-delimiters-mode)

  :hook (prog-mode-hook . rainbow-delimiters-mode))

;; Package `symbol-overlay' highlights symbols with overlays while providing a
;; keymap for various operations about highlighted symbols. It was originally
;; inspired by the package `highlight-symbol'. The fundamental difference is
;; that in `symbol-overlay' every symbol is highlighted by the Emacs built-in
;; function `overlay-put' rather than the `font-lock' mechanism used in
;; `highlight-symbol'.
(use-package! symbol-overlay
  :init

  (defhydra hydra-symbol-overlay (:color pink :hint nil)
    "
[_n_] next   [_p_] prev      [_d_] def           [_f_/_b_] switch [_t_] scope
[_e_] echo   [_o_] unoverlay [_O_] unoverlay all [_c_]^^   copy   [_z_] center
[_s_] search [_r_] replace   [_R_] rename        ^^^^             [_q_] quit
"
    ("b" symbol-overlay-switch-backward)
    ("c" symbol-overlay-save-symbol)
    ("d" symbol-overlay-jump-to-definition)
    ("e" symbol-overlay-echo-mark)
    ("f" symbol-overlay-switch-forward)
    ("n" symbol-overlay-jump-next)
    ("o" symbol-overlay-put)
    ("O" symbol-overlay-remove-all)
    ("p" symbol-overlay-jump-prev)
    ("r" symbol-overlay-query-replace)
    ("R" symbol-overlay-rename)
    ("s" symbol-overlay-isearch-literally)
    ("t" symbol-overlay-toggle-in-scope)
    ("z" recenter-top-bottom)
    ("q" nil :exit t)
    ("C-g" nil :exit t))

  (defun symbol-overlay ()
    (interactive)
    (symbol-overlay-put)
    (hydra-symbol-overlay/body))

  (set-leader-keys!
    "s o" #'symbol-overlay
    "s O" #'symbol-overlay-remove-all)

  (with-eval-after-load 'embark
    (keymap-set embark-identifier-map "y" #'symbol-overlay)
    (keymap-set embark-identifier-map "u" #'symbol-overlay-put)))

;;;; Find and replace

;; Feature `isearch' is the principal search command in Emacs and it is
;; incremental: it begins searching as soon as you type the first character of
;; the search string. As you type in the search string, Emacs shows you where
;; the string (as you have typed it so far) would be found. When you have typed
;; enough characters to identify the place you want, you can stop. Depending on
;; what you plan to do next, you may or may not need to terminate the search
;; explicitly with RET.
(use-feature! isearch
  :bind (;; Swap literal and regexp searches
         ("C-s"   . #'isearch-forward-regexp)
         ("C-r"   . #'isearch-backward-regexp)
         ("C-M-s" . #'isearch-forward)
         ("C-M-r" . #'isearch-backward))
  :config

  (defvar-keymap isearch-repeat-map
    :doc "Support Isearch based navigation with repeats."
    :repeat t
    "s" #'isearch-repeat-forward
    "r" #'isearch-repeat-backward
    "l" #'recenter-top-bottom)

  ;; Show match numbers in the search prompt.
  (setopt isearch-lazy-count t)

  ;; Increase the history size for literal searches.
  (setopt search-ring-max 100)

  ;; Increase the history size for regexp searches.
  (setopt regexp-search-ring-max 100)

  ;; Allow unlimited scrolling during incremental search.
  (setopt isearch-allow-scroll t)

  ;; Allow movement between isearch matches by cursor motion commands.
  (setopt isearch-allow-motion t)

  ;; Make motion keys yank text to the search string while moving the cursor.
  (setopt isearch-yank-on-move t)

  ;; Integrate `golden-ratio-scroll-screen' with Isearch.
  (dolist (fn '(golden-ratio-scroll-screen-down
                golden-ratio-scroll-screen-up))
    (put fn #'isearch-scroll t))

  (put 'golden-ratio-scroll-screen-down 'isearch-motion
       (cons (lambda () (goto-char (window-start)) (recenter -1 t)) 'backward))
  (put 'golden-ratio-scroll-screen-up 'isearch-motion
       (cons (lambda () (goto-char (window-end)) (recenter 0 t)) 'forward)))

;; Package `deadgrep' is the fast, beautiful text search with the help of
;; ripgrep.
(use-package! deadgrep
  :commands deadgrep--arguments
  :bind ("<f5>" . #'deadgrep)
  :config

  ;; Add additional flags to ripgrep.
  (push "--max-columns-preview" deadgrep-extra-arguments)
  (push "--max-columns=150" deadgrep-extra-arguments)
  (push "--follow" deadgrep-extra-arguments)
  (push "--hidden" deadgrep-extra-arguments))

;; Package `iedit' includes Emacs minor modes based on a API library and allows
;; you to edit one occurrence of some text in a buffer (possibly narrowed) or
;; region, and simultaneously have other occurrences edited in the same way,
;; with visual feedback as you type.
(use-package! iedit
  :init

  (set-leader-keys!
    "s e" #'iedit-mode
    "s E" #'iedit-rectangle-mode)

  :bind ( :map iedit-mode-keymap
          ("M-'" . #'iedit-show/hide-context-lines)))

;; Package `substitute' is a set of commands that perform text replacement (i)
;; throughout the buffer, (ii) limited to the current definition (per
;; narrow-to-defun), (iii) from point to the end of the buffer, and (iv) from
;; point to the beginning of the buffer. These substitutions are meant to be as
;; quick as possible and, as such, differ from the standard `query-replace'. The
;; provided commands prompt for substitute text and perform the substitution
;; outright.
(use-package! substitute
  :init

  ;; Report the matches that changed in the given context.
  (add-hook 'substitute-post-replace-functions #'substitute-report-operation)

  (set-leader-keys!
    "s s" #'substitute-target-in-buffer
    "s f" #'substitute-target-in-defun
    "s <" #'substitute-target-above-point
    "s >" #'substitute-target-below-point))

;; Package `visual-regexp' provides an alternate version of `query-replace'
;; which highlights matches and replacements as you type.
(use-package! visual-regexp
  :init

  (set-leader-keys!
    "s m" #'vr/mc-mark
    "v m" #'vr/mc-mark)

  :bind ([remap query-replace] . #'vr/query-replace)

  :config

  ;; Load `visual-regexp-steroids' after loading `visual-regexp'.
  (use-feature! visual-regexp-steroids
    :demand t))

;; Package `visual-regexp-steroids' allows `visual-regexp' to use regexp engines
;; other than Emacs'; for example, Python or Perl regexps.
(use-package! visual-regexp-steroids
  :commands vr/query-replace-literal
  :bind (([remap query-replace-regexp] . #'vr/query-replace-literal))
  :config

  (defun vr/query-replace-literal ()
    "Do a literal query-replace using `visual-regexp'."
    (interactive)
    (let ((vr/engine 'emacs-plain))
      (call-interactively #'vr/query-replace))))

;; Package `wgrep' allows you to edit a grep buffer and apply those changes to
;; the file buffer interactively.
(use-package! wgrep
  :commands wgrep-change-to-wgrep-mode
  :bind ( :map grep-mode-map
          ("C-c C-e" . #'wgrep-change-to-wgrep-mode))
  :config

  ;; Auto-save buffers after finishing editing.
  (setq wgrep-auto-save-buffer t))

;;;; Spellchecking

(defun spellchecking-mode ()
  "Enable command `flyspell-mode' or `flyspell-prog-mode'."
  (interactive)
  (if (bound-and-true-p flyspell-mode)
      (flyspell-mode-off)
    (if (derived-mode-p 'prog-mode)
        (flyspell-prog-mode)
      (flyspell-mode))))

(defun add-word-to-dict-buffer ()
  "Save word at point as correct in current buffer."
  (interactive)
  (add-word-to-dict 'buffer))

(defun add-word-to-dict-session ()
  "Save word at point as correct in current session."
  (interactive)
  (add-word-to-dict 'session))

(defun add-word-to-dict-global ()
  "Save word at point as a correct word globally."
  (interactive)
  (add-word-to-dict 'save))

(defun add-word-to-dict (scope)
  "Save word at point as a correct word.
SCOPE can be:
`buffer' for buffer local,
`session' to save in current session or
`save' to save globally."
  (let ((current-location (point))
        (word (flyspell-get-word)))
    (when (consp word)
      (flyspell-do-correct scope nil (car word) current-location
                           (cadr word) (caddr word) current-location)
      (ispell-pdict-save t))))

;; Feature `flyspell' is a minor Emacs mode performing on-the-fly spelling
;; checking.
(use-feature! flyspell
  :if (executable-find "aspell")

  :functions (flyspell-do-correct
              flyspell-get-word)
  :commands (flyspell-goto-next-error
             ispell-init-process)
  :init

  (set-prefixes! "S a" "add word")

  (set-leader-keys!
    "S a b" #'add-word-to-dict-buffer
    "S a g" #'add-word-to-dict-global
    "S a s" #'add-word-to-dict-session
    "S b"   #'flyspell-buffer
    "S d"   #'ispell-change-dictionary
    "S n"   #'flyspell-goto-next-error
    "S r"   #'flyspell-region
    "t S"   #'spellchecking-mode)

  ;; Inhibit initial aspell start message.
  (advice-add #'ispell-init-process :around #'advice-silence-messages!)

  ;; Disable default keymap as its bindings conflict with others and we use
  ;; hydra anyway.
  (setq flyspell-mode-map (make-sparse-keymap))

  :hook ((text-mode-hook outline-mode-hook) . flyspell-mode)

  :config

  ;; With `flyspell-prog-mode', check only comments and docs.
  (setq flyspell-prog-text-faces (cl-delete 'font-lock-string-face
                                            flyspell-prog-text-faces))

  ;; Do not emit messages when checking words.
  (setq flyspell-issue-message-flag nil)

  :blackout t)

;; Package `consult-flyspell' incorporates `flyspell' into `consult'. This
;; allows to display all misspelled words in the buffer with `consult', jump to
;; it and optionally apply a function to it.
(use-package! consult-flyspell
  :init

  (set-leader-keys! "S S" #'consult-flyspell)

  :config

  ;; Call `flyspell-buffer' before, unless the prefix argument is set.
  (setq consult-flyspell-always-check-buffer t)

  ;; Apply `flyspell-correct-at-point' directly after selecting candidate and
  ;; jump back to `consult-flyspell'.
  (setq consult-flyspell-select-function
        (lambda () (flyspell-correct-at-point) (consult-flyspell))))

;; Package `flyspell-correct' provides functionality for correcting words via
;; custom interfaces.
(use-package! flyspell-correct
  :init

  (defhydra hydra-flyspell (:color pink :hint nil)
    "
Spell Commands^^            Add To Dictionary^^               Other^^
--------------^^----------  -----------------^^-------------  -----^^-----------------
[_b_] check whole buffer    [_B_] add word to dict (buffer)   [_t_] toggle spell check
[_r_] check region          [_G_] add word to dict (global)   [_q_] exit
[_d_] change dictionary     [_S_] add word to dict (session)
[_n_] next spell error
[_c_] correct before point
[_s_] correct at point
"
    ("b" flyspell-buffer)
    ("B" add-word-to-dict-buffer)
    ("c" flyspell-correct-wrapper)
    ("d" ispell-change-dictionary)
    ("G" add-word-to-dict-global)
    ("n" flyspell-goto-next-error)
    ("s" flyspell-correct-at-point)
    ("S" add-word-to-dict-session)
    ("r" flyspell-region)
    ("t" spellchecking-mode)
    ("q" nil :exit t)
    ("C-g" nil :exit t))

  (set-leader-keys!
    "S c" #'flyspell-correct-wrapper
    "S s" #'flyspell-correct-at-point
    "S ." (cons "spellcheck" #'hydra-flyspell/body)))

;; Package `powerthesaurus' is an integration with powerthesaurus.org. It helps
;; to look up a word in powerthesaurus and either replace or insert selected
;; option in the buffer.
(use-package! powerthesaurus
  :init

  (set-leader-keys!
    "S t" #'powerthesaurus-lookup-synonyms-dwim
    "S T" #'powerthesaurus-lookup-antonyms-dwim))

;;;; Miscellaneous

;; Package `vlf' provides the `vlf' command, which visits part of large file
;; without loading it entirely. The buffer uses VLF mode, which provides several
;; commands for moving around, searching, comparing and editing selected part of
;; file.
(use-package! vlf
  :config
  (require 'vlf-setup))

;;;; Keyboard macros

;; Feature `kmacro' provides the user interface to Emacs' basic keyboard macro
;; functionality. With `kmacro', two function keys are dedicated to keyboard
;; macros, by default F3 and F4.
(use-feature! kmacro
  :init

  (set-prefixes!
    "k c" "counter"
    "k e" "edit"
    "k r" "ring")

  (set-leader-keys!
    "k c a" #'kmacro-add-counter
    "k c c" #'kmacro-insert-counter
    "k c C" #'kmacro-set-counter
    "k c f" #'kmacro-set-format
    "k e b" #'kmacro-bind-to-key
    "k e e" #'kmacro-edit-macro-repeat
    "k e l" #'kmacro-edit-lossage
    "k e n" #'kmacro-name-last-macro
    "k e r" #'kmacro-to-register
    "k e s" #'kmacro-step-edit-macro
    "k r d" #'kmacro-delete-ring-head
    "k r l" #'kmacro-call-ring-2nd-repeat
    "k r L" #'kmacro-view-ring-2nd
    "k r n" #'kmacro-cycle-ring-next
    "k r p" #'kmacro-cycle-ring-previous
    "k r s" #'kmacro-swap-ring
    "k k"   #'kmacro-start-macro-or-insert-counter
    "k K"   #'kmacro-end-or-call-macro
    "k l"   #'list-keyboard-macros
    "k v"   #'kmacro-view-macro-repeat))

;;; Electricity: automatic things
;;;; Autorepeat

;; Feature `repeat' provides a convenient way to repeat the previous command.
(use-feature! repeat
  :init

  ;; Suppress message saying that Repeat Mode was enabled.
  (advice-add #'repeat-mode :around #'advice-silence-messages!)

  (repeat-mode +1))

;;;; Autorevert

;; Feature `autorevert' allows the use of file-watchers or polling in order to
;; detect when the file visited by a buffer has changed, and optionally
;; reverting the buffer to match the file (unless it has unsaved changes).
(use-feature! autorevert
  :defer 2
  :commands (auto-revert--polled-buffers
             my-autorevert-inhibit-p)
  :init

  (set-leader-keys!
    "t r" #'auto-revert-mode
    "t R" #'global-auto-revert-mode)

  :config

  ;; Turn the delay on auto-reloading from 5 seconds down to 1 second. We have
  ;; to do this before turning on `auto-revert-mode' for the change to take
  ;; effect.
  (setq auto-revert-interval 1)

  ;; Auto-revert all buffers (like Dired ones), not only file-visiting buffers.
  ;; The docstring warns about potential performance problems but this should
  ;; not be an issue since we only revert visible buffers.
  (setq global-auto-revert-non-file-buffers t)

  ;; Since we automatically revert all visible buffers after one second, there's
  ;; no point in asking the user whether or not they want to do it when they
  ;; find a file. This disables that prompt.
  (setq revert-without-query '(".*"))

  ;; Silence messages from `auto-revert-mode'.
  (setq-local auto-revert-verbose nil)

  (defun my-autorevert-inhibit-p (buffer)
    "Return non-nil if autorevert should be inhibited for BUFFER."
    (or (null (get-buffer-window))
        (with-current-buffer buffer
          (or (null buffer-file-name)
              (file-remote-p buffer-file-name)))))

  (defadvice! my--autorevert-only-visible (bufs)
    :filter-return #'auto-revert--polled-buffers
    "Inhibit `autorevert' for buffers not displayed in any window."
    (cl-remove-if #'my-autorevert-inhibit-p bufs))

  (global-auto-revert-mode +1)

  :blackout (auto-revert-mode . t))

;;;; Automatic delimiter pairing

;; Show the matching paren if it is visible, and the expression otherwise.
(setq show-paren-style 'mixed)

;; Show parens when point is just inside one. This will only be done when point
;; isn't also just outside a paren.
(setq show-paren-when-point-inside-paren t)

;; Show parens when point is in the line's periphery. The periphery is at the
;; beginning or end of a line or in any whitespace there.
(setq show-paren-when-point-in-periphery t)

;; Show context around the opening paren if it is offscreen. The context is
;; usually the line that contains the openparen, except if the openparen is on
;; its own line, in which case the context includes the previous nonblank line.
;; By default, the context is shown in the echo area.
(setq show-paren-context-when-offscreen t)

;; Any matching parenthesis is highlighted in `show-paren-style' after
;; `show-paren-delay' seconds of Emacs idle time.
(show-paren-mode +1)

;; Typing an open parenthesis automatically inserts the corresponding closing
;; parenthesis, and vice versa. (Likewise for brackets, etc.). If the region is
;; active, the parentheses (brackets, etc.) are inserted around the region
;; instead.
(electric-pair-mode +1)

;; Package `surround' inserts, changes, deletes and marks surrounding pairs of
;; quotes, braces, etc.
(use-package! surround
  :init

  (defvar-keymap surround-map
    :doc "Keymap for all interactive `surround' commands."
    "c"   #'surround-change
    "d"   #'surround-delete
    "i"   #'surround-insert
    "k"   #'surround-kill
    "K"   #'surround-kill-outer
    "m"   #'surround-mark
    "M"   #'surround-mark-outer
    "["   #'surround-mark
    "]"   #'surround-mark-outer
    "M-[" #'surround-mark
    "M-]" #'surround-mark-outer)

  (keymap-global-set "M-[" surround-map))

;;;; Snippet expansion

;; Feature `abbrev' provides functionality for expanding user-defined
;; abbreviations. We prefer to use `yasnippet' instead, though.
(use-feature! abbrev
  :config

  ;; Do not litter `user-emacs-directory with persistent abbrevs file.
  (setq abbrev-file-name (expand-file-name "abbrev.el" my-data-dir))

  :blackout t)

;; Feature `hippie-exp' allows to expand text while trying various ways to find
;; its expansion. Called repeatedly it tries all possible completions in
;; succession. Which kinds of completions to try, and in which order, is
;; determined by the contents of `hippie-expand-try-functions-list'.
(use-feature! hippie-exp
  :init

  (setq hippie-expand-try-functions-list
        '(
          ;; Try to expand yasnippet snippets based on prefix
          yas-hippie-try-expand
          ;; Try to expand word "dynamically", searching the current buffer.
          try-expand-dabbrev
          ;; Try to expand word "dynamically", searching all other buffers.
          try-expand-dabbrev-all-buffers
          ;; Try to expand word "dynamically", searching the kill ring.
          try-expand-dabbrev-from-kill
          ;; Try to complete text as a file name, as many characters as unique.
          try-complete-file-name-partially
          ;; Try to complete text as a file name.
          try-complete-file-name
          ;; Try to expand word before point according to all abbrev tables.
          try-expand-all-abbrevs
          ;; Try to complete the current line to an entire line in the buffer.
          try-expand-list
          ;; Try to complete the current line to an entire line in the buffer.
          try-expand-line
          ;; Try to complete as an Emacs Lisp symbol, as many characters as
          ;; unique.
          try-complete-lisp-symbol-partially
          ;; Try to complete word as an Emacs Lisp symbol.
          try-complete-lisp-symbol))

  :bind ("M-/" . #'hippie-expand))

;; Package `auto-yasnippet' is a hybrid of keyboard macros and yasnippet. You
;; create the snippet on the go, usually to be used just in the one place. It's
;; fast, because you're not leaving the current buffer, and all you do is enter
;; the code you'd enter anyway, just placing ~ where you'd like yasnippet fields
;; and mirrors to be.
(use-package! auto-yasnippet
  :commands aya-persist-snippet

  :init

  (set-leader-keys!
    "i c" #'aya-create
    "i e" #'aya-expand
    "i o" #'aya-open-line
    "i w" #'aya-persist-snippet)

  :config

  ;; Save auto snippets in persistent location outside `user-emacs-directory'.
  (setq aya-persist-snippets-dir (expand-file-name "snippets" my-data-dir)))

;; Package `consult-yasnippet' allows to interactively select a Yasnippet
;; snippet through completing-read with in buffer previews.
(use-package! consult-yasnippet
  :init

  ;; Use `thing-at-point' as initial value for `consult-yasnippet'.
  (setq consult-yasnippet-use-thing-at-point t)

  (set-leader-keys!
    "i i" #'consult-yasnippet
    "i v" #'consult-yasnippet-visit-snippet-file))

;; Package `yasnippet' allows the expansion of user-defined abbreviations into
;; fillable templates.
(use-package! yasnippet
  :functions yas-reload-all
  :defer 1
  :commands (yas-next-field
             yas-prev-field)
  :init

  (set-leader-keys!
    "i p" #'yas-prev-field
    "i n" #'yas-next-field
    "t y" #'yas-minor-mode
    "t Y" #'yas-global-mode)

  ;; Disable default keymap with TAB expansion.
  (setq yas-minor-mode-map (make-sparse-keymap))

  ;; Save yasnippets in persistent location outside `user-emacs-directory'.
  (let ((yas-snippet-dir (expand-file-name "snippets" my-data-dir)))
    (unless (file-directory-p yas-snippet-dir)
      (make-directory yas-snippet-dir t))
    (setopt yas-snippet-dirs (list yas-snippet-dir)))

  :config

  (defadvice! my--yas-reload-all-inhibit-messages
      (yas-reload-all &rest args)
    :around #'yas-reload-all
    "Make `yas-reload-all' less verbosely."
    (let ((yas-verbosity 1))
      (apply yas-reload-all args)))

  ;; Reduce verbosity. The default value is 3. Bumping it down to 2 eliminates a
  ;; message about successful snippet lazy-loading setup on every(!) Emacs init.
  ;; Errors should still be shown.
  (setq yas-verbosity 2)

  ;; Allow stacked expansions (snippets inside snippets). Otherwise
  ;; ‘yas-next-field-or-maybe-expand’ just moves on to the next field
  (setopt yas-triggers-in-field t)

  ;; Insert region contents when selected as snippet's $0 field.
  (setopt yas-wrap-around-region t)

  ;; Enable snippets everywhere
  (yas-global-mode +1)

  :blackout (yas-minor-mode . t))

;; Package `yasnippet-snippets' is the official snippet collection for the
;; `yasnippet' package.
(use-package! yasnippet-snippets
  :after yasnippet)

;;; Candidate selection

;; Do not consider case significant in completion
(setq completion-ignore-case t)

;; Allow doing a command that requires candidate-selection when you are already
;; in the middle of candidate-selection.
(setq enable-recursive-minibuffers t)

;; Feature `savehist' saves minibuffer history to an external file after exit.
(use-feature! savehist
  :demand t
  :config

  ;; Maximum length of history lists before truncation takes place. Truncation
  ;; deletes old elements, and is done just after inserting a new element.
  (setq history-length 1000)

  ;; The interval between autosaves of minibuffer history.
  (setq savehist-autosave-interval 60)

  ;; Save history of additional variables such as `mark-ring'
  (setq savehist-additional-variables '(mark-ring
                                        global-mark-ring
                                        kill-ring
                                        search-ring
                                        regexp-search-ring
                                        extended-command-history))

  ;; Do not litter `user-emacs-directory' with persistent history file.
  (setq savehist-file (expand-file-name "savehist.el" my-cache-dir))

  (savehist-mode +1))

;; Package `nerd-icons-completion' adds icons to completion candidates using
;; the built in completion metadata functions.
(use-package! nerd-icons-completion
  :after (marginalia nerd-icons)
  :hook (marginalia-mode-hook . nerd-icons-completion-marginalia-setup)
  :init

  (nerd-icons-completion-mode +1))

;; Package `consult' implements a set of commands which use `completing-read' to
;; select from a list of candidates. Most provided commands follow the naming
;; scheme `consult-<thing>'. Some commands are drop-in replacements for existing
;; functions or the enhanced buffer switcher `consult-buffer.' Other commands
;; provide additional functionality, e.g., `consult-line', to search for a line.
;; Many commands support candidate preview. If a candidate is selected in the
;; completion view, the buffer shows the candidate immediately.
(use-package! consult
  :init

  (defun consult-line-symbol-at-point ()
    "Search for a matching line starting search with symbol at
point. "
    (interactive)
    (consult-line (thing-at-point 'symbol)))

  (set-leader-keys!
    "/"   (cons "search project" #'consult-ripgrep)
    "a m" #'consult-man
    "b b" #'consult-buffer
    "b B" #'consult-buffer-other-window
    "b f" #'consult-focus-lines
    "b k" #'consult-keep-lines
    "F b" #'consult-buffer-other-frame
    "f b" #'consult-bookmark
    "f F" #'consult-fd
    "f r" #'consult-recent-file
    "g /" #'consult-git-grep
    "j i" #'consult-imenu
    "j I" #'consult-imenu-multi
    "k m" #'consult-kmacro
    "r l" #'consult-register-load
    "r r" #'consult-register
    "r s" #'consult-register-store
    "r y" #'consult-yank-replace
    "t T" #'consult-theme
    "T b" #'consult-buffer-other-tab)

  ;; Narrow and widen selection with "[".
  (setq consult-narrow-key "[")

  ;; Configure the register formatting. This improves the register preview
  ;; for `consult-register', `consult-register-load', `consult-register-store'
  ;; and the Emacs built-ins.
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)

  ;; Tweak the register preview window. This adds stripes, sorting and hides the
  ;; mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  :bind (([remap goto-line] . #'consult-goto-line)
         ("M-g b"           . #'consult-bookmark)
         ("M-g M-b"         . #'consult-bookmark)
         ("M-g i"           . #'consult-imenu-multi)
         ("M-g M-i"         . #'consult-imenu-multi)
         ("M-g k"           . #'consult-global-mark)
         ("M-g M-k"         . #'consult-global-mark)
         ("M-g l"           . #'consult-line)
         ("M-g M-l"         . #'consult-line)
         ("M-g ;"           . #'consult-line-symbol-at-point)
         ("M-g M-;"         . #'consult-line-symbol-at-point)
         ("M-g m"           . #'consult-mark)
         ("M-g M-m"         . #'consult-mark)
         ("M-g o"           . #'consult-outline)
         ("M-g M-o"         . #'consult-outline)
         ("M-g r"           . #'consult-register)
         ("M-g M-r"         . #'consult-register)
         ("M-g /"           . #'consult-line-multi)
         ("M-g M-/"         . #'consult-line-multi)
         ([remap yank-pop]  . #'consult-yank-replace)
         ("M-s l"           . #'consult-line)
         ("M-s M-l"         . #'consult-line)
         ("M-s ;"           . #'consult-line-symbol-at-point)
         ("M-s M-;"         . #'consult-line-symbol-at-point))

  :config

  (consult-customize
   ;; Preview themes on any key press, but delay 0.5s.
   consult-theme :preview-key '(:debounce 0.5 any)
   ;; Disable the automatic preview only for commands, where the preview may be
   ;; expensive due to file loading.
   consult-ripgrep consult-git-grep consult-grep
   consult-recent-file
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file
   :preview-key "M-."))

;; Package `embark' provides a sort of right-click contextual menu for Emacs,
;; accessed through the `embark-act' command (which you should bind to a
;; convenient key), offering you relevant actions to use on a target determined
;; by the context.
(use-package! embark
  :commands (embark-next-symbol
             embark-previous-symbol)
  :init

  (set-leader-keys!
    "?"   (cons "describe keybinds" #'embark-bindings)
    "h B" #'embark-bindings)

  ;; Replace the key help with a completing-read interface.
  (setq prefix-help-command #'embark-prefix-help-command)

  :bind (("M-n"     . #'embark-next-symbol)
         ("M-p"     . #'embark-previous-symbol)
         ("M-s a"   . #'embark-act)
         ("M-s M-a" . #'embark-act)
         ("M-s A"   . #'embark-act-all)
         ("M-s M-A" . #'embark-act-all)
         ("M-s c"   . #'embark-collect)
         ("M-s M-c" . #'embark-collect)
         ("M-s e"   . #'embark-export)
         ("M-s M-e" . #'embark-export)
         ("M-s s"   . #'embark-dwim)
         ("M-s M-s" . #'embark-dwim)
         ("C-h B"   . #'embark-bindings))

  :config

  (defun embark-which-key-indicator ()
    "An embark indicator that displays keymaps using which-key.
The which-key help message will show the type and value of the
current target followed by an ellipsis if there are further
targets."
    (lambda (&optional keymap targets prefix)
      (if (null keymap)
          (which-key--hide-popup-ignore-command)
        (which-key--show-keymap
         (if (eq (plist-get (car targets) :type) 'embark-become)
             "Become"
           (format "Act on %s '%s'%s"
                   (plist-get (car targets) :type)
                   (embark--truncate-target (plist-get (car targets) :target))
                   (if (cdr targets) "…" "")))
         (if prefix
             (pcase (lookup-key keymap prefix 'accept-default)
               ((and (pred keymapp) km) km)
               (_ (key-binding prefix 'accept-default)))
           keymap)
         nil nil t (lambda (binding)
                     (not (string-suffix-p "-argument" (cdr binding))))))))

  ;; Display more compact display with the help of `which-key' for Embark
  ;; indicators.
  (setq embark-indicators
        '(embark-which-key-indicator
          embark-highlight-indicator
          embark-isearch-highlight-indicator))

  (defadvice! my--embark-hide-which-key-indicator (fn &rest args)
    :around #'embark-completing-read-prompter
    "Hide the which-key indicator immediately when using the
completing-read prompter."
    (which-key--hide-popup-ignore-command)
    (let ((embark-indicators
           (remq #'embark-which-key-indicator embark-indicators)))
      (apply fn args))))

;; Package `embark-consult' provides integration between Embark and Consult.
(use-package! embark-consult)

;; Package `marginalia' enriches existing commands with completion annotations
;; by adding marginalia to the minibuffer completions. Marginalia are marks or
;; annotations placed at the margin of the page of a book or in this case
;; helpful colorful annotations placed at the margin of the minibuffer for
;; completion candidates. Marginalia can only add annotations to be displayed
;; with the completion candidates. It cannot modify the appearance of the
;; candidates themselves, which are shown as supplied by the original commands.
;; The annotations are added based on the completion category. For example,
;; `find-file' reports the file category and `M-x' reports the command category.
(use-package! marginalia
  :init

  (marginalia-mode +1)

  :bind ( :map minibuffer-local-map
          ("M-A" . marginalia-cycle)))

;; Package `orderless' provides an orderless completion style that divides the
;; pattern into components (space-separated by default), and matches candidates
;; that match all of the components in any order.
(use-package! orderless
  :demand t
  :config

  ;; Rely on `orderless' for completions with `basic' fallback in order to
  ;; ensure that completion commands which rely on dynamic completion tables,
  ;; e.g., `completion-table-dynamic' or `completion-table-in-turn', work
  ;; correctly.
  (setopt completion-styles '(orderless basic))
  (setq completion-category-defaults nil)

  ;; Modify default dispatch list to use \"?\" for fuzzy matching.
  (setopt orderless-affix-dispatch-alist
          '((?% . char-fold-to-regexp)
            (?! . orderless-without-literal)
            (?, . orderless-initialism)
            (?= . orderless-literal)
            (?? . orderless-flex))))

;; Package `prescient' is a library for intelligent sorting and filtering in
;; various contexts.
(use-package! prescient
  :demand t
  :config

  ;; Remember usage statistics across Emacs sessions.
  (prescient-persist-mode +1)

  ;; The default setting seem a little too low.
  (setq prescient-history-length 1000)

  ;; Sort fully matched candidates before others. Prescient can sort by recency,
  ;; frequency, and candidate length. With this option, fully matched candidates
  ;; will be sorted before partially matched candidates, but candidates in each
  ;; group will still be sorted like normal.
  (setq prescient-sort-full-matches-first t)

  ;; Do not litter `user-emacs-directory' with persistent prescient file.
  (setq prescient-save-file (expand-file-name
                             "prescient-save.el"
                             my-cache-dir)))

;; Package `vertico' provides a performant and minimalistic vertical completion
;; UI based on the default completion system. The main focus of Vertico is to
;; provide a UI which behaves correctly under all circumstances. By reusing the
;; built-in facilities system, Vertico achieves full compatibility with built-in
;;  Emacs completion commands and completion tables. Vertico only provides the
;; completion UI but aims to be highly flexible, extensible and modular.
;; Additional enhancements are available as extensions or complementary
;; packages.
(use-package! vertico
  :straight (:files (:defaults "extensions/*"))
  :init

  (defadvice! my--vertico-add-history ()
    :after #'vertico-insert
    "Make `vertico-insert' add to the minibuffer history."
    (unless (eq minibuffer-history-variable t)
      (add-to-history minibuffer-history-variable (minibuffer-contents))))

  (defun vertico-restrict-to-matches ()
    "Restrict the set of candidates to the currently visible candidates."
    (interactive)
    (let ((inhibit-read-only t))
      (goto-char (point-max))
      (insert " ")
      (add-text-properties (minibuffer-prompt-end) (point-max)
                           '(invisible t read-only t cursor-intangible t
                                       rear-nonsticky t))))

  (vertico-mode +1)

  :bind ( :map vertico-map
          ("<next>"    . #'vertico-scroll-up)
          ("<prior>"   . #'vertico-scroll-down)
          ("C-M-n"     . #'vertico-next-group)
          ("C-M-p"     . #'vertico-previous-group)
          ("S-SPC"     . #'vertico-restrict-to-matches)
          :map minibuffer-local-map
          ("M-s"       . nil))

  :config

  ;; Hide unused path within file path, e.g. /a/b/c//tmp would show only /tmp.
  (setq file-name-shadow-properties '(invisible t)
        file-name-shadow-tty-properties '(invisible t))

  ;; Wrap around when using `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)

  ;; Feature `vertico-directory' provides Ido-like directory navigation
  ;; commands.
  (use-feature! vertico-directory
    :demand t
    :bind ( :map vertico-map
            ("<backtab>" . #'vertico-directory-delete-word)))

  ;; Feature `vertico-flat' enables flat, horizontal display.
  (use-feature! vertico-flat
    :demand t
    :bind ( :map vertico-map
            ("M-q" . #'vertico-flat-mode)))

  ;; Feature! vertico-mouse' adds mouse support for scrolling and candidate
  ;; selection.
  (use-feature! vertico-mouse
    :demand t
    :config

    (vertico-mouse-mode +1))

  ;; Feature `vertico-multiform' configures Vertico modes per command or
  ;; per completion category.
  (use-feature! vertico-multiform
    :demand t
    :config

    ;; Configure the display per completion category.
    (setq vertico-multiform-categories
          '((consult-grep buffer)
            (consult-location buffer)
            (imenu buffer)))

    (vertico-multiform-mode +1))

  ;; Feature `vertico-quick' provides commands to select using Avy-style quick
  ;; keys.
  (use-feature! vertico-quick
    :demand t
    :bind ( :map vertico-map
            ("M-i" . #'vertico-quick-insert)
            ("M-j" . #'vertico-quick-exit))))

;; Package `vertico-prescient' provides an interface for using Prescient to
;; sort and filter candidates in Vertico menus.
(use-package! vertico-prescient
  :demand t
  :after vertico
  :config

  ;; Let `orderless' filter candidates.
  (setq vertico-prescient-enable-filtering nil)

  ;; Use `prescient' for Vertico menus.
  (vertico-prescient-mode +1))

;;; IDE features
;;;; Definition location

;; Package `dumb-jump' provides a mechanism to jump to the definitions of
;; functions, variables, etc. in a variety of programming languages. The
;; advantage of `dumb-jump' is that it doesn't try to be clever, so it "just
;; works" instantly for dozens of languages with zero configuration.
(use-package! dumb-jump
  :after xref
  :commands xref-backend-functions
  :init

  ;; Reuse `xref' interface.
  (add-hook #'xref-backend-functions #'dumb-jump-xref-activate)

  :config

  ;; Don't waste time on searching for other grep-like tools.
  (setopt dumb-jump-force-searcher 'rg))

;; Package `xref' provides a somewhat generic infrastructure for cross
;; referencing commands, in particular "find-definition". Some part of the
;; functionality must be implemented in a language dependent way and that's done
;; by defining an xref backend.
(use-package! xref
  :init

  (set-leader-keys!
    "F ." #'xref-find-definitions-other-frame
    "w ." #'xref-find-definitions-other-window)

  :config

  ;; Prompt only if no identifier is at point.
  (setopt xref-prompt-for-identifier nil)

  ;; Use ripgrep for regexp search inside files.
  (setopt xref-search-program 'ripgrep))

;; Feature `consult-xref' provides Xref integration for Consult.
(use-feature! consult-xref
  :demand t
  :after xref
  :config

  ;; Use `consult' completion with preview.
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref))

;; Package `consult-xref-stack' navigates the Xref stack with Consult.
(use-package! consult-xref-stack
  :straight (:host github :repo "brett-lempereur/consult-xref-stack")
  :bind ("C-," . #'consult-xref-stack-backward))

;;;; Display contextual metadata

;; Feature `eldoc' provides a minor mode (enabled by default in Emacs 25) which
;; allows function signatures or other metadata to be displayed in the echo
;; area.
(use-package! eldoc
  :init

  (set-leader-keys! "e h" #'eldoc-doc-buffer)

  :hook (eval-expression-minibuffer-setup-hook . eldoc-mode)
  :blackout t)

;; Package `breadcrumb' provide `project' and `imenu'-based breadcrumb paths
;; displayed either on header line or mode line.
(use-package! breadcrumb
  :demand t
  :config

  (breadcrumb-mode +1))

;;;; Autocompletion

;; Enable indentation and completion using the TAB key. `completion-at-point' is
;; bound to C-M-i, which is M-TAB in a terminal without kitty protocol.
(setq tab-always-indent 'complete)

;; Package `cape' provides Completion At Point Extensions which can be used in
;; combination with Corfu, Company or the default completion UI. The completion
;; backends used by completion-at-point are so called
;; completion-at-point-functions (Capfs).
(use-package! cape
  :init

  ;; The order of the functions matters, the first function returning a result
  ;; wins.
  (push #'cape-dabbrev completion-at-point-functions)
  (push #'cape-file completion-at-point-functions))

;; Package `corfu' enhances in-buffer completion with a small completion popup.
;; The current candidates are shown in a popup below or above the point. The
;; candidates can be selected by moving up and down. Corfu is the minimalistic
;; in-buffer completion counterpart of the Vertico minibuffer UI. Corfu is a
;; small package, which relies on the Emacs completion facilities and
;; concentrates on providing a polished completion UI. In-buffer completion UIs
;; in Emacs can hook into `'completion-in-region', which implements the
;; interaction with the user. Completions at point are either provided by
;; commands like `dabbrev-completion' or by pluggable backends
;; (`completion-at-point-functions', Capfs) and are then passed to
;; `completion-in-region'. Many programming, text and shell major modes
;; implement a Capf. Corfu does not include its own completion backends. The
;; Emacs built-in Capfs and the Capfs provided by third-party programming
;; language packages are often sufficient. Additional Capfs and completion
;; utilities are provided by the Cape package.
(use-package! corfu
  :defer 0.5
  :straight (:files (:defaults "extensions/*"))
  :init

  (set-leader-keys!
    "t a" #'corfu-mode
    "t A" #'global-corfu-mode)

  :bind ( :map corfu-map
          ("TAB"   . #'corfu-next)
          ("<tab>"   . #'corfu-next)
          ("<backtab>" . #'corfu-previous))

  :config

  (defun corfu-move-to-minibuffer ()
    "Transfer the Corfu completion session to the minibuffer."
    (interactive)
    (pcase completion-in-region--data
      (`(,beg ,end ,table ,pred ,extras)
       (let ((completion-extra-properties extras)
             completion-cycle-threshold completion-cycling)
         (consult-completion-in-region beg end table pred)))))
  (keymap-set corfu-map "M-m" #'corfu-move-to-minibuffer)
  (push #'corfu-move-to-minibuffer corfu-continue-commands)

  (defun my--corfu-sort (candidates)
    "Sort candidates after completion backend pre-sorts them.
Most of the completion backends will pre-sort candidates but this
defeats the purpose of `corfu-prescient'."
    (let ((candidates
           (let ((display-sort-func (corfu--metadata-get
                                     'display-sort-function)))
             (if display-sort-func
                 (funcall display-sort-func candidates)
               candidates))))
      (if corfu-sort-function
          (funcall corfu-sort-function candidates)
        candidates)))

  ;; Enable cycling for `corfu-next' and `corfu-previous'.
  (setopt corfu-cycle t)

  ;; Always select the prompt, rather than the valid candidate. This means that
  ;; immediate `corfu-insert' will not change the buffer.
  (setopt corfu-preselect 'prompt)

  ;; Sort candidates after completion backend pre-sorts them.
  (setopt corfu-sort-override-function #'my--corfu-sort)

  (global-corfu-mode +1)

  ;; Feature `corfu-echo' shows candidate documentation in echo area.
  (use-feature! corfu-echo
    :demand t
    :config

    ;; Show documentation string immediately.
    (setopt corfu-echo-delay 0)

    (corfu-echo-mode +1))

  ;; Feature `corfu-indexed' prefixes candidates with indices if enabled via
  ;; `corfu-indexed-mode'. It allows you to select candidates with prefix
  ;; arguments. This is designed to be a faster alternative to selecting a
  ;; candidate with `corfu-next' and `corfu-previous'.
  (use-feature! corfu-indexed
    :demand t
    :config

    ;; Start indexing from 1.
    (setopt corfu-indexed-start 1)

    (corfu-indexed-mode +1))

  ;; Feature `corfu-popupinfo' displays an information popup for completion
  ;; candidate when using Corfu. The popup displays either the candidate
  ;; documentation or the candidate location.
  (use-feature! corfu-popupinfo
    :demand t
    :config

    (corfu-popupinfo-mode +1))

  ;; Feature `corfu-quick' prefixes candidates with quick keys. Typing these
  ;; quick keys allows you to select the candidate in front of them. This is
  ;; designed to be a faster alternative to selecting a candidate with
  ;; `corfu-next' and `corfu-previous'.
  (use-feature! corfu-quick
    :demand t
    :bind ( :map corfu-map
            ("C-q" . #'corfu-quick-complete)
            ("M-q" . #'corfu-quick-insert))))

;; Package `corfu-terminal' replaces Corfu's child frames (which are unusuable
;; on terminal) with popup/popon which works everywhere.
(use-package! corfu-terminal
  :straight (:host codeberg :repo "akib/emacs-corfu-terminal")
  :demand t
  :after corfu
  :config

  (without-display-graphic!
    (corfu-terminal-mode +1)))

;; Package `corfu-prescient' provides an interface for using Prescient to
;; sort and filter candidates in Corfu menus.
(use-package! corfu-prescient
  :demand t
  :after corfu
  :config

  ;; Let `orderless' filter candidates.
  (setopt corfu-prescient-enable-filtering nil)

  ;; Use `prescient' for Corfu menus.
  (corfu-prescient-mode +1))

;; Package `nerd-icons-corfu' adds icons to completions in Corfu. It uses
;; `nerd-icons` under the hood and, as such, works on both GUI and terminal
(use-package! nerd-icons-corfu
  :demand t
  :after corfu
  :config

  (push #'nerd-icons-corfu-formatter corfu-margin-formatters))

;;;; Syntax checking and code linting

;; Package `flymake' is a minor Emacs mode performing on-the-fly syntax checks.
;; Flymake collects diagnostic information for multiple sources, called
;; backends, and visually annotates the relevant portions in the buffer.
(use-package! flymake
  :demand t
  :bind ( :map flymake-project-diagnostics-mode-map
          ("RET" . #'flymake-goto-diagnostic)
          ("SPC" . #'flymake-show-diagnostic))
  :config

  (defvar-local flymake-old-next-error-function nil
    "Remember the old `next-error-function'.")

  (defhook! my--flymake-setup ()
    flymake-mode-hook
    "Support error navigation with `next-error'."
    (cond
     (flymake-mode
      (setq flymake-old-next-error-function next-error-function)
      (setq next-error-function #'flymake-goto-next-error))
     (t
      (setq next-error-function flymake-old-next-error-function)
      (setq flymake-old-next-error-function nil))))

  (defvar-keymap flymake-repeat-map
    :doc "Support Flymake based navigation with repeats."
    :repeat t
    "n" #'flymake-goto-next-error
    "p" #'flymake-goto-prev-error)

  ;; Shorten Flymake lighter.
  (setopt flymake-mode-line-lighter "")

  (set-leader-keys!
    "e ?" #'flymake-running-backends
    "e b" #'flymake-start
    "e l" #'flymake-show-buffer-diagnostics
    "e L" #'flymake-show-project-diagnostics
    "e n" #'flymake-goto-next-error
    "e p" #'flymake-goto-prev-error
    "e s" #'flymake-switch-to-log-buffer
    "e v" #'flymake-reporting-backends
    "t s" #'flymake-mode)

  ;; Increase the idle time after Flymake will start a syntax check as 0.5s is
  ;; a bit too naggy.
  (setq flymake-no-changes-timeout 1.0))

;; Feature `consult-flymake' shows Flymake errors, warnings, notifications
;; within consult buffer with live preview.
(use-feature! consult-flymake
  :init

  (set-leader-keys! "e e" #'consult-flymake)

  :bind (("M-g e"   . #'consult-flymake)
         ("M-g M-e" . #'consult-flymake)))

;; Package `flymake-collection' provides a comprehensive list of diagnostic
;; functions for use with Flymake, give users the tools to easily define new
;; syntax checkers and help selectively enable or disable diagnostic functions
;; based on major modes.
(use-package! flymake-collection)

;; Package `flymake-popon' shows Flymake diagnostics on cursor hover. This works
;; on both graphical and non-graphical displays.
(use-package! flymake-popon
  :hook (flymake-mode . flymake-popon-mode)
  :config

  ;; Increase the idle timeout from the default of 0.2 seconds.
  (setq flymake-popon-delay 1.5))

;;;; Online documentation

;; Package `devdocs' is a documentation viewer for Emacs similar to the built-in
;; Info browser, but geared towards documentation distributed by the DevDocs
;; website. Currently, this covers over 500 versions of 188 different software
;; components.
(use-package! devdocs
  :init

  (set-prefixes! "d" "devdocs")
  (set-leader-keys!
    "d d" #'devdocs-lookup
    "d i" #'devdocs-install
    "d u" #'devdocs-delete)

  :config

  ;; Do not litter `user-emacs-directory' with devdocs data.
  (setopt devdocs-data-dir (expand-file-name "devdocs" my-cache-dir)))

;;;; Diff/Merge handling

;; Feature `ediff' is a comprehensive visual interface to diff & patch.
(use-feature! ediff
  :init

  (set-prefixes!
    "D"     "diff"
    "D b"   "buffers"
    "D d"   "directories"
    "D f"   "files"
    "D m"   "merge"
    "D m b" "buffers"
    "D m d" "directories"
    "D m f" "files"
    "D m r" "revisions"
    "D r"   "regions"
    "D w"   "windows")

  (set-leader-keys!
    "D b 3"   #'ediff-buffers3
    "D b b"   #'ediff-buffers
    "D b B"   #'ediff-backup
    "D b p"   #'ediff-patch-buffer
    "D d 3"   #'ediff-directories3
    "D d d"   #'ediff-directories
    "D d r"   #'ediff-directory-revisions
    "D f 3"   #'ediff-files3
    "D f f"   #'ediff-files
    "D f p"   #'ediff-patch-file
    "D f v"   #'ediff-revision
    "D m b 3" #'ediff-merge-buffers-with-ancestor
    "D m b b" #'ediff-merge-buffers
    "D m d 3" #'ediff-merge-directories-with-ancestor
    "D m d d" #'ediff-merge-directories
    "D m f 3" #'ediff-merge-files-with-ancestor
    "D m f f" #'ediff-merge-files
    "D m r 3" #'ediff-merge-revisions-with-ancestor
    "D m r r" #'ediff-merge-revisions
    "D r l"   #'ediff-regions-linewise
    "D r w"   #'ediff-regions-wordwise
    "D w l"   #'ediff-windows-linewise
    "D w w"   #'ediff-windows-wordwise
    "D s"     #'ediff-show-registry
    "D h"     #'ediff-documentation)

  :config

  ;; Set split between buffer-A and buffer-B to be horizontally from default
  ;; vertical.
  (setq ediff-split-window-function 'split-window-horizontally)

  ;; Set control panel in the same frame as ediff buffers.
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)

  ;; Inhibit `golden-ratio' functionality within `ediff' session.
  (with-eval-after-load 'golden-ratio
    (defun ediff-comparison-buffer-p ()
      "Check whether this buffer belongs to `ediff' session."
      ediff-this-buffer-ediff-sessions)

    (push #'ediff-comparison-buffer-p golden-ratio-inhibit-functions)))

;;; Language support
;;;; Tree-sitter

;; Feature `treesit' provides tree-sitter integration for Emacs. It contains
;; convenient functions that are more idiomatic and flexible than the exposed C
;; API of tree-sitter. It also contains frameworks for integrating tree-sitter
;; with font-lock, indentation, activating and deactivating tree-sitter,
;; debugging tree-sitter, etc.
(use-feature! treesit
  :init

  ;; Decoration level to be used by tree-sitter fontifications. Level 1 usually
  ;; contains only comments and definitions. Level 2 usually adds keywords,
  ;; strings, data types, etc. Level 3 usually represents full-blown
  ;; fontifications, including assignments, constants, numbers and literals,
  ;; etc. Level 4 adds everything else that can be fontified: delimiters,
  ;; operators, brackets, punctuation, all functions, properties, variables,
  ;; etc.
  (setq treesit-font-lock-level 4))

;; Package `treesit-auto' automatically install and use tree-sitter major modes
;; in Emacs 29+.
(use-package! treesit-auto
  :commands treesit-auto-install-all
  :config

  ;; Install grammar only from the following list.
  (setq treesit-auto-langs
        '(bash c cpp cmake dockerfile json python rust toml)))

;;;; Bash

;; Feature `bash-ts-mode' provides major mode for editing Bash shell scripts,
;; powered by tree-sitter.
(use-feature! bash-ts-mode
  :mode ("\\.sh\\'"))

;;;; C

;; Feature `c-ts-mode' provides major mode for editing C, powered by
;; tree-sitter.
(use-feature! c-ts-mode
  :init

  (set-prefixes-for-major-mode! 'c-ts-mode "s" "session")
  (set-leader-keys-for-major-mode! 'c-ts-mode "s s" #'eglot)

  ;; Launch tree-sitter version of `c-mode' instead.
  (push '(c-mode . c-ts-mode) major-mode-remap-alist))

;;;; C++

;; Feature `c++-ts-mode' provides major mode for editing C++, powered by
;; tree-sitter.
(use-feature! c++-ts-mode
  :init

  (defhook! my--c++-ts-mode-setup ()
    c++-ts-mode-hook
    "Set custom settings for `c++-ts-mode'."
    ;; Select C++ documents when inside `c++-ts-mode' buffers.
    (setq-local devdocs-current-docs '("cpp")))

  (defun my--c-ts-mode-indent-style ()
    "Override the built-in BSD indentation style with some additional rules."
    `(
      ;; Align function arguments with the offset.
      ((match nil "argument_list") parent-bol c-ts-mode-indent-offset)
      ;; Same for parameters.
      ((match nil "parameter_list") parent-bol c-ts-mode-indent-offset)
      ;; Do not indent inside namespaces.
      ((n-p-gp nil nil "namespace_definition") grand-parent 0)
      ;; Append to BSD style
      ,@(alist-get 'bsd (c-ts-mode--indent-styles 'cpp))))
  (setopt c-ts-mode-indent-style #'my--c-ts-mode-indent-style)

  (set-prefixes-for-major-mode! 'c++-ts-mode "s" "session")
  (set-leader-keys-for-major-mode! 'c++-ts-mode "s s" #'eglot)

  ;; Launch tree-sitter version of `c++-mode' instead.
  (push '(c++-mode . c++-ts-mode) major-mode-remap-alist)
  (push '(c-or-c++-mode . c-or-c++-ts-mode) major-mode-remap-alist))

;;;; CMake

;; Feature `cmake-ts-mode' provides major mode for editing CMake files, powered
;; by tree-sitter.
(use-feature! cmake-ts-mode
  :mode ("\\(?:CMakeLists\\.txt\\|\\.cmake\\)\\'"))

;;;; Dockerfile

;; Feature `dockerfile-ts-mode' provides major mode for Dockerfile, powered by
;; tree-sitter.
(use-feature! dockerfile-ts-mode
  :mode ("\\(?:Dockerfile\\(?:\\..*\\)?\\|\\.[Dd]ockerfile\\)\\'"))

;;;; Fish

;; Package `fish-mode' provides a major mode for Fish shell scripts.
(use-package! fish-mode)

;;;; Markdown

;; Package `markdown-mode' provides a major mode for Markdown-formatted text.
(use-package! markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)

  :config

  ;; Fontify code in code blocks using the native major mode. This only works
  ;; for fenced code blocks where the language is specified where we can
  ;; automatically determine the appropriate mode to use.
  (setq markdown-fontify-code-blocks-natively t)

  ;; Use underscores when inserting italic text instead of asterisks.
  (setq markdown-italic-underscore t))

;; Package `markdown-toc' is a simple TOC generator for Markdown file.
(use-package! markdown-toc
  :hook ((markdown-mode-hook gfm-mode-hook) . markdown-toc-mode)

  :blackout t)

;; Package `grip-mode' instantly previews GitHub-flavored Markdown/Org using
;; grip.
(use-package! grip-mode
  :bind ( :map markdown-mode-command-map
          ("g" . #'grip-mode)))

;;;; Meson

;; Package `meson-mode' is a major mode for Meson build system files.  Syntax
;; highlighting works reliably.  Indentation works too, but there are probably
;; cases, where it breaks.  Simple completion is supported via
;; `completion-at-point'.
(use-package! meson-mode)

;;;; PlantUML

;; Package `plantuml-mode' is a major mode for PlantUML which is an open-source
;; tool in java that allows to quickly write things like sequence diagram, use
;; case diagram, class diagram, activity diagram, component diagram, state
;; diagram and object diagram.
(use-package! plantuml-mode
  :init

  (defun plantuml-completion-at-point ()
    "Get PlantUML keyword completion."
    (let ((bounds (bounds-of-thing-at-point 'symbol))
          (keywords plantuml-kwdList))
      (when (and bounds keywords)
        (list (car bounds) (cdr bounds) keywords :exclusive 'no))))

  (defhook! my--plantuml-mode-setup ()
    plantuml-mode-hook
    "Set custom settings for `plantuml-mode'."
    ;; Enable custom `completion-at-point'.
    (add-hook #'completion-at-point-functions #'plantuml-completion-at-point
              nil 'local)
    (add-hook #'flymake-diagnostic-functions 'flymake-plantuml)
    (flymake-mode +1))

  :config

  ;; Use binary version instead of server, we do not want to send stuff to
  ;; plantuml servers
  (setq plantuml-default-exec-mode 'executable)

  ;; Define Flymake checker for PlantUML.
  (require 'flymake-collection-define)
  (flymake-collection-define-rx
   flymake-plantuml
   "PlantUML checker using plantuml executable."

   :title "plantuml"
   :pre-let ((plantuml-exec (executable-find "plantuml")))
   :pre-check (unless plantuml-exec
                (error "Cannot find plantuml executable"))
   :write-type 'pipe
   :command (list plantuml-exec "-headless" "-syntax")
   :regexps ((error bol "ERROR" "\n" line "\n" (message) eol))))

;;;; Python

;; Feature `python-ts-mode' provides major mode for Python, powered by
;; tree-sitter.
(use-feature! python-ts-mode
  :init

  (defhook! my--python-ts-mode-setup ()
    python-ts-mode-hook
    "Set custom settings for `python-ts-mode'."
    (setq-local fill-column 100
                column-enforce-column fill-column)
    (column-enforce-mode -1)
    (display-fill-column-indicator-mode -1))

  ;; Launch tree-sitter version of `python-mode' instead.
  (push '(python-mode . python-ts-mode) major-mode-remap-alist)

  (set-prefixes-for-major-mode! 'python-ts-mode "s" "session")
  (set-leader-keys-for-major-mode! 'python-ts-mode "s s" #'eglot))

;;;; Rust

;; Feature `rust-ts-mode' provides major mode for editing Rust, powered by
;; tree-sitter.
(use-feature! rust-ts-mode
  :init

  (defhook! my--rust-ts-mode-setup ()
    rust-ts-mode-hook
    "Set custom settings for `rust-ts-mode'."
    ;; Rust uses (by default) column limit of 100.
    (setq-local fill-column 100
                column-enforce-column fill-column)
    ;; Select Rust documents when inside `rust-ts-mode' buffers.
    (setq-local devdocs-current-docs '("rust")))

  (set-prefixes-for-major-mode! 'rust-ts-mode "s" "session")
  (set-leader-keys-for-major-mode! 'rust-ts-mode "s s" #'eglot)

  :mode ("\\.rs\\'")

  :config

  (defvar rust-compilation-error-regexp
    (let ((err "^error[^:]*:[^\n]*\n\s*-->\s")
          (file "\\([^\n]+\\)")
          (start-line "\\([0-9]+\\)")
          (start-col  "\\([0-9]+\\)"))
      (let ((re (concat err file ":" start-line ":" start-col)))
        (cons re '(1 2 3))))
    "Specifications for matching rust errors in compilation buffers.")

  (defvar rust-compilation-warning-regexp
    (let ((warning "^warning:[^\n]*\n\s*-->\s")
          (file "\\([^\n]+\\)")
          (start-line "\\([0-9]+\\)")
          (start-col  "\\([0-9]+\\)"))
      (let ((re (concat warning file ":" start-line ":" start-col)))
        (cons re '(1 2 3 1)))) ;; 1 for warning
    "Specifications for matching rust warnings in compilation buffers.")

  (defvar rust-compilation-info-regexp
    (let ((file "\\([^\n]+\\)")
          (start-line "\\([0-9]+\\)")
          (start-col  "\\([0-9]+\\)"))
      (let ((re (concat "^ *::: " file ":" start-line ":" start-col)))
        (cons re '(1 2 3 0)))) ;; 0 for info type
    "Specifications for matching rust infos in compilation buffers")

  (defvar rust-compilation-panic-regexp
    (let ((panic "thread '[^']+' panicked at '[^']+', ")
          (file "\\([^\n]+\\)")
          (start-line "\\([0-9]+\\)")
          (start-col  "\\([0-9]+\\)"))
      (let ((re (concat panic file ":" start-line ":" start-col)))
        (cons re '(1 2 3))))
    "Specifications for matching thread panics in compilation buffers.")

  (with-eval-after-load 'compile
    (add-to-list 'compilation-error-regexp-alist-alist
                 (cons 'rust-error rust-compilation-error-regexp))
    (add-to-list 'compilation-error-regexp-alist-alist
                 (cons 'rust-warning rust-compilation-warning-regexp))
    (add-to-list 'compilation-error-regexp-alist-alist
                 (cons 'rust-info rust-compilation-info-regexp))
    (add-to-list 'compilation-error-regexp-alist-alist
                 (cons 'rust-panic rust-compilation-panic-regexp))

    (add-to-list 'compilation-error-regexp-alist 'rust-error)
    (add-to-list 'compilation-error-regexp-alist 'rust-warning)
    (add-to-list 'compilation-error-regexp-alist 'rust-info)
    (add-to-list 'compilation-error-regexp-alist 'rust-panic))

  (with-eval-after-load 'eglot
    ;; Set additional initialization options for rust-analyzer.
    (add-to-list
     'eglot-server-programs
     '(rust-ts-mode
       . ("rust-analyzer" :initializationOptions
          ( :diagnostics (:experimental (:enable t))
            :completion (:postfix (:enable :json-false))
            :inlayHints ( :closureReturnTypeHints (:enable "always")
                          :lifetimeElisionHints (:enable "skip_trivial"))
            :lens (:enable :json-false)
            :check (:command "clippy")))))

    (with-eval-after-load 'eglot-x
      (set-prefixes-for-minor-mode! 'eglot--managed-mode
        "b" "build"
        "o" "open")

      (set-leader-keys-for-minor-mode! 'eglot--managed-mode
        ;; Code actions
        "a m" #'eglot-x-expand-macro

        ;; Build
        "b m" #'eglot-x-rebuild-proc-macros

        ;; Goto
        "g R" #'eglot-x-find-refs
        "g S" #'eglot-x-find-workspace-symbol

        ;; Help
        "h m" #'eglot-x-view-recursive-memory-layout
        "h t" #'eglot-x-ask-related-tests

        ;; Open
        "o d" #'eglot-x-open-external-documentation

        ;; Refactor
        "r s" #'eglot-x-structural-search-replace

        ;; Session
        "s m" #'eglot-x-memory-usage
        "s ?" #'eglot-x-analyzer-status))))

;;;; Shell

;; Feature `sh-script' provides a major mode for various Shell scripts.
(use-feature! sh-script
  :init

  (defhook! my--sh-mode-setup ()
    sh-mode-hook
    "Set custom settings for `sh-mode'."
    (setq sh-basic-offset 2)
    ;; Enable syntax checking and spellchecking in comments.
    (flymake-mode +1)
    (flyspell-prog-mode))

  (dolist (mode '(bash-ts-mode sh-mode))
    (set-prefixes-for-major-mode! mode "i" "insert")

    (set-leader-keys-for-major-mode! mode
      "\\"  #'sh-backslash-region
      "i c" #'sh-case
      "i e" #'sh-indexed-loop
      "i f" #'sh-function
      "i g" #'sh-while-getopts
      "i i" #'sh-if
      "i o" #'sh-for
      "i r" #'sh-repeat
      "i s" #'sh-select
      "i u" #'sh-until
      "i w" #'sh-while
      "s"   #'sh-set-shell))

  :config

  ;; Silence messages when opening Shell scripts.
  (dolist (func '(sh-set-shell sh-make-vars-local))
    (advice-add func :around #'advice-silence-messages!)))

;; Package `'shfmt' provides commands and a minor mode for easily reformatting
;; shell scripts using the external "shfmt" program.
(use-package! shfmt
  :init

  (dolist (mode '(bash-ts-mode sh-mode))
    (set-prefixes-for-major-mode! mode "=" "format")

    (set-leader-keys-for-major-mode! mode
      "= =" #'shfmt-buffer
      "= r" #'shfmt-region))

  :config

  ;; Set indentation to 2 spaces, allow binary ops to start a line and follow
  ;; redirect operators by a space.
  (setq shfmt-arguments '("-i" "2" "-bn" "-sr" "-ci")))

;;; Configuration file formats

;; Package `git-modes' provides a major mode for .gitattributes, .gitconfig and
;; .gitignore files.
(use-package! git-modes)

;; Feature `json-ts-mode' provides major mode for editing JSON, powered by
;; tree-sitter.
(use-feature! json-ts-mode
  :mode ("\\.json\\'"))

;; Package `pkgbuild-mode' provides a major mode for PKGBUILD files used by Arch
;; Linux and derivatives.
(use-package! pkgbuild-mode)

;; Package `ssh-config-mode' provides major modes for files in ~/.ssh.
(use-package! ssh-config-mode
  :blackout "SSH-Config")

;; Feature `toml-ts-mode' provides major mode for editing TOML, powered by
;; tree-sitter
(use-feature! toml-ts-mode
  :mode ("\\.toml\\'"))

;; Package `yaml-mode' provides a major mode for YAML.
(use-package! yaml-mode)

;;; Language servers

;; Package `consult-eglot' provides an alternative of the built-in
;; `xref-appropos' which provides as you type completion.
(use-package! consult-eglot
  :demand t
  :after (consult eglot xref)
  :bind ( :map eglot-mode-map
          ([remap xref-find-apropos] . #'consult-eglot-symbols))

  :config

  (set-leader-keys-for-minor-mode! 'eglot--managed-mode
    "g s" #'consult-eglot-symbols)

  (consult-customize
   ;; Disable the automatic preview where the preview may be expensive due to
   ;; file loading.
   consult-eglot-symbols
   :preview-key "M-."))

;; Package `eglot' is the Emacs client for the Language Server Protocol (LSP).
;; The name “Eglot” is an acronym that stands for "Emacs Polyglot". Eglot
;; provides infrastructure and a set of commands for enriching the source code
;; editing capabilities of Emacs via LSP. LSP is a standardized communications
;; protocol between source code editors (such as Emacs) and language
;; servers—programs external to Emacs which analyze the source code on behalf of
;; Emacs. The protocol allows Emacs to receive various source code services from
;; the server, such as description and location of function calls, types of
;; variables, class definitions, syntactic errors, etc. This way, Emacs doesn’t
;; need to implement the language-specific parsing and analysis capabilities in
;; its own code, but is still capable of providing sophisticated editing
;; features that rely on such capabilities, such as automatic code completion,
;; go-to definition of function/class, documentation of symbol at-point,
;; refactoring, on-the-fly diagnostics, and more. Eglot itself is completely
;; language-agnostic, but it can support any programming language for which
;; there is a language server and an Emacs major mode.
(use-package! eglot
  :init

  ;; Increase the amount of data which Emacs reads from the process. The Emacs
  ;; default is too low (4k) considering that the some of the language server
  ;; responses are in 800k - 3M range.
  (setq read-process-output-max (* 1024 1024))

  ;; Inhibit logging a JSONRPC-related events.
  (fset #'jsonrpc--log-event #'ignore)

  :config

  (set-prefixes-for-minor-mode! 'eglot--managed-mode
    "=" "format"
    "a" "code actions"
    "g" "goto"
    "h" "help"
    "r" "refactor"
    "s" "session"
    "t" "toggle")

  (set-leader-keys-for-minor-mode! 'eglot--managed-mode
    ;; Format
    "= =" #'eglot-format-buffer
    "= r" #'eglot-format

    ;; Code actions
    "a a" #'eglot-code-actions
    "a e" #'eglot-code-action-extract
    "a f" #'eglot-code-action-quickfix
    "a i" #'eglot-code-action-organize-imports
    "a l" #'eglot-code-action-inline
    "a w" #'eglot-code-action-rewrite

    ;; Goto
    "g d" #'eglot-find-declaration
    "g e" #'flymake-show-project-diagnostics
    "g g" #'xref-find-definitions
    "g i" #'eglot-find-implementation
    "g r" #'xref-find-references
    "g t" #'eglot-find-typeDefinition

    ;; Help
    "h h" #'eldoc-doc-buffer

    ;; Refactor
    "r r" #'eglot-rename

    ;; Session
    "s d" #'eglot-stderr-buffer
    "s e" #'eglot-events-buffer
    "s f" #'eglot-forget-pending-continuations
    "s l" #'eglot-list-connections
    "s q" #'eglot-shutdown
    "s Q" #'eglot-shutdown-all
    "s r" #'eglot-reconnect

    ;; Toggle
    "t i" #'eglot-inlay-hints-mode)

  ;; Filter list of possible completions with Orderless.
  (setopt completion-category-overrides '((eglot (styles orderless))
                                          (eglot-capf (styles orderless))))

  ;; Increase the idle time after Eglot will notify servers of any changes.
  (setopt eglot-send-changes-idle-time 1.0)

  ;; Activate Eglot in referenced non-project files.
  (setopt eglot-extend-to-xref t)

  ;; Disable Eglot events buffer, increase it only when debugging is needed.
  (setopt eglot-events-buffer-config '(:size 0)))

;; Package `eglot-booster' enables Eglot to use emacs-lsp-booster which is a
;; rust-based wrapper program which substantially speeds up Emacs interactions
;; with LSP servers
(use-package! eglot-booster
  :straight (:host github :repo "jdtsmith/eglot-booster")
  :demand t
  :after eglot
  :config

  (eglot-booster-mode +1))

;; Package `eglot-semantic-tokens' provides support for semantic highlighting.
(use-package! eglot-semantic-tokens
  :straight (:host codeberg :repo "eownerdead/eglot-semantic-tokens")
  :demand t
  :after eglot
  :hook (eglot-managed-mode-hook . eglot--semantic-tokens-mode)
  :config

  ;; Enable semantic tokens.
  (setopt eglot-enable-semantic-tokens t)

  (set-leader-keys-for-minor-mode! 'eglot--managed-mode
    "t s" (cons "eglot-semantic-tokens-mode" #'eglot--semantic-tokens-mode)))

;; Package `eglot-x' adds support for some of Language Server Protocol
;; extensions.
(use-package! eglot-x
  :straight (:host github :repo "nemethf/eglot-x")
  :demand t
  :after eglot
  :config

  ;; Set up `eglot-x' to extend Eglot's feature-set. Call it when there are no
  ;; active LSP servers.
  (eglot-x-setup))

;;; Introspection
;;;; Help

;; Allows to print a stacktrace in case of an error.
(set-leader-keys! "t e" #'toggle-debug-on-error)

;; Feature `help' powers the *Help* buffer and related functionality.
(use-feature! help
  :config

  (defadvice! my--help-inhibit-hints (&rest _)
    :override #'help-window-display-message
    "Inhibit the \"Type q in help window to delete it\" hints.
Normally these are printed in the echo area whenever you open a
help buffer.")

  (defadvice! my--help-disable-revert-prompt
      (help-mode-revert-buffer ignore-auto _noconfirm)
    :around #'help-mode-revert-buffer
    "Don't ask for confirmation before reverting help buffers.
\(Reverting is done by pressing \\<help-mode-map>\\[revert-buffer].)"
    (funcall help-mode-revert-buffer ignore-auto 'noconfirm))

  (defhook! my--xref-help-setup ()
    help-mode-hook
    "Make xref look up Elisp symbols in help buffers.
Otherwise, it will try to find a TAGS file using etags, which is
unhelpful."
    (add-hook #'xref-backend-functions #'elisp--xref-backend nil 'local))

  (set-leader-keys!
    "h b" #'describe-bindings
    "h c" #'describe-key-briefly
    "h F" #'describe-face
    "h m" #'describe-mode
    "h M" #'describe-keymap
    "h n" #'view-emacs-news
    "h t" #'describe-theme)

  ;; Always select help window for viewing.
  (setq help-window-select 't))

;; Package `helpful' provides a complete replacement for the built-in
;; Emacs help facility which provides much more contextual information
;; in a better format.
(use-package! helpful
  :init

  (set-leader-keys!
    "h f" #'helpful-callable
    "h I" #'helpful-at-point
    "h k" #'helpful-key
    "h s" #'helpful-symbol
    "h v" #'helpful-variable
    "h x" #'helpful-command)

  :bind (([remap describe-function] . #'helpful-callable)
         ([remap describe-variable] . #'helpful-variable)
         ([remap describe-symbol]   . #'helpful-symbol)
         ([remap describe-key]      . #'helpful-key)
         ([remap describe-command]  . #'helpful-command)))

;;;; Emacs Lisp development

;; Feature `elisp-mode' provides the major mode for Emacs Lisp.
(use-feature! elisp-mode
  :config

  (defadvice! my--fill-elisp-docstrings-correctly (&rest _)
    :before-until #'fill-context-prefix
    "Prevent `auto-fill-mode' from adding indentation to Elisp docstrings."
    (when (and (derived-mode-p #'emacs-lisp-mode)
               (eq (get-text-property (point) 'face) 'font-lock-doc-face))
      "")))

;; Package `macrostep' provides a facility for interactively expanding Elisp
;; macros.
(use-package! macrostep
  :init

  (set-leader-keys-for-major-mode! 'emacs-lisp-mode
    "e" #'macrostep-expand))

;;;;; Emacs Lisp byte-compilation

;; Feature `bytecomp' handles byte-compilation of Emacs Lisp code.
(use-feature! bytecomp
  :config

  (defun byte-compile-init ()
    "Byte-compile init.el if there are any changes."
    (interactive)
    (if (file-exists-p (concat user-init-file "c"))
        (byte-recompile-file user-init-file)
      (byte-compile-file user-init-file)))

  ;; Eliminate two warnings that are essentially useless most of the time.
  (setq byte-compile-warnings '(not make-local noruntime)))

;;;;; Emacs Lisp linting

;; Feature `checkdoc' provides some tools for validating Elisp docstrings
;; against common conventions.
(use-feature! checkdoc
  :init

  ;; Not sure why this isn't included by default.
  (put 'checkdoc-package-keywords-flag 'safe-local-variable #'booleanp))

;; Package `elisp-lint' provides a linting framework for Elisp code.
(use-package! elisp-lint)

;;; Applications
;;;; Organisation

;; Package `org' provides too many features to describe in any reasonable amount
;; of space. It is built fundamentally on `outline-mode', and adds TODO states,
;; deadlines, properties, priorities, etc. to headings. Then it provides tools
;; for interacting with this data, including an agenda view, a time clocker,
;; etc.
(use-package! org
  ;; We use straight mirror as the official repo does not allow to fetch a
  ;; shallow repo with a frozen git hash.
  :straight (:host github :repo "emacs-straight/org-mode" :local-repo "org")
  :init

  (defhook! my--org-mode-setup ()
    org-mode-hook
    "Set custom settings for `org-mode'."
    (turn-on-auto-fill))

  (set-prefixes-for-major-mode! 'org-mode "t" "toggle")

  (set-leader-keys-for-major-mode! 'org-mode
    "l"   #'org-store-link
    "C-l" #'org-insert-link

    ;; Toggle
    "t i" #'org-toggle-inline-images
    "t l" #'org-toggle-link-display)
  (set-leader-keys! "o l" #'org-store-link)

  :bind ( :map org-mode-map
          ("M-p" . #'org-backward-element)
          ("M-n" . #'org-forward-element))

  :config

  ;; Default directory for Org to look in in certain rare situation.
  (setq org-directory (expand-file-name "org" my-data-dir))

  ;; Show headlines but not content by default.
  (setq org-startup-folded 'content)

  ;; Hide the first N-1 stars in a headline.
  (setq org-hide-leading-stars t)

  ;; Do not adapt indentation to outline node level.
  (setq org-adapt-indentation nil)

  ;; Use cornered arrow instead of three dots to increase its visibility.
  (setq org-ellipsis "⤵")

  ;; Require braces in order to trigger interpretations as sub/superscript. This
  ;; can be helpful in documents that need "_" frequently in plain text.
  (setq org-use-sub-superscripts '{})

  ;; Make `mwim' behaving like it should in Org.
  (setq org-special-ctrl-a/e t)

  ;; Add additional backends to export engine.
  (dolist (backend '(beamer md confluence))
    (push backend org-export-backends)))

;; Package `org-contrib' contains add-ons to Org-mode. These contributions are
;; not part of GNU Emacs or of the official Org-mode package.
(use-package! org-contrib)

;; Feature `ob' allows to work with code blocks in Org buffers.
(use-feature! ob
  :config

  ;; Do not require confirmation before interactively evaluating code blocks in
  ;; Org buffers.
  (setq org-confirm-babel-evaluate nil)

  ;; Support Emacs Lisp, PlantUML and Shell languages to Babel.
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (plantuml . t)
     (shell . t))))

;; Feature `ob-plantuml' provides Org-Babel support for evaluating plantuml
;; scripts.
(use-feature! ob-plantuml
  :config

  (setq org-plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar"))

;; Feature `org-capture' allows to take notes fast in Org.
(use-feature! org-capture
  :init

  (set-leader-keys-for-major-mode! 'org-mode "c" #'org-capture)
  (set-leader-keys! "o c" #'org-capture)

  :config

  ;; Default target for storing notes, used as a fall back file for templates
  ;; that do not specify a target file.
  (setq org-default-notes-file (expand-file-name "notes.org" org-directory)))

;; Feature `org-crypt' brings simple integration of GnuPG into Org.
(use-feature! org-crypt
  :demand t
  :after org
  :config

  ;; Prevent already encrypted text from being encrypted again.
  (setq org-tags-exclude-from-inheritance '("crypt"))

  ;; Add a hook to automatically encrypt entries before a file is saved to disk.
  (org-crypt-use-before-save-magic))

;; Feature `org-src' contains the code dealing with source code examples in Org
;; mode.
(use-feature! org-src
  :demand t
  :after org
  :config

  ;; Show edit buffer in the current window, keeping all windows.
  (setq org-src-window-setup 'current-window)

  ;; Preserve leading whitespace characters in source code blocks on export, and
  ;; when switching between the Org buffer and the language mode edit buffer.
  (setq org-src-preserve-indentation t))

;; Feature `org-tempo' reimplements completions of structure template before
;; point. For example, strings like "<e" at the beginning of the line will be
;; expanded to an example block.
(use-feature! org-tempo
  :demand t
  :after org)

;; Feature `consult-org' provides a `completing-read' interface for Org mode
;; navigation.
(use-feature! consult-org
  :demand t
  :after org
  :bind ( :map org-mode-map
          ("M-g o"   . #'consult-org-heading)
          ("M-g M-o" . #'consult-org-heading)))

;; Feature `ox' implements a generic export engine for Org, built on its
;; syntactical parser - Org Elements.
(use-feature! ox
  :config

  ;; Push export output to the kill ring if done interactively.
  (setq org-export-copy-to-kill-ring 'if-interactive)

  ;; Require braces in order to trigger interpretations as sub/superscript. This
  ;; can be helpful in documents that need "_" frequently in plain text.
  (setq org-export-with-sub-superscripts '{}))

;; Package `ox-pandoc' is another exporter for Org Mode that translates Org Mode
;; file to various other formats via Pandoc.
(use-package! ox-pandoc
  :demand t
  :after ox)

;; Package `ox-reveal' implements a reveal.js Presentation Back-End for Org
;; Export Engine
(use-package! ox-reveal
  :demand t
  :after ox
  :config

  (push 'reveal org-export-backends))

;; Package `htmlize' converts the buffer text and the associated decorations to
;; HTML.
(use-package! htmlize)

;; Package `org-modern' implements a modern style for your Org buffers using
;; font locking and text properties. The package styles headlines, keywords,
;; tables and source blocks. The styling is configurable, you can enable,
;; disable or modify the style of each syntax element individually.
(use-package! org-modern
  :hook (org-mode-hook . org-modern-mode))

;; Package `org-sticky-header' displays in the header-line the Org heading for
;; the node that's at the top of the window.  This way, if the heading for the
;; text at the top of the window is beyond the top of the window, you don't
;; forget which heading the text belongs to.
(use-package! org-sticky-header
  :hook (org-mode-hook . org-sticky-header-mode)

  :config

  ;; Show the full outline path.
  (setq org-sticky-header-full-path 'full))

;; Package `toc-org' helps you to have an up-to-date table of contents in Org
;; or Markdown files without exporting. Every time you save an Org file, the
;; first headline with a :TOC: tag will be updated with the current table of
;; contents.
(use-package! toc-org
  :hook (org-mode-hook . toc-org-mode))

;;;; Filesystem management

;; Delete files to trash as an extra layer of precaution against accidentally
;; deleting wanted files.
(setq delete-by-moving-to-trash t)

;;;;; Dired

;; Feature `dired' provides a simplistic filesystem manager in Emacs for
;; directory browsing and editing.
(use-feature! dired
  :commands (dired-up-directory
             dired-get-file-for-visit
             dired-create-empty-file
             dired-create-directory)
  :init

  (defvar dired--limit-hist '()
    "Minibuffer history for `dired-limit-regexp'.")

  (defun dired-limit-regexp (regexp omit)
    "Limit Dired to keep files matching REGEXP.

With optional OMIT argument as a prefix (\\[universal-argument]),
exclude files matching REGEXP.

Restore the buffer with \\<dired-mode-map>`\\[revert-buffer]'."
    (interactive
     (list
      (read-regexp
       (concat "Files "
               (when current-prefix-arg
                 (propertize "NOT " 'face 'warning))
               "matching PATTERN: ")
       nil 'prot-dired--limit-hist)
      current-prefix-arg))
    (dired-mark-files-regexp regexp)
    (unless omit (dired-toggle-marks))
    (dired-do-kill-lines)
    (add-to-history 'dired--limit-hist regexp))

  (set-leader-keys!
    "a d" #'dired
    "a D" #'dired-other-window
    "F d" #'dired-other-frame
    "j d" #'dired-jump
    "j D" #'dired-jump-other-window
    "T d" #'dired-other-tab)

  :hook (dired-mode-hook . dired-hide-details-mode)

  :bind ( :map dired-mode-map
          ;; This binding is way nicer than ^.
          ("J"   . #'dired-up-directory)
          ("I"   . #'dired-kill-subdir)
          ;; Bind both creations to be nearby each others
          ("\["  . #'dired-create-empty-file)
          ("\]"  . #'dired-create-directory)
          ("/"   . #'dired-limit-regexp)
          ("M-n" . #'dired-next-subdir)
          ("M-p" . #'dired-prev-subdir))

  :config

  ;; Switches passed to ls for `dired':
  ;;   - show hidden files
  ;;   - natural sort of (version) numbers within text
  ;;   - append indicator (one of */=>@|) to entries
  ;;   - print sizes like 1K 234M 2G etc
  ;;   - group directories before files
  (setopt dired-listing-switches
          "-AlvFh --group-directories-first --time-style=long-iso")

  ;; Just show 'Dired' in mode line.
  (setopt dired-switches-in-mode-line 0)

  ;; Try to guess a default target directory. This means: if there is a `dired'
  ;; buffer displayed in some window, use its current directory, instead of this
  ;; `dired' buffer’s current directory.
  (setopt dired-dwim-target t)

  ;; Skip empty lines when moving in Dired buffers and don't move up/down if the
  ;; current line is the first/last visible line.
  (setopt dired-movement-style 'bounded)

  ;; Instantly revert Dired buffers on re-visiting them, with no message.
  (setopt dired-auto-revert-buffer t)

  ;; Copy directories recursively.
  (setopt dired-recursive-copies 'always)

  ;; Hide free space label at the top
  (setopt dired-free-space nil)

  ;; Compress with Zstandard by default
  (setopt dired-compress-file-default-suffix ".zst"
          dired-compress-directory-default-suffix ".tar.zst")

  ;; Open common video extensions with `shell-command' by default.
  (setopt dired-guess-shell-alist-user
          '(("\\.\\(mp4\\|webm\\|mkv\\)" (open-in-external-app)))))

;; Feature `dired-x' provides extra `dired' functionality.
(use-feature! dired-x
  :demand t
  :after dired
  :config

  :config

  ;; Remap find-file{-other-window} to dired-x-find-file{-other-window}
  (setq dired-x-hands-off-my-keys nil)

  ;; Prevent annoying "Omitted N lines" messages when auto-reverting.
  (setq dired-omit-verbose nil))

;; Feature `wdired' allows to rename files editing their names in `dired'
;; buffers.
(use-feature! wdired
  :after dired
  :bind ( :map dired-mode-map
          ("C-c C-e" . #'wdired-change-to-wdired-mode))

  :config

  ;; Make permission bits editable.
  (setq wdired-allow-to-change-permissions t))

;; Package `dired-copy-paste' enables you to cut, copy and paste files and
;; directories in Emacs Dired.
(use-package! dired-copy-paste
  :straight (:host github :repo "jsilve24/dired-copy-paste")
  :after dired
  :commands (dired-copy-paste-do-cut
             dired-copy-paste-do-copy
             dired-copy-paste-do-paste)
  :bind ( :map dired-mode-map
          ("C-c C-w" . #'dired-copy-paste-do-cut)
          ("C-c C-c" . #'dired-copy-paste-do-copy)
          ("C-c C-y" . #'dired-copy-paste-do-paste)))

;; Package `dired-hist' is a minor mode for Emacs that keeps track of visited
;; dired buffers and lets you go back and forwards across them. This is similar
;; to the facility provided in other Emacs major modes, such as Info, help and
;; EWW.
(use-package! dired-hist
  :after dired
  :commands (dired-hist-go-back
             dired-hist-go-forward)
  :hook (dired-mode-hook . dired-hist-mode)
  :bind ( :map dired-mode-map
          ("l" . #'dired-hist-go-back)
          ("r" . #'dired-hist-go-forward)))

;; Package `dired-subtree' defines function `dired-subtree-insert' which inserts
;; the subdirectory directly below its line in the original listing, and indents
;; the listing of subdirectory to resemble a tree-like structure. The tree
;; display is somewhat more intuitive than the default "flat" subdirectory
;; manipulation provided by `dired-maybe-insert-subdir'.
(use-package! dired-subtree
  :after dired
  :bind ( :map dired-mode-map
          ("TAB" . #'dired-subtree-toggle)))

;; Package `diredfl' provides extra font lock rules for a more colourful
;; `dired'.
(use-package! diredfl
  :hook (dired-mode-hook . diredfl-mode))

;; Package `fd-dired' provides a dired-mode interface for fd's result. Same
;; functionality as `find-dired' and `find-grep-dired', use fd and rg instead.
;; Depends on `find-dired'.
(use-package! fd-dired
  :after dired
  :init

  (set-leader-keys-for-major-mode! 'dired-mode
    "f" #'fd-dired
    "g" #'fd-grep-dired)

  :bind ( :map dired-mode-map
          ("C-c C-f" . #'fd-dired)
          ("C-c /"   . #'fd-grep-dired)))

;; Package `nerd-icons-dired' shows icons for each file in Dired,
(use-package! nerd-icons-dired
  :hook (dired-mode-hook . nerd-icons-dired-mode)
  :blackout t)

;;;; Processes

(set-leader-keys! "a p" #'list-processes)

;; Feature `proced' makes an Emacs buffer containing a listing of the current
;; system processes. You can use the normal Emacs commands to move around in
;; this buffer, and special Proced commands to operate on the processes listed.
(use-feature! proced
  :init
  (set-leader-keys! "a P" #'proced)

  :config

  ;; Auto update a Proced buffer.
  (setq proced-auto-update-flag t)

  ;; Display some process attributes with color.
  (setq proced-enable-color-flag t))

;;;; Version control

;; Package `browse-at-remote' easily opens target page on github/gitlab (or
;; bitbucket) from Emacs by calling `browse-at-remote` function. Support Dired
;; buffers and opens them in tree mode at destination.
(use-package! browse-at-remote
  :init

  (set-leader-keys!
    "g r" #'browse-at-remote
    "g R" #'browse-at-remote-kill))

;; Package `consult-git-log-grep' provides an interactive way to search the git
;; log using `consult'.
(use-package! consult-git-log-grep
  :init

  (set-leader-keys! "g ?" #'consult-git-log-grep)

  :config

  ;; Use `magit' to show the commit (must be called from `magit-status').
  (setq consult-git-log-grep-open-function #'magit-show-commit))

;; Package `consult-ls-git' allows to quickly select a file from a git
;; repository or act on a stash. It provides a consult multi view of files
;; considered by git status, stashes as well as all tracked files. Alternatively
;; you can narrow to a specific section via the shortcut key.
(use-package! consult-ls-git
  :init

  (set-leader-keys! "g f" #'consult-ls-git))

;; Package `git-gutter' is a port of Sublime Text plugin GitGutter.
(use-package! git-gutter
  :defer 5
  :commands (git-gutter:next-hunk
             git-gutter:popup-hunk
             git-gutter:previous-hunk
             git-gutter:revert-hunk
             git-gutter:stage-hunk)
  :init

  (defhydra hydra-git-gutter (:color pink :hint nil)
    "
Goto^^              Actions^^         Other^^
----^^------------- -------^^-------- -----^^-------
[_n_] next hunk     [_s_] stage hunk  [_z_] recenter
[_p_] previous hunk [_r_] revert hunk [_q_] quit
^^                  [_h_] show hunk
"
    ("h" git-gutter:popup-hunk)
    ("n" git-gutter:next-hunk)
    ("p" git-gutter:previous-hunk)
    ("r" git-gutter:revert-hunk)
    ("s" git-gutter:stage-hunk)
    ("z" recenter-top-bottom)
    ("q" nil :quit t)
    ("C-g" nil :exit t))

  (set-leader-keys! "g ." (cons "git-gutter" #'hydra-git-gutter/body))

  (defhook! my--git-gutter-load ()
    find-file-hook
    "Load `git-gutter' when initially finding a file."
    (require 'git-gutter)
    (remove-hook 'find-file-hook #'my--git-gutter-load))

  :bind (("M-g M-n" . #'git-gutter:next-hunk)
         ("M-g M-p" . #'git-gutter:previous-hunk))
  :config

  (defvar-keymap git-gutter-repeat-map
    :doc "Support GitGutter based navigation with repeats."
    :repeat t
    "n" #'git-gutter:next-hunk
    "p" #'git-gutter:previous-hunk)

  (set-face-attribute 'git-gutter:modified nil :foreground "yellow")

  ;; Check git for updates every 2 seconds instead of waiting on buffer save.
  (setq git-gutter:update-interval 2)

  ;; Hide gutter if there are no changes.
  (setq git-gutter:hide-gutter t)

  (global-git-gutter-mode +1)

  (defhook! my--git-gutter-after-autorevert ()
    after-revert-hook
    "Update `git-gutter' after the buffer is autoreverted."
    (when git-gutter-mode
      (git-gutter)))

  :blackout t)

;; Package `git-messenger' provides a function that when called will pop-up the
;; last git commit message for the current line. This uses the git-blame tool
;; internally.
(use-package! git-messenger
  :init

  (set-leader-keys! "g m" (cons "git-messenger" #'git-messenger:popup-message))

  :config

  ;; Pop up commit ID and author name too.
  (setq git-messenger:show-detail t)

  ;; Use `magit-show-commit` instead `pop-to-buffer`.
  (setq git-messenger:use-magit-popup t))

;; Package `git-timemachine' allows to browse historic versions of a file under
;; git control.
(use-package! git-timemachine
  :init

  (defhook! my--git-timemachine-inhibit-revert ()
    before-revert-hook
    "Inhibit buffer reverts when `git-timemachine-mode' is active."
    (when (bound-and-true-p git-timemachine-mode)
      (user-error "Cannot revert the timemachine buffer")))

  (set-prefixes! "g t" "timemachine")

  (set-leader-keys!
    "g t t" #'git-timemachine
    "g t b" #'git-timemachine-switch-branch)

  :bind ( :map git-timemachine-mode-map
          ("C-g" . git-timemachine-quit))

  :config

  ;; Number of chars from the full sha1 hash to use for abbreviation.
  (setq git-timemachine-abbreviation-length 8))

;; Package `magit' provides a full graphical interface for Git within Emacs.
(use-package! magit
  :defer 2
  :init

  ;; Feature `git-commit' assists the user in writing good Git commit messages.
  ;; While Git allows for the message to be provided on the command line, it is
  ;; preferable to tell Git to create the commit without actually passing it a
  ;; message. Git then invokes the `$GIT_EDITOR' (or if that is undefined
  ;; `$EDITOR') asking the user to provide the message by editing the file
  ;; ".git/COMMIT_EDITMSG" (or another file in that directory, e.g.
  ;; ".git/MERGE_MSG" for merge commits).
  (use-feature! git-commit
    :config

    (defhook! my--git-commit-mode-setup ()
      git-commit-mode-hook
      "Set custom settings for `git-commit-mode'."
      (setq-local fill-column 72
                  column-enforce-column fill-column)
      (display-fill-column-indicator-mode +1)
      (column-enforce-mode +1))

    ;; Make overlong summary with the same face as `column-enforce-mode'.
    (set-face-attribute 'git-commit-overlong-summary nil :underline t)

    ;; List of checks performed by `git-commit'.
    (setq git-commit-style-convention-checks '(non-empty-second-line
                                               overlong-summary-line))

    ;; Column beyond which characters in the summary lines are highlighted.
    (setq git-commit-summary-max-length 50)

    ;; Use a local message ring so that every repository gets its own commit
    ;; message ring.
    (setq git-commit-use-local-message-ring t))

  (defadvice! my--magit-list-refs-sorted (fn &optional namespaces format sortby)
    :around #'magit-list-refs
    "Apply prescient sorting when listing refs."
    (let ((res (funcall fn namespaces format sortby)))
      (if (or sortby magit-list-refs-sortby)
          res
        (prescient-sort res))))

  ;; Disable default keybindings.
  (setq magit-define-global-key-bindings nil)

  (set-leader-keys!
    "g b" #'magit-blame
    "g c" #'magit-clone
    "g d" #'magit-diff-buffer-file
    "g D" #'magit-diff
    "g F" #'magit-find-file
    "g g" #'magit-file-dispatch
    "g G" #'magit-dispatch
    "g i" #'magit-init
    "g l" #'magit-log-buffer-file
    "g s" #'magit-status)

  ;; Suppress the message we get about "Turning on magit-auto-revert-mode" when
  ;; loading Magit.
  (setq magit-no-message '("Turning on magit-auto-revert-mode..."))

  :config

  ;; The default location for git-credential-cache is in
  ;; ~/.config/git/credential. However, if ~/.git-credential-cache/ exists, then
  ;; it is used instead. Magit seems to be hardcoded to use the latter, so here
  ;; we override it to have more correct behavior.
  (require 'xdg)
  (setq magit-credential-cache-daemon-socket (expand-file-name
                                              "git/credential/socket"
                                              (xdg-cache-home)))

  ;; Display Magit buffers in the entire frame when displaying a status buffer.
  (setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)

  ;; Don't try to save unsaved buffers when using Magit. We know perfectly well
  ;; that we need to save our buffers if we want Magit to see them.
  (setq magit-save-repository-buffers nil)

  ;; Use absolute dates when showing logs.
  (setq magit-log-margin '(t "%d-%m-%Y %H:%M " magit-log-margin-width t 18)))

;; Package 'magit-delta' integrates Delta (https://github.com/dandavison/delta)
;; with Magit, so that diffs in Magit are displayed with color highlighting
;; provided by Delta.
(use-package! magit-delta
  :after magit
  :init

  (defadvice! my--magit-delta-patch-args (args)
    :filter-return #'magit-delta--make-delta-args
    "Pick proper background and foreground colors based on the
current theme. This will also disable line numbers and decorations."
    (push (if (eq (frame-parameter nil 'background-mode) 'dark)
              "--features=modus-vivendi"
            "--features=modus-operandi") args))

  (defun magit-delta-toggle ()
    "Toggles `magit-delta-mode' and refreshes Magit."
    (interactive)
    (magit-delta-mode
     (if magit-delta-mode -1 +1))
    (magit-refresh))

  (transient-append-suffix
    'magit-diff '(-1 -1 -1)
    '("l" "Toggle magit-delta" magit-delta-toggle))

  (magit-delta-mode +1)

  :blackout t)

;; Package `magit-todos' displays keyword entries from source code comments and
;; Org files in the Magit status buffer. Activating an item jumps to it in its
;; file.
(use-package! magit-todos
  :init

  (set-prefixes! "g T" "todos")

  (set-leader-keys!
    "g T T" #'magit-todos-list
    "g T m" #'magit-todos-mode))

;; Package `transient' is the interface used by Magit to display popups.
(use-package! transient
  :functions transient-bind-q-to-quit
  :config

  ;; Show all possible options in transient windows.
  (setq transient-default-level 7)

  ;; Do not litter `user-emacs-directory' with transient files.
  (setq transient-levels-file (expand-file-name "transient/levels.el"
                                                my-cache-dir)
        transient-values-file (expand-file-name "transient/values.el"
                                                my-cache-dir)
        transient-history-file (expand-file-name "transient/history.el"
                                                 my-cache-dir))

  (with-eval-after-load 'golden-ratio
    (push "*transient*" golden-ratio-exclude-buffer-names))

  ;; Allow using `q' to quit out of popups, in addition to `C-g'.
  (transient-bind-q-to-quit))

;;;; Terminal emulator

;; Feature `eshell' is a shell-like command interpreter implemented in Emacs
;; Lisp. It invokes no external processes except for those requested by the
;; user.
(use-feature! eshell
  :config

  ;; Do not litter `user-emacs-directory' with Eshell data.
  (setopt eshell-directory-name (expand-file-name "eshell" my-cache-dir)))

;; Package `vterm' is fully-fledged terminal emulator based on an external
;; library (libvterm) loaded as a dynamic module. As a result of using compiled
;; code (instead of elisp), `vterm' is fully capable, fast, and it can
;; seamlessly handle large outputs.
(use-package! vterm
  :commands (vterm
             vterm-other-window)
  :init

  (defhook! my--vterm-setup ()
    vterm-mode-hook
    "Set custom settings for `vterm-mode'."
    (setq-local global-hl-line-mode nil))

  (set-leader-keys!
    "a s" #'vterm
    "a S" #'vterm-other-window)

  :config

  ;; Kill buffers when the associated process is terminated.
  (setq vterm-kill-buffer-on-exit t))

;; Package `vterm-toggle' provides a command which toggles between the `vterm'
;; buffer and whatever buffer you are editing.
(use-package! vterm-toggle
  :bind (("<f2>"    . #'vterm-toggle)
         :map vterm-mode-map
         ("<f2>"    . #'vterm-toggle)
         ("C-c C-d" . #'vterm-toggle-insert-cd)))

;;;; External commands

(set-leader-keys! "!" (cons "shell cmd" #'shell-command))
(set-leader-keys! "&" (cons "async shell cmd" #'async-shell-command))

;; Feature `compile' provides a way to run a shell command from Emacs and view
;; the output in real time, with errors and warnings highlighted and
;; hyperlinked.
(use-feature! compile
  :functions (ansi-color-apply-on-region
              pop-to-buffer-other-window)
  :commands (kill-compilation
             recompile)
  :init

  (defadvice! my--compilation-read-command (command)
    :override
    #'compilation-read-command
    "Overwrite `compilation-read-command' to use `completing-read'."
    (completing-read "Compile command: " compile-history
                     nil nil command
                     (if (equal (car compile-history) command)
                         '(compile-history . 1)
                       'compile-history)))

  (defun switch-to-compilation-buffer (&optional arg)
    "Go to the last compilation buffer.
If prefix argument ARG is given, switch to it in an other,
possibly new window."
    (interactive)
    (if next-error-last-buffer
        (if arg
            (pop-to-buffer-other-window next-error-last-buffer)
          (pop-to-buffer next-error-last-buffer))
      (user-error "There is no compilation buffer")))

  (set-leader-keys!
    "b c" #'switch-to-compilation-buffer
    "c b" #'switch-to-compilation-buffer
    "c c" #'compile
    "c k" #'kill-compilation
    "c r" #'recompile)

  :hook (compilation-filter-hook . ansi-color-compilation-filter)
  :config

  ;; Automatically scroll the Compilation buffer as output appears,
  ;; but stop at the first error.
  (setq compilation-scroll-output 'first-error))

;; Feature `consult-compile' provides the command `consult-compile-error' to
;; quickly jump to compilation errors and warnings.
(use-feature! consult-compile
  :bind (("M-g c"   . #'consult-compile-error)
         ("M-g M-c" . #'consult-compile-error)))

;;;; Emacs profiling

;; Package `esup' allows you to run a child Emacs process with special profiling
;; functionality, and to collect timing results for each form in your init-file.
(use-package! esup
  :config

  ;; Work around a bug where esup tries to step into the byte-compiled version
  ;; of `cl-lib' and fails horribly.
  (setq esup-depth 0)

  (defadvice! my--esup-unwrap-init-file
      (esup &optional init-file)
    :around #'esup
    "Help `esup' to work with the `user-init-file'."
    (if init-file
        (funcall esup init-file)
      (let ((fname (expand-file-name "esup-init.el" temporary-file-directory)))
        (with-temp-file fname
          (print
           `(progn
              ;; We need this for `string-trim', but it's not `require'd until
              ;; the beginning of my-init.el.
              (require 'subr-x)

              ;; Prevent indentation from being lost in the profiling results.
              (advice-add #'esup-child-chomp :override #'string-trim)

              ;; Esup does not set `user-init-file'.
              (setq user-init-file ,user-init-file)

              ;; If there's an error, let me see where it is.
              (setq debug-on-error t)

              ;; Make it possible to detect whether the init-file is being
              ;; profiled.
              (defvar my--currently-profiling-p t)

              ;; Abbreviated (and flattened) version of early-init.el.
              (setq package-enable-at-startup nil)
              (setq autoload-compute-prefixes nil)
              (setq default-frame-alist '((menu-bar-lines . 0)
                                          (tool-bar-lines . 0)
                                          (vertical-scroll-bars)))
              (setq frame-inhibit-implied-resize t))
           (current-buffer))
          (insert-file-contents-literally user-init-file)
          (goto-char (point-max))
          (print
           (current-buffer)))
        (funcall esup fname)))))

;;; Startup

;; Disable the *About GNU Emacs* buffer at startup, and go straight for the
;; scratch buffer.
(setq inhibit-startup-screen t)

;; Remove the initial *scratch* message. Start with a blank screen.
(setq initial-scratch-message nil)

;; Avoid pulling in many packages by starting the scratch buffer in
;; `fundamental-mode', rather than `list-interaction-mode'.
(setq initial-major-mode 'fundamental-mode)

;; Avoid loading unnecessary `default' library
(setq inhibit-default-init t)

;; Inhibit displaying instructions on how to exit the client on connection.
(setq server-client-instructions nil)

;; Get rid of "For information about GNU Emacs..." message at startup, unless
;; we're in a daemon session, where it'll say "Starting Emacs daemon." instead,
;; which isn't so bad.
(unless (daemonp)
  (advice-add #'display-startup-echo-area-message :override #'ignore))

;;; Shutdown

;; Bind additional helpful commands for shutting down Emacs.
(set-leader-keys!
  "q q" #'kill-emacs
  "q r" #'restart-emacs
  "q s" #'save-buffers-kill-terminal
  "q S" #'save-buffers-kill-emacs)

;;; Miscellaneous

;; Enable all disabled commands.
(setq disabled-command-function nil)

;;; Appearance

;; Show both line and column in modeline.
(line-number-mode +1)
(column-number-mode +1)

;; Set cursor as white IBeam.
(setq-default cursor-type 'bar)

;; Allow you to resize frames however you want, not just in whole columns.
(setq frame-resize-pixelwise t)

;; Don't suggest shorter ways to type commands in M-x, since they don't apply
;; when using Vertico.
(setq suggest-key-bindings 0)

;; Decrease the frequency of UI updates when Emacs is idle.
(setq idle-update-delay 1)

;; Defer fontification after 0.05s of being idle.
(setq jit-lock-defer-time 0.05)

;; Reduce rendering/line scan work for Emacs by not rendering cursors or regions
;; in non-focused windows.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;; Disable bidirectional text rendering for a modest performance boost.
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; Feature `display-line-numbers' provides a minor mode interface for
;; `display-line-numbers'.
(use-feature! display-line-numbers
  :init

  (set-leader-keys!
    "t n" #'display-line-numbers-mode
    "t N" #'global-display-line-numbers-mode)

  :hook ((prog-mode-hook text-mode-hook) . display-line-numbers-mode))

;; Feature `display-fill-column-indicator' provides a minor mode interface for
;; `display-fill-column-indicator'.
(use-feature! display-fill-column-indicator
  :init

  (set-leader-keys!
    "t f" #'display-fill-column-indicator-mode
    "t F" #'global-display-fill-column-indicator-mode)

  :hook (prog-mode-hook . display-fill-column-indicator-mode))

;;;; Font

;; Bind keys for font size changes.
(set-leader-keys!
  "z =" (cons "text-scale-adjust-increase" #'global-text-scale-adjust)
  "z +" (cons "text-scale-adjust-increase" #'global-text-scale-adjust)
  "z -" (cons "text-scale-adjust-decrease" #'global-text-scale-adjust)
  "z 0" (cons "text-scale-adjust-reset"    #'global-text-scale-adjust))

;;;; Theme

(defvar after-load-theme-hook nil
  "Hook run after a color theme is loaded using `load-theme'.")

(defadvice! my--after-load-theme (&rest _)
  :after #'load-theme
  "After theme is loaded, run `after-load-theme-hook'."
  (run-hooks 'after-load-theme-hook))

(defhook! my--set-cursor-color-in-terminal ()
  (after-load-theme-hook server-after-make-frame-hook)
  "Set cursor color in terminal Emacs based on the current theme."
  (unless (display-graphic-p)
    (let ((color (face-attribute 'cursor :background)))
      (if color
          ;; Only some terminals support this exact escape code.
          (send-string-to-terminal (format "\e]12;%s\a" color))))))

(defhook! my--reset-cursor-color-in-terminal-main ()
  kill-emacs-hook
  "Reset cursor color in terminal Emacs after exiting it."
  (unless (display-graphic-p)
    (send-string-to-terminal "\e]112\a")))

(defun my--reset-cursor-color-in-terminal (terminal)
  "Reset cursor color in terminal Emacs"
  (send-string-to-terminal "\e]112\a" terminal))
(add-to-list 'delete-terminal-functions #'my--reset-cursor-color-in-terminal)

;; Make both function calls and variable references italic, both of these are
;; not modified by `modus-themes' and `ef-themes'.
(set-face-attribute 'font-lock-function-call-face nil :slant 'italic)
(set-face-attribute 'font-lock-variable-use-face nil :slant 'italic)

;; Package `modus-themes' is a pack of themes that conform with the highest
;; standard for colour-contrast accessibility between background and foreground
;; values (WCAG AAA).
(use-package! modus-themes
  :demand t
  :bind ("<f9>" . modus-themes-select)
  :config

  ;; Use italic font forms in more code constructs, like comments.
  (setq modus-themes-italic-constructs t)

  ;; Use a bold typographic weight for text in command prompts, e.g. minibuffer.
  (setq modus-themes-prompts '(bold))

  (setq modus-themes-common-palette-overrides
        '(;; Make the mode line borderless
          (border-mode-line-active unspecified)
          (border-mode-line-inactive unspecified)
          ;; Make matching delimiters produced by `show-paren-mode' much more
          ;; prominent.
          (bg-paren-match bg-magenta-intense)
          (underline-paren-match fg-main)))

  ;; Draw a line below matching characters in completions buffers.
  (setq modus-themes-completions
        '((matches . (underline)))))

;; Package `ef-themes' is a collection of light and dark themes whose goal is to
;; provide colorful ("pretty") yet legible options for users who want something
;; with a bit more flair than the `modus-themes'.
(use-package! ef-themes
  :demand t
  :bind ("<f8>" . ef-themes-select)
  :config

  (setq ef-themes-common-palette-overrides
        '(;; Make matching delimiters produced by `show-paren-mode' much more
          ;; prominent.
          (bg-paren bg-magenta-intense))))

;; Package `theme-buffet' arranges to automatically change themes during
;; specific times of the day or at fixed intervals. The collection of themes is
;; customisable, with the default options covering the built-in Emacs themes as
;; well as `modus-themes' and `ef-themes'.
(use-package! theme-buffet
  :demand t
  :config

  ;; Silence messages when changing themes.
  (dolist (func '(theme-buffet--reload-theme
                  theme-buffet-timer-hours))
    (advice-add func :around #'advice-silence-messages!))

  ;; Use Modus and Ef themes when selecting the theme list.
  (setq theme-buffet-menu 'modus-ef)

  ;; Change a theme every 1 hour.
  (theme-buffet-timer-hours 1)

  ;; Load a theme from the current time period.
  (theme-buffet-a-la-carte))

;;;; Modeline

;; Package `hide-mode-line' provides a minor mode that hides (or masks) the
;; modeline in your current buffer. It can be used to toggle an alternative
;; modeline, toggle its visibility, or simply disable the modeline in buffers
;; where it isn't very useful otherwise.
(use-package! hide-mode-line
  :hook (treemacs-mode-hook . hide-mode-line-mode))

;; Package `keycast' provides two modes that display the current command and its
;; key or mouse binding, and update the displayed information once another
;; command is invoked. `keycast-mode' displays the command and event in the
;; mode-line and `keycast-log-mode' displays them in a dedicated frame.
(use-package! keycast
  :init

  (set-leader-keys! "t k" #'keycast-mode-line-mode)

  :config

  ;; Move Keycast display to be the last one in the modeline.
  (setopt keycast-mode-line-insert-after 'mode-line-misc-info)

  ;; Replace typing with a simple message.
  (dolist (input '(self-insert-command
                   org-self-insert-command))
    (add-to-list 'keycast-substitute-alist `(,input "." "Typing...")))

  ;; Don't show various mouse events.
  (dolist (event '(mouse-event-p
                   mouse-movement-p
                   mwheel-scroll))
    (add-to-list 'keycast-substitute-alist `(,event nil))))

;; Package `minions' implements a menu that lists enabled minor-modes, as
;; well as commonly but not currently enabled minor-modes.  It can be used to
;; toggle local and global minor-modes, to access mode-specific menus, and to
;; get help about modes.
(use-package! minions
  :demand t
  :config

  ;; Always show Flymake to see errors/warnings.
  ;; Always show View Mode to better indicate read-only files.
  (setopt minions-prominent-modes '(flymake-mode
                                    view-mode))

  (set-leader-keys! "t m" #'minions-mode)

  (minions-mode +1))

;;;; Tabs

;; Feature `tab-bar' display a Tab Bar at the top of each frame. The Tab Bar is
;; a row of tabs—buttons that you can click to switch between window
;; configurations. Each tab on the Tab Bar represents a named persistent window
;; configuration of its frame, i.e., how that frame is partitioned into windows
;; and which buffer is displayed in each window. The tab’s name is composed from
;; the list of names of buffers shown in windows of that window configuration.
;; Clicking on the tab switches to the window configuration recorded by the tab;
;; it is a configuration of windows and buffers which was previously used in the
;; frame when that tab was the current tab.
(use-feature! tab-bar
  :init

  (set-leader-keys!
    "F d" #'tab-close
    "F D" #'tab-close-other
    "T m" #'tab-move
    "T n" #'tab-new
    "T o" #'tab-next
    "T O" #'tab-previous
    "T r" #'tab-rename
    "T s" #'tab-switch
    "T T" #'other-tab-prefix)

  :config

  ;; Hide the tab bar when it has only one tab, and show it again once more tabs
  ;; are created.
  (setopt tab-bar-show 1)

  ;; Truncate buffer's name to avoid very long tabs.
  (setopt tab-bar-tab-name-function #'tab-bar-tab-name-truncated))

;; Feature `tab-line' displays a tab line on the top screen line of each window.
;; The Tab Line shows special buttons for each buffer that was displayed in a
;; window, and allows switching to any of these buffers by clicking the
;; corresponding button. Clicking on the '+' icon adds a new buffer to the
;; window-local tab line of buffers, and clicking on the 'x' icon of a tab
;; deletes it. The mouse wheel on the tab line scrolls the tabs horizontally.
(use-feature! tab-line
  :demand t
  :bind ( :map tab-line-mode-map
          ("C-<prior>" . #'tab-line-switch-to-prev-tab)
          ("C-<next>"  . #'tab-line-switch-to-next-tab))
  :config

  ;; Group buffers by mode name.
  (setopt tab-line-tabs-function #'tab-line-tabs-buffer-groups)

  ;; Upon closing a tab kill the tab's buffer.
  (setopt tab-line-close-tab-function 'kill-buffer)

  ;; Truncate buffer's name to avoid very long tabs.
  (setopt tab-line-tab-name-function #'tab-line-tab-name-truncated-buffer)

  (global-tab-line-mode +1))

;;;; Padding

;; Package `spacious-padding' provides a global minor mode to increase the
;; spacing/padding of Emacs windows and frames. The idea is to make editing and
;; reading feel more comfortable.
(use-package! spacious-padding
  :demand t
  :bind ("<f7>" . spacious-padding-mode)
  :config

  ;; Keep default settings but lower mode line width
  (setq spacious-padding-widths
        '( :internal-border-width 15
           :header-line-width 4
           :mode-line-width 1
           :tab-width 4
           :right-divider-width 30
           :scroll-bar-width 8))

  (with-display-graphic!
    (spacious-padding-mode +1)))

;;; Closing

;; Prune the build cache for straight.el - this will prevent it from growing too
;; large.
(straight-prune-build-cache)

;; Occasionally, prune the build directory as well.
(unless (bound-and-true-p my--currently-profiling-p)
  (when (= 0 (random 20))
    (straight-prune-build-directory)))

;; Restore default values after startup.
(dolist (handler file-name-handler-alist)
  (cl-pushnew handler my--initial-file-name-handler-alist))
(setq file-name-handler-alist my--initial-file-name-handler-alist)

;; Local Variables:
;; checkdoc-symbol-words: ("top-level")
;; byte-compile-warnings: (not make-local noruntime)
;; no-native-compile: t
;; indent-tabs-mode: nil
;; outline-regexp: ";;;+ "
;; sentence-end-double-space: nil
;; End:

;;; init.el ends here
