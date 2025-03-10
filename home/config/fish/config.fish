if status is-login
    # Set XDG dir vars locally
    set -l xdg_config_home $HOME/.config
    set -l xdg_cache_home $HOME/.cache
    set -l xdg_data_home $HOME/.local/share
    set -l xdg_state_home $HOME/.local/state

    # Input Method framework.
    set -gx XMODIFIERS im=fcit

    # Partial XDG support that needs some help
    set -gx ANSIBLE_HOME $xdg_config_home/ansible
    set -gx ASPELL_CONF home-dir "$xdg_config_home/aspell/; per-conf aspell.conf"
    set -gx BUNDLE_USER_CONFIG "$xdg_config_home/bundle"
    set -gx BUNDLE_USER_CACHE "$xdg_cache_home/bundle"
    set -gx BUNDLE_USER_PLUGIN "$xdg_data_home/bundle"
    set -gx CARGO_HOME $xdg_data_home/cargo
    set -gx DOCKER_CONFIG "$xdg_config_home/docker"
    set -gx GEM_HOME "$xdg_data_home/gem"
    set -gx GEM_SPEC_CACHE "$xdg_cache_home/gem"
    set -gx GNUPGHOME $xdg_data_home/gnupg
    set -gx GTK2_RC_FILES $xdg_config_home/gtk-2.0/settings.ini
    set -gx RIPGREP_CONFIG_PATH $xdg_config_home/ripgrep/config
    set -gx RUSTUP_HOME $xdg_data_home/rustup
    set -gx _ZO_DATA_DIR $xdg_data_home/zoxide

    # Needed by cargo to build Stormcloud.
    set -gx AKAMILL_INSTALL_PATH /opt/akamill
    set -gx BUILD_OS alsi22
    set -gx OPENSSL_DIR /opt/akamill
    set -gx OPENSSL_INSTALL_PATH "$OPENSSL_DIR"
    set -gx LD_LIBRARY_PATH "$OPENSSL_INSTALL_PATH/lib:$LD_LIBRARY_PATH"
    set -gx V8_INCLUDE_PATH /usr/local/include
    set -gx V8_LIBRARY_PATH /usr/local/lib

    if ! status is-interactive
        return
    end
end

# Help Emacs
if test "$TERM" = dumb
    set -gx CARGO_TERM_COLOR always
    return
end

# Disable greeting
set fish_greeting

# Create cache directory
set -l __fish_cache_dir $HOME/.cache/fish
test -d $__fish_cache_dir; or mkdir -p $__fish_cache_dir

# Automatic SSH agent
if ! pgrep -u "$USER" ssh-agent >/dev/null
    ssh-agent -c -a "$XDG_RUNTIME_DIR/ssh_agent" \
        | sed "s|^echo|#echo|" >"/tmp/ssh-agent.fish"
end

if test -z "$SSH_AGENT_PID"
    source "/tmp/ssh-agent.fish"
end

ssh-add -l | grep -q (ssh-keygen -lf $HOME/.ssh/id_rsa | awk '{print $2}')
or ssh-add

## Command line

function copy-prev-shell-word -d "Copy previous word"
    set --local cmd (commandline --tokens-expanded)
    commandline --insert $cmd[-1]
end

# Use [M-a] and [M-e] for the same effect as [C-a] and [C-e] respectively
bind alt-a beginning-of-line
bind alt-e end-of-line

# Edit the current command line in $EDITOR with [C-x C-e]
bind ctrl-x,ctrl-e edit_command_buffer

bind alt-m copy-prev-shell-word

# Starts pager search mode by default when completing
bind tab complete-and-search
bind shift-tab complete

# Prefix search with [M-S-up] and [M-S-down]
bind alt-shift-up history-prefix-search-backward
bind alt-shift-down history-prefix-search-forward

# Expand current token with [C-M-e]
bind ctrl-alt-e 'commandline -rt -- (commandline -xt | string escape | string join " ")'

## Files and directories

function bak -d "Backup files"
    for f in $argv
        if not test -e "$f"
            echo "No such file or directory: $f"
            continue
        end
        set -f f (string replace --regex "/+\$" "" $f)
        if test -d "$f"
            rsync --archive --compress "$f/" "$f".bk
        else
            rsync --archive --compress "$f" "$f".bk
        end
    end
end

function mkcd --wraps mkdir -d "mkdir + cd"
    mkdir -p $argv[1..-1]
    and cd $argv[-1]
end

# Human readable output by default
abbr -a df df --human-readable
abbr -a free free --human

## Paging

# Automatically exit the second time it reaches end-of-file
set -g LESS --quit-at-eof

# Automatically exit if the entire file can be displayed on the first screen
set -g LESS --quit-if-one-screen $LESS

# Ignore case in searches; that is, uppercase and lowercase are considered
# identical. This option is ignored if any uppercase letters appear in the
# search pattern
set -g LESS --ignore-case $LESS

# Prompt verbosely with the percent into the file
set -g LESS --LONG-PROMPT $LESS

# Display "raw" control characters. The default is to display control characters
# using the caret notation
set -g LESS --RAW-CONTROL-CHARS $LESS

# Disable sending the termcap initialization and deinitialization strings to the
# terminal. This is sometimes desirable if the deinitialization string does
# something unnecessary, like clearing the screen
set -g LESS --no-init $LESS

# Temporarily highlight the first "new" line after a forward movement of a full
# page. The first "new" line is the line immediately following the line
# previously at the bottom of the screen. Also highlights the target line after
# a g or p command. The highlight is removed at the next command which causes
# movement
set -g LESS --hilite-unread $LESS

# Change the default scrolling window size to WINDOW_SIZE-4 lines
set -g LESS --window=-4 $LESS

# Specify the default number of positions to scroll horizontally in the
# RIGHTARROW and LEFTARROW commands
set -g LESS --shift=5 $LESS

# Squeeze consecutive blank lines into a single blank line
set -g LESS --squeeze-blank-lines $LESS

# Enable mouse input
set -g LESS --mouse --wheel-lines=3 $LESS

set -gx LESS $LESS

## Editors

function fe -d "Open selected files with EDITOR or xdg-open with fd+fzf"
    set -l out (fd --type file --color=always $argv[1] | \
        fzf --ansi --layout=reverse --tac --select-1 --exit-0 --multi \
        --expect=ctrl-o,ctrl-e)
    set -l key $out[1]
    set -l files $out[2..-1]
    if test -z "$files"
        return
    end
    if test $key = ctrl-o
        for file in $files
            xdg-open $file
        end
    else
        $EDITOR $files
    end
end

function eg -d "Open files with EDITOR with rg+fzf"
    if test (count $argv) = 0
        return
    end
    if test (string match --entire emacs "$EDITOR")
        set -f files (rg --no-heading --column --line-number --color=always \
              $argv \
            | fzf --ansi --select-1 --exit-0 --multi \
            | awk -F: '{printf "+%s:%s %s\n", $2, $3, $1}')
    else
        set -f files (rg --no-heading --column --line-number --color=always \
              $argv \
            | fzf --ansi --select-1 --exit-0 --multi \
            | awk -F: '{printf "%s:%s:%s\n", $1, $2, $3}')
    end
    if test -z "$files"
        return
    end
    $EDITOR (string split " " $files)
end

function egp -d "Open files with EDITOR with fg+fzf with preview"
    if test (count $argv) = 0
        return
    end
    set -f files (rg --max-count=1 --files-with-matches --no-messages $argv \
        | fzf --select-1 --exit-0 --multi \
          --preview="rg --pretty --context=10 $argv {}")
    if test -z "$files"
        return
    end
    $EDITOR $files
end

# Set both EDITOR and VISUAL to emacsclient with autostarted server
set -gx EDITOR hx
set -gx VISUAL $EDITOR

# emacsclient starts emacs in daemon mode if it can't connect to it
set -gx ALTERNATE_EDITOR

abbr -a ec emacsclient --tty
abbr -a ecg emacsclient --create-frame --no-wait
abbr -a mg emacsclient --tty --eval '"(magit-status)"'
abbr -a mgg emacsclient --create-frame --no-wait --eval '"(magit-status)"'

abbr -a e emacs

abbr -a se EDITOR='(which $EDITOR)' sudoedit

## History

abbr -a hm history merge
abbr -a hcs history clear-session

## Git

function git-master-branch -d "Print Git master branch"
    git rev-parse --git-dir &>/dev/null; or return
    for ref in refs/heads/{master,main,trunk}
        if git show-ref --verify --quiet $ref
            echo $ref | string replace refs/heads/ ""
            return
        end
    end
end

function git-develop-branch -d "Print Git develop branch"
    git rev-parse --git-dir &>/dev/null; or return
    for ref in refs/heads/{dev,devel,develop}
        if git show-ref --verify --quiet $ref
            echo $ref | string replace refs/heads/ ""
            return
        end
    end
end

function git-wip -d "Commit all changes in Git tree"
    git add --all || return 128
    git rm (git ls-files --deleted) 2>/dev/null
    git commit --no-verify --no-gpg-sign --message --wip--
end

function git-unwip -d "Reset last commit if it was WIP"
    git rev-list --max-count=1 --format="%s" HEAD | grep --quiet "\--wip--"
    and git reset HEAD~1
end

function git-unwip-all -d "Reset all WIP commits"
    set -f commit (git log --grep="--wip--" --invert-grep --max-count=1 \
        --format=format:%H)
    if test $commit != (git rev-parse HEAD)
        git reset $commit
    end
end

abbr -a ga git add
abbr -a gaa git add --all
abbr -a gap git add --patch
abbr -a gau git add --update

abbr -a gbs git bisect
abbr -a gbsb git bisect bad
abbr -a gbsg git bisect good
abbr -a gbsr git bisect reset
abbr -a gbss git bisect start

abbr -a gbl git blame -w

abbr -a gb git branch
abbr -a gba git branch --all
abbr -a gbd git branch --delete
abbr -a gbD git branch --delete --force
abbr -a gbg git branch -vv '|' grep '": gone\]"'
abbr -a gbm git branch --move
abbr -a gbnm git branch --no-merged
abbr -a gbr git branch --remote

abbr -a gco git checkout
abbr -a gcd git checkout '(git-develop-branch)'
abbr -a gcm git checkout '(git-master-branch)'

abbr -a gcp git cherry-pick
abbr -a gcpa git cherry-pick --abort
abbr -a gcpc git cherry-pick --continue

abbr -a gclean git clean --interactive -d
abbr -a gcl git clone --recurse-submodules

abbr -a gc git commit
abbr -a gcs git commit --gpg-sign
abbr -a gcss git commit --gpg-sign --signoff
abbr -a gc! git commit --amend
abbr -a gcn! git commit --no-edit --amend
abbr -a gcs! git commit --gpg-sign --amend
abbr -a gcss! git commit --gpg-sign --signoff --amend

abbr -a gcf git config --list
abbr -a gdct git describe --tags '(git rev-list --tags --max-count=1)'

abbr -a gd git diff
abbr -a gd2 git -c delta.side-by-side=true diff
abbr -a gdn git -c delta.navigate=true diff
abbr -a gdn2 git -c delta.navigate=true -c delta.side-by-side=true diff
abbr -a gds git diff --staged
abbr -a gds2 git -c delta.side-by-side=true diff --staged
abbr -a gdsn git -c delta.navigate=true diff --staged
abbr -a gdsn2 git -c delta.navigate=true -c delta.side-by-side=true diff --staged
abbr -a gdt git -c diff.external=difft diff
abbr -a gdst git -c diff.external=difft diff --staged
abbr -a gdw git diff --word-diff
abbr -a gdsw git diff --staged --word-diff
abbr -a gdu git diff @{upstream}
abbr -a gduc git diff @ @{upstream}
abbr -a gdtool git difftool
abbr -a gdtoolg git difftool --gui

abbr -a gf git fetch

abbr -a gcount git shortlog --summary --numbered
abbr -a glg git log --stat
abbr -a glgp git log --stat --patch
abbr -a glod git log --graph --pretty='"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
abbr -a glol git log --graph --pretty='"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
abbr -a glola git log --graph --pretty='"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"' --all
abbr -a glols git log --graph --pretty='"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"' --stat
abbr -a glo git log --oneline
abbr -a glog git log --oneline --graph --all

abbr -a gignored git ls-files --others

abbr -a gm git merge
abbr -a gmff git merge --ff-only
abbr -a gma git merge --abort
abbr -a gmc git merge --continue
abbr -a gms git merge --squash
abbr -a gmtool git mergetool
abbr -a gmtoolg git mergetool --gui

abbr -a gl git pull

abbr -a gp git push
abbr -a gpf git push --force-with-lease --force-if-includes

abbr -a grb git rebase
abbr -a grba git rebase --abort
abbr -a grbc git rebase --continue
abbr -a grbi git rebase --interactive
abbr -a grbo git rebase --onto
abbr -a grbs git rebase --skip
abbr -a grbd git rebase '(git-develop-branch)'
abbr -a grbm git rebase '(git-master-branch)'
abbr -a grbod git rebase origin/'(git-develop-branch)'
abbr -a grbom git rebase origin/'(git-master-branch)'
abbr -a grbud git rebase upstream/'(git-develop-branch)'
abbr -a grbum git rebase upstream/'(git-master-branch)'

abbr -a gr git remote
abbr -a grv git remote --verbose

abbr -a gpristine git reset --hard '&&' git clean --force -dfx
abbr -a grh git reset
abbr -a grhh git reset --hard
abbr -a grhu git reset --hard @{upstream}
abbr -a grhk git reset --keep
abbr -a grhs git reset --soft

abbr -a grs git restore
abbr -a grss git restore --source
abbr -a grst git restore --staged

abbr -a grev git revert
abbr -a grm git rm
abbr -a grmc git rm --cached

abbr -a gsh git show

abbr -a gsta git stash push
abbr -a gstaa git stash apply
abbr -a gstall git stash --all
abbr -a gstc git stash clear
abbr -a gstd git stash drop
abbr -a gstl git stash list
abbr -a gstp git stash pop
abbr -a gsts git stash show --patch
abbr -a gstu git stash push --include-untracked

abbr -a gst git status
abbr -a gsl git status --long

abbr -a gsi git submodule init
abbr -a gsu git submodule update

abbr -a gsd git switch '(git-develop-branch)'
abbr -a gsm git switch '(git-master-branch)'
abbr -a gsw git switch
abbr -a gswc git switch --create
abbr -a gswd git switch --detach

abbr -a gta git tag --annotate
abbr -a gts git tag --sign
abbr -a gtv git tag '|' sort -V

abbr -a gignore git update-index --skip-worktree
abbr -a gunignore git update-index --no-skip-worktree

abbr -a gwt git worktree
abbr -a gwta git worktree add
abbr -a gwtls git worktree list
abbr -a gwtmv git worktree move
abbr -a gwtrm git worktree remove

abbr -a gwip git-wip
abbr -a gunwip git-unwip
abbr -a gunwipall git-unwip-all

## Jujutsu

abbr -a jb jj bookmark
abbr -a jbc jj bookmark create
abbr -a jbd jj bookmark delete
abbr -a jbf jj bookmark forget
abbr -a jbl jj bookmark list
abbr -a jblt jj bookmark list --tracked
abbr -a jbm jj bookmark move
abbr -a jbmf jj bookmark move --allow-backwards
abbr -a jbr jj bookmark rename
abbr -a jbs jj bookmark set
abbr -a jbsf jj bookmark set --allow-backwards
abbr -a jbt jj bookmark track

abbr -a jc jj commit
abbr -a jci jj commit --interactive
abbr -a jde jj describe

abbr -a jd jj diff

abbr -a je jj edit

abbr -a jf jj git fetch

abbr -a jl jj log
abbr -a jlo jj log -r ::@
abbr -a jlog jj log -r "'all()'"

abbr -a jn jj new

abbr -a jp jj git push
abbr -a jpa jj git push --all
abbr -a jpb jj git push --bookmark
abbr -a jpt jj git push --tracked

abbr -a jrb jj rebase

abbr -a jrs jj restore

abbr -a jsh jj show

abbr -a jsp jj split
abbr -a jspf jj split --ignore-immutable

abbr -a jsq jj squash
abbr -a jsqf jj squash --ignore-immutable
abbr -a jsqi jj squash --interactive

abbr -a jst jj status

## Bat

# Use bat as MANPAGER
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT -c

# Use bat instead of cat by default
abbr -a cat bat

# Use bat to colorize help messages
abbr -a help --set-cursor % --help 2>&1 '|' bat --plain --language help
abbr -a --position anywhere -- -h "-h 2>&1 | bat --plain --language help"
abbr -a --position anywhere -- --help "--help 2>&1 | bat --plain --language help"

## CMake

# By default, use nproc number of threads
set -gx CMAKE_BUILD_PARALLEL_LEVEL (nproc 2>/dev/null || sysctl -n hw.ncpu)

# Generates compile_commands.json by default
set -gx CMAKE_EXPORT_COMPILE_COMMANDS ON

# Use Ninja by default
set -gx CMAKE_GENERATOR Ninja

# Use sccache by default
set -gx CMAKE_C_COMPILER_LAUNCHER sccache
set -gx CMAKE_CXX_COMPILER_LAUNCHER sccache

# Output should be logged for failed tests
set -gx CTEST_OUTPUT_ON_FAILURE ON

# Report CTest progress by repeatedly updating the same line
set -gx CTEST_PROGRESS_OUTPUT ON

## Dua

abbr -a du dua

## Fzf

# Set fd as the default source for fzf
set -gx FZF_DEFAULT_COMMAND "fd \
--hidden \
--follow \
--exclude .git \
"

# Default fzf options
set -gx FZF_DEFAULT_OPTS " \
--height=60% \
--bind=alt-p:preview-up,alt-n:preview-down \
--bind=ctrl-alt-p:preview-half-page-up,ctrl-alt-n:preview-half-page-down \
--bind=alt-up:preview-half-page-up,alt-down:preview-half-page-down \
--bind=ctrl-v:half-page-down,alt-v:half-page-up \
--bind=alt-a:select-all,ctrl-alt-a:deselect-all,alt-t:toggle-all \
"

# Paste selected files and directories onto the command line with [C-t]
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND . \$dir

# Change directory with preview with [M-c]
set -gx FZF_ALT_C_COMMAND "fd \
--follow \
--type directory \
"
set -gx FZF_ALT_C_OPTS "--preview='tree -C {} | head -200'"

if type -q fzf
    set -l fzf_init $__fish_cache_dir/fzf-init.fish
    if test (type -p fzf) -nt $fzf_init; or ! test -s $fzf_init
        fzf --fish >$fzf_init
    end
    source $fzf_init
    bind --erase ctrl-r
end

## Atuin

if type -q atuin
    set -l atuin_init $__fish_cache_dir/atuin-init.fish
    if test (type -p atuin) -nt $atuin_init; or ! test -s $atuin_init
        atuin init fish --disable-up-arrow >$atuin_init
    end
    source $atuin_init
end

## Lsd

abbr -a ls lsd
abbr -a ll lsd --long
abbr -a la lsd --long --almost-all
abbr -a l lsd --long --almost-all --git

## Kitty

# Nicer scp/rsync
abbr -a transfer kitty +kitten transfer

## Ninja

# Include the current load to the ninja status
set -gx NINJA_STATUS "[%s/%f/%t] (j%r/%es/%Es/%P) "

## Ripgrep

# Grep with syntax highlighting
abbr -a rgd --set-cursor rg --json --context=3 % '|' delta

## Rsync

set -l rsync_cp rsync --archive --compress -hhh --progress
abbr -a cpv $rsync_cp
abbr -a rsync-cp $rsync_cp
abbr -a rsync-mv $rsync_cp --remove-source-files
abbr -a rsync-update $rsync_cp --update
abbr -a rsync-sync $rsync_cp --update --delete

## Serie

bind alt-g 'serie -g single -o topo'

## SSH

# Copy current terminfo file to the given host
abbr -a ssh-copy-terminfo --set-cursor \
    infocmp -a '|' ssh % tic -x -o '~/.terminfo' /dev/stdin

## Yazi

function y --wraps yazi -d "Start Yazi but change CWD after exit"
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
        cd -- "$cwd"
    end
    command rm -f -- "$tmp"
    commandline --function repaint
end

bind ctrl-o y

## Zoxide

if type -q zoxide
    set -l zoxide_init $__fish_cache_dir/zoxide-init.fish
    if test (type -p zoxide) -nt $zoxide_init; or ! test -s $zoxide_init
        zoxide init fish --cmd cd --hook prompt >$zoxide_init
    end
    source $zoxide_init
end

## Cargo

# Add locally installed cargo
fish_add_path -P "$CARGO_HOME/bin"

## Mise

if type -q mise
    set -l mise_init $__fish_cache_dir/mise-init.fish
    if test (type -p mise) -nt $mise_init; or ! test -s $mise_init
        mise activate --shims >$mise_init
    end
    source $mise_init
end

## Stormcloud

# Needed by perforce
set -gx P4CONFIG .perforce
set -gx P4EDITOR $EDITOR

# Needed by e2e tests
set -gx EW_ENSURE_AUDIT_PASSING false
set -gx EW_ENSURE_NOT_SUSPENDED false
set -gx EW_FALLBACK_TO_SSH_BUNDLES false
set -gx EW_LOG_LEVEL 0

# Needed by dewploy
set -gx CROSS_CONFIG "$HOME/.nix-profile/opt/stormcloud-docker/alsi22/Cross.toml"
set -gx GHOST_IP 198.18.132.22
set -gx STORMCLOUD_BUILD_TYPE debug

function update-v8
    set -f git_url ssh://git@git.source.akamai.com:7999/sources/stormcloud_v8.git
    set -f v8_dir /tmp/v8-update
    if not set -q argv[1]
        set -f branch master
    else
        set -f branch $argv[1]
    end
    rm -rf "$v8_dir"
    and mkdir -p "$v8_dir"
    and git archive --remote=$git_url --format=tar.gz "$branch" v8/include v8-obj-alsi11.tgz \
        | tar zxf - --directory "$v8_dir"
    and tar xf "$v8_dir/v8-obj-alsi11.tgz" --directory "$v8_dir" --strip-components=1
    and cp -rv "$v8_dir/v8/include" /usr/local/
    and cp -v "$v8_dir/libv8_monolith.a" /usr/local/lib/
    and rm -rf "$v8_dir"
end

abbr -a cb cargo build --package
abbr -a cc cargo check --package
abbr -a ct cargo nextest run --lib --package
abbr -a xb cross build --target-dir target-deploy --package
abbr -a xc cross check --target-dir target-deploy --package
abbr -a xt cross test --target-dir target-deploy --lib --package

# sql2 with configured networks
abbr -a esql2 sql2 -q essl.lighthouse.query.akadns.net
abbr -a fsql2 sql2 -q freeflow.lighthouse.query.akadns.net

## Plugins

set hydro_color_pwd $fish_color_cwd
set hydro_color_git brblue
set fish_prompt_pwd_dir_length 2
