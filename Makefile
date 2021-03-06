
upload: demo.bin
	iceprog demo.bin

test: Demo
	./Demo

clean:
	@rm -rf verilog
	@rm -f demo.blif demo.txt demo.bin

Demo: Demo.hs
	clash Demo.hs

verilog/Main/blinker.v: Demo.hs
	clash --verilog Demo.hs

demo.blif: verilog/Main/blinker.v
	(cd verilog/Main; yosys -p "synth_ice40 -blif ../../demo.blif" $$(ls *.v|grep -v testbench.v))

demo.txt: demo.blif
	arachne-pnr -d 1k -p icestick.pcf demo.blif -o demo.txt

demo.bin: demo.txt
	icepack demo.txt demo.bin

