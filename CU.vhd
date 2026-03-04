library ieee;
use ieee.std_logic_1164.all;

entity CU is
    port(
        clk:in std_logic;
        rst:in std_logic;
        opcode:in std_logic_vector(5 downto 0);
        MemRead:out std_logic;
        MemWrite:out std_logic;
        IRWrite:out std_logic;
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

architecture behavior of CU is
    type state_t is( S0, S1, S2, S3, S4, S5, S6, S7, S8);

    signal state, nxt_state : state_t;

    constant OP_RTYPE : std_logic_vector(5 downto 0) := "000000";
    constant OP_LW : std_logic_vector(5 downto 0) := "100011";
    constant OP_SW : std_logic_vector(5 downto 0) := "101011";
    constant OP_BEQ : std_logic_vector(5 downto 0) := "000100";

begin

    -- registros de estados
    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then 
                state <= S0;
            else 
                state <= nxt_state;
            end if;
        end if;
    end process;

    -- logica
    process(state, opcode)
    begin
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        IorD <= '0';
        RegWrite <= '0';
        MemtoReg <= '0';
        RegDst <= '0';
        ALUSrcA <= '0';
        ALUSrcB <= "00";
        ALUOp <= "00";
        PCWrite <= '0';
        PCWriteCond <= '0';
        PCSource <= "00";
        
        nxt_state <= S0;

        case state is -- fetch
            when S0 =>
                MemRead <= '1';
                IRWrite <= '1';
                IorD <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "01";
                ALUOp <= "00";
                PCWrite <= '1';
                PCSource <= "00";
                
                nxt_state <= S1;
        
            when S1 => -- decode
                ALUSrcA <= '0';
                ALUSrcB <= "11";
                ALUOp <= "00";

                if(opcode = OP_LW) or (opcode = OP_SW) then
                    nxt_state <= S2;
                elsif opcode = OP_RTYPE then
                    nxt_state <= S6;
                elsif opcode = OP_BEQ then
                    nxt_state <= S8;
                else 
                    nxt_state <= S0;
                end if;
            
            when S2 => -- memory address
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                ALUOp <= "00";
                
                if opcode = OP_LW then
                    nxt_state <= S3;
                else 
                    nxt_state <= S5;
                end if;
            
            when S3 => -- memory access
                MemRead <= '1';
                IorD <= '1';

                nxt_state <= S4;
            
            when S4 => -- write back step
                RegDst <= '0';
                RegWrite <= '1';
                MemtoReg <= '1';

                nxt_state <= S0;

            when S5 => -- memory access
                MemWrite <= '1';
                IorD <= '1';

                nxt_state <= S0;
            
            when S6 => -- execution 
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "10";

                nxt_state <= S7;

            when S7 => -- R-type completion
                RegDst <= '1';
                RegWrite <= '1';
                MemtoReg <= '0';

                nxt_state <= S0;
            
            when S8 => -- Branch completion
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                ALUOp <= "01";
                PCWriteCond <= '1';
                PCSource <= "01";

                nxt_state <= S0;
        
        end case;
    end process;

end architecture;
