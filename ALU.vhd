library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port(
		A,B: in std_logic_vector(3 downto 0);
		S: in std_logic_vector(2 downto 0);
		F: out std_logic_vector(3 downto 0);
		Co: out std_logic
	);
end ALU;

architecture behavior of ALU is
	component SumRes is
		port(
			A,B: in std_logic_vector(3 downto 0);
			M: in std_logic;
			S: out std_logic_vector(3 downto 0);
			Co: out std_logic
		);
	end component;

	signal AcompB: std_logic_vector(3 downto 0);-- A < B
	signal AminusB: std_logic_vector(3 downto 0); 
	signal AplusB: std_logic_vector(3 downto 0);
	signal AnorB: std_logic_vector(3 downto 0);
	signal AorB: std_logic_vector(3 downto 0);
	signal AandB: std_logic_vector(3 downto 0);  
	signal CarryRestUno, CarryRestDos, CarrySum: std_logic;
	signal Snew: std_logic_vector(2 downto 0); -- Lo niego por que es activo en 0 el push button de la FPGA

begin
	Snew <= not S(2) & S(1 downto 0);
    RestDos: SumRes port map(B=>B, A=>A, M=>'1', S=>AminusB, Co=>CarryRestDos);
	SumaUno: SumRes port map(A=>A, B=>B, M=>'0', S=>AplusB, Co=>CarrySum);
	AnorB <= A nor B;
	AorB <= A or B;
	AandB <= A and B;
    AcompB <= "0001" when unsigned(A) < unsigned(B) else "0000";
	
	-- Para simular usar "S", irl "Snew"
	with S select
		F <= "0000" when "000",
			AcompB when "001",
			AminusB when "010",
			AplusB when "011",
			AnorB when "100",
			AorB when "101",
			AandB when "110",
			"1111" when "111",
			"0000" when others;

	with S select
		Co <= CarryRestUno when "001",
			CarryRestDos when "010",
			CarrySum when "011",
			'0' when others;

end behavior;