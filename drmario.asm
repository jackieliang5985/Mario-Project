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

  # Initial capsule positions (middle of the gap)
  CAPSULE_ROW_FIRST_INITIAL:  .word 7         # Initial row for the first part
  CAPSULE_COL_FIRST_INITIAL:  .word 15        # Initial column for the first part
  CAPSULE_ROW_SECOND_INITIAL: .word 8         # Initial row for the second part
  CAPSULE_COL_SECOND_INITIAL: .word 15        # Initial column for the second part

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

      jal get_random_color       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0
      
      
      jal get_random_location
      move $a1, $v0


      jal get_random_location
      move $a0, $v0            # Color for the first half
      
      jal draw_pixel             # Draw the first halfs
      
      # Draw the initial capsule in the middle of the gap
      jal draw_initial_capsule
      j game_loop
  
  game_loop:
      # 1. Read the keyboard status
      lw $t0, ADDR_KBRD
      lw $t1, 0($t0)
  
      beqz $t1, no_input       # If no key, skip input processing
  
     # 1b. Check which key has been pressed
      lw $t2, 4($t0)
  
      # Print the key value (optional, for debugging)
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
      # beq $t2, $t5, move_up    # If 'w' is pressed, move up
      beq $t2, $t6, move_down  # If 's' is pressed, move down
      beq $t2, $t7, rotate  # If 's' is pressed, move down
      beq $t2, $t8, quit       # if 'q' is pressed, quit
      j game_loop
  
  
  no_input:
      # 5. Sleep for approximately 16 ms (60 FPS)
      # jal sleep
      # j move_down
  
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
      li $a0, 60               # Sleep for 200 ms (approximately 60 FPS)
      syscall
      j move_down
  
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


  get_random_location:
      # Generate a random number between 0 and 2
      li $v0, 42                # Syscall for random number
      li $a0, 0                 # Random number generator ID
      li $a3, 7                 # Upper bound (exclusive)
      syscall
  
      # Use the random number to select a color
      beq $a0, 0, select_four    # If 0, select red
      beq $a0, 1, select_five  # If 1, select green
      beq $a0, 2, select_six   # If 2, select blue
      beq $a0, 3, select_seven    # If 0, select red
      beq $a0, 4, select_eight  # If 1, select green
      beq $a0, 5, select_nine   # If 2, select blue

  select_four:
      li $v0, 14           # Load red color
      jr $ra
  
  select_five:
      li $v0, 16            # Load green color
      jr $ra
  
  select_six:
      li $v0, 17            # Load blue color
      jr $ra

  select_seven:
      li $v0, 18           # Load red color
      jr $ra
  
  select_eight:
      li $v0, 19            # Load green color
      jr $ra
  
  select_nine:
      li $v0, 20            # Load blue color
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

  # Function to check if a pixel is black (unoccupied)
# Arguments: $a0 = row, $a1 = column
# Returns: $v0 = 1 if pixel is black, 0 otherwise
check_pixel:
    lw $t0, ADDR_DSPL         # Load base address of display
    li $t1, 128               # Row offset (128 bytes per row)
    mul $t2, $a0, $t1         # Row offset = row * 128
    li $t3, 4                 # Each unit is 4 bytes
    mul $t4, $a1, $t3         # Column offset = column * 4
    add $t5, $t2, $t4         # Total offset = row offset + column offset
    addu $t6, $t0, $t5        # Starting address = base address + offset
    lw $t7, 0($t6)            # Load the color of the pixel
    li $v0, 0                 # Assume pixel is not black
    beq $t7, 0x000000, pixel_is_black  # If pixel is black, set $v0 = 1
    jr $ra                    # Return 0 (pixel is not black)

  pixel_is_black:
      li $v0, 1                 # Pixel is black
      jr $ra
  
    # Function to check capsule orientation
  # Returns: $v0 = 0 if vertical, 1 if horizontal
  check_orientation:
      lw $t0, CAPSULE_ROW_FIRST
      lw $t1, CAPSULE_ROW_SECOND
      beq $t0, $t1, horizontal_orientation  # If rows are equal, capsule is horizontal
      li $v0, 0                            # Otherwise, capsule is vertical
      jr $ra
  
  horizontal_orientation:
      li $v0, 1
      jr $ra
  
  find_leftmost_rightmost:
      lw $t0, CAPSULE_COL_FIRST      # Load column of the first part
      lw $t1, CAPSULE_COL_SECOND     # Load column of the second part
      blt $t0, $t1, leftmost_first   # If first part is leftmost, jump
      move $v0, $t1                  # Otherwise, second part is leftmost
      move $v1, $t0                  # First part is rightmost
      jr $ra
  
  leftmost_first:
      move $v0, $t0                  # First part is leftmost
      move $v1, $t1                  # Second part is rightmost
      jr $ra

  rotate:
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
      beq $t0, 25, no_rotate
      blt $t1, $t3, rotate_left_to_bottom
      j rotate_right_to_top
  
  rotate_left_to_bottom:
      lw $a0, CAPSULE_ROW_FIRST      # Load current row
      lw $a1, CAPSULE_COL_FIRST      # Load current column
      li $a2, 0x000000         # Background color (black)
      jal erase_capsule        # Erase the capsule at the current position
  
    # Erase the old capsule (draw it with background color)
      lw $a0, CAPSULE_ROW_SECOND      # Load current row
      lw $a1, CAPSULE_COL_SECOND     # Load current column
      li $a2, 0x000000         # Background color (black)
      jal erase_capsule        # Erase the capsule at the current positions
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
      lw $a0, CAPSULE_ROW_FIRST      # Load current row
      lw $a1, CAPSULE_COL_FIRST      # Load current column
      li $a2, 0x000000         # Background color (black)
      jal erase_capsule        # Erase the capsule at the current position
  
    # Erase the old capsule (draw it with background color)
      lw $a0, CAPSULE_ROW_SECOND      # Load current row
      lw $a1, CAPSULE_COL_SECOND     # Load current column
      li $a2, 0x000000         # Background color (black)
      jal erase_capsule        # Erase the capsule at the current positions
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
      beq $t1, 8, no_rotate
      lw $a0, CAPSULE_ROW_FIRST      # Load current row
      lw $a1, CAPSULE_COL_FIRST      # Load current column
      li $a2, 0x000000         # Background color (black)
      jal erase_capsule        # Erase the capsule at the current position
  
    # Erase the old capsule (draw it with background color)
      lw $a0, CAPSULE_ROW_SECOND      # Load current row
      lw $a1, CAPSULE_COL_SECOND     # Load current column
      li $a2, 0x000000         # Background color (black)
      jal erase_capsule        # Erase the capsule at the current positions
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
      beq $t1, 22, no_rotate
      lw $a0, CAPSULE_ROW_FIRST      # Load current row
      lw $a1, CAPSULE_COL_FIRST      # Load current column
      li $a2, 0x000000         # Background color (black)
      jal erase_capsule        # Erase the capsule at the current position
  
    # Erase the old capsule (draw it with background color)
      lw $a0, CAPSULE_ROW_SECOND      # Load current row
      lw $a1, CAPSULE_COL_SECOND     # Load current column
      li $a2, 0x000000         # Background color (black)
      jal erase_capsule        # Erase the capsule at the current positions
      lw $t0, CAPSULE_COL_FIRST      # Load current column
      addi $t0, $t0, +1        # Decrease by 1 to move left
      sw $t0, CAPSULE_COL_FIRST      # Save new column
  
      lw $t0, CAPSULE_ROW_FIRST      # Load current column
      addi $t0, $t0, -1        # Decrease by 1 to move left
      sw $t0, CAPSULE_ROW_FIRST      # Save new column
  
      # Draw the capsule at the new position
      jal draw_capsule
      j game_loop

  no_rotate:
    j game_loop
    # Function to move the capsule left
  # Function to move the capsule left
  move_left:
      # Check capsule orientation
      jal check_orientation
      beqz $v0, vertical_left  # If vertical, handle vertical movement
      j horizontal_left        # If horizontal, handle horizontal movement
  
  vertical_left:
      # Check the pixel to the left of the capsule
      lw $a0, CAPSULE_ROW_FIRST
      lw $a1, CAPSULE_COL_FIRST
      addi $a1, $a1, -1           # Check the column to the left
      jal check_pixel             # Check if the pixel is black
      beqz $v0, no_move_left      # If not black, do not move

      lw $a0, CAPSULE_ROW_SECOND
      lw $a1, CAPSULE_COL_SECOND
      addi $a1, $a1, -1           # Check the column to the left
      jal check_pixel             # Check if the pixel is black
      beqz $v0, no_move_left      # If not black, do not move
      j update_left               # Otherwise, update position

  horizontal_left:
      # Find the leftmost part of the capsule
      jal find_leftmost_rightmost
      move $a1, $v0               # Use the column of the leftmost part
  
      # Check the pixel to the left of the leftmost part
      lw $a0, CAPSULE_ROW_FIRST   # Use the row of the capsule
      addi $a1, $a1, -1           # Check the column to the left
      jal check_pixel             # Check if the pixel is black
      beqz $v0, no_move_left      # If not black, do not move

  update_left:
      # Erase the old capsule
      jal erase_capsule
  
      # Update capsule's column (move left)
      lw $t0, CAPSULE_COL_FIRST
      addi $t0, $t0, -1           # Decrease by 1 to move left
      sw $t0, CAPSULE_COL_FIRST
  
      lw $t0, CAPSULE_COL_SECOND
      addi $t0, $t0, -1           # Decrease by 1 to move left
      sw $t0, CAPSULE_COL_SECOND
  
      # Draw the capsule at the new position
      jal draw_capsule
      j game_loop

  no_move_left:
      j game_loop                 # Do nothing if movement is blocked
      
  
   # Function to move the capsule right
  move_right:
      # Check capsule orientation
      jal check_orientation
      beqz $v0, vertical_right  # If vertical, handle vertical movement
      j horizontal_right        # If horizontal, handle horizontal movement
  
  vertical_right:
      # Check the pixel to the right of the capsule
      lw $a0, CAPSULE_ROW_FIRST
      lw $a1, CAPSULE_COL_FIRST
      addi $a1, $a1, 1            # Check the column to the right
      jal check_pixel             # Check if the pixel is black
      beqz $v0, no_move_right     # If not black, do not move

      lw $a0, CAPSULE_ROW_SECOND
      lw $a1, CAPSULE_COL_SECOND
      addi $a1, $a1, 1            # Check the column to the right
      jal check_pixel             # Check if the pixel is black
      beqz $v0, no_move_right     # If not black, do not move
      j update_right              # Otherwise, update position

  horizontal_right:
      # Find the rightmost part of the capsule
      jal find_leftmost_rightmost
      move $a1, $v1               # Use the column of the rightmost part
  
      # Check the pixel to the right of the rightmost part
      lw $a0, CAPSULE_ROW_FIRST   # Use the row of the capsule
      addi $a1, $a1, 1            # Check the column to the right
      jal check_pixel             # Check if the pixel is black
      beqz $v0, no_move_right     # If not black, do not move

  update_right:
      # Erase the old capsule
      jal erase_capsule
  
      # Update capsule's column (move right)
      lw $t0, CAPSULE_COL_FIRST
      addi $t0, $t0, 1            # Increase by 1 to move right
      sw $t0, CAPSULE_COL_FIRST
  
      lw $t0, CAPSULE_COL_SECOND
      addi $t0, $t0, 1            # Increase by 1 to move right
      sw $t0, CAPSULE_COL_SECOND
  
      # Draw the capsule at the new position
      jal draw_capsule
      j game_loop

  no_move_right:
      j game_loop                 # Do nothing if movement is blocked
      
  quit:
    # Exit the program
      li $v0, 10               # Syscall for exit
      syscall
  
  # Function to move the capsule down
  move_down:
      # Check capsule orientation
      jal check_orientation
      beqz $v0, vertical_down  # If vertical, handle vertical movement
      j horizontal_down        # If horizontal, handle horizontal movement
  
  vertical_down:
      # Determine which part of the capsule is the bottommost
      lw $t0, CAPSULE_ROW_FIRST   # Load row of the first part
      lw $t1, CAPSULE_ROW_SECOND  # Load row of the second part
  
      # Compare the rows to find the bottommost pixel
      bge $t0, $t1, first_is_bottom  # If first row >= second row, first is bottom
      j second_is_bottom             # Otherwise, second is bottom
  
  first_is_bottom:
      # First part is the bottommost
      move $a0, $t0                 # Use the row of the first part
      lw $a1, CAPSULE_COL_FIRST     # Use the column of the first part
      j check_below
  
  second_is_bottom:
      # Second part is the bottommost
      move $a0, $t1                 # Use the row of the second part
      lw $a1, CAPSULE_COL_SECOND    # Use the column of the second part
  
  check_below:
      # Check the pixel below the bottommost part
      addi $a0, $a0, 1              # Check the row below
      jal check_pixel               # Check if the pixel is black
      beqz $v0, place_capsule       # If not black, place the capsule and initialize a new one
      j update_down                 # Otherwise, update position
  
  horizontal_down:
      # Check the pixel below the first part of the capsule
      lw $a0, CAPSULE_ROW_FIRST
      lw $a1, CAPSULE_COL_FIRST
      addi $a0, $a0, 1            # Check the row below
      jal check_pixel             # Check if the pixel is black
      beqz $v0, place_capsule     # If not black, place the capsule and initialize a new one
  
      # Check the pixel below the second part of the capsule
      lw $a0, CAPSULE_ROW_SECOND
      lw $a1, CAPSULE_COL_SECOND
      addi $a0, $a0, 1            # Check the row below
      jal check_pixel             # Check if the pixel is black
      beqz $v0, place_capsule     # If not black, place the capsule and initialize a new one
  
  update_down:
      # Erase the old capsule
      jal erase_capsule
  
      # Update capsule's row (move down)
      lw $t0, CAPSULE_ROW_FIRST
      addi $t0, $t0, 1            # Increase by 1 to move down
      sw $t0, CAPSULE_ROW_FIRST
  
      lw $t0, CAPSULE_ROW_SECOND
      addi $t0, $t0, 1            # Increase by 1 to move down
      sw $t0, CAPSULE_ROW_SECOND
  
      # Draw the capsule at the new position
      jal draw_capsule
      j game_loop
  
  place_capsule:
      # Color the current position of the capsule
      lw $a0, CAPSULE_ROW_FIRST
      lw $a1, CAPSULE_COL_FIRST
      move $a2, $s0            # Color for the first half
      jal draw_pixel
  
      lw $a0, CAPSULE_ROW_SECOND
      lw $a1, CAPSULE_COL_SECOND
      move $a2, $s1            # Color for the second half
      jal draw_pixel

      jal check_row_neighbors
  
      # Reset capsule position to the initial position (middle of the gap)
      lw $t0, CAPSULE_ROW_FIRST_INITIAL  # Load initial row for the first part
      sw $t0, CAPSULE_ROW_FIRST          # Reset to initial row
      lw $t0, CAPSULE_COL_FIRST_INITIAL  # Load initial column for the first part
      sw $t0, CAPSULE_COL_FIRST          # Reset to initial column
  
      lw $t0, CAPSULE_ROW_SECOND_INITIAL # Load initial row for the second part
      sw $t0, CAPSULE_ROW_SECOND         # Reset to initial row
      lw $t0, CAPSULE_COL_SECOND_INITIAL # Load initial column for the second part
      sw $t0, CAPSULE_COL_SECOND         # Reset to initial column
  
      # Initialize a new capsule
      jal draw_initial_capsule
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
  
      # Check if the first part of the capsule is on the bottom line
      lw $t0, CAPSULE_ROW_FIRST      # Load current row of the first part
      li $t1, 26                     # Bottom row
      beq $t0, $t1, skip_erase_first  # If on the bottom row, skip erasing the first part
  
      # Erase the first half of the capsule
      lw $a0, CAPSULE_ROW_FIRST      # Row for the capsule
      lw $a1, CAPSULE_COL_FIRST      # Column for the capsule
      li $a2, 0x000000               # Background color (black)
      jal draw_pixel                 # Erase the first part
  
  skip_erase_first:
      # Check if the second part of the capsule is on the bottom line
      lw $t0, CAPSULE_ROW_SECOND     # Load current row of the second part
      li $t1, 26                     # Bottom row
      beq $t0, $t1, skip_erase_second # If on the bottom row, skip erasing the second part
  
      # Erase the second half of the capsule
      lw $a0, CAPSULE_ROW_SECOND     # Row for the capsule
      lw $a1, CAPSULE_COL_SECOND     # Column for the capsule
      li $a2, 0x000000               # Background color (black)
      jal draw_pixel                 # Erase the second part
  
  skip_erase_second:
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

check_row_neighbors:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Check row neighbors for the first pixel
    lw $a0, CAPSULE_ROW_FIRST      # Row for the first pixel
    lw $a1, CAPSULE_COL_FIRST      # Column for the first pixel
    move $a2, $s0                  # Color for the first pixel
    jal check_left_and_right        # Check left and right neighbors for the first pixel

    # If 3 or more same-colored pixels, delete them
    li $t0, 3
    bge $s2, $t0, delete_pixels     # If count >= 3, delete the pixels

    # Print the result for the first pixel
    li $v0, 4
    la $a0, first_pixel_msg
    syscall

    li $v0, 1
    move $a0, $s2                  # Print the count of same-colored neighbors
    syscall

    li $v0, 4
    la $a0, newline_msg
    syscall

    # Check row neighbors for the second pixel
    lw $a0, CAPSULE_ROW_SECOND     # Row for the second pixel
    lw $a1, CAPSULE_COL_SECOND     # Column for the second pixel
    move $a2, $s1                  # Color for the second pixel
    jal check_left_and_right        # Check left and right neighbors for the second pixel

    # If 3 or more same-colored pixels, delete them
    li $t0, 3
    bge $s2, $t0, delete_pixels     # If count >= 3, delete the pixels

    # Print the result for the second pixel
    li $v0, 4
    la $a0, second_pixel_msg
    syscall

    li $v0, 1
    move $a0, $s2                  # Print the count of same-colored neighbors
    syscall

    li $v0, 4
    la $a0, newline_msg
    syscall

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function to check left and right neighbors for a single pixel
# Arguments: $a0 = row, $a1 = column, $a2 = color
# Returns: $s2 = count of same-colored neighbors in the row
check_left_and_right:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize counter for same-colored pixels
    li $s2, 0  # Counter for same-colored pixels in the row

    # Save the original column for left checking
    move $t7, $a1

    # Check to the right
    jal check_right_for_pixel

    # Restore the original column for left checking
    move $a1, $t7

    # Check to the left
    jal check_left_for_pixel

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function to check right neighbors for a single pixel
# Arguments: $a0 = row, $a1 = column, $a2 = color
# Returns: $s2 = count of same-colored neighbors to the right
check_right_for_pixel:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

check_right_loop:
    # Check the pixel to the right
    addi $a1, $a1, 1            # Move to the next column to the right
    jal check_pixel_color       # Check the color of the pixel

    # Compare the color with the capsule color
    bne $v0, $a2, check_right_done  # If colors don't match, exit the loop

    # Increment the counter
    addi $s2, $s2, 1

    # Continue checking to the right
    j check_right_loop

check_right_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function to check left neighbors for a single pixel
# Arguments: $a0 = row, $a1 = column, $a2 = color
# Returns: $s2 = count of same-colored neighbors to the left
check_left_for_pixel:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

check_left_loop:
    # Check the pixel to the left
    addi $a1, $a1, -1           # Move to the next column to the left
    jal check_pixel_color       # Check the color of the pixel

    # Compare the color with the capsule color
    bne $v0, $a2, check_left_done  # If colors don't match, exit the loop

    # Increment the counter
    addi $s2, $s2, 1

    # Continue checking to the left
    j check_left_loop

check_left_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

delete_pixels:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Delete the pixels in the row
    jal delete_row_pixels

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

delete_row_pixels:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Delete pixels to the right
    jal delete_right_pixels

    # Delete pixels to the left
    jal delete_left_pixels

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

delete_right_pixels:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

delete_right_loop:
    # Check the pixel to the right
    addi $a1, $a1, 1            # Move to the next column to the right
    jal check_pixel_color       # Check the color of the pixel

    # Compare the color with the capsule color
    bne $v0, $a2, delete_right_done  # If colors don't match, exit the loop

    # Delete the pixel (set it to black)
    li $a2, 0x000000            # Background color (black)
    jal draw_pixel              # Erase the pixel

    # Continue deleting to the right
    j delete_right_loop

delete_right_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

delete_left_pixels:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

delete_left_loop:
    # Check the pixel to the left
    addi $a1, $a1, -1           # Move to the next column to the left
    jal check_pixel_color       # Check the color of the pixel

    # Compare the color with the capsule color
    bne $v0, $a2, delete_left_done  # If colors don't match, exit the loop

    # Delete the pixel (set it to black)
    li $a2, 0x000000            # Background color (black)
    jal draw_pixel              # Erase the pixel

    # Continue deleting to the left
    j delete_left_loop

delete_left_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function to check the color of a pixel
# Input: $a0 = row, $a1 = column
# Output: $v0 = color of the pixel at (row, column)
check_pixel_color:
    # Load base address of the display
    lw $t0, ADDR_DSPL         # Load base address of display

    # Calculate the offset for the given row and column
    li $t1, 128               # Number of bytes per row (32 columns * 4 bytes per pixel)
    mul $t2, $a0, $t1         # Row offset = row * 128
    li $t3, 4                 # Each pixel is 4 bytes
    mul $t4, $a1, $t3         # Column offset = column * 4
    add $t5, $t2, $t4         # Total offset = row offset + column offset
    addu $t6, $t0, $t5        # Pixel address = base address + offset

    # Load the color of the pixel
    lw $v0, 0($t6)            # Load the color of the pixel
    jr $ra                    # Return the color in $v0
      
  
  .data
      moving_left:   .asciiz "moving left\n"
      moving_right:  .asciiz "moving right\n"
      moving_up:     .asciiz "moving up\n"
      moving_down:   .asciiz "moving down\n"
      sleeping_msg: .asciiz "Sleeping...\n"
      same_color_right_msg: .asciiz "Same-colored pixels to the right: "
    first_pixel_msg:  .asciiz "First pixel - Same-colored pixels in the row: "
    second_pixel_msg: .asciiz "Second pixel - Same-colored pixels in the row: "
    newline_msg:      .asciiz "\n"