.globl binary_search
binary_search:


LDR R0, =list
MOV R1, #99
MOV R2, #100
// Vars we need to create: startIndex, endIndex, middleIndex, keyIndex, NumIters.

MOV R3, #0                // R3 = startIndex = 0;
SUB R4, R2, #1            // R4 = endIndex = length - 1;
MOV R5, R4, LSR #1        // R5 = middleIndex = endIndex / 2;
MOV R6, #-1               // R6 = keyIndex = -1;
MOV R7, #1                // R7 = NumIters = 1;

Loop:
CMP R6, #-1               // while (keyIndex == -1)
BNE exit                  // exit the loop if keyIndex != -1
CMP R3, R4                // compare startIndex and endIndex
BGT exit                  // exit the loop if startIndex > endIndex

LDR R8, [R0, R5, LSL #2]  // R8 = numbers [ middleIndex ] 
CMP R8, R1                // numbers [ middleIndex ] == key
BNE elseif_2              // if numbers [ middleIndex ] != key, go to the next comparison
MOV R6, R5                // keyIndex = middleIndex; changed 10.30
B default

elseif_2:
CMP R8, R1                // comapare numbers[middleIndex] and key again 
BLT else                  // if numbers[middleIndex] < key, go to else
SUB R4, R5, #1            // endIndex = middleIndex -= 1                
//MOV R4, R5              //  middleIndex - 1
B default

else:
ADD R3, R5, #1             // middleIndex += 1
//MOV R3, R5               // startIndex = middleIndex + 1;

default:
RSB R9, R7, #0            // numbers [ middleIndex ] = - NumIters, stored to temp. reg R9
MOV R8, R9                // numbers[middleIndex] = -NumIters
SUB R10, R4, R3           // R10 = endIndex - startIndex
MOV R11, R10, LSR #1      // R11 = (endIndex - startIndex) / 2;
ADD R5, R3, R11           // middleIndex = startIndex + (endIndex - startIndex) / 2;
ADD R7, #1                // NumIters++
B Loop

exit:
MOV R0, R6                 // Store keyIndex to R0, added 10.30
MOV pc,lr


.data:
list:
.word 28
.word 37
.word 44
.word 60
.word 85
.word 99
.word 121
.word 127
.word 129
.word 138

.word 143
.word 155
.word 162
.word 164
.word 175
.word 179
.word 205
.word 212
.word 217
.word 231

.word 235
.word 238
.word 242
.word 248
.word 250
.word 258
.word 283
.word 286
.word 305
.word 311

.word 316
.word 322
.word 326
.word 351
.word 355
.word 364
.word 366
.word 376
.word 391
.word 398

.word 408
.word 410
.word 415
.word 418
.word 425
.word 437
.word 441
.word 452
.word 474
.word 488

.word 506
.word 507
.word 526
.word 532
.word 534
.word 547
.word 548
.word 583
.word 585
.word 595

.word 603
.word 621
.word 640
.word 661
.word 666
.word 690
.word 692
.word 713
.word 719
.word 750

.word 755
.word 768
.word 775
.word 776
.word 784
.word 785
.word 791
.word 797
.word 798
.word 804

.word 828
.word 842
.word 846
.word 858
.word 884
.word 887
.word 890
.word 893
.word 908
.word 936

.word 939
.word 953
.word 960
.word 970
.word 978
.word 979
.word 981
.word 990
.word 1002
.word 1007