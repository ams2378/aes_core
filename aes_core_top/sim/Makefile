MODULES= ../rtl/aes_rcon.sv ../rtl/aes_sbox.sv ../rtl/aes_inv_sbox.sv ../rtl/aes_xor.sv ../rtl/aes_addroundkey.sv ../rtl/aes_key_expand_128.sv ../rtl/aes_cipher_top.sv ../rtl/aes_inv_cipher_top.sv ../rtl/aes_top.sv
INTERFACE= ../bench/interface.sv
TOP = ../bench/top.sv
TEST= ../bench/test.sv
BENCH=../sim/testbench.exe

all: 
	make cleanall
	make test
	make gtkwave
duv4:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(INTERFACE) $(MODULES) $(TOP)-o $(BENCH)
	./$(BENCH)

test:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(INTERFACE) $(MODULES)  $(TOP) $(TEST) -o $(BENCH)
	./$(BENCH)

view:
	dve -full64 -vpd vcdplus.vpd &

gtkwave:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &

#leda:
#	leda -full64 -sverilog -top $(DUV) $(DUV4).sv $(DUV42).sv $(DUV16).sv $(DUV41).sv $(DUV43).sv $(DUV).sv
cleanall:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles testbench.exe* 

cleanlog:
	rm -rf log_*



#duv41:
#	vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV41).sv -o $(BENCH)
#	./$(BENCH)
#duv:
#	vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV4).sv $(DUV41).sv $(DUV).sv -o $(BENCH)
#	./$(BENCH)

