`timescale 1ps/1ps

module tb;


reg [3:0] a,b;
reg[2:0] opcode;
wire [3:0] sum;
wire of,pf,zf;


alu4bit alu(a,b,opcode,sum,of,zf,pf);

initial begin
    a = 4'b0000; b = 4'b0000; opcode = 3'b000;
    $monitor("a = %d, b = %d, opcode = %b, result = %d, overflow = %b, Output_is_zero = %b, is_number_of_1s_even = %b",a,b,opcode,sum,of,zf,pf);
    $dumpfile("alu.vcd");
    $dumpvars(0,tb);

end

always #1024 a[3] = ~a[3];
always #512 a[2] = ~a[2];
always #256 a[1] = ~a[1];
always #128 a[0] = ~a[0];
always #64 b[3] = ~b[3];
always #32 b[2] = ~b[2];
always #16 b[1] = ~b[1];
always #8 b[0] = ~b[0];
always #4 opcode[2] = ~opcode[2];
always #2 opcode[1] = ~opcode[1];
always #1 opcode[0] = ~opcode[0];

initial begin
    #2050 $finish;
end


endmodule