/*
//Configurable logic for CRC generation 

localparam CRC_BW        = 8;
localparam CRCXPOLYREV  = 'hE0;    // CRC-8 Polynom, umgekehrte Bitfolge 
localparam CRCXPOLY     = 'h07;    //CRC-8 Polynom,  Bitfolge 

function automatic logic[CRC_BW-1:0] generateCRC_X(
     logic [7:0] databyte_stream[],
     input logic reversed_poly=0,
     input logic[CRC_BW-1:0] start_crc_value='1, 
     input logic[CRC_BW-1:0] final_crc_xor_value='0,
     input logic do_end_crc_reversebits=0);
    int unsigned i, j;
    bit [CRC_BW-1:0] crcx_tmp,crcx_val = start_crc_value; // Schieberegister, Startwert (111...) 
    bit [7:0]  data;


    //Ergebnis der Schleife gibt 8-Bit-gespiegelte CRC
    for (i = 0; i < databyte_stream.size; i++)  // Byte-Stream
    begin
        if (reversed_poly==1) begin
            data = databyte_stream[i];

            for (j=0; j < 8; j++) // from LSB to MSB in one byte!
            begin
                if ((crcx_val[0]) != (data[0]))
                    crcx_val = (crcx_val >> 1) ^ CRCXPOLYREV;
                else
                    crcx_val >>= 1;

                data >>= 1;
            end
        end else begin
            data = databyte_stream[i];
            for (j=0; j < 8; j++) // from LSB to MSB in one byte
            begin
                if ((crcx_val[CRC_BW-1]) != (data[7]))
                    crcx_val = (crcx_val << 1) ^ CRCXPOLY;
                else
                    crcx_val <<= 1;

                data <<= 1;
            end
        end
    end
    crcx_val ^= final_crc_xor_value; //Ergebnis invertieren
    if (do_end_crc_reversebits==1) begin
        for (j=0; j < CRC_BW; j++) // from LSB to MSB in the CRC bitwidth
        begin
            crcx_tmp[CRC_BW-1-j]=crcx_val[j];//reversed
        end
        crcx_val=crcx_tmp;
    end
    return crcx_val;
endfunction : generateCRC_X

*/

/*

function byte calc_crc(byte unsigned cmd[]);
    bit [7:0] crc, d, c;
    int i;
    crc = 0;

    for (i=0; i<cmd.size(); i++) begin
            d = cmd[i];
            c = crc;
            crc[0] = d[7] ^ d[6] ^ d[0] ^ c[0] ^ c[6] ^ c[7];
            crc[1] = d[6] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[6];
            crc[2] = d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2] ^ c[6];
            crc[3] = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[3] ^ c[7];
            crc[4] = d[4] ^ d[3] ^ d[2] ^ c[2] ^ c[3] ^ c[4];
            crc[5] = d[5] ^ d[4] ^ d[3] ^ c[3] ^ c[4] ^ c[5];
            crc[6] = d[6] ^ d[5] ^ d[4] ^ c[4] ^ c[5] ^ c[6];
            crc[7] = d[7] ^ d[6] ^ d[5] ^ c[5] ^ c[6] ^ c[7];
    //$display("crc result: %h",crc);
    end
    return crc;
endfunction 

*/

/*

localparam CRC32POL = 32'hEDB88320; // Ethernet CRC-32 Polynom, reverse Bits 

function automatic bit[31:0] genCRC32(input bit [7:0] databyte_stream[]);
    int unsigned i, j;
    bit [31:0] crc32_val = 32'hffffffff; // shiftregister,startvalue 
    bit [7:0]  data;

    //The result of the loop generate 32-Bit-mirrowed CRC
    for (i = 0; i < databyte_stream.size; i++)  // Byte-Stream
    begin
        data = databyte_stream[i];
        for (j=0; j < 8; j++) // Bitwise from LSB to MSB
        begin
            if ((crc32_val[0]) != (data[0])) begin
                crc32_val = (crc32_val >> 1) ^ CRC32POL;
            end else begin
                crc32_val >>= 1;
            end
            data >>= 1;
        end
    end
    crc32_val ^= 32'hffffffff; //invert results
    return crc32_val;
endfunction : genCRC32

*/





localparam CRC_BW        = 32;
localparam CRCXPOLYREV  = 'h82608EDB; //polynomial value    
localparam CRCXPOLY     = 'h1_0000_0100_1100_0001_0001_1101_1011_0111;     

function automatic logic[CRC_BW-1:0] generateCRC_X(
     logic [3:0] databyte_stream[],
     input logic reversed_poly=0,
     input logic[CRC_BW-1:0] start_crc_value='1, 
     input logic[CRC_BW-1:0] final_crc_xor_value='0,
     input logic do_end_crc_reversebits=0);

    int unsigned i, j;
    bit [CRC_BW-1:0] crcx_tmp,crcx_val = start_crc_value; 
    bit [3:0]  data;

    for (i = 0; i < databyte_stream.size; i++)  // Byte-Stream
    begin
        if (reversed_poly==1) begin
            data = databyte_stream[i];

            for (j=0; j < 4; j++) // from LSB to MSB in one nibble!
            begin
                if ((crcx_val[0]) != (data[0]))
                    crcx_val = (crcx_val >> 1) ^ CRCXPOLYREV;
                else
                    crcx_val >>= 1;

                data >>= 1;
            end
        end else begin
            data = databyte_stream[i];
            for (j=0; j < 4; j++) // from LSB to MSB in one nibble
            begin
                if ((crcx_val[CRC_BW-1]) != (data[3]))
                    crcx_val = (crcx_val << 1) ^ CRCXPOLY;
                else
                    crcx_val <<= 1;

                data <<= 1;
            end
        end
    end
    crcx_val ^= final_crc_xor_value; //Ergebnis invertieren
    if (do_end_crc_reversebits==1) begin
        for (j=0; j < CRC_BW; j++) // from LSB to MSB in the CRC bitwidth
        begin
            crcx_tmp[CRC_BW-1-j]=crcx_val[j];//reversed
        end
        crcx_val=crcx_tmp;
    end
    return crcx_val;

endfunction : generateCRC_X
