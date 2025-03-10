;;; early-init.el --- Pre-initialisation config -*- lexical-binding: t -*-

;;; Commentary:

;; Emacs 27+ introduces early-init.el, which is run before init.el, before
;; package and UI initialization happens.

;;; Code:

;; In Emacs 27+, package initialization occurs before `user-init-file' is
;; loaded, but after `early-init-file' - disable this behaviour as we use
;; `straight'.
(setq package-enable-at-startup nil)

;; Prefix declarations are unneeded bulk added to our autoloads file. Best we
;; don't have to deal with them at all.
(setq autoload-compute-prefixes nil)

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early.
;; Set frame size to be slightly larger and always create frames in top left
;; corner of the screen.
(setq default-frame-alist '((menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            (vertical-scroll-bars)
                            (user-size . t)
                            (width . 110)
                            (height . 36)
                            (font . "Intel One Mono-17")))

;; Set initial frame to be maximized
; (setq initial-frame-alist '((fullscreen . maximized)))

;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we easily halve startup times with fonts that are
;; larger than the system default.
(setq frame-inhibit-implied-resize t)

;; Make sure not to load an out-of-date init.elc file.
(setq load-prefer-newer t)

;; Ignore X resources, its settings would be redundant with the other settings
;; in this file and can conflict with later config, particularly where the
;; cursor colour is concerned.
(advice-add #'x-apply-session-resources :override #'ignore)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; early-init.el ends here
