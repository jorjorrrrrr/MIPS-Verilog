# 5-Stage pipeline MIPS 32-bit processor

## Five stages of processor
- Instruction fetch (IF)
- Instruction decode and register file read (ID)
- Execution or address calculation (EX)
- Data memory access (MEM)
- Write back data to register file (WB)

## Pipeline Hazards
- [ ] Structural hazards: attempt to use the same resource in two different ways at the same time
  - **Ex.** It requires 5 stages to complete the LW calculation, but R-type inst. not need to access memory. If LW occurs before R-type inst., then hazard occurs.
    - [ ] Solution: All instructions are forced to take 5 stages. (insert NOP into MEM stage of R-type inst.)
  - **Ex.** Only using a memory to fetch instruction and load/store data
    - [X] Solution: In MIPS, use 2 memory : data memory and instruction memory
- [ ] Data hazards: attempt to use item before ready
  - **Ex.** Instruction depends on result of prior instruction still in the pipeline
    - [X] Solution: insert NOP (operate in software; not consider at here)
    - [ ] Solution: Forwarding method
  - **Ex.** 
- [ ] Control hazards: attempt to make decision before condition is evaluated
