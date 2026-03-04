library ieee;
use ieee.std_logic_1164.all;

entity SumRes is
    port( A,B: in std_logic_vector(3 downto 0);
		  M: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Co: out std_logic
    );
    end SumRes;

architecture ARC of SumRes is
    component FullAdder is
        port( A,B, Cin: in std_logic;
            S, Co: out std_logic
        );
        end component;
    signal C: std_logic_vector(3 downto 1);
	 signal xorB: std_logic_vector(3 downto 0);

    begin
	 
			xorB(0) <= B(0) xor M;
			xorB(1) <= B(1) xor M;
			xorB(2) <= B(2) xor M;
			xorB(3) <= B(3) xor M;

        I0: FullAdder port map(A(0), xorB(0), M, S(0), C(1));
        I1: FullAdder port map(A(1), xorB(1), C(1), S(1), C(2));
        I2: FullAdder port map(A(2), xorB(2), C(2), S(2), C(3));
        I3: FullAdder port map(A(3), xorB(3), C(3), S(3), Co);
    end ARC;