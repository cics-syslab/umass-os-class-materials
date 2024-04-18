session="umass-os"

tmux new-session -d -s $session -x - -y - "make && tmux split-window -hb -t $session:0 \"gdb-multiarch\" && make qemu-gdb"
tmux attach-session -t $session