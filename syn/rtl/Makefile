MODULES=  aes_output_buffer.sv aes_input_buffer.sv aes_rcon.sv aes_sbox.sv  aes_xor.sv aes_addroundkey.sv aes_key_expand_128.sv aes_cipher_top.sv aes_top.sv
INTERFACE= interface.sv
#TOP = ../bench/top.sv
#TEST= ../bench/aes_env.sv ../bench/aes_checker.sv ../bench/aes_transactions.sv ../bench/aes.c ../bench/test.c ../bench/test.sv
#BENCH=../sim/testbench.exe


test:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(INTERFACE) $(MODULES)  $(TOP) 


