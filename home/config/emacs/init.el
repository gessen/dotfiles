;;; init.el --- Load the full configuration -*- lexical-binding: t -*-

;;; Commentary:

;; This file bootstraps the whole configuration.

;;; Code:

;; Produce backtrace when error occurs
;; (setq debug-on-error t)

(defvar my-minimum-emacs-version "27.1"
  "This Emacs configuration does not support any Emacs version below this.")

;; Make sure we are running a modern enough Emacs, otherwise abort init
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

(defvar my--after-display-system-init-list '()
  "List of functions to be run after the display system is initialized.")

;; Just to keep byte-compiler happy.
(declare-function server-create-window-system-frame
                  (display nowait proc parent-id &optional parameters))

(defadvice! my--after-server-create-window-system-frame
    (&rest _)
  :after #'server-create-window-system-frame
  "After Emacs server creates a frame, run functions queued in
`MY--AFTER-DISPLAY-SYSTEM-INIT-LIST' to do any setup that needs
to have the display system initialized."
  (dolist (fn (reverse my--after-display-system-init-list))
    (funcall fn)))

(defmacro after-display-graphic-init! (&rest body)
  "Run `BODY' after display graphic is initialised.
If the display-graphic is initialized, run `BODY', otherwise, add
it to a queue of actions to perform after the first graphical
frame is created."
  (declare (indent defun))
  `(let ((init (cond ((boundp 'x-initialized) x-initialized)
                     ;; fallback to normal loading behavior only if in a GUI
                     (t (display-graphic-p)))))
     (if init
         (progn
           ,@body)
       (push (lambda () ,@body) my--after-display-system-init-list))))

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

;; Hide modeline before updating it
(setq-default mode-line-format nil)

;;; Package management

;; Disable warnings from obsolete advice system. They don't provide useful
;; diagnostic information and often they can't be fixed except by changing
;; packages upstream.
(setq ad-redefinition-action 'accept)

;; Define this variable for native compilation disabled Emacs.
(setq native-comp-deferred-compilation-deny-list '())

;;;; straight.el

(eval-and-compile
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

;; Explicitly require `use-package' when compiling to keep Flycheck happy.
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

(defvar my-leader-key-map (make-sparse-keymap)
  "Keymap for all leader key commands that should be put under a prefix.")

(defconst my-leader-key "M-m"
  "The leader key.")

(defconst my-major-mode-leader-key "C-M-m"
  "Major mode leader key.")

(defconst my-leader-key-prefixes '(("!" "shell cmd")
                                   ("/" "search project")
                                   ("?" "describe keybinds")
                                   ("a" "applications")
                                   ("b" "buffers")
                                   ("c" "compile/comment")
                                   ("d" "devdocs")
                                   ("D" "diff")
                                   ("e" "errors")
                                   ("g" "git")
                                   ("f" "files")
                                   ("F" "frames")
                                   ("h" "help")
                                   ("i" "insert")
                                   ("j" "jump")
                                   ("k" "macros")
                                   ("l" "fold")
                                   ("m" "major mode")
                                   ("M-m" "major mode")
                                   ("o" "org")
                                   ("p" "projects")
                                   ("P" "packages")
                                   ("q" "quit")
                                   ("r" "registers/rings")
                                   ("R" "rectangles")
                                   ("s" "search")
                                   ("S" "spellcheck")
                                   ("t" "toggle")
                                   ("T" "tabs")
                                   ("th" "highlight")
                                   ("u" "undo")
                                   ("v" "multiple cursors")
                                   ("V" "expand region")
                                   ("w" "windows")
                                   ("x" "text")
                                   ("z" "zoom"))
  "List of all prefixes used with leader key.")

(defun declare-prefix-for-mode! (mode prefix name)
  "Declares a `which-key' PREFIX for MODE.
MODE is the mode in which this prefix command should be added.
PREFIX is a string describing a key sequence. NAME is a string
used as the prefix command."
  (declare (indent defun))
  (let* ((is-major-mode (string-prefix-p "m" prefix))
         (is-minor-mode (not is-major-mode))
         (map (intern (format "my-%s-map" mode))))
    (when (my--init-leader-mode-map mode map is-minor-mode)
      (which-key-add-keymap-based-replacements
        (symbol-value map)
        (if is-major-mode (substring prefix 1) prefix ) name))))

(defun declare-prefix! (prefix name)
  "Declares a `which-key' PREFIX.
PREFIX is a string describing a key sequence. NAME is a string
used as the prefix command."
  (declare (indent defun))
  (which-key-add-keymap-based-replacements my-leader-key-map prefix name))

(defun my--init-leader-mode-map (mode map &optional minor)
  "Initialise MAP prefix if it doesn't exist yet.
Use `bind-map' to create MAP prefix and bind it to
`my-major-mode-leader-key'. If MODE is a minor-mode, the third
argument should be non nil."
  (let* ((prefix (intern (format "%s-prefix" map)))
         (leader-key1 my-major-mode-leader-key)
         (leader-key2 (concat my-leader-key " m"))
         (leader-key3 (concat my-leader-key " M-m"))
         (leaders (list leader-key1 leader-key2 leader-key3)))
    (or (boundp prefix)
        (progn
          (eval
           `(bind-map ,map
              :prefix-cmd ,prefix
              ,(if minor :minor-modes :major-modes) (,mode)
              :keys ,leaders))
          (boundp prefix)))))

(defun set-leader-keys-for-mode! (mode is-minor-mode key def &rest bindings)
  "Add a series of BINDINGS to `my-mode-map'.
MODE should be a quoted symbol corresponding to a valid minor
mode. IS-MINOR-MODE denotes whether the MODE is minor. BINDINGS
is a series of KEY DEF pair."
  (declare (indent defun))
  (let ((map (intern (format "my-%s-map" mode))))
    (when (my--init-leader-mode-map mode map is-minor-mode)
      (while key
        (bind-key key def (symbol-value map))
        (setq key (pop bindings)
              def (pop bindings))))))

(defun set-leader-keys-for-minor-mode! (mode key def &rest bindings)
  "Add a series of BINDINGS to `my-mode-map'.
MODE should be a quoted symbol corresponding to a valid minor
mode. BINDINGS is a series of KEY DEF pair."
  (declare (indent defun))
  (apply #'set-leader-keys-for-mode! mode t key def bindings))

(defun set-leader-keys-for-major-mode! (mode key def &rest bindings)
  "Add a series of BINDINGS to `my-mode-map'.
MODE should be a quoted symbol corresponding to a valid major
mode. BINDINGS is a series of KEY DEF pair."
  (declare (indent defun))
  (apply #'set-leader-keys-for-mode! mode nil key def bindings))

(defun set-leader-keys! (key def &rest bindings)
  "Add a series of BINDINGS to `my-leader-key-map'.
BINDINGS is a series of KEY DEF pair."
  (declare (indent defun))
  (while key
    (bind-key key def my-leader-key-map)
    (setq key (pop bindings)
          def (pop bindings))))

;; Package `bind-key' provides a macro by the same name (along with `bind-key*'
;; and `unbind-key') which provides a much prettier API for manipulating keymaps
;; than `define-key' and `global-set-key' do. It's also the same API that
;; `:bind' and similar keywords in `use-package' use.
(use-package! bind-key
  :demand t)

;; Package `bind-map' is an Emacs package providing the macro bind-map which can
;; be used to make a keymap available across different "leader keys". It is
;; essentially a generalization of the idea of a leader key as used in vim or
;; the Emacs https://github.com/cofi/evil-leader package, and allows for an
;; arbitrary number of "leader keys".
(use-package! bind-map
  :demand t)

;; Bind `leader-key' to `my-leader-key-map'.
(bind-map my-leader-key-map
  :keys (my-leader-key))

;; Package `which-key' displays the key bindings and associated commands
;; following the currently-entered key prefix in a popup.
(use-package! which-key
  :demand t
  :config

  ;; Declare all defined prefixes used with leader key
  (mapc (lambda (prefix) (apply #'declare-prefix! prefix))
        my-leader-key-prefixes)

  ;; Allow a key binding to match and be modified by multiple elements in
  ;; `which-key-replacement-alist'
  (setq which-key-allow-multiple-replacements t)

  ;; Show remapped command if a command has been remapped given the currently
  ;; active keymaps
  (setq which-key-compute-remaps t)

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

(set-leader-keys! "?" #'describe-bindings)

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

  :config

  ;; Change screen regexp to consider only "screen" as running under screen as
  ;; tmux uses screen-256color and if `clipetty' considers it screen the
  ;; clipboard functionality will not work when emacs runs as client inside
  ;; tmux.
  (setq clipetty-screen-regexp "^screen$")

  :blackout t)

;;;; Mouse integration

;; Mouse integration works out of the box in windowed mode but not terminal mode
(unless (display-graphic-p)
  ;; Enable basic mouse support (click and drag).
  (xterm-mouse-mode t))

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
(fset 'yes-or-no-p 'y-or-n-p)

;; Prevent Custom from modifying this file.
(setq custom-file (expand-file-name "custom.el" my-cache-dir))

;; Feature `request' provides a layer for URL requests.
(use-feature! request
  :config

  ;; Do not litter `user-emacs-directory' with cache files.
  (setq request-storage-directory (expand-file-name "request" my-cache-dir)))

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
  "bd" #'kill-this-buffer
  "bx" #'kill-buffer-and-window
  "FB" #'display-buffer-other-frame
  "w0" #'delete-window
  "w1" #'split-window-single
  "w2" #'split-window-double
  "w3" #'split-window-triple
  "w4" #'split-window-grid
  "wb" #'switch-to-minibuffer-window
  "we" #'balance-windows-area
  "wm" #'maximize-buffer
  "ws" #'split-window-below
  "wS" #'split-window-below-and-focus
  "wv" #'split-window-right
  "wV" #'split-window-right-and-focus
  "wx" #'kill-buffer-and-window)

;; Overwrite default `delete-other-windows' maximize-buffer
(bind-key "C-x 1" #'maximize-buffer)

;; Shorter binding to `kill-this-buffer', overwrites `quoted-insert'.
(bind-key "C-q" #'kill-this-buffer)

;; Bind keys for multi-frame management
(set-leader-keys!
  "Fd" #'delete-frame
  "FD" #'delete-other-frames
  "Fn" #'make-frame
  "Fo" #'other-frame)

;; Feature `follow' makes two windows, both showing the same buffer, scroll as a
;; single tall virtual window. In Follow mode, if you move point outside the
;; portion visible in one window and into the portion visible in the other
;; window, that selects the other window—again, treating the two as if they were
;; parts of one large window.
(use-feature! follow
  :init
  (set-leader-keys! "wF" #'follow-mode)
  :blackout " ⓕ")

;; Feature `ibuffer' provides a more modern replacement for the `list-buffers'
;; command.
(use-feature! ibuffer
  :bind ([remap list-buffers] . #'ibuffer-other-window))

;; Package `ibuffer-projectile' adds functionality to `ibuffer' for grouping
;; buffers by their Projectile root directory.
(use-package! ibuffer-projectile
  :init

  (defhook! my--ibuffer-group-by-projects ()
    ibuffer-hook
    "Group buffers by projects."
    (ibuffer-projectile-set-filter-groups)
    (ibuffer-projectile-set-filter-groups)
    (unless (eq ibuffer-sorting-mode 'alphabetic)
      (ibuffer-do-sort-by-alphabetic))))

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
    "wu" #'winner-undo
    "wU" #'winner-redo)

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
  (after-display-graphic-init! (winner-mode +1)))

;; Package `ace-window' provides a function, `ace-window' which is meant to
;; replace `other-window' by assigning each window a short, unique label. When
;; there are only two windows present, `other-window' is called. If there are
;; more, each window will have its first label character highlighted. Once a
;; unique label is typed, ace-window will switch to that window.
(use-package! ace-window
  :init

  (set-leader-keys!
    "wd" #'ace-delete-window
    "wD" #'ace-delete-other-windows
    "wM" #'ace-swap-window
    "ww" #'ace-window)
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
  (set-leader-keys! "tg" #'golden-ratio-mode)

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
                  "speedbar-mode"))
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

  :blackout " Ⓖ")

;; Package `winum' helps with navigating windows and frames using numbers. It is
;; an extended and actively maintained version of the `window-numbering'
;; package. This version brings, among other things, support for number sets
;; across multiple frames, giving the user a smoother experience of multi-screen
;; Emacs.
(use-package! winum
  :demand t
  :bind (:map winum-keymap
              ("M-1" . #'winum-select-window-1)
              ("M-2" . #'winum-select-window-2)
              ("M-3" . #'winum-select-window-3)
              ("M-4" . #'winum-select-window-4)
              ("M-5" . #'winum-select-window-5)
              ("M-6" . #'winum-select-window-6)
              ("M-7" . #'winum-select-window-7)
              ("M-8" . #'winum-select-window-8)
              ("M-9" . #'winum-select-window-9))

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
          (call-interactively #'projectile-invalidate-cache)
          (message "File '%s' deleted" filename)))))

(defun rename-current-buffer-file ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless (and filename (file-exists-p filename))
      (user-error "Buffer '%s' is not visiting a file" name))
    (let* ((basename (file-name-nondirectory filename))
           (new-filename (read-file-name
                          "New name: " (file-name-directory filename)
                          basename nil basename)))
      (when (get-buffer new-filename)
        (user-error "A buffer named '%s' already exists" new-filename))
      (rename-file filename new-filename 1)
      (rename-buffer new-filename)
      (set-visited-file-name new-filename)
      (set-buffer-modified-p nil)
      (recentf-add-file new-filename)
      (recentf-remove-if-non-kept filename)
      (call-interactively #'projectile-invalidate-cache)
      (message "File '%s' renamed to '%s'"
               name (file-name-nondirectory new-filename)))))

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

(declare-prefix! "fe" "emacs")

(set-leader-keys!
  "be"  #'safe-erase-buffer
  "bR"  #'safe-revert-buffer
  "fA"  #'find-alternate-file
  "fc"  #'write-file
  "fD"  #'delete-current-buffer-file
  "fei" #'find-user-init-file
  "fed" #'find-user-emacs-directory
  "ff"  #'find-file
  "fi"  #'insert-file
  "fl"  #'find-file-literally
  "fm"  #'rename-current-buffer-file
  "fo"  #'open-in-external-app
  "fs"  #'save-buffer
  "fS"  #'save-some-buffers
  "Ff"  #'find-file-other-frame
  "wf"  #'find-file-other-window)

;; Feature `files-x' extends file handling with local persistent variables.
(use-feature! files-x
  :init
  (declare-prefix! "fv" "variables")
  (set-leader-keys!
    "fvd" #'add-dir-local-variable
    "fvf" #'add-file-local-variable
    "fvp" #'add-file-local-variable-prop-line))

;; Feature `mule' provides basic commands for multilingual environment
(use-feature! mule
  :commands (dos2unix unix2dox)
  :init
  (declare-prefix! "fC" "convert")
  (set-leader-keys!
    "fCu" #'dos2unix
    "fCd" #'unix2dos)

  :config

  (defun dos2unix ()
    "Convert the current buffer to UNIX file format."
    (interactive)
    (set-buffer-file-coding-system 'undecided-unix nil))

  (defun unix2dos ()
    "Convert the current buffer to DOS file format."
    (interactive)
    (set-buffer-file-coding-system 'undecided-dos nil)))

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
  :demand t
  :config

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

;; Package `fasd' hooks into to `find-file-hook' to add all visited files and
;; directories to `fasd'. It also allow to use `fasd' binary to prompt and fuzzy
;; complete available candidates.
(use-package! fasd
  :demand t
  :init
  (declare-prefix! "fa" "fasd")
  (set-leader-keys!
    "fad" #'fasd-find-directory-only
    "faf" #'fasd-find-file-only
    "fas" #'fasd-find-file)

  :config

  (defun fasd-find-file-only ()
    "Use fasd to open a file."
    (interactive)
    (fasd-find-file -1))

  (defun fasd-find-directory-only ()
    "Use fasd to open a directory with dired."
    (interactive)
    (fasd-find-file 2))

  (global-fasd-mode +1))

;; Package `projectile' keeps track of a "project" list, which is automatically
;; added to as you visit Git repositories, Node.js projects, etc. It then
;; provides commands for quickly navigating between and within these projects.
(use-package! projectile
  :defer 1
  :commands (projectile-register-project-type)
  :init

  (set-leader-keys!
    "p!" #'projectile-run-shell-command-in-root
    "p&" #'projectile-run-async-shell-command-in-root
    "p%" #'projectile-replace-regexp
    "pa" #'projectile-toggle-between-implementation-and-test
    "pb" #'projectile-switch-to-buffer
    "pc" #'projectile-compile-project
    "pC" #'projectile-configure-project
    "pd" #'projectile-find-dir
    "pD" #'projectile-dired
    "pe" #'projectile-edit-dir-locals
    "pf" #'projectile-find-file
    "pF" #'projectile-find-file-in-known-projects
    "pg" #'projectile-grep
    "pi" #'projectile-install-project
    "pI" #'projectile-invalidate-cache
    "pk" #'projectile-kill-buffers
    "pp" #'projectile-switch-project
    "pP" #'projectile-package-project
    "pr" #'projectile-recentf
    "pR" #'projectile-replace
    "pt" #'projectile-test-project)

  :config

  ;; When switching projects, give the option to choose what to do. This is a
  ;; way better interface than having to remember ahead of time to use a prefix
  ;; argument on `projectile-switch-project'.
  (setq projectile-switch-project-action 'projectile-commander)

  ;; Use Selectrum via `completing-read'.
  (setq projectile-completion-system 'default)

  ;; Sort files by recently active buffers first, then recently opened files.
  (setq projectile-sort-order 'recently-active)

  ;; Use git-grep underhood `projectile-grep' when possible.
  (setq projectile-use-git-grep t)

  ;; Do not litter `user-emacs-directory' with projectile persistent files.
  (setq projectile-cache-file (expand-file-name "projectile.el" my-cache-dir)
        projectile-known-projects-file (expand-file-name
                                        "projectile-bookmarks.el"
                                        my-cache-dir))

  ;; Ignore `straight' repos when opening them.
  (setq projectile-ignored-projects (list (expand-file-name
                                           "straight/"
                                           user-emacs-directory)))

  ;; Register CMake project type.
  (projectile-register-project-type
   'cmake '("CMakeLists.txt")
   :project-file "CMakeLists.txt"
   :compilation-dir "build"
   :configure (string-join '("cmake %s -B%s"
                             "-DCMAKE_INSTALL_PREFIX=/usr") " ")
   :compile "cmake --build ."
   :test "cmake --build . && ctest --output-on-failure"
   :install "cmake --build . --target install"
   :package "cmake --build . --target package")

  ;; Register meson project type.
  (projectile-register-project-type
   'meson '("meson.build")
   :project-file "meson.build"
   :compilation-dir "build"
   :configure "meson %s --prefix=/usr"
   :compile "meson compile"
   :test "meson test"
   :install "meson install"
   :package "meson dist")

  (projectile-mode +1)

  :blackout t)

;; Package `sudo-edit' allows to open files as another user, by default "root".
(use-package! sudo-edit
  :init
  (set-leader-keys! "fE" #'sudo-edit))

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
    (setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers)))

  (with-eval-after-load 'projectile
    ;; Force loading `treemacs-projectile' package if `treemacs' wasn't loaded
    ;; by it via `treemacs-projectile' function.
    (require 'treemacs-projectile)))

;; Package `treemacs-projectile' brings Projectile integration for Treemacs.
(use-package! treemacs-projectile
  :init

  (set-leader-keys! "pT" #'treemacs-projectile))

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

;;; Editing
;;;; Text formatting

;; When region is active, make `capitalize-word' and friends act on it.
(bind-key "M-i" #'capitalize-dwim)
(bind-key "M-l" #'downcase-dwim)
(bind-key "M-u" #'upcase-dwim)

;; Rebind `quoted-insert' as C-q will be used by `kill-buffer'
(bind-key "C-z" #'quoted-insert)

;; Use M-DEL to remove word in terminal like in GUI
(bind-key "<M-delete>" #'backward-kill-word)

(set-leader-keys!
  "t C-f" #'auto-fill-mode
  "tt"    #'toggle-truncate-lines
  "tl"    #'visual-line-mode
  "tL"    #'global-visual-line-mode
  "xb"    #'delete-blank-lines
  "xf"    #'fill-paragraph
  "xt"    #'delete-trailing-whitespace)

;; Make `kill-line' kills the whole line.
(setq kill-whole-line t)

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
    "tw" #'whitespace-mode
    "tW" #'global-whitespace-mode)

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

  ;; Slightly rename `string-inflection' names.
  (declare-prefix! "xc" "inflection-camelcase")
  (declare-prefix! "xk" "inflection-elispcase")
  (declare-prefix! "xp" "inflection-pascalcase")
  (declare-prefix! "xs" "inflection-snakecase")
  (declare-prefix! "xu" "inflection-uppercase")
  (declare-prefix! "xx" "inflections")

  (set-leader-keys!
    "xc" #'string-inflection-lower-camelcase
    "xk" #'string-inflection-kebab-case
    "xp" #'string-inflection-camelcase
    "xs" #'string-inflection-underscore
    "xu" #'string-inflection-upcase
    "xx" #'hydra-string-inflection/body))

;; Package `ws-butler' unobtrusively remove trailing whitespace. What this means
;; is that only lines touched get trimmed. If the whitespace at end of buffer is
;; changed, then blank lines at the end of buffer are truncated respecting
;; `require-final-newline'. All of this happens only when saving.
(use-package! ws-butler
  :hook (prog-mode-hook . ws-butler-mode)

  :init
  (set-leader-keys! "t C-w" #'ws-butler-mode)

  :blackout " Ⓦ")

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
  :bind (:map indent-rigidly-map
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

(defun duplicate-line (&optional n)
  "Duplicate current line.
With argument N, make N copies. With negative N, comment out
original line and use the absolute value."
  (let ((text (thing-at-point 'line))
        (pos (- (point) (line-beginning-position))))
    (save-excursion
      ;; Go to beginning of next line, or make a new one when at the end of the
      ;; buffer
      (end-of-line)
      (when (< 0 (forward-line 1))
        (newline))
      (dotimes (_i (abs (or n 1 )))
        (insert text)))
    ;; Comment line with negative argument
    (when (> 0 n)
      (comment-region (line-beginning-position) (line-end-position)))
    (forward-line 1)
    ;; Go the the same position as in the original line
    (forward-char pos)))

(defun duplicate-region (&optional n)
  "Duplicate active region.
With argument N, make N copies."
  (let* ((pos (point))
         (start (region-beginning))
         (end (region-end))
         (len (- end start))
         (text (buffer-substring start end)))
    ;; Swap point and mark to get same behaviour or text insertion
    (when (< pos end)
      (exchange-point-and-mark))
    (dotimes (_i (abs (or n 1)))
      (insert text))
    ;; Enable temporary transient mark
    (setq deactivate-mark nil)
    (push-mark)
    (backward-char len)
    (setq transient-mark-mode (cons 'only t))
    ;; Swap point and mark again to restore their proper position at the end
    (unless (< pos end)
      (exchange-point-and-mark))))

(defun duplicate-line-or-region (&optional n)
  "Duplicate current line, or region if active.
With argument N, make N copies. With negative N, comment out
original line and use the absolute value."
  (interactive "p")
  (if mark-active
      (duplicate-region n)
    (duplicate-line n)))

(bind-key "M-c" #'duplicate-line-or-region)

(set-leader-keys!
  "bi" #'clone-indirect-buffer
  "bI" #'clone-indirect-buffer-other-window
  "by" #'copy-clipboard-to-buffer
  "bw" #'copy-buffer-to-clipboard
  "ib" #'insert-buffer)

;; Eliminate duplicates in the kill ring. That is, if you kill the same thing
;; twice, you won't have to use M-y twice to get past it to older entries in the
;; kill ring.
(setq kill-do-not-save-duplicates t)

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
    "td" #'hungry-delete-mode
    "tD" #'global-hungry-delete-mode)

  ;; Leave words separated by a single space if they would have been joined.
  (setq hungry-delete-join-reluctantly t)

  ;; Do not auto-delete LF and CR.
  (setq-default hungry-delete-chars-to-skip " \t\f\v")

  ;; Enable `hungry-delete-mode' everywhere.
  (global-hungry-delete-mode +1)

  :blackout " Ⓓ")

;; Package `zop-to-char' is a visual `zap-to-char' command for Emacs. It works
;; in minibuffer and you can change direction with C-b and C-f. You can also use
;; `zop-to-char' to move to a place with C-q.
(use-package! zop-to-char
  ;; Rebind `zap-to-char' to `zop-up-to-char' and bind `zop-to-char'.
  :bind (("M-z" . #'zop-up-to-char)
         ("M-Z" . #'zop-to-char)))

;;;; Selection

(set-leader-keys! "ba" #'mark-whole-buffer)

;; Package `easy-kill-extras' contains extra functions for `easy-kill' and
;; `easy-mark'.
(use-package! easy-kill-extras
  :bind ([remap mark-word] . #'easy-mark-word))

;; Package `expand-region' increases the selected region by semantic units. Just
;; keep pressing the key until it selects what you want.
(use-package! expand-region
  :init

  (set-leader-keys! "V" #'er/expand-region)

  :config

  ;; Use subword expressions, i.e in PascalCase treat each "word" separately.
  (setq expand-region-subword-enabled t)

  :bind ("C-=" . #'er/expand-region))

;; Package `smart-region' guesses what you want to select by one command:
;;
;; - If you call this command multiple times at the same position, it expands
;;   the selected region (with `er/expand-region').
;;
;; - Else, if you move from the mark and call this command, it selects the
;;   region rectangular (with `rectangle-mark-mode').
;;
;; - Else, if you move from the mark and call this command at the same column as
;;   mark, it adds a cursor to each line (with `mc/edit-lines').
(use-package! smart-region
  :bind ([remap set-mark-command] . #'smart-region)

  :config

  ;; Revert the behaviour of `smart-region' that blacklists itself as
  ;; `mc/cmds-to-run-once'.
  (add-to-list 'mc/cmds-to-run-for-all 'smart-region)
  (setq mc/cmds-to-run-once (delq 'smart-region mc/cmds-to-run-once))
  (mc/save-lists))

;;;; Multiple selection

;; Package `ace-mc' allows you to quickly add and remove `multiple-cursors' mode
;; cursors using `ace-jump'.
(use-package! ace-mc
  :init

  (set-leader-keys!
    "vj" #'ace-mc-add-multiple-cursors
    "vJ" #'ace-mc-add-single-cursor))

;; Package `iedit' includes Emacs minor modes (iedit-mode and
;; iedit-rectangle-mode) based on a API library (iedit-lib) and allows you to
;; edit one occurrence of some text in a buffer (possibly narrowed) or region,
;; and simultaneously have other occurrences edited in the same way, with visual
;; feedback as you type.
(use-package! iedit
  :init

  (set-leader-keys!
    "se" #'iedit-mode
    "sE" #'iedit-rectangle-mode)

  :bind (:map iedit-mode-keymap
              ("M-'" . #'iedit-show/hide-context-lines)))

;; Package `multiple-cursors' implements multiple cursors for Emacs in a similar
;; way in other text editors.
(use-package! multiple-cursors
  :functions (mc/mmlte--down
              mc/mmlte--up
              mc/mmlte--right
              mc/mmlte--left)
  :init
  (set-leader-keys!
    "va" #'mc/mark-all-dwim
    "vA" #'mc/mark-all-like-this
    "vb" #'mc/edit-beginnings-of-lines
    "ve" #'mc/edit-ends-of-lines
    "vg" #'mc/vertical-align-with-space
    "vG" #'mc/vertical-align
    "vl" #'mc/edit-lines
    "vn" #'mc/mark-next-like-this
    "vp" #'mc/mark-previous-like-this
    "vr" #'mc/mark-all-in-region
    "vR" #'mc/mark-all-in-region-regexp
    "vs" #'mc/skip-to-next-like-this
    "vS" #'mc/skip-to-previous-like-this
    "vu" #'mc/unmark-next-like-this
    "vU" #'mc/unmark-previous-like-this
    "vv" #'mc/mark-more-like-this-extended
    "vw" #'mc/mark-all-words-like-this)

  (with-eval-after-load 'multiple-cursors-core
    ;; Load other `multiple-cursors' libraries.
    (require 'mc-mark-more)

    ;; Do not litter `user-emacs-directory' with settings.
    (setq mc/list-file (expand-file-name "mc-lists.el" my-data-dir))

    ;; Load settings earlier as `smart-region` saves this file before actually
    ;; loading it. This results in constantly cleaned settings.
    (mc/load-lists)

    ;; Do not leave `multiple-cursors-mode' with RET.
    (unbind-key "<return>" mc/keymap)

    ;; Show only selected lines with `M-\''.
    (bind-key "M-'" #'mc-hide-unmatched-lines-mode mc/keymap)

    ;; Add additional bindings for `mc/mark-more-like-this-extended' in order
    ;; to not use keyboard arrows.
    (bind-key "C-n" #'mc/mmlte--down  mc/mark-more-like-this-extended-keymap)
    (bind-key "C-p" #'mc/mmlte--up    mc/mark-more-like-this-extended-keymap)
    (bind-key "C-s" #'mc/mmlte--right mc/mark-more-like-this-extended-keymap)
    (bind-key "C-r" #'mc/mmlte--left  mc/mark-more-like-this-extended-keymap))

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

  (set-leader-keys!
    "Rc" #'delete-whitespace-rectangle
    "Rd" #'delete-rectangle
    "Re" #'rectangle-exchange-point-and-mark
    "Ri" #'copy-rectangle-to-register
    "Rk" #'kill-rectangle
    "Rm" #'rectangle-mark-mode
    "RN" #'rectangle-number-lines
    "Ro" #'open-rectangle
    "Rs" #'string-rectangle
    "Rx" #'clear-rectangle
    "Ry" #'yank-rectangle))

;;;; Folding

;; Package `origami' is a text folding minor mode for Emacs. With this minor
;; mode enabled, you can collapse and expand regions of text. The actual buffer
;; contents are never changed in any way. This works by using overlays to affect
;; how the buffer is presented. This also means that all of your usual editing
;; commands should work with folded regions. For example killing and yanking
;; folded text works as you would expect. There are many commands provided to
;; make expanding and collapsing text convenient.
(use-package! origami
  :commands (origami-close-all-nodes
             origami-close-node
             origami-close-node-recursively
             origami-forward-toggle-node
             origami-open-all-nodes
             origami-open-node
             origami-open-node-recursively
             origami-next-fold
             origami-previous-fold
             origami-recursively-toggle-node
             origami-show-only-node
             origami-redo
             origami-reset
             origami-toggle-all-nodes
             origami-undo)
  :init

  (defhydra hydra-origami (:color pink :hint nil)
    "
Close^^           Open^^            Toggle^^         Goto^^         Other^^
-----^^---------- ----^^----------- ------^^-------- ----^^-------- -----^^---------
[_c_] at point    [_o_] at point    [_a_] at point   [_n_] next     [_s_] single out
[_C_] recursively [_O_] recursively [_A_] all        [_p_] previous [_R_] reset
[_m_] all         [_r_] all         [_TAB_] like org ^^             [_q_] quit
"
    ("a" origami-forward-toggle-node)
    ("A" origami-toggle-all-nodes)
    ("c" origami-close-node)
    ("C" origami-close-node-recursively)
    ("o" origami-open-node)
    ("O" origami-open-node-recursively)
    ("r" origami-open-all-nodes)
    ("m" origami-close-all-nodes)
    ("n" origami-next-fold)
    ("p" origami-previous-fold)
    ("s" origami-show-only-node)
    ("<tab>" origami-recursively-toggle-node)
    ("TAB" origami-recursively-toggle-node)
    ("u" origami-undo)
    ("d" origami-redo)
    ("R" origami-reset)
    ("q" nil :exit t)
    ("C-g" nil :exit t))

  (set-leader-keys! "l" 'hydra-origami/body)

  :hook (prog-mode-hook . origami-mode)

  :config

  ;; Highlight the line the fold start on.
  (setq origami-show-fold-header t))

;;;; Undo/redo

;; Feature `warnings' allows us to enable and disable warnings.
(use-feature! warnings
  :config

  ;; Ignore the warning we get when a huge buffer is reverted and the undo
  ;; information is too large to be recorded.
  (push '(undo discard-info) warning-suppress-log-types))

;; Package `undo-tree' replaces the default Emacs undo system, which is poorly
;; designed and hard to use, with a much more powerful tree-based system. In
;; basic usage, you don't even have to think about the tree, because it acts
;; like a conventional undo/redo system.
(use-package! undo-tree
  :demand t
  :config

  ;; Suppress message saying undo history could not be loaded or that it was
  ;; saved.
  (dolist (func '(undo-tree-load-history undo-tree-save-history))
    (advice-add func :around #'advice-silence-messages!))

  (set-leader-keys!
    "au" #'undo-tree-visualize
    "ur" #'undo-tree-redo
    "uu" #'undo-tree-undo
    "uv" #'undo-tree-visualize)

  (global-undo-tree-mode +1)

  ;; Save undo history to a persistent file when a buffer is saved.
  (setq undo-tree-auto-save-history t)

  ;; Display timestamps in undo-tree visualisation.
  (setq undo-tree-visualizer-timestamps t)

  ;; Display a diff in undo-tree visualisation.
  (setq undo-tree-visualizer-diff t)

  ;; Keep `user-emacs-directory' clean.
  (let ((autosave-dir (expand-file-name "undo-tree/site/" my-cache-dir))
        (tramp-autosave-dir (expand-file-name "undo-tree/dist/" my-cache-dir)))
    (setq undo-tree-history-directory-alist
          `((".*" . ,autosave-dir)
            ("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'" . ,tramp-autosave-dir)))
    (unless (file-directory-p autosave-dir)
      (make-directory autosave-dir t))
    (unless (file-directory-p tramp-autosave-dir)
      (make-directory tramp-autosave-dir t)))

  :blackout t)

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
  "bm" #'switch-to-messages-buffer
  "bn" #'new-empty-buffer)

;; Keep point screen position unchanged when scrolling
(setq scroll-preserve-screen-position t)

;; More performant rapid scrolling over unfontified regions. May cause brief
;; spells of inaccurate syntax highlighting right after scrolling, which should
;; quickly self-correct.
(setq fast-but-imprecise-scrolling t)

;; Overrides the default behavior of Emacs which recenters point when it reaches
;; the top or bottom of the screen.
(setq scroll-conservatively 101)

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
    "tc" #'subword-mode
    "tC" #'global-subword-mode)

  (global-subword-mode +1)

  :blackout " Ⓒ")

;; Package `golden-ratio' scrolls screen down or up and highlights current line
;; before or after scrolling. The lines it scrolls is scren_height * 0.618.
(use-package! golden-ratio-scroll-screen
  :bind (([remap scroll-down-command] . #'golden-ratio-scroll-screen-down)
         ([remap scroll-up-command]   . #'golden-ratio-scroll-screen-up)))

;; Package `avy' can move point to any position in Emacs – even in a different
;; window – using very few keystrokes. For this, you look at the position where
;; you want point to be, invoke Avy, and then enter the sequence of characters
;; displayed at that position.
(use-package! avy
  :init

  ;; Unbind `M-j' to and use it for `avy'
  (unbind-key "M-j")

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
    "t-" #'centered-cursor-mode
    "t_" #'global-centered-cursor-mode)

  :config

  ;; Make the end of the file recentered.
  (setq ccm-recenter-at-end-of-file t)

  :blackout " ⊖")

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

  (set-leader-keys! "jc" #'goto-last-change))

;; Package `mwim' stands for "Move Where I Mean".  It provides commands to
;; switch between various positions on the current line (particularly, to move
;; to the beginning/end of code, line or comment).
(use-package! mwim
  :bind (("C-a" . #'mwim-beginning-of-code-or-line)
         ("C-e" . #'mwim-end-of-line-or-code)
         ;; Not really using `forward-sentence' and `backward-sentence'.
         ("M-a" . #'mwim-beginning)
         ("M-e" . #'mwim-end)))

;;;; Highlighting

;; Allow to disable font colouring when needed.
(set-leader-keys!
  "thf" #'font-lock-mode
  "thF" #'global-font-lock-mode)

;; Feature `hl-line' provides minor mode to ;; highlight, on a suitable
;; terminal, the line on which point is. The global mode highlights the current
;; line in the selected window only (except when the minibuffer window is
;; selected). The local mode is sticky - it highlights the line about the
;; buffer's point even if the buffer's window is not selected.
(use-feature! hl-line
  :demand t
  :config

  (set-leader-keys!
    "thl" #'hl-line-mode
    "thL" #'global-hl-line-mode)

  (global-hl-line-mode +1))

;; Package `column-enforce-mode' highlights text that extends beyond a column
;; limit set by various modes.
(use-package! column-enforce-mode
  :init

  (defadvice! my--set-fill-column (arg)
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
    "t8" #'column-enforce-mode
    "t*" #'global-column-enforce-mode)

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

  (set-leader-keys! "thi" #'highlight-indent-guides-mode)

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

  (set-leader-keys! "thn" #'highlight-numbers-mode)

  :hook (prog-mode-hook . highlight-numbers-mode))

;; Package `highlight-parentheses' highlights surrounding parentheses in Emacs.
(use-package! highlight-parentheses
  :init

  (set-leader-keys!
    "thp" #'highlight-parentheses-mode
    "thP" #'global-highlight-parentheses-mode)

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

  (declare-prefix! "st" "todo")
  (set-leader-keys!
    "it"  #'hl-todo-insert
    "stn" #'hl-todo-next
    "sto" #'hl-todo-occur
    "stp" #'hl-todo-previous
    "tht" #'hl-todo-mode
    "thT" #'global-hl-todo-mode)

  (global-hl-todo-mode +1))

;; Package `rainbow-delimiters' is a "rainbow parentheses"-like mode which
;; highlights parentheses, brackets, and braces according to their depth. Each
;; successive level is highlighted in a different color. This makes it easy to
;; spot matching delimiters, orient yourself in the code, and tell which
;; statements are at a given level.
(use-package! rainbow-delimiters
  :init

  (set-leader-keys! "thr" #'rainbow-delimiters-mode)

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
    "so" #'symbol-overlay
    "sO" #'symbol-overlay-remove-all))

;;;; Find and replace

;; Package `ctrlf' provides a replacement for `isearch' that is more similar to
;; the tried-and-true text search interfaces in other programs.
(use-package! ctrlf
  :commands ctrlf-mode
  :init

  (ctrlf-mode +1)

  :config

  ;; Switch literal/regexp default keybindings to regexp/fuzzy-regexp.
  (setq ctrlf-default-search-style 'regexp)
  (setq ctrlf-alternate-search-style 'fuzzy-regexp))

;; Package `deadgrep' is the fast, beautiful text search with the help of
;; ripgrep.
(use-package! deadgrep
  :commands deadgrep--arguments
  :bind ("<f5>" . #'deadgrep)
  :config

  (defadvice! my--deadgrep-arguments-patch (args)
    :filter-return #'deadgrep--arguments
    "Add additional flags to `deadgrep--arguments'."
    (push "--max-columns-preview" args)
    (push "--max-columns=150" args)
    (push "--follow" args)
    (push "--hidden" args)
    (push "--no-config" args)))

;; Package `visual-regexp' provides an alternate version of `query-replace'
;; which highlights matches and replacements as you type.
(use-package! visual-regexp
  :init

  (set-leader-keys! "vm" #'vr/mc-mark)
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

  ;; Use Emacs-style regular expressions by default, instead of Python-style.
  (setq vr/engine 'emacs)

  (defun vr/query-replace-literal ()
    "Do a literal query-replace using `visual-regexp'."
    (interactive)
    (let ((vr/engine 'emacs-plain))
      (call-interactively #'vr/query-replace))))

;; Package `wgrep' allows you to edit a grep buffer and apply those changes to
;; the file buffer interactively.
(use-package! wgrep
  :demand t
  :bind (:map grep-mode-map
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

  (declare-prefix! "Sa" "add word")

  (set-leader-keys!
    "Sab" #'add-word-to-dict-buffer
    "Sag" #'add-word-to-dict-global
    "Sas" #'add-word-to-dict-session
    "Sb"  #'flyspell-buffer
    "Sd"  #'ispell-change-dictionary
    "Sn"  #'flyspell-goto-next-error
    "Sr"  #'flyspell-region
    "tS"  #'spellchecking-mode)

  ;; Inhibit initial aspell start message.
  (advice-add #'ispell-init-process :around #'advice-silence-messages!)

  ;; Disable default keymap as its bindings conflict with others and we use
  ;; hydra anyway.
  (setq flyspell-mode-map (make-sparse-keymap))

  :hook ((text-mode-hook outline-mode-hook) . flyspell-mode)

  :config

  ;; Do not emit messages when checking words.
  (setq flyspell-issue-message-flag nil)

  ;; Slightly change aspell behaviour.
  (setq ispell-extra-args '("--sug-mode=ultra"
                            "--lang=en_US"
                            "--run-together"))

  :blackout " Ⓢ")

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

  (declare-prefix! "S." "spellcheck")

  (set-leader-keys!
    "Sc" #'flyspell-correct-wrapper
    "Ss" #'flyspell-correct-at-point
    "S." #'hydra-flyspell/body))

;; Package `powerthesaurus' is an integration with powerthesaurus.org. It helps
;; to look up a word in powerthesaurus and either replace or insert selected
;; option in the buffer.
(use-package! powerthesaurus
  :init

  (set-leader-keys!
    "St" #'powerthesaurus-lookup-word-dwim))

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
  (declare-prefix! "kc" "counter")
  (declare-prefix! "ke" "edit")
  (declare-prefix! "kr" "ring")
  (set-leader-keys!
    "kca" #'kmacro-add-counter
    "kcc" #'kmacro-insert-counter
    "kcC" #'kmacro-set-counter
    "kcf" #'kmacro-set-format
    "keb" #'kmacro-bind-to-key
    "kee" #'kmacro-edit-macro-repeat
    "kel" #'kmacro-edit-lossage
    "ken" #'kmacro-name-last-macro
    "ker" #'kmacro-to-register
    "kes" #'kmacro-step-edit-macro
    "krd" #'kmacro-delete-ring-head
    "krl" #'kmacro-call-ring-2nd-repeat
    "krL" #'kmacro-view-ring-2nd
    "krn" #'kmacro-cycle-ring-next
    "krp" #'kmacro-cycle-ring-previous
    "krs" #'kmacro-swap-ring
    "kk"  #'kmacro-start-macro-or-insert-counter
    "kK"  #'kmacro-end-or-call-macro
    "kv"  #'kmacro-view-macro-repeat))

;;; Electricity: automatic things
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
    "tr" #'auto-revert-mode
    "tR" #'global-auto-revert-mode)

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

  :blackout (auto-revert-mode . " Ⓡ"))

;;;; Automatic delimiter pairing

;; Package `smartparens' provides an API for manipulating paired delimiters of
;; many different types, as well as interactive commands and key bindings for
;; operating on paired delimiters at the s-expression level. It provides a
;; Paredit compatibility layer.
(use-package! smartparens
  :demand t
  :bind (;; Use it to change parenthesis to another type.
         "M-=" . #'sp-rewrap-sexp)
  :config

  (set-leader-keys!
    "js" #'sp-split-sexp
    "jn" #'sp-newline
    "tp" #'smartparens-mode
    "tP" #'smartparens-global-mode
    "tq" #'smartparens-strict-mode
    "tQ" #'smartparens-global-strict-mode)

  ;; Load the default pair definitions for Smartparens.
  (require 'smartparens-config)

  ;; Load new SublimeText-like smartparens config that does not insert an
  ;; autopair when the next symbol is a word constituent.
  (require 'sp-sublimetext-like)

  ;; Extend SublimeText-like config to "" and ''.
  (let ((when '(sp-point-not-before-word))
        (actions '(insert wrap autoskip navigate)))
    (sp-pair "\"" "\"" :when when :actions actions)
    (sp-pair "'"  "'"  :when when :actions actions))

  ;; Enable Smartparens functionality in all buffers.
  (smartparens-global-mode +1)

  ;; Highlight matching delimiters.
  (show-smartparens-global-mode +1)

  ;; Prevent all transient highlighting of inserted pairs.
  (setq sp-highlight-pair-overlay nil)
  (setq sp-highlight-wrap-overlay nil)
  (setq sp-highlight-wrap-tag-overlay nil)

  ;; Don't disable autoskip when point moves backwards. This lets you open a
  ;; sexp, type some things, delete some things, etc., and then type over the
  ;; closing delimiter as long as you didn't leave the sexp entirely.
  (setq sp-cancel-autoskip-on-backward-movement nil)

  ;; Make C-k kill the sexp following point in Lisp modes, instead of just the
  ;; current line.
  (bind-key [remap kill-line] #'sp-kill-hybrid-sexp smartparens-mode-map
            (apply #'derived-mode-p sp-lisp-modes))

  ;; Quiet some silly messages.
  (dolist (key '(:unmatched-expression :no-matching-tag))
    (setf (cdr (assq key sp-message-alist)) nil))

  :blackout " Ⓟ")

;; Package `embrace' modifies pairs based on `expand-region'. It's heavily
;; inspired by `evil-surround' but instead of using `evil' and its text objects,
;; this package relies on another package `expand-region'.
(use-package! embrace
  :bind ("M-+" . #'embrace-commander)
  :config

  (defun embrace-buffer-p ()
    "Check whether the visible buffer is a part of `embrace'."
    (and (get-buffer "*embrace-help*")
         (get-buffer-window "*embrace-help*" 'visible)))
  (push 'embrace-buffer-p golden-ratio-inhibit-functions))

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
    "ic" #'aya-create
    "ie" #'aya-expand
    "io" #'aya-open-line
    "iw" #'aya-persist-snippet)

  :config

  ;; Save auto snippets in persistent location outside `user-emacs-directory'.
  (setq aya-persist-snippets-dir (expand-file-name "snippets" my-data-dir)))

;; Package `yasnippet' allows the expansion of user-defined abbreviations into
;; fillable templates. The only reason we have it here is because it gets pulled
;; in by LSP, and we need to unbreak some stuff.
(use-package! yasnippet
  :functions yas-reload-all
  :defer 1
  :commands (yas-next-field
             yas-prev-field)
  :init

  (set-leader-keys!
    "ip" #'yas-prev-field
    "in" #'yas-next-field
    "ty" #'yas-minor-mode
    "tY" #'yas-global-mode)

  ;; Disable default keymap with TAB expansion.
  (setq yas-minor-mode-map (make-sparse-keymap))

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
  (setq yas-triggers-in-field t)

  ;; Insert region contents when selected as snippet's $0 field.
  (setq yas-wrap-around-region t)

  ;; Save yasnippets in persistent location outside `user-emacs-directory'.
  (let ((yas-snippet-dir (expand-file-name "snippets" my-data-dir)))
    (unless (file-directory-p yas-snippet-dir)
      (make-directory yas-snippet-dir t))
    (setq yas-snippet-dirs (list yas-snippet-dir)))

  ;; Enale snippets everywhere
  (yas-global-mode +1)

  :blackout (yas-minor-mode . " Ⓨ"))

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

;; Package `consult' implements a set of commands which use `completing-read' to
;; select from a list of candidates. Most provided commands follow the naming
;; scheme `consult-<thing>'. Some commands are drop-in replacements for existing
;; functions, e.g., `consult-apropos' or the enhanced buffer switcher
;; `consult-buffer.' Other commands provide additional functionality, e.g.,
;; `consult-line', to search for a line. Many commands support candidate
;; preview. If a candidate is selected in the completion view, the buffer shows
;; the candidate immediately.
(use-package! consult
  :init

  (defun consult-git-ls (&optional dir)
    "Search for regexp with git-ls-files in DIR."
    (interactive)
    (let ((consult-find-command '("git" "ls-files" "--full-path" "--")))
      (call-interactively #'consult-find)))

  (defun consult-line-symbol-at-point ()
    "Search for a matching line starting search with symbol at
point. "
    (interactive)
    (consult-line (thing-at-point 'symbol)))

  (defvar-local consult-toggle-preview-orig nil)

  (defun consult-toggle-preview ()
    "Enable or disable preview within `consult' session."
    (interactive)
    (if consult-toggle-preview-orig
        (setq consult--preview-function consult-toggle-preview-orig
              consult-toggle-preview-orig nil)
      (setq consult-toggle-preview-orig consult--preview-function
            consult--preview-function #'ignore)))

  (set-leader-keys!
    "/"  #'consult-ripgrep
    "am" #'consult-man'
    "bb" #'consult-buffer
    "bB" #'consult-buffer-other-window
    "bf" #'consult-focus-lines
    "bk" #'consult-keep-lines
    "Fb" #'consult-buffer-other-frame
    "fb" #'consult-bookmark
    "fF" #'consult-find
    "fO" #'consult-file-externally
    "fr" #'consult-recent-file
    "g/" #'consult-git-grep
    "gf" #'consult-git-ls
    "ji" #'consult-imenu
    "km" #'consult-kmacro
    "rl" #'consult-register-load
    "rr" #'consult-register
    "rs" #'consult-register-store
    "ry" #'consult-yank-replace
    "ss" #'consult-line
    "sS" #'consult-multi-occur
    "tT" #'consult-theme)

  (with-eval-after-load 'selectrum
    (bind-key "M-P" #'consult-toggle-preview selectrum-minibuffer-map))

  :bind (([remap goto-line] . #'consult-goto-line)
         ("M-g i"           . #'consult-imenu)
         ("M-g M-i"         . #'consult-imenu)
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
         ([remap yank-pop]  . #'consult-yank-replace)
         ("M-s l"           . #'consult-line)
         ("M-s M-l"         . #'consult-line)
         ("M-s ;"           . #'consult-line-symbol-at-point)
         ("M-s M-;"         . #'consult-line-symbol-at-point)
         ("M-s m"           . #'consult-multi-occur)
         ("M-s M-m"         . #'consult-multi-occur))

  :config

  ;; Enable preview for some commands with `C-o'.
  (dolist (cmd '(consult-bookmark consult-recent-file consult-ripgrep))
    (setf (alist-get cmd consult-config) `(:preview-key ,(kbd "C-o"))))

  ;; Use fd instead of find.
  (setq consult-find-command "fd --color=never --full-path ARG OPTS")

  ;; Narrow and widen selection with "[".
  (setq consult-narrow-key (kbd "["))

  ;; Configure the register formatting. This improves the register preview
  ;; for `consult-register', `consult-register-load', `consult-register-store'
  ;; and the Emacs built-ins.
  (setq register-preview-delay 0)
  (setq register-preview-function #'consult-register-format)

  ;; Tweak the register preview window. This adds stripes, sorting and hides the
  ;; mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Configure a function which returns the project root directory
  (with-eval-after-load 'projectile
    (setq consult-project-root-function #'projectile-project-root)))

;; Package `embark' provides a sort of right-click contextual menu for Emacs,
;; accessed through the `embark-act' command (which you should bind to a
;; convenient key), offering you relevant actions to use on a target determined
;; by the context.
(use-package! embark
  :bind ("M-s a" . #'embark-act)

  :config

  (defun my-embark-action-indicator (map _target)
    "Use `which-key' like a key menu prompt."
    (which-key--show-keymap "Embark" map nil nil 'no-paging)
    #'which-key--hide-popup-ignore-command)

  (setq embark-action-indicator #'my-embark-action-indicator)
  (setq embark-become-indicator #'my-embark-action-indicator))

;; Package `embark-consult' provides integration between Embark and Consult.
(use-package! embark-consult
  :demand t
  :after (embark consult))

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

  ;; Prefer richer, more heavy, annotations over the lighter default variant.
  (setq marginalia-annotators '(marginalia-annotators-heavy
                                marginalia-annotators-light
                                nil))

  (marginalia-mode +1)

  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle)))

;; Package `orderless' provides an orderless completion style that divides the
;; pattern into components (space-separated by default), and matches candidates
;; that match all of the components in any order.
(use-package! orderless
  :demand t
  :config

  ;; `completion-styles' filter and highlight in a single step, the approach of
  ;; Selectrum to only highlight the actually displayed candidates is more
  ;; efficient.
  (setq selectrum-refine-candidates-function #'orderless-filter)
  (setq selectrum-highlight-candidates-function #'orderless-highlight-matches)

  ;; Rely on `orderless' solely for completions.
  (setq completion-styles '(orderless))
  (setq completion-category-defaults nil)

  ;; Change initialism to strict initialism and add prefixes (partial completion
  ;; from Emacs).
  (setq orderless-matching-styles '(orderless-regexp
                                    orderless-strict-initialism
                                    orderless-prefixes))

  (defun orderless-flex-if-twiddle (pattern _index _total)
    "Return `orderless-flex' if pattern starts/ends with \"~\"."
    (cond ((string-suffix-p "~" pattern)
           `(orderless-flex . ,(substring pattern 0 -1)))
          ((string-prefix-p "~" pattern)
           `(orderless-flex . ,(substring pattern 1)))))

  ;; Enable fuzzy matching when the pattern starts or ends with "~".
  (setq orderless-style-dispatchers '(orderless-flex-if-twiddle))

  ;; Extend separator from space to spaces.
  (setq orderless-component-separator "[ ]+"))

;; Package `prescient' is a library for intelligent sorting and filtering in
;; various contexts.
(use-package! prescient
  :config

  ;; Remember usage statistics across Emacs sessions.
  (prescient-persist-mode +1)

  ;; The default setting seem a little too low.
  (setq prescient-history-length 1000)

  ;; Do not litter `user-emacs-directory' with persistent prescient file.
  (setq prescient-save-file (expand-file-name
                             "prescient-save.el"
                             my-cache-dir)))

;; Package `selectrum' is an incremental completion and narrowing framework.
;; Like Ivy and Helm, which it improves on, Selectrum provides a user interface
;; for choosing from a list of options by typing a query to narrow the list, and
;; then selecting one of the remaining candidates. This offers a significant
;; improvement over the default Emacs interface for candidate selection.
(use-package! selectrum
  :init

  ;; This doesn't actually load Selectrum.
  (selectrum-mode +1)

  :bind ((:map selectrum-minibuffer-map
               ("<prior>"    . #'selectrum-previous-page)
               ("<next> "    . #'selectrum-next-page)
               ;; Use <backtab> to go up with `find-file'.
               ("<backtab>"  . #'backward-kill-sexp)
               ("S-TAB"      . #'backward-kill-sexp))
         (:map minibuffer-local-map
               ("M-s"        . nil)))

  :config

  ;; Don't show anything when displaying count information before the prompt.
  (setq selectrum-count-style nil))

;; Package `selectrum-prescient' provides intelligent sorting and filtering for
;; candidates in Selectrum menus.
(use-package! selectrum-prescient
  :demand t
  :after selectrum
  :bind (:map selectrum-prescient-toggle-map
              ;; Unbind these keys as prescient is only used for sorting.
              ("'" . nil)
              ("a" . nil)
              ("c" . nil)
              ("f" . nil)
              ("i" . nil)
              ("l" . nil)
              ("p" . nil)
              ("P" . nil)
              ("r" . nil))

  :config

  ;; Disable the filtering functionalities in favour of `orderless.
  (setq selectrum-prescient-enable-filtering nil)

  (selectrum-prescient-mode +1))

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
  (setq dumb-jump-prefer-searcher 'rg))

;; Package `xref' provides a somewhat generic infrastructure for cross
;; referencing commands, in particular "find-definition". Some part of the
;; functionality must be implemented in a language dependent way and that's done
;; by defining an xref backend.
(use-package! xref
  :init

  (set-leader-keys!
    "F." #'xref-find-definitions-other-frame
    "w." #'xref-find-definitions-other-window)

  :config

  ;; Prompt if no identifier is at point. This allows `dumb-jump' to use
  ;; `xref-find-references.
  (setq xref-prompt-for-identifier nil)

  ;; Use ripgrep for regexp search inside files.
  (setq xref-search-program 'ripgrep))

;; Feature `consult-xref' provides Xref integration for Consult.
(use-feature! consult-xref
  :demand t
  :after (consult xref)
  :config

  ;; Use `consult' completion with preview.
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref))

;;;; Display contextual metadata

;; Feature `eldoc' provides a minor mode (enabled by default in Emacs 25) which
;; allows function signatures or other metadata to be displayed in the echo
;; area.
(use-feature! eldoc
  :hook (eval-expression-minibuffer-setup-hook . eldoc-mode)

  :blackout t)

;;;; Autocompletion

;; Package `company' provides an in-buffer autocompletion framework. It allows
;; for packages to define backends that supply completion candidates, as well as
;; optional documentation and source code. Then Company allows for multiple
;; frontends to display the candidates, such as a tooltip menu.
(use-package! company
  :defines (company-dabbrev-downcase
            company-dabbrev-ignore-case
            company-dabbrev-other-buffers)
  :functions company-mode-hook
  :defer 0.5
  :init

  (set-leader-keys!
    "ta" #'company-mode
    "tA" #'global-company-mode)

  :bind ((:map company-mode-map
               ("M-\\" . #'company-complete)
               ("C-\\" . #'company-begin-backend))
         (:map company-active-map
               ("M-b"  . #'company-other-backend)))

  :config

  (dolist (face '(company-tooltip-common company-tooltip-common-selection))
    (set-face-attribute face nil :weight 'bold))

  ;; Make completion with no delay.
  (setq company-idle-delay 0)

  ;; Make completions display when you have only typed one character, instead of
  ;; three.
  (setq company-minimum-prefix-length 1)

  ;; Always display the entire suggestion list onscreen, placing it above the
  ;; cursor if necessary.
  (setq company-tooltip-minimum company-tooltip-limit)

  ;; Values for `company-backends' used everywhere. Each major-mode should
  ;; modify this list to suit its needs.
  (setq company-backends '(company-capf
                           company-files
                           (company-dabbrev-code company-keywords)
                           company-dabbrev))

  ;; Don't display metadata in the echo area as this conflicts with ElDoc.
  (setq company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                            company-preview-if-just-one-frontend))

  ;; Show quick-reference numbers in the tooltip. Select a completion with M-1
  ;; through M-0.
  (setq company-show-numbers t)

  ;; Dismiss the completions menu with non-matching input.
  (setq company-require-match nil)

  ;; Only search the current buffer to get suggestions for `company-dabbrev'
  ;; (a backend that creates suggestions from text found in your buffers). This
  ;; prevents Company from causing lag once you have a lot of buffers open.
  (setq company-dabbrev-other-buffers nil)

  ;; Make the `company-dabbrev' backend fully case-sensitive, to improve the UX
  ;; when working with domain-specific words that have particular casing.
  (setq company-dabbrev-ignore-case nil
        company-dabbrev-downcase nil)

  ;; When candidates in the autocompletion tooltip have additional metadata,
  ;; like a type signature, align that information to the right-hand side.
  (setq company-tooltip-align-annotations t)

  (defvar-local my--company-buffer-modified-counter nil
    "Last return value of `buffer-chars-modified-tick'.
Used to ensure that Company only initiates a completion when the
buffer is modified.")

  (defadvice! my--company-should-begin ()
    :override #'company--should-begin
    "Make Company trigger a completion when the buffer is modified.
This is in contrast to the default behavior, which is to trigger
a completion when one of a whitelisted set of commands is used.
One specific improvement this brings about is that you get
completions automatically when backspacing into a symbol."
    (let ((tick (buffer-chars-modified-tick)))
      (unless (equal tick my--company-buffer-modified-counter)
        ;; Only trigger completion if previous counter value was non-nil (i.e.,
        ;; don't trigger completion just as we're jumping to a buffer for the
        ;; first time).
        (prog1 (and my--company-buffer-modified-counter
                    (not (and (symbolp this-command)
                              (string-match-p
                               "^\\(company-\\|undo-\\|undo$\\)"
                               (symbol-name this-command)))))
          (setq my--company-buffer-modified-counter tick)))))

  (defadvice! my--company-should-continue-update-buffer-modified-counter ()
    :after #'company--should-continue
    "Make sure `my--company-buffer-modified-counter' is up to date.
If we don't do this on `company--should-continue' as well as
`company--should-begin', then we may end up in a situation where
autocomplete triggers when it shouldn't. Specifically suppose we
delete a char from a symbol, triggering autocompletion, then type
it back, but there is more than one candidate so the menu stays
onscreen. Without this advice, saving the buffer will cause the
menu to disappear and then come back after `company-idle-delay'."
    (setq my--company-buffer-modified-counter
          (buffer-chars-modified-tick)))

  (global-company-mode +1)

  :blackout " Ⓐ")

;; Package `company-prescient' provides intelligent sorting for candidates in
;; Company completions. Note that it does not change the filtering behavior of
;; Company.
(use-package! company-prescient
  :demand t
  :after company
  :config

  ;; Use `prescient' for Company menus.
  (company-prescient-mode +1))

;; Package `company-posframe' is a Company extension which lets Company use
;; child frame as its candidate menu.
(use-package! company-posframe
  :commands (company-posframe-quickhelp-toggle)
  :init

  (after-display-graphic-init!
    (with-eval-after-load 'company
      (require 'company-posframe)
      (add-hook #'company-mode-hook #'company-posframe-mode)
      (bind-keys :map company-posframe-active-map
                 ("M-h" . company-posframe-quickhelp-toggle))))

  :config

  ;; Do not display metadata (e.g. signature) of the selection below the visible
  ;; candidates.
  (setq company-posframe-show-metadata nil)

  ;; Trigger popup manually with `company-posframe-quickhelp-toggle'.
  (setq company-posframe-quickhelp-delay nil)

  :blackout t)

;;;; Syntax checking and code linting

;; Package `flycheck' provides a framework for in-buffer error and warning
;; highlighting.
(use-package! flycheck
  :defer 1
  :commands (flycheck-buffer
             flycheck-clear
             flycheck-compile
             flycheck-copy-errors-as-kill
             flycheck-describe-checker
             flycheck-disable-checker
             flycheck-explain-error-at-point
             flycheck-list-errors
             flycheck-next-error
             flycheck-previous-error
             flycheck-select-checker
             flycheck-verify-setup)
  :init

  (set-leader-keys!
    "e?" #'flycheck-describe-checker
    "eb" #'flycheck-buffer
    "ec" #'flycheck-compile
    "eC" #'flycheck-clear
    "eh" #'display-local-help
    "el" #'flycheck-list-errors
    "en" #'flycheck-next-error
    "ep" #'flycheck-previous-error
    "es" #'flycheck-select-checker
    "ev" #'flycheck-verify-setup
    "ew" #'flycheck-copy-errors-as-kill
    "ex" #'flycheck-disable-checker
    "ts" #'flycheck-mode)

  :hook ((flycheck-error-list-mode-hook . hide-mode-line-mode))

  :config

  ;; Rerunning checks on every newline is a bit excessive.
  (delq 'new-line flycheck-check-syntax-automatically)

  ;; Increase the idle time after Flycheck will start a syntax check as 0.5s is
  ;; a bit too naggy.
  (setq flycheck-idle-change-delay 1.0)

  ;; Decrease the delay before displaying errors at point.
  (setq flycheck-display-errors-delay 0.25)

  ;; Display error messages only if there is no error list visible.
  (setq flycheck-display-errors-function
    #'flycheck-display-error-messages-unless-error-list)

  ;; For the above functionality, check syntax in a buffer that you switched to
  ;; only briefly. This allows "refreshing" the syntax check state for several
  ;; buffers quickly after e.g. changing a config file.
  (setq flycheck-buffer-switch-check-intermediate-buffers t)

  ;; Use the load-path of the current Emacs session during syntax checking.
  (setq flycheck-emacs-lisp-load-path 'inherit)

  :blackout " ⓢ")

;; Package `consult-flycheck' shows Flycheck errors, warnings, notifications
;; within consult buffer with live preview.
(use-package! consult-flycheck
  :init

  (set-leader-keys! "ee" #'consult-flycheck)

  :bind (("M-g e"   . #'consult-flycheck)
         ("M-g M-e" . #'consult-flycheck)))

(defun my--flycheck-popup-mode ()
  "Activate one of the Flycheck popups modes.
If available and in GUI Emacs activate command
`flycheck-posframe-mode'. Activate command `flycheck-inline-mode'
otherwise. Do nothing if function `lsp-ui-mode' is active and
function `lsp-ui-sideline-enable' is non-nil."
  (unless (and (bound-and-true-p lsp-ui-mode)
               (bound-and-true-p lsp-ui-sideline-enable))
    (if (display-graphic-p)
        (flycheck-posframe-mode +1)
      (flycheck-inline-mode +1))))

;; Package `flycheck-posframe' displays Flycheck errors using posframe.el.
(use-package! flycheck-posframe
  :hook (flycheck-mode-hook . my--flycheck-popup-mode)
  :config

  (set-face-attribute 'flycheck-posframe-warning-face nil :inherit 'warning)
  (set-face-attribute 'flycheck-posframe-error-face nil :inherit 'error)

  ;; Inhibit display popups if Flycheck error list is visible.
  (add-hook 'flycheck-posframe-inhibit-functions
    (lambda () (flycheck-get-error-list-window 'current-frame)))

  (with-eval-after-load 'company
    ;; Inhibit displaying popups if Company is active.
    (add-hook 'flycheck-posframe-inhibit-functions #'company--active-p)))

;; Package `flycheck-inline' provides an error display function to show Flycheck
;; errors inline, directly below their location in the buffer.
(use-package! flycheck-inline
  :hook (flycheck-mode-hook . my--flycheck-popup-mode)
  :config

  (defadvice! my--flycheck-inline-inhibit-with-errors-list (&rest _)
    :before-while #'flycheck-inline-display-phantom
    "Inhibit displaying Flycheck error messages when error list is visible."
    (not (flycheck-get-error-list-window 'current-frame)))

  (with-eval-after-load 'company
    (defadvice! my--flycheck-inline-inhibit-with-company (&rest _)
      :before-while #'flycheck-inline-display-phantom
      "Inhibit displaying Flycheck error messages when Company is active."
      (not (bound-and-true-p company-backend)))))

;;;; Online documentation

;; Package `devdocs-browser' allows to browse API documentations provided by
;; devdocs.io inside Emacs using EWW, with improved formatting, including
;; highlighted code blocks and extra commands like "jump to other sections" or
;; "open in default browser". You can manage (install, upgrade, uninstall, etc.)
;; docsets and optionally download full content for offline usage.
(use-package! devdocs-browser
  :init

  (declare-prefix! "do" "offline")
  (declare-prefix! "du" "update")

  (set-leader-keys!
    "dd" #'devdocs-browser-open
    "dD" #'devdocs-browser-open-in
    "di" #'devdocs-browser-install-doc
    "dr" #'devdocs-browser-uninstall-doc

    "duu" #'devdocs-browser-update-docs
    "dug" #'devdocs-browser-upgrade-doc
    "duG" #'devdocs-browser-upgrade-all-docs)

  :config

  (set-leader-keys!
    "dod" #'devdocs-browser-download-offline-data
    "dor" #'devdocs-browser-remove-offline-data)

  ;; Do not litter `user-emacs-directory' with offline data.
  (setq devdocs-browser-cache-directory my-cache-dir))

;;;; Diff/Merge handling

;; Feature `ediff' is a comprehensive visual interface to diff & patch.
(use-feature! ediff
  :init

  (declare-prefix! "Db"  "buffers")
  (declare-prefix! "Dd"  "directories")
  (declare-prefix! "Df"  "files")
  (declare-prefix! "Dm"  "merge")
  (declare-prefix! "Dmb" "buffers")
  (declare-prefix! "Dmd" "directories")
  (declare-prefix! "Dmf" "files")
  (declare-prefix! "Dmr" "revisions")
  (declare-prefix! "Dr"  "regions")
  (declare-prefix! "Dw"  "windows")

  (set-leader-keys!
    "Db3"  #'ediff-buffers3
    "Dbb"  #'ediff-buffers
    "DbB"  #'ediff-backup
    "Dbp"  #'ediff-patch-buffer
    "Dd3"  #'ediff-directories3
    "Ddd"  #'ediff-directories
    "Ddr"  #'ediff-directory-revisions
    "Df3"  #'ediff-files3
    "Dff"  #'ediff-files
    "Dfp"  #'ediff-patch-file
    "Dfv"  #'ediff-revision
    "Dmb3" #'ediff-merge-buffers-with-ancestor
    "Dmbb" #'ediff-merge-buffers
    "Dmd3" #'ediff-merge-directories-with-ancestor
    "Dmdd" #'ediff-merge-directories
    "Dmf3" #'ediff-merge-files-with-ancestor
    "Dmff" #'ediff-merge-files
    "Dmr3" #'ediff-merge-revisions-with-ancestor
    "Dmrr" #'ediff-merge-revisions
    "Drl"  #'ediff-regions-linewise
    "Drw"  #'ediff-regions-wordwise
    "Dwl"  #'ediff-windows-linewise
    "Dww"  #'ediff-windows-wordwise
    "Ds"   #'ediff-show-registry
    "Dh"   #'ediff-documentation)

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

;;;; Language servers

;; Package `lsp-mode' is an Emacs client for the Language Server Protocol
;; <https://langserver.org/>. It is where we get all of our information for
;; completions, definition location, documentation, and so on.
(use-package! lsp-mode
  :defer 3
  :init

  (defmacro lsp-define-extension!
      (prefix suffix arglist request docstring &optional extra)
    "Define functions that use non-standard LSP extension.
Two functions will be defined, one using `lsp-find-custom' (its
name will be PREFIX-SUFFIX) and another one using
`lsp-ui-peek-find-custom' (its name will be
PREFIX-ui-peek-SUFFIX). Each function can use a number prefix.
ARGLIST is as in `defun'. REQUEST is a non-standard LSP request
sent to the server. DOCSTRING is as in `defun' while EXTRA is a
list of additional parameters sent with this request."
    (declare (indent 3)
             (doc-string 5))
    (unless (stringp docstring)
      (error "LSP extension `%S' not documented'" request))
    `(progn
       (defun ,(intern (format "%s-%s" prefix suffix)) ,arglist
         ,(format "%s" docstring)
         (interactive "p")
         (lsp-find-custom ,request ,extra))
       (defun ,(intern (format "%s-ui-peek-%s" prefix suffix)) ,arglist
         ,(format "%s" docstring)
         (interactive "p")
         (lsp-ui-peek-find-custom ,request ,extra))))

  (defhook! my--lsp-mode-setup ()
    lsp-after-initialize-hook
    "Set custom settings after initialising LSP server."
    ;; Declare prefixes common for all LSP servers.
    (mapc (lambda (prefix) (apply #'declare-prefix-for-mode! major-mode prefix))
          '(("m="  "format")
            ("ma"  "code actions")
            ("mf"  "folders")
            ("mg"  "peek")
            ("mgh" "hierarchy")
            ("mgm" "members")
            ("mgR" "references")
            ("mG"  "goto")
            ("mGh" "hierarchy")
            ("mGm" "members")
            ("mGR" "references")
            ("mh"  "help")
            ("mr"  "refactor")
            ("ms"  "session")
            ("mt"  "toggle"))))

  ;; Disable default keymap, we have our own.
  (setq lsp-mode-map (make-sparse-keymap))

  :config

  (set-leader-keys-for-minor-mode! 'lsp-mode
    ;; Format
    "==" #'lsp-format-buffer
    "=r" #'lsp-format-region

    ;; Code actions
    "aa" #'lsp-execute-code-action
    "ah" #'lsp-document-highlight
    "al" #'lsp-avy-lens

    ;; Folders
    "fa" #'lsp-workspace-folders-add
    "fb" #'lsp-workspace-blacklist-remove
    "fr" #'lsp-workspace-folders-remove
    "fs" #'lsp-workspace-folders-open

    ;; Peek
    "gt" #'lsp-find-type-definition

    ;; Goto
    "Gd" #'lsp-find-declaration
    "Gg" #'lsp-find-definition
    "Gi" #'lsp-find-implementation
    "Gr" #'lsp-find-references
    "Gt" #'lsp-find-type-definition

    ;; Help
    "hh" #'lsp-describe-thing-at-point
    "hs" #'lsp-signature-activate

    ;; Refactor
    "ro" #'lsp-organize-imports
    "rr" #'lsp-rename

    ;; Session
    "sd" #'lsp-describe-session
    "sD" #'lsp-disconnect
    "sq" #'lsp-workspace-shutdown
    "sr" #'lsp-workspace-restart
    "ss" #'lsp

    ;; Toggle
    "ta" #'lsp-modeline-code-actions-mode
    "tb" #'lsp-headerline-breadcrumb-mode
    "tD" #'lsp-modeline-diagnostics-mode
    "tf" #'lsp-toggle-on-type-formatting
    "th" #'lsp-toggle-symbol-highlight
    "tl" #'lsp-lens-mode
    "tL" #'lsp-toggle-trace-io
    "tS" #'lsp-toggle-signature-auto-activate)

  ;; Do not litter `user-emacs-directory' with persistent LSP files.
  (setq lsp-session-file (expand-file-name "lsp-session-v1" my-cache-dir))

  ;; Do not auto-execute single action, let us see what that action is.
  (setq lsp-auto-execute-action nil)

  ;; Do not wait such long time (10s) before deciding a server timed out.
  (setq lsp-response-timeout 5)

  ;; Ignore watching files in the workspace if the server has requested that.
  (setq lsp-enable-file-watchers nil)

  ;; Enable experimental semantic highlighting support.
  (setq lsp-semantic-tokens-enable t)

  ;; Inhibit automatic edits suggested by the language server before saving a
  ;; document.
  (setq lsp-before-save-edits nil)

  ;; Disable features that have great potential to be slow.
  (setq lsp-enable-folding nil
        lsp-enable-text-document-color nil)

  ;; Reduce unexpected modifications to code
  (setq lsp-enable-on-type-formatting nil)

  ;; List of the clients to be automatically required when launching `lsp'.
  ;; Default list is rather large which leads to requiring a lot of unnecessary
  ;; files.
  (setq lsp-client-packages '(ccls))

  ;; Increase the amount of data which Emacs reads from the process. The Emacs
  ;; default is too low (4k) considering that the some of the language server
  ;; responses are in 800k - 3M range.
  (setq read-process-output-max (* 1024 1024))

  ;; Feature `lsp-completion' configures completion-related functionality.
  (use-feature! lsp-completion
    :init

    ;; Let me configure completion provider (`company-capf') by myself.
    (setq lsp-completion-provider :none))

  ;; Feature `lsp-dired' provides integration with Dired file explorer.
  ;; Lsp-Mode will show which files/folders contain errors/warnings/hints.
  (use-feature! lsp-dired
    :init

    (lsp-dired-mode +1))

  ;; Feature `lsp-iedit' provides features that allow starting Iedit on various
  ;; different lsp-based, semantic units.
  (use-feature! lsp-iedit
    :init

    (set-leader-keys-for-minor-mode! 'lsp-mode
      "re" #'lsp-iedit-highlights))

  ;; Feature `lsp-clangd' brings implementation of clangd client for Emacs.
  (use-feature! lsp-clangd
    :config

    (defun lsp-clangd-find-other-file-other-window ()
      "Switch between the corresponding C/C++ source and header file in
a new window."
      (interactive)
      (lsp-clangd-find-other-file t))

    (dolist (mode '(c-mode c++-mode))
      (set-leader-keys-for-major-mode! mode
        "ga" #'lsp-clangd-find-other-file
        "gA" #'lsp-clangd-find-other-file-other-window
        "Ga" #'lsp-clangd-find-other-file
        "GA" #'lsp-clangd-find-other-file-other-window))

    ;; Set some basic logging for debugging purpose, change completion style to
    ;; be more detailed and remove automatic header insertion.
    (setq lsp-clients-clangd-args (list
                                   "-log=info"
                                   "--completion-style=detailed"
                                   "--header-insertion=never"))))

;; Package `lsp-ui' provides a pretty UI for showing diagnostic messages from
;; LSP in the buffer using overlays. It's configured automatically by
;; `lsp-mode'.
(use-package! lsp-ui
  :demand t
  :after lsp-mode
  :bind ((:map lsp-ui-mode-map
               ;; Remap `xref' to use `lsp-ui-peek' feature.
               ([remap xref-find-definitions] . #'lsp-ui-peek-find-definitions)
               ([remap xref-find-references]  . #'lsp-ui-peek-find-references)
               ("C-c z"                       . #'lsp-ui-doc-focus-frame)))

  :config

  (set-leader-keys-for-minor-mode! 'lsp-mode
    ;; Peek
    "gg" #'lsp-ui-peek-find-definitions
    "gi" #'lsp-ui-peek-find-implementation
    "gM" #'lsp-ui-imenu
    "gr" #'lsp-ui-peek-find-references

    ;; Help
    "hg" #'lsp-ui-doc-glance

    ;; Toggle
    "td" #'lsp-ui-doc-mode
    "ts" #'lsp-ui-sideline-mode)

  ;; Update sideline information when changing current line, not when moving
  ;; cursor
  (setq lsp-ui-sideline-update-mode 'line)

  ;; Decrease the maximum width of doc frame by 33%.
  (setq lsp-ui-doc-max-width 100)

  ;; Setting this to nil will make Lsp Ui windows not disappear on mouse
  ;; movement
  (setq lsp-ui-doc-show-with-mouse nil)

  ;; Always fontify chunks of code when peeking.
  (setq lsp-ui-peek-fontify 'always)

  ;; Show the peek view even if there is only 1 cross reference.
  (setq lsp-ui-peek-always-show t))

;; Package `consult-lsp` provides alternative of the build-in lsp-mode
;; `xref-appropos` which provides as you type completion.
(use-package! consult-lsp
  :demand t
  :after (consult lsp-mode xref)
  :bind (:map lsp-mode-map
              ([remap xref-find-apropos] . #'consult-lsp-symbols))

  :config

  (set-leader-keys-for-minor-mode! 'lsp-mode
    "ge"  #'consult-lsp-diagnostics
    "gs"  #'consult-lsp-symbols
    "Ge"  #'consult-lsp-diagnostics
    "Gs"  #'consult-lsp-symbols)

  ;; Enable preview with `C-o'.
  (setf (alist-get 'consult-lsp-symbols consult-config)
        `(:preview-key ,(kbd "C-o"))))

;;; Language support
;;;; C, C++

;; Feature `cc-mode' provides major modes for C, C++.
(use-feature! cc-mode
  :init

  (defhook! my--cc-mode-setup ()
    c-mode-common-hook
    "Set custom settings for C/C++ mode."
    (setq-local company-backends '(company-capf
                                   company-files
                                   (company-dabbrev-code company-keywords)
                                   company-dabbrev))
    ;; Launch `lsp-mode'
    (lsp-deferred))

  (dolist (mode '(c-mode c++-mode))
    (declare-prefix-for-mode! mode "mg" "peek")
    (declare-prefix-for-mode! mode "mG" "goto")
    (set-leader-keys-for-major-mode! mode
      "ga" #'projectile-find-other-file
      "gA" #'projectile-find-other-file-other-window
      "Ga" #'projectile-find-other-file
      "GA" #'projectile-find-other-file-other-window))

  :config

  (defadvice! my--c-update-modeline-inhibit (&rest _)
    :override #'c-update-modeline
    "Unconditionally inhibit CC submode indicators in the mode lighter.")

  ;; Indentation for CC Mode
  (defconst my-cc-style
    '((c-recognize-knr-p . nil)
      (c-basic-offset . 2)
      (c-tab-always-indent . t)
      (c-comment-only-line-offset . 0)
      (comment-column . 40)
      (c-indent-comments-syntactically-p . t)
      (c-indent-comment-alist . ((other . (space . 1))))
      (c-hanging-braces-alist . ((defun-open before after)
                                 (defun-close before after)
                                 (class-open after)
                                 (class-close before)
                                 (inexpr-class-open after)
                                 (inexpr-class-close before)
                                 (namespace-open after)
                                 (namespace-close before after)
                                 (inline-open before after)
                                 (inline-close before after)
                                 (block-open after)
                                 (block-close . c-snug-do-while)
                                 (extern-lang-open after)
                                 (extern-lang-close before after)
                                 (statement-case-open after)
                                 (substatement-open after)))
      (c-hanging-colons-alist . ((case-label after)
                                 (label after)
                                 (access-label after)
                                 (member-init-intro)
                                 (inher-intro)))
      (c-hanging-semi&comma-criteria
       . (c-semi&comma-inside-parenlist
          c-semi&comma-no-newlines-before-nonblanks
          c-semi&comma-no-newlines-for-oneline-inliners))
      (c-cleanup-list . (brace-else-brace
                         brace-elseif-brace
                         brace-catch-brace
                         defun-close-semi
                         list-close-comma
                         scope-operator))
      (c-offsets-alist . ((inexpr-class . +)
                          (inexpr-statement . +)
                          (lambda-intro-cont . +)
                          (inlambda . c-lineup-inexpr-block)
                          (template-args-cont c-lineup-template-args +)
                          (incomposition . +)
                          (inmodule . +)
                          (innamespace . 0)
                          (inextern-lang . +)
                          (composition-close . 0)
                          (module-close . 0)
                          (namespace-close . 0)
                          (extern-lang-close . 0)
                          (composition-open . 0)
                          (module-open . 0)
                          (namespace-open . 0)
                          (extern-lang-open . 0)
                          (friend . 0)
                          (cpp-define-intro c-lineup-cpp-define +)
                          (cpp-macro-cont . +)
                          (cpp-macro . [0])
                          (inclass . +)
                          (stream-op . c-lineup-streamop)
                          (arglist-cont-nonempty c-lineup-gcc-asm-reg
                                                 c-lineup-arglist)
                          (arglist-cont c-lineup-gcc-asm-reg 0)
                          (comment-intro c-lineup-knr-region-comment
                                         c-lineup-comment)
                          (catch-clause . 0)
                          (else-clause . 0)
                          (do-while-closure . 0)
                          (access-label . -)
                          (case-label . 0)
                          (substatement . +)
                          (statement-case-intro . +)
                          (statement . 0)
                          (brace-entry-open . 0)
                          (brace-list-entry . c-lineup-under-anchor)
                          (brace-list-close . 0)
                          (block-close . 0)
                          (block-open . 0)
                          (inher-cont . c-lineup-multi-inher)
                          (inher-intro . +)
                          (member-init-cont . c-lineup-multi-inher)
                          (member-init-intro . +)
                          (annotation-var-cont . +)
                          (annotation-top-cont . 0)
                          (topmost-intro . 0)
                          (func-decl-cont . +)
                          (inline-close . 0)
                          (class-close . 0)
                          (class-open . 0)
                          (defun-block-intro . +)
                          (defun-close . 0)
                          (defun-open . 0)
                          (c . c-lineup-C-comments)
                          (string . c-lineup-dont-change)
                          (topmost-intro-cont . c-lineup-topmost-intro-cont)
                          (brace-list-intro . +)
                          (brace-list-open . 0)
                          (inline-open . +)
                          (arglist-close . +)
                          (arglist-intro . +)
                          (statement-cont . +)
                          (statement-case-open . 0)
                          (label . ++)
                          (substatement-label . ++)
                          (substatement-open . +)
                          (statement-block-intro . +))))
    "My custom C/C++ programming style.")

  ;; Add custom C/C++ style and set it as default. This style is only used for
  ;; languages which do not have a more specific style set in `c-default-style'.
  (c-add-style "mine" my-cc-style)
  (setf (map-elt c-default-style 'other) "mine"))

;; Package `ccls' is a client for ccls, a C/C++/Objective-C language server
;; supporting multi-million line C++ code-bases, powered by libclang. It
;; leverages `lsp-mode', but also provides some ccls extensions to LSP.
(use-package! ccls
  :bind (:map ccls-tree-mode-map
              ("e" . #'ccls-tree-toggle-expand)
              ("n" . #'ccls-tree-next-line)
              ("p" . #'ccls-tree-prev-line))
  :config

  (lsp-define-extension! "ccls" "find-references-read" (_)
    "textDocument/references"
    "Find read references of the type at point."
    `(:role 8))

  (lsp-define-extension! "ccls" "find-references-write" (_)
    "textDocument/references"
    "Find write references of the type at point."
    `(:role 16))

  (lsp-define-extension! "ccls" "find-references-address" (_)
    "textDocument/references"
    "Find address references of the type at point."
    `(:role 128))

  (lsp-define-extension! "ccls" "find-base" (levels)
    "$ccls/inheritance"
    "Find base types of the type at point.
Prefix arg LEVELS will describe how many levels of inheritance
should be visible."
    `(:derived ,json-false :levels ,(or levels 1)))

  (lsp-define-extension! "ccls" "find-derived" (levels)
    "$ccls/inheritance"
    "Find derived types of the type at point.
Prefix arg LEVELS will describe how many levels of inheritance
should be visible."
    `(:derived t :levels ,(or levels 1)))

  (lsp-define-extension! "ccls" "find-callers" (levels)
    "$ccls/call"
    "Find callers of the function at point.
Prefix arg LEVELS will describe how many levels of calls should be visible."
    `(:callee ,json-false :levels ,(or levels 1)))

  (lsp-define-extension! "ccls" "find-callees" (levels)
    "$ccls/call"
    "Find callees of the function at point.
Prefix arg LEVELS will describe how many levels of calls should be visible."
    `(:callee t :levels ,(or levels 1)))

  (lsp-define-extension! "ccls" "find-member-vars" (levels)
    "$ccls/member"
    "Find member variables of the type at point.
Prefix arg LEVELS will describe how many levels of children should be visible."
    `(:kind 4 :levels ,(or levels 1)))

  (lsp-define-extension! "ccls" "find-member-funcs" (levels)
    "$ccls/member"
    "Find member functions of the type at point.
Prefix arg LEVELS will describe how many levels of children should be visible."
    `(:kind 3 :levels ,(or levels 1)))

  (lsp-define-extension! "ccls" "find-member-types" (levels)
    "$ccls/member"
    "Find member types of the type at point.
Prefix arg LEVELS will describe how many levels of children should be visible."
    `(:kind 2 :levels ,(or levels 1)))

  (defun my--ccls-avy-document-symbol (all)
    "Go to symbol or word with `avy' help.
ALL when non-nil determines whether words will be pickable."
    (interactive)
    (let ((line 0)
          (w (selected-window))
          (start-line (1- (line-number-at-pos (window-start))))
          (end-line (1- (line-number-at-pos (window-end))))
          (point0)
          (point1)
          (candidates))
      (save-excursion
        (goto-char 1)
        (cl-loop for loc in
                 (lsp--send-request
                  (lsp--make-request
                   "textDocument/documentSymbol"
                   `(:textDocument ,(lsp--text-document-identifier)
                                   ,@(when all '(:excludeRole 0))
                                   :startLine ,start-line :endLine ,end-line)))
                 for range = loc
                 for range_start = (gethash "start" range)
                 for range_end = (gethash "end" range)
                 for l0 = (gethash "line" range_start)
                 for c0 = (gethash "character" range_start)
                 for l1 = (gethash "line" range_end)
                 for c1 = (gethash "character" range_end)
                 while (<= l0 end-line)
                 when (>= l0 start-line)
                 do
                 (forward-line (- l0 line))
                 (forward-char c0)
                 (setq point0 (point))
                 (forward-line (- l1 l0))
                 (forward-char c1)
                 (setq point1 (point))
                 (setq line l1)
                 (push `((,point0 . ,point1) . ,w) candidates)))
      (require 'avy)
      (avy-with avy-document-symbol
                (avy-process candidates
                             (avy--style-fn avy-style)))))

  (defun ccls-avy-goto-symbol ()
    "Go to symbol with `avy' help."
    (interactive)
    (my--ccls-avy-document-symbol nil))

  (defun ccls-avy-goto-word ()
    "Go to word with `avy' help."
    (interactive)
    (my--ccls-avy-document-symbol t))

  (defun ccls-call-hierarchy-inv ()
    "Display callees hierarchy."
    (interactive)
    (ccls-call-hierarchy t))

  (defun ccls-inheritance-hierarchy-inv ()
    "Display hierarchy of derived classes."
    (interactive)
    (ccls-inheritance-hierarchy t))

  (dolist (mode '(c-mode c++-mode))
    (set-leader-keys-for-major-mode! mode
      ;; Code actions
      "ap"  #'ccls-preprocess-file

      ;; Peek
      "gb"  #'ccls-ui-peek-find-base
      "gc"  #'ccls-ui-peek-find-callers
      "gC"  #'ccls-ui-peek-find-callees
      "gd"  #'ccls-ui-peek-find-derived
      "ghi" #'ccls-inheritance-hierarchy
      "ghI" #'ccls-inheritance-hierarchy-inv
      "ghc" #'ccls-call-hierarchy
      "ghC" #'ccls-call-hierarchy-inv
      "ghm" #'ccls-member-hierarchy
      "gmm" #'ccls-ui-peek-find-member-vars
      "gmf" #'ccls-ui-peek-find-member-funcs
      "gmt" #'ccls-ui-peek-find-member-types
      "gk"  #'ccls-avy-goto-symbol
      "gK"  #'ccls-avy-goto-word
      "gR&" #'ccls-ui-peek-find-references-address
      "gRr" #'ccls-ui-peek-find-references-read
      "gRw" #'ccls-ui-peek-find-references-write

      ;; Goto
      "Gb"  #'ccls-find-base
      "Gc"  #'ccls-find-callers
      "GC"  #'ccls-find-callees
      "Gd"  #'ccls-find-derived
      "Ghi" #'ccls-inheritance-hierarchy
      "GhI" #'ccls-inheritance-hierarchy-inv
      "Ghc" #'ccls-call-hierarchy
      "GhC" #'ccls-call-hierarchy-inv
      "Ghm" #'ccls-member-hierarchy
      "Gmm" #'ccls-find-member-vars
      "Gmf" #'ccls-find-member-funcs
      "Gmt" #'ccls-find-member-types
      "Gk"  #'ccls-avy-goto-symbol
      "GK"  #'ccls-avy-goto-word
      "gR&" #'ccls-find-references-address
      "gRr" #'ccls-find-references-read
      "gRw" #'ccls-find-references-write))

  ;; Set some basic logging for debugging purpose.
  (setq ccls-args (list "-log-file=/tmp/ccls.log" "-v=1"))

  ;; Change initialisation options to include almost all warnings. Disable some
  ;; clang incompatible flags and set completion to be "smart" case.
  (setq ccls-initialization-options
        '(
          :cache (:directory ".cache/ccls")
          :clang (
                  :extraArgs ["-Weverything"
                              "-Wno-c++98-compat"
                              "-Wno-c++98-compat-pedantic"
                              "-Wno-covered-switch-default"
                              "-Wno-global-constructors"
                              "-Wno-exit-time-destructors"
                              "-Wno-documentation"
                              "-Wno-padded"
                              "-Wno-unneeded-member-function"
                              "-Wno-unused-member-function"
                              "-Wno-language-extension-token"
                              "-Wno-gnu-zero-variadic-macro-arguments"
                              "-Wno-gnu-statement-expression"
                              "-Wno-unused-macros"
                              "-Wno-weak-vtables"
                              "-Wno-ctad-maybe-unsupported"
                              "-Wno-error"]
                  :excludeArgs ["-fconserve-stack"
                                "-fmacro-prefix-map"
                                "-fmerge-constants"
                                "-fno-var-tracking-assignments"
                                "-fstack-usage"
                                "-mabi=lp64"])
          :codeLens (:localVariables :json-false)
          :completion (
                       :caseSensitivity 1
                       :detailedLabel t
                       :duplicateOptional :json-false
                       :include (:maxPathSize 30))
          :index (
                  :blacklist [".*CMakeFiles.*"]
                  :maxInitializerLines 15)))

  ;; Use a bit slower method than font-lock but more accurate.
  (setq ccls-sem-highlight-method 'overlay)

  ;; Use default rainbow semantic highlight theme.
  (ccls-use-default-rainbow-sem-highlight))

;; Package `flycheck-clang-tidy' adds a Flycheck syntax checker for C/C++ based
;; on clang-tidy.
(use-package! flycheck-clang-tidy
  :after flycheck
  :hook (flycheck-mode-hook . flycheck-clang-tidy-setup))

;;;; CMake

;; Package `cmake-font-lock' brings advanced syntax coloring support for CMake
;; scripts. The major feature of this package is to highlighting function
;; arguments according to their use. This package is aware of all built-in CMake
;; functions. In addition, it allows you to add function signatures for your own
;; functions.
(use-package! cmake-font-lock)

;; Package `cmake-mode' provides a major mode with syntax highlighting and
;; indentation for CMakeLists.txt and *.cmake source files.
(use-package! cmake-mode
  :mode ("\\.cmake\(.in\)?\\'")
  :init

  (defhook! my--cmake-mode-setup ()
    cmake-mode-hook
    "Set custom settings for `cmake-mode'."
    (setq-local company-backends '(company-files
                                   (company-cmake
                                    :separate
                                    company-dabbrev-code)
                                   company-dabbrev))
    ;; It's highly annoying with CMake.
    (electric-indent-mode -1)))

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
  :bind (:map markdown-mode-command-map
              ("g" . #'grip-mode)))

;;;; Meson

;; Package `meson-mode' is a major mode for Meson build system files.  Syntax
;; highlighting works reliably.  Indentation works too, but there are probably
;; cases, where it breaks.  Simple completion is supported via
;; `completion-at-point'.
(use-package! meson-mode
  :init

  (defhook! my--meson-mode-setup ()
    meson-mode-hook
    "Set custom settings for `meson-mode'."
    (setq-local company-backends '(company-files
                                   (company-capf
                                    :separate
                                    company-dabbrev-code)
                                   company-dabbrev))
    (company-mode +1)))

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
        (list (car bounds)
              (cdr bounds)
              keywords
              :exclusive 'no
              :company-docsig #'identity))))

  (defhook! my-plantuml-setup ()
    plantuml-mode-hook
    "Set custom settings for `plantuml-mode'."
    ;; Enable custom `completion-at-point'.
    (add-hook 'completion-at-point-functions #'plantuml-completion-at-point
              nil 'local)
    (flycheck-mode +1))

  :config

  ;; Use binary version instead of server, we do not want to send stuff to
  ;; plantuml servers
  (setq plantuml-default-exec-mode 'executable)

  ;; Define flycheck checker for plantuml.
  (require 'flycheck)
  (flycheck-define-checker plantuml
    "A checker using plantuml."
    :command ("plantuml" "-headless" "-syntax")
    :standard-input t
    :error-patterns ((error line-start "ERROR" "\n" line "\n" (message)
                            line-end))
    :modes plantuml-mode)
  (add-to-list 'flycheck-checkers 'plantuml))

;;;; Shell

;; Feature `sh-script' provides a major mode for various Shell scripts.
(use-feature! sh-script
  :init

  (defhook! my--sh-mode-setup ()
    sh-mode-hook
    "Set custom settings for `sh-mode'."
    (setq sh-basic-offset 2)
    ;; Add `company-shell' and `company-shell-env backend.
    (setq-local company-backends '((company-shell-env
                                    company-capf)
                                   company-dabbrev-code
                                   company-dabbrev))
    ;; Enable syntax checking and spellchecking in comments.
    (flycheck-mode +1)
    (flyspell-prog-mode))

  (declare-prefix-for-mode! 'sh-mode "mi" "insert")
  (set-leader-keys-for-major-mode! 'sh-mode
    "\\" #'sh-backslash-region
    "ic" #'sh-case
    "ie" #'sh-indexed-loop
    "if" #'sh-function
    "ig" #'sh-while-getopts
    "ii" #'sh-if
    "io" #'sh-for
    "ir" #'sh-repeat
    "is" #'sh-select
    "iu" #'sh-until
    "iw" #'sh-while
    "s"  #'sh-set-shell)

  ;; Add dotfiles versions of Bash and Zsh.
  :mode ("\\(bash\\|zsh\\)rc\\'" . sh-mode)

  :config

  ;; Silence messages when opening Shell scripts.
  (dolist (func '(sh-set-shell sh-make-vars-local))
    (advice-add func :around #'advice-silence-messages!)))

;; Package `company-shell'
(use-package! company-shell)

;; Package `'shfmt' provides commands and a minor mode for easily reformatting
;; shell scripts using the external "shfmt" program.
(use-package! shfmt
  :init

  (set-leader-keys-for-major-mode! 'sh-mode
    "==" #'shfmt-buffer
    "=r" #'shfmt-region)

  :config

  ;; Set indentation to 2 spaces, allow binary ops to start a line and follow
  ;; redirect operators by a space.
  (setq shfmt-arguments '("-i" "2" "-bn" "-sr" "-ci")))

;;; Configuration file formats

;; Package `gitattributes-mode' provides a major mode for .gitattributes files.
(use-package! gitattributes-mode)

;; Package `gitconfig-mode' provides a major mode for .gitconfig and
;; .gitmodules files.
(use-package! gitconfig-mode)

;; Package `gitignore-mode' provides a major mode for .gitignore files.
(use-package! gitignore-mode)

;; Package `json-mode' provides a major mode for JSON.
(use-package! json-mode
  :init

  (defhook! my--json-mode-setup ()
    json-mode-hook
    "Set custom settings for `json-mode'."
    (setq js-indent-level 2)))

;; Package `pkgbuild-mode' provides a major mode for PKGBUILD files used by Arch
;; Linux and derivatives.
(use-package! pkgbuild-mode)

;; Package `ssh-config-mode' provides major modes for files in ~/.ssh.
(use-package! ssh-config-mode
  :blackout "SSH-Config")

;; Package `toml-mode' provides a major mode for TOML.
(use-package! toml-mode
  :blackout "TOML")

;; Package `yaml-mode' provides a major mode for YAML.
(use-package! yaml-mode)

;;; Introspection
;;;; Help

;; Allows to print a stacktrace in case of an error.
(set-leader-keys! "te" #'toggle-debug-on-error)

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
    "hb" #'describe-bindings
    "hc" #'describe-key-briefly
    "hF" #'describe-face
    "hm" #'describe-mode
    "hM" #'describe-keymap
    "hn" #'view-emacs-news
    "ht" #'describe-theme)

  ;; Always select help window for viewing.
  (setq help-window-select 't))

;; Package `helpful' provides a complete replacement for the built-in
;; Emacs help facility which provides much more contextual information
;; in a better format.
(use-package! helpful
  :init

  (set-leader-keys!
    "hf" #'helpful-callable
    "hI" #'helpful-at-point
    "hk" #'helpful-key
    "hs" #'helpful-symbol
    "hv" #'helpful-variable)

  :bind (;; Remap standard commands.
         ([remap describe-function] . #'helpful-callable)
         ([remap describe-variable] . #'helpful-variable)
         ([remap describe-symbol]   . #'helpful-symbol)
         ([remap describe-key]      . #'helpful-key)))

;;;; Emacs Lisp development

;; Feature `elisp-mode' provides the major mode for Emacs Lisp.
(use-feature! elisp-mode
  :config

  (with-eval-after-load 'helpful
    (defadvice! my--company-doc-buffer-use-helpful
        (func &rest args)
      :around #'elisp--company-doc-buffer
      "Cause `company' to use Helpful to show Elisp documentation."
      (cl-letf (((symbol-function #'describe-function) #'helpful-function)
                ((symbol-function #'describe-variable) #'helpful-variable))
        (apply func args))))

  (defadvice! my--fill-elisp-docstrings-correctly (&rest _)
    :before-until #'fill-context-prefix
    "Prevent `auto-fill-mode' from adding indentation to Elisp docstrings."
    (when (and (derived-mode-p #'emacs-lisp-mode)
               (eq (get-text-property (point) 'face) 'font-lock-doc-face))
      ""))

  :blackout ((lisp-interaction-mode . "Lisp-Interaction")
             (emacs-lisp-mode . `("ELisp"
                                  (lexical-binding
                                   ""
                                   (:propertize "/d" face warning))))))

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
  (setq byte-compile-warnings '(not make-local noruntime))

  :blackout (emacs-lisp-compilation-mode . "Byte-Compile"))

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

  (declare-prefix-for-mode! 'org-mode "mt" "toggle")

  (set-leader-keys-for-major-mode! 'org-mode
    "l"   #'org-store-link
    "C-l" #'org-insert-link

    ;; Toggle
    "ti" #'org-toggle-inline-images
    "tl" #'org-toggle-link-display)
  (set-leader-keys! "ol" #'org-store-link)

  :bind (:map org-mode-map
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
    (push backend org-export-backends))

  ;; Add plantuml for generating diagrams inside Org Mode.
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t))))

;; Package `org-contrib' contains add-ons to Org-mode. These contributions are
;; not part of GNU Emacs or of the official Org-mode package.
(use-package! org-contrib)

;; Feature `ob' allows to work with code blocks in Org buffers.
(use-feature! ob
  :config

  ;; Do not require confirmation before interactively evaluating code blocks in
  ;; Org buffers.
  (setq org-confirm-babel-evaluate nil))

;; Feature `ob-plantuml' provides Org-Babel support for evaluating plantuml
;; scripts.
(use-feature! ob-plantuml
  :config

  (setq org-plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar"))

;; Feature `org-capture' allows to take notes fast in Org.
(use-feature! org-capture
  :init

  (set-leader-keys-for-major-mode! 'org-mode "c" #'org-capture)
  (set-leader-keys! "oc" #'org-capture)

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
  :bind (:map org-mode-map
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

;; Package `ox-reveal' implements a reveal.js Presentation Back-End for Org
;; Export Engine
(use-package! ox-reveal
  :demand t
  :after ox
  :config

  (push 'reveal org-export-backends))

;; Package `htmlize' converts the buffer text and the associated decorations to HTML.
(use-package! htmlize)

;; Package `org-sticky-header' displays in the header-line the Org heading for
;; the node that's at the top of the window.  This way, if the heading for the
;; text at the top of the window is beyond the top of the window, you don't
;; forget which heading the text belongs to.
(use-package! org-sticky-header
  :hook (org-mode-hook . org-sticky-header-mode)

  :config

  ;; Show the full outline path.
  (setq org-sticky-header-full-path 'full))

;; Package `org-superstar' prettifies headings and plain lists in `org-mode'.
;; It's a direct descendant of `org-bullets’.
(use-package! org-superstar
  :hook (org-mode-hook . org-superstar-mode))

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
  (set-leader-keys!
    "ad" #'dired
    "aD" #'dired-other-window
    "fj" #'dired-jump
    "fJ" #'dired-jump-other-window
    "FO" #'dired-other-frame
    "jd" #'dired-jump
    "jD" #'dired-jump-other-window
    "wO" #'dired-other-window)

  :bind (:map dired-mode-map
              ;; This binding is way nicer than ^.
              ("J"  . #'dired-up-directory)
              ;; Bind both creations to be nearby each others
              ("\[" . #'dired-create-empty-file)
              ("\]" . #'dired-create-directory))

  :config
  ;; Switches passed to ls for `dired':
  ;;   - show hidden files
  ;;   - natural sort of (version) numbers within text
  ;;   - append indicator (one of */=>@|) to entries
  ;;   - print sizes like 1K 234M 2G etc
  ;;   - group directories before files
  (setq dired-listing-switches
        "-alvFh --group-directories-first --time-style=long-iso")

  ;; Try to guess a default target directory. This means: if there is a `dired'
  ;; buffer displayed in some window, use its current directory, instead of this
  ;; `dired' buffer’s current directory.
  (setq dired-dwim-target t)

  ;; Instantly revert Dired buffers on re-visiting them, with no message.
  (setq dired-auto-revert-buffer t)

  ;; Copy directories recursively.
  (setq dired-recursive-copies 'always))

;; Feature `dired-x' provides extra `dired' functionality.
(use-feature! dired-x
  :demand t
  :after dired
  :commands (dired-jump dired-jump-other-window)

  :init

  ;; Remap find-file{-other-window} to dired-x-find-file{-other-window}
  (setq dired-x-hands-off-my-keys nil)

  :config

  ;; Prevent annoying "Omitted N lines" messages when auto-reverting.
  (setq dired-omit-verbose nil)

  ;; Do not bind C-x C-j to dired-jump
  (setq dired-bind-jump nil)

  ;; Open common video extensions with `shell-command' by default.
  (setq dired-guess-shell-alist-user
        '(("\\.\\(mp4\\|webm\\|mkv\\)" (open-in-external-app)))))

;; Feature `wdired' allows to rename files editing their names in `dired'
;; buffers.
(use-feature! wdired
  :after dired
  :bind (:map dired-mode-map
              ("C-c C-e" . #'wdired-change-to-wdired-mode))

  :config

  ;; Make permission bits editable.
  (setq wdired-allow-to-change-permissions t))


;; Package `dired-subtree' defines function `dired-subtree-insert' which inserts
;; the subdirectory directly below its line in the original listing, and indents
;; the listing of subdirectory to resemble a tree-like structure. The tree
;; display is somewhat more intuitive than the default "flat" subdirectory
;; manipulation provided by `dired-maybe-insert-subdir'.
(use-package! dired-subtree
  :after dired
  :bind (:map dired-mode-map
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

  :bind (:map dired-mode-map
              ("C-c C-f" . #'fd-dired)
              ("C-c /"   . #'fd-grep-dired)))

;; Package `treemacs-icons-dired' brings Treemacs icons for Dired.
(use-package! treemacs-icons-dired
  :init

  (after-display-graphic-init!
    (add-hook 'dired-mode-hook #'treemacs-icons-dired-mode)))

;;;;; Ranger

;; Package `ranger' is a derived major mode that runs within Dired emulating
;; many of the features of ranger <https://github.com/hut/ranger>. This minor
;; mode shows a stack of the parent directories and updates the parent buffers
;; while navigating the file system. The preview window takes some of the ideas
;; from Peep-Dired <https://github.com/asok/peep-dired> to display previews for
;; selected files in the primary dired buffer. This package tries its best to
;; make a seamless user experience from ranger created for python.
(use-package! ranger
  :commands (deer-jump-other-window
             ranger-up-directory)

  :init

  ;; Remove `C-p' key binding that switches from `dired-mode' to `deer-mode'.
  (remove-hook 'dired-mode-hook 'ranger-set-dired-key)

  ;; We define it to satisfy byte-compiler - this does not work with :defines
  ;; as it has to be defined as nil
  (defvar ranger-was-ranger nil)

  (set-leader-keys!
    "ar" #'ranger
    "aR" #'deer
    "jr" #'deer
    "jR" #'deer-jump-other-window)

  :bind (:map ranger-mode-map
              ("-" . #'ranger-up-directory))

  :config
  (with-eval-after-load 'golden-ratio
    (push "ranger-mode" golden-ratio-exclude-modes)))

;;;; Processes

(set-leader-keys! "ap" #'list-processes)

;; Feature `proced' makes an Emacs buffer containing a listing of the current
;; system processes. You can use the normal Emacs commands to move around in
;; this buffer, and special Proced commands to operate on the processes listed.
(use-feature! proced
  :init
  (set-leader-keys! "aP" #'proced))

;;;; Version control

;; Feature `vc-hooks' provides hooks for the Emacs VC package. We don't use VC,
;; because Magit is superior in pretty much every way.
(use-feature! vc-hooks
  :config

  ;; Disable VC. This improves performance and disables some annoying warning
  ;; messages and prompts, especially regarding symlinks. See
  ;; <https://stackoverflow.com/a/6190338/3538165>.
  (setq vc-handled-backends nil))

;; Package `browse-at-remote' easily opens target page on github/gitlab (or
;; bitbucket) from Emacs by calling `browse-at-remote` function. Support Dired
;; buffers and opens them in tree mode at destination.
(use-package! browse-at-remote
  :init

  (set-leader-keys!
    "gr" #'browse-at-remote
    "gR" #'browse-at-remote-kill))

;; Package `git-commit' assists the user in writing good Git commit messages.
;; While Git allows for the message to be provided on the command line, it is
;; preferable to tell Git to create the commit without actually passing it a
;; message. Git then invokes the `$GIT_EDITOR' (or if that is undefined
;; `$EDITOR') asking the user to provide the message by editing the file
;; ".git/COMMIT_EDITMSG" (or another file in that directory, e.g.
;; ".git/MERGE_MSG" for merge commits).
(use-package! git-commit
  :demand t
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
  (setq git-commit-summary-max-length 50))

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

  (declare-prefix! "g." "git-gutter")
  (set-leader-keys! "g." #'hydra-git-gutter/body)

  (defhook! my--git-gutter-load ()
    find-file-hook
    "Load `git-gutter' when initially finding a file."
    (require 'git-gutter)
    (remove-hook 'find-file-hook #'my--git-gutter-load))

  :config

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

  (set-leader-keys! "gm" #'git-messenger:popup-message)

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

  (declare-prefix! "gt" "timemachine")

  (set-leader-keys!
    "gtt" #'git-timemachine
    "gtb" #'git-timemachine-switch-branch)

  :bind (:map git-timemachine-mode-map
              ("C-g" . git-timemachine-quit))

  :config

  ;; Number of chars from the full sha1 hash to use for abbreviation.
  (setq git-timemachine-abbreviation-length 8))

;; Package `magit' provides a full graphical interface for Git within Emacs.
(use-package! magit
  :defer 2
  :init

  ;; Disable default keybindings.
  (setq magit-define-global-key-bindings nil)

  (set-leader-keys!
    "gb" #'magit-blame
    "gc" #'magit-clone
    "gd" #'magit-diff
    "gF" #'magit-find-file
    "gg" #'magit-dispatch
    "gG" #'magit-file-dispatch
    "gi" #'magit-init
    "gl" #'magit-log-buffer-file
    "gL" #'magit-list-repositories
    "gs" #'magit-status
    "gS" #'magit-stage-file
    "gU" #'magit-unstage-file)

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

  ;; Without explicitly setting this, the candidates won't be sorted with
  ;; Prescient.
  (setq magit-completing-read-function #'selectrum-completing-read)

  ;; Use absolute dates when showing logs.
  (setq magit-log-margin '(t "%d-%m-%Y %H:%M " magit-log-margin-width t 18))

  (transient-append-suffix
    'magit-rebase "-d"
    '("-D" "Use current timestamp for author date" "--ignore-date"))

  (transient-append-suffix
    'magit-fetch "-t"
    '("-u" "Unshallow" "--unshallow"))

  :config
  (with-eval-after-load 'golden-ratio
    (dolist (buf '("^magit.*"))
      (push buf golden-ratio-exclude-buffer-regexp))))

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
              "--features=colors-dark"
            "--features=colors-light") args))

  (magit-delta-mode +1)

  :blackout t)

;; Package `magit-todos' displays keyword entries from source code comments and
;; Org files in the Magit status buffer. Activating an item jumps to it in its
;; file.
(use-package! magit-todos
  :init

  (declare-prefix! "gT" "todos")

  (set-leader-keys!
    "gTT" #'magit-todos-list
    "gTm" #'magit-todos-mode))

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
    "as" #'vterm
    "aS" #'vterm-other-window)

  :config

  ;; Kill buffers when the associated process is terminated.
  (setq vterm-kill-buffer-on-exit t))

;; Package `vterm-toggle' provides a command which toggles between the `vterm'
;; buffer and whatever buffer you are editing.
(use-package! vterm-toggle
  :bind (("<f2>"    . #'vterm-toggle)
         (:map vterm-mode-map
               ("<f2>"    . #'vterm-toggle)
               ("C-c C-d" . #'vterm-toggle-insert-cd))))

;;;; External commands

(set-leader-keys! "!" #'shell-command)

;; Feature `compile' provides a way to run a shell command from Emacs and view
;; the output in real time, with errors and warnings highlighted and
;; hyperlinked.
(use-feature! compile
  :functions (ansi-color-apply-on-region
              pop-to-buffer-other-window)
  :commands (kill-compilation
             recompile)
  :init

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

  (defun show-hide-compilation-window ()
    "Show/Hide the window containing the compilation buffer."
    (interactive)
    (when-let ((buffer next-error-last-buffer))
      (if (get-buffer-window buffer 'visible)
          (delete-windows-on buffer)
        (switch-to-compilation-buffer))))

  (defhook! my--compile-window-colorise-buffer ()
    compilation-filter-hook
    "Colorise *compilation* buffer from `compilation-filter-start' to `point'."
    (let ((buffer-read-only nil))
      (require 'ansi-color)
      (ansi-color-apply-on-region compilation-filter-start (point))))

  (set-leader-keys!
    "bc" #'switch-to-compilation-buffer
    "cb" #'switch-to-compilation-buffer
    "cC" #'compile
    "cd" #'show-hide-compilation-window
    "ck" #'kill-compilation
    "cr" #'recompile)

  :config

  ;; Automatically scroll the Compilation buffer as output appears,
  ;; but stop at the first error.
  (setq compilation-scroll-output 'first-error))

;; Feature `consult-compile' provides the command `consult-compile-error' to
;; quickly jump to compilation errors and warnings.
(use-feature! consult-compile
  :demand t
  :after compile
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

;; Get rid of "For information about GNU Emacs..." message at startup, unless
;; we're in a daemon session, where it'll say "Starting Emacs daemon." instead,
;; which isn't so bad.
(unless (daemonp)
  (advice-add #'display-startup-echo-area-message :override #'ignore))

;;; Shutdown

;; Package `restart-emacs' provides an easy way to restart Emacs from inside of
;; Emacs, both in the terminal and in windowed mode.
(use-package! restart-emacs
  :init
  (set-leader-keys! "qr" #'restart-emacs))

;; Bind additional helpful commands for shutting down Emacs.
(set-leader-keys!
  "qq" #'kill-emacs
  "qs" #'save-buffers-kill-terminal
  "qS" #'save-buffers-kill-emacs)

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

;; Don't blink the cursor on the opening paren when you insert a closing paren,
;; as we already have superior handling of that from Smartparens.
(setq blink-matching-paren nil)

;; Don't suggest shorter ways to type commands in M-x, since they don't apply
;; when using Selectrum.
(setq suggest-key-bindings 0)

;; Decrease the frequency of UI updates when Emacs is idle.
(setq idle-update-delay 1)

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
    "tn" #'display-line-numbers-mode
    "tN" #'global-display-line-numbers-mode)

  :hook ((prog-mode-hook text-mode-hook) . display-line-numbers-mode))

;; Feature `display-fill-column-indicator' provides a minor mode interface for
;; `display-fill-column-indicator'.
(use-feature! display-fill-column-indicator
  :init

  (set-leader-keys!
    "tf" #'display-fill-column-indicator-mode
    "tF" #'global-display-fill-column-indicator-mode)

  :hook (prog-mode-hook . display-fill-column-indicator-mode))

;;;; Font

;; Set default font.
(face-spec-set 'default '((t :family "Hack" :height 135)))

;; Package `default-text-scale' provides commands for increasing or decreasing
;; the default font size in all GUI Emacs frames - it is like an Emacs-wide
;; version of `text-scale-mode'.
(use-package! default-text-scale
  :demand t
  :config

  (defhydra hydra-zoom (:color pink :hint nil)
    "
[_+_] zoom in [_-_] zoom out
[_0_] reset   [_q_] quit
"
    ("+" default-text-scale-increase)
    ("=" default-text-scale-increase)
    ("-" default-text-scale-decrease)
    ("0" default-text-scale-reset)
    ("q" nil :exit t)
    ("C-g" nil :exit t))
  (set-leader-keys! "z" #'hydra-zoom/body)

  (default-text-scale-mode +1))

;;;; Theme

;; Package `darkokai-theme' is a darker variant on Monokai.
(use-package! darkokai-theme
  :config

  ;; Configure `selectrum-prescient' faces.
  (let ((custom--inhibit-theme-enable nil))
    (darkokai-with-color-vars
      (custom-theme-set-faces
       'darkokai
       `(selectrum-current-candidate
         ((,class (:background ,darkokai-highlight-line
                               :inherit bold
                               :underline nil))
          (,terminal-class (:background ,terminal-darkokai-highlight-line
                                        :inherit bold
                                        :underline nil))))
       `(selectrum-prescient-primary-highlight
         ((,class (:foreground ,darkokai-green))
          (,terminal-class (:foreground ,terminal-darkokai-green))))
       `(selectrum-prescient-secondary-highlight
         ((,class (:foreground ,darkokai-orange
                               :underline t))
          (,terminal-class (:foreground ,terminal-darkokai-orange
                                        :underline t))))))))

;; Package `monokai-alt-theme' is theme with a dark background. Based on Sublime
;; Monokai theme.
(use-package! monokai-alt-theme)

;; Package `monokai-pro-theme' is a simple theme based on the Monokai Pro
;; Sublime colour schemes.
(use-package! monokai-pro-theme)

;; Package `monokai-theme' is a fruity colour theme for Emacs.
(use-package! monokai-theme)

;; Package `modus-themes' is a pack of themes that conform with the highest
;; standard for colour-contrast accessibility between background and foreground
;; values (WCAG AAA).
(use-package! modus-themes
  :bind ("<f9>" . modus-themes-toggle))

;; Load default theme.
(load-theme 'darkokai t)

;;;; Modeline

;; Package `doom-modeline' offers a fancy and fast mode-line inspired by
;; minimalism design. It's integrated into Doom Emacs.
(use-package! doom-modeline
  :demand t
  :config

  ;; Display the icons in the mode-line. We set it explicitly because of server
  ;; mode in GUI.
  (setq doom-modeline-icon t)

  ;; Display minor modes in modeline, with `minions-mode' they won't be visible
  ;; anyway but could be quickly looked at by disabling `minions-mode'.
  (setq doom-modeline-minor-modes t)

  ;; We do not use any modal editing so its icon is redundant.
  (setq doom-modeline-modal-icon nil)

  ;; Use unicode as a fallback (instead of ASCII) when not using icons.
  (setq doom-modeline-unicode-fallback t)

  ;; Redesign modeline to have much less information from the default one.
  (doom-modeline-def-modeline 'main
    '(bar window-number matches buffer-info remote-host buffer-position
          selection-info)
    '(misc-info grip debug lsp minor-modes indent-info buffer-encoding
                major-mode process vcs checker))

  (doom-modeline-mode +1))

;; Package `hide-mode-line' provides a minor mode that hides (or masks) the
;; modeline in your current buffer. It can be used to toggle an alternative
;; modeline, toggle its visibility, or simply disable the modeline in buffers
;; where it isn't very useful otherwise.
(use-package! hide-mode-line)

;; Package `minions' implements a menu that lists enabled minor-modes, as
;; well as commonly but not currently enabled minor-modes.  It can be used to
;; toggle local and global minor-modes, to access mode-specific menus, and to
;; get help about modes.
(use-package! minions
  :demand t
  :config

  (set-leader-keys! "tm" #'minions-mode)

  (minions-mode +1))

;;;; Tabs

;; Package `powerline' is a library for customizing the mode-line that is based
;; on the Vim Powerline. A collection of predefined themes comes with the
;; package.
(use-package! powerline
  ;; This package has issues with native compilation.
  :straight (:build (:not native-compile)))

;; Package `centaur-tabs' is an Emacs plugin aiming to become an aesthetic,
;; modern looking tabs plugin. This package offers tabs with a wide range of
;; customization options, both aesthetical and functional, implementing them
;; trying to follow the Emacs philosophy packing them with useful keybindings
;; and a nice integration with the Emacs environment, without sacrificing
;; customizability.
(use-package! centaur-tabs
  :demand t
  :init

  (set-leader-keys!
    "Td" #'centaur-tabs-open-directory-in-external-application
    "Tf" #'centaur-tabs-extract-window-to-new-frame
    "Tk" #'centaur-tabs-kill-other-buffers-in-current-group
    "Tn" #'centaur-tabs-forward
    "TN" #'centaur-tabs-forward-group
    "To" #'centaur-tabs-open-in-external-application
    "Tp" #'centaur-tabs-backward
    "TP" #'centaur-tabs-backward-group)

  :config

  (defadvice! my--centaur-tabs-hide-tab (fn &rest args)
    :around #'centaur-tabs-hide-tab
    "Make `centaur-tabs-hide-tab' hide additional buffers."
    (setq arg (car args))
    (let ((name (format "%s" arg)))
      (or (apply fn args)
          (string-prefix-p "*ccls" name))))

  ;; Change tabs style to have a bit of border between tabs.
  (setq centaur-tabs-style "alternate")

  ;; Increase the height by about 50%.
  (setq centaur-tabs-height 32)

  ;; Display an icon from `all-the-icons' alongside the tab name.
  (setq centaur-tabs-set-icons t)

  ;; Display a marker when the buffer is modified.
  (setq centaur-tabs-set-modified-marker t)

  ;; Display the bar under the currently selected tab.
  (setq centaur-tabs-set-bar 'under)

  ;; Show the buttons for backward/forward tabs.
  (setq centaur-tabs-show-navigation-buttons t)

  ;; Gray out icons for unselected buffers.
  (setq centaur-tabs-gray-out-icons 'buffer)

  ;; Draw the underline at the same place as the descent line.
  (setq x-underline-at-descent-line t)

  (centaur-tabs-change-fonts "Hack" 100)
  (centaur-tabs-mode +1)

  ;; Group tabs by `projectile' project.
  (centaur-tabs-group-by-projectile-project)

  ;; Make the headline face match the centaur-tabs-default face. This makes the
  ;; tab bar have an uniform appearance
  (centaur-tabs-headline-match)

  :bind (:map centaur-tabs-mode-map
              ("C-<prior>" . #'centaur-tabs-backward)
              ("C-<next>"  . #'centaur-tabs-forward)
              ("C-<home>"  . #'centaur-tabs-backward-group)
              ("C-<end>"   . #'centaur-tabs-forward-group)))

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
