# Assignment 2: Classify

contributed by < [`michael1215`](https://github.com/lu1215/classify-rv32i) >

## Part A: Mathematical Functions
### abs
Checking the first bit; if it is 1, perform the 2's complement.
```s
## 2's complement ##
xori t0, t0, -1 # 1's complement
addi t0, t0, 1  # result of 1's complement plus 1
```

### Multiplication
utilizing the shift and add technique to practice RISC-V multiplication, and stopping the operation by verifying that either a0 or a1 is zero.
**mul.s**
```s
.globl shif_add

.text
# =======================================================
# FUNCTION: Multiplication using shift and add
#
# Calculates a * b
#      a
#   *  b
#   ----
# 
# Args:
#   a0 (int): Multiplicand
#   a1 (int): Multiplier
#
# Returns:
#   a0 (int):   Resulting multiplication value
#
# Preconditions:
#   - ?
#
# Error Handling:
#   - ?
# =======================================================

shif_add:
    # Prologue
    addi t0, x0, 0    # initinalize sum = 0
    beqz a0, mul_end    # a = 0 or b = 0, result is zero
    beqz a1, mul_end
    
calculating:
    andi t1, a1, 1    # get rightmost bit of b
    beqz t1, skip_add    # if t1 = 0, t0 doesn't need to add a0
    add t0, t0, a0
    
skip_add:
    slli a0, a0, 1    # left shift a0 1 bit 
    srai a1, a1, 1    # right shift a1 1 bit
    beqz a0, mul_end    # when a1 = negative number, a1 will never become zero , so adding a new condition
    bnez a1, calculating    # if a1 = 0, calculation end, else continue calculating
    
mul_end:
    # Epilogue
    addi a0, t0, 0
    jr ra    # return
```

To check for correctness of shif_add, we used scenario 1: one input is zero, case 2: multiple two positive numbers, case 3: multiple one positive number and one negative, and case 4: two negative numbers.
**test code for mul.s**
```s
.import ./mul.s

.data
message: .asciiz "test pass\n"

.text
main:
    # Test Case 1: 0 * 10 = 0
    li a0, 0               # a = 0
    li a1, 10              # b = 10
    jal ra, shif_add       # call shif_add
    li t2, 0               # expected result
    bne a0, t2, fail       # if a0 != 0, fail

    # Test Case 2: 7 * 6 = 42
    li a0, 7               # a = 7
    li a1, 6               # b = 6
    jal ra, shif_add       # call shif_add
    li t2, 42              # expected result
    bne a0, t2, fail       # if a0 != 42, fail

    # Test Case 3: -3 * 9 = -27
    li a0, -3              # a = -3
    li a1, 9               # b = 9
    jal ra, shif_add       # call shif_add
    li t2, -27             # expected result
    bne a0, t2, fail       # if a0 != -27, fail

    # Test Case 4: 8 * -5 = -40
    li a0, 8               # a = 8
    li a1, -5              # b = -5
    jal ra, shif_add       # call shif_add
    li t2, -40             # expected result
    bne a0, t2, fail       # if a0 != -40, fail

    # Test Case 5: -4 * -4 = 16
    li a0, -4              # a = -4
    li a1, -4              # b = -4
    jal ra, shif_add       # call shif_add
    li t2, 16              # expected result
    bne a0, t2, fail       # if a0 != 16, fail

    # 所有測試通過
    la a0, message              # a0 = addr message
    li a7, 4                    # a7 = 4 (syscall code for print string in RARS)
    ecall
    li a7, 10              # syscall: exit
    ecall

fail:
    li a7, 10              # syscall: exit with failure code
    ecall
```

![image](https://hackmd.io/_uploads/B147qEKWyl.png)
### Task1: ReLU 
[類神經網路的 ReLU 及其常數時間複雜度實作](https://hackmd.io/@sysprog/constant-time-relu)
[branchless_ReLU.c](https://gist.github.com/ToruNiina/f7a3ba69585cf3bfd869e302357c11a8)

![image](https://hackmd.io/_uploads/B1SUKWSgkg.png)

#### idea 
obtaining the "sign bit" using the "&" operation; if the sign bit is zero, return the original number; if not, return 0.
```
logic by reference
x & ~(x>>31) ## arithmetic right shift
if x >= 0 => ~(x>>31) = 0xFFFFFFFF
else => ~(x>>31) = 0x0
```

**relu.s**
```s
loop_start:
    # TODO: Add your own implementation
    # t2 save a0 addr
    addi t2, a0, 0
    # set t1 as a counter

loop:
    # x & ~(x>>31)
    # t4 is x, and t3 is ~(x>>31)
    lw t0, 0(t2)
    srai t3, t0, 31
    xori t3, t3, -1
    and t0, t0, t3    
    # storing element to original address
    sw t0, 0(t2)
    addi t2, t2, 4  # moving to next element
    addi t1, t1, 1 # index--
    bne t1, a1, loop

loop_end:
    ret
```

### Task 2: ArgMax
reference:
Author of the article: Cynthia
Article link: https://cynthiachuang.github.io/What-Do-Max-and-Argmax-Mean-in-Maths/
Copyright notice: Unless otherwise noted, all articles in this blog are licensed under the CC BY-NC-SA 4.0 license. Please indicate the author, link, and source when reposting.
[數學中常見的 arg 和 arg max/ min 是什麼？](https://cynthiachuang.github.io/What-Do-Max-and-Argmax-Mean-in-Maths/)
[What is the best way to get the minimum or maximum value from an Array of numbers?](https://stackoverflow.com/questions/424800/what-is-the-best-way-to-get-the-minimum-or-maximum-value-from-an-array-of-number)

#### idea
utilizing a for loop to iterate through each element, storing the local maximum in one temp and the index of the maximum value in another.
**argmax.s**
```s
loop_start:
    # TODO: Add your own implementation
    # prologue
    blez a1, argmaxend
    lw t0, 0(a0)    # initinalize temp maximum to first element
    addi t1, x0, 0     # initinalize temp index to 0
    addi t4, a1, 0     # set index = len of array
    
argmaxloop:
    blez t4, argmaxend     # index >= 0, keep finding, else go to end
    lw t2, 0(a0)           # load current value
    slt t3, t0, t2         # comparing temp maximum and current value
    beqz t3, skip_changing # if cur value < max, t3 = 1, do nothing
    sub t1, a1, t4         # changing index to current index
    addi t0, t2, 0         # changing maximum to current value

skip_changing:
    addi a0, a0, 4     # addr += 4
    addi t4, t4, -1    # index -= 1
    j argmaxloop
    
argmaxend:
    # epilogue
    addi a0, t1, 0
    jr ra
```

### Task 3.1: Dot Product
reference:
[RISC-V Vector Extension: 從指令集到程式模型 - Kito Cheng](https://hackmd.io/@coscup/SJLHICJTc/%2F%40coscup%2FSJ1eIRyp5)
[Introduction to the RISC-V Vector Extension](https://eupilot.eu/wp-content/uploads/2022/11/RISC-V-VectorExtension-1-1.pdf)
[transposing a square matrix](https://hackmd.io/@sysprog/arch2023-quiz3-sol#Problem-A)
[RISC-V "V" Vector Extension](https://github.com/riscv/riscv-v-spec/blob/master/v-spec.adoc)
[riscv-v-spec](https://github.com/riscv/riscv-v-spec/tree/master/example)

**dot.s**
```s
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         

    addi sp, sp, -36
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw a0, 12(sp)
    sw a1, 16(sp)
    sw ra, 20(sp)
    sw a2, 24(sp)
    sw a3, 28(sp)
    sw a4, 32(sp)
    

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    # making stride become real stride in memory address
    slli a3, a3, 2
    slli a4, a4, 2
    addi t2, x0, 0    # making sum = 0 in the start
    # reducing times of lw and sw
    addi sp, sp, -8 # make sure to store slli a3, a3, 2 and slli a4, a4, 2
    sw a3, 0(sp)
    sw a4, 4(sp)


loop:    
    addi sp, sp, -16
    sw a0, 0(sp)    # storing a0, a1 into stack
    sw a1, 4(sp)
    sw t2, 8(sp)
    sw a2, 12(sp) 
    lw a0, 0(a0)    # this instruction can derived from lw t0, 0(a0) and addi a0, t0, 0
    lw a1, 0(a1)    # this instruction can derived from lw t1, 0(a1) and addi a1, t1, 0

    jal shif_add
    lw t2, 8(sp)
    add t2, t2, a0    # summing up values, and derived from add t2, t2, a0 and addi t0, a0, 0

    lw a0, 0(sp)    # storing a0, a1 into stack
    lw a1, 4(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    lw a3, 0(sp)
    lw a4, 4(sp)
    
    add a0, a0, a3    # addr += stride of v0
    add a1, a1, a4    # addr += stride of v1
    addi a2, a2, -1    # index--
    bgtz a2, loop    # if index <= 0, go to dot_end label

loop_end:
    addi sp, sp, 8  # make sure to clean up the stack for storing slli a3, a3, 2 and slli a4, a4, 2
    mv a0, t2
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw a1, 16(sp)
    lw ra, 20(sp)
    lw a2, 24(sp)
    lw a3, 28(sp)
    lw a4, 32(sp)
    addi sp, sp, 36
    jr ra
```

dot.s (import shift_add from another file), before jump to shift_add, all variable need to be stored into stack, or it will cause cc violation.
ex: `[CC Violation]: (PC=0x00000748) Usage of unset register a3! ../src/dot.s:65 add a0, a0, a3    # addr += stride of v0`
and if we bump into this question, we need to check that every variable will be put into stack or it will be initinalize properly after return from function of other .s files.

**dot.s(using vector extension)**
```s
# input: a0(addr of v0), a1(addr of v1), a2(len of input array), a3(a3 is the stride of v0), a4( a4 is the stride of v1)
# output: a0(addr of calculated vector)
dot_product:
    # prologue
    addi sp, sp, 4
    sw t0, 0(sp)
    
    vsetvli t0, a2, e32               # 
    vlse.v v1, (a0), a3               # load value to v1 from a0(stride is a3)
    vlse.v v2, (a1), a4               # load value to v0 from a1(stride is a4)
    vmul.vv v3, v1, v2               # dot product v1 and v2 , then save the result to v4
    vredsum.vs v4, v3, v0             # summing up value in v3, and store in v4[0]
    vsw v4, (a0)                      # store calculated value in a0
    lw t0, 0(sp)
    addi, sp, sp, 4
    jr ra
```

### Task 3.2: Matrix Multiplication
[sgemm.s](https://github.com/riscv/riscv-v-spec/blob/master/example/sgemm.S)

Constructing this section to verify that the out loop can retrieve the right row of M0 the next time.
```s
inner_loop_end:
    # TODO: Add your own implementation
    addi s0, s0, 1  # outer counter ++
    slli t0, a2, 2  # moving matrix a pointer to next row
    add s3, s3, t0
    j outer_loop_start
```

## Part B: File Operations and Main
### Task 1: Read Matrix
substituting my own shif_add function for mul.
```s
    # mul s1, t1, t2   # s1 is number of elements
    # FIXME: Replace 'mul' with your own implementation    
    addi a0, t1, 0
    addi a1, t2, 0

    jal shif_add    # calling mul function

    addi s1, a0, 0
```



### Task 2: Write Matrix
substituting my own shif_add function for mul.
```s
    addi a0, s2, 0
    addi a1, s3, 0

    jal shif_add    # calling mul function

    addi s4, a0, 0
```
### Task 3: Classification
Adding a new multiple function to prevent errors.
```s
# =======================================================
# FUNCTION: Multiplication using shift and add
#
# Calculates a * b
#    a
# *  b
# ----
# 
# Args:
#   a1 (int): Multiplicand
#   a2 (int): Multiplier
#
# Returns:
#   a1 (int):   Resulting multiplication value
#
# Preconditions:
#   - ?
#
# Error Handling:
#   - ?
# =======================================================
shif_add_aone:
    # Prologue
    addi t0, x0, 0    # initinalize sum = 0
    beqz a1, mul_end_aone    # a = 0 or b = 0, result is zero
    beqz a2, mul_end_aone
    
calculating_aone:
    andi t1, a2, 1    # get rightmost bit of b
    beqz t1, skip_add_aone    # if t1 = 0, t0 doesn't need to add a1
    add t0, t0, a1
    
skip_add_aone:
    slli a1, a1, 1    # left shift a1 1 bit 
    srai a2, a2, 1    # right shift a2 1 bit
    beqz a1, mul_end_aone    # when a2 = negative number, a2 will never become zero , so adding a new condition
    bnez a2, calculating_aone    # if a2 = 0, calculation end, else continue calculating
    
mul_end_aone:
    # Epilogue
    addi a1, t0, 0
    jr ra    # return
```
```s
# mul a1, t0, t1 # load length of array into second arg
# FIXME: Replace 'mul' with your own implementation
addi sp, sp, -4
sw a2, 0(sp)
addi a1, t0, 0
addi a2, t1, 0
jal shif_add_aone    # calling mul function
lw a2, 0(sp)
addi sp, sp, 4
```

```s
# mul a0, t0, t1 # FIXME: Replace 'mul' with your own implementation
# mul part #
addi a0, t0, 0
addi a1, t1, 0
jal shif_add    # calling mul function
# mul part #
```

## result
![image](https://hackmd.io/_uploads/rJFxzWvfJx.png)

## Problem Solving

### CC violation
Before jumping to shift_add while importing shift_add from another file, all variables must be saved in the stack to avoid a cc violation.
ex: 
`[CC Violation]: `
`(PC=0x00000748) Usage of unset register a3! ../src/dot.s:65 add a0, a0, a3    # addr += stride of v0`
Moreover, if we see this condition, we must confirm that each variable will be added to the stack or that it will be correctly initialized following the return from other.s files' functions.

### Attempting to access uninitialized memory
I keep running across errors when writing classify.s. (Venus ran into a simulator error! Attempting to access uninitialized memory between the stack and heap. Attempting to access '4' bytes at address '0x10008180'.)
Reason and solution: I thought that changing a0 and a1 in my relu function would not affect the original code's execution, however it would cause other functions to access the incorrect address and result in this problem.
Therefore, if I made a straight modification, I would switch the function's input registers to other registers.
**The input parameter cannot be altered even if it is not returned.**

### You are attempting to edit the text of the program though the program is set to immutable at address 0x0000000F!

![image](https://hackmd.io/_uploads/rkaqN0-Mkl.png)
because in classify.s code in fornt of `li a0, 15`, it has a instruction `mv a0, s9 # move h to the first argument` this instruction make a0 becoming a pointer, so when we use `li a0, 15`
that 

```s
addi sp, sp, -4
sw a0, 0(sp)
# The address of the t3 value is stored in the register s3.
# a0 points to addr of t3 value(s3)
mv a0, s3 
# li a0, 15 => error
lw a0, 0(sp)
addi sp, sp, 4
```
resister a0 always points to a valid address(It is possible to modify the address where value is stored.), therefore when code becomes above code, it will not result in an error like the one just mentioned.

**We must verify that the address that a register points to is valid if it has previously saved a pointer.**

### AssertionError: Venus returned exit code 27 not 0.
stdout:
Exited with error code 27


### Tips
***To avoid debugging too much to locate the bug, you can occasionally just change a small portion of the code then compile or test.***

### Speed up
* reducing lw/sw instruction: I eliminate several lw and sw instructions in the multiply code to reduce instructions since I use a mul.s file to import the multiply function, which requires me to store all variables before I can use it.
* moving location of instruction: putting this instruction `lw a0, 0(a0)` between lw and sw instructions. This reduces instructions such as `lw t0, 0(a0)` `addi a0, t0, 0` or `addi t0, a0, 0` `add t2, t2, t0` => `add t2, t2, a0`.