<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# cli-goodies

- [aliases](#aliases)
- [`cd` to current Finder directory](#cd-to-current-finder-directory)
- [easy git commit with message](#easy-git-commit-with-message)
- [use `diff` to compare files changed by a command](#use-diff-to-compare-files-changed-by-a-command)
- [easy gist clone](#easy-gist-clone)
- [git aliases](#git-aliases)
  - [temporary commit](#temporary-commit)
  - [last message](#last-message)
  - [fix commit in history](#fix-commit-in-history)
  - [remove merged branches](#remove-merged-branches)
  - [`git add` or `add -p `by pattern](#git-add-or-add--p-by-pattern)
  - [squash last commit to the one before](#squash-last-commit-to-the-one-before)
- [easy git ignore](#easy-git-ignore)
- [beautify and syntax highlight a JavaScript file](#beautify-and-syntax-highlight-a-javascript-file)
- [add npm bin to $PATH](#add-npm-bin-to-path)
- [tmux+vim: reflow vim windows after tmux pane zoom in/out](#tmuxvim-reflow-vim-windows-after-tmux-pane-zoom-inout)
- [trim empty area around an image](#trim-empty-area-around-an-image)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Some of these are from the depths of the Internet so credit belongs to the
original authors.
foo

## aliases

```sh
alias lcc='fc -ln -1 | awk "{\$1=\$1}1" ORS="" | pbcopy' # copy last command
alias now='date -u +"%Y-%m-%dT%H:%M:%SZ"' # print current datetime as ISO
alias ni="npm install"
alias nisd="npm install --save-dev"
alias nis="npm install --save"
alias nig="npm install -g"
alias irc="mosh raine@host -- screen -rd irc"
```

## `cd` to current Finder directory

```sh
cdf() {
  target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
  if [ "$target" != "" ]; then
    cd "$target"; pwd
  else
    echo 'No Finder window found' >&2
  fi
}
```

## easy git commit with message

```sh
c() {
  git commit -m "$*"
}
```

```sh
c this is a commit message
```

## use `diff` to compare files changed by a command

No temporary files

```sh
old=$(cat l10n/*.json); localize; diff <(echo -E "$old") <(cat l10n/*.json)
```

## easy gist clone

Clone a gist URL

```sh
gist-clone() {
  gist_id=`echo "$1" | sed -e 's/.*\///g'`
  git clone git@gist.github.com:/$gist_id.git $2
}
```

```sh
gist-clone https://gist.github.com/raine/ef467c47029f1d26c30b dir-name
```

## git aliases

Put these to `[alias]` section in `.gitconfig`.

### temporary commit

Sometimes more desirable than stashing w/ untracked when leaving a branch
with uncommitted work.

```
todo = !"git add . && git commit -m 'TODO'"
```

### last message

Print last commit message (the short version).

```
last-msg = !sh -c \"git log -1 \\$1 --format=\\\"%s\\\"\" -
```

### fix commit in history

This beast is like `git commit --amend` on steroids. It's used for amending
commits that are not the tip of the current branch.

```
fix = "!_() { c=$(git rev-parse $1) && git commit --fixup $c && if grep -qv \"No local changes\" <<<$(git stash); then s=1; fi; git -c core.editor=cat rebase -i --autosquash $c~; if [[ -n "$s" ]]; then git stash pop; fi; }; _"
```

If your history looks like:

```
ed63d7f (HEAD, origin/master, master) readme: use heredocs
81ee47c mocha: increase timeout
a9b38ab add test/data/config*
```

You can amend `a9b38ab` with:

```
git add --patch # oops, forgot something from that commit
git fix a9b38ad
```

### remove merged branches

Remove branches that have been merged to the current branch.

```
remove-merged-branches = !git branch --merged | grep -v \"\\*\" | xargs -n 1 git branch -d
```

### `git add` or `add -p `by pattern

Normally, `git add --patch` will go through all unstaged changes.

With `git grep-add-patch`, you can filter files to be added by providing a
pattern to match filename against.

```
grep-add = "!sh -c 'git ls-files -m -o --exclude-standard | grep $1 | xargs git add' -"
grep-add-patch = "!sh -c 'git add -p `git ls-files -m -o --exclude-standard | grep $1`' -"
```

```
git grep-add-patch README # only add README.md hunk by hunk
```

Here's a helper that fallbacks to `git add -p`  if no pattern is provided. I
have this aliased to `gap`.

```sh
# enable single alias for both git add -p and grep + git add -p
function git-add-patch; {
  if (( $# == 0 )); then
    git add -p
  else
    git grep-add-patch $1
  fi;
}
```

### squash last commit to the one before

```
squash-last = "!GIT_SEQUENCE_EDITOR=\"sed -i -re '/$(git rev-parse --short HEAD)/s/^pick /s /'\" git rebase -i --autosquash HEAD~2"
```

## easy git ignore

```sh
git-ignore() {
  echo $1 >>! .gitignore
}
```

## beautify and syntax highlight a JavaScript file

```sh
npm install -g js-beautify
pip install Pygments
```

```sh
jscat() {
  < $1 | js-beautify -s 2 -f - | pygmentize -g | less -F
}
```

```sh
jscat foo.min.js
```

## add npm bin to $PATH

```sh
npm-bin-path() {
  echo "adding `npm bin` to path"
  export PATH=$(npm bin):$PATH
  echo $PATH
}
```

```sh
$ npm-bin-path
adding .../node_modules/.bin to path
```

## tmux+vim: reflow vim windows after tmux pane zoom in/out

This makes vim window splits adjust to the new window size when tmux zoom out
/ zoom in (Prefix+z) is used.

Put to `$PATH` as `tmux-zoom-out-vim`:

```sh
#!/usr/bin/env bash
set -e

cmd="$(tmux display -p '#{pane_current_command}')"
cmd="$(basename "${cmd,,*}")"

tmux resize-pane -Z

if [ "${cmd%m}" = "vi" ]; then
  sleep 0.1
  tmux send-keys C-w =
fi
```

Configure in `tmux.conf`:

```
bind-key z run-shell 'tmux-zoom-out-vim'
```

## trim empty area around an image

```sh
trim-empty() {
  convert "$1" -fuzz "1%" -trim +repage "$1"
}
```

```sh
trim-empty img.png
```

[Use ImageMagick to trim empty around an image](https://coderwall.com/p/1shzpw/use-imagemagick-to-trim-empty-around-an-image)

