-- Registrador de pipeline --
-- Tamanho do registrador pode ser alterado ao instanciar --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY pipe_reg IS
		GENERIC(
				WIDTH		:	INTEGER := 16		-- Inicia com tamanho padrão 16
		);
		
		PORT(
				CLK		:	IN STD_LOGIC;
				STALL		:	IN STD_LOGIC;										-- = 1 bloqueia a escrita do registrador
				FLUSH		:	IN STD_LOGIC;										-- = 1 zera o registrador
				DATA_IN	:	IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
				DATA_OUT	:	OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE LOGIC OF pipe_reg IS

	SIGNAL DATA_REG	:	STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0) := (OTHERS => '0');		-- Registrador começa zerado por padrão
	
	BEGIN
		
		PROCESS(CLK, STALL, FLUSH)
		BEGIN
		
			IF rising_edge(CLK) THEN
			
				IF FLUSH = '1' THEN
					DATA_REG <= (OTHERS => '0');
				
				ELSIF STALL = '0' THEN
					DATA_REG <= DATA_IN;
				
				END IF;
			END IF;
		END PROCESS;
		
		DATA_OUT <= DATA_REG;

END ARCHITECTURE;
	