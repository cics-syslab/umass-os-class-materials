| Format                | Name                               | Pseudocode                                      |
| --------------------- | ---------------------------------- | ----------------------------------------------- |
| `lui rd,imm`          | Load Upper Immediate               | rd = imm                                        |
| `auipc rd,offset`     | Add Upper Immediate to PC          | rd = pc + offset                                |
| `jal rd,offset`       | Jump and Link                      | rd = pc + length(inst) pc = pc + offset         |
| `jalr rd,rs1,offset`  | Jump and Link Register             | rd = pc + length(inst) pc = (rs1 + offset) & -2 |
| `beq rs1,rs2,offset`  | Branch Equal                       | if rs1 == rs2 then pc = pc + offset             |
| `bne rs1,rs2,offset`  | Branch Not Equal                   | if rs1 != rs2 then pc = pc + offset             |
| `blt rs1,rs2,offset`  | Branch Less Than                   | if rs1 < rs2 then pc = pc + offset              |
| `bge rs1,rs2,offset`  | Branch Greater than Equal          | if rs1 >= rs2 then pc = pc + offset             |
| `bltu rs1,rs2,offset` | Branch Less Than Unsigned          | if rs1 < rs2 then pc = pc + offset              |
| `bgeu rs1,rs2,offset` | Branch Greater than Equal Unsigned | if rs1 >= rs2 then pc = pc + offset             |
| `lb rd,offset(rs1)`   | Load Byte                          | rd = s8[rs1 + offset]                           |
| `lh rd,offset(rs1)`   | Load Half                          | rd = s16[rs1 + offset]                          |
| `lw rd,offset(rs1)`   | Load Word                          | rd = s32[rs1 + offset]                          |
| `lbu rd,offset(rs1)`  | Load Byte Unsigned                 | rd = u8[rs1 + offset]                           |
| `lhu rd,offset(rs1)`  | Load Half Unsigned                 | rd = u16[rs1 + offset]                          |
| `sb rs2,offset(rs1)`  | Store Byte                         | u8[rs1 + offset] = rs2                          |
| `sh rs2,offset(rs1)`  | Store Half                         | u16[rs1 + offset] = rs2                         |
| `sw rs2,offset(rs1)`  | Store Word                         | u32[rs1 + offset] = rs2                         |
| `addi rd,rs1,imm`     | Add Immediate                      | rd = rs1 + sx(imm)                              |
| `slti rd,rs1,imm`     | Set Less Than Immediate            | rd = sx(rs1) < sx(imm)                          |
| `sltiu rd,rs1,imm`    | Set Less Than Immediate Unsigned   | rd = ux(rs1) < ux(imm)                          |
| `xori rd,rs1,imm`     | Xor Immediate                      | rd = ux(rs1) ^ ux(imm)                          |
| `ori rd,rs1,imm`      | Or Immediate                       | rd = ux(rs1) ∨ ux(imm)                          |
| `andi rd,rs1,imm`     | And Immediate                      | rd = ux(rs1) ∧ ux(imm)                          |
| `slli rd,rs1,imm`     | Shift Left Logical Immediate       | rd = ux(rs1) << ux(imm)                         |
| `srli rd,rs1,imm`     | Shift Right Logical Immediate      | rd = ux(rs1) >> ux(imm)                         |
| `srai rd,rs1,imm`     | Shift Right Arithmetic Immediate   | rd = sx(rs1) >> ux(imm)                         |
| `add rd,rs1,rs2`      | Add                                | rd = sx(rs1) + sx(rs2)                          |
| `sub rd,rs1,rs2`      | Subtract                           | rd = sx(rs1) - sx(rs2)                          |
| `sll rd,rs1,rs2`      | Shift Left Logical                 | rd = ux(rs1) << rs2                             |
| `slt rd,rs1,rs2`      | Set Less Than                      | rd = sx(rs1) < sx(rs2)                          |
| `sltu rd,rs1,rs2`     | Set Less Than Unsigned             | rd = ux(rs1) < ux(rs2)                          |
| `xor rd,rs1,rs2`      | Xor                                | rd = ux(rs1) ^ ux(rs2)                          |
| `srl rd,rs1,rs2`      | Shift Right Logical                | rd = ux(rs1) >> rs2                             |
| `sra rd,rs1,rs2`      | Shift Right Arithmetic             | rd = sx(rs1) >> rs2                             |
| `or rd,rs1,rs2`       | Or                                 | rd = ux(rs1) | ux(rs2)                          |
| `and rd,rs1,rs2`      | And                                | rd = ux(rs1) & ux(rs2)                          |
| `fence pred,succ`     | Fence                              | -                                               |
| `fence.i`             | Fence Instruction                  | -                                               |