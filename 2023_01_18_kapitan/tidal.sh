#!/bin/bash
set -euf -o pipefail

tmux rename-session tidal

ghci -ghci-script ./BootTidal.hs
