LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.pc_package.all;
USE work.mem_inst_package.all;
USE work.ULA_sim_package.all;
USE work.pipe_reg_package.all;
USE work.reg_file_package.all;
USE work.UC_package.all;
USE work.mux2_1_package.all;
USE work.ULA16_package.all;
USE work.data_mem_package.all;

ENTITY pipeline IS
	PORT(
			CLK			:		IN STD_LOGIC;
			RESET			:		IN STD_LOGIC;
			
			-- Temporários --
			WR_ADDR		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			REG_WR		:		IN STD_LOGIC;
			WR_DATA		:		IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			IFIDREG_OUT	:		OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE LOGIC OF pipeline IS

-- === SINAIS === --
	
	-- ==== IF ==== --
		-- PC --
		SIGNAL PC_OUT		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		-- ULA DO PC --
		SIGNAL ULA_PC_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
		SIGNAL ULA_INC		:	STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";		--	Incremento de PC <= PC + 1
		
		-- MEMÓRIAS --
		SIGNAL MEM_INST_OUT		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		-- IF/ID --
		SIGNAL IFID_STALL	:	STD_LOGIC := '0';
		SIGNAL IFID_FLUSH	:	STD_LOGIC := '0';
		SIGNAL IFID_IN		:	STD_LOGIC_VECTOR(19 DOWNTO 0);					-- Registrador IF/ID possui 20 bits de dados
		SIGNAL IFID_OUT	:	STD_LOGIC_VECTOR(19 DOWNTO 0);
	
	-- ==== ID ==== --
		-- BANCO DE REGISTRADORES --
		SIGNAL RS_OUT		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
		SIGNAL RT_OUT		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		-- UC --
		SIGNAL REGDST		:	STD_LOGIC;
		SIGNAL REGWRITE	:	STD_LOGIC;
		SIGNAL MEMREAD		:	STD_LOGIC;
		SIGNAL MEMWRITE	:	STD_LOGIC;
		SIGNAL MEMTOREG	:	STD_LOGIC;
		SIGNAL BRANCH		:	STD_LOGIC;
		SIGNAL JUMP			:	STD_LOGIC;
		SIGNAL ALUSRC		:	STD_LOGIC;
		SIGNAL ALUOP		:	STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		-- ID/EX --
		SIGNAL IDEX_STALL	:	STD_LOGIC := '0';
		SIGNAL IDEX_FLUSH	:	STD_LOGIC := '0';
		SIGNAL IDEX_IN		:	STD_LOGIC_VECTOR(58 DOWNTO 0);					-- ID/EX possui 59 bits de dados
		SIGNAL IDEX_OUT	:	STD_LOGIC_VECTOR(58 DOWNTO 0);
		
		-- MUX DA ULA --
		SIGNAL MUX_Y_OUT	:	STD_LOGIC_VECTOR(15 DOWNTO 0);					-- Saída do MUX determina entrada Y da ULA
		SIGNAL OFFSET5		:	STD_LOGIC_VECTOR(4 DOWNTO 0);						-- Offset para extensão de sinal
		SIGNAL OFFSET_EXT	:	STD_LOGIC_VECTOR(15 DOWNTO 0);					-- Offset extendido
		
		-- SINAIS DA ULA --
		SIGNAL CIN			:	STD_LOGIC;
		SIGNAL ULA_OUT		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		-- MUX REGISTRADOR DESTINO --
		SIGNAL REGDST_EX	:	STD_LOGIC;
		SIGNAL RT_EX		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
		SIGNAL RD_EX		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
		SIGNAL DST_REG_EX	:	STD_LOGIC_VECTOR(3 DOWNTO 0);						-- Passa o registrador destino (RT ou RD) para o próximo estágio do pipeline
		
	-- ==== MEM ==== --
		-- EX/MEM --
		SIGNAL EXMEM_STALL	:	STD_LOGIC := '0';
		SIGNAL EXMEM_FLUSH	:	STD_LOGIC := '0';
		SIGNAL EXMEM_IN		:	STD_LOGIC_VECTOR(39 DOWNTO 0);				-- EX/MEM possui 40 bits de dados
		SIGNAL EXMEM_OUT		:	STD_LOGIC_VECTOR(39 DOWNTO 0);
		
		-- MEMÓRIA DE DADOS --
		SIGNAL MEM_OUT			:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	
	-- OVERFLOW --
	SIGNAL OVERFLOW	:	STD_LOGIC;
	
	BEGIN
		-- ULA PC --
		ULA_PC			:	ULA_sim PORT MAP(PC_OUT, ULA_INC, ULA_PC_OUT, OVERFLOW);
		
		-- PC --
		PC_REG			:	pc PORT MAP(CLK, RESET, ULA_PC_OUT, PC_OUT);
		
		-- MEMÓRIA DE INSTRUÇÕES --
		MEM_INSTRUCAO	:	mem_inst PORT MAP(PC_OUT, MEM_INST_OUT);
		
		-- IF/ID --
		IFID_IN <= ULA_PC_OUT & MEM_INST_OUT;
		
		IFID_REG			:	pipe_reg 
				GENERIC MAP(WIDTH => 20)
				PORT MAP(CLK, IFID_STALL, IFID_FLUSH, IFID_IN, IFID_OUT);
				
		IFIDREG_OUT <= IFID_OUT;
		
		-- REGISTRADORES GERAIS --
		REG_MEM			:	reg_file PORT MAP(CLK, IFID_OUT(12 DOWNTO 9), IFID_OUT(8 DOWNTO 5), WR_ADDR, WR_DATA, REG_WR, RS_OUT, RT_OUT);
		
		-- UC --
		CONTROL			:	UC PORT MAP(IFID_OUT(15 DOWNTO 13), REGDST, REGWRITE, MEMREAD, MEMWRITE, MEMTOREG, BRANCH, JUMP, ALUSRC, ALUOP);
		
		-- ID/EX --
		IDEX_IN <=
			 REGDST                     &  -- bit 58
			 REGWRITE                   &  -- bit 57
			 MEMREAD                    &  -- bit 56
			 MEMWRITE                   &  -- bit 55
			 MEMTOREG                   &  -- bit 54
			 BRANCH                     &  -- bit 53
			 JUMP                       &  -- bit 52
			 ALUSRC                     &  -- bit 51
			 ALUOP                      &  -- bits 50..49
			 IFID_OUT(19 DOWNTO 16)     &  -- PC+1 (bits 48..45)
			 RS_OUT                     &  -- bits 44..29
			 RT_OUT                     &  -- bits 28..13
			 IFID_OUT(12 DOWNTO 9)      &  -- RS (bits 12..9)
			 IFID_OUT(8 DOWNTO 5)       &  -- RT (bits 8..5)
			 IFID_OUT(4 DOWNTO 1)       &  -- RD (bits 4..1)
			 IFID_OUT(0);                  -- FUNCT (bit 0)
		  
		
		IDEX_REG			:	pipe_reg
				GENERIC MAP(WIDTH => 59)
				PORT MAP(CLK, IDEX_STALL, IDEX_FLUSH, IDEX_IN, IDEX_OUT);
				
		-- Extensão de sinal (OFFSET END)
		OFFSET5 <= IDEX_OUT(4 DOWNTO 0);
		OFFSET_EXT <= (15 DOWNTO 5 => '0') & OFFSET5;
				
		-- MUX --
		MUX_Y				:	mux2_1 PORT MAP(IDEX_OUT(28 DOWNTO 13), OFFSET_EXT, ALUSRC, MUX_Y_OUT);		-- Seleciona RT_OUT ou OFFSET com base no ALUSRC
		
		-- ALU CONTROL --
		CIN <=
			'0'	WHEN IDEX_OUT(50 DOWNTO 49) = "00" ELSE
			'1'	WHEN IDEX_OUT(50 DOWNTO 49) = "01" ELSE
			IDEX_OUT(0)	WHEN IDEX_OUT(50 DOWNTO 49) = "10" ELSE
			'0';		-- Default
		
		-- ULA 16BITS --
		ULA_EX	:	ULA16 PORT MAP(CIN, IDEX_OUT(44 DOWNTO 29), MUX_Y_OUT, ULA_OUT, OVERFLOW);
		
		-- REGISTRADOR DESTINO --
		REGDST_EX <= IDEX_OUT(58);
		RT_EX <= IDEX_OUT(8 DOWNTO 5);
		RD_EX <= IDEX_OUT(4 DOWNTO 1);
		
		DST_REG_EX <= RT_EX WHEN REGDST_EX = '0' ELSE RD_EX;
		
		-- EX/MEM --
		EXMEM_IN <=
			 IDEX_OUT(57)                  & -- bit 39 : REGWRITE
			 IDEX_OUT(56)                  & -- bit 38 : MEMREAD
			 IDEX_OUT(55)                  & -- bit 37 : MEMWRITE
			 IDEX_OUT(54)                  & -- bit 36 : MEMTOREG
			 ULA_OUT                       & -- bits 35..20 : resultado da ULA
			 IDEX_OUT(28 DOWNTO 13)        & -- bits 19..4 : RT_VALUE
			 DST_REG_EX;                     -- bits 3..0  : registrador destino
		
		EXMEM_REG		:	pipe_reg
				GENERIC MAP(WIDTH => 40)
				PORT MAP(CLK, EXMEM_STALL, EXMEM_FLUSH, EXMEM_IN, EXMEM_OUT);
		
		-- MEMÓRIA DE DADOS --
		MEM_DADOS: data_mem PORT MAP(CLK, EXMEM_OUT(37), EXMEM_OUT(38), EXMEM_OUT(35 DOWNTO 20), EXMEM_OUT(19 DOWNTO 4), MEM_OUT); 
END ARCHITECTURE;