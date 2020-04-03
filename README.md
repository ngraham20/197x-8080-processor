# 197x-8080-processor

## Inspriation
- [Intel 8080][1]
- [Intel 8088][2] ([IBM PC][5])
- [MOS Technology 6502][7] ([Apple II][8])
- [Motorola 68000][4] ([Apple Macintosh][6])

## Application Area
### Intel 8088 - Nathaniel G.
The `Intel 8088` is a general purpose processor, used most notably in the IBM general use PC.
It has an 8-bit external data bus, with a 16-bit registers and one megabyte address range.
### MOS Tech 6502 - Keenan R.
General use. The `MOS Tech 6520` was used in a variety of products such as the original Nintendo Entertainment System to a computer used by the BBC.
### Motorola 68000 - Nate W.
The `Motorola 68000` was one of the first general-purpose processors with a 32-bit instruction set. It was used in the Apple Macintosh for general computing.

## Processor Use
### Intel 8088
| Name | Number | Type | Use |
|------|--------|------|-----|
|AX||Accumulator|Arithmetic, logic, data transfer|
|BX||Base|Can be used as a 16-bit offset address. Paired by default with segment register "DS." (memory ref. [BX] means [DS:BX]|
|CX||Counter|Used to control looping|
|DX||Data|Often used to hold single-byte character data and is referenced as DH or DL. Combines with AX to form a 32-bit register for some operations (e.g. multiply)|
|CS||Code Segment|Holds 
|SI||Source Index||
|DI||Destination Index||
|BP||Base Pointer||
|SP||Stack Pointer||
|||||

### MOS Tech 6502
| Name | Number | Use |
|------|--------|-----|
|A||Accumulator|
|Y||Index Register|
|X||Index Register|
|PC||Program Counter|
|S||Stack Pointer|
|P||Processor Status Register|

### Motorola 68000
| Name | Number | Use |
|------|--------|-----|
|D0-D7|1-8|Data Registers|
|A0-A6|9-15|Address Registers|
|A7 (USP)|16|Stack Pointer (user)|
|A7' (SSP)|17|Stack Pointer (supervisor)|
|PC|18|Program counter|
|CCR|19|Condition Code Register|


## Processor OPCodes
### Intel 8088
### MOS Tech 6502
|Opcode|Operation|Syntax|
|------|---------|------|
|AND| A AND M -> A |And (IND, X) |
|ASL| C <-[76543210]<-0 |ASL A|
|BCC| branch on C = 1| BCC oper|
|DEX|X-1 -> X| DEC|
### Motorola 68000
|Opcode|Operation|Syntax|
|------|---------|------|
|ADD|Source + Destination -> Destination|Add \<ea>,Dn|
|DIVS|Destination/Source -> Destination|DIVS.W\<ea>,Dn|
|EOR|Source OR Destination -> Destination|EOR Dn,\<ea>|
|MOVEA|Source -> Destination|MOVEAE\<ea>,An|

## Block Diagram
### Intel 8088
### MOS Tech 6502
### Motorola 68000
![Motorola](motorola.png)

## Slightly Esoteric Assembly Language
Just another SEA-language

## General Purpose 16-Bit Processor

```
I-type
R-type
J-type

SYS
| syscall

MEM
| lw        #
| sw        #
| li        #
| si        #
| la        #
| sa        #

BRANCH
| bneq      #
| blt       #

JMP
| jump      #

ALU
| add       # 
| addi      # 
| sub       #
| subi      #
| mult      #
| multi     #
| div       #
| divi      #
| slt       #
| neq       #
| and       #
| or        #
| not       #
| xor       #
| slr       #
| srr       #
```

[1]: https://en.wikipedia.org/wiki/Intel_8080
[2]: https://en.wikipedia.org/wiki/Intel_8088
[3]: https://en.wikipedia.org/wiki/Microprocessor#History
[4]: https://en.wikipedia.org/wiki/Motorola_68000
[5]: https://en.wikipedia.org/wiki/IBM_Personal_Computer
[6]: https://en.wikipedia.org/wiki/Macintosh
[7]: https://en.wikipedia.org/wiki/MOS_Technology_6502
[8]: https://en.wikipedia.org/wiki/Apple_II