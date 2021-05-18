
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _string=R4
	.DEF _string_msb=R5
	.DEF _sub=R6
	.DEF _sub_msb=R7
	.DEF _speed=R8
	.DEF _speed_msb=R9
	.DEF _time=R10
	.DEF _time_msb=R11
	.DEF _Weigt=R12
	.DEF _Weigt_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  LOW(_0x20003),HIGH(_0x20003),LOW(_0x20004),HIGH(_0x20004)

_0x20005:
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46
_0x20000:
	.DB  0x20,0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65
	.DB  0x20,0x74,0x6F,0x20,0x74,0x68,0x65,0x20
	.DB  0x6F,0x6E,0x6C,0x69,0x6E,0x65,0x20,0x6C
	.DB  0x61,0x62,0x20,0x63,0x6C,0x61,0x73,0x73
	.DB  0x65,0x73,0x20,0x64,0x75,0x65,0x20,0x74
	.DB  0x6F,0x20,0x43,0x6F,0x72,0x6F,0x6E,0x61
	.DB  0x20,0x64,0x69,0x73,0x65,0x61,0x73,0x65
	.DB  0x2E,0x0,0x30,0x30,0x30,0x30,0x30,0x30
	.DB  0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30
	.DB  0x30,0x30,0x0,0x48,0x61,0x64,0x69,0x73
	.DB  0x20,0x41,0x68,0x6D,0x61,0x64,0x69,0x61
	.DB  0x6E,0xA,0x39,0x36,0x32,0x32,0x36,0x31
	.DB  0x33,0x0,0x53,0x70,0x65,0x65,0x64,0x3A
	.DB  0x3F,0x3F,0x28,0x30,0x2D,0x35,0x30,0x72
	.DB  0x29,0xA,0x0,0x45,0x45,0x0,0x54,0x69
	.DB  0x6D,0x65,0x3A,0x3F,0x3F,0x28,0x30,0x2D
	.DB  0x39,0x39,0x73,0x29,0xA,0x0,0x57,0x65
	.DB  0x69,0x67,0x74,0x3A,0x3F,0x3F,0x28,0x30
	.DB  0x2D,0x39,0x39,0x46,0x29,0xA,0x0,0x54
	.DB  0x65,0x6D,0x70,0x3A,0x3F,0x3F,0x28,0x32
	.DB  0x30,0x2D,0x38,0x30,0x43,0x29,0xA,0x0
	.DB  0x54,0x48,0x45,0x20,0x45,0x4E,0x44,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x3A
	.DW  _0x20003
	.DW  _0x20000*2

	.DW  0x11
	.DW  _0x20004
	.DW  _0x20000*2+58

	.DW  0x10
	.DW  _data_key
	.DW  _0x20005*2

	.DW  0x17
	.DW  _0x20012
	.DW  _0x20000*2+75

	.DW  0x11
	.DW  _0x20031
	.DW  _0x20000*2+98

	.DW  0x03
	.DW  _0x20031+17
	.DW  _0x20000*2+115

	.DW  0x10
	.DW  _0x20031+20
	.DW  _0x20000*2+118

	.DW  0x03
	.DW  _0x20031+36
	.DW  _0x20000*2+115

	.DW  0x11
	.DW  _0x20031+39
	.DW  _0x20000*2+134

	.DW  0x03
	.DW  _0x20031+56
	.DW  _0x20000*2+115

	.DW  0x11
	.DW  _0x20031+59
	.DW  _0x20000*2+151

	.DW  0x03
	.DW  _0x20031+76
	.DW  _0x20000*2+115

	.DW  0x08
	.DW  _0x20031+79
	.DW  _0x20000*2+168

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <header.h>
;void main(void)
; 0000 0003 {

	.CSEG
_main:
; .FSTART _main
; 0000 0004 
; 0000 0005 all_init();
	RCALL _all_init
; 0000 0006 #asm("sei")
	sei
; 0000 0007 
; 0000 0008 
; 0000 0009 one();
	RCALL _one
; 0000 000A two();
	RCALL _two
; 0000 000B three();
	RCALL _three
; 0000 000C four();
	RCALL _four
; 0000 000D five();
	RCALL _five
; 0000 000E 
; 0000 000F 
; 0000 0010 
; 0000 0011 }
_0x3:
	RJMP _0x3
; .FEND
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <string.h>
;#include <delay.h>
;#include <stdlib.h>
;
;
;char* string=" Welcome to the online lab classes due to Corona disease.";

	.DSEG
_0x20003:
	.BYTE 0x3A
;char* sub="0000000000000000";
_0x20004:
	.BYTE 0x11
;char data_key[]={'0','1','2','3',
;                 '4','5','6','7',
;                 '8','9','A','B',
;                 'C','D','E','F'};
;
;int speed,time,Weigt,Temp;
;char i,j,flag,intrupt_flag=0;
;char t;
;
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0001 0015 {

	.CSEG
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 0016 
; 0001 0017     if(intrupt_flag){
	LDS  R30,_intrupt_flag
	CPI  R30,0
	BREQ _0x20006
; 0001 0018     flag=1;
	LDI  R30,LOW(1)
	STS  _flag,R30
; 0001 0019     while(flag)
_0x20007:
	LDS  R30,_flag
	CPI  R30,0
	BREQ _0x20009
; 0001 001A     {
; 0001 001B         for(i=4;i<8;i++)
	LDI  R30,LOW(4)
	STS  _i,R30
_0x2000B:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x2000C
; 0001 001C         {
; 0001 001D             PORTB=0;
	CALL SUBOPT_0x0
; 0001 001E             PORTB=1<<i;
; 0001 001F             for(j=0;j<4;j++)
_0x2000E:
	LDS  R26,_j
	CPI  R26,LOW(0x4)
	BRSH _0x2000F
; 0001 0020             {
; 0001 0021                  if((PINB&(1<<j))==(1<<j))
	CALL SUBOPT_0x1
	BRNE _0x20010
; 0001 0022                  {
; 0001 0023                     lcd_putchar(  data_key[(4*(i-4))+j]  );
	CALL SUBOPT_0x2
; 0001 0024                     flag=0;
; 0001 0025 
; 0001 0026                     break;
	RJMP _0x2000F
; 0001 0027                  }
; 0001 0028 
; 0001 0029              }
_0x20010:
	CALL SUBOPT_0x3
	RJMP _0x2000E
_0x2000F:
; 0001 002A 
; 0001 002B          if(flag==0)
	LDS  R30,_flag
	CPI  R30,0
	BREQ _0x2000C
; 0001 002C          break;
; 0001 002D 
; 0001 002E          }
	CALL SUBOPT_0x4
	RJMP _0x2000B
_0x2000C:
; 0001 002F 
; 0001 0030     }
	RJMP _0x20007
_0x20009:
; 0001 0031     intrupt_flag=0;
	LDI  R30,LOW(0)
	STS  _intrupt_flag,R30
; 0001 0032     delay_ms(1000);
	CALL SUBOPT_0x5
; 0001 0033        }
; 0001 0034 }
_0x20006:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void one()
; 0001 0037 {
_one:
; .FSTART _one
; 0001 0038  lcd_puts("Hadis Ahmadian\n9622613" );
	__POINTW2MN _0x20012,0
	CALL _lcd_puts
; 0001 0039  delay_ms(1000);
	RJMP _0x20A0003
; 0001 003A  lcd_clear();
; 0001 003B }
; .FEND

	.DSEG
_0x20012:
	.BYTE 0x17
;
;
;void two()
; 0001 003F {

	.CSEG
_two:
; .FSTART _two
; 0001 0040  for(i=0;i<=strlen(string);i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x20014:
	MOVW R26,R4
	CALL _strlen
	LDS  R26,_i
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x20015
; 0001 0041     {
; 0001 0042        delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0001 0043        lcd_clear();
	RCALL _lcd_clear
; 0001 0044        strncpy(sub,string+i,16);
	ST   -Y,R7
	ST   -Y,R6
	LDS  R30,_i
	LDI  R31,0
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	CALL _strncpy
; 0001 0045        lcd_puts(sub);
	MOVW R26,R6
	CALL _lcd_puts
; 0001 0046     }
	CALL SUBOPT_0x4
	RJMP _0x20014
_0x20015:
; 0001 0047 
; 0001 0048  lcd_clear();
	RJMP _0x20A0002
; 0001 0049 }
; .FEND
;
;
;
;void three(void)
; 0001 004E {
_three:
; .FSTART _three
; 0001 004F     flag=1;
	LDI  R30,LOW(1)
	STS  _flag,R30
; 0001 0050     while(flag)
_0x20016:
	LDS  R30,_flag
	CPI  R30,0
	BREQ _0x20018
; 0001 0051     {
; 0001 0052         for(i=4;i<8;i++)
	LDI  R30,LOW(4)
	STS  _i,R30
_0x2001A:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x2001B
; 0001 0053         {
; 0001 0054             PORTB=0;
	CALL SUBOPT_0x0
; 0001 0055             PORTB=1<<i;
; 0001 0056             for(j=0;j<4;j++)
_0x2001D:
	LDS  R26,_j
	CPI  R26,LOW(0x4)
	BRSH _0x2001E
; 0001 0057             {
; 0001 0058                  if((PINB&(1<<j))==(1<<j))
	CALL SUBOPT_0x1
	BRNE _0x2001F
; 0001 0059                  {
; 0001 005A                     lcd_putchar(  data_key[(4*(i-4))+j]  );
	CALL SUBOPT_0x2
; 0001 005B                     flag=0;
; 0001 005C                     break;
	RJMP _0x2001E
; 0001 005D                  }
; 0001 005E 
; 0001 005F              }
_0x2001F:
	CALL SUBOPT_0x3
	RJMP _0x2001D
_0x2001E:
; 0001 0060 
; 0001 0061          if(flag==0)
	LDS  R30,_flag
	CPI  R30,0
	BREQ _0x2001B
; 0001 0062          break;
; 0001 0063 
; 0001 0064          }
	CALL SUBOPT_0x4
	RJMP _0x2001A
_0x2001B:
; 0001 0065 
; 0001 0066     }
	RJMP _0x20016
_0x20018:
; 0001 0067 
; 0001 0068     delay_ms(1000);
_0x20A0003:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0001 0069     lcd_clear();
_0x20A0002:
	RCALL _lcd_clear
; 0001 006A 
; 0001 006B }
	RET
; .FEND
;
;
;char key_press()
; 0001 006F {
_key_press:
; .FSTART _key_press
; 0001 0070      while(1)
_0x20021:
; 0001 0071     {
; 0001 0072         for(i=4;i<8;i++)
	LDI  R30,LOW(4)
	STS  _i,R30
_0x20025:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x20026
; 0001 0073         {
; 0001 0074             PORTB=0;
	CALL SUBOPT_0x0
; 0001 0075             PORTB=1<<i;
; 0001 0076             for(j=0;j<4;j++)
_0x20028:
	LDS  R26,_j
	CPI  R26,LOW(0x4)
	BRSH _0x20029
; 0001 0077             {
; 0001 0078                 if((PINB&(1<<j))==(1<<j))
	CALL SUBOPT_0x1
	BRNE _0x2002A
; 0001 0079                 {
; 0001 007A                     lcd_putchar(  data_key[(4*(i-4))+j]  );
	CALL SUBOPT_0x6
	LD   R26,Z
	RCALL _lcd_putchar
; 0001 007B                     return(  data_key[(4*(i-4))+j]  );
	CALL SUBOPT_0x6
	LD   R30,Z
	RET
; 0001 007C                 }
; 0001 007D 
; 0001 007E             }
_0x2002A:
	CALL SUBOPT_0x3
	RJMP _0x20028
_0x20029:
; 0001 007F 
; 0001 0080         }
	CALL SUBOPT_0x4
	RJMP _0x20025
_0x20026:
; 0001 0081 
; 0001 0082     }
	RJMP _0x20021
; 0001 0083 
; 0001 0084 }
; .FEND
;
;
;void four()
; 0001 0088 {
_four:
; .FSTART _four
; 0001 0089  intrupt_flag=1;
	LDI  R30,LOW(1)
	STS  _intrupt_flag,R30
; 0001 008A  PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0001 008B  while(intrupt_flag);
_0x2002B:
	LDS  R30,_intrupt_flag
	CPI  R30,0
	BRNE _0x2002B
; 0001 008C }
	RET
; .FEND
;
;
;void five(void)
; 0001 0090 {
_five:
; .FSTART _five
; 0001 0091 lcd_clear();
	RCALL _lcd_clear
; 0001 0092 
; 0001 0093 flag=1;
	LDI  R30,LOW(1)
	STS  _flag,R30
; 0001 0094 
; 0001 0095 while(flag){
_0x2002E:
	LDS  R30,_flag
	CPI  R30,0
	BREQ _0x20030
; 0001 0096 
; 0001 0097     lcd_clear();
	RCALL _lcd_clear
; 0001 0098     lcd_puts("Speed:??(0-50r)\n");
	__POINTW2MN _0x20031,0
	RCALL _lcd_puts
; 0001 0099     speed=0;
	CLR  R8
	CLR  R9
; 0001 009A     t=key_press();
	CALL SUBOPT_0x7
; 0001 009B 
; 0001 009C     while(t!='F')
_0x20032:
	LDS  R26,_t
	CPI  R26,LOW(0x46)
	BREQ _0x20034
; 0001 009D     {
; 0001 009E         speed=speed*10+(t - '0');
	MOVW R30,R8
	CALL SUBOPT_0x8
	MOVW R8,R30
; 0001 009F         delay_ms(1000);
	CALL SUBOPT_0x5
; 0001 00A0         t=key_press();
	CALL SUBOPT_0x7
; 0001 00A1     }
	RJMP _0x20032
_0x20034:
; 0001 00A2 
; 0001 00A3     if(speed<0||speed>50)
	CLR  R0
	CP   R8,R0
	CPC  R9,R0
	BRLT _0x20036
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x20035
_0x20036:
; 0001 00A4     {
; 0001 00A5         lcd_clear();
	RCALL _lcd_clear
; 0001 00A6         lcd_puts("EE");
	__POINTW2MN _0x20031,17
	CALL SUBOPT_0x9
; 0001 00A7         delay_ms(1000);
; 0001 00A8     }
; 0001 00A9 
; 0001 00AA     else
	RJMP _0x20038
_0x20035:
; 0001 00AB     {
; 0001 00AC         flag=0;
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0001 00AD     }
_0x20038:
; 0001 00AE 
; 0001 00AF }
	RJMP _0x2002E
_0x20030:
; 0001 00B0 
; 0001 00B1 //****************************
; 0001 00B2 
; 0001 00B3 delay_ms(1000);
	CALL SUBOPT_0x5
; 0001 00B4 flag=1;
	LDI  R30,LOW(1)
	STS  _flag,R30
; 0001 00B5 while(flag){
_0x20039:
	LDS  R30,_flag
	CPI  R30,0
	BREQ _0x2003B
; 0001 00B6     lcd_clear();
	RCALL _lcd_clear
; 0001 00B7     lcd_puts("Time:??(0-99s)\n");
	__POINTW2MN _0x20031,20
	RCALL _lcd_puts
; 0001 00B8     time=0;
	CLR  R10
	CLR  R11
; 0001 00B9     t=key_press();
	CALL SUBOPT_0x7
; 0001 00BA 
; 0001 00BB     while(t!='F')
_0x2003C:
	LDS  R26,_t
	CPI  R26,LOW(0x46)
	BREQ _0x2003E
; 0001 00BC     {
; 0001 00BD         time=time*10+((int)t-48);
	MOVW R30,R10
	CALL SUBOPT_0x8
	MOVW R10,R30
; 0001 00BE         delay_ms(1000);
	CALL SUBOPT_0x5
; 0001 00BF         t=key_press();
	CALL SUBOPT_0x7
; 0001 00C0     }
	RJMP _0x2003C
_0x2003E:
; 0001 00C1 
; 0001 00C2     if(time<0||time>99)
	CLR  R0
	CP   R10,R0
	CPC  R11,R0
	BRLT _0x20040
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x2003F
_0x20040:
; 0001 00C3     {
; 0001 00C4         lcd_clear();
	RCALL _lcd_clear
; 0001 00C5         lcd_puts("EE");
	__POINTW2MN _0x20031,36
	CALL SUBOPT_0x9
; 0001 00C6         delay_ms(1000);
; 0001 00C7     }
; 0001 00C8 
; 0001 00C9     else
	RJMP _0x20042
_0x2003F:
; 0001 00CA     {
; 0001 00CB         flag=0;
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0001 00CC     }
_0x20042:
; 0001 00CD 
; 0001 00CE }
	RJMP _0x20039
_0x2003B:
; 0001 00CF 
; 0001 00D0 //****************************
; 0001 00D1 
; 0001 00D2 delay_ms(1000);
	CALL SUBOPT_0x5
; 0001 00D3 flag=1;
	LDI  R30,LOW(1)
	STS  _flag,R30
; 0001 00D4 
; 0001 00D5 while(flag){
_0x20043:
	LDS  R30,_flag
	CPI  R30,0
	BREQ _0x20045
; 0001 00D6     lcd_clear();
	RCALL _lcd_clear
; 0001 00D7     lcd_puts("Weigt:??(0-99F)\n");
	__POINTW2MN _0x20031,39
	RCALL _lcd_puts
; 0001 00D8     Weigt=0;
	CLR  R12
	CLR  R13
; 0001 00D9     t=key_press();
	CALL SUBOPT_0x7
; 0001 00DA 
; 0001 00DB     while(t!='F')
_0x20046:
	LDS  R26,_t
	CPI  R26,LOW(0x46)
	BREQ _0x20048
; 0001 00DC     {
; 0001 00DD         Weigt=Weigt*10+((int)t-48);
	MOVW R30,R12
	CALL SUBOPT_0x8
	MOVW R12,R30
; 0001 00DE         delay_ms(1000);
	CALL SUBOPT_0x5
; 0001 00DF         t=key_press();
	CALL SUBOPT_0x7
; 0001 00E0     }
	RJMP _0x20046
_0x20048:
; 0001 00E1 
; 0001 00E2     if(Weigt<0||Weigt>99)
	CLR  R0
	CP   R12,R0
	CPC  R13,R0
	BRLT _0x2004A
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x20049
_0x2004A:
; 0001 00E3     {
; 0001 00E4         lcd_clear();
	RCALL _lcd_clear
; 0001 00E5         lcd_puts("EE");
	__POINTW2MN _0x20031,56
	CALL SUBOPT_0x9
; 0001 00E6         delay_ms(1000);
; 0001 00E7     }
; 0001 00E8 
; 0001 00E9     else
	RJMP _0x2004C
_0x20049:
; 0001 00EA     {
; 0001 00EB         flag=0;
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0001 00EC     }
_0x2004C:
; 0001 00ED 
; 0001 00EE }
	RJMP _0x20043
_0x20045:
; 0001 00EF 
; 0001 00F0 //****************************
; 0001 00F1 
; 0001 00F2 delay_ms(1000);
	CALL SUBOPT_0x5
; 0001 00F3 flag=1;
	LDI  R30,LOW(1)
	STS  _flag,R30
; 0001 00F4 
; 0001 00F5 while(flag){
_0x2004D:
	LDS  R30,_flag
	CPI  R30,0
	BREQ _0x2004F
; 0001 00F6     lcd_clear();
	RCALL _lcd_clear
; 0001 00F7     lcd_puts("Temp:??(20-80C)\n");
	__POINTW2MN _0x20031,59
	RCALL _lcd_puts
; 0001 00F8     Temp=0;
	LDI  R30,LOW(0)
	STS  _Temp,R30
	STS  _Temp+1,R30
; 0001 00F9     t=key_press();
	CALL SUBOPT_0x7
; 0001 00FA 
; 0001 00FB     while(t!='F')
_0x20050:
	LDS  R26,_t
	CPI  R26,LOW(0x46)
	BREQ _0x20052
; 0001 00FC     {
; 0001 00FD         Temp=Temp*10+((int)t-48);
	LDS  R30,_Temp
	LDS  R31,_Temp+1
	CALL SUBOPT_0x8
	STS  _Temp,R30
	STS  _Temp+1,R31
; 0001 00FE         delay_ms(1000);
	CALL SUBOPT_0x5
; 0001 00FF         t=key_press();
	CALL SUBOPT_0x7
; 0001 0100     }
	RJMP _0x20050
_0x20052:
; 0001 0101 
; 0001 0102     if(Temp<20||Temp>80)
	LDS  R26,_Temp
	LDS  R27,_Temp+1
	SBIW R26,20
	BRLT _0x20054
	LDS  R26,_Temp
	LDS  R27,_Temp+1
	CPI  R26,LOW(0x51)
	LDI  R30,HIGH(0x51)
	CPC  R27,R30
	BRLT _0x20053
_0x20054:
; 0001 0103     {
; 0001 0104         lcd_clear();
	RCALL _lcd_clear
; 0001 0105         lcd_puts("EE");
	__POINTW2MN _0x20031,76
	CALL SUBOPT_0x9
; 0001 0106         delay_ms(1000);
; 0001 0107     }
; 0001 0108 
; 0001 0109     else
	RJMP _0x20056
_0x20053:
; 0001 010A     {
; 0001 010B         flag=0;
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0001 010C     }
_0x20056:
; 0001 010D 
; 0001 010E }
	RJMP _0x2004D
_0x2004F:
; 0001 010F 
; 0001 0110 delay_ms(1000);
	CALL SUBOPT_0x5
; 0001 0111 lcd_clear();
	RCALL _lcd_clear
; 0001 0112 lcd_puts("THE END");
	__POINTW2MN _0x20031,79
	RCALL _lcd_puts
; 0001 0113 
; 0001 0114 }
	RET
; .FEND

	.DSEG
_0x20031:
	.BYTE 0x57
;
;
; void port_init()
; 0001 0118  {

	.CSEG
_port_init:
; .FSTART _port_init
; 0001 0119   // Declare your local variables here
; 0001 011A 
; 0001 011B // Input/Output Ports initialization
; 0001 011C // Port A initialization
; 0001 011D // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0001 011E DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 011F // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0001 0120 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0001 0121 
; 0001 0122 // Port B initialization
; 0001 0123 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0124 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0001 0125 
; 0001 0126 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0127 PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0001 0128 
; 0001 0129 // Port C initialization
; 0001 012A // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 012B DDRC=(1<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(129)
	OUT  0x14,R30
; 0001 012C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 012D PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0001 012E 
; 0001 012F // Port D initialization
; 0001 0130 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0131 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0001 0132 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0133 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0001 0134 
; 0001 0135 
; 0001 0136  }
	RET
; .FEND
;
;void intrupt_init()
; 0001 0139 {
_intrupt_init:
; .FSTART _intrupt_init
; 0001 013A 
; 0001 013B // Timer/Counter 0 initialization
; 0001 013C // Clock source: System Clock
; 0001 013D // Clock value: Timer 0 Stopped
; 0001 013E // Mode: Normal top=0xFF
; 0001 013F // OC0 output: Disconnected
; 0001 0140 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0001 0141 TCNT0=0x00;
	OUT  0x32,R30
; 0001 0142 OCR0=0x00;
	OUT  0x3C,R30
; 0001 0143 
; 0001 0144 // Timer/Counter 1 initialization
; 0001 0145 // Clock source: System Clock
; 0001 0146 // Clock value: Timer1 Stopped
; 0001 0147 // Mode: Normal top=0xFFFF
; 0001 0148 // OC1A output: Disconnected
; 0001 0149 // OC1B output: Disconnected
; 0001 014A // Noise Canceler: Off
; 0001 014B // Input Capture on Falling Edge
; 0001 014C // Timer1 Overflow Interrupt: Off
; 0001 014D // Input Capture Interrupt: Off
; 0001 014E // Compare A Match Interrupt: Off
; 0001 014F // Compare B Match Interrupt: Off
; 0001 0150 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0001 0151 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0001 0152 TCNT1H=0x00;
	OUT  0x2D,R30
; 0001 0153 TCNT1L=0x00;
	OUT  0x2C,R30
; 0001 0154 ICR1H=0x00;
	OUT  0x27,R30
; 0001 0155 ICR1L=0x00;
	OUT  0x26,R30
; 0001 0156 OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 0157 OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 0158 OCR1BH=0x00;
	OUT  0x29,R30
; 0001 0159 OCR1BL=0x00;
	OUT  0x28,R30
; 0001 015A 
; 0001 015B // Timer/Counter 2 initialization
; 0001 015C // Clock source: System Clock
; 0001 015D // Clock value: Timer2 Stopped
; 0001 015E // Mode: Normal top=0xFF
; 0001 015F // OC2 output: Disconnected
; 0001 0160 ASSR=0<<AS2;
	OUT  0x22,R30
; 0001 0161 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0001 0162 TCNT2=0x00;
	OUT  0x24,R30
; 0001 0163 OCR2=0x00;
	OUT  0x23,R30
; 0001 0164 
; 0001 0165 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 0166 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0001 0167 
; 0001 0168 // External Interrupt(s) initialization
; 0001 0169 // INT0: Off
; 0001 016A // INT1: On
; 0001 016B // INT1 Mode: Rising Edge
; 0001 016C // INT2: Off
; 0001 016D GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0001 016E MCUCR=(1<<ISC11) | (1<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(12)
	OUT  0x35,R30
; 0001 016F MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0001 0170 GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0001 0171 
; 0001 0172 // USART initialization
; 0001 0173 // USART disabled
; 0001 0174 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0001 0175 
; 0001 0176 // Analog Comparator initialization
; 0001 0177 // Analog Comparator: Off
; 0001 0178 // The Analog Comparator's positive input is
; 0001 0179 // connected to the AIN0 pin
; 0001 017A // The Analog Comparator's negative input is
; 0001 017B // connected to the AIN1 pin
; 0001 017C ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0001 017D SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0001 017E 
; 0001 017F // ADC initialization
; 0001 0180 // ADC disabled
; 0001 0181 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0001 0182 
; 0001 0183 // SPI initialization
; 0001 0184 // SPI disabled
; 0001 0185 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0001 0186 
; 0001 0187 // TWI initialization
; 0001 0188 // TWI disabled
; 0001 0189 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0001 018A 
; 0001 018B 
; 0001 018C 
; 0001 018D }
	RET
; .FEND
;
;void all_init()
; 0001 0190 {
_all_init:
; .FSTART _all_init
; 0001 0191  port_init();
	RCALL _port_init
; 0001 0192  intrupt_init();
	RCALL _intrupt_init
; 0001 0193  lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0001 0194 }
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xA
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20A0001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strncpy:
; .FSTART _strncpy
	ST   -Y,R26
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncpy0:
    tst  r23
    breq strncpy1
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncpy0
strncpy2:
    tst  r23
    breq strncpy1
    dec  r23
    st   x+,r22
    rjmp strncpy2
strncpy1:
    movw r30,r24
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_data_key:
	.BYTE 0x10
_Temp:
	.BYTE 0x2
_i:
	.BYTE 0x1
_j:
	.BYTE 0x1
_flag:
	.BYTE 0x1
_intrupt_flag:
	.BYTE 0x1
_t:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDS  R30,_i
	LDI  R26,LOW(1)
	CALL __LSLB12
	OUT  0x18,R30
	LDI  R30,LOW(0)
	STS  _j,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1:
	IN   R1,22
	LDS  R30,_j
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	MOVW R22,R30
	LDS  R30,_j
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	CP   R30,R22
	CPC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2:
	LDS  R30,_i
	LDI  R31,0
	SBIW R30,4
	CALL __LSLW2
	MOVW R26,R30
	LDS  R30,_j
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R26,Z
	CALL _lcd_putchar
	LDI  R30,LOW(0)
	STS  _flag,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDS  R30,_i
	LDI  R31,0
	SBIW R30,4
	CALL __LSLW2
	MOVW R26,R30
	LDS  R30,_j
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	CALL _key_press
	STS  _t,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	LDS  R30,_t
	LDI  R31,0
	SBIW R30,48
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	CALL _lcd_puts
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

;END OF CODE MARKER
__END_OF_CODE:
