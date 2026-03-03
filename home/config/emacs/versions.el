((ace-window :source "elpaca-menu-lock-file" :recipe
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
                  "31cb2fea8f4bc7a593acd76187a89075d8075500"))
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
                       treeless :ref "1d9dd90f77a594cd50b368e6efc85d44539ec209"))
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
                             "38e5ffd77493c17c821fd88f938dbf42705a5158"))
 (cape :source "elpaca-menu-lock-file" :recipe
       (:package "cape" :repo "minad/cape" :fetcher github :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source "elpaca-menu-lock-file" :protocol https :inherit t
                 :depth treeless :ref "2b2a5c5bef16eddcce507d9b5804e5a0cc9481ae"))
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
                      "181bb35ba9416bdede255c9fa6b86a2d60115f94"))
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
 (cond-let
   :source "elpaca-menu-lock-file" :recipe
   (:package "cond-let" :fetcher github :repo "tarsius/cond-let" :files
             ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
              "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
              (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                        "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
             :source "elpaca-menu-lock-file" :protocol https :inherit t :depth
             treeless :ref "8bf87d45e169ebc091103b2aae325aece3aa804d"))
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
                    "d1d39d52151a10f7ca29aa291886e99534cc94db"))
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
                        "1497b46d6f48da2d884296a1297e5ace1e050eb5"))
 (consult-eglot :source "elpaca-menu-lock-file" :recipe
                (:package "consult-eglot" :fetcher github :repo
                          "mohkale/consult-eglot" :files
                          (:defaults "extensions/consult-eglot-embark/*")
                          :source "elpaca-menu-lock-file" :protocol https
                          :inherit t :depth treeless :ref
                          "d8b444aac39edfc6473ffbd228df3e9119451b51"))
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
                              "1dcbf2e15a2279365940de8e7c2d29d2586dfa2c"))
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
                  "abfe0003d71b61ffdcf23fc6e546643486daeb69"))
 (dash :source "elpaca-menu-lock-file" :recipe
       (:package "dash" :fetcher github :repo "magnars/dash.el" :files
                 ("dash.el" "dash.texi") :source "elpaca-menu-lock-file"
                 :protocol https :inherit t :depth treeless :ref
                 "fb443e7a6e660ba849cafcd01021d9aac3ac6764"))
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
                    "25c746024ddf73570195bf42b841f761a2fee10c"))
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
                    "3eefe68941933c8549049502007411ed2bf70387"))
 (dired-copy-paste :source "elpaca-menu-lock-file" :recipe
                   (:source "elpaca-menu-lock-file" :protocol https :inherit t
                            :depth treeless :host github :repo
                            "jsilve24/dired-copy-paste" :package
                            "dired-copy-paste" :ref
                            "aefb5597e65bc1a7b771c2c82961f5a10b5f424b"))
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
                      "e19593b720b9db5cf8d61d28d466da30b449b84b"))
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
                      "98cbae5d8c378ad14d612d7c88a78484c49a80b8"))
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
                             "3fea06322d76be78e66074b9a9dad9a6d4aa6bcd"))
 (eglot-booster :source "elpaca-menu-lock-file" :recipe
                (:source "elpaca-menu-lock-file" :protocol https :inherit t
                         :depth treeless :host github :repo
                         "jdtsmith/eglot-booster" :package "eglot-booster" :ref
                         "cab7803c4f0adc7fff9da6680f90110674bb7a22"))
 (eglot-hover :source "elpaca-menu-lock-file" :recipe
              (:source "elpaca-menu-lock-file" :protocol https :inherit t :depth
                       treeless :host codeberg :repo "slotThe/eglot-hover"
                       :package "eglot-hover" :ref
                       "b9a3a0e160bf5b3ab13d6675f60816c5798dafa8"))
 (eglot-x :source "elpaca-menu-lock-file" :recipe
          (:source "elpaca-menu-lock-file" :protocol https :inherit t :depth
                   treeless :host github :repo "nemethf/eglot-x" :package
                   "eglot-x" :ref "46bca93291727454dd92567e761a1e2ab5622590"))
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
            "1508298c1ed19c81fa4ebc5d22d945322e9e4c52" :files
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
                               "1508298c1ed19c81fa4ebc5d22d945322e9e4c52"))
 (embark :source "elpaca-menu-lock-file" :recipe
         (:package "embark" :repo "oantolin/embark" :fetcher github :files
                   ("embark.el" "embark-org.el" "embark.texi") :source
                   "elpaca-menu-lock-file" :protocol https :inherit t :depth
                   treeless :ref "d546952ccddedd8cca6bb4cfdbbfa2a596c3e114"))
 (embark-consult :source "elpaca-menu-lock-file" :recipe
                 (:package "embark-consult" :repo "oantolin/embark" :fetcher
                           github :files ("embark-consult.el") :source
                           "elpaca-menu-lock-file" :protocol https :inherit t
                           :depth treeless :ref
                           "d546952ccddedd8cca6bb4cfdbbfa2a596c3e114"))
 (expreg :source "elpaca-menu-lock-file" :recipe
         (:package "expreg" :repo
                   ("https://github.com/casouri/expreg.git" . "expreg") :files
                   ("*" (:exclude ".git")) :source "elpaca-menu-lock-file"
                   :protocol https :inherit t :depth treeless :ref
                   "53fd5a4812b77e49d3ab45fc16bb2998abaf1d86"))
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
                              "502d36e0fb4c4daedc16ea5d732dcbc8285d6fb1"))
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
                             "e2beb322d4ef1baaaf191dbc6f50e19fa5781abf"))
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
                      "c3faeeea1982786f78d8c38397dec0f078eaec84"))
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
                    "9540fc414014822dde00f0188b74e17ac99e916d"))
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
                    "fa644880699adea3770504f913e6dddbec90c076"))
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
                  "14161daa295332a49dda92b97c00d62efd38acfe"))
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
                 :depth treeless :ref "75e8e4805fe6f4ab256bd59bec71464edbc23887"))
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
                    "b831e380c4deb1d51ce5db0a965b96427aec52e4"))
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
                  "2a89ba755b0459914a44b1ffa793e57f759a5b85"))
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
                   ("git-hooks" "git-hooks/*")
                   (:exclude "lisp/magit-section.el"))
                  :source "elpaca-menu-lock-file" :protocol https :inherit t
                  :depth treeless :ref
                  "f3ff4c9fbba9422597aabdd74d618fa90787462b"))
 (magit-blame-color-by-age :source "elpaca-menu-lock-file" :recipe
                           (:source "elpaca-menu-lock-file" :protocol https
                                    :inherit t :depth treeless :host github
                                    :repo "jdtsmith/magit-blame-color-by-age"
                                    :package "magit-blame-color-by-age" :ref
                                    "fac05141e1d1d357a4a19aa25bf0a72b250c525d"))
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
                          "f3ff4c9fbba9422597aabdd74d618fa90787462b"))
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
                        "7294a95580bddf7232f2d205efae312dc24c5f61"))
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
                       "0d08fbea0f1182627891240780081ba528c1348b"))
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
                          "9de2df5a9f2f864c82ec112d3369154767a2bb49"))
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
                         "d22633b654193bcab322ec51b6dd3bb98dd5f69f"))
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
                         "9dd3b9074b3123d9dfd80aff4e1083bdb93dad45"))
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
                             "ddd677091afc7d65ce56d11866e18aeded110ada"))
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
                       treeless :ref "9a7f44db9a53567f04603bc88d05402cad49c64c"))
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
                                  "d09ea987ed3d2cc64137234f27851594050e2b64"))
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
                             "929b62f01b93d30a3f42cc507fc45c84a2457b3f"))
 (nerd-icons-grep :source "elpaca-menu-lock-file" :recipe
                  (:package "nerd-icons-grep" :fetcher github :repo
                            "hron/nerd-icons-grep" :files
                            ("*.el" "*.el.in" "dir" "*.info" "*.texi"
                             "*.texinfo" "doc/dir" "doc/*.info" "doc/*.texi"
                             "doc/*.texinfo" "lisp/*.el" "docs/dir"
                             "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                             (:exclude ".dir-locals.el" "test.el" "tests.el"
                                       "*-test.el" "*-tests.el" "LICENSE"
                                       "README*" "*-pkg.el"))
                            :source "elpaca-menu-lock-file" :protocol https
                            :inherit t :depth treeless :ref
                            "7179ff3384efce53f7de2f3c1a98070a310a10da"))
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
                               "0cf63e4fa666cc9f3717e182f72342dca9f31f67"))
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
                      "3a2a32181f7a5bd7b633e40d89de771a5dd88cc7"))
 (org-contrib :source "elpaca-menu-lock-file" :recipe
              (:package "org-contrib" :host github :repo
                        "emacsmirror/org-contrib" :files (:defaults) :source
                        "elpaca-menu-lock-file" :protocol https :inherit t
                        :depth treeless :ref
                        "90e1d6bd6288615233dae273f0525a43a9d8779d"))
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
                       "b4b5b1c864f1fdf240d1bbd7093529f5a75e8a06"))
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
                      "1caeb56a4be26597319e7288edbc2cabada151b4"))
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
                         "1c37329703a507fa357302cf6fc29d4f2fe631a8"))
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
                  "45a0b759076ce4139aba36dde0a2904136282e73"))
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
                     "4fc893c3c9ea3f6b5099ac1b369abb3c6da40b1e"))
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
                   treeless :ref "7f32ceeaf59de5c035b90c7afffa249c5ff3185a"))
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
                        "c0ddac04b7b937ed56d6bf97e4bfcc4eccfa501a"))
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
                  "2a222c53cea5bbecf85332077521e6de8185f101"))
 (ssh-config-mode :source "elpaca-menu-lock-file" :recipe
                  (:package "ssh-config-mode" :fetcher github :repo
                            "peterhoeg/ssh-config-mode-el" :files
                            (:defaults "*.txt") :source "elpaca-menu-lock-file"
                            :protocol https :inherit t :depth treeless :ref
                            "f21726d6f44a0e769a15f0a94620078a326774f7"))
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
                              "4a2f87d7b47f5efe702a78f8a40a98df36eeba13"))
 (substitute :source "elpaca-menu-lock-file" :recipe
             (:package "substitute" :repo
                       ("https://github.com/protesilaos/substitute"
                        . "substitute")
                       :files
                       ("*" (:exclude ".git" "COPYING" "doclicense.texi"))
                       :source "elpaca-menu-lock-file" :protocol https :inherit
                       t :depth treeless :ref
                       "cb15c1b4c974f9a04c60af7c58590dcd85578d69"))
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
                      "bda7c2e0772deaee8e36a217d15c14784e8c6800"))
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
                         "31466e4ccfd4f896ce3145c95c4c1f8b59d4bfdf"))
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
                    "b4ce5ed20c1cf0591e497e6998a7634a172726fa"))
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
                            "92d733a5b162a70c572fac17b9f9e872426df547"))
 (vertico :source "elpaca-menu-lock-file" :recipe
          (:package "vertico" :repo "minad/vertico" :files
                    (:defaults "extensions/*") :fetcher github :source
                    "elpaca-menu-lock-file" :protocol https :inherit t :depth
                    treeless :ref "93f15873d7d6244d72202c5dd7724a030a2d5b9a"))
 (vlf :source "elpaca-menu-lock-file" :recipe
      (:package "vlf" :repo ("https://github.com/emacsmirror/gnu_elpa" . "vlf")
                :branch "externals/vlf" :files ("*" (:exclude ".git")) :source
                "elpaca-menu-lock-file" :protocol https :inherit t :depth
                treeless :ref "6192573ee088079bf1f81abc2bf2a370a5a92397"))
 (vundo :source "elpaca-menu-lock-file" :recipe
        (:package "vundo" :repo ("https://github.com/casouri/vundo" . "vundo")
                  :files ("*" (:exclude ".git" "test")) :source
                  "elpaca-menu-lock-file" :protocol https :inherit t :depth
                  treeless :ref "e0af8c5845abf884a644215a9cac37f39c13cd5a"))
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
                        "902b4d572af2c2f36060da01e3c33d194cdec32b"))
 (ws-butler :source "elpaca-menu-lock-file" :recipe
            (:package "ws-butler" :fetcher git :url
                      "https://https.git.savannah.gnu.org/git/elpa/nongnu.git"
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
                        "86fab1d247eb5ebe6b40fa5073a70dfa487cd465"))
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
                               "606ee926df6839243098de6d71332a697518cb86"))
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
                        "09885546aa2ee8b78953f54fd14f23f834cf2dfd")))
