module alu4bit(input [3:0] a, input [3:0] b, input [2:0] opcode, output reg [3:0] q, output of, output zf, output epf);


wire sbit = opcode[2]&(~opcode[1])&(~opcode[0]);   //sbit will only be high in subtraction opcode = 100
wire [3:0] sum;

assign of = flg&(~sbit);
assign zf = ~(|q);
assign epf = ~(^q);


addsub4bit add(a,b,sbit,sum,flg);


always@(*) begin

    case(opcode)
    3'd0: q = a&b;
    3'd1: q = a|b;
    3'd2: q = a^b;
    3'd3: q = sum;
    3'd4: q = (~sum)+1'b1;
    default: q = 4'b0;
    endcase

end

endmodule

module addsub4bit(input [3:0] a, input [3:0] b, input sbit, output [3:0] sum, output c);

    wire [3:0] modb;

    assign modb = sbit?(~(b) + 1'b1):b;

    wire [2:0] cinter;
    fa f1(a[0],modb[0],1'b0,sum[0],cinter[0]);
    fa f2(a[1],modb[1],cinter[0],sum[1],cinter[1]);
    fa f3(a[2],modb[2],cinter[1],sum[2],cinter[2]);
    fa f4(a[3],modb[3],cinter[2],sum[3],c);

endmodule


module fa(input a, input b, input cin, output s, output cout);
    assign {cout,s} = a+b+cin;
endmodule


