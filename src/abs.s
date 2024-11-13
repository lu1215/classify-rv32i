.globl abs

.text
# =================================================================
# FUNCTION: Absolute Value Converter
#
# Transforms any integer into its absolute (non-negative) value by
# modifying the original value through pointer dereferencing.
# For example: -5 becomes 5, while 3 remains 3.
#
# Args:
#   a0 (int *): Memory address of the integer to be converted
#
# Returns:
#   None - The operation modifies the value at the pointer address
# =================================================================
abs:
    # Prologue
    ebreak
    # addi sp, sp, -4
    # sw t0, 0(sp)
    # Load number from memory
    lw t0 0(a0)
    bge t0, zero, done

    # TODO: Add your own implementation
    # doing 2's complement
    xori t0, t0, -1 # 1's complement
    addi t0, t0, 1  # result of 1's complement plus 1
    sw t0, 0(a0)

done:
    # Epilogue
    # lw t0, 0(sp)
    # addi sp, sp, 4
    jr ra
