LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY UC IS
	PORT(
			OPCODE		:	IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			REGDST		:	OUT STD_LOGIC;								-- Quando 0, o destino vem de RT, quando 1 o destino é de RD
			REGWRITE		:	OUT STD_LOGIC;
			MEMREAD		:	OUT STD_LOGIC;
			MEMWRITE		:	OUT STD_LOGIC;
			MEMTOREG		:	OUT STD_LOGIC;
			BRANCH		:	OUT STD_LOGIC;
			JUMP			:	OUT STD_LOGIC;
			ALUSRC		:	OUT STD_LOGIC;
			ALUOP			:	OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE LOGIC OF UC IS
	BEGIN
	
	PROCESS(OPCODE)
	BEGIN
		-- NOP --
		REGDST	<= '0';
		REGWRITE	<= '0';
		MEMREAD	<= '0';
		MEMWRITE	<= '0';
		MEMTOREG	<= '0';
		BRANCH	<= '0';
		JUMP		<= '0';
		ALUSRC	<= '0';
		ALUOP		<= "00";
		
		CASE OPCODE IS
		
			WHEN "001" =>	-- LW
				REGDST	<= '0';
				REGWRITE	<= '1';
				MEMREAD	<= '1';
				MEMTOREG	<= '1';
				ALUSRC	<= '1';
				ALUOP		<= "00";
			
			WHEN "010" =>	-- SW
				REGWRITE	<= '0';
				MEMWRITE	<= '1';
				MEMTOREG	<= '0';
				ALUSRC	<= '1';
				ALUOP		<= "00";
				
			WHEN "011" =>	-- ADD/SUB
				REGDST	<= '1';			-- Escreve o resultado em RD
				REGWRITE	<=	'1';
				ALUSRC	<= '0';
				ALUOP		<= "10";
				
			WHEN "100" =>	-- BEQ
				BRANCH	<= '1';
				ALUSRC	<=	'0';
				ALUOP		<= "01";
				
			WHEN "101" =>	-- JUMP
				JUMP		<= '1';
			
			WHEN OTHERS =>
				NULL;
			
		END CASE;
	END PROCESS;

END ARCHITECTURE;