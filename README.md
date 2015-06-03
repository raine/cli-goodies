<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# cli-goodies

- [aliases](#aliases)
- [`cd` to current Finder directory](#cd-to-current-finder-directory)
- [easy git commit with message](#easy-git-commit-with-message)
- [use `diff` to compare files changed by a command](#use-diff-to-compare-files-changed-by-a-command)
- [easy gist clone](#easy-gist-clone)
- [easy git ignore](#easy-git-ignore)
- [beautify and syntax highlight a JavaScript file](#beautify-and-syntax-highlight-a-javascript-file)
- [add npm bin to $PATH](#add-npm-bin-to-path)
- [tmux+vim: reflow vim windows after tmux pane zoom in/out](#tmuxvim-reflow-vim-windows-after-tmux-pane-zoom-inout)
- [trim empty area around an image](#trim-empty-area-around-an-image)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Some of these are from the depths of the Internet so credit belongs to the
original authors.

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

