library ieee;
use ieee.std_logic_1164.all;

entity Top is
    port(
        clk:in std_logic;
        rst:in std_logic;
        opcode:in std_logic_vector(5 downto 0);
        funct:in std_logic_vector(5 downto 0);

        A:in std_logic_vector(3 downto 0);
        B:in std_logic_vector(3 downto 0);
        ALUres:out std_logic_vector(3 downto 0);
        Co:out std_logic; 

        
        MemRead:out std_logic;
        MemWrite:out std_logic;
        IrWrite:out std_logic;
        IorD:out std_logic;
        RegWrite:out std_logic;
        MemtoReg:out std_logic;
        RegDst:out std_logic;
        ALUSrcA:out std_logic;
        ALUSrcB:out std_logic_vector(1 downto 0);
        ALUOp:out std_logic_vector(1 downto 0);
        PCWrite:out std_logic;
        PCWriteCond:out std_logic;
        PCSource:out std_logic_vector(1 downto 0)
    );
end entity;

architecture behavior of Top is

    signal sig_ALUcont : std_logic_vector(2 downto 0);
    signal sig_ALUOp : std_logic_vector(1 downto 0);
    signal sig_ALUSrcB : std_logic_vector(1 downto 0);
    signal sig_PCSource : std_logic_vector(1 downto 0);
    signal sig_PCWriteCond : std_logic;

begin
    
    U_CU: entity work.CU
        port map(
            clk => clk,
            rst => rst,
            opcode => opcode,

            MemRead => MemRead,
            MemWrite => MemWrite,
            IRWrite => IRWrite,
            IorD => IorD,
            RegWrite => RegWrite,
            MemtoReg => MemtoReg,
            RegDst => RegDst,
            ALUSrcA => ALUSrcA,
            ALUSrcB => sig_ALUSrcB,
            ALUOp => sig_ALUOp,
            PCWrite => PCWrite,
            PCWriteCond => sig_PCWriteCond,
            PCSource => sig_PCSource
        );
    
    U_ALUCRL: entity work.ALUcontrol
        port map(
            ALUOp => sig_ALUOp,
            funct => funct,
            ALUcont => sig_ALUcont
        );

    U_ALU: entity work.ALU
        port map(
            A => A,
            B => B,
            S => sig_ALUcont,
            F => ALUres,
            Co => Co
        );

    ALUOp <= sig_ALUOp;
    ALUSrcB <= sig_ALUSrcB;
    PCSource <= sig_PCSource;
    PCWriteCond <= sig_PCWriteCond;

end architecture;