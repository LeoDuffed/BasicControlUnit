library ieee;
use ieee.std_logic_1164.all;

entity ALUcontrol is
    port(
        ALUOp:in std_logic_vector(1 downto 0);
        funct:in std_logic_vector(5 downto 0);
        ALUcont:out std_logic_vector(2 downto 0)
    );
end entity;

architecture behavior of ALUcontrol is
begin
    process (ALUOp, funct)
    begin

        ALUcont <= "000";

        case ALUOp is -- Falta xor y preset
            when "00" => 
                ALUcont <= "011"; -- suma
            when "01" =>
                ALUcont <= "010"; -- resta
            when "10" =>
                case funct is  
                    when "100000" => 
                        ALUcont <= "011"; -- suma
                    when "100010" =>
                        ALUcont <= "010"; -- resta
                    when "100100" => 
                        ALUcont <= "110"; -- and
                    when "100101" =>
                        ALUcont <= "101"; -- or
                    when "101010" =>
                        ALUcont <= "001"; -- A < B
                    when "100001" =>
                        ALUcont <= "100"; -- nor 
                    when others => 
                        ALUcont <= "000";
                end case;
            when others =>
                ALUcont <= "000";
        end case;

    end process;

end architecture;
