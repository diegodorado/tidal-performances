#!/bin/bash
# set -euf -o pipefail

tmux rename-session tidal

tmux split-window -v -t tidal -l 85%

tmux select-pane -t 1

tmux split-window -t tidal -h

tmux send-keys -t 1 "ghci -ghci-script ./BootTidal.hs" C-m

tmux send-keys -t 2 "~/.vim/plugged/scvim/bin/start_pipe" C-m

tmux send-keys -t 3 "vim start.scd perfo.tidal" C-m

tmux select-pane -t 3
