-- Memória de dados --
-- Usa endereços de 16bits --
-- Armazena dados de 16bits --
-- Escrita síncrona, leitura assíncrona --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY data_mem IS
	PORT(
			CLK		:	IN STD_LOGIC;
			MEMWRITE	:	IN STD_LOGIC;
			MEMREAD	:	IN STD_LOGIC;
			ADDR		:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			WR_DATA	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			RD_DATA	:	OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE LOGIC OF data_mem IS

	TYPE mem_type IS ARRAY (0 TO 65535) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL MEM	:	mem_type := (		-- Valores pré-carregados
		0  => x"000A",
      1  => x"000B",
      2  => x"000C",
      3  => x"000D",
      4  => x"000E",
      5  => x"000F",
      6  => x"00AA",
      7  => x"00BB",
      8  => x"00CC",
      9  => x"00DD",
		
		OTHERS => (OTHERS=> '0')
	);
	
	BEGIN
	
		RD_DATA <= MEM(to_integer(unsigned(ADDR))) WHEN MEMREAD = '1'
		ELSE (OTHERS => '0');
		
		PROCESS(CLK, MEMWRITE)
		BEGIN
			IF rising_edge(CLK) THEN
				IF MEMWRITE = '1' THEN
					MEM(to_integer(unsigned(ADDR))) <= WR_DATA;
				END IF;
			END IF;
		
		END PROCESS;

END ARCHITECTURE;
		