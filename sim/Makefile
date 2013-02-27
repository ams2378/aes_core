MODULES= ../rtl/aes_rcon.sv ../rtl/aes_sbox.sv ../rtl/aes_key_expand_128.sv ../rtl/aes_cipher_top.sv ../rtl/aes_top.sv
INTERFACE= ../bench/interface.sv
TOP = ../bench/top.sv
TEST= ../bench/aes_env.sv ../bench/aes_checker.sv ../bench/aes_transactions.sv ../bench/aes.c ../bench/test.c ../bench/test.sv
BENCH=../sim/testbench.exe

all: 
	make clean
	make test
	make gtkwave
duv4:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(INTERFACE) $(MODULES) $(TOP)-o $(BENCH)
	./$(BENCH)

test:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(INTERFACE) $(MODULES)  $(TOP) $(TEST) -o $(BENCH)
	./$(BENCH)

view:
#	dve -full64 -vpd vcdplus.vpd &

gtkwave:
#	vcs -vpd2vcd vcdplus.vpd waveform.vcd
#	gtkwave waveform.vcd &

#leda:
#	leda -full64 -sverilog -top $(DUV) $(DUV4).sv $(DUV42).sv $(DUV16).sv $(DUV41).sv $(DUV43).sv $(DUV).sv
clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles



#duv41:
#	vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV41).sv -o $(BENCH)
#	./$(BENCH)
#duv:
#	vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV4).sv $(DUV41).sv $(DUV).sv -o $(BENCH)
#	./$(BENCH)

