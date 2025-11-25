-- ULA 4 bits --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.full_adder_package.all;

ENTITY ULA_sim IS
    PORT(
        X    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- primeira entrada
        Y    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- segunda entrada
        S    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- soma
        COUT : OUT STD_LOGIC                    -- carry final
    );
END ENTITY;

ARCHITECTURE logic OF ULA_sim IS

    SIGNAL C : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

    STAGE0: full_adder PORT MAP('0', X(0), Y(0), C(0), S(0));
    STAGE1: full_adder PORT MAP(C(0), X(1), Y(1), C(1), S(1));
    STAGE2: full_adder PORT MAP(C(1), X(2), Y(2), C(2), S(2));
    STAGE3: full_adder PORT MAP(C(2), X(3), Y(3), COUT, S(3));

END logic;
