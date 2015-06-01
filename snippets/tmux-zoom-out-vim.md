tmux+vim: reflow vim windows after tmux pane zoom in/out

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
