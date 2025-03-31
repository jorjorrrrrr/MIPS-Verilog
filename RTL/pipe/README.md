# 5-Stage pipeline MIPS 32-bit processor

## Five stages of processor
- Instruction fetch (IF)
- Instruction decode and register file read (ID)
- Execution or address calculation (EX)
- Data memory access (MEM)
- Write back data to register file (WB)

## :warning: Pipeline Hazards
### :dart: Structural hazards: attempt to use the same resource in two different ways at the same time
- **Ex.** It requires 5 stages to complete the LW calculation, but R-type inst. not need to access memory. If LW followed by R-type inst., then hazard occurs.
  - :white_check_mark: Solution: All instructions are forced to take 5 stages. (insert NOP into MEM stage of R-type inst.)
- **Ex.** Only using a memory to fetch instruction and load/store data
  - :white_check_mark: Solution: In MIPS, use 2 memory : data memory and instruction memory
### :dart: Data hazards: attempt to use item before ready (inst. i1 followed by inst. i2)
- **Read after Write (RAW)** : i2 tries to read operand before i1 writes it
  - **R-type-use**
    - :white_check_mark: Solution 1: insert NOP (operate in software which achieve lower throughput; :x: consider at here)
    - :white_check_mark: Solution 2: Forwarding method (need to design a `forwarding unit`)
  - **load-use**
    - :white_check_mark: Solution 1: insert NOP (operate in software which achieve lower throughput; :x: consider at here)
    - :white_check_mark: Solution 2: Stall method (need to design a `hazard detection unit`)
- **Write after Read (WAR)** : i2 tries to write operand before i1 read it
  - :white_check_mark: Solution: In MIPS, eliminate WAR by always fetching operands early (ID) in pipeline
- **Write after Write (WAW)** : i2 tries to write operand before i1 write it
  - :white_check_mark: Solution: In MIPS, eliminate WAW by doing all write backs in order (last stage, static)
### :dart: Control hazards: attempt to make decision before condition is evaluated
- **Branch hazards** : In conventional design, branch condition is determined at MEM stage, which wastes a lot of time and decreases throughput.
  - :white_check_mark: Solution: move the decision about branch conditions earlier in the pipeline (like ID stage).
- **Challenges of Further Reducing Delay**: A direct approach to complete branch condition is to predict that the branch is always not taken (flush the instruction after branch), which can decrease throughput in certain scenarios, such as nested loops.
  - :white_check_mark: Solution 1: Compiler rescheduling, Delayed branch (:x: consider at here)
  - :hourglass_flowing_sand: Solution 2: Dynamic branch prediction like 1-bit predictor and 2-bit predictor.
