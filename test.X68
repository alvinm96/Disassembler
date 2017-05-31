		ORG $7000

*========================================
* code0000 tests
*========================================
		ANDI.B		#10,D0
		ANDI.W		#$1000,D3
		ANDI.L		#$12345678,D7
		ANDI.B		#10,$3000
		ANDI.W		#$1000,$2000
		ANDI.L		#$12345678,$5000

		SUBI.B		#10,D0
		SUBI.W		#$1000,D3
		SUBI.L		#$12345678,D7
		SUBI.B		#10,$3000
		SUBI.W		#$1000,$2000
		SUBI.L		#$12345678,$5000		

		ADDI.B		#10,D0
		ADDI.W		#$1000,D3
		ADDI.L		#$12345678,D7
		ADDI.B		#10,$3000
		ADDI.W		#$1000,$2000
		ADDI.L		#$12345678,$5000

		EORI.B		#10,D0
		EORI.W		#$1000,D3
		EORI.L		#$12345678,D7
		EORI.B		#10,$3000
		EORI.W		#$1000,$2000
		EORI.L		#$12345678,$5000
		
		CMPI.B		#10,D0
		CMPI.W		#$1000,D3
		CMPI.L		#$12345678,D7
		CMPI.B		#10,$3000
		CMPI.W		#$1000,$2000
		CMPI.L		#$12345678,$5000				

*========================================
* code0001 tests
*========================================
		MOVE.B		D0,D3
		MOVE.B		D7,D2
		MOVE.B		D3,(A3)
		MOVE.B		(A3),(A4)
		MOVE.B		(A7),D3

*========================================
* code0010 tests
*========================================
		MOVE.L		#$1000,D5
		MOVE.L		#$1111FFFF,(A5)+
		MOVE.L		A3,-(A2)
		MOVE.L		D3,$1000
		MOVE.L		D3,$12345678		

*========================================
* code0011 tests
*========================================
		MOVE.W		#$1000,D5
		MOVE.W		#$ABCD,(A5)+
		MOVE.W		A3,-(A2)
		MOVE.W		D3,$1000
		MOVE.W		D3,$12345678
		MOVEA.W		(A3)+,A0
		MOVEA.W		-(A3),A1
		MOVEA.W		A3,A2
		MOVEA.W		D4,A3
		MOVEA.W		$1000,A4
		MOVEA.W		#$1000,A5
		MOVEA.W		$1234,A6
		MOVEA.W		#$1234,A7
		MOVEA.L		$1000,A4
		MOVEA.L		#$1000,A5
		MOVEA.L		$12345678,A6
		MOVEA.L		#$12345678,A7	

*========================================
* code0100 tests
*========================================
		RTS
		JSR			(A5)
		JSR			$1000
		JSR			$12345678
		LEA			(A5),A2
		LEA			$1000,A7
		LEA			$87654321,A0
		CLR.B		D0
		CLR.B		(A0)
		CLR.B		(A5)+
		CLR.B		-(A7)
		CLR.W		$1000
		CLR.L		$87654321

*========================================
* code0101 tests
*========================================
		SUBQ.B		#1,D0
		SUBQ.W		#4,A4
		SUBQ.L		#7,$10000000
		SUBQ.B		#8,D4

*========================================
* code0110 tests
*========================================
		BHI			BRANCH_TEST
		BLS			BRANCH_TEST
		BCC			BRANCH_TEST
		BCS			BRANCH_TEST
		BNE			BRANCH_TEST
		BEQ			BRANCH_TEST
		BVC			BRANCH_TEST
		BVS			BRANCH_TEST
		BPL			BRANCH_TEST
		BMI			BRANCH_TEST
		BGE			BRANCH_TEST
		BLT			BRANCH_TEST
		BGT			BRANCH_TEST
		BLE			BRANCH_TEST

BRANCH_TEST

*========================================
* code0111 tests
*========================================
		MOVEQ.L		#$10,D0
		MOVEQ.L		#$AB,D7
		MOVEQ.L		#7,D3
		MOVEQ.L		#8,D4

*========================================
* code1000 tests
*========================================
		OR.B		D0,D7
		OR.B		(A0),D7
		OR.B		(A4)+,D7
		OR.W		$1000,D7
		OR.L		$12345678,D7
		OR.B		D7,(A0)
		OR.B		D6,(A2)+
		OR.W		D3,$1000
		OR.L		D5,$12345678
		DIVU.W		D0,D1
		DIVU.W		$1234,D3
		DIVU.W		-(A0),D7

*========================================
* code1001 tests
*========================================
		SUB.B		(A2)+,D5
		SUB.B		D0,(A2)+
		SUB.W		A3,D3
		SUB.W		D3,A3
		SUB.L		$1200,D3
		SUB.L		$12345678,D7
		SUBA.W		#2,A3
		SUBA.L		$1234FEDC,A2

*========================================
* code1011 tests
*========================================
		CMP.B		D0,D1
		CMP.W		A2,D4
		CMP.L		(A3),D7
		CMP.W		$1234,D3
		CMP.L		$12345678,D7
		CMP.L		#$1234,D0
		CMPA.W		(A2),A4
		CMPA.W		D0,A0
		CMPA.L		$87654321,A7
		CMPA.L		(A2)+,A3
		EOR.B		D0,D1
		EOR.W		D4,D6
		EOR.L		D6,(A0)
		EOR.W		D3,-(A7)
		EOR.W		D0,$6543
		EOR.L		D6,$12345678

*========================================
* code1100 tests
*========================================
		AND.B		D6,D1
		AND.W		(A7),D5
		AND.L		(A7)+,D5
		AND.B		-(A1),D5
		AND.W		$1000,D7
		AND.L		$12345678,D0
		AND.B		#$01,D6
		MULS.W		D5,D2
		MULS.W		(A5),D3
		MULS.W		(A5)+,D3
		MULS.W		-(A5),D3

*========================================
* code1101 tests
*========================================
		ADD.B		$1234,D0
		ADD.W		$1234,D0
		ADD.L		$12345678,D0
		ADD.B		D5,D3
		ADD.W		A2,D6
		ADD.B		(A2),D6
		ADD.W		(A2)+,D6
		ADD.L		-(A2),D6
		ADDA.W		A2,A3
		ADDA.W		D0,A7
		ADDA.L		$12345678,A2
		ADDA.W		$1234,A7

*========================================
* code1110 tests
*========================================
		ROL.B		#4,D5
		ROR.B		#4,D5
		ROL.W		D0,D1
		ROR.W		D1,D0
		ROL.L		#8,D0
		ROR.L		#8,D2
		ROL.W		$1234
		ROR.W		$1234
		ASL.B		#4,D5
		ASR.B		#4,D5
		ASL.W		D0,D1
		ASR.W		D1,D0
		ASL.L		#8,D0
		ASR.L		#8,D2
		ASL.W		$1234
		ASR.W		$1234
		LSL.B		#4,D5
		LSR.B		#4,D5
		LSL.W		D0,D1
		LSR.W		D1,D0
		LSL.L		#8,D0
		LSR.L		#8,D2
		LSL.W		$1234
		LSR.W		$1234			



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
