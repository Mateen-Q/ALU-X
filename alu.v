module alu4bit(input [3:0] a, input [3:0] b, input [2:0] opcode, output reg [7:0] q, output of, output zf, output epf);


wire sbit = opcode[2]&(~opcode[1])&(~opcode[0]);   //sbit will only be high in subtraction opcode = 100
wire [3:0] sum;
wire [7:0] mult;

assign of = flg&(~sbit);
assign zf = ~(|q);
assign epf = ~(^q);


addsub4bit add(a,b,sbit,sum,flg);
mult4bit multiply(a,b,mult);


always@(*) begin

    case(opcode)
    3'd0: q = a&b;
    3'd1: q = a|b;
    3'd2: q = a^b;
    3'd3: q = sum;
    3'd4: q = (~sum)+1'b1;
    3'd5: q = mult;
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
    wire w1,w3,w4;
    xor g1(w1,a,b);
    xor g2(s,w1,cin);
    and g3(w3,w1,cin);
    and g4(w4,a,b);
    or g5(cout,w3,w4);
endmodule


module ha(input a, input b, output s, output c);
    xor g1(s,a,b);
    and g2(c,a,b);
endmodule


module mult4bit(input [3:0] a, input [3:0] b, output [7:0] p);
    wire b0a1, b1a0, b0a2, b1a1,b0a3, b1a2, b1a3;
    wire l1c1, l1s1, l1c2, l1s2, l1c3,l1s3, l1c4;
    wire b2a0, b2a1, b2a2, b2a3;
    wire l2c1,l2s1,l2c2,l2s2,l2c3,l2s3,l2c4;
    wire b3a0, b3a1, b3a2, b3a3;
    wire l3c1,l3c2,l3c3;
    and g1(p[0],a[0],b[0]);
    and g2(b0a1,b[0],a[1]);
    and g3(b1a0,b[1],a[0]);
    and g4(b0a2, b[0],a[2]);
    and g5(b1a1,b[1],a[1]);
    and g6(b0a3,b[0],a[3]);
    and g7(b1a2,b[1],a[2]);
    and g8(b1a3,b[1],a[3]);
    and g9(b2a0,b[2],a[0]);
    and g10(b2a1,b[2],a[1]);
    and g11(b2a2,b[2],a[2]);
    and g12(b2a3,b[2],a[3]);
    and g13(b3a0,b[3],a[0]);
    and g14(b3a1,b[3],a[1]);
    and g15(b3a2,b[3],a[2]);
    and g16(b3a3,b[3],a[3]);
    ha ha1(b0a1,b1a0,p[1],l1c1);
    fa fa1(l1c1,b0a2,b1a1,l1s1,l1c2);
    fa fa2(l1c2,b0a3,b1a2,l1s2,l1c3);
    ha ha2(l1c3,b1a3,l1s3,l1c4);
    ha ha3(l1s1,b2a0,p[2],l2c1);
    fa fa3(l2c1,l1s2,b2a1,l2s1,l2c2);
    fa fa4(l2c2,l1s3,b2a2,l2s2,l2c3);
    fa fa5(l2c3,l1c4,b2a3,l2s3,l2c4);
    ha ha4(l2s1,b3a0,p[3],l3c1);
    fa fa6(l3c1,l2s2,b3a1,p[4],l3c2);
    fa fa7(l3c2,l2s3,b3a2,p[5],l3c3);
    fa fa8(l3c3,l2c4,b3a3,p[6],p[7]);
endmodule

