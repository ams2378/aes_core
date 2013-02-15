#TOP=top.sv 
#INTERFACE=interface.sv
BENCH=  aes.c test.c test.sv
#DUT=  aes.c test.c  test.sv 

#DUT=  test.sv 
.PHONY: help

#dut:  
#	vcs -full64 -PP -sverilog +define+SV +define+VPD +lint=all,noVCDE -notice $(DUT) 

#test: 
#	vcs -PP -sverilog +define+SV +define+VPD $(INTERFACE) $(BENCH)

bench: 
	vcs -full64 -PP -sverilog +define+SV +define+VPD  $(BENCH) -o testbench.exe
        
#wave:
#	vcs -vpd2vcd vcdplus.vpd waveform.vcd
#	gtkwave waveform.vcd &

clean:
	rm -rf *.o *~ *.vpd sim* csrc DVEfiles *daidir *exe *.key

