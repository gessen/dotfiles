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
                       :source "elpaca-menu-lock-file" :id ace-window :type git
                       :protocol https :inherit t :depth treeless :ref
                       "77115afc1b0b9f633084cf7479c767988106c196"))
 (async :source "elpaca-menu-lock-file" :recipe
        (:package "async" :repo "jwiegley/emacs-async" :fetcher github :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "elpaca-menu-lock-file" :id async :type git :protocol
                  https :inherit t :depth treeless :ref
                  "4fdcb061a166e0d6ccc27d3829a28e04415ae825"))
 (avy :source "elpaca-menu-lock-file" :recipe
      (:package "avy" :repo "abo-abo/avy" :fetcher github :files
                ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                 "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                 "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                 (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                           "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                :source "elpaca-menu-lock-file" :id avy :type git :protocol
                https :inherit t :depth treeless :ref
                "933d1f36cca0f71e4acb5fac707e9ae26c536264"))
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
                     :source "elpaca-menu-lock-file" :id beginend :type git
                     :protocol https :inherit t :depth treeless :ref
                     "26d6142ceaf7c58705281852410b61ddc0d780ee"))
 (breadcrumb :source "elpaca-menu-lock-file" :recipe
             (:package "breadcrumb" :repo
                       ("https://github.com/joaotavora/breadcrumb"
                        . "breadcrumb")
                       :tar "1.0.1" :host gnu :files ("*" (:exclude ".git"))
                       :source "elpaca-menu-lock-file" :id breadcrumb :type git
                       :protocol https :inherit t :depth treeless :ref
                       "bcf7f1d1c102f8430c017d66aeee5d12e26585a4"))
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
                             :source "elpaca-menu-lock-file" :id
                             browse-at-remote :type git :protocol https :inherit
                             t :depth treeless :ref
                             "38e5ffd77493c17c821fd88f938dbf42705a5158"))
 (cape :source "elpaca-menu-lock-file" :recipe
       (:package "cape" :repo "minad/cape" :fetcher github :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source "elpaca-menu-lock-file" :id cape :type git :protocol
                 https :inherit t :depth treeless :ref
                 "f0135abaf95a22b9fb2c951751a5d0733ce61bbd"))
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
                      :source "elpaca-menu-lock-file" :id circadian :type git
                      :protocol https :inherit t :depth treeless :ref
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
                     :source "elpaca-menu-lock-file" :id clipetty :type git
                     :protocol https :inherit t :depth treeless :ref
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
                           :source "elpaca-menu-lock-file" :id comment-dwim-2
                           :type git :protocol https :inherit t :depth treeless
                           :ref "6ab75d0a690f0080e9b97c730aac817d04144cd0"))
 (compat :source "elpaca-menu-lock-file" :recipe
         (:package "compat" :repo
                   ("https://github.com/emacs-compat/compat" . "compat") :tar
                   "31.0.0.2" :host gnu :files ("*" (:exclude ".git")) :source
                   "elpaca-menu-lock-file" :id compat :type git :protocol https
                   :inherit t :depth treeless :ref
                   "3c70c4572c2e54aaebb3dcdd0b2ef6a84676118e"))
 (cond-let
   :source "elpaca-menu-lock-file" :recipe
   (:package "cond-let" :fetcher github :repo "tarsius/cond-let" :files
             ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
              "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
              (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                        "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
             :source "elpaca-menu-lock-file" :id cond-let :type git :protocol
             https :inherit t :depth treeless :ref
             "bbe1f1c7389b16ad0e6c3bc7b28ba8fb27afb6f5"))
 (consult :source "elpaca-menu-lock-file" :recipe
          (:package "consult" :repo "minad/consult" :fetcher github :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id consult :type git
                    :protocol https :inherit t :depth treeless :ref
                    "e98ac9a3b7b78397e6f14eadfc70aacc069edd7d"))
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
                        :source "elpaca-menu-lock-file" :id consult-dir :type
                        git :protocol https :inherit t :depth treeless :ref
                        "1497b46d6f48da2d884296a1297e5ace1e050eb5"))
 (consult-eglot :source "elpaca-menu-lock-file" :recipe
                (:package "consult-eglot" :fetcher github :repo
                          "mohkale/consult-eglot" :files
                          (:defaults "extensions/consult-eglot-embark/*")
                          :source "elpaca-menu-lock-file" :id consult-eglot
                          :type git :protocol https :inherit t :depth treeless
                          :ref "3e4d9a40911b897c0a2c5d20199d0f7c30bfc1c2"))
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
                           :source "elpaca-menu-lock-file" :id consult-ls-git
                           :type git :protocol https :inherit t :depth treeless
                           :ref "85882e4b7af9ad40160d985e42b36b0fd6400ead"))
 (consult-xref-stack :source "elpaca-menu-lock-file" :recipe
                     (:source "elpaca-menu-lock-file" :package
                              "consult-xref-stack" :id consult-xref-stack :host
                              github :repo "brett-lempereur/consult-xref-stack"
                              :type git :protocol https :inherit t :depth
                              treeless :ref
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
                              :source "elpaca-menu-lock-file" :id
                              consult-yasnippet :type git :protocol https
                              :inherit t :depth treeless :ref
                              "89e39887c87e25d18861216a4d72e5d174f13751"))
 (corfu :source "elpaca-menu-lock-file" :recipe
        (:package "corfu" :repo "minad/corfu" :files (:defaults "extensions/*")
                  :fetcher github :source "elpaca-menu-lock-file" :id corfu
                  :type git :protocol https :inherit t :depth treeless :ref
                  "75be36fe63e78c63ac71c32039ab07836bd532ac"))
 (dash :source "elpaca-menu-lock-file" :recipe
       (:package "dash" :fetcher github :repo "magnars/dash.el" :files
                 ("dash.el" "dash.texi") :source "elpaca-menu-lock-file" :id
                 dash :type git :protocol https :inherit t :depth treeless :ref
                 "d746dd9edcb67a108818beb0cdc78dc1cb466832"))
 (deflate :source "elpaca-menu-lock-file" :recipe
          (:package "deflate" :fetcher github :repo "skuro/deflate" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id deflate :type git
                    :protocol https :inherit t :depth treeless :ref
                    "d3863855d213f73dc7a1a54736d94a75f8f7e9c5"))
 (devdocs :source "elpaca-menu-lock-file" :recipe
          (:package "devdocs" :fetcher github :repo "astoff/devdocs.el" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id devdocs :type git
                    :protocol https :inherit t :depth treeless :ref
                    "25c746024ddf73570195bf42b841f761a2fee10c"))
 (diff-hl :source "elpaca-menu-lock-file" :recipe
          (:package "diff-hl" :fetcher github :repo "dgutov/diff-hl" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id diff-hl :type git
                    :protocol https :inherit t :depth treeless :ref
                    "6f1df2b83d1140a2938409b35de7f4c9c7b1defd"))
 (dired-copy-paste :source "elpaca-menu-lock-file" :recipe
                   (:source "elpaca-menu-lock-file" :package "dired-copy-paste"
                            :id dired-copy-paste :host github :repo
                            "jsilve24/dired-copy-paste" :type git :protocol
                            https :inherit t :depth treeless :ref
                            "278b73dd72de55d39edd7014b59654ee25b61707"))
 (diredfl :source "elpaca-menu-lock-file" :recipe
          (:package "diredfl" :fetcher github :repo "purcell/diredfl" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id diredfl :type git
                    :protocol https :inherit t :depth treeless :ref
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
                       :source "elpaca-menu-lock-file" :id drag-stuff :type git
                       :protocol https :inherit t :depth treeless :ref
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
                      :source "elpaca-menu-lock-file" :id dumb-jump :type git
                      :protocol https :inherit t :depth treeless :ref
                      "cf06b4ccdce6a39346c32f05139f9ee8b77ee229"))
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
                      :source "elpaca-menu-lock-file" :id easy-kill :type git
                      :protocol https :inherit t :depth treeless :ref
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
                             :source "elpaca-menu-lock-file" :id
                             easy-kill-extras :type git :protocol https :inherit
                             t :depth treeless :ref
                             "3fea06322d76be78e66074b9a9dad9a6d4aa6bcd"))
 (eglot-hover :source "elpaca-menu-lock-file" :recipe
              (:source "elpaca-menu-lock-file" :package "eglot-hover" :id
                       eglot-hover :host codeberg :repo "slotThe/eglot-hover"
                       :type git :protocol https :inherit t :depth treeless :ref
                       "b9a3a0e160bf5b3ab13d6675f60816c5798dafa8"))
 (eglot-x :source "elpaca-menu-lock-file" :recipe
          (:source "elpaca-menu-lock-file" :package "eglot-x" :id eglot-x :host
                   github :repo "nemethf/eglot-x" :type git :protocol https
                   :inherit t :depth treeless :ref
                   "46bca93291727454dd92567e761a1e2ab5622590"))
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
                       :source "elpaca-menu-lock-file" :id elisp-lint :type git
                       :protocol https :inherit t :depth treeless :ref
                       "c5765abf75fd1ad22505b349ae1e6be5303426c2"))
 (elisp-refs :source "elpaca-menu-lock-file" :recipe
             (:package "elisp-refs" :repo "Wilfred/elisp-refs" :fetcher github
                       :files (:defaults (:exclude "elisp-refs-bench.el"))
                       :source "elpaca-menu-lock-file" :id elisp-refs :type git
                       :protocol https :inherit t :depth treeless :ref
                       "541a064c3ce27867872cf708354a65d83baf2a6d"))
 (elpaca :source
   "elpaca-menu-lock-file" :recipe
   (:source nil :package "elpaca" :id elpaca :repo
            "https://github.com/progfolio/elpaca.git" :ref
            "5b0cbb19421ef20c140b46a7b1fb7d04240b53f6" :inherit ignore :files
            (:defaults "elpaca-test.el" (:exclude "extensions")) :build
            (:not elpaca-activate) :type git :protocol https :depth treeless))
 (elpaca-use-package :source "elpaca-menu-lock-file" :recipe
                     (:package "elpaca-use-package" :wait t :repo
                               "https://github.com/progfolio/elpaca.git" :files
                               ("extensions/elpaca-use-package.el") :main
                               "extensions/elpaca-use-package.el" :build
                               (:not elpaca-source elpaca-build-docs) :source
                               "elpaca-menu-lock-file" :id elpaca-use-package
                               :type git :protocol https :inherit t :depth
                               treeless :ref
                               "5b0cbb19421ef20c140b46a7b1fb7d04240b53f6"))
 (embark :source "elpaca-menu-lock-file" :recipe
         (:package "embark" :repo "oantolin/embark" :fetcher github :files
                   ("embark.el" "embark-org.el" "embark.texi") :source
                   "elpaca-menu-lock-file" :id embark :type git :protocol https
                   :inherit t :depth treeless :ref
                   "87e53827cf6659dcc4ac4e54be9af34aeca44f6e"))
 (embark-consult :source "elpaca-menu-lock-file" :recipe
                 (:package "embark-consult" :repo "oantolin/embark" :fetcher
                           github :files ("embark-consult.el") :source
                           "elpaca-menu-lock-file" :id embark-consult :type git
                           :protocol https :inherit t :depth treeless :ref
                           "87e53827cf6659dcc4ac4e54be9af34aeca44f6e"))
 (expreg :source "elpaca-menu-lock-file" :recipe
         (:package "expreg" :repo
                   ("https://github.com/casouri/expreg.git" . "expreg") :tar
                   "1.4.1" :host gnu :files ("*" (:exclude ".git")) :source
                   "elpaca-menu-lock-file" :id expreg :type git :protocol https
                   :inherit t :depth treeless :ref
                   "d3ac3703e3e0aa66dc1ac6f8110b1862206beb20"))
 (f :source "elpaca-menu-lock-file" :recipe
    (:package "f" :fetcher github :repo "rejeep/f.el" :files
              ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
               "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
               (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                         "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
              :source "elpaca-menu-lock-file" :id f :type git :protocol https
              :inherit t :depth treeless :ref
              "931b6d0667fe03e7bf1c6c282d6d8d7006143c52"))
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
                      :source "elpaca-menu-lock-file" :id fish-mode :type git
                      :protocol https :inherit t :depth treeless :ref
                      "2526b1803b58cf145bc70ff6ce2adb3f6c246f89"))
 (flymake-collection :source "elpaca-menu-lock-file" :recipe
                     (:package "flymake-collection" :fetcher github :repo
                               "mohkale/flymake-collection" :files
                               (:defaults "src/*.el" "src/checkers/*.el")
                               :old-names (flymake-rest) :source
                               "elpaca-menu-lock-file" :id flymake-collection
                               :type git :protocol https :inherit t :depth
                               treeless :ref
                               "1c771edc125ae44d9574489f3989397027b17654"))
 (git-modes :source "elpaca-menu-lock-file" :recipe
            (:package "git-modes" :fetcher github :repo "magit/git-modes" :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :id git-modes :type git
                      :protocol https :inherit t :depth treeless :ref
                      "f291a4cc4a8b02a25d5cf93b4ab6af29e6f060d9"))
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
                                       :source "elpaca-menu-lock-file" :id
                                       golden-ratio-scroll-screen :type git
                                       :protocol https :inherit t :depth
                                       treeless :ref
                                       "60eb00ed7e51c0875a38cff25c9a87fe79296484"))
 (helpful :source "elpaca-menu-lock-file" :recipe
          (:package "helpful" :repo "Wilfred/helpful" :fetcher github :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id helpful :type git
                    :protocol https :inherit t :depth treeless :ref
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
                              :source "elpaca-menu-lock-file" :id
                              highlight-numbers :type git :protocol https
                              :inherit t :depth treeless :ref
                              "8b4744c7f46c72b1d3d599d4fb75ef8183dee307"))
 (hl-todo :source "elpaca-menu-lock-file" :recipe
          (:package "hl-todo" :fetcher github :repo "tarsius/hl-todo" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id hl-todo :type git
                    :protocol https :inherit t :depth treeless :ref
                    "527d545b8c2f36243194cbe4a8d0e6ac9d50e6a7"))
 (ht :source "elpaca-menu-lock-file" :recipe
     (:package "ht" :fetcher github :repo "Wilfred/ht.el" :files
               ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
                "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                          "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
               :source "elpaca-menu-lock-file" :id ht :type git :protocol https
               :inherit t :depth treeless :ref
               "1c49aad1c820c86f7ee35bf9fff8429502f60fef"))
 (htmlize :source "elpaca-menu-lock-file" :recipe
          (:package "htmlize" :fetcher github :repo "emacsorphanage/htmlize"
                    :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id htmlize :type git
                    :protocol https :inherit t :depth treeless :ref
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
                          :source "elpaca-menu-lock-file" :id hungry-delete
                          :type git :protocol https :inherit t :depth treeless
                          :ref "d919e555e5c13a2edf4570f3ceec84f0ade71657"))
 (hydra :source "elpaca-menu-lock-file" :recipe
        (:package "hydra" :repo "abo-abo/hydra" :fetcher github :files
                  (:defaults (:exclude "lv.el")) :source "elpaca-menu-lock-file"
                  :id hydra :wait t :type git :protocol https :inherit t :depth
                  treeless :ref "59a2a45a35027948476d1d7751b0f0215b1e61aa"))
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
                            :source "elpaca-menu-lock-file" :id ibuffer-project
                            :type git :protocol https :inherit t :depth treeless
                            :ref "9002abd9cb4c8753fe4f6c522d9407b4d52e7873"))
 (iedit :source "elpaca-menu-lock-file" :recipe
        (:package "iedit" :repo "victorhge/iedit" :fetcher github :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "elpaca-menu-lock-file" :id iedit :type git :protocol
                  https :inherit t :depth treeless :ref
                  "14161daa295332a49dda92b97c00d62efd38acfe"))
 (jinx :source "elpaca-menu-lock-file" :recipe
       (:package "jinx" :repo "minad/jinx" :files
                 (:defaults "jinx-mod.c" "emacs-module.h") :fetcher github
                 :source "elpaca-menu-lock-file" :id jinx :type git :protocol
                 https :inherit t :depth treeless :ref
                 "23f6d028decb6081ee30659e7e841f6046e5f511"))
 (keycast :source "elpaca-menu-lock-file" :recipe
          (:package "keycast" :fetcher github :repo "tarsius/keycast" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id keycast :type git
                    :protocol https :inherit t :depth treeless :ref
                    "a6518e1b48b08ba883e9b1a2db0872d5bf3d85f4"))
 (kkp :source "elpaca-menu-lock-file" :recipe
      (:package "kkp" :fetcher github :repo "benotn/kkp" :files
                ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                 "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                 "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                 (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                           "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                :source "elpaca-menu-lock-file" :id kkp :type git :protocol
                https :inherit t :depth treeless :ref
                "82b7443e10a2ba287467b62e90b6adb6dd93dc99"))
 (llama :source "elpaca-menu-lock-file" :recipe
        (:package "llama" :fetcher github :repo "tarsius/llama" :files
                  ("llama.el" ".dir-locals.el") :source "elpaca-menu-lock-file"
                  :id llama :type git :protocol https :inherit t :depth treeless
                  :ref "4d4024048053b898a01521046e0f063ee47615b0"))
 (lv :source "elpaca-menu-lock-file" :recipe
     (:package "lv" :repo "abo-abo/hydra" :fetcher github :files ("lv.el")
               :source "elpaca-menu-lock-file" :id lv :type git :protocol https
               :inherit t :depth treeless :ref
               "59a2a45a35027948476d1d7751b0f0215b1e61aa"))
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
                      :source "elpaca-menu-lock-file" :id macrostep :type git
                      :protocol https :inherit t :depth treeless :ref
                      "d0928626b4711dcf9f8f90439d23701118724199"))
 (magit :source "elpaca-menu-lock-file" :recipe
        (:package "magit" :fetcher github :repo "magit/magit" :files
                  ("lisp/magit*.el" "lisp/git-*.el" "docs/magit.texi"
                   "docs/AUTHORS.md" "LICENSE" ".dir-locals.el"
                   ("githooks" "githooks/*") ("git-hooks" "git-hooks/*")
                   (:exclude "lisp/magit-section.el"))
                  :source "elpaca-menu-lock-file" :id magit :type git :protocol
                  https :inherit t :depth treeless :ref
                  "137f137dccb37097ae9caa31018cafa071ff4ec1"))
 (magit-blame-color-by-age :source "elpaca-menu-lock-file" :recipe
                           (:source "elpaca-menu-lock-file" :package
                                    "magit-blame-color-by-age" :id
                                    magit-blame-color-by-age :host github :repo
                                    "jdtsmith/magit-blame-color-by-age" :type
                                    git :protocol https :inherit t :depth
                                    treeless :ref
                                    "784d78647e2ee511923d8e8d67d1d19f24ff5a0a"))
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
                        :source "elpaca-menu-lock-file" :id magit-delta :type
                        git :protocol https :inherit t :depth treeless :ref
                        "5fc7dbddcfacfe46d3fd876172ad02a9ab6ac616"))
 (magit-section :source "elpaca-menu-lock-file" :recipe
                (:package "magit-section" :fetcher github :repo "magit/magit"
                          :files
                          ("lisp/magit-section.el" "docs/magit-section.texi"
                           "magit-section-pkg.el")
                          :source "elpaca-menu-lock-file" :id magit-section
                          :type git :protocol https :inherit t :depth treeless
                          :ref "137f137dccb37097ae9caa31018cafa071ff4ec1"))
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
                        :source "elpaca-menu-lock-file" :id magit-todos :type
                        git :protocol https :inherit t :depth treeless :ref
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
                       :source "elpaca-menu-lock-file" :id marginalia :type git
                       :protocol https :inherit t :depth treeless :ref
                       "7ec0b70afb43a756ecd45a958c6ebe797717fc91"))
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
                          :source "elpaca-menu-lock-file" :id markdown-mode
                          :type git :protocol https :inherit t :depth treeless
                          :ref "6995b8d095eceace0b947c1217646781ab021c10"))
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
                         :source "elpaca-menu-lock-file" :id markdown-toc :type
                         git :protocol https :inherit t :depth treeless :ref
                         "ab4ba86e627ef83b7eec6706d66b81241c96f48c"))
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
                       :source "elpaca-menu-lock-file" :id meson-mode :type git
                       :protocol https :inherit t :depth treeless :ref
                       "0449c649daaa9322e1c439c1540d8c290501d455"))
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
                             :source "elpaca-menu-lock-file" :id
                             multiple-cursors :type git :protocol https :inherit
                             t :depth treeless :ref
                             "94b8b07a4bab87f803123723b68227565429dfa1"))
 (mwim :source "elpaca-menu-lock-file" :recipe
       (:package "mwim" :repo "alezost/mwim.el" :fetcher github :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source "elpaca-menu-lock-file" :id mwim :type git :protocol
                 https :inherit t :depth treeless :ref
                 "b41885b3e14653d17eabb2db0bd336ac972d5315"))
 (nerd-icons :source "elpaca-menu-lock-file" :recipe
             (:package "nerd-icons" :repo "rainstormstudio/nerd-icons.el"
                       :fetcher github :files (:defaults "data") :source
                       "elpaca-menu-lock-file" :id nerd-icons :type git
                       :protocol https :inherit t :depth treeless :ref
                       "17faac7977242b470732efd417d3bcc8eb5a830e"))
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
                                  :source "elpaca-menu-lock-file" :id
                                  nerd-icons-completion :type git :protocol
                                  https :inherit t :depth treeless :ref
                                  "45b585d972192a3eaeb239e15e55de7f46f8920a"))
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
                             :source "elpaca-menu-lock-file" :id
                             nerd-icons-corfu :type git :protocol https :inherit
                             t :depth treeless :ref
                             "e1197d6c1db673f4ec7ee20cb2c4297f479420e7"))
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
                             :source "elpaca-menu-lock-file" :id
                             nerd-icons-dired :type git :protocol https :inherit
                             t :depth treeless :ref
                             "104acd8879528b8115589f35f1bbcbe231ad732f"))
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
                            :source "elpaca-menu-lock-file" :id nerd-icons-grep
                            :type git :protocol https :inherit t :depth treeless
                            :ref "7179ff3384efce53f7de2f3c1a98070a310a10da"))
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
                               :source "elpaca-menu-lock-file" :id
                               nerd-icons-ibuffer :type git :protocol https
                               :inherit t :depth treeless :ref
                               "22dcbeea8c7677c83c8464c34247cf968250ee18"))
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
                      :source "elpaca-menu-lock-file" :id orderless :type git
                      :protocol https :inherit t :depth treeless :ref
                      "f4a8114ed729d34d35cec6c7eb34b5d0b23aaa6f"))
 (org-contrib :source "elpaca-menu-lock-file" :recipe
              (:package "org-contrib" :host github :repo
                        "emacsmirror/org-contrib" :files (:defaults) :source
                        "elpaca-menu-lock-file" :id org-contrib :type git
                        :protocol https :inherit t :depth treeless :ref
                        "82f94c5612c20286d234613f0ce0d92eac2c0845"))
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
                       :source "elpaca-menu-lock-file" :id org-modern :type git
                       :protocol https :inherit t :depth treeless :ref
                       "d106d02cf045cc968c09989e9c48e0f2b44c574c"))
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
                              :source "elpaca-menu-lock-file" :id
                              org-sticky-header :type git :protocol https
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
                      :source "elpaca-menu-lock-file" :id ox-pandoc :type git
                      :protocol https :inherit t :depth treeless :ref
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
                      :source "elpaca-menu-lock-file" :id ox-reveal :type git
                      :protocol https :inherit t :depth treeless :ref
                      "f55c851bf6aeb1bb2a7f6cf0f2b7bd0e79c4a5a0"))
 (package-lint :source "elpaca-menu-lock-file" :recipe
               (:package "package-lint" :fetcher github :repo
                         "purcell/package-lint" :files
                         (:defaults "data" (:exclude "*flymake.el")) :source
                         "elpaca-menu-lock-file" :id package-lint :type git
                         :protocol https :inherit t :depth treeless :ref
                         "87bf02ca387a37094e1a0057adefa9735d880cec"))
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
                        :source "elpaca-menu-lock-file" :id parent-mode :type
                        git :protocol https :inherit t :depth treeless :ref
                        "fbd49857ab2e4cd0c5611c0cc83f93711657b298"))
 (pcre2el :source "elpaca-menu-lock-file" :recipe
          (:package "pcre2el" :fetcher github :repo "joddie/pcre2el" :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id pcre2el :type git
                    :protocol https :inherit t :depth treeless :ref
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
                          :source "elpaca-menu-lock-file" :id pkgbuild-mode
                          :type git :protocol https :inherit t :depth treeless
                          :ref "aadf3d1d19c5eb9b52c15c5b73b1a46faac5b7d5"))
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
                          :source "elpaca-menu-lock-file" :id plantuml-mode
                          :type git :protocol https :inherit t :depth treeless
                          :ref "a4a63efa4a3980bfbd825bfb3a263c6664401e79"))
 (pulsar :source "elpaca-menu-lock-file" :recipe
         (:package "pulsar" :repo
                   ("https://github.com/protesilaos/pulsar" . "pulsar") :tar
                   "1.4.1" :host gnu :files
                   ("*" (:exclude ".git" "COPYING" "doclicense.texi")) :source
                   "elpaca-menu-lock-file" :id pulsar :type git :protocol https
                   :inherit t :depth treeless :ref
                   "1849c0720c3fe5eb92f800b20351b58bce8804b6"))
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
                        :source "elpaca-menu-lock-file" :id reformatter :type
                        git :protocol https :inherit t :depth treeless :ref
                        "2bd8818f3f2119a3876e574a437495214c87bc81"))
 (s :source "elpaca-menu-lock-file" :recipe
    (:package "s" :fetcher github :repo "magnars/s.el" :files
              ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
               "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
               (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                         "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
              :source "elpaca-menu-lock-file" :id s :type git :protocol https
              :inherit t :depth treeless :ref
              "d7c04b84d03481a1ed62ee13dbe595224ccbe57c"))
 (shfmt :source "elpaca-menu-lock-file" :recipe
        (:package "shfmt" :fetcher github :repo "purcell/emacs-shfmt" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "elpaca-menu-lock-file" :id shfmt :type git :protocol
                  https :inherit t :depth treeless :ref
                  "284823c7db1aebbb1bc1fdaf06e92aaba7ebceb0"))
 (ssh-config-mode :source "elpaca-menu-lock-file" :recipe
                  (:package "ssh-config-mode" :fetcher github :repo
                            "peterhoeg/ssh-config-mode-el" :files
                            (:defaults "*.txt") :source "elpaca-menu-lock-file"
                            :id ssh-config-mode :type git :protocol https
                            :inherit t :depth treeless :ref
                            "da45cc5496dad6160d318c9a815cb5d7f620ed99"))
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
                              :source "elpaca-menu-lock-file" :id
                              string-inflection :type git :protocol https
                              :inherit t :depth treeless :ref
                              "4a2f87d7b47f5efe702a78f8a40a98df36eeba13"))
 (substitute :source "elpaca-menu-lock-file" :recipe
             (:package "substitute" :repo
                       ("https://github.com/protesilaos/substitute"
                        . "substitute")
                       :tar "0.6.1" :host gnu :files
                       ("*" (:exclude ".git" "COPYING" "doclicense.texi"))
                       :source "elpaca-menu-lock-file" :id substitute :type git
                       :protocol https :inherit t :depth treeless :ref
                       "e4bf1ac7f8ae5d8cf27f05ab35412e2da4d04e3d"))
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
                     :source "elpaca-menu-lock-file" :id surround :type git
                     :protocol https :inherit t :depth treeless :ref
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
                           :source "elpaca-menu-lock-file" :id symbol-overlay
                           :type git :protocol https :inherit t :depth treeless
                           :ref "85d100b0cca35b70cee1b260e09af8e1fb2fcc08"))
 (tabgo :source "elpaca-menu-lock-file" :recipe
        (:package "tabgo" :fetcher github :repo "isamert/tabgo.el" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "elpaca-menu-lock-file" :id tabgo :type git :protocol
                  https :inherit t :depth treeless :ref
                  "7cf1142c3e194ded79632846830775b42830ce51"))
 (toc-org :source "elpaca-menu-lock-file" :recipe
          (:package "toc-org" :fetcher github :repo "snosov1/toc-org" :old-names
                    (org-toc) :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id toc-org :type git
                    :protocol https :inherit t :depth treeless :ref
                    "69165018974a82b397d0869f0c7f0bf7d3b4ee07"))
 (transient :source "elpaca-menu-lock-file" :recipe
            (:package "transient" :fetcher github :repo "magit/transient" :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "elpaca-menu-lock-file" :id transient :type git
                      :protocol https :inherit t :depth treeless :ref
                      "618f000e51e39b1d57ad82e133c231b461d62777"))
 (undo-fu :source "elpaca-menu-lock-file" :recipe
          (:package "undo-fu" :fetcher codeberg :repo "ideasman42/emacs-undo-fu"
                    :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "elpaca-menu-lock-file" :id undo-fu :type git
                    :protocol https :inherit t :depth treeless :ref
                    "5684ef2aef5f60176472916b21869cf221e018cc"))
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
                            :source "elpaca-menu-lock-file" :id undo-fu-session
                            :type git :protocol https :inherit t :depth treeless
                            :ref "92d733a5b162a70c572fac17b9f9e872426df547"))
 (vertico :source "elpaca-menu-lock-file" :recipe
          (:package "vertico" :repo "minad/vertico" :files
                    (:defaults "extensions/*") :fetcher github :source
                    "elpaca-menu-lock-file" :id vertico :type git :protocol
                    https :inherit t :depth treeless :ref
                    "a6874e3d8c74a9eea77967d702d608ebbd6b27ec"))
 (vlf :source "elpaca-menu-lock-file" :recipe
      (:package "vlf" :repo ("https://github.com/emacsmirror/gnu_elpa" . "vlf")
                :tar "1.7.2" :host gnu :branch "externals/vlf" :files
                ("*" (:exclude ".git")) :source "elpaca-menu-lock-file" :id vlf
                :type git :protocol https :inherit t :depth treeless :ref
                "6192573ee088079bf1f81abc2bf2a370a5a92397"))
 (vundo :source "elpaca-menu-lock-file" :recipe
        (:package "vundo" :repo ("https://github.com/casouri/vundo" . "vundo")
                  :tar "2.4.0" :host gnu :files ("*" (:exclude ".git" "test"))
                  :source "elpaca-menu-lock-file" :id vundo :type git :protocol
                  https :inherit t :depth treeless :ref
                  "e0af8c5845abf884a644215a9cac37f39c13cd5a"))
 (wgrep :source "elpaca-menu-lock-file" :recipe
        (:package "wgrep" :fetcher github :repo "mhayashi1120/Emacs-wgrep"
                  :files ("wgrep.el") :source "elpaca-menu-lock-file" :id wgrep
                  :type git :protocol https :inherit t :depth treeless :ref
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
                        :source "elpaca-menu-lock-file" :id with-editor :type
                        git :protocol https :inherit t :depth treeless :ref
                        "d6d859f7839a2ced6700857976270be56cd225b0"))
 (ws-butler :source "elpaca-menu-lock-file" :recipe
            (:package "ws-butler" :repo
                      ("https://github.com/emacsmirror/nongnu_elpa"
                       . "ws-butler")
                      :tar "1.3" :host nongnu :branch "elpa/ws-butler" :files
                      ("*"
                       (:exclude ".git" "COPYING" "tests" "Makefile"
                                 ".travis.yml"))
                      :source "NonGNU ELPA" :id ws-butler :inherit
                      elpaca-menu-nongnu-elpa :type git :protocol https :depth
                      treeless :ref "67c49cfdf5a5a9f28792c500c8eb0017cfe74a3a"))
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
                        :source "elpaca-menu-lock-file" :id xterm-color :type
                        git :protocol https :inherit t :depth treeless :ref
                        "ffdad85e584dfc0857f2a1fb970f5ef0f5d31ba3"))
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
                      :source "elpaca-menu-lock-file" :id yaml-mode :type git
                      :protocol https :inherit t :depth treeless :ref
                      "5d7347519c94eac1c9383a3b9bebe218d3e43318"))
 (yasnippet :source "elpaca-menu-lock-file" :recipe
            (:package "yasnippet" :fetcher github :repo "joaotavora/yasnippet"
                      :files (:defaults ("doc" "doc/*.org")) :source
                      "elpaca-menu-lock-file" :id yasnippet :type git :protocol
                      https :inherit t :depth treeless :ref
                      "c1e6ff23e9af16b856c88dfaab9d3ad7b746ad37"))
 (yasnippet-snippets :source "elpaca-menu-lock-file" :recipe
                     (:package "yasnippet-snippets" :repo
                               "AndreaCrotti/yasnippet-snippets" :fetcher github
                               :files ("*.el" "snippets" ".nosearch") :source
                               "elpaca-menu-lock-file" :id yasnippet-snippets
                               :type git :protocol https :inherit t :depth
                               treeless :ref
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
                        :source "elpaca-menu-lock-file" :id zop-to-char :type
                        git :protocol https :inherit t :depth treeless :ref
                        "09885546aa2ee8b78953f54fd14f23f834cf2dfd")))
