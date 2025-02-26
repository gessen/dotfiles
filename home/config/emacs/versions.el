((pcre2el :source #1="elpaca-menu-lock-file" :recipe
          (:package "pcre2el" :fetcher github :repo "joddie/pcre2el" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2="elpaca-menu-lock-file" :protocol https :inherit
                    t :depth treeless :ref
                    "b4d846d80dddb313042131cf2b8fbf647567e000"))
 (async :source #1# :recipe
        (:package "async" :repo "jwiegley/emacs-async" :fetcher github :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source #2# :protocol https :inherit t :depth treeless :ref
                  "b99658e831bc7e7d20ed4bb0a85bdb5c7dd74142"))
 (xterm-color :source #1# :recipe
              (:package "xterm-color" :repo "atomontage/xterm-color" :fetcher
                        github :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source #2# :protocol https :inherit t :depth treeless
                        :ref "2ad407c651e90fff2ea85d17bf074cee2c022912"))
 (with-editor :source #1#
   :recipe
   (:package "with-editor" :fetcher github :repo "magit/with-editor" :files
             ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
              "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
              (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                        "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
             :source #2# :protocol https :inherit t :depth treeless :ref
             "ca902ae02972bdd6919a902be2593d8cb6bd991b"))
 (magit-section :source #1# :recipe
                (:package "magit-section" :fetcher github :repo "magit/magit"
                          :files
                          ("lisp/magit-section.el" "docs/magit-section.texi"
                           "magit-section-pkg.el")
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "4a01405bf1b6cdcaafabcbf7692a1ad0f67ea7b5"))
 (llama :source #1# :recipe
        (:package "llama" :fetcher github :repo "tarsius/llama" :files
                  ("llama.el" ".dir-locals.el") :source #2# :protocol https
                  :inherit t :depth treeless :ref
                  "9802c215a3eea748d9d7f81a1465850388006897"))
 (dired-hacks-utils :source #1# :recipe
                    (:package "dired-hacks-utils" :fetcher github :repo
                              "Fuco1/dired-hacks" :files
                              ("dired-hacks-utils.el") :source #2# :protocol
                              https :inherit t :depth treeless :ref
                              "e9e408e8571aee5574ca0a431ef15cac5a3585d4"))
 (package-lint :source #1# :recipe
               (:package "package-lint" :fetcher github :repo
                         "purcell/package-lint" :files
                         (:defaults "data" (:exclude "*flymake.el")) :source #2#
                         :protocol https :inherit t :depth treeless :ref
                         "21edc6d0d0eadd2d0a537f422fb9b7b8a3ae6991"))
 (elisp-refs :source #1# :recipe
             (:package "elisp-refs" :repo "Wilfred/elisp-refs" :fetcher github
                       :files (:defaults (:exclude "elisp-refs-bench.el"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "541a064c3ce27867872cf708354a65d83baf2a6d"))
 (f :source #1# :recipe
    (:package "f" :fetcher github :repo "rejeep/f.el" :files
              ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
               "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
               (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                         "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
              :source #2# :protocol https :inherit t :depth treeless :ref
              "931b6d0667fe03e7bf1c6c282d6d8d7006143c52"))
 (reformatter :source #1# :recipe
              (:package "reformatter" :repo "purcell/emacs-reformatter" :fetcher
                        github :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source #2# :protocol https :inherit t :depth treeless
                        :ref "f2cb59466b1c3f85a8c960f7d4b7b7ead015bedc"))
 (mathjax :source #1# :recipe
          (:package "mathjax" :repo
                    ("https://github.com/astoff/mathjax.el" . "mathjax") :files
                    ("*" (:exclude ".git")) :source #2# :protocol https :inherit
                    t :depth treeless :ref
                    "db669451bbee7d2ea9872c28661c4679391b9644"))
 (popon :source #1# :recipe
        (:package "popon" :repo
                  ("https://codeberg.org/akib/emacs-popon" . "popon") :files
                  ("*" (:exclude ".git")) :source #2# :protocol https :inherit t
                  :depth treeless :ref
                  "bf8174cb7e6e8fe0fe91afe6b01b6562c4dc39da"))
 (popup :source #1# :recipe
        (:package "popup" :fetcher github :repo "auto-complete/popup-el" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source #2# :protocol https :inherit t :depth treeless :ref
                  "4b35c57ec88428233eecf27537854fc1f5f802ff"))
 (jeison :source #1# :recipe
         (:package "jeison" :repo "SavchenkoValeriy/jeison" :fetcher github
                   :files
                   ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                    "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                    "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                    "docs/*.texinfo"
                    (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                              "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                   :source #2# :protocol https :inherit t :depth treeless :ref
                   "19a51770f24eaa7b538c7be6a8a5c25d154b641f"))
 (spinner :source #1# :recipe
          (:package "spinner" :repo
                    ("https://github.com/Malabarba/spinner.el" . "spinner")
                    :files ("*" (:exclude ".git")) :source #2# :protocol https
                    :inherit t :depth treeless :ref
                    "d4647ae87fb0cd24bc9081a3d287c860ff061c21"))
 (parent-mode :source #1# :recipe
              (:package "parent-mode" :fetcher github :repo "Fanael/parent-mode"
                        :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source #2# :protocol https :inherit t :depth treeless
                        :ref "fbd49857ab2e4cd0c5611c0cc83f93711657b298"))
 (frog-menu :source #1# :recipe
            (:package "frog-menu" :repo
                      ("https://github.com/clemera/frog-menu" . "frog-menu")
                      :files ("*" (:exclude ".git")) :source #2# :protocol https
                      :inherit t :depth treeless :ref
                      "2b8d04c1a03b339e2eaf031eacd0d9d615a21322"))
 (ace-jump-mode :source #1# :recipe
                (:package "ace-jump-mode" :repo "winterTTr/ace-jump-mode"
                          :fetcher github :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "8351e2df4fbbeb2a4003f2fb39f46d33803f3dac"))
 (posframe :source #1# :recipe
           (:package "posframe" :fetcher github :repo "tumashu/posframe" :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source #2# :protocol https :inherit t :depth treeless :ref
                     "12f540c9ad5da09673b2bca1132b41f94c134e82"))
 (cfrs :source #1# :recipe
       (:package "cfrs" :repo "Alexander-Miller/cfrs" :fetcher github :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source #2# :protocol https :inherit t :depth treeless :ref
                 "f3a21f237b2a54e6b9f8a420a9da42b4f0a63121"))
 (ht :source #1# :recipe
     (:package "ht" :fetcher github :repo "Wilfred/ht.el" :files
               ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
                "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                          "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
               :source #2# :protocol https :inherit t :depth treeless :ref
               "1c49aad1c820c86f7ee35bf9fff8429502f60fef"))
 (pfuture :source #1# :recipe
          (:package "pfuture" :repo "Alexander-Miller/pfuture" :fetcher github
                    :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "19b53aebbc0f2da31de6326c495038901bffb73c"))
 (s :source #1# :recipe
    (:package "s" :fetcher github :repo "magnars/s.el" :files
              ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
               "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
               (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                         "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
              :source #2# :protocol https :inherit t :depth treeless :ref
              "dda84d38fffdaf0c9b12837b504b402af910d01d"))
 (dash :source #1# :recipe
       (:package "dash" :fetcher github :repo "magnars/dash.el" :files
                 ("dash.el" "dash.texi") :source #2# :protocol https :inherit t
                 :depth treeless :ref "1de9dcb83eacfb162b6d9a118a4770b1281bcd84"))
 (nerd-icons :source #1# :recipe
             (:package "nerd-icons" :repo "rainstormstudio/nerd-icons.el"
                       :fetcher github :files (:defaults "data") :source #2#
                       :protocol https :inherit t :depth treeless :ref
                       "546ee20caf825e65da4c5435d31f13d269ed2a81"))
 (spacious-padding :source #1# :recipe
                   (:package "spacious-padding" :repo
                             ("https://github.com/protesilaos/spacious-padding"
                              . "spacious-padding")
                             :files
                             ("*" (:exclude ".git" "COPYING" "doclicense.texi"))
                             :source #2# :protocol https :inherit t :depth
                             treeless :ref
                             "2bfcb8da5f7f08e39c52c889231f2b6f93f10e78"))
 (minions :source #1# :recipe
          (:package "minions" :fetcher github :repo "tarsius/minions" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "7ccb5e23a54c10f64880d1f55676f86681ff2f07"))
 (keycast :source #1# :recipe
          (:package "keycast" :fetcher github :repo "tarsius/keycast" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "c44618d2867fc2410e5061fef2a805e974198cf2"))
 (hide-mode-line :source #1# :recipe
                 (:package "hide-mode-line" :repo
                           "hlissner/emacs-hide-mode-line" :fetcher github
                           :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source #2# :protocol https :inherit t :depth
                           treeless :ref
                           "ddd154f1e04d666cd004bf8212ead8684429350d"))
 (theme-buffet :source #1# :recipe
               (:package "theme-buffet" :repo
                         ("https://git.sr.ht/~bboal/theme-buffet"
                          . "theme-buffet")
                         :files ("*" (:exclude ".git")) :source #2# :protocol
                         https :inherit t :depth treeless :ref
                         "06f1be349e9c3d124520b18742911307de9abda3"))
 (ef-themes :source #1# :recipe
            (:package "ef-themes" :repo
                      ("https://github.com/protesilaos/ef-themes" . "ef-themes")
                      :files
                      ("*"
                       (:exclude ".git" "COPYING" "doclicense.texi"
                                 "contrast-ratios.org"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "7a1933c03a97957eda900b2063617f76f6c389e9"))
 (modus-themes :source #1# :recipe
               (:package "modus-themes" :fetcher github :repo
                         "protesilaos/modus-themes" :files
                         ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                          "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                          "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                          "docs/*.texinfo"
                          (:exclude ".dir-locals.el" "test.el" "tests.el"
                                    "*-test.el" "*-tests.el" "LICENSE" "README*"
                                    "*-pkg.el"))
                         :source #2# :protocol https :inherit t :depth treeless
                         :ref "ab56e2888b2fc77af2824afcc7b77d5dd854fd05"))
 (esup :source #1# :recipe
       (:package "esup" :fetcher github :repo "jschaf/esup" :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source #2# :protocol https :inherit t :depth treeless :ref
                 "4b49c8d599d4cc0fbf994e9e54a9c78e5ab62a5f"))
 (vterm-toggle :source #1# :recipe
               (:package "vterm-toggle" :fetcher github :repo
                         "jixiuf/vterm-toggle" :files
                         ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                          "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                          "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                          "docs/*.texinfo"
                          (:exclude ".dir-locals.el" "test.el" "tests.el"
                                    "*-test.el" "*-tests.el" "LICENSE" "README*"
                                    "*-pkg.el"))
                         :source #2# :protocol https :inherit t :depth treeless
                         :ref "06cb4f3c565e46470a3c4505c11e26066d869715"))
 (vterm :source #1# :recipe
        (:package "vterm" :fetcher github :repo "akermu/emacs-libvterm" :files
                  ("CMakeLists.txt" "elisp.c" "elisp.h" "emacs-module.h" "etc"
                   "utf8.c" "utf8.h" "vterm.el" "vterm-module.c"
                   "vterm-module.h")
                  :source #2# :protocol https :inherit t :depth treeless :ref
                  "056ad74653704bc353d8ec8ab52ac75267b7d373"))
 (transient :source #1# :recipe
            (:package "transient" :fetcher github :repo "magit/transient" :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "04dab99dc9bc8788ed17473118421e6ee291091d"))
 (magit-todos :source #1# :recipe
              (:package "magit-todos" :fetcher github :repo
                        "alphapapa/magit-todos" :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source #2# :protocol https :inherit t :depth treeless
                        :ref "bd27c57eada0fda1cc0a813db04731a9bcc51b7b"))
 (magit-delta :source #1# :recipe
              (:package "magit-delta" :fetcher github :repo
                        "dandavison/magit-delta" :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source #2# :protocol https :inherit t :depth treeless
                        :ref "5fc7dbddcfacfe46d3fd876172ad02a9ab6ac616"))
 (magit :source #1# :recipe
        (:package "magit" :fetcher github :repo "magit/magit" :files
                  ("lisp/magit*.el" "lisp/git-*.el" "docs/magit.texi"
                   "docs/AUTHORS.md" "LICENSE" ".dir-locals.el"
                   (:exclude "lisp/magit-section.el"))
                  :source #2# :protocol https :inherit t :depth treeless :ref
                  "4a01405bf1b6cdcaafabcbf7692a1ad0f67ea7b5"))
 (git-timemachine :source #1# :recipe
                  (:package "git-timemachine" :fetcher codeberg :repo
                            "pidu/git-timemachine" :files
                            ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                             "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                             "doc/*.texinfo" "lisp/*.el" "docs/dir"
                             "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                             (:exclude ".dir-locals.el" "test.el" "tests.el"
                                       "*-test.el" "*-tests.el" "LICENSE"
                                       "README*" "*-pkg.el"))
                            :source #2# :protocol https :inherit t :depth
                            treeless :ref
                            "d1346a76122595aeeb7ebb292765841c6cfd417b"))
 (git-messenger :source #1# :recipe
                (:package "git-messenger" :repo "emacsorphanage/git-messenger"
                          :fetcher github :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "eade986ef529aa2dac6944ad61b18de55cee0b76"))
 (git-gutter :source #1# :recipe
             (:package "git-gutter" :repo "emacsorphanage/git-gutter" :fetcher
                       github :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "2d7465e46b7b5bfa113b18e6f8ec0e3e55c018b2"))
 (consult-ls-git :source #1# :recipe
                 (:package "consult-ls-git" :repo "rcj/consult-ls-git" :fetcher
                           github :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source #2# :protocol https :inherit t :depth
                           treeless :ref
                           "beb253374e2cee10b8682fb8b377ca1f2caa4e27"))
 (consult-git-log-grep :source #1# :recipe
                       (:package "consult-git-log-grep" :fetcher github :repo
                                 "ghosty141/consult-git-log-grep" :files
                                 ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                  "*.texinfo" "doc/dir" "doc/*.info"
                                  "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                                  "docs/dir" "docs/*.info" "docs/*.texi"
                                  "docs/*.texinfo"
                                  (:exclude ".dir-locals.el" "test.el"
                                            "tests.el" "*-test.el" "*-tests.el"
                                            "LICENSE" "README*" "*-pkg.el"))
                                 :source #2# :protocol https :inherit t :depth
                                 treeless :ref
                                 "2dbedc0efc90c8a0311c9f2244596fe1ee3eddd4"))
 (browse-at-remote :source #1# :recipe
                   (:package "browse-at-remote" :repo
                             "rmuslimov/browse-at-remote" :fetcher github :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source #2# :protocol https :inherit t :depth
                             treeless :ref
                             "76aa27dfd469fcae75ed7031bb73830831aaccbf"))
 (nerd-icons-dired :source #1# :recipe
                   (:package "nerd-icons-dired" :repo
                             "rainstormstudio/nerd-icons-dired" :fetcher github
                             :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source #2# :protocol https :inherit t :depth
                             treeless :ref
                             "c0b0cda2b92f831d0f764a7e8c0c6728d6a27774"))
 (fd-dired :source #1# :recipe
           (:package "fd-dired" :fetcher github :repo "yqrashawn/fd-dired"
                     :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source #2# :protocol https :inherit t :depth treeless :ref
                     "458464771bb220b6eb87ccfd4c985c436e57dc7e"))
 (diredfl :source #1# :recipe
          (:package "diredfl" :fetcher github :repo "purcell/diredfl" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "fe72d2e42ee18bf6228bba9d7086de4098f18a70"))
 (dired-subtree :source #1# :recipe
                (:package "dired-subtree" :fetcher github :repo
                          "Fuco1/dired-hacks" :files ("dired-subtree.el")
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "e9e408e8571aee5574ca0a431ef15cac5a3585d4"))
 (dired-hist :source #1# :recipe
             (:package "dired-hist" :fetcher github :repo "Anoncheg1/dired-hist"
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "bcbfa60e2de0d86a38740d72bea7e4f25ccc35c8"))
 (dired-copy-paste :source #1# :recipe
                   (:source #2# :protocol https :inherit t :depth treeless :host
                            github :repo "jsilve24/dired-copy-paste" :package
                            "dired-copy-paste" :ref
                            "aefb5597e65bc1a7b771c2c82961f5a10b5f424b"))
 (toc-org :source #1# :recipe
          (:package "toc-org" :fetcher github :repo "snosov1/toc-org" :old-names
                    (org-toc) :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "6d3ae0fc47ce79b1ea06cabe21a3c596395409cd"))
 (org-sticky-header :source #1# :recipe
                    (:package "org-sticky-header" :fetcher github :repo
                              "alphapapa/org-sticky-header" :files
                              ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                               "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                               "doc/*.texinfo" "lisp/*.el" "docs/dir"
                               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                               (:exclude ".dir-locals.el" "test.el" "tests.el"
                                         "*-test.el" "*-tests.el" "LICENSE"
                                         "README*" "*-pkg.el"))
                              :source #2# :protocol https :inherit t :depth
                              treeless :ref
                              "697875935b04b25c8229b9155a1ea0cab3ebe629"))
 (org-modern :source #1# :recipe
             (:package "org-modern" :repo "minad/org-modern" :fetcher github
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "ae0d91fa16f0e72df50633d0941242eecd78721b"))
 (htmlize :source #1# :recipe
          (:package "htmlize" :fetcher github :repo "hniksic/emacs-htmlize"
                    :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "8e3841c837b4b78bd72ad7f0436e919f39315a46"))
 (ox-reveal :source #1# :recipe
            (:package "ox-reveal" :repo "yjwen/org-reveal" :fetcher github
                      :old-names (org-reveal) :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "f55c851bf6aeb1bb2a7f6cf0f2b7bd0e79c4a5a0"))
 (ox-pandoc :source #1# :recipe
            (:package "ox-pandoc" :repo "emacsorphanage/ox-pandoc" :fetcher
                      github :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "34e6ea97b586e20529d07158a73af3cf33cdd1d5"))
 (org-contrib :source #1# :recipe
              (:package "org-contrib" :repo
                        ("https://git.sr.ht/~bzg/org-contrib" . "org-contrib")
                        :files (:defaults) :source #2# :protocol https :inherit
                        t :depth treeless :ref
                        "8d14a600a2069ffc494edfc9a12b8e5fc8840bf1"))
 (org :source #1# :recipe
      (:package "org" :repo "emacs-straight/org-mode" :pre-build
                (progn (require 'elpaca-menu-org) (elpaca-menu-org--build))
                :autoloads "org-loaddefs.el" :depth treeless :build
                (:not elpaca--generate-autoloads-async) :files
                (:defaults ("etc/styles/" "etc/styles/*" "doc/*.texi")) :source
                #2# :protocol https :inherit t :host github :local-repo "org"
                :ref "71c7c885eb7eed01ba74e9068db222fbe438e846"))
 (elisp-lint :source #1# :recipe
             (:package "elisp-lint" :fetcher github :repo
                       "gonewest818/elisp-lint" :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "c5765abf75fd1ad22505b349ae1e6be5303426c2"))
 (macrostep :source #1# :recipe
            (:package "macrostep" :fetcher github :repo
                      "emacsorphanage/macrostep" :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "d0928626b4711dcf9f8f90439d23701118724199"))
 (helpful :source #1# :recipe
          (:package "helpful" :repo "Wilfred/helpful" :fetcher github :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "34328c639ed7aad371a3f57209acad2a5bb66401"))
 (eglot-x :source #1# :recipe
          (:source #2# :protocol https :inherit t :depth treeless :host github
                   :repo "nemethf/eglot-x" :package "eglot-x" :ref
                   "82c315c052e5a08c5307df4a4624049ee0e219e8"))
 (eglot-semantic-tokens :source #1# :recipe
                        (:source #2# :protocol https :inherit t :depth treeless
                                 :host codeberg :repo
                                 "eownerdead/eglot-semantic-tokens" :package
                                 "eglot-semantic-tokens" :ref
                                 "fcb25e048bff2b9fa0a70b85d4d07951aa6e1022"))
 (eglot-booster :source #1# :recipe
                (:source #2# :protocol https :inherit t :depth treeless :host
                         github :repo "jdtsmith/eglot-booster" :package
                         "eglot-booster" :ref
                         "e6daa6bcaf4aceee29c8a5a949b43eb1b89900ed"))
 (eglot :source #1# :recipe
        (:package "eglot" :repo
                  ("https://github.com/emacs-mirror/emacs" . "eglot") :branch
                  "master" :files
                  ("lisp/progmodes/eglot.el" "doc/emacs/doclicense.texi"
                   "doc/emacs/docstyle.texi" "doc/misc/eglot.texi"
                   "etc/EGLOT-NEWS" (:exclude ".git"))
                  :source #2# :protocol https :inherit t :depth treeless :ref
                  "4cf53c436159ea54dbfe1a1e24515e2e6fbf9a6f"))
 (consult-eglot :source #1# :recipe
                (:package "consult-eglot" :fetcher github :repo
                          "mohkale/consult-eglot" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "2bc816be057a2ece99d4bf014ade14ae7d758b07"))
 (yaml-mode :source #1# :recipe
            (:package "yaml-mode" :repo "yoshiki/yaml-mode" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "d91f878729312a6beed77e6637c60497c5786efa"))
 (ssh-config-mode :source #1# :recipe
                  (:package "ssh-config-mode" :fetcher github :repo
                            "peterhoeg/ssh-config-mode-el" :files
                            (:defaults "*.txt") :source #2# :protocol https
                            :inherit t :depth treeless :ref
                            "d0596f5fbeab3d2c3c30eb83527316403bc5b2f7"))
 (pkgbuild-mode :source #1# :recipe
                (:package "pkgbuild-mode" :fetcher github :repo
                          "juergenhoetzel/pkgbuild-mode" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "aadf3d1d19c5eb9b52c15c5b73b1a46faac5b7d5"))
 (git-modes :source #1# :recipe
            (:package "git-modes" :fetcher github :repo "magit/git-modes"
                      :old-names
                      (gitattributes-mode gitconfig-mode gitignore-mode) :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "f99010bbeb8b6d8a0819fac0195a2ef0159d08f0"))
 (shfmt :source #1# :recipe
        (:package "shfmt" :fetcher github :repo "purcell/emacs-shfmt" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source #2# :protocol https :inherit t :depth treeless :ref
                  "78a96e66d2685672de3d0b7d627cd57a3b0caaf2"))
 (plantuml-mode :source #1# :recipe
                (:package "plantuml-mode" :fetcher github :repo
                          "skuro/plantuml-mode" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "ea45a13707abd2a70df183f1aec6447197fc9ccc"))
 (meson-mode :source #1# :recipe
             (:package "meson-mode" :fetcher github :repo "wentasah/meson-mode"
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "0449c649daaa9322e1c439c1540d8c290501d455"))
 (grip-mode :source #1# :recipe
            (:package "grip-mode" :repo "seagle0128/grip-mode" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "ffce7f78ebe48645b93fa162038ac7f678ffd618"))
 (markdown-toc :source #1# :recipe
               (:package "markdown-toc" :fetcher github :repo
                         "ardumont/markdown-toc" :files
                         ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                          "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                          "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                          "docs/*.texinfo"
                          (:exclude ".dir-locals.el" "test.el" "tests.el"
                                    "*-test.el" "*-tests.el" "LICENSE" "README*"
                                    "*-pkg.el"))
                         :source #2# :protocol https :inherit t :depth treeless
                         :ref "d2fb4cbd95e558042307d706f9f47f93687c9fcc"))
 (markdown-mode :source #1# :recipe
                (:package "markdown-mode" :fetcher github :repo
                          "jrblevin/markdown-mode" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "038f0fb9789afafff99b7f23de107862dde113ee"))
 (fish-mode :source #1# :recipe
            (:package "fish-mode" :fetcher github :repo "wwwjfy/emacs-fish"
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "2526b1803b58cf145bc70ff6ce2adb3f6c246f89"))
 (treesit-auto :source #1# :recipe
               (:package "treesit-auto" :fetcher github :repo
                         "renzmann/treesit-auto" :files
                         ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                          "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                          "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                          "docs/*.texinfo"
                          (:exclude ".dir-locals.el" "test.el" "tests.el"
                                    "*-test.el" "*-tests.el" "LICENSE" "README*"
                                    "*-pkg.el"))
                         :source #2# :protocol https :inherit t :depth treeless
                         :ref "016bd286a1ba4628f833a626f8b9d497882ecdf3"))
 (devdocs :source #1# :recipe
          (:package "devdocs" :fetcher github :repo "astoff/devdocs.el" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "d2214d34cdeb4483a594dd6973fcd095cef4653f"))
 (flymake-popon :source #1# :recipe
                (:package "flymake-popon" :repo
                          ("https://codeberg.org/akib/emacs-flymake-popon"
                           . "flymake-popon")
                          :files ("*" (:exclude ".git")) :source #2# :protocol
                          https :inherit t :depth treeless :ref
                          "99ea813346f3edef7220d8f4faeed2ec69af6060"))
 (flymake-collection :source #1# :recipe
                     (:package "flymake-collection" :fetcher github :repo
                               "mohkale/flymake-collection" :files
                               (:defaults "src/*.el" "src/checkers/*.el")
                               :old-names (flymake-rest) :source #2# :protocol
                               https :inherit t :depth treeless :ref
                               "04dd61c639026c0eb52cdcc149e291955f5c6104"))
 (nerd-icons-corfu :source #1# :recipe
                   (:package "nerd-icons-corfu" :fetcher github :repo
                             "LuigiPiucco/nerd-icons-corfu" :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source #2# :protocol https :inherit t :depth
                             treeless :ref
                             "41110180ceab9d0edaa856d19633b2b3fdf82e75"))
 (corfu-prescient :source #1# :recipe
                  (:package "corfu-prescient" :fetcher github :repo
                            "radian-software/prescient.el" :files
                            ("corfu-prescient.el") :source #2# :protocol https
                            :inherit t :depth treeless :ref
                            "7dd5b53886146a507f1388e0b61990f9820f9eb1"))
 (corfu-terminal :source #1# :recipe
                 (:package "corfu-terminal" :repo "akib/emacs-corfu-terminal"
                           :files ("*" (:exclude ".git")) :source #2# :protocol
                           https :inherit t :depth treeless :host codeberg :ref
                           "501548c3d51f926c687e8cd838c5865ec45d03cc"))
 (corfu :source #1# :recipe
        (:package "corfu" :repo "minad/corfu" :files (:defaults "extensions/*")
                  :fetcher github :source #2# :protocol https :inherit t :depth
                  treeless :ref "2c476b442ccfda9935e472b26d9cd60d45726560"))
 (cape :source #1# :recipe
       (:package "cape" :repo "minad/cape" :fetcher github :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source #2# :protocol https :inherit t :depth treeless :ref
                 "118db73710466ab03708e7511f4bff7827057000"))
 (breadcrumb :source #1# :recipe
             (:package "breadcrumb" :repo
                       ("https://github.com/joaotavora/breadcrumb"
                        . "breadcrumb")
                       :files ("*" (:exclude ".git")) :source #2# :protocol
                       https :inherit t :depth treeless :ref
                       "da34d030e6d01db2bba45b30080204b23a714c9f"))
 (dumb-jump :source #1# :recipe
            (:package "dumb-jump" :repo "jacktasia/dumb-jump" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "9f3967b0bea038c37d4a6c6bb96144574bb706ee"))
 (consult-xref-stack :source #1# :recipe
                     (:source #2# :protocol https :inherit t :depth treeless
                              :host github :repo
                              "brett-lempereur/consult-xref-stack" :package
                              "consult-xref-stack" :ref
                              "aa9bbf7a3ff43353b7c10595b3d13887b213466b"))
 (vertico-prescient :source #1# :recipe
                    (:package "vertico-prescient" :fetcher github :repo
                              "radian-software/prescient.el" :files
                              ("vertico-prescient.el") :source #2# :protocol
                              https :inherit t :depth treeless :ref
                              "7dd5b53886146a507f1388e0b61990f9820f9eb1"))
 (vertico :source #1# :recipe
          (:package "vertico" :repo "minad/vertico" :files
                    (:defaults "extensions/*") :fetcher github :source #2#
                    :protocol https :inherit t :depth treeless :ref
                    "000668cb6c611f009d9c98168ae68cb70734cbad"))
 (prescient :source #1# :recipe
            (:package "prescient" :fetcher github :repo
                      "radian-software/prescient.el" :files ("prescient.el")
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "7dd5b53886146a507f1388e0b61990f9820f9eb1"))
 (orderless :source #1# :recipe
            (:package "orderless" :repo "oantolin/orderless" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "c7cb04499d94ee1c17affb29b1cfcd2a45116c97"))
 (marginalia :source #1# :recipe
             (:package "marginalia" :repo "minad/marginalia" :fetcher github
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "a527fb03b76a2bce1e360c6e73a095e06922c3f3"))
 (embark-consult :source #1# :recipe
                 (:package "embark-consult" :repo "oantolin/embark" :fetcher
                           github :files ("embark-consult.el") :source #2#
                           :protocol https :inherit t :depth treeless :ref
                           "d5df0eff182b014ab49328a4dbb1d69eb7faafbd"))
 (embark :source #1# :recipe
         (:package "embark" :repo "oantolin/embark" :fetcher github :files
                   ("embark.el" "embark-org.el" "embark.texi") :source #2#
                   :protocol https :inherit t :depth treeless :ref
                   "d5df0eff182b014ab49328a4dbb1d69eb7faafbd"))
 (consult :source #1# :recipe
          (:package "consult" :repo "minad/consult" :fetcher github :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "2643235a853d55805822239bb2cd75a7aabef48d"))
 (nerd-icons-completion :source #1# :recipe
                        (:package "nerd-icons-completion" :repo
                                  "rainstormstudio/nerd-icons-completion"
                                  :fetcher github :files
                                  ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                   "*.texinfo" "doc/dir" "doc/*.info"
                                   "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                                   "docs/dir" "docs/*.info" "docs/*.texi"
                                   "docs/*.texinfo"
                                   (:exclude ".dir-locals.el" "test.el"
                                             "tests.el" "*-test.el" "*-tests.el"
                                             "LICENSE" "README*" "*-pkg.el"))
                                  :source #2# :protocol https :inherit t :depth
                                  treeless :ref
                                  "8e5b995eb2439850ab21ba6062d9e6942c82ab9c"))
 (yasnippet-snippets :source #1# :recipe
                     (:package "yasnippet-snippets" :repo
                               "AndreaCrotti/yasnippet-snippets" :fetcher github
                               :files ("*.el" "snippets" ".nosearch") :source
                               #2# :protocol https :inherit t :depth treeless
                               :ref "f1907ed38acc479e78d5c113810465e4d77d8604"))
 (yasnippet :source #1# :recipe
            (:package "yasnippet" :repo "joaotavora/yasnippet" :fetcher github
                      :files ("yasnippet.el" "snippets") :source #2# :protocol
                      https :inherit t :depth treeless :ref
                      "5b315f1753480ebe669b157b8242448b5eafcfea"))
 (consult-yasnippet :source #1# :recipe
                    (:package "consult-yasnippet" :fetcher github :repo
                              "mohkale/consult-yasnippet" :files
                              ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                               "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                               "doc/*.texinfo" "lisp/*.el" "docs/dir"
                               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                               (:exclude ".dir-locals.el" "test.el" "tests.el"
                                         "*-test.el" "*-tests.el" "LICENSE"
                                         "README*" "*-pkg.el"))
                              :source #2# :protocol https :inherit t :depth
                              treeless :ref
                              "834d39acfe8a7d2c304afbe4d649b9372118c756"))
 (auto-yasnippet :source #1# :recipe
                 (:package "auto-yasnippet" :fetcher github :repo
                           "abo-abo/auto-yasnippet" :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source #2# :protocol https :inherit t :depth
                           treeless :ref
                           "6a9e406d0d7f9dfd6dff7647f358cb05a0b1637e"))
 (surround :source #1# :recipe
           (:package "surround" :fetcher github :repo "mkleehammer/surround"
                     :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source #2# :protocol https :inherit t :depth treeless :ref
                     "32a63da201064bb0787fd2e7a79e41878e0223a4"))
 (vlf :source #1# :recipe
      (:package "vlf" :repo
                ("https://git.savannah.gnu.org/git/emacs/elpa.git" . "vlf")
                :branch "externals/vlf" :files ("*" (:exclude ".git")) :source
                #2# :protocol https :inherit t :depth treeless :ref
                "6192573ee088079bf1f81abc2bf2a370a5a92397"))
 (powerthesaurus :source #1# :recipe
                 (:package "powerthesaurus" :repo
                           "SavchenkoValeriy/emacs-powerthesaurus" :fetcher
                           github :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source #2# :protocol https :inherit t :depth
                           treeless :ref
                           "4b97797cf789aaba411c61a85fe23474ebc5bedc"))
 (flyspell-correct :source #1# :recipe
                   (:package "flyspell-correct" :repo
                             "d12frosted/flyspell-correct" :fetcher github
                             :files
                             ("flyspell-correct.el" "flyspell-correct-ido.el")
                             :source #2# :protocol https :inherit t :depth
                             treeless :ref
                             "1e7a5a56362dd875dddf848b9a9e25d1395b9d37"))
 (consult-flyspell :source #1# :recipe
                   (:package "consult-flyspell" :repo "OlMon/consult-flyspell"
                             :fetcher gitlab :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source #2# :protocol https :inherit t :depth
                             treeless :ref
                             "7011e6634598530ea2d874e7e7389dc1bb94e1ca"))
 (wgrep :source #1# :recipe
        (:package "wgrep" :fetcher github :repo "mhayashi1120/Emacs-wgrep"
                  :files ("wgrep.el") :source #2# :protocol https :inherit t
                  :depth treeless :ref
                  "49f09ab9b706d2312cab1199e1eeb1bcd3f27f6f"))
 (visual-regexp-steroids :source #1# :recipe
                         (:package "visual-regexp-steroids" :repo
                                   "benma/visual-regexp-steroids.el" :fetcher
                                   github :files
                                   ("visual-regexp-steroids.el" "regexp.py")
                                   :source #2# :protocol https :inherit t :depth
                                   treeless :ref
                                   "a6420b25ec0fbba43bf57875827092e1196d8a9e"))
 (visual-regexp :source #1# :recipe
                (:package "visual-regexp" :repo "benma/visual-regexp.el"
                          :fetcher github :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "48457d42a5e0fe10fa3a9c15854f1f127ade09b5"))
 (substitute :source #1# :recipe
             (:package "substitute" :repo
                       ("https://github.com/protesilaos/substitute"
                        . "substitute")
                       :files
                       ("*" (:exclude ".git" "COPYING" "doclicense.texi"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "7e1fe732d86c7326550089f3c14794889312a30c"))
 (iedit :source #1# :recipe
        (:package "iedit" :repo "victorhge/iedit" :fetcher github :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source #2# :protocol https :inherit t :depth treeless :ref
                  "27c61866b1b9b8d77629ac702e5f48e67dfe0d3b"))
 (deadgrep :source #1# :recipe
           (:package "deadgrep" :repo "Wilfred/deadgrep" :fetcher github :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source #2# :protocol https :inherit t :depth treeless :ref
                     "bb555790c6f404572d537e1e4adec8b4ff0515f5"))
 (symbol-overlay :source #1# :recipe
                 (:package "symbol-overlay" :fetcher github :repo
                           "wolray/symbol-overlay" :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source #2# :protocol https :inherit t :depth
                           treeless :ref
                           "6151f4279bd94b5960149596b202cdcb45cacec2"))
 (rainbow-delimiters :source #1# :recipe
                     (:package "rainbow-delimiters" :fetcher github :repo
                               "Fanael/rainbow-delimiters" :files
                               ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                                "doc/*.texinfo" "lisp/*.el" "docs/dir"
                                "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                                (:exclude ".dir-locals.el" "test.el" "tests.el"
                                          "*-test.el" "*-tests.el" "LICENSE"
                                          "README*" "*-pkg.el"))
                               :source #2# :protocol https :inherit t :depth
                               treeless :ref
                               "f40ece58df8b2f0fb6c8576b527755a552a5e763"))
 (pulsar :source #1# :recipe
         (:package "pulsar" :repo
                   ("https://github.com/protesilaos/pulsar" . "pulsar") :files
                   ("*" (:exclude ".git" "COPYING" "doclicense.texi")) :source
                   #2# :protocol https :inherit t :depth treeless :ref
                   "77416e6076af7ab3ccfb7a91915dd036ad968155"))
 (prism :source #1# :recipe
        (:package "prism" :fetcher github :repo "alphapapa/prism.el" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source #2# :protocol https :inherit t :depth treeless :ref
                  "2fa8eb5a9ca62a548d33befef4517e5d0266eb28"))
 (hl-todo :source #1# :recipe
          (:package "hl-todo" :repo "tarsius/hl-todo" :fetcher github :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source #2# :protocol https :inherit t :depth treeless :ref
                    "fb692ec0923bcd98eaa8760127921aca61db8e1e"))
 (highlight-parentheses :source #1# :recipe
                        (:package "highlight-parentheses" :fetcher sourcehut
                                  :repo "tsdh/highlight-parentheses.el" :files
                                  ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                   "*.texinfo" "doc/dir" "doc/*.info"
                                   "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                                   "docs/dir" "docs/*.info" "docs/*.texi"
                                   "docs/*.texinfo"
                                   (:exclude ".dir-locals.el" "test.el"
                                             "tests.el" "*-test.el" "*-tests.el"
                                             "LICENSE" "README*" "*-pkg.el"))
                                  :source #2# :protocol https :inherit t :depth
                                  treeless :ref
                                  "965b18dd69eff4457e17c9e84b3cbfdbfca2ddfb"))
 (highlight-numbers :source #1# :recipe
                    (:package "highlight-numbers" :fetcher github :repo
                              "Fanael/highlight-numbers" :old-names
                              (number-font-lock-mode) :files
                              ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                               "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                               "doc/*.texinfo" "lisp/*.el" "docs/dir"
                               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                               (:exclude ".dir-locals.el" "test.el" "tests.el"
                                         "*-test.el" "*-tests.el" "LICENSE"
                                         "README*" "*-pkg.el"))
                              :source #2# :protocol https :inherit t :depth
                              treeless :ref
                              "8b4744c7f46c72b1d3d599d4fb75ef8183dee307"))
 (highlight-indent-guides :source #1# :recipe
                          (:package "highlight-indent-guides" :fetcher github
                                    :repo "DarthFennec/highlight-indent-guides"
                                    :files
                                    ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                     "*.texinfo" "doc/dir" "doc/*.info"
                                     "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                                     "docs/dir" "docs/*.info" "docs/*.texi"
                                     "docs/*.texinfo"
                                     (:exclude ".dir-locals.el" "test.el"
                                               "tests.el" "*-test.el"
                                               "*-tests.el" "LICENSE" "README*"
                                               "*-pkg.el"))
                                    :source #2# :protocol https :inherit t
                                    :depth treeless :ref
                                    "3205abe2721053416e354a1ff53947dd122a6941"))
 (column-enforce-mode :source #1# :recipe
                      (:package "column-enforce-mode" :fetcher github :repo
                                "jordonbiondo/column-enforce-mode" :files
                                ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                 "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                                 "doc/*.texinfo" "lisp/*.el" "docs/dir"
                                 "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                                 (:exclude ".dir-locals.el" "test.el" "tests.el"
                                           "*-test.el" "*-tests.el" "LICENSE"
                                           "README*" "*-pkg.el"))
                                :source #2# :protocol https :inherit t :depth
                                treeless :ref
                                "14a7622f2268890e33536ccd29510024d51ee96f"))
 (mwim :source #1# :recipe
       (:package "mwim" :repo "alezost/mwim.el" :fetcher github :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source #2# :protocol https :inherit t :depth treeless :ref
                 "b4f3edb4c0fb8f8b71cecbf8095c2c25a8ffbf85"))
 (goto-chg :source #1# :recipe
           (:package "goto-chg" :repo "emacs-evil/goto-chg" :fetcher github
                     :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source #2# :protocol https :inherit t :depth treeless :ref
                     "72f556524b88e9d30dc7fc5b0dc32078c166fda7"))
 (frog-jump-buffer :source #1# :recipe
                   (:package "frog-jump-buffer" :repo
                             "waymondo/frog-jump-buffer" :fetcher github :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source #2# :protocol https :inherit t :depth
                             treeless :ref
                             "ab830cb7a5af9429866ba88fb37589a0366d8bf2"))
 (centered-cursor-mode :source #1# :recipe
                       (:package "centered-cursor-mode" :fetcher github :repo
                                 "andre-r/centered-cursor-mode.el" :files
                                 ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                  "*.texinfo" "doc/dir" "doc/*.info"
                                  "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                                  "docs/dir" "docs/*.info" "docs/*.texi"
                                  "docs/*.texinfo"
                                  (:exclude ".dir-locals.el" "test.el"
                                            "tests.el" "*-test.el" "*-tests.el"
                                            "LICENSE" "README*" "*-pkg.el"))
                                 :source #2# :protocol https :inherit t :depth
                                 treeless :ref
                                 "67ef719e685407dbc455c7430765e4e685fd95a9"))
 (beginend :source #1# :recipe
           (:package "beginend" :fetcher github :repo "DamienCassou/beginend"
                     :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source #2# :protocol https :inherit t :depth treeless :ref
                     "26d6142ceaf7c58705281852410b61ddc0d780ee"))
 (avy :source #1# :recipe
      (:package "avy" :repo "abo-abo/avy" :fetcher github :files
                ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                 "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                 "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                 (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                           "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                :source #2# :protocol https :inherit t :depth treeless :ref
                "933d1f36cca0f71e4acb5fac707e9ae26c536264"))
 (golden-ratio-scroll-screen :source #1# :recipe
                             (:package "golden-ratio-scroll-screen" :repo
                                       "jixiuf/golden-ratio-scroll-screen"
                                       :fetcher github :files
                                       ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                        "*.texinfo" "doc/dir" "doc/*.info"
                                        "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                                        "docs/dir" "docs/*.info" "docs/*.texi"
                                        "docs/*.texinfo"
                                        (:exclude ".dir-locals.el" "test.el"
                                                  "tests.el" "*-test.el"
                                                  "*-tests.el" "LICENSE"
                                                  "README*" "*-pkg.el"))
                                       :source #2# :protocol https :inherit t
                                       :depth treeless :ref
                                       "ed82ac7e9129c7be5983b44def0b9239b54d4dcf"))
 (vundo :source #1# :recipe
        (:package "vundo" :repo ("https://github.com/casouri/vundo" . "vundo")
                  :files ("*" (:exclude ".git" "test")) :source #2# :protocol
                  https :inherit t :depth treeless :ref
                  "288892ee93214ddcaf65fdd9f3134c1bd10100ee"))
 (multiple-cursors :source #1# :recipe
                   (:package "multiple-cursors" :fetcher github :repo
                             "magnars/multiple-cursors.el" :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source #2# :protocol https :inherit t :depth
                             treeless :ref
                             "89f1a8df9b1fc721b1672b4c7b6d3ab451e7e3ef"))
 (ace-mc :source #1# :recipe
         (:package "ace-mc" :repo "mm--/ace-mc" :fetcher github :files
                   ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                    "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                    "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                    "docs/*.texinfo"
                    (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                              "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                   :source #2# :protocol https :inherit t :depth treeless :ref
                   "6877880efd99e177e4e9116a364576def3da391b"))
 (expreg :source #1# :recipe
         (:package "expreg" :repo
                   ("https://github.com/casouri/expreg.git" . "expreg") :files
                   ("*" (:exclude ".git")) :source #2# :protocol https :inherit
                   t :depth treeless :ref
                   "9950c07ec90293964baa33603f4a80e764b0a847"))
 (easy-kill-extras :source #1# :recipe
                   (:package "easy-kill-extras" :fetcher github :repo
                             "knu/easy-kill-extras.el" :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source #2# :protocol https :inherit t :depth
                             treeless :ref
                             "ffc8a332893f26b43eb28ba56a714f875cc14183"))
 (zop-to-char :source #1# :recipe
              (:package "zop-to-char" :fetcher github :repo
                        "thierryvolpiatto/zop-to-char" :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source #2# :protocol https :inherit t :depth treeless
                        :ref "00152aa666354b27e56e20565f186b363afa0dce"))
 (hungry-delete :source #1# :recipe
                (:package "hungry-delete" :fetcher github :repo
                          "nflath/hungry-delete" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source #2# :protocol https :inherit t :depth treeless
                          :ref "d919e555e5c13a2edf4570f3ceec84f0ade71657"))
 (easy-kill :source #1# :recipe
            (:package "easy-kill" :fetcher github :repo "leoliu/easy-kill"
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "de7d66c3c864a4722a973ee9bc228a14be49ba0c"))
 (drag-stuff :source #1# :recipe
             (:package "drag-stuff" :repo "rejeep/drag-stuff.el" :fetcher github
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "6d06d846cd37c052d79acd0f372c13006aa7e7c8"))
 (visual-fill-column :source #1# :recipe
                     (:package "visual-fill-column" :fetcher codeberg :repo
                               "joostkremers/visual-fill-column" :files
                               ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                                "doc/*.texinfo" "lisp/*.el" "docs/dir"
                                "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                                (:exclude ".dir-locals.el" "test.el" "tests.el"
                                          "*-test.el" "*-tests.el" "LICENSE"
                                          "README*" "*-pkg.el"))
                               :source #2# :protocol https :inherit t :depth
                               treeless :ref
                               "11575df4e042f3263db62de0e8ee4f2331fbb1b4"))
 (ws-butler :source #1# :recipe
            (:package "ws-butler" :fetcher github :repo "lewang/ws-butler"
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "d3927f6131f215e9cd3e1f747be5a91e5be8ca9a"))
 (string-inflection :source #1# :recipe
                    (:package "string-inflection" :fetcher github :repo
                              "akicho8/string-inflection" :files
                              ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                               "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                               "doc/*.texinfo" "lisp/*.el" "docs/dir"
                               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                               (:exclude ".dir-locals.el" "test.el" "tests.el"
                                         "*-test.el" "*-tests.el" "LICENSE"
                                         "README*" "*-pkg.el"))
                              :source #2# :protocol https :inherit t :depth
                              treeless :ref
                              "617df25e91351feffe6aff4d9e4724733449d608"))
 (comment-dwim-2 :source #1# :recipe
                 (:package "comment-dwim-2" :fetcher github :repo
                           "remyferre/comment-dwim-2" :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source #2# :protocol https :inherit t :depth
                           treeless :ref
                           "6ab75d0a690f0080e9b97c730aac817d04144cd0"))
 (treemacs-nerd-icons :source #1# :recipe
                      (:package "treemacs-nerd-icons" :fetcher github :repo
                                "rainstormstudio/treemacs-nerd-icons" :files
                                ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                 "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                                 "doc/*.texinfo" "lisp/*.el" "docs/dir"
                                 "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                                 (:exclude ".dir-locals.el" "test.el" "tests.el"
                                           "*-test.el" "*-tests.el" "LICENSE"
                                           "README*" "*-pkg.el"))
                                :source #2# :protocol https :inherit t :depth
                                treeless :ref
                                "eac9fb5d92b8b29e7c4fcf9f3baddb2cb0b04575"))
 (treemacs :source #1# :recipe
           (:package "treemacs" :fetcher github :repo
                     "Alexander-Miller/treemacs" :files
                     (:defaults "Changelog.org" "icons" "src/elisp/treemacs*.el"
                                "src/scripts/treemacs*.py"
                                (:exclude "src/extra/*"))
                     :source #2# :protocol https :inherit t :depth treeless :ref
                     "32bb3dd02ddfca85661614b3b227e770fab821e2"))
 (sudo-edit :source #1# :recipe
            (:package "sudo-edit" :repo "nflath/sudo-edit" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "74eb1e6986461baed9a9269566ff838530b4379b"))
 (consult-dir :source #1# :recipe
              (:package "consult-dir" :fetcher github :repo
                        "karthink/consult-dir" :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source #2# :protocol https :inherit t :depth treeless
                        :ref "6cb46395df8f02ec5e5f4b58a08281e6981fda15"))
 (winum :source #1# :recipe
        (:package "winum" :fetcher github :repo "deb0ch/emacs-winum" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source #2# :protocol https :inherit t :depth treeless :ref
                  "c5455e866e8a5f7eab6a7263e2057aff5f1118b9"))
 (popper :source #1# :recipe
         (:package "popper" :fetcher github :repo "karthink/popper" :files
                   ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                    "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                    "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                    "docs/*.texinfo"
                    (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                              "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                   :source #2# :protocol https :inherit t :depth treeless :ref
                   "c0dced3cdff15d3ebfc56a52d7616b390255eb76"))
 (nerd-icons-ibuffer :source #1# :recipe
                     (:package "nerd-icons-ibuffer" :repo
                               "seagle0128/nerd-icons-ibuffer" :fetcher github
                               :files
                               ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                                "doc/*.texinfo" "lisp/*.el" "docs/dir"
                                "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                                (:exclude ".dir-locals.el" "test.el" "tests.el"
                                          "*-test.el" "*-tests.el" "LICENSE"
                                          "README*" "*-pkg.el"))
                               :source #2# :protocol https :inherit t :depth
                               treeless :ref
                               "16270e898abbba2bd810cbf97f999c6142863101"))
 (ibuffer-project :source #1# :recipe
                  (:package "ibuffer-project" :fetcher github :repo
                            "muffinmad/emacs-ibuffer-project" :files
                            ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                             "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                             "doc/*.texinfo" "lisp/*.el" "docs/dir"
                             "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                             (:exclude ".dir-locals.el" "test.el" "tests.el"
                                       "*-test.el" "*-tests.el" "LICENSE"
                                       "README*" "*-pkg.el"))
                            :source #2# :protocol https :inherit t :depth
                            treeless :ref
                            "9002abd9cb4c8753fe4f6c522d9407b4d52e7873"))
 (golden-ratio :source #1# :recipe
               (:package "golden-ratio" :repo "roman/golden-ratio.el" :fetcher
                         github :files
                         ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                          "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                          "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                          "docs/*.texinfo"
                          (:exclude ".dir-locals.el" "test.el" "tests.el"
                                    "*-test.el" "*-tests.el" "LICENSE" "README*"
                                    "*-pkg.el"))
                         :source #2# :protocol https :inherit t :depth treeless
                         :ref "375c9f287dfad68829582c1e0a67d0c18119dab9"))
 (ace-window :source #1# :recipe
             (:package "ace-window" :repo "abo-abo/ace-window" :fetcher github
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source #2# :protocol https :inherit t :depth treeless
                       :ref "77115afc1b0b9f633084cf7479c767988106c196"))
 (kkp :source #1# :recipe
      (:package "kkp" :fetcher github :repo "benjaminor/kkp" :files
                ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                 "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                 "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                 (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                           "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                :source #2# :protocol https :inherit t :depth treeless :ref
                "ad23d961c3a5dce83b1c9a6b4c65b48809c7af9a"))
 (clipetty :source #1# :recipe
           (:package "clipetty" :repo "spudlyo/clipetty" :fetcher github :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source #2# :protocol https :inherit t :depth treeless :ref
                     "01b39044b9b65fa4ea7d3166f8b1ffab6f740362"))
 (lv :source #1# :recipe
     (:package "lv" :repo "abo-abo/hydra" :fetcher github :files ("lv.el")
               :source #2# :protocol https :inherit t :depth treeless :ref
               "317e1de33086637579a7aeb60f77ed0405bf359b"))
 (hydra :source #1# :recipe
        (:package "hydra" :repo "abo-abo/hydra" :fetcher github :files
                  (:defaults (:exclude "lv.el")) :source #2# :protocol https
                  :inherit t :depth treeless :wait t :ref
                  "317e1de33086637579a7aeb60f77ed0405bf359b"))
 (which-key :source #1# :recipe
            (:package "which-key" :repo "justbur/emacs-which-key" :fetcher
                      github :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source #2# :protocol https :inherit t :depth treeless
                      :ref "38d4308d1143b61e4004b6e7a940686784e51500"))
 (blackout :source #1# :recipe
           (:package "blackout" :fetcher github :repo "radian-software/blackout"
                     :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source #2# :protocol https :inherit t :depth treeless
                     :wait t :ref "7707211370f03f03a2f74df15f42ac24a1e99300"))
 (elpaca-use-package :source #1# :recipe
                     (:package "elpaca-use-package" :wait t :repo
                               "https://github.com/progfolio/elpaca.git" :files
                               ("extensions/elpaca-use-package.el") :main
                               "extensions/elpaca-use-package.el" :build
                               (:not elpaca--compile-info) :source #2# :protocol
                               https :inherit t :depth treeless :ref
                               "7a68b7dc6b73094e0e3829efd009dbc6bd0fb495"))
 (elpaca :source
   #1# :recipe
   (:source nil :protocol https :inherit ignore :depth 1 :repo
            "https://github.com/progfolio/elpaca.git" :ref
            "7a68b7dc6b73094e0e3829efd009dbc6bd0fb495" :files
            (:defaults "elpaca-test.el" (:exclude "extensions")) :build
            (:not elpaca--activate-package) :package "elpaca")))
