//////////////////////////
//	Project Stationery  //
//////////////////////////

#include <stdio.h>

typedef void (IntHndlr)(long);

extern void InterruptHandler(long cause);
asm void system_call();

asm void system_call()
{
	nofralloc
	sc
	blr
}


void main()
{
	int i=0;
	printf("Super_Jew\n\r");
	
	printf("Welcome to CodeWarrior!\r\n");

	system_call(); // generate a system call exception to demonstrate the ISR
		
	while (1) { i++; } // loop forever
}

