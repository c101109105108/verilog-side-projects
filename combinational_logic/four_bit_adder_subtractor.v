module full_adder(
input A, B, adder_cin,
output S, adder_cout
);

wire xor_x1_out, and_a1_out, and_a2_out;

xor x1(xor_x1_out, A, B);
and a1(and_a1_out, A, B);
xor x2(S, xor_x1_out, adder_cin);
and a2(and_a2_out, xor_x1_out, adder_cin);
or o1(adder_cout, and_a2_out, and_a1_out);
endmodule // module full_adder

module four_bit_adder_subtractor(
input A0, A1, A2, A3, B0, B1, B2, B3, Cin, K,
output S0, S1, S2, S3, Cout
);

wire xor_x3_out, xor_x4_out, xor_x5_out, xor_x6_out;
wire c0, c1, c2;

xor x3(xor_x3_out, B0, K);
xor x4(xor_x4_out, B1, K);
xor x5(xor_x5_out, B2, K);
xor x6(xor_x6_out, B3, K);

full_adder fa0(A0, xor_x3_out, Cin, S0, c0);
full_adder fa1(A1, xor_x4_out, c0, S1, c1);
full_adder fa2(A2, xor_x5_out, c1, S2, c2);
full_adder fa3(A3, xor_x6_out, c2, S3, Cout);

endmodule // four_bit_adder_subtractor
