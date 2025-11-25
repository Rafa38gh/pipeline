-- ULA de 16bits --
-- Somador/Subtrator --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.full_adder_package.all;

ENTITY ULA16 IS
	PORT(
			FUNCT		:	IN STD_LOGIC;
			X			:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Y			:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			S			:	OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			COUT		:	OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE LOGIC OF ULA16 IS
	SIGNAL C			:	STD_LOGIC_VECTOR(14 DOWNTO 0);		-- Carries
	SIGNAL TMP		:	STD_LOGIC_VECTOR(15 DOWNTO 0);		-- Complemento de 2
	
	BEGIN
		
		GEN_TMP : FOR i IN 0 TO 15 GENERATE		-- Gera Y complemento de 2
			TMP(i) <= Y(i) XOR FUNCT;
			
		END GENERATE;
		
		STAGE0: full_adder PORT MAP(CIN  => FUNCT, X => X(0), Y => TMP(0), COUT => C(0), S => S(0));
		 
		STAGES: FOR i IN 1 TO 14 GENERATE
			FA: full_adder PORT MAP(C(i-1), X(i), TMP(i), C(i), S(i));
			
		END GENERATE;
		
		STAGE15: full_adder PORT MAP(C(14), X(15), TMP(15), COUT, S(15));

END ARCHITECTURE;