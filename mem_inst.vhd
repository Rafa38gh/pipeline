-- MEMÓRIA DE INSTRUÇÕES (ROM) --
-- Aceita palavras de 16bits, com suporte máximo para 16 instruções --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mem_inst IS
	PORT(
			ADDR		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);		-- Endereço da instrução, incrementado em +1
			INST		:		OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE LOGIC OF mem_inst IS
	TYPE rom_type IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	
   SIGNAL rom : rom_type := (			-- Instruções pré-carregadas na memória
        0  => "0010001001000000",  
        1  => "0000000000000000",  
        2  => "0000000000000000",
        3  => "0000000000000000",
        4  => "0000000000000000",
        5  => "0000000000000000",
        6  => "0000000000000000",
        7  => "0000000000000000",
        8  => "0000000000000000",
        9  => "0000000000000000",
        10 => "0000000000000000",
        11 => "0000000000000000",
        12 => "0000000000000000",
        13 => "0000000000000000",
        14 => "0000000000000000",
        15 => "0000000000000000"
   );
	
	BEGIN
		INST <= rom(to_integer(unsigned(ADDR)));

END ARCHITECTURE;