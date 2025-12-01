LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY reg_file IS
	PORT(
			CLK		:	IN STD_LOGIC;
			RS_IN		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			RT_IN		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			WR_ADDR	:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			WR_DATA	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			REG_WR	:	IN STD_LOGIC;
			
			R1_OUT	:	OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			R2_OUT	:	OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			RS_OUT	:	OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			RT_OUT	:	OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE LOGIC OF reg_file IS
	
	TYPE reg_array IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(15 DOWNTO 0);		-- 16 registradores de 16 bits cada
	SIGNAL reg	:	reg_array := ( 1 => "0000000000000000", 2 => "0000000000000111", OTHERS => (OTHERS => '0'));						-- Inicia todos os registradores como 0
	
	BEGIN
		R1_OUT <= reg(1);
		R2_OUT <= reg(2);
		
		RS_OUT <= reg(to_integer(unsigned(RS_IN)));
		RT_OUT <= reg(to_integer(unsigned(RT_IN)));
		
		PROCESS(CLK, REG_WR)
		BEGIN
			IF rising_edge(CLK) THEN
			
				IF REG_WR = '1' THEN
					reg(to_integer(unsigned(WR_ADDR))) <= WR_DATA;					-- Escreve o conteúdo de WR_DATA no registrador especificado por WR_ADDR
				
				END IF;
			END IF;
		END PROCESS;
	
END ARCHITECTURE;
		