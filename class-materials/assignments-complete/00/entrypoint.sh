# This is a bash script. You can put commands for bash to execute
# in here and they will be executed one after another.
#
# TODO:
# Use the provided resources and the internet to write a script that:
# 1. Starts a new tmux session running `make qemu-gdb` in the /umass-os directory
# 2. Splits the tmux window, running `gdb-multiarch` in the new pane
# 3. Attaches to the session
#
# Step 2 may be more difficult than it sounds. If `make qemu-gdb` takes too long to compile
# The gdb-multiach will fail to attach to the running qemu process. How could you 
# ensure that the kernel is compiled before starting qmeu-gdb?
# BEGIN DELETE BLOCK
session="umass-os"

tmux new-session -d -s $session -x - -y - "make && tmux split-window -hb -t $session:0 \"gdb-multiarch\" && make qemu-gdb"
tmux attach-session -t $session
# END DELETE BLOCK