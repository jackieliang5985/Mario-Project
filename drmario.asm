  ################# CSC258 Assembly Final Project ###################
  # This file contains our implementation of Dr Mario.
  #
  # Student 1: Thanush Lingeswaran, 1010292586
  # Student 2: Jackie Liang, 1010279119
  #
  # We assert that the code submitted here is entirely our own 
  # creation, and will indicate otherwise when it is not.
  #
  ######################## Bitmap Display Configuration ########################
  # - Unit width in pixels:       8
  # - Unit height in pixels:      8
  # - Display width in pixels:    256
  # - Display height in pixels:   256
  # - Base Address for Display:   0x10008000 ($gp)
  ##############################################################################

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
  COLOR_GREEN:  .word 0xffff00  # yellow
  COLOR_BLUE:   .word 0x0000ff  # Blue
  COLOR_BLUER:  .word 0x90d5df
  COLOR_EXTRA_BLUE: .word 0x00bfff
  COLOR_WHITE:  .word 0xFFFFFF  # White
  COLOR_BLACK:  .word 0x000000  # Black

  COLOR_VIRUS_RED:    .word 0xed2939  # Virus-Red
  COLOR_VIRUS_GREEN:  .word 0xffd300  # Virus-ellow
  COLOR_VIRUS_BLUE:   .word 0x0041c2  # Virus-Blue

  COLOR_SKIN:    .word 0xFCD8A8  # Peach skin tone
  COLOR_HAIR:    .word 0x887000  # Brown hair (this is also used for his seth)
  COLOR_REDCROSS: .word 0xFF0000 # Red cross

  # Capsule position (middle of the gap)
  CAPSULE_ROW_FIRST:  .word 7         # Row for the capsule (middle of the gap)
  CAPSULE_COL_FIRST:  .word 15        # Column for the capsule (middle of the gap)
  CAPSULE_ROW_SECOND: .word 8         # Row for the capsule (middle of the gap)
  CAPSULE_COL_SECOND: .word 15        # Column for the capsule (middle of the gap)

  VIRUS_ROW_FIRST: .word 14
  VIRUS_COLUMN_FIRST: .word 16
  VIRUS_ROW_SECOND: .word 14
  VIRUS_COLUMN_SECOND: .word 16
  VIRUS_ROW_THIRD: .word 14
  VIRUS_COLUMN_THIRD: .word 16
  VIRUS_ROW_FOURTH: .word 14
  VIRUS_COLUMN_FOURTH: .word 16
  VIRUS_COUNT: .word 4

  # Initial capsule positions (middle of the gap)
  CAPSULE_ROW_FIRST_INITIAL:  .word 7         # Initial row for the first part
  CAPSULE_COL_FIRST_INITIAL:  .word 15        # Initial column for the first part
  CAPSULE_ROW_SECOND_INITIAL: .word 8         # Initial row for the second part
  CAPSULE_COL_SECOND_INITIAL: .word 15        # Initial column for the second part

  CAPSULE_COLOR1: .word 0 #stores the color of the top capsule pixel
  CAPSULE_COLOR2: .word 0 #stores the color of the bottom capsule pixel

NEXT_PILL_ROW: .word 1        # Row for next pill preview
NEXT_PILL_COL: .word 23       # Column for next pill preview
NEXT_PILL_COLOR1: .word 0     # Stores color of next pill's first half
NEXT_PILL_COLOR2: .word 0     # Stores color of next pill's second half


SAVED_CAPSULE_ROW: .word 7        # Row for saved capsule
SAVED_CAPSULE_COL: .word 6        # Column for saved capsule
SAVED_CAPSULE_COLOR1: .word 0     # Color of saved capsule's first half
SAVED_CAPSULE_COLOR2: .word 0     # Color of saved capsule's second half
HAS_SAVED_CAPSULE: .word 0        # 0 = no saved capsule, 1 = has saved capsule


  PAUSED: .word 0    # 0 = not paused, 1 = paused
  DIM_COLOR: .word 0x404040      # Dark gray for dim effect
  PAUSE_MSG_ROW: .word 12        # Center row for pause message
  PAUSE_MSG_COL: .word 11        # Starting column for pause message


    # Speed control variables
  SLEEP_COUNTER: .word 0       # Counts sleep calls
  SPEED_INTERVAL: .word 30     # Increase speed every 30 calls 
  CURRENT_DELAY: .word 60      # Starts at 60ms (slower)
  MIN_DELAY: .word 20          # Minimum 20ms (fastest)
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
      li $a2, 12                # End column for the left part (13)
      jal draw_horizontal_line
  
      # Draw the right part of the top horizontal line
      li $a0, 9                 # Start at row 9
      li $a1, 18                # Start at column 19
      li $a2, 22                # End at column 22
      jal draw_horizontal_line
  
      # Draw the 2 vertical lines that are protruding out of the gap
      li $a0, 7                 # Start at row 7
      li $a1, 13                # Start at column 14
      li $a2, 2                 # Height of the vertical line (2 pixels)
      jal draw_vertical_line
  
      li $a0, 7                 # Start at row 7
      li $a1, 17                # Start at column 18
      li $a2, 2                 # Height of the vertical line (2 pixels)
      jal draw_vertical_line
  
      # Draw additional vertical lines for the design
      li $a0, 5                 # Start at row 5
      li $a1, 12                # Start at column 13
      li $a2, 2                 # Height of the vertical line (2 pixels)
      jal draw_vertical_line
  
      li $a0, 5                 # Start at row 5
      li $a1, 18                # Start at column 18
      li $a2, 2                 # Height of the vertical line (2 pixels)
      jal draw_vertical_line


      jal draw_checkered_pattern

      li $a0, 26                 # Start at row 9
      li $a1, 30                # Start at column 19
      lw $a2, COLOR_EXTRA_BLUE
      jal draw_pixel

      li $a0, 26                 # Start at row 9
      li $a1, 28                # Start at column 19
      lw $a2, COLOR_EXTRA_BLUE
      jal draw_pixel

      li $a0, 26                 # Start at row 9
      li $a1, 26                # Start at column 19
      lw $a2, COLOR_EXTRA_BLUE
      jal draw_pixel

      li $a0, 26                 # Start at row 9
      li $a1, 24                # Start at column 19
      lw $a2, COLOR_EXTRA_BLUE
      jal draw_pixel

      # draw the doctor

      li $a0, 3                 # Start at row 3
      li $a1, 23                # Start at column 19
      lw $a2, COLOR_SKIN
      jal draw_pixel

      li $a0, 4                 # Start at row 3
      li $a1, 23                # Start at column 19
      lw $a2, COLOR_SKIN
      jal draw_pixel

      li $a0, 5                 # Start at row 3
      li $a1, 23                # Start at column 19
      lw $a2, COLOR_SKIN
      jal draw_pixel

      li $a0, 4                 # Start at row 3
      li $a1, 22                # Start at column 19
      lw $a2, COLOR_SKIN
      jal draw_pixel
      
      li $a0, 5                 # Start at row 3
      li $a1, 22                # Start at column 19
      lw $a2, COLOR_SKIN
      jal draw_pixel

      li $a0, 5                 # Start at row 3
      li $a1, 24                # Start at column 19
      lw $a2, COLOR_SKIN
      jal draw_pixel

      li $a0, 5                 # Start at row 3
      li $a1, 25                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 5                 # Start at row 3
      li $a1, 26                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 5                 # Start at row 3
      li $a1, 27                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 5                 # Start at row 3
      li $a1, 29                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 5                 # Start at row 3
      li $a1, 30                # Start at column 19
      lw $a2, COLOR_SKIN
      jal draw_pixel

      li $a0, 6                 # Start at row 3
      li $a1, 30                # Start at column 19
      lw $a2, COLOR_SKIN
      jal draw_pixel


      li $a0, 6                 # Start at row 3
      li $a1, 29                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel
      

      li $a0, 5                 # Start at row 3
      li $a1, 28                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 4                 # Start at row 3
      li $a1, 26                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 4                 # Start at row 3
      li $a1, 27                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 3                 # Start at row 3
      li $a1, 27                # Start at column 19
      lw $a2, COLOR_WHITE
      jal draw_pixel
      
      li $a0, 3                 # Start at row 3
      li $a1, 28                # Start at column 19
      lw $a2, COLOR_WHITE
      jal draw_pixel

      li $a0, 3                 # Start at row 3
      li $a1, 29                # Start at column 19
      lw $a2, COLOR_WHITE
      jal draw_pixel
      
      li $a0, 4                 # Start at row 3
      li $a1, 28                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 4                 # Start at row 3
      li $a1, 29                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 4                 # Start at row 3
      li $a1, 30                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 2                 # Start at row 3
      li $a1, 28                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 2                 # Start at row 3
      li $a1, 29                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 2                 # Start at row 3
      li $a1, 29                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 1                 # Start at row 3
      li $a1, 28                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 5                 # Start at row 3
      li $a1, 31                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel

      li $a0, 6                 # Start at row 3
      li $a1, 31                # Start at column 19
      lw $a2, COLOR_HAIR
      jal draw_pixel


      li $a0, 2                 # Start at row 3
      li $a1, 26                # Start at column 19
      lw $a2, COLOR_WHITE
      jal draw_pixel

      li $a0, 3                 # Start at row 3
      li $a1, 25                # Start at column 19
      lw $a2, COLOR_WHITE
      jal draw_pixel

      li $a0, 2                 # Start at row 3
      li $a1, 24                # Start at column 19
      lw $a2, COLOR_WHITE
      jal draw_pixel

      li $a0, 1                 # Start at row 3
      li $a1, 25                # Start at column 19
      lw $a2, COLOR_WHITE
      jal draw_pixel




      # Draw the initial capsule in the middle of the gap
      jal draw_initial_capsule
      
      j before

before:
      lw $t0, ADDR_KBRD
      lw $t1, 0($t0)
      lw $t2, 4($t0)

      li $s5, 0x65             # Easy
      li $s6, 0x6d             # Medium
      li $s7, 0x68             # Hard

      beq $t2, $s5, start_easy # 'p'
      beq $t2, $s6, start_medium # 'p'
      beq $t2, $s7, start_hard # 'p'
      j before
  
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
  
       # Movement controls
    li $t3, 0x61            # 'a' - left
    beq $t2, $t3, move_left
    
    li $t4, 0x64            # 'd' - right
    beq $t2, $t4, move_right
    
    li $t5, 0x73            # 's' - down
    beq $t2, $t5, move_down
    
    li $t6, 0x77            # 'w' - rotate
    beq $t2, $t6, rotate
    
    # Other controls
    li $t7, 0x70            # 'p' - pause
    beq $t2, $t7, toggle_pause
    
    li $t8, 0x71            # 'q' - quit
    beq $t2, $t8, quit
    
    # Save/retrieve
    li $t9, 0x66            # 'f' - save
    beq $t2, $t9, save_capsule

    li $t3, 0x67            # 'g' - retrieve
    beq $t2, $t3, retrieve_capsule
    
      j game_loop
  
  
  no_input:
    lw $t0, PAUSED
    bnez $t0, game_loop     # Don't move if paused
      # 5. Sleep for approximately 16 ms (60 FPS)
      # jal sleep
      # j move_down
  
      # 6. Loop back to Step 1
      j game_loop

  toggle_pause:
    # Save return address if needed
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Toggle pause state
    lw $t0, PAUSED
    xori $t0, $t0, 1        # Flip between 0 and 1
    sw $t0, PAUSED

    # Optional: Add visual feedback (like blinking the screen)
    # jal show_pause_message maybe something like this

    # Restore and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j game_loop
    
  # Function to sleep for approximately 16.67 ms (60 FPS)
 sleep:
    # Save return address if needed
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # 1. Update speed counter and check if we should increase speed
    lw $t0, SLEEP_COUNTER
    lw $t1, SPEED_INTERVAL
    addi $t0, $t0, 1           # Increment counter
    sw $t0, SLEEP_COUNTER
    
    blt $t0, $t1, no_speed_change  # Not time to speed up yet
    
    # Time to increase speed!
    li $t0, 0                  # Reset counter
    sw $t0, SLEEP_COUNTER
    
    lw $t1, CURRENT_DELAY
    addi $t1, $t1, -1          # Decrease delay by 1ms (makes game faster)
    lw $t2, MIN_DELAY
    bge $t1, $t2, store_new_delay  # Don't go below minimum
    move $t1, $t2              # Use minimum delay if we went below
    
store_new_delay:
    sw $t1, CURRENT_DELAY

no_speed_change:
    # 2. Sleep with current delay value
    lw $a0, CURRENT_DELAY
    li $v0, 32                 # Syscall for sleep
    syscall
    
    # Restore and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

start_easy:
  li $s5, 200
  sw $s5, CURRENT_DELAY

  # Virus generation 1
      
      jal get_random_location_column
      move $a1, $v0
      sw $a1, VIRUS_COLUMN_FIRST

      jal get_random_location_row
      move $a0, $v0           
      sw $a0, VIRUS_ROW_FIRST

      
      jal get_random_location_column
      move $a1, $v0
      sw $a1, VIRUS_COLUMN_SECOND

      jal get_random_location_row
      move $a0, $v0           
      sw $a0, VIRUS_ROW_SECOND


      lw $t0, VIRUS_COLUMN_FIRST
      lw $t1, VIRUS_COLUMN_SECOND
      beq $t0, $t1, check_dup_easy

      
      jal get_random_color_two       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0
      lw $a0, VIRUS_ROW_FIRST
      lw $a1, VIRUS_COLUMN_FIRST
      jal draw_pixel

      jal get_random_color_two       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0
      lw $a0, VIRUS_ROW_SECOND
      lw $a1, VIRUS_COLUMN_SECOND
      jal draw_pixel
      
      li $s7, 2 
      sw $s7, VIRUS_COUNT
      
      
  j game_loop

check_dup_easy:
  j start_easy
  
start_medium:
  li $s6, 100
  sw $s6, CURRENT_DELAY

  # Virus generation 1     
      jal get_random_location_column
      move $a1, $v0
      sw $a1, VIRUS_COLUMN_FIRST

      jal get_random_location_row
      move $a0, $v0           
      sw $a0, VIRUS_ROW_FIRST
            
  
      # Virus generation 2
      jal get_random_location_column
      move $a1, $v0
      sw $a1, VIRUS_COLUMN_SECOND

      jal get_random_location_row
      move $a0, $v0           
      sw $a0, VIRUS_ROW_SECOND


      lw $t0, VIRUS_COLUMN_FIRST
      lw $t1, VIRUS_COLUMN_SECOND
      beq $t0, $t1, check_dup_medium


  # Virus generation 3
      jal get_random_location_column
      move $a1, $v0
      sw $a1, VIRUS_COLUMN_THIRD

      jal get_random_location_row
      move $a0, $v0           
      sw $a0, VIRUS_ROW_THIRD


      lw $t0, VIRUS_COLUMN_FIRST
      lw $t1, VIRUS_COLUMN_THIRD
      beq $t0, $t1, check_dup_medium

      lw $t0, VIRUS_COLUMN_SECOND
      lw $t1, VIRUS_COLUMN_THIRD
      beq $t0, $t1, check_dup_medium

      jal get_random_color_two       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0m
      lw $a0, VIRUS_ROW_FIRST
      lw $a1, VIRUS_COLUMN_FIRST
      jal draw_pixel

      jal get_random_color_two       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0
      lw $a0, VIRUS_ROW_SECOND
      lw $a1, VIRUS_COLUMN_SECOND
      jal draw_pixel

      jal get_random_color_two       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0
      lw $a0, VIRUS_ROW_THIRD
      lw $a1, VIRUS_COLUMN_THIRD
      jal draw_pixel

      
      li $s7, 3 
      sw $s7, VIRUS_COUNT
      
      
  j game_loop

check_dup_medium:
  j start_medium

start_hard:
  li $s7, 60
  sw $s7, CURRENT_DELAY
 # Virus generation 1  
      jal get_random_location_column
      move $a1, $v0
      sw $a1, VIRUS_COLUMN_FIRST

      jal get_random_location_row
      move $a0, $v0           
      sw $a0, VIRUS_ROW_FIRST
            
      
      # Virus generation 2      
      jal get_random_location_column
      move $a1, $v0
      sw $a1, VIRUS_COLUMN_SECOND

      jal get_random_location_row
      move $a0, $v0           
      sw $a0, VIRUS_ROW_SECOND

      lw $t0, VIRUS_COLUMN_FIRST
      lw $t1, VIRUS_COLUMN_SECOND
      beq $t0, $t1, check_dup_hard


  # Virus generation 3      
      jal get_random_location_column
      move $a1, $v0
      sw $a1, VIRUS_COLUMN_THIRD

      jal get_random_location_row
      move $a0, $v0           
      sw $a0, VIRUS_ROW_THIRD


      lw $t0, VIRUS_COLUMN_FIRST
      lw $t1, VIRUS_COLUMN_THIRD
      beq $t0, $t1, check_dup_hard

      lw $t0, VIRUS_COLUMN_SECOND
      lw $t1, VIRUS_COLUMN_THIRD
      beq $t0, $t1, check_dup_hard


  # Virus generation 4
      jal get_random_location_column
      move $a1, $v0
      sw $a1, VIRUS_COLUMN_FOURTH

      jal get_random_location_row
      move $a0, $v0           
      sw $a0, VIRUS_ROW_FOURTH


      lw $t0, VIRUS_COLUMN_FIRST
      lw $t1, VIRUS_COLUMN_FOURTH
      beq $t0, $t1, check_dup_hard

      lw $t0, VIRUS_COLUMN_SECOND
      lw $t1, VIRUS_COLUMN_FOURTH
      beq $t0, $t1, check_dup_hard

      lw $t0, VIRUS_COLUMN_THIRD
      lw $t1, VIRUS_COLUMN_FOURTH
      beq $t0, $t1, check_dup_hard



      jal get_random_color_two       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0m
      lw $a0, VIRUS_ROW_FIRST
      lw $a1, VIRUS_COLUMN_FIRST
      jal draw_pixel

      jal get_random_color_two       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0
      lw $a0, VIRUS_ROW_SECOND
      lw $a1, VIRUS_COLUMN_SECOND
      jal draw_pixel

      jal get_random_color_two       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0
      lw $a0, VIRUS_ROW_THIRD
      lw $a1, VIRUS_COLUMN_THIRD
      jal draw_pixel

      jal get_random_color_two       # Get random color for the first half
      move $a2, $v0             # Save first color in $s0
      lw $a0, VIRUS_ROW_FOURTH
      lw $a1, VIRUS_COLUMN_FOURTH
      jal draw_pixel

      
      li $s7, 4
      sw $s7, VIRUS_COUNT
      
  j game_loop

check_dup_hard:
  j start_hard


# Save function
save_capsule:
    lw $t0, PAUSED
    bnez $t0, game_loop     # Ignore if paused
    
    lw $t0, HAS_SAVED_CAPSULE
    bnez $t0, game_loop     # Already saved, ignore

    # Store current capsule colors
    sw $s0, SAVED_CAPSULE_COLOR1
    sw $s1, SAVED_CAPSULE_COLOR2
    li $t0, 1
    sw $t0, HAS_SAVED_CAPSULE

    # Draw saved capsule preview at (7,6) and (8,6)
    lw $a0, SAVED_CAPSULE_ROW
    lw $a1, SAVED_CAPSULE_COL
    move $a2, $s0
    jal draw_pixel
    
    addi $a0, $a0, 1        # Second part at (8,6)
    move $a2, $s1
    jal draw_pixel

    # Erase current capsule
    jal erase_capsule

    # Spawn new random capsule at initial position
    jal generate_new_capsule
    
    j game_loop

# Retrieve function  
retrieve_capsule:
    lw $t0, PAUSED
    bnez $t0, game_loop
    
    lw $t0, HAS_SAVED_CAPSULE
    beqz $t0, game_loop     # Nothing to retrieve

    # Erase saved preview at (7,6) and (8,6)
    lw $a0, SAVED_CAPSULE_ROW
    lw $a1, SAVED_CAPSULE_COL
    li $a2, 0x000000
    jal draw_pixel
    
    addi $a0, $a0, 1        # (8,6)
    jal draw_pixel

    # Erase current capsule
    jal erase_capsule

    # Load saved colors
    lw $s0, SAVED_CAPSULE_COLOR1
    lw $s1, SAVED_CAPSULE_COLOR2

    # Mark slot as empty
    sw $zero, HAS_SAVED_CAPSULE

    # Place retrieved capsule at initial position (7,15) and (8,15)
    lw $t0, CAPSULE_ROW_FIRST_INITIAL
    sw $t0, CAPSULE_ROW_FIRST
    lw $t0, CAPSULE_COL_FIRST_INITIAL
    sw $t0, CAPSULE_COL_FIRST
    lw $t0, CAPSULE_ROW_SECOND_INITIAL
    sw $t0, CAPSULE_ROW_SECOND
    lw $t0, CAPSULE_COL_SECOND_INITIAL
    sw $t0, CAPSULE_COL_SECOND

    # Draw retrieved capsule
    lw $a0, CAPSULE_ROW_FIRST
    lw $a1, CAPSULE_COL_FIRST
    move $a2, $s0
    jal draw_pixel

    lw $a0, CAPSULE_ROW_SECOND
    lw $a1, CAPSULE_COL_SECOND
    move $a2, $s1
    jal draw_pixel
    
    j game_loop
    
# Helper function to generate a new capsule (unchanged from previous)
generate_new_capsule:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Erase the next pill preview
    lw $a0, NEXT_PILL_ROW
    lw $a1, NEXT_PILL_COL
    li $a2, 0x000000         # Black
    jal draw_pixel

    lw $a0, NEXT_PILL_ROW
    addi $a0, $a0, 1         # Second part
    lw $a1, NEXT_PILL_COL
    li $a2, 0x000000         # Black
    jal draw_pixel

    # Move next pill colors to current pill
    lw $s0, NEXT_PILL_COLOR1
    lw $s1, NEXT_PILL_COLOR2

    # Reset capsule position to initial position
    lw $t0, CAPSULE_ROW_FIRST_INITIAL
    sw $t0, CAPSULE_ROW_FIRST
    lw $t0, CAPSULE_COL_FIRST_INITIAL
    sw $t0, CAPSULE_COL_FIRST
    lw $t0, CAPSULE_ROW_SECOND_INITIAL
    sw $t0, CAPSULE_ROW_SECOND
    lw $t0, CAPSULE_COL_SECOND_INITIAL
    sw $t0, CAPSULE_COL_SECOND

    # Generate new next pill preview
    jal get_random_color
    sw $v0, NEXT_PILL_COLOR1
    jal get_random_color
    sw $v0, NEXT_PILL_COLOR2

    # Draw new next pill preview
    lw $a0, NEXT_PILL_ROW
    lw $a1, NEXT_PILL_COL
    lw $a2, NEXT_PILL_COLOR1
    jal draw_pixel

    lw $a0, NEXT_PILL_ROW
    addi $a0, $a0, 1         # Second part
    lw $a1, NEXT_PILL_COL
    lw $a2, NEXT_PILL_COLOR2
    jal draw_pixel

    # Draw the new current pill
    lw $a0, CAPSULE_ROW_FIRST
    lw $a1, CAPSULE_COL_FIRST
    move $a2, $s0
    jal draw_pixel

    lw $a0, CAPSULE_ROW_SECOND
    lw $a1, CAPSULE_COL_SECOND
    move $a2, $s1
    jal draw_pixel

    # Restore return address
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
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

    # Generate random colors for current capsule
    jal get_random_color
    move $s0, $v0             # First color in $s0
    jal get_random_color
    move $s1, $v0             # Second color in $s1

    # Generate random colors for next capsule preview
    jal get_random_color
    sw $v0, NEXT_PILL_COLOR1
    jal get_random_color
    sw $v0, NEXT_PILL_COLOR2

    # Draw current capsule at normal position
    lw $a0, CAPSULE_ROW_FIRST
    lw $a1, CAPSULE_COL_FIRST
    move $a2, $s0
    jal draw_pixel

    lw $a0, CAPSULE_ROW_SECOND
    lw $a1, CAPSULE_COL_SECOND
    move $a2, $s1
    jal draw_pixel

    # Draw next capsule preview at row 1, column 23
    lw $a0, NEXT_PILL_ROW
    lw $a1, NEXT_PILL_COL
    lw $a2, NEXT_PILL_COLOR1
    jal draw_pixel

    lw $a0, NEXT_PILL_ROW
    addi $a0, $a0, 1          # Second part is below first
    lw $a1, NEXT_PILL_COL
    lw $a2, NEXT_PILL_COLOR2
    jal draw_pixel

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


get_random_color_two:
      # Load the address of the colors
      la $t0, COLOR_VIRUS_RED         # Load address of COLOR_RED
      la $t1, COLOR_VIRUS_GREEN       # Load address of COLOR_GREEN
      la $t2, COLOR_VIRUS_BLUE        # Load address of COLOR_BLUE
  
      # Generate a random number between 0 and 2
      li $v0, 42                # Syscall for random number
      li $a0, 0                 # Random number generator ID
      li $a1, 3                 # Upper bound (exclusive)
      syscall
  
      # Use the random number to select a color
      beq $a0, 0, select_red_two    # If 0, select red
      beq $a0, 1, select_green_two  # If 1, select green
      beq $a0, 2, select_blue_two   # If 2, select blue
  
  select_red_two:
      lw $v0, 0($t0)            # Load red color
      jr $ra
  
  select_green_two:
      lw $v0, 0($t1)            # Load green color
      jr $ra
  
  select_blue_two:
      lw $v0, 0($t2)            # Load blue color
      jr $ra


get_random_location_row:
      # Generate a random number between 0 and 2
      li $v0, 42                # Syscall for random number
      li $a0, 0                 # Random number generator ID
      li $a1, 8                 # Upper bound (exclusive)
      syscall
      addi $a0, $a0, 16
      move $v0, $a0
      jr $ra


  get_random_location_column:
      # Generate a random number between 0 and 2
      li $v0, 42                # Syscall for random number
      li $a0, 0                 # Random number generator ID
      li $a1, 8                 # Upper bound (exclusive)
      syscall
      addi $a0, $a0, 11
      move $v0, $a0
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

# Function to draw a checkered pattern
draw_checkered_pattern:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize variables
    li $t0, 0                  # Row counter
    li $t1, 0                  # Column counter
    lw $t2, ADDR_DSPL          # Base address of display
    lw $t3, COLOR_EXTRA_BLUE        # Load white color
    lw $t4, COLOR_BLACK        # Load black color
    li $t5, 0x808080           # Gray color (outline)
    li $t6, 0                  # Inside flag (0 = checkered, 1 = skip)

draw_checkered_outer_loop:
    bge $t0, 32, draw_checkered_done  # If row >= 32, exit loop

draw_checkered_inner_loop:
    bge $t1, 32, draw_checkered_next_row  # If column >= 32, move to next row

    # Calculate the address of the current pixel
    li $t7, 128                # Bytes per row
    mul $t8, $t0, $t7          # Row offset = row * 128
    li $t9, 4                  # Bytes per pixel
    mul $t7, $t1, $t9          # Column offset = column * 4
    add $t8, $t8, $t7          # Total offset = row offset + column offset
    addu $t8, $t2, $t8         # Address of the current pixel

    # Load the color of the current pixel
    lw $t7, 0($t8)             # Load pixel color

    # If we see a gray pixel, toggle the inside flag
    beq $t7, $t5, toggle_inside_flag  

    # If inside the black region, skip drawing checkered pixels
    bnez $t6, draw_checkered_next_pixel  

    # Determine the checkered color based on the row and column
    add $t7, $t0, $t1          # Add row and column
    andi $t7, $t7, 1           # Check if the sum is odd or even
    beqz $t7, draw_white       # If even, draw white
    j draw_black               # If odd, draw black


draw_white:
    sw $t3, 0($t8)             # Draw white pixel
    j draw_checkered_next_pixel

draw_black:
    sw $t4, 0($t8)             # Draw black pixel
    j draw_checkered_next_pixel

toggle_inside_flag:
    # Toggle $t6 (0 → 1, 1 → 0)
    xori $t6, $t6, 1
    j draw_checkered_next_pixel


handle_gray_block:
    # If we're not inside a gray block, set the flag to indicate we're now inside
    beqz $t6, set_inside_flag

    # If we're already inside a gray block, check if this is the last gray block in the sequence
    addi $t7, $t1, 1           # Check the next column
    blt $t7, 32, check_next_pixel  # If within bounds, check the next pixel
    j clear_inside_flag        # If at the end of the row, clear the flag


check_next_pixel:
    # Calculate the address of the next pixel
    mul $t7, $t0, 128          # Row offset = row * 128
    mul $t9, $t1, 4            # Column offset = column * 4
    add $t7, $t7, $t9          # Total offset = row offset + column offset
    addi $t7, $t7, 4           # Move to the next column
    addu $t7, $t2, $t7         # Address of the next pixel

    # Load the color of the next pixel
    lw $t9, 0($t7)             # Load pixel color

    # If the next pixel is not gray, clear the flag (end of gray block sequence)
    bne $t9, $t5, clear_inside_flag

    # If the next pixel is gray, continue skipping
    j draw_checkered_next_pixel

set_inside_flag:
    # Set the flag to indicate we're now inside a gray block
    li $t6, 1
    j draw_checkered_next_pixel

clear_inside_flag:
    # Clear the flag to indicate we're now outside a gray block
    li $t6, 0
    j draw_checkered_next_pixel

draw_checkered_next_pixel:
    addi $t1, $t1, 1           # Move to the next column
    j draw_checkered_inner_loop

draw_checkered_next_row:
    addi $t0, $t0, 1           # Move to the next row
    li $t1, 0                  # Reset column counter
    li $t6, 0                  # Reset inside flag for the new row
    j draw_checkered_outer_loop

draw_checkered_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
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
# Function to check if a pixel is a virus
# Input: $a0 = row, $a1 = column
# Output: $v0 = 1 if pixel is a virus, 0 otherwise
check_if_virus:
    # Load virus location
    lw $t0, VIRUS_ROW_FIRST          # Load virus row
    lw $t1, VIRUS_COLUMN_FIRST       # Load virus column

    # Compare input row and column with virus location
    beq $a0, $t0, not_virus    # If row doesn't match, not a virus


    lw $t0, VIRUS_ROW_SECOND          # Load virus row
    lw $t1, VIRUS_COLUMN_SECOND      # Load virus column

    # Compare input row and column with virus location
    beq $a0, $t0, not_virus    # If row doesn't match, not a virus


    lw $t0, VIRUS_ROW_THIRD          # Load virus row
    lw $t1, VIRUS_COLUMN_THIRD       # Load virus column

    # Compare input row and column with virus location
    beq $a0, $t0, not_virus    # If row doesn't match, not a virus


    lw $t0, VIRUS_ROW_FOURTH          # Load virus row
    lw $t1, VIRUS_COLUMN_FOURTH       # Load virus column

    # Compare input row and column with virus location
    beq $a0, $t0, not_virus    # If row doesn't match, not a virus


not_virus:
  beq $a1, $t1, viruse    # If column doesn't match, not a virus
  beq $a1, $t1, viruse    # If column doesn't match, not a virus
  beq $a1, $t1, viruse    # If column doesn't match, not a virus
  beq $a1, $t1, viruse    # If column doesn't match, not a virus
  # Virus not found - return 1
  li $v0, 0                  # Return 1 (not a virus)
  jr $ra                     # Return

viruse:
    li $v0, 1                  # Return 1 (a virus)
    jr $ra                     # Return
decrease_virus_count:
    # Decrement virus count and check if game should end
    lw $t0, VIRUS_COUNT
    addi $t0, $t0, -1
    sw $t0, VIRUS_COUNT

        # If count reaches 0, quit game
    beqz $t0, quit
    li $v0, 0
    jr $ra                     # Return if count > 0
    
    
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
      lw $t0, PAUSED
      bnez $t0, game_loop     # Don't move if paused
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
      lw $a0, CAPSULE_ROW_FIRST
      addi $a0, $a0, 1
      lw $a1, CAPSULE_COL_FIRST
      addi $a1, $a1, 1
      jal check_pixel
      beq $v0, 0, no_rotate
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
      lw $a0, CAPSULE_ROW_FIRST
      addi $a0, $a0, -1
      lw $a1, CAPSULE_COL_FIRST
      addi $a1, $a1, -1
      jal check_pixel
      beq $v0, 0, no_rotate
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
      lw $a0, CAPSULE_ROW_FIRST
      addi $a0, $a0, 1
      lw $a1, CAPSULE_COL_FIRST
      addi $a1, $a1, -1
      jal check_pixel
      beq $v0, 0, no_rotate
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
      lw $a0, CAPSULE_ROW_FIRST
      addi $a0, $a0, -1
      lw $a1, CAPSULE_COL_FIRST
      addi $a1, $a1, 1
      jal check_pixel
      beq $v0, 0, no_rotate
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
      lw $t0, PAUSED
      bnez $t0, game_loop     # Don't move if paused
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
      lw $t0, PAUSED
      bnez $t0, game_loop     # Don't move if paused
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
      
game_over:
    # If the game is over (row 9 is filled), we allow the player to restart the game
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Flash the screen 3 times (white-black-white-black-white-black)
    li $t4, 3                  # Number of flashes
flash_loop:
    # Flash white
    jal flash_screen_white
    li $a0, 150                # 150ms delay
    li $v0, 32
    syscall
    
    # Flash black
    jal clear_screen
    li $a0, 150                # 150ms delay
    li $v0, 32
    syscall
    
    addi $t4, $t4, -1          # Decrement flash counter
    bnez $t4, flash_loop       # Repeat if not done

    # Final clear to black
    jal clear_screen

    # Display game over message (optional)
    # You could add text display here if you want

game_over_loop:
    # Wait for 'r' key to restart
    lw $t0, ADDR_KBRD
    lw $t1, 0($t0)
    beqz $t1, game_over_loop  # No key pressed, keep waiting

    # Check if key is 'r' (0x72)
    lw $t2, 4($t0)
    li $t3, 0x72             # ASCII 'r'
    bne $t2, $t3, game_over_loop  # Not 'r', keep waiting

    # 'r' pressed - restart the game
    jal restart_game

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

flash_screen_white:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize variables
    lw $t0, ADDR_DSPL         # Base address of display
    li $t1, 0                 # Pixel counter
    li $t2, 1024              # Total pixels (256x256 / (8x8) = 32x32 = 1024)
    lw $t3, COLOR_WHITE       # White color

flash_loop_white:
    bge $t1, $t2, flash_done_white  # If all pixels processed, exit
    sw $t3, 0($t0)            # Store white color
    addi $t0, $t0, 4          # Move to next pixel
    addi $t1, $t1, 1          # Increment counter
    j flash_loop_white

flash_done_white:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

clear_screen:
    # Paint the entire screen black
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize variables
    lw $t0, ADDR_DSPL         # Base address of display
    li $t1, 0                 # Pixel counter
    li $t2, 1024              # Total pixels (256x256 / (8x8) = 32x32 = 1024)

clear_loop:
    bge $t1, $t2, clear_done  # If all pixels cleared, exit
    sw $zero, 0($t0)          # Store black color
    addi $t0, $t0, 4          # Move to next pixel
    addi $t1, $t1, 1          # Increment counter
    j clear_loop

clear_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

restart_game:
    # Reset all game state variables to initial values
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Reset capsule position
    lw $t0, CAPSULE_ROW_FIRST_INITIAL
    sw $t0, CAPSULE_ROW_FIRST
    lw $t0, CAPSULE_COL_FIRST_INITIAL
    sw $t0, CAPSULE_COL_FIRST
    lw $t0, CAPSULE_ROW_SECOND_INITIAL
    sw $t0, CAPSULE_ROW_SECOND
    lw $t0, CAPSULE_COL_SECOND_INITIAL
    sw $t0, CAPSULE_COL_SECOND

    # Reset speed/delay settings
    li $t0, 60
    sw $t0, CURRENT_DELAY
    li $t0, 0
    sw $t0, SLEEP_COUNTER

    # Reset pause state
    sw $zero, PAUSED

    # Redraw the game elements
    j main

check_row_9_covered:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize variables
    lw $t0, ADDR_DSPL          # Base address of display
    li $t1, 128                # Bytes per row
    li $t2, 8                  # Row 9
    mul $t3, $t2, $t1          # Row offset = row * 128
    addu $t4, $t0, $t3         # Starting address of Row 9

    li $t5, 14                 # Column counter (start at 13)
    li $t6, 16                 # Total columns (end at 17)
    li $t7, 4                  # Bytes per pixel

check_row_9_loop:
    bge $t5, $t6, row_9_covered  # If all columns checked and no black pixels found, row is covered

    # Calculate the address of the current pixel
    mul $t8, $t5, $t7          # Column offset = column * 4
    addu $t9, $t4, $t8         # Address of the current pixel

    # Load the color of the current pixel
    lw $t8, 0($t9)             # Load pixel color
    li $t9, 0x000000           # Black color
    beq $t8, $t9, row_9_not_covered  # If pixel is black, row is not covered

    # Move to the next column
    addi $t5, $t5, 1           # Increment column counter
    j check_row_9_loop

row_9_covered:
    li $v0, 1                  # Return 1 (Row 9 is fully covered)
    j check_row_9_done

row_9_not_covered:
    li $v0, 0                  # Return 0 (Row 9 is not fully covered)

check_row_9_done:
    # Restore return address
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
  
  # Function to move the capsule down
  move_down:
      lw $t0, PAUSED
      bnez $t0, game_loop     # Don't move if paused
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

    jal check_row_9_covered
    beq $v0, 1, game_over    # If Row 9 is covered, game over

    # Erase the next pill preview
    lw $a0, NEXT_PILL_ROW
    lw $a1, NEXT_PILL_COL
    li $a2, 0x000000         # Black
    jal draw_pixel

    lw $a0, NEXT_PILL_ROW
    addi $a0, $a0, 1         # Second part
    lw $a1, NEXT_PILL_COL
    li $a2, 0x000000         # Black
    jal draw_pixel

    # Move next pill colors to current pill
    lw $s0, NEXT_PILL_COLOR1
    lw $s1, NEXT_PILL_COLOR2

    # Reset capsule position to initial position
    lw $t0, CAPSULE_ROW_FIRST_INITIAL
    sw $t0, CAPSULE_ROW_FIRST
    lw $t0, CAPSULE_COL_FIRST_INITIAL
    sw $t0, CAPSULE_COL_FIRST
    lw $t0, CAPSULE_ROW_SECOND_INITIAL
    sw $t0, CAPSULE_ROW_SECOND
    lw $t0, CAPSULE_COL_SECOND_INITIAL
    sw $t0, CAPSULE_COL_SECOND

    # Generate new next pill preview
    jal get_random_color
    sw $v0, NEXT_PILL_COLOR1
    jal get_random_color
    sw $v0, NEXT_PILL_COLOR2

    # Draw new next pill preview
    lw $a0, NEXT_PILL_ROW
    lw $a1, NEXT_PILL_COL
    lw $a2, NEXT_PILL_COLOR1
    jal draw_pixel

    lw $a0, NEXT_PILL_ROW
    addi $a0, $a0, 1         # Second part
    lw $a1, NEXT_PILL_COL
    lw $a2, NEXT_PILL_COLOR2
    jal draw_pixel

    # Draw the new current pill
    lw $a0, CAPSULE_ROW_FIRST
    lw $a1, CAPSULE_COL_FIRST
    move $a2, $s0
    jal draw_pixel

    lw $a0, CAPSULE_ROW_SECOND
    lw $a1, CAPSULE_COL_SECOND
    move $a2, $s1
    jal draw_pixel

    j game_loop
      
erase_pixel:
    # Debug: Print the input parameters
    # $a0 = row, $a1 = column, $a2 = background color
    li $v0, 4                  # Syscall for print_string
    la $a0, debug_message_1     # Load the address of the message
    syscall

    li $v0, 1                  # Syscall for print_int
    move $a0, $a0              # Print row
    syscall

    li $v0, 4                  # Syscall for print_string
    la $a0, newline_msg     # Load the address of the message
    syscall

    li $v0, 1                  # Syscall for print_int
    move $a0, $a1              # Print column
    syscall

    li $v0, 4                  # Syscall for print_string
    la $a0, newline_msg     # Load the address of the message
    syscall
    
    li $v0, 1                  # Syscall for print_int
    move $a0, $a2              # Print background color
    syscall

        li $v0, 4                  # Syscall for print_string
    la $a0, newline_msg     # Load the address of the message
    syscall

    # Compute row offset (128 bytes per row)
    lw $t0, ADDR_DSPL          # Load base address of display
    li $t1, 128                # Row offset (128 bytes per row)
    mul $t2, $a0, $t1          # Row offset = row * 128

    # Debug: Print row offset
    li $v0, 1                  # Syscall for print_int
    move $a0, $t2              # Print row offset
    syscall

        li $v0, 4                  # Syscall for print_string
    la $a0, newline_msg     # Load the address of the message
    syscall

    li $t3, 4                  # Each unit is 4 bytes
    mul $t4, $a1, $t3          # Column offset = column * 4

    # Debug: Print column offset
    li $v0, 1                  # Syscall for print_int
    move $a0, $t4              # Print column offset
    syscall

        li $v0, 4                  # Syscall for print_string
    la $a0, newline_msg     # Load the address of the message
    syscall

    add $t5, $t2, $t4          # Total offset = row offset + column offset
    addu $t6, $t0, $t5         # Starting address = base address + offset

    # Debug: Print total offset and address
    li $v0, 1                  # Syscall for print_int
    move $a0, $t5              # Print total offset
    syscall

    li $v0, 4                  # Syscall for print_string
    la $a0, newline_msg     # Load the address of the message
    syscall

    li $v0, 1                  # Syscall for print_int
    move $a0, $t6              # Print final address
    syscall

        li $v0, 4                  # Syscall for print_string
    la $a0, newline_msg     # Load the address of the message
    syscall

    sw $a2, 0($t6)             # Write background color to the location

    # Debug: Print a message indicating the pixel is erased
    li $v0, 4                  # Syscall for print_string
    la $a0, debug_message_2     # Load the address of the message
    syscall

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
      
# Function to check row and column neighbors and delete contiguous segments if necessary
check_row_neighbors:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    #### DEBUGGING FIRST PIXEL ####
    # Check row neighbors for the first pixel
    lw $a0, CAPSULE_ROW_FIRST      # Row for the first pixel
    lw $a1, CAPSULE_COL_FIRST      # Column for the first pixel
    move $a2, $s0                  # Color for the first pixel
    jal check_left_and_right        # Check left and right neighbors for the first pixel

    # Check if the count of same-colored neighbors is greater than or equal to 3
    li $t0, 4
    bge $s2, $t0, delete_first_segment  # If $s2 >= 3, delete the segment

    # Check vertical neighbors for the first pixel
    lw $a0, CAPSULE_ROW_FIRST
    lw $a1, CAPSULE_COL_FIRST
    move $a2, $s0
    jal check_bottom_and_top

    # Check if the count of same-colored neighbors is greater than or equal to 3
    li $t0, 4
    bge $s2, $t0, delete_first_vertical_segment  # If $s2 >= 3, delete the vertical segment

    #### DEBUGGING SECOND PIXEL ####
    # Check row neighbors for the second pixel
    lw $a0, CAPSULE_ROW_SECOND
    lw $a1, CAPSULE_COL_SECOND
    move $a2, $s1
    jal check_left_and_right

    # Check if the count of same-colored neighbors is greater than or equal to 3
    li $t0, 4
    bge $s2, $t0, delete_second_segment  # If $s2 >= 3, delete the segment

    # Check vertical neighbors for the second pixel
    lw $a0, CAPSULE_ROW_SECOND
    lw $a1, CAPSULE_COL_SECOND
    move $a2, $s1
    jal check_bottom_and_top

    # Check if the count of same-colored neighbors is greater than or equal to 3
    li $t0, 4
    bge $s2, $t0, delete_second_vertical_segment  # If $s2 >= 3, delete the vertical segment

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

delete_first_vertical_segment:
    # Delete the vertical segment for the first pixel
    lw $a0, CAPSULE_ROW_FIRST      # Start row
    lw $a1, CAPSULE_COL_FIRST      # Column

    # Set the end row to $s4 (last row of the segment)
    move $a2, $s4                  # $s4 contains the last row of the segment
    subu $t8, $t6, $t1         # Address of the pixel above (row - 1)
    jal delete_vertical_segment     # Call the function to delete the vertical segment
    j check_row_neighbors_end       # Jump to the end of the function

delete_second_vertical_segment:
    # Delete the vertical segment for the second pixel
    lw $a0, CAPSULE_ROW_SECOND     # Start row
    lw $a1, CAPSULE_COL_SECOND     # Column
    move $a2, $s4                  # End rows
    
    jal delete_vertical_segment
    j check_row_neighbors_end

delete_first_segment:
    # Delete the contiguous segment for the first pixel
    lw $a0, CAPSULE_ROW_FIRST
    move $a1, $s3                  # Start column
    move $a2, $s4                  # End column
    jal delete_contiguous_segment
    j check_row_neighbors_end

delete_second_segment:
    # Delete the contiguous segment for the second pixel
    lw $a0, CAPSULE_ROW_SECOND
    move $a1, $s3                  # Start column
    move $a2, $s4                  # End column
    jal delete_contiguous_segment
    j check_row_neighbors_end

check_row_neighbors_end:
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

    # Initialize variables
    li $s2, 1                  # Start with 1 to include the current pixel
    move $s3, $a1              # Start column = current column
    move $s4, $a1              # End column = current column

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
    

# Function to check bottom and top neighbors for a single pixel
# Arguments: $a0 = row, $a1 = column, $a2 = color
# Returns: $s2 = count of same-colored neighbors in the column
check_bottom_and_top:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize counter for same-colored pixels
    li $s2, 1                  # Start with 1 to include the current pixel
    move $s3, $a0              # Start row = current row
    move $s4, $a0              # End row = current row

    # Save the original row for top checking
    move $t7, $a0

    # Check below
    jal check_bottom_for_pixel

    # Restore the original row for top checking
    move $a0, $t7

    # Check above
    jal check_top_for_pixel

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

    # Update the end column
    move $s4, $a1

    # Continue checking to the right
    j check_right_loop

check_right_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function to check left neighbors for a single pixel
# Arguments: $a0 = row, $a1 = column, $a2 = color
# Modifies: $s2, $s3
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

    # Update the start column
    move $s3, $a1

    # Continue checking to the left
    j check_left_loop

check_left_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
check_bottom_for_pixel:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

check_bottom_loop:
    # Check the pixel below
    addi $a0, $a0, 1            # Move to the next row below
    jal check_pixel_color        # Check the color of the pixel

    # Compare the color with the capsule color
    bne $v0, $a2, check_bottom_done  # If colors don't match, exit the loop

    # Increment the counter
    addi $s2, $s2, 1

    # Update the end row
    move $s4, $a0              # Update $s4 to the current row

    # Continue checking below
    j check_bottom_loop

check_bottom_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
    
check_top_for_pixel:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

check_top_loop:
    # Check the pixel to the right
    addi $a0, $a0, -1            # Move to the next row to the right
    jal check_pixel_color       # Check the color of the pixel

    # Compare the color with the capsule color
    bne $v0, $a2, check_top_done  # If colors don't match, exit the loop

    # Increment the counter
    addi $s2, $s2, 1

    # Continue checking to the right
    j check_top_loop

check_top_done:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


# Function to delete a contiguous segment of same-colored pixels in a row and shift pixels above down
# Arguments: $a0 = row, $a1 = start column, $a2 = end column
delete_contiguous_segment:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize variables
    lw $t0, ADDR_DSPL          # Base address of display
    li $t1, 128                # Bytes per row
    mul $t2, $a0, $t1          # Row offset = row * 128
    addu $t3, $t0, $t2         # Starting address of the row
    

    # Calculate the starting address of the segment
    li $t4, 4                  # Bytes per pixel
    mul $t5, $a1, $t4          # Column offset = start column * 4
    addu $t6, $t3, $t5         # Starting address of the segment

    # Calculate the ending address of the segment
    mul $t7, $a2, $t4          # Column offset = end column * 4
    addu $t8, $t3, $t7         # Ending address of the segment

    # Delete the segment by setting pixels to black
delete_segment_loop:
    bgt $t6, $t8, delete_segment_done  # If we've passed the end column, exit
    sw $zero, 0($t6)           # Set pixel to black (0x000000)
    addiu $t6, $t6, 4          # Move to the next pixel
    j delete_segment_loop

delete_segment_done:
    # Shift pixels above the deleted segment down
    move $t9, $a1              # Start column
shift_columns_loop:
    bgt $t9, $a2, shift_columns_done  # If we've passed the end column, exit

    # Calculate the address of the current column in the deleted row
    mul $t5, $t9, $t4          # Column offset = column * 4
    addu $t6, $t3, $t5         # Address of the current column in the deleted row

    # Shift pixels above down
    move $t7, $a0              # Current row (start from the deleted row)
    
shift_rows_loop:
    beqz $t7, shift_rows_done  # If we've reached the top row, exit

    # Calculate the address of the pixel above
    subu $t8, $t6, $t1         # Address of the pixel above (row - 1)

    # Copy the pixel above to the current row
    lw $t5, 0($t8)             # Load pixel from the row above
    li $t0, 0x000000           # Assume black blocks are 0x000000
    beq $t5, $t0, shift_rows_done  # If black block, stop shifting

    # # Check if the pixel above is a virus
    # move $a0, $t7              # Current row
    # addi $a0, $a0, -1          # Row of the pixel above
    # move $a1, $t9              # Column of the pixel above
    # jal check_if_virus         # Check if it's a virus
    # bnez $v0, shift_rows_done  # If it's a virus, stop shifting

    # Copy the pixel above to the current row
    sw $t5, 0($t6)             # Store pixel in the current row

    # Move to the next row above
    subu $t6, $t6, $t1         # Move to the next row above
    addiu $t7, $t7, -1         # Decrement row counter
    j shift_rows_loop

shift_rows_done:
    # Clear the top row in the current column
    sw $zero, 0($t6)           # Set the top pixel to black (0x000000)

    # Move to the next column
    addiu $t9, $t9, 1          # Increment column counter
    j shift_columns_loop

shift_columns_done:
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

    lw $t0, COLOR_VIRUS_RED
    lw $t1, COLOR_VIRUS_GREEN
    lw $t2, COLOR_VIRUS_BLUE

    # Load the color of the pixel
    lw $v0, 0($t6)            # Load the color of the pixel
    beq $v0, $t0, redy
    beq $v0, $t1, yellowy
    beq $v0, $t2, bluey
    jr $ra                    # Return the color in $v0

redy:
  lw $t0, COLOR_RED
  move $v0, $t0
  jr $ra

yellowy:
  lw $t0, COLOR_GREEN
  move $v0, $t0
  jr $ra

bluey:
  lw $t0, COLOR_BLUE
  move $v0, $t0
  jr $ra

  # Function to delete a contiguous vertical segment of same-colored pixels and shift rows above down
# Arguments: $a0 = row (start of the vertical segment), $a1 = column, $a2 = end row (end of the vertical segment)
delete_vertical_segment:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize variables
    lw $t0, ADDR_DSPL          # Base address of display
    li $t1, 128                # Bytes per row
    li $t3, 4                  # Bytes per pixel
    mul $t4, $a1, $t3          # Column offset = column * 4
    
    # First, delete the vertical segment
    move $t7, $a0              # Start row
    mul $t2, $t7, $t1          # Row offset
    addu $t6, $t0, $t2         # Row address
    addu $t6, $t6, $t4         # Pixel address
    
delete_vertical_segment_loop:
    bgt $t7, $a2, deletion_done  # Stop if current row > end row
    sw $zero, 0($t6)           # Set pixel to black
    addiu $t6, $t6, 128        # Next row
    addiu $t7, $t7, 1          # Increment row
    j delete_vertical_segment_loop

deletion_done:
    # Now shift all pixels above the deleted segment down
    # Start from the row above the top of the deleted segment
    addi $t7, $a0, -1          # Start at row above deletion
    
shift_rows_above_loop:
    bltz $t7, shift_rows_above_done  # If we've reached the top row, exit
    li $t5, 9                  # Row 9 - always stop here
    ble $t7, $t5, shift_rows_above_done  # Stop if we reach row 9 or below
    
    # Calculate current pixel address
    mul $t2, $t7, $t1          # Row offset
    addu $t6, $t0, $t2         # Row address
    addu $t6, $t6, $t4         # Pixel address
    
    # Check if pixel is gray (wall)
    lw $t5, 0($t6)
    li $t9, 0x808080           # Gray color
    beq $t5, $t9, shift_rows_above_done   # Skip gray pixels

    lw $t9, VIRUS_ROW_FIRST
    beq $t7, $t9, check_if_virus
    beq $v0, 1, shift_rows_above_done

    lw $t9, VIRUS_ROW_SECOND
    beq $t7, $t9, check_if_virus
    beq $v0, 1, shift_rows_above_done

    lw $t9, VIRUS_ROW_THIRD
    beq $t7, $t9, check_if_virus
    beq $v0, 1, shift_rows_above_done

    lw $t9, VIRUS_ROW_FOURTH
    beq $t7, $t9, check_if_virus
    beq $v0, 1, shift_rows_above_done
    
    # Find the lowest empty space below this pixel
    move $t8, $t7              # Current row
find_empty_space_loop:
    addiu $t8, $t8, 1          # Next row down
    bgt $t8, 26, found_space   # If at bottom, use this
    
    # Calculate address of pixel below
    mul $t2, $t8, $t1
    addu $t2, $t0, $t2
    addu $t2, $t2, $t4
    lw $t5, 0($t2)             # Load pixel below
    
    # If pixel below is not black, we found the space above it
    bnez $t5, found_space
    j find_empty_space_loop
    
found_space:
    addiu $t8, $t8, -1         # Row above the collision
    blt $t8, $t7, skip_shift   # If no space found, skip
    
    # Move the pixel down to the empty space
    lw $t5, 0($t6)             # Load current pixel
    mul $t2, $t8, $t1          # Calculate target address
    addu $t2, $t0, $t2
    addu $t2, $t2, $t4
    sw $t5, 0($t2)             # Store pixel in new position
    sw $zero, 0($t6)           # Clear original position
    
skip_shift:
    addiu $t7, $t7, -1         # Move up one row
    j shift_rows_above_loop

shift_rows_above_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
check_gray_at_row_9:
    # Calculate the address of the pixel at row 9
    mul $t2, $t9, $t1          # Row offset = row 9 * 128
    addu $t5, $t2, $t4         # Address offset for pixel at row 9
    addu $t6, $t0, $t5         # Address of pixel at row 9 in display

    # Check if the pixel at row 9 is gray
    lw $t5, 0($t6)             # Load pixel color
    li $t9, 0x808080           # Gray color
    beq $t5, $t9, shift_rows_above_done  # If pixel is gray, exit the loop

    # If not gray, continue shifting
    j shift_rows_above_done
    

# check_left_and_right_2:
#     # Initialize variables
#     li $s2, 1                  # Start with 1 to include the current pixel
#     move $s3, $a1              # Start column = current column
#     move $s4, $a1              # End column = current column

#     # Save the original column for left checking
#     move $t7, $a1

#     # Check to the right
#     jal check_right_loop_1

#     # Restore the original column for left checking
#     move $a1, $t7

#     # Check to the left
#     jal check_left_loop_1

# check_right_loop_1:
#     # Check the pixel to the right
#     addi $a1, $a1, 1            # Move to the next column to the right
#     jal check_pixel       # Check the color of the pixel
#     beq $v0, 1, check_right_done_1
#     addi, $a0, $a0, 1
#     jal check_pixel
#     beq $v0, 1, find_collision_loop

#     # Continue checking to the right
#     j check_right_loop_1

# check_right_done_1:
#     # Restore return address and return
#     lw $ra, 0($sp)
#     addi $sp, $sp, 4
#     jr $ra

# # Function to check left neighbors for a single pixel
# # Arguments: $a0 = row, $a1 = column, $a2 = color
# # Modifies: $s2, $s3
# check_left_for_neigbour:
#     # Save return address
#     addi $sp, $sp, -4
#     sw $ra, 0($sp)

# check_left_loop_1:
#     # Check the pixel to the left
#     addi $a1, $a1, -1           # Move to the next column to the left
#     jal check_pixel_color       # Check the color of the pixel

#     # Compare the color with the capsule color
#     bne $v0, $a2, check_left_done  # If colors don't match, exit the loop

#     # Increment the counter
#     addi $s2, $s2, 1

#     # Update the start column
#     move $s3, $a1

#     # Continue checking to the left
#     j check_left_loop

# check_left_done_1:
#     # Restore return address and return
#     lw $ra, 0($sp)
#     addi $sp, $sp, 4
#     jr $ra

    
  .data
      moving_left:   .asciiz "moving left\n"
      moving_right:  .asciiz "moving right\n"
      moving_up:     .asciiz "moving up\n"
      moving_down:   .asciiz "moving down\n"
      sleeping_msg: .asciiz "Sleeping...\n"
      same_color_right_msg: .asciiz "Same-colored pixels to the right: "
    first_pixel_msg:  .asciiz "First pixel - Same-colored pixels in the row: "
    extra:  .asciiz "Fixing: "
    extra1:  .asciiz "Fixing1: "
    col_first_pixel_msg:  .asciiz "First pixel - Same-colored pixels in the column: "
    second_pixel_msg: .asciiz "Second pixel - Same-colored pixels in the row: "
    col_second_pixel_msg: .asciiz "Second pixel - Same-colored pixels in the column: "
    newline_msg:      .asciiz "\n"

    debug_row_msg: .asciiz "Row: "
debug_col_msg: .asciiz ", Column: "

debug_deletion_row_msg: .asciiz "Deletion - Row: "
debug_deletion_col_msg: .asciiz ", Column: "
debug_address_msg: .asciiz "Calculated address: "
debug_separator: .asciiz "\n------ Debugging Second Pixel ------\n"
at_row_msg:     .asciiz " at row "
column_msg:     .asciiz ", column "
deletion_msg:   .asciiz "Deleting row of size: "
debug_message_1: .asciiz "Erasing pixel at row: "
debug_message_2: .asciiz "Pixel erased successfully!\n"
dumbass: .asciiz "dumb"
virus_found: .asciiz "virus Found"