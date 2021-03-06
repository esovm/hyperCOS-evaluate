/*-****************************************************************************/
/*-                                                                           */
/*-            Copyright (c) of hyperCOS.                                     */
/*-                                                                           */
/*-  This software is copyrighted by and is the sole property of socware.net. */
/*-  All rights, title, ownership, or other interests in the software remain  */
/*-  the property of socware.net. The source code is FREE for short-term      */
/*-  evaluation, educational or non-commercial research only. Any commercial  */
/*-  application may only be used in accordance with the corresponding license*/
/*-  agreement. Any unauthorized use, duplication, transmission, distribution,*/
/*-  or disclosure of this software is expressly forbidden.                   */
/*-                                                                           */
/*-  Knowledge of the source code may NOT be used to develop a similar product*/
/*-                                                                           */
/*-  This Copyright notice may not be removed or modified without prior       */
/*-  written consent of socware.net.                                          */
/*-                                                                           */
/*-  socware.net reserves the right to modify this software                   */
/*-  without notice.                                                          */
/*-                                                                           */
/*-  To contact socware.net:                                                  */
/*-                                                                           */
/*-             socware.help@gmail.com                                        */
/*-                                                                           */
/*-****************************************************************************/

#include "cfg.h"
#include "asm-off.h"
#include "cpu/asm.h"
	.asm_syn

	.text
	.asm_fun _hfault
_hfault:
	tst 	lr, #4
	ite	eq
	mrseq	r0, MSP
	mrsne	r0, PSP
	push	{lr}
	bl	cpu_tf
	pop	{lr}
	cmp	r0, #0
	it	ne
	// return iff it's a lazy float trap
	bxne	lr

1:
	b	1b
	.asm_fun __abt
__abt:
	tst 	lr, #4
	ite	eq
	mrseq	r0, MSP
	mrsne	r0, PSP

	push	{lr}
	ldr     lr, =core_abt
	ldr     lr, [lr]
	blx     lr
	pop	{lr}
	bx	lr

	.data
	.align 2
	.global core_abt
core_abt:
	.word   _abt
