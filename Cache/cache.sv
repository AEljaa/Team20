module cache #(
    parameter setlength = 3 // a set length of 3 means 8 cache blocks
)(
    input clk,
    input wen,
    input logic [31:0] addr, //[Tag,set,byte_offset]
    input logic [31:0] ramdata,
    input logic [31:0] wdatain, 
    output logic [31:0] cache_out,
    output logic Hit
);
//TODO : ADD cu signals for chace wheter we have read from mem or write from meme
logic [62-setlength:0] cacheblocks [2**setlength-1:0]; // our set is 3 bits and so at most 8 cache blocks
//input 
logic [29-setlength:0] tag_i = addr[31:setlength+2];
logic [setlength-1:0] set_i = addr[setlength+1:2]; 
//cache
logic v_c = cacheblocks[set_i][62-setlength];
logic [29-setlength:0] tag_c = cacheblocks[set_i][61-setlength:32];

always_latch begin
    if(v_c && tag_c == tag_i) begin
        cache_out = cacheblocks[set_i][31:0];
    end
    else begin
        cache_out = ramdata;
    end
end

always_ff@(posedge clk)begin
    //if mem type 
    if(wen)begin
        cacheblocks[set_i][31:0] <= wdatain; // assign the data of the address into the cache if there was not a hit
        cacheblocks[set_i][61-setlength:32] <= tag_i; // replace the old tag with now the new tag of what we are replacing
        cacheblocks[set_i][62-setlength] <= 1; // cache v bit is now valid (1)
    end
    if(!(v_c && tag_c == tag_i))begin
        cacheblocks[set_i][31:0] <= ramdata; // assign the data of the address into the cache if there was not a hit
        cacheblocks[set_i][61-setlength:32] <= tag_i; // replace the old tag with now the new tag of what we are replacing
        cacheblocks[set_i][62-setlength] <= 1; // cache v bit is now valid (1)

    end
end

endmodule