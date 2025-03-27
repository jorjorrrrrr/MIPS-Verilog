owner	:= jorjor

# Simulation Command
VCS_RUN := vcs -kdb -R -full64 -sverilog +v2k +notimingcheck \
				-debug_acc +nospecify +vcs+flush+all -debug_access -l compile.log

CC 		:= -cm line+fsm+tgl+cond+branch+assert 

# Verilog Source Code
SRC		:= ./testbench/tb_cpu.sv \
			../../RTL/nonpipe/ArithmeticLogicUnit.v \
			../../RTL/nonpipe/ControlUnit.v \
			../../RTL/nonpipe/CPU.v \
			../../RTL/nonpipe/DataMemory.v \
			../../RTL/nonpipe/FA.v \
			../../RTL/nonpipe/HA.v \
			../../RTL/nonpipe/InstructionMemory.v \
			../../RTL/nonpipe/LoHiRegister.v \
			../../RTL/nonpipe/MultDiv.v \
			../../RTL/nonpipe/ProgramCounter.v \
			../../RTL/nonpipe/RegisterFile.v 

SRC_MODULE := ./testbench/tb_adder.sv \
			../../RTL/adder/RCA32.v \
			../../RTL/adder/CLA32.v \
			../../RTL/adder/MCLA32.v \
			../../RTL/adder/FA.v \
			../../RTL/adder/HA.v

# LOG file
define log
	cp compile.log $(1).log
endef

all: test_cpu
#all: test_adder

test_adder: 
	$(VCS_RUN) $(SRC_MODULE) +define+RCA32
	$(call log, "../../LOG/adder/rca32")
	$(VCS_RUN) $(SRC_MODULE) +define+CLA32
	$(call log, "../../LOG/adder/cla32")
	$(VCS_RUN) $(SRC_MODULE) +define+MCLA32
	$(call log, "../../LOG/adder/mcla32")

test_cpu: 
	$(VCS_RUN) $(SRC) +define+P1+PRINT
	$(call log, "../../LOG/cpu/cpu_pattern1")
	$(VCS_RUN) $(SRC) +define+P2
	$(call log, "../../LOG/cpu/cpu_pattern2")
	$(VCS_RUN) $(SRC) +define+P3
	$(call log, "../../LOG/cpu/cpu_pattern3")
	$(VCS_RUN) $(SRC) +define+P4
	$(call log, "../../LOG/cpu/cpu_pattern4")
	$(VCS_RUN) $(SRC) +define+P5+PRINT
	$(call log, "../../LOG/cpu/cpu_pattern5")
	$(VCS_RUN) $(SRC) +define+P6+PRINT
	$(call log, "../../LOG/cpu/cpu_pattern6")
	$(VCS_RUN) $(SRC) +define+P7+PRINT
	$(call log, "../../LOG/cpu/cpu_pattern7")
	$(VCS_RUN) $(SRC) +define+P8+PRINT
	$(call log, "../../LOG/cpu/cpu_pattern8")
	$(VCS_RUN) $(SRC)
	$(call log, "../../LOG/cpu/cpu")

# pre-simulation + Code Coverage
test_cpu_cc: 
	$(VCS_RUN) $(SRC) $(CC)

# open verdi
verdi:
	verdi -ssf novas.fsdb &

# Open verdi to observe code coverage
check_cc :
	verdi -cov -covdir simv.vdb -workMode coverageAnalysis &

# Clean it
clean: # Remove Specify File
	rm -rf command.log novas.* novas_dump.log \
		simv simv.vdb/ sim.daidir/ csrc/ \
		xcelium.d/ verdiLog/ xmverilog.* \
		alib-52/ default.svf filenames*.log \
		cm.log compile.log vdCovLog/ ucli.key \
		nWaveLog *.fsdb sdfAnnotateInfo *.mr \
		verdi_config_file *.pvl *.syn simv.daidir \
		cksum_dir .fsm.sch.verilog.xml verilog.dump

.PHONY: all test_cpu test_cpu_cc verdi check_cc clean
