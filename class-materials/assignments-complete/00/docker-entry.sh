# BEGIN DELETE BLOCK
session="umass-os"

tmux new-session -d -s $session -x - -y - "make qemu-gdb"
tmux split-window -hb -t $session:0 "gdb-multiarch"
tmux attach-session -t $session
# END DELETE BLOCK