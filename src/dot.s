.import ./mul.s
.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         

    addi sp, sp, -40 
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw a0, 12(sp)
    sw a1, 16(sp)
    sw ra, 20(sp)
    

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    # making stride become real stride in memory address
    slli a3, a3, 2
    slli a4, a4, 2
    addi t2, x0, 0    # making sum = 0 in the start

loop:    
    lw t0, 0(a0)    # get value from v0
    lw t1, 0(a1)    # get value from v1
    
    sw a0, 12(sp)    # storing a0, a1 into stack
    sw a1, 16(sp)
    sw t2, 24(sp)
    sw a2, 28(sp) 
    sw a3, 32(sp) 
    sw a4, 36(sp)

    addi a0, t0, 0
    addi a1, t1, 0
    jal shif_add
    addi t0, a0, 0

    lw a0, 12(sp)    # storing a0, a1 into stack
    lw a1, 16(sp)
    lw t2, 24(sp)
    lw a2, 28(sp) 
    lw a3, 32(sp) 
    lw a4, 36(sp)

    add t2, t2, t0    # summing up values
    add a0, a0, a3    # addr += stride of v0
    add a1, a1, a4    # addr += stride of v1
    addi a2, a2, -1    # index--
    bgtz a2, loop    # if index <= 0, go to dot_end label
    addi t0, t2, 0

loop_end:
    mv a0, t0
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw ra, 20(sp)
    addi sp, sp, 40
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
