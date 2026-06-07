MEMORY
{
    MEM : ORIGIN = 0x0, LENGTH = 0x4000
    RAM : ORIGIN = 0x20000000 , LENGTH = 0x800
}

SECTIONS
{
    .text : {
        *(.vectors*)
        *(.text*)
    } > MEM   /* saying go ahead put vector table content at this address */

    .data : {
        *(.data*)
    } > RAM
}
