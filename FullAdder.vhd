library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
	port (
		A, B, Cin: in std_logic;
		S,Co: out std_logic
	);
end entity FullAdder;

architecture behavior of FullAdder is

	component HalfAdder is
		port (
			A, B: in std_logic;
			S, Co: out std_logic
		);
	end component HalfAdder;
	
	signal C: std_logic_vector(2 downto 0);

	begin

		I0: HalfAdder port map(A => A, B => B, Co => C(2), S => C(1));

		I1: HalfAdder port map(A => C(1), B => Cin, S => S, Co => C(0));
		 

		Co <= C(2) or C(0);
	
end architecture behavior;