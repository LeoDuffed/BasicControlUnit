library ieee;
use ieee.std_logic_1164.all;

Entity HalfAdder is
    port(A,B: in std_logic;
        S, Co: out std_logic);
end HalfAdder;

Architecture behavior of HalfAdder is
begin   
    S <= A xor B;
    Co <= A and B;
end behavior;