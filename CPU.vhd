-- CPU FINAL NA PLACA --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.pipeline_package.all;

ENTITY CPU IS
	PORT(
			SW				:	IN STD_LOGIC_VECTOR(17 DOWNTO 0);
			Clock_50		:	IN STD_LOGIC;
			
			LEDR			:	OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
			HEX0			:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX1			:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX2			:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX3			:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX4			:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX5			:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX6			:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX7			:	OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END ENTITY;

ARCHITECTURE LOGIC OF CPU IS
	SIGNAL RESET		:	STD_LOGIC;
	SIGNAL ENABLE		:	STD_LOGIC;
	
	SIGNAL RS, RT		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL RS1, RS2, RS3, RS4	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL RT1, RT2, RT3, RT4	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	CONSTANT max: INTEGER :=50000000;
	CONSTANT half:INTEGER := max/2;
	signal clockticks: INTEGER RANGE 0 TO max;
	signal CLK: STD_LOGIC;
	
	BEGIN
		
		PIPE		:		pipeline PORT MAP(CLK, RESET, ENABLE, RS, RT);
		
		ENABLE <= SW(17);
		RESET <= SW(16);
		
		LEDR <= SW;
		
		RS1 <= RS(3 DOWNTO 0);
		RS2 <= RS(7 DOWNTO 4);
		RS3 <= RS(11 DOWNTO 8);
		RS4 <= RS(15 DOWNTO 12);
		
		RT1 <= RT(3 DOWNTO 0);
		RT2 <= RT(7 DOWNTO 4);
		RT3 <= RT(11 DOWNTO 8);
		RT4 <= RT(15 DOWNTO 12);
		
		WITH RT1 SELECT
			HEX0 <= 	"0000001" when "0000",
						"1001111" when "0001",
						"0010010" when "0010",
						"0000110" when "0011",
						"1001100" when "0100",
						"0100100" when "0101",
						"0100000" when "0110",
						"0001111" when "0111",
						"0000000" when "1000",
						"0000100" when "1001",
						"0001000" when "1010",
						"1100000" when "1011",
						"0110001" when "1100",
						"1000010" when "1101",
						"0110000" when "1110",
						"0111000" when "1111",
						"1111111" when others;
		
		WITH RT2 SELECT
			HEX1 <= 	"0000001" when "0000",
						"1001111" when "0001",
						"0010010" when "0010",
						"0000110" when "0011",
						"1001100" when "0100",
						"0100100" when "0101",
						"0100000" when "0110",
						"0001111" when "0111",
						"0000000" when "1000",
						"0000100" when "1001",
						"0001000" when "1010",
						"1100000" when "1011",
						"0110001" when "1100",
						"1000010" when "1101",
						"0110000" when "1110",
						"0111000" when "1111",
						"1111111" when others;
		
		WITH RT3 SELECT
			HEX2 <= 	"0000001" when "0000",
						"1001111" when "0001",
						"0010010" when "0010",
						"0000110" when "0011",
						"1001100" when "0100",
						"0100100" when "0101",
						"0100000" when "0110",
						"0001111" when "0111",
						"0000000" when "1000",
						"0000100" when "1001",
						"0001000" when "1010",
						"1100000" when "1011",
						"0110001" when "1100",
						"1000010" when "1101",
						"0110000" when "1110",
						"0111000" when "1111",
						"1111111" when others;
						
		WITH RT4 SELECT
			HEX3 <= 	"0000001" when "0000",
						"1001111" when "0001",
						"0010010" when "0010",
						"0000110" when "0011",
						"1001100" when "0100",
						"0100100" when "0101",
						"0100000" when "0110",
						"0001111" when "0111",
						"0000000" when "1000",
						"0000100" when "1001",
						"0001000" when "1010",
						"1100000" when "1011",
						"0110001" when "1100",
						"1000010" when "1101",
						"0110000" when "1110",
						"0111000" when "1111",
						"1111111" when others;
		
		WITH RS1 SELECT
			HEX4 <= 	"0000001" when "0000",
						"1001111" when "0001",
						"0010010" when "0010",
						"0000110" when "0011",
						"1001100" when "0100",
						"0100100" when "0101",
						"0100000" when "0110",
						"0001111" when "0111",
						"0000000" when "1000",
						"0000100" when "1001",
						"0001000" when "1010",
						"1100000" when "1011",
						"0110001" when "1100",
						"1000010" when "1101",
						"0110000" when "1110",
						"0111000" when "1111",
						"1111111" when others;
		
		WITH RS2 SELECT
			HEX5 <= 	"0000001" when "0000",
						"1001111" when "0001",
						"0010010" when "0010",
						"0000110" when "0011",
						"1001100" when "0100",
						"0100100" when "0101",
						"0100000" when "0110",
						"0001111" when "0111",
						"0000000" when "1000",
						"0000100" when "1001",
						"0001000" when "1010",
						"1100000" when "1011",
						"0110001" when "1100",
						"1000010" when "1101",
						"0110000" when "1110",
						"0111000" when "1111",
						"1111111" when others;
		
		WITH RS3 SELECT
			HEX6 <= 	"0000001" when "0000",
						"1001111" when "0001",
						"0010010" when "0010",
						"0000110" when "0011",
						"1001100" when "0100",
						"0100100" when "0101",
						"0100000" when "0110",
						"0001111" when "0111",
						"0000000" when "1000",
						"0000100" when "1001",
						"0001000" when "1010",
						"1100000" when "1011",
						"0110001" when "1100",
						"1000010" when "1101",
						"0110000" when "1110",
						"0111000" when "1111",
						"1111111" when others;
		
		WITH RS4 SELECT
			HEX7 <= 	"0000001" when "0000",
						"1001111" when "0001",
						"0010010" when "0010",
						"0000110" when "0011",
						"1001100" when "0100",
						"0100100" when "0101",
						"0100000" when "0110",
						"0001111" when "0111",
						"0000000" when "1000",
						"0000100" when "1001",
						"0001000" when "1010",
						"1100000" when "1011",
						"0110001" when "1100",
						"1000010" when "1101",
						"0110000" when "1110",
						"0111000" when "1111",
						"1111111" when others;
		
						
						
		ClockDivide: PROCESS
			BEGIN
			WAIT UNTIL CLOCK_50' EVENT and CLOCK_50 = '1';
			IF clockticks <max THEN
				clockticks <= clockticks +1;
			ELSE
				clockticks <= 0;
			END IF;
			IF clockticks <half THEN
				CLK <= '0';
			ELSE
				CLK <= '1';
			END IF;
			END PROCESS;

END LOGIC;