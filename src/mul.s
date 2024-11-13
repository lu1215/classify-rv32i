.globl shif_add
# .globl shif_add_aone
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
    # addi sp, sp, -8
    # sw t0, 0(sp)    # sum
    # sw t1, 4(sp)    # tmp value for Multiplication
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
    # lw t0, 0(sp)
    # lw t1, 4(sp)
    # addi sp, sp, 8
    jr ra    # return


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

# shif_add_aone:
#     # Prologue
#     addi sp, sp, -8
#     sw t0, 0(sp)    # sum
#     sw t1, 4(sp)    # tmp value for Multiplication
#     # sw a2, 8(sp)    # store a2
#     addi t0, x0, 0    # initinalize sum = 0
#     beqz a1, mul_end_aone    # a = 0 or b = 0, result is zero
#     beqz a2, mul_end_aone
    
# calculating_aone:
#     andi t1, a2, 1    # get rightmost bit of b
#     beqz t1, skip_add_aone    # if t1 = 0, t0 doesn't need to add a1
#     add t0, t0, a1
    
# skip_add_aone:
#     slli a1, a1, 1    # left shift a1 1 bit 
#     srai a2, a2, 1    # right shift a2 1 bit
#     beqz a1, mul_end_aone    # when a2 = negative number, a2 will never become zero , so adding a new condition
#     bnez a2, calculating_aone    # if a2 = 0, calculation end, else continue calculating
    
# mul_end_aone:
#     # Epilogue
#     addi a1, t0, 0
#     lw t0, 0(sp)
#     lw t1, 4(sp)
#     # lw a2, 8(sp)
#     addi sp, sp, 8
#     jr ra    # return