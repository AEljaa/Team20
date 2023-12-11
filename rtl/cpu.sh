#!/bin/sh
# cleanup
rm -rf obj_dir
rm -r *.vcd

# run Verilator so we can translate .sv into .cpp, and pass this to our C++ testbench
make 
verilator -Wall --cc --trace cpu.sv --exe cpu_tb.cpp

#build the C++ project through make automatically generated by verilator

make -j -C obj_dir/ -f Vcpu.mk Vcpu

#run the executable simulation file

obj_dir/Vcpu