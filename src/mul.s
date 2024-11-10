.globl shif_add

.text
# =======================================================
# FUNCTION: Multiplication using shift and add
#
# Calculates a * b
#    a
# *  b
# ----
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
    addi sp, sp, -8
    sw t0, 0(sp)    # sum
    sw t1, 4(sp)    # tmp value for Multiplication
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
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    jr ra    # return