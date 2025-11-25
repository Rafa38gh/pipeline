-- Multiplexador 2 para 1 --
-- Entradas de 16 bits --

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux2_1 IS
    PORT(
        A       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        B       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        SEL     : IN  STD_LOGIC;
        Y       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE logic OF mux2_1 IS
BEGIN
    Y <= A WHEN SEL = '0' ELSE B;
END ARCHITECTURE;
