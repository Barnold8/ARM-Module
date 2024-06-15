	B main

sentence_one DEFB "Hello my name is Brandon\n", 0
sentence_two DEFB "I have programmed in x86\n", 0
sentence_three DEFB "What in the world are these instructions?\n",0

	ALIGN
main

	ADR		R0, sentence_one

	SWI 	3

	ADR 	R0, sentence_two

	SWI		3

	ADR		R0, sentence_three

	SWI		3

	SWI 2
