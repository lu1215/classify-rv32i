.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    # addi sp, sp, -24
    # sw t0, 0(sp)    # temp maximum
    # sw t1, 4(sp)    # temp index
    # sw t2, 8(sp)    # current value
    # sw t3, 12(sp)   # recording result of copmaring
    # sw t4, 16(sp)   # recording index
    # sw t6, 20(sp)   # recording index

    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0
    li t2, 1
    
    
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
    # lw t0, 0(sp)
    # lw t1, 4(sp)
    # lw t2, 8(sp)
    # lw t3, 12(sp)
    # lw t4, 16(sp)
    # lw t6, 20(sp)
    # addi sp, sp, 24
    jr ra

handle_error:
    li a0, 36
    j exit
