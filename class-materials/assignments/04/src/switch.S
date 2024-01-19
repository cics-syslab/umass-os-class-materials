.global switch_to_process

# Context switch
#
#   void switch_to_process(struct proc_register_set *old, struct proc_register_set *new);
# 
# Save current registers in old. Load from new.	
switch_to_process:
    