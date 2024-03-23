# This is a bash script. You can put commands for bash to execute
# in here and they will be executed one after another.
#
# TODO:
# Use the provided resources and the internet to write a script that:
# 1. Starts a new tmux session running `make qemu-gdb` in the /umass-os directory
# 2. Splits the tmux window, running `gdb-multiarch` in the new pane
# 3. Attaches to the session
# BEGIN DELETE BLOCK
session="umass-os"

tmux new-session -d -s $session -x - -y - "make qemu-gdb"
tmux split-window -hb -t $session:0 "gdb-multiarch"
tmux attach-session -t $session
# END DELETE BLOCK