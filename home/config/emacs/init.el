;;; init.el --- Load the full configuration -*- lexical-binding: t -*-

;;; Commentary:

;; This file bootstraps the whole configuration.

;;; Code:

(defconst my-minimum-emacs-version "31.0"
  "This Emacs configuration does not support any Emacs version below this.")

;; Make sure we are running a modern enough Emacs, otherwise abort init.
(when (version< emacs-version my-minimum-emacs-version)
  (error (concat "This Emacs configuration requires at least Emacs %s, "
                 "but you are running Emacs %s")
         my-minimum-emacs-version emacs-version))

;; Just log warnings and immediately show errors.
(setopt warning-minimum-level :error)

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

;; Ask whether to terminate asynchronous compilations on exit. This prevents
;; native compilation from leaving temporary files in /tmp
(setq native-comp-async-query-on-exit t)

;;;; Elpaca


(defvar elpaca-core-date 20260301)
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Use locked packages versions.
(setopt elpaca-lock-file (expand-file-name "versions.el" user-emacs-directory))

;;;; use-package

;; Package `use-package' provides a handy macro by the same name which is
;; essentially a wrapper around `with-eval-after-load' with a lot of handy
;; syntactic sugar and useful features.
(elpaca elpaca-use-package
  ;; Enable `use-package' :ensure support for Elpaca.
  (elpaca-use-package-mode))

(eval-and-compile
  ;; Tell `use-package' to always use `elpaca' unless specified otherwise.
  (setopt use-package-always-ensure t)

  ;; Tell `use-package' to always load features lazily unless told otherwise.
  ;; It's nicer to have this kind of thing be deterministic: if `:demand' is
  ;; present, the loading is eager; otherwise, the loading is lazy.
  (setopt use-package-always-defer t)

  ;; Do not automatically add -hook prefix to all hooks mentioned in :hook.
  ;; It inhibits a simple introspection of hooks by Emacs.
  (setopt use-package-hook-name-suffix nil))

;; Explicitly require `use-package' when compiling to keep Flymake happy.
(eval-when-compile
  (require 'use-package))

(defmacro use-feature! (name &rest args)
  "Like `use-package', but with Elpaca disabled.
NAME and ARGS are as in `use-package'."
  (declare (indent defun))
  `(use-package ,name
     :ensure nil
     ,@args))

(defmacro use-package! (name &rest args)
  "Wrap `use-package'.
NAME and ARGS are as in `use-package'."
  (declare (indent defun))
  `(use-package ,name
     ,@args))

;;; Keybindings

(defvar-keymap my-leader-key-map
  :doc "Keymap for all common leader key commands."
  "a" `("ai" . ,(make-sparse-keymap))
  "A" `("apps" . ,(make-sparse-keymap))
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
  "r" `("regs/rings" . ,(make-sparse-keymap))
  "s" `("search" . ,(make-sparse-keymap))
  "S" `("spellcheck" . ,(make-sparse-keymap))
  "t" `("toggle" . ,(make-sparse-keymap))
  "T" `("tabs" . ,(make-sparse-keymap))
  "u" `("undo" . ,(make-sparse-keymap))
  "v" `("multiple-cursors" . ,(make-sparse-keymap))
  "w" `("windows" . ,(make-sparse-keymap))
  "x" `("text" . ,(make-sparse-keymap))
  "z" `("zoom" . ,(make-sparse-keymap))
  "p m" `("manage" . ,(make-sparse-keymap))
  "t H" `("highlight" . ,(make-sparse-keymap)))

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
(use-feature! which-key
  :demand t
  :config

  ;; Make various prefixes more readable.
  (which-key-add-key-based-replacements
    "C-c"           "mode-and-user"
    "C-x"           "extra-commands"
    "C-x 4"         "other-window"
    "C-x 5"         "other-frame"
    "C-x 8"         "insert-special"
    "C-x a"         "abbrev"
    "C-x n"         "narrow"
    "C-x p"         "projects"
    "C-x p C-x"     "extra"
    "C-x r"         "reg/rect/bkmks"
    "C-x t ^"       "detach"
    "C-x t"         "tab-bar"
    "C-x v"         "vc"
    "C-x v b"       "branch"
    "C-x v E"       "outgoing-edited"
    "C-x v I"       "incoming"
    "C-x v M"       "mergebase"
    "C-x v O"       "outgoing"
    "C-x v T"       "unintegrated"
    "C-x v T R"     "remote"
    "C-x v w"       "worktree"
    "C-x w"         "window-extras"
    "C-x w ^"       "detach"
    "C-x w f"       "layout-flip"
    "C-x w o"       "rotate-windows"
    "C-x w r"       "layout-rotate"
    "C-x x"         "buffer-extras"
    "C-x C-k"       "kmacro"
    "C-x C-k C-q"   "counters"
    "C-x C-k C-r a" "add"
    "C-x C-k C-r"   "register"
    "M-g"           "goto"
    "M-s h"         "highlight"
    "M-s"           "search"

    my-major-mode-leader-key-alt  "major-mode"
    my-major-mode-leader-key-alt2 "major-mode")

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

  ;; Disable `help-char' override as we use `embark' for that.
  (setq which-key-use-C-h-commands nil)

  ;; Sort by key using alphabetical order, with lowercase keys having higher
  ;; priority
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-sort-uppercase-first nil)

  (which-key-mode +1))

;; Package `hydra' can be used to tie related commands into a family of short
;; bindings with a common prefix - a Hydra. Once you summon the Hydra (through
;; the prefixed binding), all the heads can be called in succession with only a
;; short extension - it's like a minor mode that disables itself automagically.
(use-package! hydra
  :ensure (:wait t)
  :demand t)

;;; Configure ~/.emacs.d paths

(require 'xdg)

(defconst my-cache-dir (concat (xdg-cache-home) "/emacs/")
  "Directory for volatile local storage. Must end with slash.")

(defconst my-data-dir (concat (xdg-data-home) "/emacs/")
  "Directory for non-volatile local storage. Must end with slash.")

(defsubst cache-dir (path)
  "Expand PATH relative to `my-cache-dir'."
  (expand-file-name (convert-standard-filename path) my-cache-dir))

(defsubst data-dir (path)
  "Expand PATH relative to `my-data-dir'."
  (expand-file-name (convert-standard-filename path) my-data-dir))

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
  :init

  (global-clipetty-mode +1))

;;;; Mouse integration

;; Mouse yank commands yank at point instead of at click. This also allows
;; yanking text into an Isearch without moving the mouse cursor to the echo area
(setopt mouse-yank-at-point t)

;; Double-clicking attempts to select the symbol at click.
(setopt mouse-1-double-click-prefer-symbols t)

;; Clicking the left mouse button with the <Shift> modifier (`S-down-mouse-1')
;; adjusts the already selected region.
(mouse-shift-adjust-mode +1)

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

;; Display tool-tips in TTY child frames.
(without-display-graphic! (tty-tip-mode t))

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
  :hook (tty-setup-hook . global-kkp-mode))

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
(setopt custom-file (cache-dir "custom.el"))

;; Silence Emacs in terminal.
(setq ring-bell-function #'ignore)

;; Disable ESC key as a modifier and use better `keyboard-quit' by default.
(keymap-global-set "<escape>" #'keyboard-escape-quit)
(keymap-global-set "C-g" #'keyboard-escape-quit)

;;; Windows management

;; When switching the buffer respect display actions specified by
;; `display-buffer-overriding-action', `display-buffer-alist' and other display
;; related variables.
(setopt switch-to-buffer-obey-display-actions t)

;; Set custom actions when display certain buffers.
(setopt display-buffer-alist
        '(;; No window
          ("\\`\\*Async Shell Command\\*\\'"
           (display-buffer-no-window))
          ("\\`\\*\\(Warnings\\|Compile-Log\\|Org Links\\)\\*\\'"
           (display-buffer-no-window)
           (allow-no-window . t))
          ;; Make Majutsu behave like Magit.
          ((derived-mode . majutsu-log-mode)
           (display-buffer-full-frame))
          ;; Make Helpful behave more similar to builtin Help.
          ((derived-mode . helpful-mode)
           (display-buffer-reuse-mode-window display-buffer-pop-up-window)
           (mode . helpful-mode))
          ;; Bottom reusable window
          ((or . ((derived-mode . flymake-diagnostics-buffer-mode)
                  (derived-mode . flymake-project-diagnostics-mode)
                  (derived-mode . occur-mode)
                  (derived-mode . grep-mode)))
           (display-buffer-reuse-mode-window display-buffer-below-selected)
           (mode . ( flymake-diagnostics-buffer-mode
                     flymake-project-diagnostics-mode
                     occur-mode
                     grep-mode))
           (body-function . select-window))
          ;; Compilation window in fullscreen
          ((derived-mode . compilation-mode)
           (display-buffer-full-frame))
          ;; Select Eldoc window when launching it
          ("\\*eldoc.*\\*"
           (display-buffer-reuse-window display-buffer-pop-up-window)
           (body-function . select-window))))

;; Killing buffers should also quit their windows.
(setopt kill-buffer-quit-windows t)

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
  "w 1" #'same-window-prefix
  "w 2" #'split-window-double
  "w 3" #'split-window-triple
  "w 4" #'split-window-grid
  "w b" #'switch-to-minibuffer-window
  "w e" #'balance-windows
  "w m" #'maximize-buffer
  "w q" #'kill-buffer-and-window
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
  "F F" #'other-frame-prefix
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
  (set-leader-keys! "w F" #'follow-mode))

;; Feature `ibuffer' provides a more modern replacement for the `list-buffers'
;; command.
(use-feature! ibuffer
  :init

  (set-leader-keys! "b l" #'ibuffer)

  :bind ([remap list-buffers] . #'ibuffer)
  :config

  ;; Show buffer sizes in human-readable format.
  (setopt ibuffer-human-readable-size t)

  ;; Don't ask for confirmation of dangerous operations.
  (setopt ibuffer-expert t)

  ;; Don't show the names of filter groups which are empty.
  (setopt ibuffer-show-empty-filter-groups nil))

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

;; Package `ace-window' provides a function, `ace-window' which is meant to
;; replace `other-window' by assigning each window a short, unique label. When
;; there are only two windows present, `other-window' is called. If there are
;; more, each window will have its first label character highlighted. Once a
;; unique label is typed, ace-window will switch to that window.
(use-package! ace-window
  :demand t
  :config

  (defun ace-window-prefix ()
    "Use `ace-window' to display the buffer of the next command.
The next buffer is the buffer displayed by the next command invoked
immediately after this command (ignoring reading from the minibuffer).
Creates a new window before displaying the buffer.
When `switch-to-buffer-obey-display-actions' is non-nil,
`switch-to-buffer' commands are also supported."
    (interactive)
    (display-buffer-override-next-command
     (lambda (buffer alist)
       (let ((alist (append '((inhibit-same-window . t)) alist))
             window type)
         (if (setq window (display-buffer-pop-up-window buffer alist))
             (setq type 'window)
           (setq window (aw-select (propertize " ACE" 'face
                                               'mode-line-highlight))
                 type 'reuse))
         (cons window type)))
     nil "[ace-window]")
    (message "Use `ace-window' to display next command buffer..."))

  (set-leader-keys!
    "w d" #'ace-delete-window
    "w D" #'ace-delete-other-windows
    "w M" #'ace-swap-window
    "w w" #'ace-window-prefix)

  ;; Show the Ace window key in the mode line.
  (ace-window-display-mode +1)

  :bind ("M-o" . #'ace-window))

;; Package `ibuffer-project' provides IBuffer filtering and sorting functions to
;; group buffers by function or regexp applied to `default-directory'. By
;; default buffers are grouped by `project-current' or by `default-directory'.
(use-package! ibuffer-project
  :init

  (defhook! my--ibuffer-group-by-projects ()
    ibuffer-hook
    "Group buffers by projects."
    (setq ibuffer-filter-groups (ibuffer-project-generate-filter-groups))
    (ibuffer-do-sort-by-project-file-relative))

  :config

  ;; Avoid calculating project root each time by caching it.
  (setopt ibuffer-project-use-cache t))

;; Package `nerd-icons-ibuffer' provides icons for IBuffer that work in GUI
;; and in terminal.
(use-package! nerd-icons-ibuffer
  :hook (ibuffer-mode-hook . nerd-icons-ibuffer-mode))

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
         (filepath (expand-file-name filename)))
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
  "f S"   #'save-some-buffers)

;; Feature `files-x' extends file handling with local persistent variables.
(use-feature! files-x
  :init

  (set-prefixes! "f v" "variables")

  (set-leader-keys!
    "f v c" #'customize-dirlocals
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

  ;; Include Dired and Magit.
  (setopt project-switch-commands
          '((project-find-file "Find file" ?f)
            (project-find-regexp "Find regexp" ?g)
            (project-find-dir "Find directory" ?d)
            (project-dired "Dired" ?D)
            (magit-project-status "Magit" ?m)
            (majutsu-project-log "Majutsu" ?j)
            (project-vc-dir "VC-Dir" ?v)
            (project-eshell "Eshell" ?e)
            (project-any-command "Other" ?o)))

  ;; Show current project name and Project menu on the mode line.
  (setopt project-mode-line t)

  ;; Do not litter `user-emacs-directory' with Project persistent history.
  (setopt project-list-file (cache-dir "projects.el"))

  (set-leader-keys!
    "p !" #'project-shell-command
    "p %" #'project-query-replace-regexp
    "p &" #'project-async-shell-command
    "p /" #'project-search
    "p B" #'project-display-buffer
    "p c" #'project-compile
    "p C" #'project-customize-dirlocals
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
    "p r" #'project-recompile
    "p s" #'project-save-some-buffers
    "p v" #'project-vc-dir
    "p x" #'project-execute-extended-command

    "p m f" #'project-forget-project
    "p m F" #'project-forget-projects-under
    "p m z" #'project-forget-zombie-projects
    "p m r" #'project-remember-projects-under))

;; Feature `recentf' maintains a menu for visiting files that were operated on
;; recently. The recent files list is automatically saved across Emacs sessions.
(use-feature! recentf
  :demand t
  :config

  ;; Never perform auto-cleanup, especially at the start.
  (setopt recentf-auto-cleanup 'never)

  ;; Increase the maximum number of items of the recent list that will be saved.
  (setopt recentf-max-saved-items 300)

  ;; Do not litter `user-emacs-directory' with recentf persistent history.
  (setopt recentf-save-file (cache-dir "recentf.el"))

  ;; List of regexps and predicates for filenames excluded from the recent list.
  (setopt recentf-exclude (list my-cache-dir (file-truename elpaca-directory)))

  ;; Suppress messages saying the recentf file was either loaded or saved.
  (advice-add #'recentf-load-list :around #'advice-silence-messages!)
  (setopt recentf-show-messages nil)

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
  (setopt save-place-file (cache-dir "places.el"))

  (save-place-mode +1))

;; Feature `tramp' provides remote file editing, similar to ange-ftp. The
;; difference is that ange-ftp uses FTP to transfer files between the local and
;; the remote host, whereas tramp.el uses a combination of rsh and rcp or other
;; work-alike programs, such as ssh/scp.
(use-feature! tramp
  :init

  (set-leader-keys! "f E" #'tramp-revert-buffer-with-sudo)

  (with-eval-after-load 'embark
    (keymap-set embark-file-map "s" #'tramp-revert-buffer-with-sudo))

  :config

  ;; Show only warnings and errors.
  (setopt tramp-verbose 2)

  ;; Use rsync instead of default scp in order to utilize control master.
  (setopt tramp-default-method "rsync")

  ;; Use rsync for files above 1 KiB and ssh for smaller files.
  (setopt tramp-copy-size-limit 1024)

  ;; The default timeout is too long.
  (setopt tramp-connection-timeout 5)

  ;; Let ssh_config define them.
  (setopt tramp-use-connection-share nil)

  ;; Disable file locks for remote files.
  (setopt remote-file-name-inhibit-locks t)

  ;; Do not litter `user-emacs-directory' with tramp files.
  (setopt tramp-auto-save-directory (cache-dir "tramp-auto-save")
          tramp-persistency-file-name (cache-dir "tramp.el")
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

;;; Saving files

;; Don't make backup files.
(setq make-backup-files nil)

;; Disable lockfiles (those pesky .# symlinks).
(setq create-lockfiles nil)

;; Do not litter `user-emacs-directory with auto-save files.
(setopt auto-save-list-file-prefix (cache-dir "auto-save/"))
(let ((autosave-dir (cache-dir "auto-save/site/"))
      (tramp-autosave-dir (cache-dir "auto-save/dist/")))
  (setopt auto-save-file-name-transforms
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

(defun toggle-fill-paragraph ()
  "Toggle fill/unfill of the current region.
Operates on the current paragraph if no region is active."
  (interactive)
  (let (deactivate-mark
        (fill-column
         (if (eq last-command this-command)
             (progn (setq this-command nil)
                    most-positive-fixnum)
           fill-column)))
    (if (derived-mode-p '(prog-mode))
        (call-interactively #'prog-fill-reindent-defun)
      (call-interactively #'fill-paragraph))))

(keymap-global-set "M-q" #'toggle-fill-paragraph)
(keymap-unset prog-mode-map "M-q")

;; When region is active, make `capitalize-word' and friends act on it.
(keymap-global-set "M-i" #'capitalize-dwim)
(keymap-global-set "M-l" #'downcase-dwim)
(keymap-global-set "M-u" #'upcase-dwim)

;; Rebind `quoted-insert' as C-q will be used by `kill-buffer'
(keymap-global-set "C-z" #'quoted-insert)

(set-leader-keys!
  "t C-f" #'auto-fill-mode
  "t t"   #'toggle-truncate-lines
  "t l"   #'visual-line-mode
  "t L"   #'global-visual-line-mode
  "x b"   #'delete-blank-lines
  "x f"   #'fill-paragraph
  "x F"   #'unfill-paragraph
  "x t"   #'delete-trailing-whitespace)

;; Make `kill-line' delete the whole line when the cursor is at start of a line.
(setq kill-whole-line t)

;; Kill the last word as defined by the current major mode when `kill-region' is
;; invoked without an active region.
(setopt kill-region-dwim 'emacs-word)

;; Kill entire line.
(keymap-global-set "C-S-k" #'kill-whole-line)

;; When filling paragraphs, assume that sentences end with one space rather than
;; two.
(setq-default sentence-end-double-space nil)

;; Turn on `word-wrap' globally and make simple editing commands redefined to
;; act on visual lines, not logical lines.
(global-visual-line-mode +1)

;; Display continuation lines with prefixes from surrounding context
(global-visual-wrap-prefix-mode)

;; Trigger auto-fill after punctuation characters, not just whitespace.
(mapc
 (lambda (c)
   (set-char-table-range auto-fill-chars c t))
 "!-=+]};:'\",.?")

;; Feature `hideshow' selectively display code and comment blocks.
(use-feature! hideshow
  :init

  (set-leader-keys! "t h" #'hs-minor-mode)

  :config

  ;; Display block hide/show indicators on the fringe.
  (setopt hs-show-indicators t))

;; Feature `outline' `outline' provides major and minor modes for collapsing
;; sections of a buffer into an outline-like format.
(use-feature! outline
  :init

  (set-leader-keys! "t o" #'outline-minor-mode)

  :hook ((diff-mode-hook
          grep-mode-hook
          xref-after-update-hook) . outline-minor-mode)
  :config

  ;; Show outline clickable buttons in a buffer.
  (setopt outline-minor-mode-use-buttons t)

  ;; Enable visibility-cycling commands on headings in `outline-minor-mode' with
  ;; `<tab>' and `S-<tab>'.
  (setopt outline-minor-mode-cycle t)

  ;; Try to append outline font-lock faces to those of major mode.
  (setopt outline-minor-mode-highlight 'append)

  ;; Remove default keybinding of `RET'.
  (keymap-unset outline-overlay-button-map "RET"))

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
  (setq whitespace-style (delq 'lines whitespace-style)))

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
    ("c" string-inflection-lower-camel-case)
    ("k" string-inflection-kebab-case)
    ("p" string-inflection-camel-case)
    ("s" string-inflection-snake-case)
    ("u" string-inflection-upcase)
    ("q" nil :exit t)
    ("C-g" nil :exit t))

  (set-leader-keys!
    "x c" (cons "inflection-camelcase" #'string-inflection-lower-camel-case)
    "x k" (cons "inflection-kebabcase" #'string-inflection-kebab-case)
    "x p" (cons "inflection-pascalcase" #'string-inflection-camel-case)
    "x s" (cons "inflection-snakecase" #'string-inflection-snake-case)
    "x u" (cons "inflection-uppercase" #'string-inflection-upcase)
    "x x" (cons "inflections" #'hydra-string-inflection/body))

  (with-eval-after-load 'embark
    (keymap-set embark-identifier-map "x"
                '("inflections" . hydra-string-inflection/body))
    (keymap-set embark-flymake-map "x"
                '("inflections" . hydra-string-inflection/body))))

;; Package `ws-butler' unobtrusively remove trailing whitespace. What this means
;; is that only lines touched get trimmed. If the whitespace at end of buffer is
;; changed, then blank lines at the end of buffer are truncated respecting
;; `require-final-newline'. All of this happens only when saving.
(use-package! ws-butler
  :hook (prog-mode-hook . ws-butler-mode)

  :init

  (set-leader-keys! "t C-w" #'ws-butler-mode)

  :config

  ;; Do not restore to the buffer trimmed whitespace right before point.
  ;; This behavior isn't compatible with `vc-jj' and `diff-hl'.
  (setopt ws-butler-keep-whitespace-before-point nil))

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
  (global-hungry-delete-mode +1))

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
    (setq this-command 'set-mark-command
          this-original-command 'set-mark-command)
    (call-interactively 'set-mark-command))

   ;; Region exists and is a single line - call `expreg-expand'
   ((or (eq last-command 'expreg-expand)
        (= (line-number-at-pos) (line-number-at-pos (mark))))
    (setq this-command 'expreg-expand
          this-original-command 'expreg-expand)
    (call-interactively 'expreg-expand))

   ;; Region exists and is a multi line - either call `mc/edit-lines' or
   ;; `rectangle-mark-mode'
   (t
    (let ((column-of-mark
           (save-excursion
             (goto-char (mark))
             (current-column))))
      (if (= column-of-mark (current-column))
          (progn
            (setq this-command 'mc/edit-lines
                  this-original-command 'mc/edit-lines)
            (call-interactively 'mc/edit-lines))
        (progn
          (setq this-command 'rectangle-mark-mode
                this-original-command 'rectangle-mark-mode)
          (call-interactively 'rectangle-mark-mode)))))))

;; Overwrite default `set-mark-command' with dwim version.
(keymap-global-set "<remap> <set-mark-command>" #'set-mark-command-dwim)

(set-leader-keys! "b a" #'mark-whole-buffer)

;; Repeating `set-mark-command' after popping mark pops it again.
(setopt set-mark-command-repeat-pop t)

;; Package `easy-kill-extras' contains extra functions for `easy-kill' and
;; `easy-mark'.
(use-package! easy-kill-extras
  :init

  (with-eval-after-load 'easy-kill
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

  :bind ([remap mark-word] . #'easy-mark-word))

;; Package `expreg' increases selected region by semantic units.
(use-package! expreg
  :bind ("C-=" . #'expreg-expand)
  :config

  (defvar-keymap expreg-repeat-map
    :doc "Support Expreg based selection with repeats."
    :repeat (:hints ((expreg-expand   . "expand")
                     (expreg-contract . "contract")))
    "SPC" #'expreg-expand
    "="   #'expreg-expand
    "-"   #'expreg-contract))

;;;; Multiple selection

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

    ;; Automatically matched cursor style with `modus-themes' is invisible.
    (setopt mc/match-cursor-style nil)

    ;; Do not litter `user-emacs-directory' with settings.
    (setopt mc/list-file (data-dir "mc-lists.el"))

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
    "s r t" #'string-insert-rectangle
    "s r x" #'clear-rectangle
    "s r y" #'yank-rectangle)

  :bind ( :map rectangle-mark-mode-map
          ("M-t" . #'string-insert-rectangle)))

;;;; Undo/redo

;; Feature `warnings' allows us to enable and disable warnings.
(use-feature! warnings
  :config

  ;; Ignore the warning we get when a huge buffer is reverted and the undo
  ;; information is too large to be recorded.
  (push '(undo discard-info) warning-suppress-log-types))

;; Package `undo-fu' provides a light weight wrapper for Emacs built-in undo
;; system, adding convenient undo/redo without losing access to the full undo
;; history, allowing you to visit all previous states of the document if you
;; need.
(use-package! undo-fu
  :init

  (set-leader-keys!
    "u r" #'undo-fu-only-redo
    "u R" #'undo-fu-only-redo-all
    "u u" #'undo-fu-only-undo)

  :bind (([remap undo]      . #'undo-fu-only-undo)
         ([remap undo-redo] . #'undo-fu-only-redo))

  :config

  (defvar-keymap undo-fu-repeat-map
    :doc "Support `undo-fu' with repeats."
    :repeat (:hints ((undo-fu-only-undo . "undo")
                     (undo-fu-only-redo . "redo")))
    "u" #'undo-fu-only-undo
    "/" #'undo-fu-only-undo
    "r" #'undo-fu-only-redo)

  ;; Use `undo-in-region' when a selection is present.
  (setopt undo-fu-allow-undo-in-region t)

  ;; Do not use `keyboard-quit' to disable linear undo/redo behavior.
  (setopt undo-fu-ignore-keyboard-quit t))

;; Package `undo-fu-session' writes undo/redo information upon file save which
;; is restored where possible when the file is loaded again.
(use-package! undo-fu-session
  :demand t
  :config

  ;; Use zstd as a compression algorithm.
  (setopt undo-fu-session-compression 'zst)

  ;; Do not litter `user-emacs-directory' with undo history.
  (setopt undo-fu-session-directory (cache-dir "undo-session/"))

  ;; Ignore undo session for the following files.
  (setopt undo-fu-session-incompatible-files
          '("\\.gpg$" "/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))

  (undo-fu-session-global-mode +1))

;; Package `vundo' (visual undo) displays the undo history as a tree and lets
;; you move in the tree to go back to previous buffer states. To use vundo, type
;; M-x vundo RET in the buffer you want to undo. An undo tree buffer should pop
;; up.
(use-package! vundo
  :init

  (set-leader-keys!
    "A u" #'vundo
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
  (setopt bookmark-default-file (data-dir "bookmarks.el"))

  ;; Save bookmarks immediately.
  (setopt bookmark-save-flag 0)

  ;; Suppress messages saying the bookmark file was either loaded or saved.
  (dolist (func '(bookmark-load bookmark-write-file))
    (advice-add func :around #'advice-silence-messages!)))

;; Feature `register' provides a way to save various useful pieces of buffer
;; state to named variables.
(use-feature! register
  :config

  ;; Show a preview buffer with navigation and highlighting.
  (setopt register-use-preview t))

;; Feature `subword' provides a minor mode which causes the `forward-word' and
;; `backward-word' commands to stop at capitalization changes within a word, so
;; that you can step through the components of PascalCase symbols one at a time.
(use-feature! subword
  :demand t
  :config

  (set-leader-keys!
    "t c" #'subword-mode
    "t C" #'global-subword-mode)

  (global-subword-mode +1))

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
         ("M-j i"   . #'avy-goto-char-in-line)
         ("M-j M-i" . #'avy-goto-char-in-line)
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
         ("M-j M-p" . #'avy-kill-ring-save-region)
         :map isearch-mode-map
         ("M-j j"   . #'avy-isearch)
         ("M-j M-j" . #'avy-isearch))

  :config

  (which-key-add-key-based-replacements "M-j" "avy")

  ;; Add a gray background during the selection.
  (setq avy-background t)

  ;; Show Eldoc message after Avy commands.
  (eldoc-add-command-completions "avy-goto-" "avy-isearch"))

;; Package `beginend' redefines M-< and M-> for some modes, e.g in `dired-mode'
;; M-< goes to first line and in `prog-mode' it goes to the first line after
;; comments
(use-package! beginend
  :demand t
  :config

  (beginend-global-mode +1))

;; Package `centered-cursor-mode' Makes the cursor stay vertically in a defined
;; position, usually centered.
(use-package! centered-cursor-mode
  :init

  (set-leader-keys!
    "t -" #'centered-cursor-mode
    "t _" #'global-centered-cursor-mode)

  :config

  ;; Make the end of the file recentered.
  (setq ccm-recenter-at-end-of-file t))

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
  "t H f" #'font-lock-mode
  "t H F" #'global-font-lock-mode)

;; Feature `hl-line' provides minor mode to highlight, on a suitable terminal,
;; the line on which point is. The global mode highlights the current line in
;; the selected window only (except when the minibuffer window is selected). The
;; local mode is sticky - it highlights the line about the buffer's point even
;; if the buffer's window is not selected.
(use-feature! hl-line
  :demand t
  :config

  (set-leader-keys!
    "t H l" #'hl-line-mode
    "t H L" #'global-hl-line-mode)

  (global-hl-line-mode +1))

;; Package `highlight-numbers' provides syntax highlighting of numeric literals
;; in source code, like what many editors provide by default.
(use-package! highlight-numbers
  :init

  (set-leader-keys! "t H n" #'highlight-numbers-mode)

  :hook (prog-mode-hook . highlight-numbers-mode))

;; Package `highlight-parentheses' highlights surrounding parentheses in Emacs.
(use-package! highlight-parentheses
  :init

  (set-leader-keys!
    "t H p" #'highlight-parentheses-mode
    "t H P" #'global-highlight-parentheses-mode)

  :hook (prog-mode-hook . highlight-parentheses-mode)
  :config

  ;; Make parentheses a bit more visible.
  (set-face-attribute 'highlight-parentheses-highlight nil :weight 'ultrabold)

  ;; Make most inside parentheses greenish.
  (setq highlight-parentheses-colors '("Springgreen3"
                                       "IndianRed1"
                                       "IndianRed3"
                                       "IndianRed4")))

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
    "t H t" #'hl-todo-mode
    "t H T" #'global-hl-todo-mode)

  (global-hl-todo-mode +1))

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

  (set-leader-keys! "t H r" #'rainbow-delimiters-mode)

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
[_n_] next    [_p_] prev          [_f_/_b_] switch [_t_] scope
[_o_] overlay [_O_] unoverlay all [_c_]^^ copy     [_z_] center
[_s_] search  [_r_] replace       [_R_]^^ rename   [_q_] quit
"
    ("b" symbol-overlay-switch-backward)
    ("c" symbol-overlay-save-symbol)
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
         ("C-M-r" . #'isearch-backward)
         :map isearch-mode-map
         ("C-g"   . #'isearch-cancel)
         ("C-SPC" . #'isearch-mark-selection)
         ("M-w"   . #'isearch-copy-selection))
  :config

  (defun isearch-copy-selection ()
    "Copy the current Isearch selection to the kill ring."
    (interactive)
    (when isearch-other-end
      (let ((selection (buffer-substring-no-properties
                        isearch-other-end (point))))
        (kill-new selection)
        (isearch-done))))

  (defun isearch-mark-selection ()
    "Mark the current Isearch selection."
    (interactive)
    (isearch-done)
    (push-mark isearch-other-end t 'activate)
    (activate-mark))

  (defvar-keymap isearch-repeat-map
    :doc "Support Isearch based navigation with repeats."
    :repeat (:hints ((isearch-repeat-forward  . "forward")
                     (isearch-repeat-backward . "backward")
                     (recenter-top-bottom     . "recenter")))
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
  (setopt isearch-allow-scroll 'unlimited)

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

;; Feature `grep' provides the Grepping facilities.
(use-feature! grep
  :bind (("M-s g"   . #'grep)
         ("M-s M-g" . #'grep)
         ("M-s G"   . #'rgrep)
         ("M-s M-G" . #'rgrep))
  :config

  ;; Subdivide grep output into sections, one per file.
  (setopt grep-use-headings t)

  ;; Use ripgrep instead.
  (defvar rg-options "-nH --null --no-heading --no-messages -e")
  (setopt grep-command (format "rg %s " rg-options))
  (setopt grep-template (format "%s<R> -g '<F>'" grep-command))
  (setopt grep-find-command
          (format "%s . -type f -print0 | \"%s\" -0 %s"
                  find-program xargs-program grep-command))
  (setopt grep-find-template
          (format "%s -H <D> <X> -type f <F> -print0 | \"%s\" -0 %s<R>"
                  find-program xargs-program grep-command))

  ;; Add various aliases for globs.
  (push '("rust" . "*.rs") grep-files-aliases)
  (push '("toml" . "*.toml") grep-files-aliases)
  (push '("yaml" . "*.yml *.yaml") grep-files-aliases)

  ;; Skip various autodetections since ripgrep usage is already hardcoded.
  (setopt grep-use-null-device nil)
  (setopt grep-use-null-filename-separator t)
  (setopt grep-highlight-matches 'auto))

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
          ("M-'" . #'iedit-show/hide-context-lines)
          :map isearch-mode-map
          ("M-s e"   . #'iedit-mode-from-isearch)
          ("M-s M-e" . #'iedit-mode-from-isearch)))

;; Package `nerd-icons-grep' adds `nerd-icons' to `grep-mode' buffers when
;; `grep-use-headings' is t.
(use-package! nerd-icons-grep
  :demand
  :after grep
  :config

  (nerd-icons-grep-mode +1))

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
    "s l" #'substitute-target-on-line
    "s s" #'substitute-target-in-buffer
    "s f" #'substitute-target-in-defun
    "s <" #'substitute-target-above-point
    "s >" #'substitute-target-below-point))

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

;; Package `jinx' is a fast just-in-time spell-checker for Emacs. Jinx
;; highlights misspelled words in the text of the visible portion of the buffer.
;; For efficiency, Jinx highlights misspellings lazily, recognizes window
;; boundaries and text folding, if any. For example, when unfolding or
;; scrolling, only the newly visible part of the text is checked if it has not
;; been checked before. Each misspelling can be corrected from a list of
;; dictionary words presented as a completion menu. Jinx’s high performance and
;; low resource usage comes from directly calling the API of the Enchant
;; library. Jinx automatically compiles jinx-mod.c and loads the dynamic module
;; at startup. By binding directly to the native Enchant API, Jinx avoids slower
;; inter-process communication. Enchant is used by other text editors and
;; supports multiple backends like Nuspell, Hunspell and Aspell.
(use-package! jinx
  :hook ((text-mode-hook prog-mode-hook conf-mode-hook) . jinx-mode)
  :init

  (set-leader-keys!
    "S a" #'jinx-correct-all
    "S s" #'jinx-correct
    "S l" #'jinx-languages)

  :bind (("M-$"   . #'jinx-correct)
         ("C-M-$" . #'jinx-languages))

  :config

  ;; Enable both camelCase and PascalCase everywhere.
  (setopt jinx-camel-modes t)

  (with-eval-after-load 'vertico-multiform
    ;; Use the grid display such that more suggestions fit on the screen and
    ;; enable annotations
    (add-to-list 'vertico-multiform-categories
                 '(jinx grid
                        (vertico-grid-annotate . 20) (vertico-count . 4)))))

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

  (global-auto-revert-mode +1))

;;;; Automatic indentation

;; Indent the yanked text only if point is not in a string or comment and yanked
;; region is longer than 1 line.
(setopt electric-indent-actions '(yank))

;;;; Automatic delimiter pairing

;; Typing an open parenthesis automatically inserts the corresponding closing
;; parenthesis, and vice versa. (Likewise for brackets, etc.). If the region is
;; active, the parentheses (brackets, etc.) are inserted around the region
;; instead.
(electric-pair-mode +1)

;; Feature `paren' highlights matching parenthesis.
(use-feature! paren
  :demand t
  :config

  ;; Show the matching paren if it is visible, and the expression otherwise.
  (setopt show-paren-style 'mixed)

  ;; Decrease the time after `paren' highlights matches.
  (setopt show-paren-delay 0)

  ;; Show parens when point is just inside one. This will only be done when
  ;; point isn't also just outside a paren.
  (setopt show-paren-when-point-inside-paren t)

  ;; Show parens when point is in the line's periphery. The periphery is at the
  ;; beginning or end of a line or in any whitespace there.
  (setopt show-paren-when-point-in-periphery t)

  ;; Show context around the opening paren if it is offscreen. The context is
  ;; usually the line that contains the openparen, except if the openparen is on
  ;; its own line, in which case the context includes the previous nonblank
  ;; line. By default, the context is shown in the echo area.
  (setopt show-paren-context-when-offscreen t)

  ;; Any matching parenthesis is highlighted in `show-paren-style' after
  ;; `show-paren-delay' seconds of Emacs idle time.
  (show-paren-mode +1))

;; Package `surround' inserts, changes, deletes and marks surrounding pairs of
;; quotes, braces, etc.
(use-package! surround
  :init

  (defvar-keymap surround-map
    :doc "Keymap for all interactive `surround' commands."
    "c"   #'surround-change
    "M-c" #'surround-change
    "d"   #'surround-delete
    "M-d" #'surround-delete
    "w"   #'surround-kill
    "M-w" #'surround-kill
    "q"   #'surround-kill-outer
    "M-q" #'surround-kill-outer
    "s"   #'surround-insert
    "M-s" #'surround-insert
    "["   #'surround-mark
    "]"   #'surround-mark-outer
    "M-[" #'surround-mark
    "M-]" #'surround-mark-outer)

  (keymap-global-set "M-]" surround-map))

;;;; Snippet expansion

;; Feature `abbrev' provides functionality for expanding user-defined
;; abbreviations. We prefer to use `yasnippet' instead, though.
(use-feature! abbrev
  :config

  ;; Do not litter `user-emacs-directory with persistent abbrevs file.
  (setopt abbrev-file-name (data-dir "abbrev.el")))

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
  (setopt aya-persist-snippets-dir (data-dir "snippets")))

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
  :commands (yas-hippie-try-expand
             yas-next-field
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
  (let ((yas-snippet-dir (data-dir "snippets")))
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
  (yas-global-mode +1))

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

;; Hide commands in M-x which do not work in the current mode.
(setopt read-extended-command-predicate #'command-completion-default-include-p)

;; Do not allow the cursor in the minibuffer prompt.
(setopt minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))

;; Feature `minibuffer' provides minibuffer and completion functions.
(use-feature! minibuffer
  :bind ( :map minibuffer-local-completion-map
          ;; Unbind `minibuffer-complete-word'
          ("SPC" . nil))
  :config

  ;; Show the *Completions* buffer immediately when opening a minibuffer with
  ;; completion.
  (setopt completion-eager-display t)

  ;; Always update the *Completions* buffer when typing.
  (setopt completion-eager-update t)

  ;; First TAB pops up the window showing the completions list buffer, and the
  ;; next TAB selects that window.
  (setopt completion-auto-select 'second-tab)

  ;; Always show *Completions* buffer after a completion attempt, and the list
  ;; of completions is updated if already visible.
  (setopt completion-auto-help 'always)

  ;; Do not show help in the *Completions* buffer.
  (setopt completion-show-help nil)

  ;; Sort candidates in the *Completions* buffer according to the order of the
  ;; candidates in the minibuffer history.
  (setopt completions-sort 'historical)

  ;; Enable grouping of completion candidates in the *Completions* buffer.
  (setopt completions-group t)

  ;; Display completions down the screen in one column.
  (setopt completions-format 'one-column)

  ;; Display completions with details added as prefix/suffix.
  (setopt completions-detailed t)

  ;; Limit *Completions* buffer height.
  (setopt completions-max-height 20)

  ;; Allow navigating completions from the minibuffer.
  (setopt minibuffer-visible-completions t))

;; Feature `savehist' saves minibuffer history to an external file after exit.
(use-feature! savehist
  :demand t
  :config

  (defhook! my--savehist-remove-text-properties ()
    savehist-save-hook
    "Remove text properties (fonts, overlays, etc.)."
    (setq kill-ring (mapcar #'substring-no-properties
                            (cl-remove-if-not #'stringp kill-ring))))

  ;; Maximum length of history lists before truncation takes place. Truncation
  ;; deletes old elements, and is done just after inserting a new element.
  (setopt history-length 1000)

  ;; The interval between autosaves of minibuffer history.
  (setopt savehist-autosave-interval 60)

  ;; Save history of additional variables such as `mark-ring'
  (setopt savehist-additional-variables '(mark-ring
                                          global-mark-ring
                                          kill-ring
                                          search-ring
                                          regexp-search-ring
                                          extended-command-history))

  ;; Do not litter `user-emacs-directory' with persistent history file.
  (setopt savehist-file (cache-dir "savehist.el"))

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
    "A m" #'consult-man
    "b b" #'consult-buffer
    "b f" #'consult-focus-lines
    "b k" #'consult-keep-lines
    "f b" #'consult-bookmark
    "f F" #'consult-fd
    "f r" #'consult-recent-file
    "g /" #'consult-git-grep
    "j i" #'consult-imenu
    "j I" #'consult-imenu-multi
    "k m" #'consult-kmacro
    "p b" #'consult-project-buffer
    "r l" #'consult-register-load
    "r r" #'consult-register
    "r s" #'consult-register-store
    "r y" #'consult-yank-replace
    "t T" #'consult-theme)

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
         ("M-g R"           . #'consult-grep-match)
         ("M-g M-R"         . #'consult-grep-match)
         ("M-g /"           . #'consult-line-multi)
         ("M-g M-/"         . #'consult-line-multi)
         ([remap yank-pop]  . #'consult-yank-replace)
         ("M-s d"           . #'consult-fd)
         ("M-s M-d"         . #'consult-fd)
         ("M-s f"           . #'consult-focus-lines)
         ("M-s M-f"         . #'consult-focus-lines)
         ("M-s M-h"         . #'consult-isearch-history)
         ("M-s k"           . #'consult-keep-lines)
         ("M-s M-k"         . #'consult-keep-lines)
         ("M-s l"           . #'consult-line)
         ("M-s M-l"         . #'consult-line)
         ("M-s L"           . #'consult-line-multi)
         ("M-s M-L"         . #'consult-line-multi)
         ("M-s r"           . #'consult-grep-match)
         ("M-s M-r"         . #'consult-grep-match)
         ("M-s ;"           . #'consult-line-symbol-at-point)
         ("M-s M-;"         . #'consult-line-symbol-at-point)
         ("M-s /"           . #'consult-ripgrep)
         ("M-s M-/"         . #'consult-ripgrep)
         :map isearch-mode-map
         ("M-e"             . #'consult-isearch-history)
         ("M-g l"           . #'consult-line)
         ("M-g M-l"         . #'consult-line)
         ("M-g /"           . #'consult-line-multi)
         ("M-g M-/"         . #'consult-line-multi)
         ("M-s l"           . #'consult-line)
         ("M-s M-l"         . #'consult-line)
         ("M-s L"           . #'consult-line-multi)
         ("M-s M-L"         . #'consult-line-multi))

  :config

  (with-eval-after-load 'consult-imenu
    (defun consult-imenu--decorate (name prefix face kind)
      "Return imenu NAME decorated with PREFIX, FACE and KIND metadata."
      (let ((key (concat (if prefix (concat prefix " " name) name))))
        (when (and prefix face)
          (add-face-text-property (1+ (length prefix)) (length key)
                                  face 'append key))
        (when kind
          (add-face-text-property (if prefix (1+ (length prefix)) 0) (length key)
                                  (nth 2 kind) 'append key)
          (setq key (concat (car kind) " " key))
          (put-text-property 0 (length (car kind)) 'consult--type (nth 1 kind) key))
        key))

    (defun consult-imenu--flatten (prefix face list types)
      "Flatten imenu LIST.
PREFIX is prepended in front of all items.
FACE is the item face.
TYPES is the mode-specific types configuration."
      (mapcan
       (lambda (item)
         (let* ((name (concat (car item)))
                (kind (assoc (get-text-property 0 'imenu-kind name) types))
                (key (consult-imenu--decorate name prefix face kind)))
           (if (imenu--subalist-p item)
               (let* ((next-prefix name)
                      (next-face face)
                      (region (get-text-property 0 'imenu-region name)))
                 (add-face-text-property 0 (length name)
                                         'consult-imenu-prefix 'append name)
                 (if prefix
                     (setq next-prefix (concat prefix "/" name))
                   (when-let* ((type (cdr (assoc name types))))
                     (put-text-property 0 (length name) 'consult--type (car type) name)
                     (setq next-face (cadr type))))
                 (nconc
                  (and region
                       (list (cons key (consult-imenu--normalize (car region)))))
                  (consult-imenu--flatten next-prefix next-face (cdr item) types)))
             (list (cons key (consult-imenu--normalize (cdr item)))))))
       list)))

  (consult-customize
   ;; Preview themes on any key press, but delay 0.5s.
   consult-theme :preview-key '(:debounce 0.5 any)
   ;; Disable the automatic preview only for commands, where the preview may be
   ;; expensive due to file loading.
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   :preview-key '(:debounce 0.4 any)))

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

  ;; Add Embark to the mouse context menu.
  (add-hook 'context-menu-functions #'embark-context-menu 100)

  :bind (("M-n"     . #'embark-next-symbol)
         ("M-p"     . #'embark-previous-symbol)
         ("M-s a"   . #'embark-act)
         ("M-s M-a" . #'embark-act)
         ("M-s A"   . #'embark-act-all)
         ("M-s M-A" . #'embark-act-all)
         ("M-s b"   . #'embark-become)
         ("M-s M-b" . #'embark-become)
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

  ;; Rely on `orderless' for completions with `basic' and `partial-completion'
  ;; fallback in order to ensure that completion commands which rely on dynamic
  ;; completion tables, e.g., `completion-table-dynamic' or
  ;; `completion-table-in-turn', work correctly.
  (setopt completion-styles '(orderless basic partial-completion))
  (setq completion-category-defaults nil)

  ;; Modify default dispatch list to use \"`\" for fuzzy matching and disable
  ;; \"^\" as it conflicts with beginning of line regexp.
  (setopt orderless-affix-dispatch-alist
          '((?% . char-fold-to-regexp)
            (?! . orderless-not)
            (?& . orderless-annotation)
            (?, . orderless-initialism)
            (?= . orderless-literal)
            (?` . orderless-flex))))

;; Package `vertico' provides a performant and minimalistic vertical completion
;; UI based on the default completion system. The main focus of Vertico is to
;; provide a UI which behaves correctly under all circumstances. By reusing the
;; built-in facilities system, Vertico achieves full compatibility with built-in
;;  Emacs completion commands and completion tables. Vertico only provides the
;; completion UI but aims to be highly flexible, extensible and modular.
;; Additional enhancements are available as extensions or complementary
;; packages.
(use-package! vertico
  :ensure (:files (:defaults "extensions/*"))
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

;;; IDE features
;;;; Definition location

;; Feature `consult-xref' provides Xref integration for Consult.
(use-feature! consult-xref
  :demand t
  :after xref
  :config

  ;; Use `consult' completion with preview.
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref))

;; Feature `semantic/symref/grep' implements the Symref tool API using the
;; external tools find/grep.
(use-feature! semantic/symref/grep
  :config

  ;; List of major modes that are not supported by the default list.
  (setq semantic-symref-filepattern-alist
        '((c-ts-mode "*.[ch]")
          (c++-ts-mode "*.[chCH]" "*.[ch]pp" "*.cc" "*.hh")
          (rust-ts-mode "*.rs")
          (toml-ts-mode "*.toml"))))

;; Package `xref' provides a somewhat generic infrastructure for cross
;; referencing commands, in particular "find-definition". Some part of the
;; functionality must be implemented in a language dependent way and that's done
;; by defining an xref backend.
(use-feature! xref
  :config

  ;; Prompt only if no identifier is at point.
  (setopt xref-prompt-for-identifier nil)

  ;; Use ripgrep for regexp search inside files.
  (setopt xref-search-program 'ripgrep)

  ;; Semantic framework needs to be customized to support modes powered by
  ;; tree-sitter. Use find and grep directly instead of going through the
  ;; Semantic framework.
  (setopt xref-references-in-directory-function
          'xref-references-in-directory-grep)

  ;; Show Eldoc message after Xref commands.
  (eldoc-add-command-completions "xref-find-" "xref-go-" "xref-goto-"))

;; Package `consult-xref-stack' navigates the Xref stack with Consult.
(use-package! consult-xref-stack
  :ensure (:host github :repo "brett-lempereur/consult-xref-stack")
  :bind ("C-," . #'consult-xref-stack))

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

;;;; Display contextual metadata

;; Feature `eldoc' provides a minor mode (enabled by default in Emacs 25) which
;; allows function signatures or other metadata to be displayed in the echo
;; area.
(use-feature! eldoc
  :init

  (set-leader-keys!
    "e h" #'eldoc-doc-buffer
    "h h" #'eldoc-doc-buffer)

  :hook (eval-expression-minibuffer-setup-hook . eldoc-mode)
  :bind ([remap display-local-help] . #'eldoc-doc-buffer)
  :config

  ;; Decrease the idle time after ElDoc shows documentation at point.
  (setopt eldoc-idle-delay 0)

  ;; Prefer ElDoc's documentation buffer if it is displayed in some window.
  (setopt eldoc-echo-area-prefer-doc-buffer t))

;; Package `breadcrumb' provide `project' and `imenu'-based breadcrumb paths
;; displayed either on header line or mode line.
(use-package! breadcrumb
  :demand t
  :config

  (breadcrumb-mode +1))

;;;; Autocompletion

;; Enable indentation and completion using the TAB key. `completion-at-point' is
;; bound to C-M-i, which is M-TAB in a terminal without kitty protocol.
(setopt tab-always-indent 'complete)

;; Disable Ispell completion function.
(setopt text-mode-ispell-word-completion nil)

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
  :ensure (:files (:defaults "extensions/*"))
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
defeats the purpose of `corfu-sort-function'."
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

  ;; Feature `corfu-auto' automatically shows the popup.
  (use-feature! corfu-auto
    :demand t
    :config

    ;; Enable showing the popup automatically.
    (setopt corfu-auto t))

  ;; Feature `corfu-echo' shows candidate documentation in echo area.
  (use-feature! corfu-echo
    :demand t
    :config

    ;; Show documentation string immediately.
    (setopt corfu-echo-delay 0)

    (corfu-echo-mode +1))

  ;; Feature `corfu-history' sorts candidates by their history position.
  (use-feature! corfu-history
    :demand t
    :config

    (corfu-history-mode +1))

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

;; Package `nerd-icons-corfu' adds icons to completions in Corfu. It uses
;; `nerd-icons` under the hood and, as such, works on both GUI and terminal
(use-package! nerd-icons-corfu
  :demand t
  :after corfu
  :config

  (push #'nerd-icons-corfu-formatter corfu-margin-formatters))

;;;; Syntax checking and code linting

;; Display the line in the visited source file 15 lines from the top.
(setopt next-error-recenter 15)

;; Highlight the current error message in the `next-error' buffer.
(setopt next-error-message-highlight t)

(set-leader-keys! "e s" #'next-error-select-buffer)

;; Feature `flymake' is a minor Emacs mode performing on-the-fly syntax checks.
;; Flymake collects diagnostic information for multiple sources, called
;; backends, and visually annotates the relevant portions in the buffer.
(use-feature! flymake
  :config

  (defvar-keymap flymake-repeat-map
    :doc "Support Flymake based navigation with repeats."
    :repeat (:hints ((flymake-goto-next-error . "next")
                     (flymake-goto-prev-error . "prev")))
    "n" #'flymake-goto-next-error
    "p" #'flymake-goto-prev-error)

  ;; Shorten Flymake lighter.
  (setopt flymake-mode-line-lighter "")

  ;; Use full diagnostic text rather than truncated output.
  (setopt flymake-diagnostic-format-alist
          '((:help-echo . (origin code message))
            (:eol . (oneliner))
            (:eldoc . (origin code message))
            (:eldoc-echo . (origin code message))
            (t . (origin code message))))

  (set-leader-keys!
    "e ?" #'flymake-running-backends
    "e b" #'flymake-start
    "e l" #'flymake-show-buffer-diagnostics
    "e L" #'flymake-show-project-diagnostics
    "e n" #'flymake-goto-next-error
    "e p" #'flymake-goto-prev-error
    "e S" #'flymake-switch-to-log-buffer
    "e v" #'flymake-reporting-backends
    "t s" #'flymake-mode)

  ;; Increase the idle time after Flymake will start a syntax check as 0.5s is
  ;; a bit too naggy.
  (setopt flymake-no-changes-timeout 5.0)

  ;; Suppress the display of Flymake counters when there are no errors or
  ;; warnings.
  (setopt flymake-suppress-zero-counters t))

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
  (setopt devdocs-data-dir (cache-dir "devdocs")))

;;;; Diff/Merge handling

;; Feature `diff-mode' provides support for font-lock, outline, navigation
;; commands, editing and various conversions as well as jumping to the
;; corresponding source file.
(use-feature! diff-mode
  :init

  (set-leader-keys-for-major-mode! 'diff-mode
    "a" #'diff-apply-hunk
    "A" #'diff-apply-buffer
    "d" #'diff-delete-other-hunks
    "e" #'diff-ediff-patch
    "f" #'next-error-follow-minor-mode
    "g" #'diff-refresh-hunk
    "n" #'diff-restrict-view
    "k" #'diff-revert-and-kill-hunk
    "r" #'diff-reverse-direction
    "s" #'diff-split-hunk
    "t" #'diff-test-hunk
    "u" #'diff-revert-and-kill-hunk
    "w" #'diff-ignore-whitespace-hunk)

  :bind ( :map diff-mode-map
          ("M-o" . nil))
  :config

  ;; Set `diff-mode' buffers as read-only.
  (setopt diff-default-read-only t)

  ;; Use reliable file-based syntax highlighting when available and hunk-based
  ;; syntax highlighting otherwise as a fallback.
  (setopt diff-font-lock-syntax 'hunk-also))

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
  (setopt ediff-split-window-function 'split-window-horizontally)

  ;; Set control panel in the same frame as ediff buffers.
  (setopt ediff-window-setup-function 'ediff-setup-windows-plain)

  ;; Prompt to remove unmodified buffers A/B/C at session end.
  (setopt ediff-keep-variants nil))

;; Feature `smerge-mode' provides a lightweight alternative to Emerge and Ediff.
(use-feature! smerge-mode
  :config

  ;; Keep the repeat map without duplicates.
  (keymap-unset smerge-repeat-map "m")
  (keymap-unset smerge-repeat-map "o")

  ;; Add hints to the existing repeat keymap.
  (put 'smerge-next 'repeat-hint "next")
  (put 'smerge-prev 'repeat-hint "prev")
  (put 'smerge-resolve 'repeat-hint "resolve")
  (put 'smerge-keep-upper 'repeat-hint "upper")
  (put 'smerge-keep-base 'repeat-hint "base")
  (put 'smerge-keep-lower 'repeat-hint "lower")
  (put 'smerge-keep-all 'repeat-hint "all")
  (put 'smerge-refine 'repeat-hint "Refine")
  (put 'smerge-combine-with-next 'repeat-hint "Combine")
  (put 'smerge-keep-current 'repeat-hint "current"))

;;; Language support
;;;; Tree-sitter

;; Feature `treesit' provides tree-sitter integration for Emacs. It contains
;; convenient functions that are more idiomatic and flexible than the exposed C
;; API of tree-sitter. It also contains frameworks for integrating tree-sitter
;; with font-lock, indentation, activating and deactivating tree-sitter,
;; debugging tree-sitter, etc.
(use-feature! treesit
  :demand t
  :config

  ;; Decoration level to be used by tree-sitter fontifications. Level 1 usually
  ;; contains only comments and definitions. Level 2 usually adds keywords,
  ;; strings, data types, etc. Level 3 usually represents full-blown
  ;; fontifications, including assignments, constants, numbers and literals,
  ;; etc. Level 4 adds everything else that can be fontified: delimiters,
  ;; operators, brackets, punctuation, all functions, properties, variables,
  ;; etc.
  (setopt treesit-font-lock-level 4)

  ;; Install tree-sitter language grammar libraries when needed without asking.
  (setopt treesit-auto-install-grammar 'always)

  ;; Enable selected tree-sitter modes by default.
  (setopt treesit-enabled-modes '(bash-ts-mode
                                  c-ts-mode
                                  c++-ts-mode
                                  c-or-c++-ts-mode
                                  cmake-ts-mode
                                  dockerfile-ts-mode
                                  json-ts-mode
                                  python-ts-mode
                                  ruby-ts-mode
                                  rust-ts-mode
                                  toml-ts-mode)))

;;;; C/C++

;; Feature `c-ts-mode' provides major mode for editing both C and C++, powered
;; by tree-sitter.
(use-feature! c-ts-mode
  :init

  (defhook! my--c-ts-mode-setup ()
    c-ts-mode-hook
    "Set custom settings for `c-ts-mode'."
    ;; Select C documents when inside `c-ts-mode' buffers.
    (setq-local devdocs-current-docs '("c")))

  (defhook! my--c++-ts-mode-setup ()
    c++-ts-mode-hook
    "Set custom settings for `c++-ts-mode'."
    ;; Select C++ documents when inside `c++-ts-mode' buffers.
    (setq-local devdocs-current-docs '("cpp")))

  (set-prefixes-for-major-mode! 'c-ts-mode "s" "session")
  (set-prefixes-for-major-mode! 'c++-ts-mode "s" "session")

  (set-leader-keys-for-major-mode! 'c-ts-mode "s s" #'eglot)
  (set-leader-keys-for-major-mode! 'c++-ts-mode "s s" #'eglot)

  :config

  (defun my--c-ts-mode-indent-style ()
    "Override the built-in BSD indentation style with some additional rules."
    (cond
     ((eq major-mode 'c-ts-mode)
      `((c
         ;; Align function arguments with the offset.
         ((match nil "argument_list") parent-bol c-ts-indent-offset)
         ;; Same for parameters.
         ((match nil "parameter_list") parent-bol c-ts-indent-offset)
         ;; Append to BSD style
         ,@(cdr (car (c-ts-mode--simple-indent-rules 'c 'bsd))))))
     ((eq major-mode 'c++-ts-mode)
      `((cpp
         ;; Align function arguments with the offset.
         ((match nil "argument_list") parent-bol c-ts-indent-offset)
         ;; Same for parameters.
         ((match nil "parameter_list") parent-bol c-ts-indent-offset)
         ;; Do not indent inside namespaces.
         ((n-p-gp nil nil "namespace_definition") grand-parent 0)
         ;; Append to BSD style
         ,@(cdr (car (c-ts-mode--simple-indent-rules 'cpp 'bsd))))))))

  ;; Set custom indent style based on BSD for both C and C++.
  (setopt c-ts-mode-indent-style 'my--c-ts-mode-indent-style)

  ;; Syntax-highlight Doxygen comment blocks.
  (setopt c-ts-mode-enable-doxygen t))

;;;; Fish

;; Package `fish-mode' provides a major mode for Fish shell scripts.
(use-package! fish-mode)

;;;; Jenkinsfile

;; Package `jenkinsfile-mode' provides a major mode for editing Jenkins
;; declarative pipeline files.
(use-package! jenkinsfile-mode
  :mode ("Jenkinsfile-" "\\.pipeline$"))

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
(use-package! markdown-toc)

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
    (setq-local fill-column 100)
    (display-fill-column-indicator-mode -1))

  (set-prefixes-for-major-mode! 'python-ts-mode "s" "session")
  (set-leader-keys-for-major-mode! 'python-ts-mode "s s" #'eglot))

;;;; Ruby

;; Feature `ruby-ts-mode' provides major mode for Ruby, powered by tree-sitter.
(use-feature! ruby-ts-mode
  :init

  (defhook! my--ruby-ts-mode-setup ()
    ruby-ts-mode-hook
    "Set custom settings for `ruby-ts-mode'."
    (setq-local fill-column 120)
    (setq-local indent-tabs-mode t)
    (display-fill-column-indicator-mode -1))

  (set-prefixes-for-major-mode! 'ruby-ts-mode "s" "session")
  (set-leader-keys-for-major-mode! 'ruby-ts-mode "s s" #'eglot))

;;;; Rust

;; Feature `rust-ts-mode' provides major mode for editing Rust, powered by
;; tree-sitter.
(use-feature! rust-ts-mode
  :init

  (defhook! my--rust-ts-mode-setup ()
    rust-ts-mode-hook
    "Set custom settings for `rust-ts-mode'."
    ;; Rust uses (by default) column limit of 100.
    (setq-local fill-column 100)
    ;; Select Rust documents when inside `rust-ts-mode' buffers.
    (setq-local devdocs-current-docs '("rust"))
    ;; Improve Imenu support.
    (setq-local treesit-simple-imenu-settings
                (let ((node-function-p #'my--rust-ts-mode--node-function-p)
                      (node-method-p #'my--rust-ts-mode--node-method-p))
                  `(("Constant" ,(rx bos (or "const_item"
                                             "static_item")
                                     eos) nil nil)
                    ("Enum" "\\`enum_item\\'" nil nil)
                    ("EnumMember" "\\`enum_variant\\'" nil nil)
                    ("Field" "\\`field_declaration\\'" nil nil)
                    ("Function" ,(rx bos (or "function_item"
                                             "function_signature_item"
                                             "macro_definition")
                                     eos) ,node-function-p nil)
                    ("Interface" "\\`trait_item\\'" nil nil)
                    ("Method" ,(rx bos (or "function_item"
                                           "function_signature_item")
                                   eos) ,node-method-p nil)
                    ("Module" "\\`mod_item\\'" nil nil)
                    ("Object" "\\`impl_item\\'" nil nil)
                    ("Struct" "\\`struct_item\\'" nil nil)
                    ("TypeParameter" ,(rx bos (or "type_item"
                                                  "associated_type")
                                          eos) nil nil))))
    ;; Improve Outline support.
    (setq-local treesit-outline-predicate
                'treesit-outline-predicate--from-imenu)
    ;; Improve navigation support.
    (setq-local treesit-defun-type-regexp
                (regexp-opt '("enum_item"
                              "function_item"
                              "function_signature_item"
                              "impl_item"
                              "macro_definition"
                              "struct_item"
                              "trait_item")))
    ;; Improve the builtin Imenu with additional nodes
    (setq-local treesit-defun-name-function #'my--rust-ts-mode--defun-name))

  (defun my--rust-ts-mode--node-method-p (node)
    "Return non-nil if NODE is a Rust method.
NODE should be a tree-sitter function node with a `parameters' field."
    (when-let*
        ((parameters (treesit-node-child-by-field-name node "parameters"))
         (parameter (treesit-node-child parameters 0 t)))
      (or (equal (treesit-node-type parameter) "self_parameter")
          (and (equal (treesit-node-type parameter) "parameter")
               (when-let* ((receiver (treesit-node-child parameter 0 t)))
                 (equal (treesit-node-type receiver) "self"))))))

  (defun my--rust-ts-mode--node-function-p (node)
    "Return non-nil if NODE is a Rust function and not a method."
    (not (my--rust-ts-mode--node-method-p node)))

  (defun my--rust-ts-mode--defun-name (node)
    "Return the defun name of NODE.
Return nil if there is no name or if NODE is not a defun node."
    (cl-flet
        ((treesit-field-text (node field)
           (treesit-node-text (treesit-node-child-by-field-name node field) t))
         (treesit-node-grandparent (node)
           (let ((grandparent (treesit-node-parent (treesit-node-parent node))))
             (unless (equal (treesit-node-type grandparent) "mod_item")
               grandparent)))
         (join (&rest parts) (string-join (delq nil parts) " ")))
      (pcase (treesit-node-type node)
        ((or "function_item"
             "function_signature_item"
             "type_item")
         (let* ((grandparent (treesit-node-grandparent node))
                (trait-text (treesit-field-text grandparent "trait"))
                (type-text (treesit-field-text grandparent "type"))
                (name-text (treesit-field-text grandparent "name")))
           (join (when trait-text "impl") trait-text
                 (when type-text (if trait-text "for" "impl")) type-text
                 name-text (treesit-field-text node "name"))))
        ("impl_item"
         (let ((trait-text (treesit-field-text node "trait")))
           (join "impl" trait-text
                 (when trait-text "for") (treesit-field-text node "type"))))
        ((or "const_item"
             "macro_definition"
             "static_item"
             "trait_item")
         (treesit-field-text node "name"))
        ((or "associated_type"
             "enum_variant"
             "field_declaration")
         (let ((grandparent (treesit-node-grandparent node)))
           (join (treesit-field-text grandparent "name")
                 (treesit-field-text node "name"))))
        (_ (rust-ts-mode--defun-name node)))))

  (set-prefixes-for-major-mode! 'rust-ts-mode "s" "session")
  (set-leader-keys-for-major-mode! 'rust-ts-mode "s s" #'eglot)

  :config

  ;; Fontify suffixes of number literals as types.
  (setopt rust-ts-mode-fontify-number-suffix-as-type t)

  (with-eval-after-load 'consult-imenu
    ;; Update `consult-imenu' with the symbol categories for Rust.
    (add-to-list 'consult-imenu-config
                 '(rust-ts-mode
                   :types ((?e "Enum" font-lock-type-face)
                           (?E "EnumMember" font-lock-type-face)
                           (?F "Field" font-lock-property-name-face)
                           (?f "Function" font-lock-function-name-face)
                           (?i "Interface" font-lock-type-face)
                           (?k "Constant" font-lock-constant-face)
                           (?m "Method" font-lock-function-name-face)
                           (?M "Module" font-lock-constant-face)
                           (?o "Object" font-lock-type-face)
                           (?s "Struct" font-lock-type-face)
                           (?t "TypeParameter" font-lock-type-face)))))

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
            :rustfmt ( :extraArgs ["+nightly"]
                       :rangeFormatting (:enable t))
            :workspace (:symbol (:search (:kind "all_symbols")))
            :check (:command "check")))))

    (with-eval-after-load 'eglot-x
      (set-prefixes-for-minor-mode! 'eglot--managed-mode
        "b" "build"
        "o" "open")

      (set-leader-keys-for-minor-mode! 'eglot--managed-mode
        ;; Code actions
        "a h" #'eglot-x-hover-actions
        "a m" #'eglot-x-expand-macro
        "a r" #'eglot-x-ask-runnables
        "a t" #'eglot-x-ask-related-tests

        ;; Build
        "b m" #'eglot-x-rebuild-proc-macros

        ;; Goto
        "g R" #'eglot-x-find-refs
        "g S" #'eglot-x-find-workspace-symbol

        ;; Help
        "h m" #'eglot-x-view-recursive-memory-layout

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
  :hook (sh-mode-hook . flymake-mode)
  :config

  ;; Set the default indentation.
  (setopt sh-basic-offset 2)

  ;; Always indent relative to the continued line's beginning.
  (setopt sh-indent-after-continuation 'always)

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
(use-package! git-modes
  :mode ("/git/config-\\ca*\\'" . gitconfig-mode))

;; Package `nix-ts-mode' provides major mode for editing Nix expressions,
;; powered by tree-sitter.
(use-package! nix-ts-mode
  :mode ("\\.nix\\'")
  :config

  (add-to-list
   'treesit-language-source-alist
   '(nix "https://github.com/nix-community/tree-sitter-nix"))

  (treesit-ensure-installed 'nix))

;; Package `pkgbuild-mode' provides a major mode for PKGBUILD files used by Arch
;; Linux and derivatives.
(use-package! pkgbuild-mode)

;; Package `ssh-config-mode' provides major modes for files in ~/.ssh.
(use-package! ssh-config-mode)

;; Feature `toml-ts-mode' provides major mode for editing TOML, powered by
;; tree-sitter
(use-feature! toml-ts-mode
  :init

  (set-prefixes-for-major-mode! 'toml-ts-mode "s" "session")
  (set-leader-keys-for-major-mode! 'toml-ts-mode "s s" #'eglot))

;; Package `yaml-mode' provides a major mode for YAML.
(use-package! yaml-mode)

;;; Language servers

;; Package `consult-eglot' provides an alternative of the built-in
;; `xref-appropos' which provides as you type completion.
(use-package! consult-eglot
  :ensure (:files (:defaults "extensions/consult-eglot-embark/*"))
  :demand t
  :after (consult eglot xref)
  :bind ( :map eglot-mode-map
          ([remap xref-find-apropos] . #'consult-eglot-symbols))

  :config

  ;; Slightly modify keys and correct few typos in the default value.
  (setopt consult-eglot-narrow
          '((?a . "Array")
            (?B . "Boolean")
            (?c . "Class")
            (?C . "Constructor")
            (?e . "Enum")
            (?E . "EnumMember")
            (?F . "Field")
            (?f . "Function")
            (?i . "Interface")
            (?k . "Constant")
            (?m . "Method")
            (?M . "Module")
            (?n . "Namespace")
            (?N . "Number")
            (?o . "Object")
            (?O . "Other")
            (?P . "Package")
            (?p . "Property")
            (?s . "Struct")
            (?S . "String")
            (?t . "TypeParameter")
            (?v . "Variable")))

  (set-leader-keys-for-minor-mode! 'eglot--managed-mode
    "g s" #'consult-eglot-symbols)

  (consult-customize
   ;; Disable the automatic preview where the preview may be expensive due to
   ;; file loading.
   consult-eglot-symbols
   :preview-key '(:debounce 0.4 any))

  ;; Feature `consult-eglot-embark' provides Embark goto symbol and export
  ;; suppport.
  (use-feature! consult-eglot-embark
    :demand t
    :config

    (consult-eglot-embark-mode +1)))

;; Feature `eglot' is the Emacs client for the Language Server Protocol (LSP).
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
(use-feature! eglot
  :init

  ;; Increase the amount of data which Emacs reads from the process. The Emacs
  ;; default is too low (4k) considering that the some of the language server
  ;; responses are in 800k - 3M range.
  (setq read-process-output-max (* 1024 1024 4))

  ;; Inhibit logging a JSONRPC-related events.
  (fset #'jsonrpc--log-event #'ignore)

  :bind ( :map eglot-mode-map
          ("<f5>" . #'eglot-momentary-inlay-hints))
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
    "g c" #'eglot-show-call-hierarchy
    "g d" #'eglot-find-declaration
    "g e" #'flymake-show-project-diagnostics
    "g g" #'xref-find-definitions
    "g i" #'eglot-find-implementation
    "g r" #'xref-find-references
    "g t" #'eglot-find-typeDefinition
    "g T" #'eglot-show-type-hierarchy

    ;; Help
    "h h" #'eldoc-doc-buffer

    ;; Refactor
    "r r" #'eglot-rename

    ;; Session
    "s d" #'eglot-describe-connection
    "s e" #'eglot-events-buffer
    "s E" #'eglot-stderr-buffer
    "s f" #'eglot-forget-pending-continuations
    "s l" #'eglot-list-connections
    "s q" #'eglot-shutdown
    "s Q" #'eglot-shutdown-all
    "s r" #'eglot-reconnect

    ;; Toggle
    "t i" #'eglot-inlay-hints-mode
    "t s" #'eglot-semantic-tokens-mode)

  ;; Filter list of possible completions with Orderless.
  (setopt completion-category-overrides '((eglot (styles orderless))
                                          (eglot-capf (styles orderless))))

  ;; Increase the idle time after Eglot will notify servers of any changes.
  (setopt eglot-send-changes-idle-time 5.0)

  ;; Activate Eglot in referenced non-project files.
  (setopt eglot-extend-to-xref t)

  ;; Use *Messages* buffer to show progress.
  (setopt eglot-report-progress 'messages)

  ;; Do not hint about code actions at point.
  (setopt eglot-code-action-indications nil)

  ;; Disable Eglot events buffer, increase it only when debugging is needed.
  (setopt eglot-events-buffer-config '(:size 0))

  ;; Make the inlay hints a bit smaller.
  (set-face-attribute 'eglot-inlay-hint-face nil :height 0.7))

;; Package `eglot-booster' enables Eglot to use emacs-lsp-booster which is a
;; rust-based wrapper program which substantially speeds up Emacs interactions
;; with LSP servers
(use-package! eglot-booster
  :ensure (:host github :repo "jdtsmith/eglot-booster")
  :demand t
  :after eglot
  :config

  ;; Do not translate JSON into bytecode but still perform I/O buffering."
  (setopt eglot-booster-io-only t)

  (eglot-booster-mode +1))

;; Package `eglot-hover' provides a minor mode to improve Eglot's default hover
;; messages.
(use-package! eglot-hover
  :ensure (:host codeberg :repo "slotThe/eglot-hover")
  :demand t
  :after eglot
  :config

  (defhook! my--eglot-hover-mode-setup ()
    eglot-managed-mode-hook
    "Turn on or off `eglot-hover-mode', depending on the Eglot state."
    (if (eglot-managed-p)
        (eglot-hover-mode +1)
      (eglot-hover-mode -1)))

  (set-leader-keys-for-minor-mode! 'eglot--managed-mode
    "t h" #'eglot-hover-mode)

  ;; Associate powered by tree-sitter modes with code block names.
  (setopt eglot-hover-assocs '((c-ts-mode . "cpp")
                               (c++-ts-mode . "cpp")
                               (c-or-c++-ts-mode . "cpp")
                               (python-ts-mode . "python")
                               (rust-ts-mode . "rust"))))

;; Package `eglot-x' adds support for some of Language Server Protocol
;; extensions.
(use-package! eglot-x
  :ensure (:host github :repo "nemethf/eglot-x")
  :demand t
  :after eglot
  :config

  (defun eglot-x--runnable-dir (runnable)
    "Return working directory for RUNNABLE."
    (eglot--dbind ((Runnable) label kind args)
                  runnable
                  (or (plist-get args :workspaceRoot)
                      (plist-get args :cwd)
                      default-directory)))

  ;; Disable experimental SnippetTextEdits as they work incorrectly with
  ;; comments that have backticks.
  (setopt eglot-x-enable-snippet-text-edit nil)

  ;; Put hover actions at the top of Eldoc buffer.
  (setopt eglot-x-hover-actions-priority 80)

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
         ([remap describe-command]  . #'helpful-command))

  :config

  (with-eval-after-load 'ibuffer
    (add-to-list 'ibuffer-help-buffer-modes 'helpful-mode)))

;;;; Emacs Lisp development

;; Feature `elisp-mode' provides the major mode for Emacs Lisp.
(use-feature! elisp-mode
  :config

  ;; Highlight symbols according to their semantic meaning.
  (setopt elisp-fontify-semantically t
          elisp-add-help-echo nil)

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
;;;; Large Language Models

;; Package `agent-shell' is a native Emacs shell to interact with LLM agents
;; powered by Agent Client Protocol. With `agent-shell', you can chat with the
;; likes of Gemini CLI, Claude Code, Mistral Vibe, or any other ACP-driven
;; agent.
(use-package! agent-shell
  :init

  (set-leader-keys!
    "a s" #'agent-shell)

  :config

  ;; ;; Prefer viewport interaction over shell interaction.
  ;; (setopt agent-shell-prefer-viewport-interaction t)

  ;; Use OpenCode as a default provider.
  (setopt agent-shell-preferred-agent-config
          (agent-shell-opencode-make-agent-config))

  ;; Always prompt to choose a session or start a new one.
  (setopt agent-shell-session-strategy 'prompt)

  ;; Display a formatted box showing token counts, context window usage, and
  ;; cost information after each agent response.
  (setopt agent-shell-show-usage-at-turn-end t))

;; Package `gptel' provides a simple Large Language Model chat client for Emacs,
;; offering support for multiple models and backends. It integrates seamlessly
;; with Emacs, remaining accessible at any time and working uniformly across
;; buffers.
(use-package! gptel
  :init

  (set-leader-keys!
    "a a" #'gptel
    "a c" #'gptel-add
    "a f" #'gptel-add-file
    "a m" #'gptel-menu
    "a r" #'gptel-rewrite)

  (with-eval-after-load 'embark
    (keymap-set embark-region-map "+" #'gptel-add))

  :bind ( :map gptel-mode-map
          ("C-<return>" . #'gptel-menu)
          ("C-c C-g"    . #'gptel-abort))
  :config

  (set-leader-keys!
    "a C" #'gptel-context-remove-all)

  ;; Configure GitHub Copilot as the backend provider.
  (setopt gptel-backend '(gptel-gh "Copilot"))

  ;; Set Gemini 3.1 Pro as the default model.
  (setopt gptel-model 'gpt-5.4)

  ;; Enable advanced options in `gptel-menu'.
  (setopt gptel-expert-commands t)

  ;; Configure builtin `markdown-ts-mode' instead of requiring `markdown-mode'.
  ;; (setopt gptel-default-mode 'markdown-ts-mode)
  ;; (setopt gptel-prompt-prefix-alist
  ;;         '((markdown-ts-mode . "### ")
  ;;           (org-mode . "*** ")
  ;;           (text-mode . "### ")))
  ;; (setopt gptel-response-prefix-alist
  ;;         '((markdown-ts-mode . "")
  ;;           (org-mode . "")
  ;;           (text-mode . "")))

  ;; Do not litter `user-emacs-directory' with copilot tokens.
  (setopt gptel-gh-github-token-file (cache-dir "copilot-chat/github-token"))
  (setopt gptel-gh-token-file (cache-dir "copilot-chat/token")))

;; Package `gptel-agent' is a collection of tools and prompts to use gptel
;; “agentically” with any LLM, to autonomously perform tasks.
(use-package! gptel-agent
  :demand t
  :after gptel
  :config

  ;; Read files from agents directories.
  (gptel-agent-update))

;; Package `gptel-prompts' offers an alternative way to manage your
;; `gptel-directives' variable, using files rather than customizing the variable
;; directly.
(use-package! gptel-prompts
  :ensure (:host github :repo "jwiegley/gptel-prompts")
  :demand t
  :after gptel
  :config

  ;; Use ~/.local/emacs/prompts directory.
  (setopt gptel-prompts-directory (data-dir "prompts"))

  (gptel-prompts-update)

  ;; Ensure prompts are updated if prompt files change
  (gptel-prompts-add-update-watchers))

;; Package `gptel-quick' is a tiny everyday helper for easily looking up or
;; summarizing text using an LLM. It provides one command. Call `gptel-quick' to
;; show a short summary or explanation of the word at point, or an active
;; region, in a popup. This is useful for quickly looking up names, words,
;; phrases, or summarizing/explaining prose or snippets of code, with minimal
;; friction:
(use-package! gptel-quick
  :ensure (:host github :repo "karthink/gptel-quick")
  :init

  (set-leader-keys! "a ?" #'gptel-quick)

  (with-eval-after-load 'embark
    (keymap-set embark-general-map "?" #'gptel-quick))

  :config

  ;; Display results in echo area.
  (setopt gptel-quick-display nil))

;; Package `llm-tool-collection' provides a crowd-sourced collection of tools to
;; empower Large Language Models in Emacs.
(use-package! llm-tool-collection
  :ensure (:host github :repo "skissue/llm-tool-collection")
  :demand t
  :after gptel
  :config

  ;; Register all tools.
  (mapcar (apply-partially #'apply #'gptel-make-tool)
          (llm-tool-collection-get-all)))

;;;; Organisation

;; Skip building Org manual.
(setopt elpaca-menu-org-make-manual nil)

;; Package `org' provides too many features to describe in any reasonable amount
;; of space. It is built fundamentally on `outline-mode', and adds TODO states,
;; deadlines, properties, priorities, etc. to headings. Then it provides tools
;; for interacting with this data, including an agenda view, a time clocker,
;; etc.
(use-feature! org
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
  (setopt org-directory (data-dir "org"))

  ;; Show headlines but not content by default.
  (setopt org-startup-folded 'content)

  ;; Hide the first N-1 stars in a headline.
  (setopt org-hide-leading-stars t)

  ;; Do not adapt indentation to outline node level.
  (setopt org-adapt-indentation nil)

  ;; Use cornered arrow instead of three dots to increase its visibility.
  (setopt org-ellipsis "⤵")

  ;; Require braces in order to trigger interpretations as sub/superscript. This
  ;; can be helpful in documents that need "_" frequently in plain text.
  (setopt org-use-sub-superscripts '{})

  ;; Make `mwim' behaving like it should in Org.
  (setopt org-special-ctrl-a/e t)

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

  (defadvice! my--find-file-read-args (fn &rest args)
    :around #'find-file-read-args
    "Use `default-directory' of the current Dired directory."
    (if (derived-mode-p #'dired-mode)
        (let ((default-directory (dired-current-directory)))
          (apply fn args))
      (apply fn args)))

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
    "A d" #'dired
    "j d" #'dired-jump)

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

  ;; Automatically revert Dired buffers after `dired-do' operations.
  (setopt dired-do-revert-buffer t)

  ;; Copy directories recursively.
  (setopt dired-recursive-copies 'always)

  ;; Hide free space label at the top
  (setopt dired-free-space nil)

  ;; Create destination dirs when copying/removing files without asking.
  (setopt dired-create-destination-dirs 'always)

  ;; Consider a file name ending in a slash as a directory to create.
  (setopt dired-create-destination-dirs-on-trailing-dirsep t)

  ;; Let `dired-create-empty-file' act on the current directory.
  (setopt dired-create-empty-file-in-current-directory t)

  ;; Search file names with Isearch when initial point position is on a file
  ;; name.
  (setopt dired-isearch-filenames 'dwim)

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
  :ensure (:host github :repo "jsilve24/dired-copy-paste")
  :after dired
  :commands (dired-copy-paste-do-cut
             dired-copy-paste-do-copy
             dired-copy-paste-do-paste)
  :bind ( :map dired-mode-map
          ("C-c C-w" . #'dired-copy-paste-do-cut)
          ("C-c C-c" . #'dired-copy-paste-do-copy)
          ("C-c C-y" . #'dired-copy-paste-do-paste)))

;; Package `diredfl' provides extra font lock rules for a more colourful
;; `dired'.
(use-package! diredfl
  :hook (dired-mode-hook . diredfl-mode))

;; Package `nerd-icons-dired' shows icons for each file in Dired,
(use-package! nerd-icons-dired
  :hook (dired-mode-hook . nerd-icons-dired-mode))

;;;; Processes

(set-leader-keys! "A p" #'list-processes)

;; Feature `proced' makes an Emacs buffer containing a listing of the current
;; system processes. You can use the normal Emacs commands to move around in
;; this buffer, and special Proced commands to operate on the processes listed.
(use-feature! proced
  :init
  (set-leader-keys! "A P" #'proced)

  :config

  ;; Auto update a Proced buffer.
  (setq proced-auto-update-flag t)

  ;; Display some process attributes with color.
  (setq proced-enable-color-flag t))

;;;; Version control

;; Feature `log-edit' is used by VC for entering commit messages.
(use-feature! log-edit
  :config

  (defun log-edit-extract-ticket-name (branch)
    "Extract ticket name from BRANCH."
    (let ((pattern (concat (user-login-name)
                           "/\\([[:alpha:]]+-[[:digit:]]+\\)")))
      (when (string-match-p pattern branch)
        (upcase (replace-regexp-in-string pattern "[\\1] " branch)))))

  (defun log-edit-get-current-branch ()
    "Returns current branch (for Git) or bookmark (for JJ)."
    (cond
     ((eq log-edit-vc-backend 'Git)
      (vc-git--current-branch))
     ((eq log-edit-vc-backend 'JJ)
      (car (last (vc-jj--process-lines
                  nil "log" "--no-graph"
                  "-r" "closest_bookmark(@)"
                  "-T" "local_bookmarks.map(|b| b.name())"))))))

  (defun log-edit-insert-jira-ticket ()
    "Insert the ticket name in the commit buffer if feasible."
    (when-let* ((ticket (log-edit-extract-ticket-name
                         (or (log-edit-get-current-branch) ""))))
      (insert ticket)
      (end-of-line -1)
      (end-of-line)))

  (defhook! my--log-edit-mode-setup ()
    log-edit-mode-hook
    "Set custom settings for `log-edit-mode'."
    (setq-local fill-column 72)
    (auto-fill-mode +1)
    (display-fill-column-indicator-mode +1))

  ;; Remove unnecessary hook functions and show diff by default.
  (setopt log-edit-hook '(log-edit-insert-message-template
                          log-edit-insert-jira-ticket
                          log-edit-maybe-show-diff)))

;; Feature `vc' allows you to use a version control system from within Emacs,
;; integrating the version control operations smoothly with editing. It provides
;; a uniform interface for common operations in many version control operations.
(use-feature! vc
  :init

  ;; Disable almost all VC backends to improve performance.
  (setopt vc-handled-backends '(Git))

  :bind ( :map vc-prefix-map
          ("RET" . #'vc-dir-root)
          ("e"   . #'vc-ediff)
          ("F"   . #'vc-update)
          ("l"   . #'vc-print-change-log)
          ("L"   . #'vc-print-root-change-log)
          ("k"   . #'vc-revert))

  :config

  ;; `C-x v I' and `C-x v O' become prefix commands with log and diff command.
  (setopt vc-use-incoming-outgoing-prefixes t)

  ;; Prompt to allow VCS operations that may rewrite published history.
  (setopt vc-allow-rewriting-published-history 'ask)

  ;; Feature `vc-dir' provides a directory status display under VC.
  (use-feature! vc-dir
    :init

    (defadvice! my--vc-dir-hide-state-silent
        (vc-dir-hide-state &rest args)
      :around #'vc-dir-hide-state
      "Make `vc-dir-hide-state' silent when used with default argument."
      (if (car args)
          (apply vc-dir-hide-state args)
        (advice-silence-messages! vc-dir-hide-state args)))

    :bind ( :map vc-dir-mode-map
            ("M-s" . nil)
            ("e"   . #'vc-ediff)
            ("F"   . #'vc-update)
            ("k"   . #'vc-revert))

    :config

    ;; Hide items whenever their state would change to 'up-to-date' or
    ;; 'ignored'.
    (setopt vc-dir-auto-hide-up-to-date t)))

;;;;; Git

;; Feature `vc-git' contains a VC backend for the git version control system.
(use-feature! vc-git
  :bind ( :map vc-dir-git-mode-map
          ("z a" . #'vc-git-stash-apply)
          ("z k" . #'vc-git-stash-delete))
  :config

  ;; Column beyond which characters in the summary lines are highlighted.
  (setopt vc-git-log-edit-summary-target-len 50)

  ;; Show stat output in git log
  (setopt vc-git-log-switches '("--stat")))

;; Package `browse-at-remote' easily opens target page on github/gitlab (or
;; bitbucket) from Emacs by calling `browse-at-remote` function. Supports Dired
;; buffers and opens them in tree mode at destination.
(use-package! browse-at-remote
  :init

  (defun browse-at-remote-dwim (arg)
    "Call `browse-at-remote' with `browse-at-remote-prefer-symbolic' reversed
if called with universal argument."
    (interactive "P")
    (if arg
        (let ((browse-at-remote-prefer-symbolic
               (not browse-at-remote-prefer-symbolic)))
          (browse-at-remote))
      (browse-at-remote)))

  (defun browse-at-remote-kill-dwim (arg)
    "Call `browse-at-remote-kill' with `browse-at-remote-prefer-symbolic'
reversed if called with universal argument."
    (interactive "P")
    (if arg
        (let ((browse-at-remote-prefer-symbolic
               (not browse-at-remote-prefer-symbolic)))
          (browse-at-remote-kill))
      (browse-at-remote-kill))
    ;; Prevent URL escapes from being interpreted as format strings.
    (message (replace-regexp-in-string "%" "%%" (car kill-ring) t t)))

  (set-leader-keys!
    "g r" #'browse-at-remote-dwim
    "g R" #'browse-at-remote-kill-dwim)

  (with-eval-after-load 'magit
    (defadvice! my--browse-at-remote-with-magit-blob-mode (fn)
      :around #'browse-at-remote-get-url
      "Allow `browse-at-remote' commands in `magit-blob-mode' buffers to open
that file in your browser at the visited revision."
      (if magit-blob-mode
          (let* ((filename magit-buffer-file-name)
                 (remote-ref (browse-at-remote--remote-ref filename))
                 (remote (car remote-ref))
                 (ref magit-buffer-revision)
                 (relname (f-relative filename (f-expand
                                                (vc-git-root filename))))
                 (target-repo (browse-at-remote--get-url-from-remote remote))
                 (remote-type (browse-at-remote--get-remote-type
                               (plist-get target-repo :unresolved-host)))
                 (repo-url (plist-get target-repo :url))
                 (url-formatter (browse-at-remote--get-formatter 'region-url
                                                                 remote-type))
                 (start (and (use-region-p) (min (region-beginning)
                                                 (region-end))))
                 (point-end (and (use-region-p) (max (region-beginning)
                                                     (region-end))))
                 (end (when point-end (if (eq (char-before point-end) ?\n)
                                          (- point-end 1)
                                        point-end)))
                 (start-line (when start (line-number-at-pos start)))
                 (end-line (when end (line-number-at-pos end)))
                 (line
                  (when browse-at-remote-add-line-number-if-no-region-selected
                    (line-number-at-pos (point)))))
            (unless url-formatter
              (error (format "Origin repo parsing failed: %s" repo-url)))

            (funcall url-formatter repo-url ref relname
                     (or start-line line)
                     (when (and end-line (not (equal start-line end-line)))
                       end-line)))
        (funcall fn))))

  :config

  ;; Add gitsource to the list of supported domains.
  (push '(:host "^gitsource" :type "stash")
        browse-at-remote-remote-type-regexps)
  (push '(:host "git.source.akamai.com" :type "stash")
        browse-at-remote-remote-type-regexps)

  (defadvice! my--browse-at-remote--fix-repo-url-stash (args)
    :filter-args #'browse-at-remote--fix-repo-url-stash
    "Modify SSH alias into full HTTPS domain."
    (list (replace-regexp-in-string "gitsource\\(-mirror\\)?"
                                    "git.source.akamai.com" (s-join "" args))))

  ;; Use commit hash for link rather than branch names.
  (setopt browse-at-remote-prefer-symbolic nil))

;; Package `consult-ls-git' allows to quickly select a file from a git
;; repository or act on a stash. It provides a consult multi view of files
;; considered by git status, stashes as well as all tracked files. Alternatively
;; you can narrow to a specific section via the shortcut key.
(use-package! consult-ls-git
  :init

  (set-leader-keys! "g f" #'consult-ls-git))

;; Package `diff-hl' highlights uncommitted changes on the side of the window,
;; allows you to jump between and revert them selectively. This feature is also
;; known as "source control gutter indicators". In buffers controlled by Git,
;; you can stage and unstage the changes.
(use-package! diff-hl
  :init

  (set-leader-keys!
    "g ." #'diff-hl-show-hunk
    "g n" #'diff-hl-revert-hunk
    "g S" #'diff-hl-stage-dwim)

  :hook (((text-mode-hook prog-mode-hook conf-mode-hook) . diff-hl-mode)
         (vc-dir-mode-hook . diff-hl-dir-mode))

  :bind (("M-g ]" . #'diff-hl-next-hunk)
         ("M-g [" . #'diff-hl-previous-hunk))
  :config

  (with-eval-after-load 'magit
    (add-hook #'magit-post-refresh-hook #'diff-hl-magit-post-refresh))

  ;; Run `diff-hl' updates asynchronously.
  (setopt diff-hl-update-async t)

  ;; Disable `diff-hl' in remote buffers.
  (setopt diff-hl-disable-on-remote t)

  ;; Recenter after jumping to hunks.
  (setopt diff-hl-next-previous-hunk-auto-recenter t)

  ;; Inline popup is shown over the hunk, hiding it.
  (setopt diff-hl-show-hunk-inline-hide-hunk t)

  ;; Show both deleted and new lines.
  (setopt diff-hl-show-hunk-inline-smart-lines nil)

  ;; Toggle displaying `diff-hl-mode' highlights on the margin.
  (diff-hl-margin-mode +1)

  ;; Enable margin to show a popup with vc diffs when clicked.
  (global-diff-hl-show-hunk-mouse-mode +1))

;; Package `magit' provides a full graphical interface for Git within Emacs.
;; Disable default keybindings.
(setq magit-define-global-key-bindings nil)
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

    (defun git-commit-extract-ticket-name (branch-name)
      "Extract ticket name from BRANCH-NAME."
      (let ((ticket-pattern (concat (user-login-name)
                                    "/\\([[:alpha:]]+-[[:digit:]]+\\)")))
        (when (string-match-p ticket-pattern branch-name)
          (upcase (replace-regexp-in-string ticket-pattern
                                            "[\\1] " branch-name)))))

    (defun git-commit-insert-ticket-name ()
      "Insert the ticket name in the commit buffer if feasible."
      (when-let ((tag (git-commit-extract-ticket-name
                       (magit-get-current-branch))))
        (unless (string-search tag (or (git-commit-buffer-message) ""))
          (insert tag))))

    (defhook! my--git-commit-mode-setup ()
      git-commit-mode-hook
      "Set custom settings for `git-commit-mode'."
      (setq-local fill-column 72)
      (auto-fill-mode +1)
      (display-fill-column-indicator-mode +1)
      (git-commit-insert-ticket-name))

    ;; List of checks performed by `git-commit'.
    (setq git-commit-style-convention-checks '(non-empty-second-line
                                               overlong-summary-line))

    ;; Column beyond which characters in the summary lines are highlighted.
    (setopt git-commit-summary-max-length 50)

    ;; Use a local message ring so that every repository gets its own commit
    ;; message ring.
    (setopt git-commit-use-local-message-ring t))

  ;; Suppress messages about updating margins.
  (advice-add #'magit-margin-set-variable :around #'advice-silence-messages!)

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

  :config

  ;; Show fine differences for all displayed diff hunks.
  (setopt magit-diff-refine-hunk 'all)

  ;; The default location for git-credential-cache is in
  ;; ~/.config/git/credential. However, if ~/.git-credential-cache/ exists, then
  ;; it is used instead. Magit seems to be hardcoded to use the latter, so here
  ;; we override it to have more correct behavior.
  (require 'xdg)
  (setopt magit-credential-cache-daemon-socket (expand-file-name
                                                "git/credential/socket"
                                                (xdg-cache-home)))

  ;; Display Magit buffers in the entire frame when displaying a status buffer.
  (setopt magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)

  ;; Don't try to save unsaved buffers when using Magit. We know perfectly well
  ;; that we need to save our buffers if we want Magit to see them.
  (setopt magit-save-repository-buffers nil)

  ;; Use `nerd-icons' when formatting lines representing a file.
  (setopt magit-format-file-function #'magit-format-file-nerd-icons)

  ;; Sort refs by their committer dates.
  (setopt magit-list-refs-sortby '("-committerdate" "-HEAD"))

  ;; Use absolute dates when showing logs.
  (setopt magit-log-margin '(t "%d-%m-%Y %H:%M " magit-log-margin-width t 18))

  ;; Insert worktrees section (only with more than one worktree) just after the
  ;; status section.
  (setcdr magit-status-sections-hook
          (push 'magit-insert-worktrees (cdr magit-status-sections-hook))))

;; Package `magit-blame-color-by-age' colors Magit-blame headers by age.
(use-package! magit-blame-color-by-age
  :ensure (:host github :repo "jdtsmith/magit-blame-color-by-age")
  :hook (magit-blame-mode-hook . magit-blame-color-by-age-mode))

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

  :hook (magit-mode-hook . magit-delta-mode))

;; Package `magit-todos' displays keyword entries from source code comments and
;; Org files in the Magit status buffer. Activating an item jumps to it in its
;; file.
(use-package! magit-todos
  :init

  (set-prefixes! "g t" "todos")

  (set-leader-keys!
    "g t t" #'magit-todos-list
    "g t m" #'magit-todos-mode))

;; Package `transient' is the interface used by Magit to display popups.
(use-package! transient
  :functions transient-bind-q-to-quit
  :config

  ;; Show all possible options in transient windows.
  (setopt transient-default-level 7)

  ;; Pop up transient windows at the bottom of the window where it was invoked.
  (setopt transient-display-buffer-action
          '(display-buffer-below-selected
            (dedicated . t)
            (inhibit-same-window . t))
          transient-show-during-minibuffer-read t)

  ;; Do not litter `user-emacs-directory' with transient files.
  (setopt transient-levels-file (cache-dir "transient/levels.el")
          transient-values-file (cache-dir "transient/values.el")
          transient-history-file (cache-dir "transient/history.el"))

  ;; Allow using `q' to quit out of popups, in addition to `C-g'.
  (transient-bind-q-to-quit))

;;;;; Jujutsu

;; Package `majutsu' provides a Magit-style interface for Jujutsu, offering an
;; efficient way to interact with JJ repositories from within Emacs.
(use-package! majutsu
  :ensure (:host github :repo "0WD0/majutsu")
  :init

  ;; Suppress messages about redefining template helpers.
  (advice-add #'majutsu-template--register-function
              :around #'advice-silence-messages!)

  (defadvice! my--majutsu-log-load-magit (&rest _)
    :before #'majutsu-log
    "Run `majutus-log' with correct autoload."
    (require 'magit))

  (defun majutsu-project-log ()
    "Run `majutsu-log' in the current project's root."
    (interactive)
    (majutsu-log (project-root (project-current t))))

  (set-leader-keys! "g j" #'majutsu-log))

;; Package `vc-jj' includes support for the Jujutsu version control system.
(use-package! vc-jj
  :config

	(defun vc-jj-project-list-files (dir extra-ignores)
	  "List all files in directory DIR.
	Do not include files matching glob patterns in EXTRA-IGNORES in the
	result.

	This function is called by `project-files' as of project.el 0.11.2.  The
	value of EXTRA-IGNORES comes from the variable `project-vc-ignores'.

	If EXTRA-IGNORES is non-nil, this implementation falls back to a generic
	implementation."
	  (if extra-ignores
	      ;; Same fallback as in project.el for git <= 2.13.  Note:
	      ;; currently includes the contents of the `.jj' directory so we
	      ;; don't want to merge this as-is.
	      ;; TODO: handle extra-ignores parameter better -- rewrite each
	      ;; element e to be `~root-glob:"e"' and use `&' to combine them?
	      (vc-default-project-list-files 'JJ dir extra-ignores)
	    (let* ((default-directory (expand-file-name (vc-jj-root dir)))
	           (args (list "--" (file-relative-name dir)))
	           (files (apply #'vc-jj--process-lines nil "file" "list" args)))
	      (mapcar #'expand-file-name files))))

  (cl-defmethod project-files :around ((project (head vc)) &optional dirs)
    "Return a list of files in directories DIRS in PROJECT."
    ;; Intercept the primary/default `project-files' method.  Vc-jj does
    ;; not register itself as a new project backend: it hooks into the
    ;; existing VC integration into project.el (see `project-try-vc' in
    ;; `project-find-functions').  Because of that, we cannot provide a
    ;; standalone `project-files' method for a distinct backend class.
    ;; Therefore, we wrap the primary method with an :around method and
    ;; selectively override its behavior when the VC backend is JJ.
    (cl-call-next-method)))

;;;; Bug references

;; Feature `bug-reference' provides minor modes for putting clickable overlays
;; on references to bugs. A bug reference is text like "PR foo/29292". This is
;; mapped to a URL using a user-supplied format. Two minor modes are provided.
;; One works on any text in the buffer, the other operates only on comments and
;; strings.
(use-feature! bug-reference
  :hook (prog-mode-hook . bug-reference-prog-mode)
  :config

  ;; Set to EdgeWorkers Jiras.
  (setq bug-reference-url-format "https://track.akamai.com/jira/browse/%s")
  (setopt bug-reference-bug-regexp
          (rx (group (group word-start "EW-" (+ digit) word-end)))))

;;;; Terminal emulator

;; Feature `eshell' is a shell-like command interpreter implemented in Emacs
;; Lisp. It invokes no external processes except for those requested by the
;; user.
(use-feature! eshell
  :config

  ;; Do not litter `user-emacs-directory' with Eshell data.
  (setopt eshell-directory-name (cache-dir "eshell")))

;;;; External commands

;; Show current directory when prompting for a shell command.
(setopt shell-command-prompt-show-cwd t)

(defun start-terminal ()
  "Start a terminal emulator in a subprocess."
  (interactive)
  (start-process "term" nil "kitty"))

(set-leader-keys! "!" (cons "shell cmd" #'shell-command))
(set-leader-keys! "&" (cons "async shell cmd" #'async-shell-command))
(set-leader-keys! "@" (cons "term" #'start-terminal))

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
  :bind ( :map compilation-mode-map
          ("C-o" . nil)
          ("o"   . #'compilation-display-error))
  :config

  ;; Use a more specific set of regexps to avoid conflicts between patterns,
  ;; such as the gnu pattern matching errors from rust compiler warnings.
  (setopt compilation-error-regexp-alist
          '(meson
            bash
            python-tracebacks-and-caml
            cmake
            cmake-info
            clang-include
            gcc-include
            rust
            rust-panic
            shellcheck))

  ;; Automatically scroll the Compilation buffer as output appears,
  ;; but stop at the first error.
  (setopt compilation-scroll-output 'first-error))

;; Feature `consult-compile' provides the command `consult-compile-error' to
;; quickly jump to compilation errors and warnings.
(use-feature! consult-compile
  :bind (("M-g c"   . #'consult-compile-error)
         ("M-g M-c" . #'consult-compile-error)))

;; Package `fancy-compilation' enhances `compilation-mode' in the following
;; ways:
;; - support color output
;; - support progress updates on a single line (as used by e.g. ninja)
;; - use scrolling behavior similar to most terminals
(use-package! fancy-compilation
  :demand t
  :after compile
  :config

  ;; Behave as default `compilation-mode'.
  (setopt fancy-compilation-override-colors nil
          fancy-compilation-quiet-prelude nil
          fancy-compilation-quiet-prolog nil
          fancy-compilation-scroll-output 'first-error)

  (fancy-compilation-mode +1))

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

;; Disable and kill the *Messages* buffer.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Get rid of "For information about GNU Emacs..." message at startup, unless
;; we're in a daemon session, where it'll say "Starting Emacs daemon." instead,
;; which isn't so bad.
(unless (daemonp)
  (advice-add #'display-startup-echo-area-message :override #'ignore))

;; Feature `server' allows Emacs to operate as a server for other processes.
(use-feature! server
  :defer 1
  :config

  ;; Inhibit displaying instructions on how to exit the client on connection.
  (setopt server-client-instructions nil)

  (unless (or (server-running-p) (daemonp))
    (server-start)))

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

;; Allow you to resize frames and windows however you want, not just in whole
;; columns.
(setopt frame-resize-pixelwise t)
(setopt window-resize-pixelwise t)

;; Don't suggest shorter ways to type commands in M-x, since they don't apply
;; when using Vertico.
(setq suggest-key-bindings 0)

;; Defer fontification after 0.05s of being idle.
(setq jit-lock-defer-time 0.25)

;; Reduce rendering/line scan work for Emacs by not rendering cursors or regions
;; in non-focused windows.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;; Disable bidirectional text rendering for a modest performance boost.
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; Disable bidirectional parentheses algorithm for a modest performance boost.
(setopt bidi-inhibit-bpa t)

;; Feature `display-line-numbers' provides a minor mode interface for
;; `display-line-numbers'.
(use-feature! display-line-numbers
  :init

  (set-leader-keys!
    "t n" #'display-line-numbers-mode
    "t N" #'global-display-line-numbers-mode)

  :hook ((text-mode-hook prog-mode-hook conf-mode-hook dired-mode-hook)
         . display-line-numbers-mode)

  :config

  ;; Relative visual line numbers.
  (setopt display-line-numbers-type 'visual))

;; Feature `display-fill-column-indicator' provides a minor mode interface for
;; `display-fill-column-indicator'.
(use-feature! display-fill-column-indicator
  :init

  (set-leader-keys!
    "t f" #'display-fill-column-indicator-mode
    "t F" #'global-display-fill-column-indicator-mode)

  :hook (prog-mode-hook . display-fill-column-indicator-mode)

  :config

  ;; Highlight fill-column-indicator when current line is too long.
  (setopt display-fill-column-indicator-warning t))

;;;; Font

;; Bind keys for font size changes.
(set-leader-keys!
  "z =" (cons "text-scale-adjust-increase" #'text-scale-adjust)
  "z +" (cons "text-scale-adjust-increase" #'text-scale-adjust)
  "z -" (cons "text-scale-adjust-decrease" #'text-scale-adjust)
  "z 0" (cons "text-scale-adjust-reset"    #'text-scale-adjust))

;;;; Theme

;; Set cursor color in terminal Emacs based on the current theme. This uses the
;; OSC 12 escape sequence.
(setopt xterm-update-cursor 'color)

;; Package `modus-themes' is a pack of themes that conform with the highest
;; standard for colour-contrast accessibility between background and foreground
;; values (WCAG AAA).
(use-package! modus-themes
  :demand t
  :bind (("<f9>"   . modus-themes-select)
         ("M-<f9>" . modus-themes-rotate))
  :config

  ;; Make references of properties italic, they are not modified by
  ;; `modus-themes'.
  (set-face-attribute 'font-lock-property-use-face nil :slant 'italic)

  (defun my--modus-custom-faces (theme &rest _)
    "Custom faces that use Modus colors."
    (modus-themes-with-colors
      (custom-set-faces
       `(eglot-highlight-symbol-face ((,c :background ,bg-cyan-subtle)))
       ;; Make function calls and references of variables italic.
       `(font-lock-function-call-face ((,c :slant italic)))
       `(font-lock-variable-use-face ((,c :slant italic))))))
  (add-hook 'enable-theme-functions #'my--modus-custom-faces)

  ;; Use only main themes and their tinted versions.
  (setopt modus-themes-to-rotate '(modus-operandi
                                   modus-operandi-tinted
                                   modus-vivendi
                                   modus-vivendi-tinted))

  ;; Use italic and bold font forms in more constructs.
  (setopt modus-themes-italic-constructs t
          modus-themes-bold-constructs t)

  ;; Draw a line below matching characters in completions buffers.
  (setopt modus-themes-completions '((matches . (underline))))

  (setopt modus-themes-common-palette-overrides
          '(;; Make the mode line borderless
            (border-mode-line-active unspecified)
            (border-mode-line-inactive unspecified))))

;; Package `circadian' provides a theme-switching for Emacs based on daytime.
(use-package! circadian
  :demand t
  :config

  (setq calendar-latitude 50.064651)
  (setq calendar-longitude 19.944981)

  ;; Set Modus themes as light and dark respectively.
  (setopt circadian-themes '((:sunrise . (modus-operandi modus-operandi-tinted))
                             (:sunset . (modus-vivendi modus-vivendi-tinted))))

  (circadian-setup))

;;;; Modeline

;; Compress modelines wider than the currently selected window.
(setopt mode-line-compact 'long)

;; Always show Flymake to see errors/warnings.
;; Always show View Mode to better indicate read-only files.
(setopt mode-line-collapse-minor-modes
        '(not flymake-mode multiple-cursors-mode view-mode))

;; Package `keycast' provides two modes that display the current command and its
;; key or mouse binding, and update the displayed information once another
;; command is invoked. `keycast-mode' displays the command and event in the
;; mode-line and `keycast-log-mode' displays them in a dedicated frame.
(use-package! keycast
  :demand t
  :config

  (set-leader-keys! "t k" #'keycast-mode-line-mode)

  ;; Move Keycast display to be the last one in the modeline.
  (setopt keycast-mode-line-insert-after 'mode-line-misc-info)

  ;; Replace typing with a simple message.
  (dolist (input '(self-insert-command
                   org-self-insert-command))
    (add-to-list 'keycast-substitute-alist `(,input "." "Typing...")))

  ;; Don't show various mouse events.
  (dolist (event '("<mouse-event>"
                   "<mouse-movement>"
                   mouse-set-point
                   mouse-set-region
                   mouse-drag-region
                   "<wheel-down>" "<wheel-up>"
                   "<double-wheel-down>" "<double-wheel-up>"
                   "<triple-wheel-down>" "<triple-wheel-up>"
                   "<mouse-2>"))
    (add-to-list 'keycast-substitute-alist `(,event nil)))

  (keycast-mode-line-mode +1))

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
    "T d" #'tab-close
    "T D" #'tab-close-other
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
  (setopt tab-bar-tab-name-function #'tab-bar-tab-name-truncated)

  (tab-bar-history-mode +1))

;; Feature `tab-line' displays a tab line on the top screen line of each window.
;; The Tab Line shows special buttons for each buffer that was displayed in a
;; window, and allows switching to any of these buffers by clicking the
;; corresponding button. Clicking on the '+' icon adds a new buffer to the
;; window-local tab line of buffers, and clicking on the 'x' icon of a tab
;; deletes it. The mouse wheel on the tab line scrolls the tabs horizontally.
(use-feature! tab-line
  :demand t
  :config

  ;; Group buffers by projects.
  (setopt tab-line-tabs-function #'tab-line-tabs-buffer-groups)
  (setopt tab-line-tabs-buffer-group-function
          #'tab-line-tabs-buffer-group-by-project)

  ;; Upon closing a tab kill the tab's buffer.
  (setopt tab-line-close-tab-function 'kill-buffer)

  ;; Truncate buffer's name to avoid very long tabs.
  (setopt tab-line-tab-name-function #'tab-line-tab-name-truncated-buffer)

  (global-tab-line-mode +1))

;; Package `tabgo' allows the user to switch between tabs in a graphical and
;; more intuitive way, like Avy.
(use-package! tabgo
  :bind ("M-J" . #'tabgo))

;;; Profiling

;; Feature `profiler' provides  helper functions for Emacs's native profiler.
(use-feature! profiler
  :init

  (defun cpu-profiler-start ()
    (interactive)
    (profiler-start 'cpu))

  :bind (("<f6>" . #'cpu-profiler-start)
         ("<f7>" . #'profiler-stop)
         ("<f8>" . #'profiler-report)))

;;; Closing

(use-package! dape
  :init

  (setopt dape-adapter-dir (file-name-as-directory
                            (cache-dir "debug-adapters"))))

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
