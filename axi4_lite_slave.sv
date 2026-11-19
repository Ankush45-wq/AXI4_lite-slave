// Code your design here
// Code your design here
// Code your design here
///////////////////////////////////////axi_write/////////////////////////////
module axi_write #(parameter WIDTH = 32)(
              input clk,
              input rst,
  
              input [WIDTH-1:0]AWADDR,
              input AWVALID,
              output AWREADY,

              input [WIDTH-1:0]WDATA,
              input [WIDTH/8-1:0]WSTRB,
              input WVALID,
              output WREADY,

              input BREADY,
              output [1:0]BRESP,
              output BVALID,
  
  output logic [WIDTH-1:0]add_reg,
  output logic [WIDTH-1:0]wdata_reg,
  output logic [WIDTH/8-1:0]wstrb_reg,
  output logic write_en

);
  
  logic aw_received;
  logic w_received;

//AREADY logic
assign AWREADY = ~aw_received;
//write logic
assign WREADY = ~w_received;
//write\_en
assign write_en = aw_received && w_received;

always_ff@(posedge clk or posedge rst)
  begin
    if(rst)
      begin
        add_reg <= 0;
        wdata_reg <= 0;
        wstrb_reg <= 0;
        aw_received <= 1'b0;
        w_received <= 1'b0;
         BVALID       <= 1'b0;
         BRESP        <= 2'b00;
      end
  else
    begin
      if(AWVALID && AWREADY)
        begin
          add_reg <= AWADDR;
          aw_received <= 1'b1;
        end
      if (WVALID && WREADY)
        begin
          wdata_reg <= WDATA;
          wstrb_reg <= WSTRB;
          w_received <= 1'b1;
        end
      if (write_en)
        begin
            BVALID <= 1'b1;
            BRESP  <= 2'b00;
        end
      if(BVALID && BREADY)
        begin
          aw_received <= 0;
          w_received <= 0;
          BVALID <= 0;
        end
      endr
  end
endmodule

//////////////////////////////register_bank///////////////////////
module register_bank#(parameter WIDTH =32)(
  input clk,
  input rst,
  
  input logic [WIDTH-1:0]add_reg,
  input logic [WIDTH-1:0]wdata_reg,
  input logic [WIDTH/8-1:0]wstrb_reg,
  input logic write_en,
  
  output logic [WIDTH-1:0] control_reg,
  output logic [WIDTH-1:0] status_reg,
  output logic [WIDTH-1:0] gpio_out_reg,
  output logic [WIDTH-1:0] gpio_in_reg,
  output logic [WIDTH-1:0] version_reg,
  output logic [WIDTH-1:0] irq_enable_reg,
  output logic [WIDTH-1:0] irq_status_reg,
  output logic [WIDTH-1:0] scratch_reg,
  
  
  input  [WIDTH-1:0] read_addr,
  output logic [WIDTH-1:0] read_data

);
  
  always_ff@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          control_reg <= 0;
          status_reg <= 0;
          gpio_out_reg <= 0;
          gpio_in_reg <= 0;
          version_reg <= 0;
          irq_enable_reg <= 0;
          irq_status_reg <= 0;
          scratch_reg <= 0;
        end
      
      else
        begin
          if(write_en)
            begin
              case(add_reg)
                32'h00:begin
                  if(wstrb_reg[0])
                    begin
                      control_reg[7:0] <=wdata_reg[7:0]; 
                    end
                  if(wstrb_reg[1])
                    begin
                      control_reg[15:8] <=wdata_reg[15:8]; 
                    end
                  if(wstrb_reg[2])
                    begin
                      control_reg[23:16] <=wdata_reg[23:16]; 
                    end
                  if(wstrb_reg[3])
                    begin
                      control_reg[31:24] <=wdata_reg[31:24]; 
                    end
                end
                32'h08:begin
                  if(wstrb_reg[0])
                    begin
                      gpio_out_reg[7:0] <= wdata_reg[7:0];
                    end
                  if(wstrb_reg[1])
                    begin
                      gpio_out_reg[15:8] <= wdata_reg[15:8];
                    end
                  if(wstrb_reg[2])
                    begin
                      gpio_out_reg[23:16] <= wdata_reg[23:16];
                    end
                  if(wstrb_reg[3])
                    begin
                      gpio_out_reg[31:24] <= wdata_reg[31:24];
                    end
                end
                32'h14:begin
                  if(wstrb_reg[0])
                    begin
                      irq_enable_reg[7:0] <= wdata_reg[7:0];
                    end
                  if(wstrb_reg[1])
                    begin
                      irq_enable_reg[15:8] <= wdata_reg[15:8];
                    end
                  if(wstrb_reg[2])
                    begin
                      irq_enable_reg[23:16] <= wdata_reg[23:16];
                    end
                  if(wstrb_reg[3])
                    begin
                      irq_enable_reg[31:24] <= wdata_reg[31:24];
                    end
                end
                32'h1C:begin
                  if(wstrb_reg[0])
                    begin
                      scratch_reg[7:0] <= wdata_reg[7:0];
                    end
                  if(wstrb_reg[1])
                    begin
                      scratch_reg[15:8] <= wdata_reg[15:8];
                    end
                  if(wstrb_reg[2])
                    begin
                      scratch_reg[23:16] <= wdata_reg[23:16];
                    end
                  if(wstrb_reg[3])
                    begin
                      scratch_reg[31:24] <= wdata_reg[31:24];
                    end
                end
              endcase
            end
        end
    end
  always_comb
    begin
      case(read_addr)
        32'h00:
          begin
            read_data = control_reg;
          end
        32'h04:
          begin
            read_data = status_reg;
          end
        32'h08:
          begin
            read_data = gpio_out_reg;
          end
        32'h0C:
          begin
            read_data = gpio_in_reg;
          end
        32'h10:
          begin
            read_data = version_reg;
          end
        32'h14:
          begin
            read_data = irq_enable_reg;
          end
        32'h18:
          begin
            read_data = irq_status_reg;
          end
        32'h1C:
          begin
            read_data = scratch_reg;
          end
        default:
          begin
            read_data = '0;
          end
      endcase
    end
endmodule

/////////////////////////////read_logic////////////////////////////////////////
module axi_read#(parameter WIDTH = 32)(
                        input clk,
                        input rst,
                        input [WIDTH-1:0] ARADDR,
                        input ARVALID,
                        output ARREADY,

                        input RREADY,
                        output [WIDTH-1:0]RDATA,
                        output [1:0]RRESP,
                        output RVALID,
  
 input logic [WIDTH-1:0] read_data,
 output logic [WIDTH-1:0] read_addr;
  

);
  logic ar_received;
  logic read_addr_valid;
  assign read_addr_valid =( 
    	(read_addr == 32'h00) ||
        (read_addr == 32'h04) ||
        (read_addr == 32'h08) ||
        (read_addr == 32'h0C) ||
        (read_addr == 32'h10) ||
        (read_addr == 32'h14) ||
        (read_addr == 32'h18) ||
    	(read_addr == 32'h1C)); 

  assign ARREADY = ~ar_received;
  assign RDATA = read_data;
  
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          read_addr <= 0;
          ar_received <= 0;
          RVALID <= 0;
          RRESP <= 0;
        end
      else
        begin
          if(ARVALID && ARREADY)
            begin
              read_addr <= ARADDR;
              ar_received  <= 1'b1;
            end
          if(ar_received)
            begin
              if(read_addr_valid)
                begin
                  RVALID <= 1'b1;
                  RRESP <= 2'b00;//okay
                end
              else
                begin
                  RVALID <=1'b1;
                  RRESP <= 2'b10;//sleverr
                end
            end
          if(RREADY && RVALID)
            begin
              RVALID <= 0;
              ar_received <= 0;
            end
          
        end
    end
endmodule

/////////////////////////////top module /////////////////////////////////////
module axi_slave_top #(parameter WIDTH = 32)(
  input clk,
  input rst,
  
              input [WIDTH-1:0]AWADDR,
              input AWVALID,
              output AWREADY,

              input [WIDTH-1:0]WDATA,
              input [WIDTH/8-1:0]WSTRB,
              input WVALID,
              output WREADY,
  
              input BREADY,
              output [1:0]BRESP,
              output BVALID,
  
              input [WIDTH-1:0] ARADDR,
              input ARVALID,
              output ARREADY,

              input RREADY,
              output [WIDTH-1:0]RDATA,
              output [1:0]RRESP,
              output RVALID,
  
  
  
);
  
  logic [WIDTH-1:0]add_reg;
  logic [WIDTH-1:0]wdata_reg;
  logic [WIDTH/8-1:0]wstrb_reg;
  logic write_en;
  
  logic  [WIDTH-1:0] read_addr;
  logic [WIDTH-1:0] read_data;
  //axi_write_top
  axi_write #(.WIDTH(WIDTH)) uxi_write(
    .clk(clk),
    .rst(rst),
  
    .AWADDR(AWADDR),
    .AWVALID(AWVALID),
    .AWREADY(AWREADY),

    .WDATA(WDATA),
    .WSTRB(WSTRB),
    .WVALID(WVALID),
    .WREADY(WREADY),

    .BREADY(BREADY),
    .BRESP(BRESP),
    .BVALID(BVALID),
  
    .add_reg(add_reg),
    .wdata_reg(wdata_reg),
    .wstrb_reg(wstrb_reg),
    .write_en(write_en)
  
  );
  
  register_bank#(.WIDTH(WIDTH)) uxi_register_bank(
    .clk(clk),
    .rst(rst),
     
    .add_reg(add_reg),
    .wdata_reg(wdata_reg),
    .wstrb_reg(wstrb_reg),
    .write_en(write_en),
  
    .read_addr(read_addr),
    .read_data(read_data)

  );
  axi_read#(.WIDTH(WIDTH)) uxi_read(
    .clk(clk),
    .rst(rst),
    .ARADDR(ARADDR),
    .ARVALID(ARVALID),
    .ARREADY(ARREADY),

    .RREADY(RREADY),
    .RDATA(RDATA),
    .RRESP(RRESP),
    .RVALID(RVALID),
  
    .read_data(read_data),
    .read_addr(read_addr)
  );
endmodule























