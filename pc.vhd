-- PC --
-- Para avançar para cada instrução é necessário somar PC <= PC + 1 --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY pc IS
	PORT(
			CLK		:	IN STD_LOGIC;
			RESET		:	IN STD_LOGIC;
			ENABLE	:	IN STD_LOGIC;
			PC_IN		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			PC_OUT	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE LOGIC OF pc IS
	SIGNAL PC_REG	:	STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');		-- Inicia PC como 0000
	
	BEGIN
		
		PC_OUT <= PC_REG;
		
		PROCESS(CLK, RESET)
		BEGIN
			IF RESET = '1' THEN
				PC_REG <= "0000";
				
			ELSIF rising_edge(CLK) THEN
				IF ENABLE = '1' THEN
					PC_REG <= PC_IN;
				
				END IF;
			
			END IF;
		END PROCESS;
		
END ARCHITECTURE;