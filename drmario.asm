    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

# Define 3 colors for the capsule halves
COLOR_RED:    .word 0xff0000  # Red
COLOR_GREEN:  .word 0x00ff00  # Green
COLOR_BLUE:   .word 0x0000ff  # Blue

# Capsule position (middle of the gap)
CAPSULE_ROW_FIRST:  .word 7         # Row for the capsule (middle of the gap)
CAPSULE_COL_FIRST:  .word 15        # Column for the capsule (middle of the gap)
CAPSULE_ROW_SECOND: .word 8         # Row for the capsule (middle of the gap)
CAPSULE_COL_SECOND: .word 15        # Column for the capsule (middle of the gap)

CAPSULE_COLOR1: .word 0 #stores the color of the top capsule pixel
CAPSULE_COLOR2: .word 0 #stores the color of the bottom capsule pixel

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
    .text
    .globl main

    # Run the game.
main:
    # Initialize the game
    # Call your initialization functions here (e.g., setting up the game grid, etc.)

    # Draw the game grid or UI elements
    li $t1, 0x808080          # Gray color for the lines
    lw $t0, ADDR_DSPL         # Load base address of display

    # Draw the left vertical line
    li $a0, 10                # Start at row 10
    li $a1, 7                 # Start at column 8
    li $a2, 16                # Height of the vertical line (16 pixels)
    jal draw_vertical_line

    # Draw the right vertical line
    li $a0, 10                # Start at row 10
    li $a1, 23                # Start at column 23
    li $a2, 16                # Height of the vertical line (16 pixels)
    jal draw_vertical_line

    # Draw the bottom horizontal line
    li $a0, 26                # Start at row 26
    li $a1, 8                 # Start at column 9
    li $a2, 22                # End at column 22
    jal draw_horizontal_line

    # Draw the top horizontal line with a 4-pixel gap in the middle
    li $a0, 9                 # Start at row 9
    li $a1, 8                 # Start at column 9
    li $a2, 11                # End column for the left part (12)
    jal draw_horizontal_line

    # Draw the right part of the top horizontal line
    li $a0, 9                 # Start at row 9
    li $a1, 19                # Start at column 19
    li $a2, 22                # End at column 22
    jal draw_horizontal_line

    # Draw the 2 vertical lines that are protruding out of the gap
    li $a0, 7                 # Start at row 7
    li $a1, 12                # Start at column 13
    li $a2, 2                 # Height of the vertical line (2 pixels)
    jal draw_vertical_line

    li $a0, 7                 # Start at row 7
    li $a1, 18                # Start at column 18
    li $a2, 2                 # Height of the vertical line (2 pixels)
    jal draw_vertical_line

    # Draw additional vertical lines for the design
    li $a0, 5                 # Start at row 5
    li $a1, 11                # Start at column 12
    li $a2, 2                 # Height of the vertical line (2 pixels)
    jal draw_vertical_line

    li $a0, 5                 # Start at row 5
    li $a1, 19                # Start at column 19
    li $a2, 2                 # Height of the vertical line (2 pixels)
    jal draw_vertical_line

    # Draw the initial capsule in the middle of the gap
    jal draw_initial_capsule
    j game_loop

game_loop:
    # 1. Read the keyboard status
    lw $t0, ADDR_KBRD
    lw $t1, 0($t0)

    # 2. Check if a key is pressed
    beqz $t1, no_input       # If no key, skip input processing

    # 3. Read the key value
    lw $t2, 4($t0)

    # 4. Print the key value (optional, for debugging)
    li $v0, 1
    move $a0, $t2
    syscall

    li $t3, 0x61             # ASCII value for 'a' (move left)
    li $t4, 0x64             # ASCII value for 'd' (move right)
    li $t5, 0x77             # ASCII value for 'w' (move up)
    li $t6, 0x73             # ASCII value for 's' (move down)
    li $t7, 0x72             # ASCII value for 'r' (rotate)
    li $t8, 0x71             # ASCII value for 'q' (quit)

    beq $t2, $t3, move_left  # If 'a' is pressed, move left
    beq $t2, $t4, move_right # If 'd' is pressed, move right
    beq $t2, $t5, move_up    # If 'w' is pressed, move up
    beq $t2, $t6, move_down  # If 's' is pressed, move down
    beq $t2, $t7, rotate  # If 's' is pressed, move down
    beq $t2, $t8, quit       # if 'q' is pressed, quit

no_input:
    # 5. Sleep for approximately 16 ms (60 FPS)
    jal sleep

    # 6. Loop back to Step 1
    j game_loop

# Function to sleep for approximately 16.67 ms (60 FPS)
sleep:
    # Debug: Print "Sleeping..."
    li $v0, 4                # Syscall for printing a string
    la $a0, sleeping_msg     # Load address of the string
    syscall

    # Sleep for 16 ms
    li $v0, 32               # Syscall for sleep
    li $a0, 16               # Sleep for 16 ms (approximately 60 FPS)
    syscall

    jr $ra                   # Return to caller
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

# Function to draw the initial capsule
draw_initial_capsule:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Generate random colors for the capsule halves
    jal get_random_color       # Get random color for the first half
    move $s0, $v0             # Save first color in $s0
    jal get_random_color       # Get random color for the second half
    move $s1, $v0             # Save second color in $s1

    # Draw the first half of the capsule
    lw $a0, CAPSULE_ROW_FIRST       # Row for the capsule
    lw $a1, CAPSULE_COL_FIRST      # Column for the capsule
    move $a2, $s0             # Color for the first half
    jal draw_pixel             # Draw the first half

    lw $a0, CAPSULE_ROW_SECOND      # Row for the capsule
    lw $a1, CAPSULE_COL_SECOND       # Column for the capsule
    move $a2, $s1             # Color for the second half
    jal draw_pixel             # Draw the second half

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function to get a random color
get_random_color:
    # Load the address of the colors
    la $t0, COLOR_RED         # Load address of COLOR_RED
    la $t1, COLOR_GREEN       # Load address of COLOR_GREEN
    la $t2, COLOR_BLUE        # Load address of COLOR_BLUE

    # Generate a random number between 0 and 2
    li $v0, 42                # Syscall for random number
    li $a0, 0                 # Random number generator ID
    li $a1, 3                 # Upper bound (exclusive)
    syscall

    # Use the random number to select a color
    beq $a0, 0, select_red    # If 0, select red
    beq $a0, 1, select_green  # If 1, select green
    beq $a0, 2, select_blue   # If 2, select blue

select_red:
    lw $v0, 0($t0)            # Load red color
    jr $ra

select_green:
    lw $v0, 0($t1)            # Load green color
    jr $ra

select_blue:
    lw $v0, 0($t2)            # Load blue color
    jr $ra

# Function to draw a pixel
# Arguments: $a0 = row, $a1 = column, $a2 = color
draw_pixel:
    lw $t0, ADDR_DSPL         # Load base address of display
    li $t1, 128               # Row offset (128 bytes per row)
    mul $t2, $a0, $t1         # Row offset = row * 128
    li $t3, 4                 # Each unit is 4 bytes
    mul $t4, $a1, $t3         # Column offset = column * 4
    add $t5, $t2, $t4         # Total offset = row offset + column offset
    addu $t6, $t0, $t5        # Starting address = base address + offset
    sw $a2, 0($t6)            # Write pixel to the display
    jr $ra

rotate:
    lw $a0, CAPSULE_ROW_FIRST      # Load current row
    lw $a1, CAPSULE_COL_FIRST      # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current position

  # Erase the old capsule (draw it with background color)
    lw $a0, CAPSULE_ROW_SECOND      # Load current row
    lw $a1, CAPSULE_COL_SECOND     # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current positions
    
    # Check the current position and rotate accordingly
    lw $t0, CAPSULE_ROW_FIRST
    lw $t1, CAPSULE_COL_FIRST
    lw $t2, CAPSULE_ROW_SECOND
    lw $t3, CAPSULE_COL_SECOND

    # If the rows are equal, the capsule is sideways
    beq $t0, $t2, was_sideways     # If first and second rows are equal, it's sideways

    # If the columns are equal, the capsule is upright
    beq $t1, $t3, was_up           # If first and second columns are equal, it's up

was_sideways:
    # Handle sideways rotation: Capsule is horizontal (left to right or right to left)
    # Check which way the capsule is facing (left or right)
    # If the first column is smaller than the second, it means the capsule is left-to-right.
    blt $t1, $t3, rotate_left_to_bottom
    j rotate_right_to_top

rotate_left_to_bottom:
    lw $t0, CAPSULE_COL_FIRST      # Load current column
    addi $t0, $t0, +1        # Decrease by 1 to move left
    sw $t0, CAPSULE_COL_FIRST      # Save new column

    lw $t0, CAPSULE_ROW_FIRST      # Load current column
    addi $t0, $t0, +1        # Decrease by 1 to move left
    sw $t0, CAPSULE_ROW_FIRST      # Save new column

    # Draw the capsule at the new position
    jal draw_capsule
    j game_loop

rotate_right_to_top:
    lw $t0, CAPSULE_COL_FIRST      # Load current column
    addi $t0, $t0, -1        # Decrease by 1 to move left
    sw $t0, CAPSULE_COL_FIRST      # Save new column

    lw $t0, CAPSULE_ROW_FIRST      # Load current column
    addi $t0, $t0, -1        # Decrease by 1 to move left
    sw $t0, CAPSULE_ROW_FIRST      # Save new column

    # Draw the capsule at the new position
    jal draw_capsule
    j game_loop

was_up:
    # Handle upright rotation: Capsule is vertical (top to bottom or bottom to top)
    # Check if first segment's row is smaller than the second's row (top to bottom)
    blt $t0, $t2, rotate_top_to_left
    j rotate_bottom_to_right

rotate_top_to_left:
    lw $t0, CAPSULE_COL_FIRST      # Load current column
    addi $t0, $t0, -1        # Decrease by 1 to move left
    sw $t0, CAPSULE_COL_FIRST      # Save new column

    lw $t0, CAPSULE_ROW_FIRST      # Load current column
    addi $t0, $t0, +1        # Decrease by 1 to move left
    sw $t0, CAPSULE_ROW_FIRST      # Save new column

    # Draw the capsule at the new position
    jal draw_capsule
    j game_loop

rotate_bottom_to_right:
    lw $t0, CAPSULE_COL_FIRST      # Load current column
    addi $t0, $t0, +1        # Decrease by 1 to move left
    sw $t0, CAPSULE_COL_FIRST      # Save new column

    lw $t0, CAPSULE_ROW_FIRST      # Load current column
    addi $t0, $t0, -1        # Decrease by 1 to move left
    sw $t0, CAPSULE_ROW_FIRST      # Save new column

    # Draw the capsule at the new position
    jal draw_capsule
    j game_loop
    
# Function to move the capsule left
move_left:
    # Erase the old capsule (draw it with background color)
    lw $a0, CAPSULE_ROW_FIRST      # Load current row
    lw $a1, CAPSULE_COL_FIRST      # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current position

  # Erase the old capsule (draw it with background color)
    lw $a0, CAPSULE_ROW_SECOND      # Load current row
    lw $a1, CAPSULE_COL_SECOND     # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current position

    # Update capsule's column
    lw $t0, CAPSULE_COL_FIRST      # Load current column
    addi $t0, $t0, -1        # Decrease by 1 to move left
    sw $t0, CAPSULE_COL_FIRST      # Save new column

    lw $t0, CAPSULE_COL_SECOND      # Load current column
    addi $t0, $t0, -1        # Decrease by 1 to move left
    sw $t0, CAPSULE_COL_SECOND      # Save new column

    # Draw the capsule at the new position
    jal draw_capsule
    j game_loop


# Function to move the capsule right
move_right:
    # Erase the old capsule (draw it with background color)
    lw $a0, CAPSULE_ROW_FIRST      # Load current row
    lw $a1, CAPSULE_COL_FIRST     # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current position

    # Erase the old capsule (draw it with background color)
    lw $a0, CAPSULE_ROW_SECOND      # Load current row
    lw $a1, CAPSULE_COL_SECOND      # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current position

    # Update capsule's column
    lw $t0, CAPSULE_COL_FIRST      # Load current column
    addi $t0, $t0, 1         # Increase by 1 to move right
    sw $t0, CAPSULE_COL_FIRST      # Save new column

    lw $t0, CAPSULE_COL_SECOND      # Load current column
    addi $t0, $t0, 1         # Increase by 1 to move right
    sw $t0, CAPSULE_COL_SECOND      # Save new column

    # Draw the capsule at the new position
    jal draw_capsule
    j game_loop

# Function to move the capsule up
move_up:
    # Erase the old capsule (draw it with background color)
    lw $a0, CAPSULE_ROW_FIRST      # Load current row
    lw $a1, CAPSULE_COL_FIRST      # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current position

    lw $a0, CAPSULE_ROW_SECOND      # Load current row
    lw $a1, CAPSULE_COL_SECOND      # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current position

    # Update capsule's row
    lw $t0, CAPSULE_ROW_FIRST      # Load current row
    addi $t0, $t0, -1        # Decrease by 1 to move up
    sw $t0, CAPSULE_ROW_FIRST      # Save new row

    # Update capsule's row
    lw $t0, CAPSULE_ROW_SECOND      # Load current row
    addi $t0, $t0, -1        # Decrease by 1 to move up
    sw $t0, CAPSULE_ROW_SECOND      # Save new row

    # Draw the capsule at the new position
    jal draw_capsule
    j game_loop

quit:
  # Exit the program
    li $v0, 10               # Syscall for exit
    syscall

# Function to move the capsule down
move_down:
    # Erase the old capsule (draw it with background color)
    lw $a0, CAPSULE_ROW_FIRST      # Load current row
    lw $a1, CAPSULE_COL_FIRST      # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current position

    lw $a0, CAPSULE_ROW_SECOND      # Load current row
    lw $a1, CAPSULE_COL_SECOND      # Load current column
    li $a2, 0x000000         # Background color (black)
    jal erase_capsule        # Erase the capsule at the current position

    # Update capsule's row
    lw $t0, CAPSULE_ROW_FIRST      # Load current row
    addi $t0, $t0, 1         # Increase by 1 to move down
    sw $t0, CAPSULE_ROW_FIRST      # Save new row

    # Update capsule's row
    lw $t0, CAPSULE_ROW_SECOND      # Load current row
    addi $t0, $t0, 1         # Increase by 1 to move down
    sw $t0, CAPSULE_ROW_SECOND      # Save new row

    # Draw the capsule at the new position
    jal draw_capsule
    j game_loop
    
# Function to erase the pixel (background color)
erase_pixel:
    lw $t0, ADDR_DSPL        # Load base address of display
    li $t1, 128              # Row offset (128 bytes per row)
    mul $t2, $a0, $t1        # Row offset = row * 128
    li $t3, 4                # Each unit is 4 bytes
    mul $t4, $a1, $t3        # Column offset = column * 4
    add $t5, $t2, $t4        # Total offset = row offset + column offset
    addu $t6, $t0, $t5       # Starting address = base address + offset
    sw $a2, 0($t6)           # Write background color to the location
    jr $ra
    
# Function to draw the capsule at the new position
# Function to erase the capsule
erase_capsule:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Erase the first half of the capsule
    li $a2, 0x000000         # Black color (background)
    jal draw_pixel

    # Erase the second half of the capsule
    addi $a0, $a0, 1         # Move to the next row
    jal draw_pixel

    # Restore return address
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
draw_capsule:
    # Draw the first half of the capsule
    lw $a0, CAPSULE_ROW_FIRST      # Row for the capsule
    lw $a1, CAPSULE_COL_FIRST      # Column for the capsule
    move $a2, $s0            # Color for the first half
    jal draw_pixel

    # Draw the first half of the capsule
    lw $a0, CAPSULE_ROW_SECOND      # Row for the capsule
    lw $a1, CAPSULE_COL_SECOND      # Column for the capsule
    move $a2, $s1            # Color for the second half
    jal draw_pixel
    j game_loop

.data
    moving_left:   .asciiz "moving left\n"
    moving_right:  .asciiz "moving right\n"
    moving_up:     .asciiz "moving up\n"
    moving_down:   .asciiz "moving down\n"
    sleeping_msg: .asciiz "Sleeping...\n"