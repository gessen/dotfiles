((ace-jump-mode :source "elpaca-menu-lock-file" :recipe
                (:package "ace-jump-mode" :repo "winterTTr/ace-jump-mode"
                          :fetcher github :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source "elpaca-menu-lock-file" :protocol https
                          :inherit t :depth treeless :ref
                          "8351e2df4fbbeb2a4003f2fb39f46d33803f3dac"))
 (ace-mc :source "elpaca-menu-lock-file" :recipe
         (:package "ace-mc" :repo "mm--/ace-mc" :fetcher github :files
                   ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                    "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                    "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                    "docs/*.texinfo"
                    (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                              "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                   :source "elpaca-menu-lock-file" :protocol https :inherit t
                   :depth treeless :ref
                   "6877880efd99e177e4e9116a364576def3da391b"))
 (ace-window :source "elpaca-menu-lock-file" :recipe
             (:package "ace-window" :repo "abo-abo/ace-window" :fetcher github
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "77115afc1b0b9f633084cf7479c767988106c196"))
 (async :source "elpaca-menu-lock-file" :recipe
        (:package "async" :repo "jwiegley/emacs-async" :fetcher github :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "elpaca-menu-lock-file" :protocol https :inherit t
                  :depth treeless :ref
                  "ca7f126d41d47b853839c964d248cd258cbfb63b"))
 (auto-yasnippet :source "elpaca-menu-lock-file" :recipe
                 (:package "auto-yasnippet" :fetcher github :repo
                           "abo-abo/auto-yasnippet" :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source "elpaca-menu-lock-file" :protocol https
                           :inherit t :depth treeless :ref
                           "6a9e406d0d7f9dfd6dff7647f358cb05a0b1637e"))
 (avy :source "elpaca-menu-lock-file" :recipe
      (:package "avy" :repo "abo-abo/avy" :fetcher github :files
                ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                 "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                 "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                 (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                           "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                :source "elpaca-menu-lock-file" :protocol https :inherit t
                :depth treeless :ref "933d1f36cca0f71e4acb5fac707e9ae26c536264"))
 (beginend :source "elpaca-menu-lock-file" :recipe
           (:package "beginend" :fetcher github :repo "DamienCassou/beginend"
                     :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source "elpaca-menu-lock-file" :protocol https :inherit t
                     :depth treeless :ref
                     "26d6142ceaf7c58705281852410b61ddc0d780ee"))
 (breadcrumb :source "elpaca-menu-lock-file" :recipe
             (:package "breadcrumb" :repo
                       ("https://github.com/joaotavora/breadcrumb"
                        . "breadcrumb")
                       :files ("*" (:exclude ".git")) :source
                       "elpaca-menu-lock-file" :protocol https :inherit t :depth
                       treeless :ref "da34d030e6d01db2bba45b30080204b23a714c9f"))
 (browse-at-remote :source "elpaca-menu-lock-file" :recipe
                   (:package "browse-at-remote" :repo
                             "rmuslimov/browse-at-remote" :fetcher github :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source "elpaca-menu-lock-file" :protocol https
                             :inherit t :depth treeless :ref
                             "76aa27dfd469fcae75ed7031bb73830831aaccbf"))
 (cape :source "elpaca-menu-lock-file" :recipe
       (:package "cape" :repo "minad/cape" :fetcher github :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source "elpaca-menu-lock-file" :protocol https :inherit t
                 :depth treeless :ref "97641dcd1ebca1007badd26b2fb9269b86934c22"))
 (centered-cursor-mode :source "elpaca-menu-lock-file" :recipe
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
                                 :source "elpaca-menu-lock-file" :protocol https
                                 :inherit t :depth treeless :ref
                                 "67ef719e685407dbc455c7430765e4e685fd95a9"))
 (circadian :source "elpaca-menu-lock-file" :recipe
            (:package "circadian" :fetcher github :repo
                      "guidoschmidt/circadian.el" :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "73fa3fd8b63af04bab877209397e42b83fbb9534"))
 (clipetty :source "elpaca-menu-lock-file" :recipe
           (:package "clipetty" :repo "spudlyo/clipetty" :fetcher github :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source "elpaca-menu-lock-file" :protocol https :inherit t
                     :depth treeless :ref
                     "01b39044b9b65fa4ea7d3166f8b1ffab6f740362"))
 (column-enforce-mode :source "elpaca-menu-lock-file" :recipe
                      (:package "column-enforce-mode" :fetcher github :repo
                                "jordonbiondo/column-enforce-mode" :files
                                ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                 "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                                 "doc/*.texinfo" "lisp/*.el" "docs/dir"
                                 "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                                 (:exclude ".dir-locals.el" "test.el" "tests.el"
                                           "*-test.el" "*-tests.el" "LICENSE"
                                           "README*" "*-pkg.el"))
                                :source "elpaca-menu-lock-file" :protocol https
                                :inherit t :depth treeless :ref
                                "14a7622f2268890e33536ccd29510024d51ee96f"))
 (comment-dwim-2 :source "elpaca-menu-lock-file" :recipe
                 (:package "comment-dwim-2" :fetcher github :repo
                           "remyferre/comment-dwim-2" :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source "elpaca-menu-lock-file" :protocol https
                           :inherit t :depth treeless :ref
                           "6ab75d0a690f0080e9b97c730aac817d04144cd0"))
 (cond-let :source "elpaca-menu-lock-file" :recipe
           (:package "cond-let" :fetcher github :repo "tarsius/cond-let" :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source "elpaca-menu-lock-file" :protocol https :inherit t
                     :depth treeless :ref
                     "79a16e1f2428f0f79f03250b987bc79cd37a029e"))
 (consult :source "elpaca-menu-lock-file" :recipe
          (:package "consult" :repo "minad/consult" :fetcher github :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "098462a6321a15afd4ae33fa8083658145332d9c"))
 (consult-dir :source "elpaca-menu-lock-file" :recipe
              (:package "consult-dir" :fetcher github :repo
                        "karthink/consult-dir" :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "elpaca-menu-lock-file" :protocol https :inherit
                        t :depth treeless :ref
                        "4532b8d215d16b0159691ce4dee693e72d71e0ff"))
 (consult-eglot :source "elpaca-menu-lock-file" :recipe
                (:package "consult-eglot" :fetcher github :repo
                          "mohkale/consult-eglot" :files
                          (:defaults "extensions/consult-eglot-embark/*")
                          :source "elpaca-menu-lock-file" :protocol https
                          :inherit t :depth treeless :ref
                          "d8b444aac39edfc6473ffbd228df3e9119451b51"))
 (consult-git-log-grep :source "elpaca-menu-lock-file" :recipe
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
                                 :source "elpaca-menu-lock-file" :protocol https
                                 :inherit t :depth treeless :ref
                                 "5b1669ebaff9a91000ea185264cfcb850885d21f"))
 (consult-ls-git :source "elpaca-menu-lock-file" :recipe
                 (:package "consult-ls-git" :repo "rcj/consult-ls-git" :fetcher
                           github :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source "elpaca-menu-lock-file" :protocol https
                           :inherit t :depth treeless :ref
                           "85882e4b7af9ad40160d985e42b36b0fd6400ead"))
 (consult-xref-stack :source "elpaca-menu-lock-file" :recipe
                     (:source "elpaca-menu-lock-file" :protocol https :inherit t
                              :depth treeless :host github :repo
                              "brett-lempereur/consult-xref-stack" :package
                              "consult-xref-stack" :ref
                              "aa9bbf7a3ff43353b7c10595b3d13887b213466b"))
 (consult-yasnippet :source "elpaca-menu-lock-file" :recipe
                    (:package "consult-yasnippet" :fetcher github :repo
                              "mohkale/consult-yasnippet" :files
                              ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                               "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                               "doc/*.texinfo" "lisp/*.el" "docs/dir"
                               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                               (:exclude ".dir-locals.el" "test.el" "tests.el"
                                         "*-test.el" "*-tests.el" "LICENSE"
                                         "README*" "*-pkg.el"))
                              :source "elpaca-menu-lock-file" :protocol https
                              :inherit t :depth treeless :ref
                              "a3482dfbdcbe487ba5ff934a1bb6047066ff2194"))
 (corfu :source "elpaca-menu-lock-file" :recipe
        (:package "corfu" :repo "minad/corfu" :files (:defaults "extensions/*")
                  :fetcher github :source "elpaca-menu-lock-file" :protocol
                  https :inherit t :depth treeless :ref
                  "8367a5a97576ced9745ca0376799b9ab07a93781"))
 (corfu-terminal :source "elpaca-menu-lock-file" :recipe
                 (:package "corfu-terminal" :repo "akib/emacs-corfu-terminal"
                           :files ("*" (:exclude ".git")) :source
                           "elpaca-menu-lock-file" :protocol https :inherit t
                           :depth treeless :host codeberg :ref
                           "501548c3d51f926c687e8cd838c5865ec45d03cc"))
 (dash :source "elpaca-menu-lock-file" :recipe
       (:package "dash" :fetcher github :repo "magnars/dash.el" :files
                 ("dash.el" "dash.texi") :source "elpaca-menu-lock-file"
                 :protocol https :inherit t :depth treeless :ref
                 "af5ea5d8a13735fa27d2c3e6f756d065639a7b45"))
 (deflate :source "elpaca-menu-lock-file" :recipe
          (:package "deflate" :fetcher github :repo "skuro/deflate" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "d3863855d213f73dc7a1a54736d94a75f8f7e9c5"))
 (devdocs :source "elpaca-menu-lock-file" :recipe
          (:package "devdocs" :fetcher github :repo "astoff/devdocs.el" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "4023409017d37dc2d6c230fe010fadb917b4395b"))
 (diff-hl :source "elpaca-menu-lock-file" :recipe
          (:package "diff-hl" :fetcher github :repo "dgutov/diff-hl" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "7677f245374488f8e09b8800334fc1b1e3d27468"))
 (dired-copy-paste :source "elpaca-menu-lock-file" :recipe
                   (:source "elpaca-menu-lock-file" :protocol https :inherit t
                            :depth treeless :host github :repo
                            "jsilve24/dired-copy-paste" :package
                            "dired-copy-paste" :ref
                            "aefb5597e65bc1a7b771c2c82961f5a10b5f424b"))
 (dired-hacks-utils :source "elpaca-menu-lock-file" :recipe
                    (:package "dired-hacks-utils" :fetcher github :repo
                              "Fuco1/dired-hacks" :files
                              ("dired-hacks-utils.el") :source
                              "elpaca-menu-lock-file" :protocol https :inherit t
                              :depth treeless :ref
                              "de9336f4b47ef901799fe95315fa080fa6d77b48"))
 (dired-hist :source "elpaca-menu-lock-file" :recipe
             (:package "dired-hist" :fetcher github :repo "Anoncheg1/dired-hist"
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "bcbfa60e2de0d86a38740d72bea7e4f25ccc35c8"))
 (dired-subtree :source "elpaca-menu-lock-file" :recipe
                (:package "dired-subtree" :fetcher github :repo
                          "Fuco1/dired-hacks" :files ("dired-subtree.el")
                          :source "elpaca-menu-lock-file" :protocol https
                          :inherit t :depth treeless :ref
                          "de9336f4b47ef901799fe95315fa080fa6d77b48"))
 (diredfl :source "elpaca-menu-lock-file" :recipe
          (:package "diredfl" :fetcher github :repo "purcell/diredfl" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "fe72d2e42ee18bf6228bba9d7086de4098f18a70"))
 (drag-stuff :source "elpaca-menu-lock-file" :recipe
             (:package "drag-stuff" :repo "rejeep/drag-stuff.el" :fetcher github
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "6d06d846cd37c052d79acd0f372c13006aa7e7c8"))
 (dumb-jump :source "elpaca-menu-lock-file" :recipe
            (:package "dumb-jump" :repo "jacktasia/dumb-jump" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "21545d3b8637b38f1930176f1c4782943ce3c0bd"))
 (easy-kill :source "elpaca-menu-lock-file" :recipe
            (:package "easy-kill" :fetcher github :repo "leoliu/easy-kill"
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "de7d66c3c864a4722a973ee9bc228a14be49ba0c"))
 (easy-kill-extras :source "elpaca-menu-lock-file" :recipe
                   (:package "easy-kill-extras" :fetcher github :repo
                             "knu/easy-kill-extras.el" :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source "elpaca-menu-lock-file" :protocol https
                             :inherit t :depth treeless :ref
                             "ffc8a332893f26b43eb28ba56a714f875cc14183"))
 (eglot :source "elpaca-menu-lock-file" :recipe
        (:package "eglot" :repo
                  ("https://github.com/emacs-mirror/emacs" . "eglot") :branch
                  "master" :files
                  ("lisp/progmodes/eglot.el" "doc/emacs/doclicense.texi"
                   "doc/emacs/docstyle.texi" "doc/misc/eglot.texi"
                   "etc/EGLOT-NEWS" (:exclude ".git"))
                  :source "elpaca-menu-lock-file" :protocol https :inherit t
                  :depth treeless :ref
                  "0bf5898f20571897dc540d10cdc6f4c3a517a82c"))
 (eglot-booster :source "elpaca-menu-lock-file" :recipe
                (:source "elpaca-menu-lock-file" :protocol https :inherit t
                         :depth treeless :host github :repo
                         "jdtsmith/eglot-booster" :package "eglot-booster" :ref
                         "cab7803c4f0adc7fff9da6680f90110674bb7a22"))
 (eglot-semantic-tokens :source "elpaca-menu-lock-file" :recipe
                        (:source "elpaca-menu-lock-file" :protocol https
                                 :inherit t :depth treeless :host codeberg :repo
                                 "eownerdead/eglot-semantic-tokens" :package
                                 "eglot-semantic-tokens" :ref
                                 "fcb25e048bff2b9fa0a70b85d4d07951aa6e1022"))
 (eglot-x :source "elpaca-menu-lock-file" :recipe
          (:source "elpaca-menu-lock-file" :protocol https :inherit t :depth
                   treeless :host github :repo "nemethf/eglot-x" :package
                   "eglot-x" :ref "8e872efd3d0b7779bde5b1e1d75c8e646a1f729f"))
 (elisp-lint :source "elpaca-menu-lock-file" :recipe
             (:package "elisp-lint" :fetcher github :repo
                       "gonewest818/elisp-lint" :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "c5765abf75fd1ad22505b349ae1e6be5303426c2"))
 (elisp-refs :source "elpaca-menu-lock-file" :recipe
             (:package "elisp-refs" :repo "Wilfred/elisp-refs" :fetcher github
                       :files (:defaults (:exclude "elisp-refs-bench.el"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "541a064c3ce27867872cf708354a65d83baf2a6d"))
 (elpaca :source
   "elpaca-menu-lock-file" :recipe
   (:source nil :protocol https :inherit ignore :depth 1 :repo
            "https://github.com/progfolio/elpaca.git" :ref
            "10e65441f34253254272aeacd300574b576894a2" :files
            (:defaults "elpaca-test.el" (:exclude "extensions")) :build
            (:not elpaca--activate-package) :package "elpaca"))
 (elpaca-use-package :source "elpaca-menu-lock-file" :recipe
                     (:package "elpaca-use-package" :wait t :repo
                               "https://github.com/progfolio/elpaca.git" :files
                               ("extensions/elpaca-use-package.el") :main
                               "extensions/elpaca-use-package.el" :build
                               (:not elpaca--compile-info) :source
                               "elpaca-menu-lock-file" :protocol https :inherit
                               t :depth treeless :ref
                               "10e65441f34253254272aeacd300574b576894a2"))
 (embark :source "elpaca-menu-lock-file" :recipe
         (:package "embark" :repo "oantolin/embark" :fetcher github :files
                   ("embark.el" "embark-org.el" "embark.texi") :source
                   "elpaca-menu-lock-file" :protocol https :inherit t :depth
                   treeless :ref "1371a1e33e3a3d96557beb28dccf1fa762f6ae22"))
 (embark-consult :source "elpaca-menu-lock-file" :recipe
                 (:package "embark-consult" :repo "oantolin/embark" :fetcher
                           github :files ("embark-consult.el") :source
                           "elpaca-menu-lock-file" :protocol https :inherit t
                           :depth treeless :ref
                           "1371a1e33e3a3d96557beb28dccf1fa762f6ae22"))
 (expreg :source "elpaca-menu-lock-file" :recipe
         (:package "expreg" :repo
                   ("https://github.com/casouri/expreg.git" . "expreg") :files
                   ("*" (:exclude ".git")) :source "elpaca-menu-lock-file"
                   :protocol https :inherit t :depth treeless :ref
                   "af897a63fb14f98c0e897e1ce09f052bc494ec87"))
 (f :source "elpaca-menu-lock-file" :recipe
    (:package "f" :fetcher github :repo "rejeep/f.el" :files
              ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
               "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
               (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                         "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
              :source "elpaca-menu-lock-file" :protocol https :inherit t :depth
              treeless :ref "931b6d0667fe03e7bf1c6c282d6d8d7006143c52"))
 (fancy-compilation :source "elpaca-menu-lock-file" :recipe
                    (:package "fancy-compilation" :fetcher codeberg :repo
                              "ideasman42/emacs-fancy-compilation" :files
                              ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                               "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                               "doc/*.texinfo" "lisp/*.el" "docs/dir"
                               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                               (:exclude ".dir-locals.el" "test.el" "tests.el"
                                         "*-test.el" "*-tests.el" "LICENSE"
                                         "README*" "*-pkg.el"))
                              :source "elpaca-menu-lock-file" :protocol https
                              :inherit t :depth treeless :ref
                              "51f6945c84e6d0e09d45698f1b9056e73fd79fa9"))
 (fd-dired :source "elpaca-menu-lock-file" :recipe
           (:package "fd-dired" :fetcher github :repo "yqrashawn/fd-dired"
                     :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source "elpaca-menu-lock-file" :protocol https :inherit t
                     :depth treeless :ref
                     "458464771bb220b6eb87ccfd4c985c436e57dc7e"))
 (fish-mode :source "elpaca-menu-lock-file" :recipe
            (:package "fish-mode" :fetcher github :repo "wwwjfy/emacs-fish"
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "2526b1803b58cf145bc70ff6ce2adb3f6c246f89"))
 (flymake-collection :source "elpaca-menu-lock-file" :recipe
                     (:package "flymake-collection" :fetcher github :repo
                               "mohkale/flymake-collection" :files
                               (:defaults "src/*.el" "src/checkers/*.el")
                               :old-names (flymake-rest) :source
                               "elpaca-menu-lock-file" :protocol https :inherit
                               t :depth treeless :ref
                               "909d98d9ec70c2baa5467634ec37181a058f2548"))
 (flymake-popon :source "elpaca-menu-lock-file" :recipe
                (:package "flymake-popon" :repo
                          ("https://codeberg.org/akib/emacs-flymake-popon"
                           . "flymake-popon")
                          :files ("*" (:exclude ".git")) :source
                          "elpaca-menu-lock-file" :protocol https :inherit t
                          :depth treeless :ref
                          "99ea813346f3edef7220d8f4faeed2ec69af6060"))
 (frog-jump-buffer :source "elpaca-menu-lock-file" :recipe
                   (:package "frog-jump-buffer" :repo
                             "waymondo/frog-jump-buffer" :fetcher github :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source "elpaca-menu-lock-file" :protocol https
                             :inherit t :depth treeless :ref
                             "ab830cb7a5af9429866ba88fb37589a0366d8bf2"))
 (frog-menu :source "elpaca-menu-lock-file" :recipe
            (:package "frog-menu" :repo
                      ("https://github.com/clemera/frog-menu" . "frog-menu")
                      :files ("*" (:exclude ".git")) :source
                      "elpaca-menu-lock-file" :protocol https :inherit t :depth
                      treeless :ref "2b8d04c1a03b339e2eaf031eacd0d9d615a21322"))
 (git-modes :source "elpaca-menu-lock-file" :recipe
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
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "7063d66857023e6c010cecac52de67c0baa77fb7"))
 (golden-ratio-scroll-screen :source "elpaca-menu-lock-file" :recipe
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
                                       :source "elpaca-menu-lock-file" :protocol
                                       https :inherit t :depth treeless :ref
                                       "60eb00ed7e51c0875a38cff25c9a87fe79296484"))
 (goto-chg :source "elpaca-menu-lock-file" :recipe
           (:package "goto-chg" :repo "emacs-evil/goto-chg" :fetcher github
                     :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source "elpaca-menu-lock-file" :protocol https :inherit t
                     :depth treeless :ref
                     "72f556524b88e9d30dc7fc5b0dc32078c166fda7"))
 (grip-mode :source "elpaca-menu-lock-file" :recipe
            (:package "grip-mode" :repo "seagle0128/grip-mode" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "11fecd5b38c78597ff53a39fb3a090e7c80350fa"))
 (helpful :source "elpaca-menu-lock-file" :recipe
          (:package "helpful" :repo "Wilfred/helpful" :fetcher github :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "03756fa6ad4dcca5e0920622b1ee3f70abfc4e39"))
 (highlight-indent-guides :source "elpaca-menu-lock-file" :recipe
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
                                    :source "elpaca-menu-lock-file" :protocol
                                    https :inherit t :depth treeless :ref
                                    "dfc43e0741444c50adbb1140dfe67d780752a18b"))
 (highlight-numbers :source "elpaca-menu-lock-file" :recipe
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
                              :source "elpaca-menu-lock-file" :protocol https
                              :inherit t :depth treeless :ref
                              "8b4744c7f46c72b1d3d599d4fb75ef8183dee307"))
 (highlight-parentheses :source "elpaca-menu-lock-file" :recipe
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
                                  :source "elpaca-menu-lock-file" :protocol
                                  https :inherit t :depth treeless :ref
                                  "965b18dd69eff4457e17c9e84b3cbfdbfca2ddfb"))
 (hl-todo :source "elpaca-menu-lock-file" :recipe
          (:package "hl-todo" :repo "tarsius/hl-todo" :fetcher github :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "862d903e7242f3cf90e05846aa52a4270851d496"))
 (ht :source "elpaca-menu-lock-file" :recipe
     (:package "ht" :fetcher github :repo "Wilfred/ht.el" :files
               ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
                "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                          "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
               :source "elpaca-menu-lock-file" :protocol https :inherit t :depth
               treeless :ref "1c49aad1c820c86f7ee35bf9fff8429502f60fef"))
 (htmlize :source "elpaca-menu-lock-file" :recipe
          (:package "htmlize" :fetcher github :repo "emacsorphanage/htmlize"
                    :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "c9a8196a59973fabb3763b28069af9a4822a5260"))
 (hungry-delete :source "elpaca-menu-lock-file" :recipe
                (:package "hungry-delete" :fetcher github :repo
                          "nflath/hungry-delete" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source "elpaca-menu-lock-file" :protocol https
                          :inherit t :depth treeless :ref
                          "d919e555e5c13a2edf4570f3ceec84f0ade71657"))
 (hydra :source "elpaca-menu-lock-file" :recipe
        (:package "hydra" :repo "abo-abo/hydra" :fetcher github :files
                  (:defaults (:exclude "lv.el")) :source "elpaca-menu-lock-file"
                  :protocol https :inherit t :depth treeless :wait t :ref
                  "59a2a45a35027948476d1d7751b0f0215b1e61aa"))
 (ibuffer-project :source "elpaca-menu-lock-file" :recipe
                  (:package "ibuffer-project" :fetcher github :repo
                            "muffinmad/emacs-ibuffer-project" :files
                            ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                             "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                             "doc/*.texinfo" "lisp/*.el" "docs/dir"
                             "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                             (:exclude ".dir-locals.el" "test.el" "tests.el"
                                       "*-test.el" "*-tests.el" "LICENSE"
                                       "README*" "*-pkg.el"))
                            :source "elpaca-menu-lock-file" :protocol https
                            :inherit t :depth treeless :ref
                            "9002abd9cb4c8753fe4f6c522d9407b4d52e7873"))
 (iedit :source "elpaca-menu-lock-file" :recipe
        (:package "iedit" :repo "victorhge/iedit" :fetcher github :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "elpaca-menu-lock-file" :protocol https :inherit t
                  :depth treeless :ref
                  "27c61866b1b9b8d77629ac702e5f48e67dfe0d3b"))
 (jeison :source "elpaca-menu-lock-file" :recipe
         (:package "jeison" :repo "SavchenkoValeriy/jeison" :fetcher github
                   :files
                   ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                    "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                    "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                    "docs/*.texinfo"
                    (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                              "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                   :source "elpaca-menu-lock-file" :protocol https :inherit t
                   :depth treeless :ref
                   "19a51770f24eaa7b538c7be6a8a5c25d154b641f"))
 (jinx :source "elpaca-menu-lock-file" :recipe
       (:package "jinx" :repo "minad/jinx" :files
                 (:defaults "jinx-mod.c" "emacs-module.h") :fetcher github
                 :source "elpaca-menu-lock-file" :protocol https :inherit t
                 :depth treeless :ref "8d9cca951de02ef33c3ef0ed31c0bf62984d3680"))
 (keycast :source "elpaca-menu-lock-file" :recipe
          (:package "keycast" :fetcher github :repo "tarsius/keycast" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "f23f6823710c4d194cbdb5f1a0532d1d6fe0d968"))
 (kkp :source "elpaca-menu-lock-file" :recipe
      (:package "kkp" :fetcher github :repo "benotn/kkp" :files
                ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                 "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                 "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                 (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                           "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                :source "elpaca-menu-lock-file" :protocol https :inherit t
                :depth treeless :ref "1a7b4f395aa4e1e04afc45fe2dbd6a045871803b"))
 (llama :source "elpaca-menu-lock-file" :recipe
        (:package "llama" :fetcher github :repo "tarsius/llama" :files
                  ("llama.el" ".dir-locals.el") :source "elpaca-menu-lock-file"
                  :protocol https :inherit t :depth treeless :ref
                  "ec1d4ef02f5572fc5aff3f62d3e7ef791f444456"))
 (lv :source "elpaca-menu-lock-file" :recipe
     (:package "lv" :repo "abo-abo/hydra" :fetcher github :files ("lv.el")
               :source "elpaca-menu-lock-file" :protocol https :inherit t :depth
               treeless :ref "59a2a45a35027948476d1d7751b0f0215b1e61aa"))
 (macrostep :source "elpaca-menu-lock-file" :recipe
            (:package "macrostep" :fetcher github :repo
                      "emacsorphanage/macrostep" :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "d0928626b4711dcf9f8f90439d23701118724199"))
 (magit :source "elpaca-menu-lock-file" :recipe
        (:package "magit" :fetcher github :repo "magit/magit" :files
                  ("lisp/magit*.el" "lisp/git-*.el" "docs/magit.texi"
                   "docs/AUTHORS.md" "LICENSE" ".dir-locals.el"
                   (:exclude "lisp/magit-section.el"))
                  :source "elpaca-menu-lock-file" :protocol https :inherit t
                  :depth treeless :ref
                  "2cca6a4be5e6c7e347f96afcc6da9f13c2b49c9a"))
 (magit-blame-color-by-age :source "elpaca-menu-lock-file" :recipe
                           (:source "elpaca-menu-lock-file" :protocol https
                                    :inherit t :depth treeless :host github
                                    :repo "jdtsmith/magit-blame-color-by-age"
                                    :package "magit-blame-color-by-age" :ref
                                    "d0de4159a225d2d8bf51723b8d47e2ba7f221783"))
 (magit-delta :source "elpaca-menu-lock-file" :recipe
              (:package "magit-delta" :fetcher github :repo
                        "dandavison/magit-delta" :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "elpaca-menu-lock-file" :protocol https :inherit
                        t :depth treeless :ref
                        "5fc7dbddcfacfe46d3fd876172ad02a9ab6ac616"))
 (magit-section :source "elpaca-menu-lock-file" :recipe
                (:package "magit-section" :fetcher github :repo "magit/magit"
                          :files
                          ("lisp/magit-section.el" "docs/magit-section.texi"
                           "magit-section-pkg.el")
                          :source "elpaca-menu-lock-file" :protocol https
                          :inherit t :depth treeless :ref
                          "2cca6a4be5e6c7e347f96afcc6da9f13c2b49c9a"))
 (magit-todos :source "elpaca-menu-lock-file" :recipe
              (:package "magit-todos" :fetcher github :repo
                        "alphapapa/magit-todos" :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "elpaca-menu-lock-file" :protocol https :inherit
                        t :depth treeless :ref
                        "bd27c57eada0fda1cc0a813db04731a9bcc51b7b"))
 (marginalia :source "elpaca-menu-lock-file" :recipe
             (:package "marginalia" :repo "minad/marginalia" :fetcher github
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "cb3a69c039cf3b4ab007a72f802fc5f4699e8120"))
 (markdown-mode :source "elpaca-menu-lock-file" :recipe
                (:package "markdown-mode" :fetcher github :repo
                          "jrblevin/markdown-mode" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source "elpaca-menu-lock-file" :protocol https
                          :inherit t :depth treeless :ref
                          "d51c469133d220823cc6ab50ff8e8743ed6e42fb"))
 (markdown-toc :source "elpaca-menu-lock-file" :recipe
               (:package "markdown-toc" :fetcher github :repo
                         "ardumont/markdown-toc" :files
                         ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                          "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                          "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                          "docs/*.texinfo"
                          (:exclude ".dir-locals.el" "test.el" "tests.el"
                                    "*-test.el" "*-tests.el" "LICENSE" "README*"
                                    "*-pkg.el"))
                         :source "elpaca-menu-lock-file" :protocol https
                         :inherit t :depth treeless :ref
                         "e3429d3014655b7d2ff6d5ac12b27d4d94fdcee4"))
 (mathjax :source "elpaca-menu-lock-file" :recipe
          (:package "mathjax" :repo
                    ("https://github.com/astoff/mathjax.el" . "mathjax") :files
                    ("*" (:exclude ".git")) :source "elpaca-menu-lock-file"
                    :protocol https :inherit t :depth treeless :ref
                    "db669451bbee7d2ea9872c28661c4679391b9644"))
 (meson-mode :source "elpaca-menu-lock-file" :recipe
             (:package "meson-mode" :fetcher github :repo "wentasah/meson-mode"
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "0449c649daaa9322e1c439c1540d8c290501d455"))
 (minions :source "elpaca-menu-lock-file" :recipe
          (:package "minions" :fetcher github :repo "tarsius/minions" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "7ccb5e23a54c10f64880d1f55676f86681ff2f07"))
 (modus-themes :source "elpaca-menu-lock-file" :recipe
               (:package "modus-themes" :fetcher github :repo
                         "protesilaos/modus-themes" :files
                         ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                          "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                          "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                          "docs/*.texinfo"
                          (:exclude ".dir-locals.el" "test.el" "tests.el"
                                    "*-test.el" "*-tests.el" "LICENSE" "README*"
                                    "*-pkg.el"))
                         :source "elpaca-menu-lock-file" :protocol https
                         :inherit t :depth treeless :ref
                         "a391efc0f8e9f3ab4c932b403948d4b3ed1af040"))
 (multiple-cursors :source "elpaca-menu-lock-file" :recipe
                   (:package "multiple-cursors" :fetcher github :repo
                             "magnars/multiple-cursors.el" :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source "elpaca-menu-lock-file" :protocol https
                             :inherit t :depth treeless :ref
                             "89f1a8df9b1fc721b1672b4c7b6d3ab451e7e3ef"))
 (mwim :source "elpaca-menu-lock-file" :recipe
       (:package "mwim" :repo "alezost/mwim.el" :fetcher github :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source "elpaca-menu-lock-file" :protocol https :inherit t
                 :depth treeless :ref "b4f3edb4c0fb8f8b71cecbf8095c2c25a8ffbf85"))
 (nerd-icons :source "elpaca-menu-lock-file" :recipe
             (:package "nerd-icons" :repo "rainstormstudio/nerd-icons.el"
                       :fetcher github :files (:defaults "data") :source
                       "elpaca-menu-lock-file" :protocol https :inherit t :depth
                       treeless :ref "3774e0578b1023bd2ae10735e28c0cd1ccf46889"))
 (nerd-icons-completion :source "elpaca-menu-lock-file" :recipe
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
                                  :source "elpaca-menu-lock-file" :protocol
                                  https :inherit t :depth treeless :ref
                                  "d7582d430283d8e085227a249f6c8b79199b1829"))
 (nerd-icons-corfu :source "elpaca-menu-lock-file" :recipe
                   (:package "nerd-icons-corfu" :fetcher github :repo
                             "LuigiPiucco/nerd-icons-corfu" :files
                             ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                              "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                              "doc/*.texinfo" "lisp/*.el" "docs/dir"
                              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                              (:exclude ".dir-locals.el" "test.el" "tests.el"
                                        "*-test.el" "*-tests.el" "LICENSE"
                                        "README*" "*-pkg.el"))
                             :source "elpaca-menu-lock-file" :protocol https
                             :inherit t :depth treeless :ref
                             "f821e953b1a3dc9b381bc53486aabf366bf11cb1"))
 (nerd-icons-dired :source "elpaca-menu-lock-file" :recipe
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
                             :source "elpaca-menu-lock-file" :protocol https
                             :inherit t :depth treeless :ref
                             "adf9a2bb5f3f13be7a676923639337f3fcc5d8c3"))
 (nerd-icons-ibuffer :source "elpaca-menu-lock-file" :recipe
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
                               :source "elpaca-menu-lock-file" :protocol https
                               :inherit t :depth treeless :ref
                               "1b0b6dd3e2e89e6d120218ac11b7534e0b268f5b"))
 (orderless :source "elpaca-menu-lock-file" :recipe
            (:package "orderless" :repo "oantolin/orderless" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "211ccb906b9444f7210106909b37c402d582731a"))
 (org-contrib :source "elpaca-menu-lock-file" :recipe
              (:package "org-contrib" :repo
                        ("https://git.sr.ht/~bzg/org-contrib" . "org-contrib")
                        :files (:defaults) :source "elpaca-menu-lock-file"
                        :protocol https :inherit t :depth treeless :ref
                        "f1f6b6ec812803ff99693255555a82960fb3545a"))
 (org-modern :source "elpaca-menu-lock-file" :recipe
             (:package "org-modern" :repo "minad/org-modern" :fetcher github
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "d5e1f5af65cce53113e017d319edaff25641e15b"))
 (org-sticky-header :source "elpaca-menu-lock-file" :recipe
                    (:package "org-sticky-header" :fetcher github :repo
                              "alphapapa/org-sticky-header" :files
                              ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                               "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                               "doc/*.texinfo" "lisp/*.el" "docs/dir"
                               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                               (:exclude ".dir-locals.el" "test.el" "tests.el"
                                         "*-test.el" "*-tests.el" "LICENSE"
                                         "README*" "*-pkg.el"))
                              :source "elpaca-menu-lock-file" :protocol https
                              :inherit t :depth treeless :ref
                              "697875935b04b25c8229b9155a1ea0cab3ebe629"))
 (ox-pandoc :source "elpaca-menu-lock-file" :recipe
            (:package "ox-pandoc" :repo "emacsorphanage/ox-pandoc" :fetcher
                      github :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "5766c70b6db5a553829ccdcf52fcf3c6244e443d"))
 (ox-reveal :source "elpaca-menu-lock-file" :recipe
            (:package "ox-reveal" :repo "yjwen/org-reveal" :fetcher github
                      :old-names (org-reveal) :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "f55c851bf6aeb1bb2a7f6cf0f2b7bd0e79c4a5a0"))
 (package-lint :source "elpaca-menu-lock-file" :recipe
               (:package "package-lint" :fetcher github :repo
                         "purcell/package-lint" :files
                         (:defaults "data" (:exclude "*flymake.el")) :source
                         "elpaca-menu-lock-file" :protocol https :inherit t
                         :depth treeless :ref
                         "f990665a1b4ca9eadbfcdb0b2a22fbb819e78ef4"))
 (parent-mode :source "elpaca-menu-lock-file" :recipe
              (:package "parent-mode" :fetcher github :repo "Fanael/parent-mode"
                        :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "elpaca-menu-lock-file" :protocol https :inherit
                        t :depth treeless :ref
                        "fbd49857ab2e4cd0c5611c0cc83f93711657b298"))
 (pcre2el :source "elpaca-menu-lock-file" :recipe
          (:package "pcre2el" :fetcher github :repo "joddie/pcre2el" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "b4d846d80dddb313042131cf2b8fbf647567e000"))
 (pkgbuild-mode :source "elpaca-menu-lock-file" :recipe
                (:package "pkgbuild-mode" :fetcher github :repo
                          "juergenhoetzel/pkgbuild-mode" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source "elpaca-menu-lock-file" :protocol https
                          :inherit t :depth treeless :ref
                          "aadf3d1d19c5eb9b52c15c5b73b1a46faac5b7d5"))
 (plantuml-mode :source "elpaca-menu-lock-file" :recipe
                (:package "plantuml-mode" :fetcher github :repo
                          "skuro/plantuml-mode" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source "elpaca-menu-lock-file" :protocol https
                          :inherit t :depth treeless :ref
                          "348e83ff193051d5ad332642100dd704f6e2a6d2"))
 (popon :source "elpaca-menu-lock-file" :recipe
        (:package "popon" :repo
                  ("https://codeberg.org/akib/emacs-popon" . "popon") :files
                  ("*" (:exclude ".git")) :source "elpaca-menu-lock-file"
                  :protocol https :inherit t :depth treeless :ref
                  "bf8174cb7e6e8fe0fe91afe6b01b6562c4dc39da"))
 (popup :source "elpaca-menu-lock-file" :recipe
        (:package "popup" :fetcher github :repo "auto-complete/popup-el" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "elpaca-menu-lock-file" :protocol https :inherit t
                  :depth treeless :ref
                  "b189a4e8ccf18356395878c3d38a23df834d3898"))
 (posframe :source "elpaca-menu-lock-file" :recipe
           (:package "posframe" :fetcher github :repo "tumashu/posframe" :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source "elpaca-menu-lock-file" :protocol https :inherit t
                     :depth treeless :ref
                     "12f540c9ad5da09673b2bca1132b41f94c134e82"))
 (powerthesaurus :source "elpaca-menu-lock-file" :recipe
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
                           :source "elpaca-menu-lock-file" :protocol https
                           :inherit t :depth treeless :ref
                           "4b97797cf789aaba411c61a85fe23474ebc5bedc"))
 (pulsar :source "elpaca-menu-lock-file" :recipe
         (:package "pulsar" :repo
                   ("https://github.com/protesilaos/pulsar" . "pulsar") :files
                   ("*" (:exclude ".git" "COPYING" "doclicense.texi")) :source
                   "elpaca-menu-lock-file" :protocol https :inherit t :depth
                   treeless :ref "14d89f691d6aa0ae3292e7845c3113662d71b692"))
 (rainbow-delimiters :source "elpaca-menu-lock-file" :recipe
                     (:package "rainbow-delimiters" :fetcher github :repo
                               "Fanael/rainbow-delimiters" :files
                               ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                                "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                                "doc/*.texinfo" "lisp/*.el" "docs/dir"
                                "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                                (:exclude ".dir-locals.el" "test.el" "tests.el"
                                          "*-test.el" "*-tests.el" "LICENSE"
                                          "README*" "*-pkg.el"))
                               :source "elpaca-menu-lock-file" :protocol https
                               :inherit t :depth treeless :ref
                               "f40ece58df8b2f0fb6c8576b527755a552a5e763"))
 (reformatter :source "elpaca-menu-lock-file" :recipe
              (:package "reformatter" :repo "purcell/emacs-reformatter" :fetcher
                        github :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "elpaca-menu-lock-file" :protocol https :inherit
                        t :depth treeless :ref
                        "c52e91d5438b9bf16b77b4384822e254f10a6b0a"))
 (s :source "elpaca-menu-lock-file" :recipe
    (:package "s" :fetcher github :repo "magnars/s.el" :files
              ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
               "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
               (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                         "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
              :source "elpaca-menu-lock-file" :protocol https :inherit t :depth
              treeless :ref "dda84d38fffdaf0c9b12837b504b402af910d01d"))
 (shfmt :source "elpaca-menu-lock-file" :recipe
        (:package "shfmt" :fetcher github :repo "purcell/emacs-shfmt" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "elpaca-menu-lock-file" :protocol https :inherit t
                  :depth treeless :ref
                  "1f838a07b88380b654ef4ae759e73a720db6a166"))
 (spacious-padding :source "elpaca-menu-lock-file" :recipe
                   (:package "spacious-padding" :repo
                             ("https://github.com/protesilaos/spacious-padding"
                              . "spacious-padding")
                             :files
                             ("*" (:exclude ".git" "COPYING" "doclicense.texi"))
                             :source "elpaca-menu-lock-file" :protocol https
                             :inherit t :depth treeless :ref
                             "342aeabe0a7e6e0cab75c8f078cd8569f8c3fccb"))
 (ssh-config-mode :source "elpaca-menu-lock-file" :recipe
                  (:package "ssh-config-mode" :fetcher github :repo
                            "peterhoeg/ssh-config-mode-el" :files
                            (:defaults "*.txt") :source "elpaca-menu-lock-file"
                            :protocol https :inherit t :depth treeless :ref
                            "d0596f5fbeab3d2c3c30eb83527316403bc5b2f7"))
 (string-inflection :source "elpaca-menu-lock-file" :recipe
                    (:package "string-inflection" :fetcher github :repo
                              "akicho8/string-inflection" :files
                              ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                               "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                               "doc/*.texinfo" "lisp/*.el" "docs/dir"
                               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                               (:exclude ".dir-locals.el" "test.el" "tests.el"
                                         "*-test.el" "*-tests.el" "LICENSE"
                                         "README*" "*-pkg.el"))
                              :source "elpaca-menu-lock-file" :protocol https
                              :inherit t :depth treeless :ref
                              "91d6c991abcf9cfb2af403368962a9c7983235b4"))
 (substitute :source "elpaca-menu-lock-file" :recipe
             (:package "substitute" :repo
                       ("https://github.com/protesilaos/substitute"
                        . "substitute")
                       :files
                       ("*" (:exclude ".git" "COPYING" "doclicense.texi"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "a1afb50cea273514ab6655b136fe11973d35af96"))
 (sudo-edit :source "elpaca-menu-lock-file" :recipe
            (:package "sudo-edit" :repo "nflath/sudo-edit" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "74eb1e6986461baed9a9269566ff838530b4379b"))
 (surround :source "elpaca-menu-lock-file" :recipe
           (:package "surround" :fetcher github :repo "mkleehammer/surround"
                     :files
                     ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                      "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                      "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                      "docs/*.texinfo"
                      (:exclude ".dir-locals.el" "test.el" "tests.el"
                                "*-test.el" "*-tests.el" "LICENSE" "README*"
                                "*-pkg.el"))
                     :source "elpaca-menu-lock-file" :protocol https :inherit t
                     :depth treeless :ref
                     "6807bf69be1591a419a009adf8a5071b1cdcc76e"))
 (symbol-overlay :source "elpaca-menu-lock-file" :recipe
                 (:package "symbol-overlay" :fetcher github :repo
                           "wolray/symbol-overlay" :files
                           ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                            "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                            "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                            "docs/*.texinfo"
                            (:exclude ".dir-locals.el" "test.el" "tests.el"
                                      "*-test.el" "*-tests.el" "LICENSE"
                                      "README*" "*-pkg.el"))
                           :source "elpaca-menu-lock-file" :protocol https
                           :inherit t :depth treeless :ref
                           "6151f4279bd94b5960149596b202cdcb45cacec2"))
 (tabgo :source "elpaca-menu-lock-file" :recipe
        (:package "tabgo" :fetcher github :repo "isamert/tabgo.el" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "elpaca-menu-lock-file" :protocol https :inherit t
                  :depth treeless :ref
                  "b72f1b1fa58b888e29fda268d094c5d210b8b8e8"))
 (toc-org :source "elpaca-menu-lock-file" :recipe
          (:package "toc-org" :fetcher github :repo "snosov1/toc-org" :old-names
                    (org-toc) :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "6d3ae0fc47ce79b1ea06cabe21a3c596395409cd"))
 (transient :source "elpaca-menu-lock-file" :recipe
            (:package "transient" :fetcher github :repo "magit/transient" :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "9c5b936ce8a22f4d13cc07da75749d62508d4d23"))
 (treesit-auto :source "elpaca-menu-lock-file" :recipe
               (:package "treesit-auto" :fetcher github :repo
                         "renzmann/treesit-auto" :files
                         ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                          "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                          "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                          "docs/*.texinfo"
                          (:exclude ".dir-locals.el" "test.el" "tests.el"
                                    "*-test.el" "*-tests.el" "LICENSE" "README*"
                                    "*-pkg.el"))
                         :source "elpaca-menu-lock-file" :protocol https
                         :inherit t :depth treeless :ref
                         "016bd286a1ba4628f833a626f8b9d497882ecdf3"))
 (undo-fu :source "elpaca-menu-lock-file" :recipe
          (:package "undo-fu" :fetcher codeberg :repo "ideasman42/emacs-undo-fu"
                    :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :protocol https :inherit t
                    :depth treeless :ref
                    "545e29459e71a9aca81c96c1385d43a5696e27e9"))
 (undo-fu-session :source "elpaca-menu-lock-file" :recipe
                  (:package "undo-fu-session" :fetcher codeberg :repo
                            "ideasman42/emacs-undo-fu-session" :files
                            ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                             "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                             "doc/*.texinfo" "lisp/*.el" "docs/dir"
                             "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                             (:exclude ".dir-locals.el" "test.el" "tests.el"
                                       "*-test.el" "*-tests.el" "LICENSE"
                                       "README*" "*-pkg.el"))
                            :source "elpaca-menu-lock-file" :protocol https
                            :inherit t :depth treeless :ref
                            "ee4bbead4bb325a10cf8f292ccc66830f8048f41"))
 (vertico :source "elpaca-menu-lock-file" :recipe
          (:package "vertico" :repo "minad/vertico" :files
                    (:defaults "extensions/*") :fetcher github :source
                    "elpaca-menu-lock-file" :protocol https :inherit t :depth
                    treeless :ref "4a11453e9de3d92b566bf0aa032da96b5b2e6770"))
 (vlf :source "elpaca-menu-lock-file" :recipe
      (:package "vlf" :repo ("https://github.com/emacsmirror/gnu_elpa" . "vlf")
                :branch "externals/vlf" :files ("*" (:exclude ".git")) :source
                "elpaca-menu-lock-file" :protocol https :inherit t :depth
                treeless :ref "6192573ee088079bf1f81abc2bf2a370a5a92397"))
 (vundo :source "elpaca-menu-lock-file" :recipe
        (:package "vundo" :repo ("https://github.com/casouri/vundo" . "vundo")
                  :files ("*" (:exclude ".git" "test")) :source
                  "elpaca-menu-lock-file" :protocol https :inherit t :depth
                  treeless :ref "30f85b4ae1f2a7189d44bb738b49559928d046cb"))
 (wgrep :source "elpaca-menu-lock-file" :recipe
        (:package "wgrep" :fetcher github :repo "mhayashi1120/Emacs-wgrep"
                  :files ("wgrep.el") :source "elpaca-menu-lock-file" :protocol
                  https :inherit t :depth treeless :ref
                  "49f09ab9b706d2312cab1199e1eeb1bcd3f27f6f"))
 (with-editor :source "elpaca-menu-lock-file" :recipe
              (:package "with-editor" :fetcher github :repo "magit/with-editor"
                        :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "elpaca-menu-lock-file" :protocol https :inherit
                        t :depth treeless :ref
                        "87a384a0e59260cca41ca8831d98e195b1ec8ada"))
 (ws-butler :source "elpaca-menu-lock-file" :recipe
            (:package "ws-butler" :fetcher git :url
                      "https://git.savannah.gnu.org/git/emacs/nongnu.git"
                      :branch "elpa/ws-butler" :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "67c49cfdf5a5a9f28792c500c8eb0017cfe74a3a"))
 (xterm-color :source "elpaca-menu-lock-file" :recipe
              (:package "xterm-color" :repo "atomontage/xterm-color" :fetcher
                        github :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "elpaca-menu-lock-file" :protocol https :inherit
                        t :depth treeless :ref
                        "2ad407c651e90fff2ea85d17bf074cee2c022912"))
 (yaml-mode :source "elpaca-menu-lock-file" :recipe
            (:package "yaml-mode" :repo "yoshiki/yaml-mode" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :protocol https :inherit t
                      :depth treeless :ref
                      "d91f878729312a6beed77e6637c60497c5786efa"))
 (yasnippet :source "elpaca-menu-lock-file" :recipe
            (:package "yasnippet" :repo "joaotavora/yasnippet" :fetcher github
                      :files ("yasnippet.el" "snippets") :source
                      "elpaca-menu-lock-file" :protocol https :inherit t :depth
                      treeless :ref "c1e6ff23e9af16b856c88dfaab9d3ad7b746ad37"))
 (yasnippet-snippets :source "elpaca-menu-lock-file" :recipe
                     (:package "yasnippet-snippets" :repo
                               "AndreaCrotti/yasnippet-snippets" :fetcher github
                               :files ("*.el" "snippets" ".nosearch") :source
                               "elpaca-menu-lock-file" :protocol https :inherit
                               t :depth treeless :ref
                               "4f9f9e7b29822d66a34b7d5f1c19ed65cce1d8e1"))
 (zop-to-char :source "elpaca-menu-lock-file" :recipe
              (:package "zop-to-char" :fetcher github :repo
                        "thierryvolpiatto/zop-to-char" :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "elpaca-menu-lock-file" :protocol https :inherit
                        t :depth treeless :ref
                        "00152aa666354b27e56e20565f186b363afa0dce")))
