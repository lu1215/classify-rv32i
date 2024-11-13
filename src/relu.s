.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0

loop_start:
    # TODO: Add your own implementation
    # t2 save a0 addr
    addi t2, a0, 0
    # t1 as a counter

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

error:
    li a0, 36          
    j exit          
