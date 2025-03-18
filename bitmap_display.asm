.data
ADDR_DSPL:
    .word 0x10008000          # Base address of the bitmap display
.text
    .globl main

main:
    li $t1, 0x808080          # Gray color for the lines
    lw $t0, ADDR_DSPL         # Load base address of display

    # Draw the left vertical line
    li $a0, 10                # Start at row 10
    li $a1, 8                 # Start at column 8
    li $a2, 16                # Height of the vertical line (16 pixels)
    jal draw_vertical_line

    # Draw the right vertical line
    li $a0, 10                # Start at row 10
    li $a1, 23                # Start at column 23
    li $a2, 16                # Height of the vertical line (16 pixels)
    jal draw_vertical_line

    # Draw the bottom horizontal line
    li $a0, 26                # Start at row 26
    li $a1, 9                 # Start at column 9
    li $a2, 22                # End at column 22
    jal draw_horizontal_line

    # Draw the top horizontal line with a 4-pixel gap in the middle
    li $a0, 9                 # Start at row 9
    li $a1, 9                 # Start at column 9
    li $a2, 12                # End column for the left part (12)
    jal draw_horizontal_line

    # Draw the right part of the top horizontal line
    li $a0, 9                 # Start at row 9
    li $a1, 19                # Start at column 19
    li $a2, 22                # End at column 22
    jal draw_horizontal_line

    # Draw the 2 vertical lines that are protruding out of the gap
    li $a0, 7                 # Start at row 7
    li $a1, 13                # Start at column 13
    li $a2, 2                 # Height of the vertical line (2 pixels)
    jal draw_vertical_line

    li $a0, 7                 # Start at row 7
    li $a1, 18                # Start at column 18
    li $a2, 2                 # Height of the vertical line (2 pixels)
    jal draw_vertical_line

    # Draw additional vertical lines for the design
    li $a0, 5                 # Start at row 5
    li $a1, 12                # Start at column 12
    li $a2, 2                 # Height of the vertical line (2 pixels)
    jal draw_vertical_line

    li $a0, 5                 # Start at row 5
    li $a1, 19                # Start at column 19
    li $a2, 2                 # Height of the vertical line (2 pixels)
    jal draw_vertical_line

exit:
    li $v0, 10                # Exit program
    syscall

# Function to draw a vertical line
# Arguments: $a0 = start row, $a1 = start column, $a2 = height
draw_vertical_line:
    li $t4, 128               # Row offset (128 bytes per row)
    mul $t5, $a0, $t4         # Row offset = row * 128
    li $t6, 4                 # Each unit is 4 bytes
    mul $t7, $a1, $t6         # Column offset = column * 4
    add $t8, $t5, $t7         # Total offset = row offset + column offset
    addu $t9, $t0, $t8        # Starting address = base address + offset
    li $t3, 0                 # Start row count for drawing
draw_vertical_loop:
    sw $t1, 0($t9)            # Write pixel to the vertical line location
    addi $t9, $t9, 128        # Move to the next row (add 128 bytes)
    addi $t3, $t3, 1          # Increment row count
    blt $t3, $a2, draw_vertical_loop # Continue drawing for specified height
    jr $ra                    # Return to caller

# Function to draw a horizontal line
# Arguments: $a0 = start row, $a1 = start column, $a2 = end column
draw_horizontal_line:
    li $t4, 128               # Row offset (128 bytes per row)
    mul $t5, $a0, $t4         # Row offset = row * 128
    li $t6, 4                 # Each unit is 4 bytes
    mul $t7, $a1, $t6         # Column offset = column * 4
    add $t8, $t5, $t7         # Total offset = row offset + column offset
    addu $t9, $t0, $t8        # Starting address = base address + offset
draw_horizontal_loop:
    sw $t1, 0($t9)            # Write pixel to the horizontal line location
    addi $t9, $t9, 4          # Move to the next column (add 4 bytes)
    addi $a1, $a1, 1          # Increment column count
    ble $a1, $a2, draw_horizontal_loop # Continue drawing until the end column
    jr $ra                    # Return to caller