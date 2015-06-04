git aliases

Put these to `[alias]` in `.gitconfig`.

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
