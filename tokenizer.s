
#=========================================================================
# Tokenizer
#=========================================================================
# Split a string into alphabetic, punctuation and space tokens
# 
# Inf2C Computer Systems
# 
# Siavash Katebzadeh
# 8 Oct 2018
# 
#
#=========================================================================
# DATA SEGMENT
#=========================================================================
.data
#-------------------------------------------------------------------------
# Constant strings
#-------------------------------------------------------------------------

input_file_name:        .asciiz  "input.txt"   
newline:                .asciiz  "\n"
        
#-------------------------------------------------------------------------
# Global variables in memory
#-------------------------------------------------------------------------
# 
content:                .space 2049     # Maximun size of input_file + NULL
tokenArray:		.space 4098


# You can add your data here!
        
#=========================================================================
# TEXT SEGMENT  
#=========================================================================
.text

#-------------------------------------------------------------------------
# MAIN code block
#-------------------------------------------------------------------------

.globl main                     # Declare main label to be globally visible.
                                # Needed for correct operation with MARS
main:
        
#-------------------------------------------------------------------------
# Reading file block. DO NOT MODIFY THIS BLOCK
#-------------------------------------------------------------------------

# opening file for reading

        li   $v0, 13                    # system call for open file
        la   $a0, input_file_name       # input file name
        li   $a1, 0                     # flag for reading
        li   $a2, 0                     # mode is ignored
        syscall                         # open a file
        
        move $s0, $v0                   # save the file descriptor 

# reading from file just opened

        move $t0, $0                    # idx = 0

READ_LOOP:                              # do {
        li   $v0, 14                    # system call for reading from file
        move $a0, $s0                   # file descriptor
                                        # content[idx] = c_input
        la   $a1, content($t0)          # address of buffer from which to read
        li   $a2,  1                    # read 1 char
        syscall                         # c_input = fgetc(input_file);
        blez $v0, END_LOOP              # if(feof(input_file)) { break }
        lb   $t1, content($t0)          
        addi $v0, $0, 10                # newline \n
        beq  $t1, $v0, END_LOOP         # if(c_input == '\n')
        addi $t0, $t0, 1                # idx += 1
        j    READ_LOOP
END_LOOP:
        sb   $0,  content($t0)

        li   $v0, 16                    # system call for close file
        move $a0, $s0                   # file descriptor to close
        syscall                         # fclose(input_file)
#------------------------------------------------------------------
# End of reading file block.
#------------------------------------------------------------------

# You can add your code here!
li $t0, 0                                        #int c_idx = 0;

bigloop:
          lb $t2, content($t0)	                 #c = content[c_idx];
          beqz  $t2, printmyArray                     #if(c == '\0'){
	
          lb   $s0, newline                      #$s0 holds the newline character
          addi $s1, $zero, 95                    #$s1 holds the ascii value for '_'
          addi $s2, $zero, 65                    #$s2 holds the ascii value for A
          addi $s3, $zero, 32                    #$s3 holds the ascii value for the space key
          addi $s4, $zero, 33                    #$s4 holds the ascii value for the '!' key
          addi $s5, $zero, 63                    #$s5 holds the ascii value for the '?' key
          addi $s6, $zero, 44                    #$s6 holds the ascii value for the ',' key
          addi $s7, $zero, 46                    #$s7 holds the ascii value for the '.' key
	
	
	
          bge $t2, $s2, smallWordloop	         #if(c >= 'A' && c <= 'Z' || c >= 'a' && c <= 'z')
	
          beq $t2, $s3, smallSpaceloop           #else if(c == ' ') {
                                                
                                                 #else if(c == ',' || c == '.' || c == '!' || c == '?') {	                              
          beq $t2, $s4, smallPuncloop
          beq $t2, $s5, smallPuncloop
          beq $t2, $s6, smallPuncloop
          beq $t2, $s7, smallPuncloop
	
smallWordloop:                         #copy till see any non-alphabetic character
	
          sb $t2, tokenArray($t3)                #tokens[tokens_number][token_c_idx] = c;
          addi $t0, $t0, 1                       #c_idx += 1;
          lb $t2, content($t0)                   #c = content[c_idx];
          blt $t2, $s2, newliner                 #while(c >= 'A' && c <= 'Z' || c >= 'a' && c <= 'z');
          addi $t3, $t3, 1                       #token_c_idx += 1;
          sb $t2, tokenArray($t3)                #tokens[tokens_number][token_c_idx] = c;
	
j smallWordloop


smallPuncloop:                         #copy till see any non-punctuation mark character
	
          sb $t2, tokenArray($t3)                #tokens[tokens_number][token_c_idx] = c;
          addi $t0, $t0, 1                       #c_idx += 1;
          lb $t2, content($t0)                   #c = content[c_idx];
          
          blt $t2, $s4, newliner                 #while(c == ',' || c == '.' || c == '!' || c == '?');
          bgt $t2, $s5, newliner
          
          addi $t3, $t3, 1                       #token_c_idx += 1;
          sb $t2, tokenArray($t3)                #tokens[tokens_number][token_c_idx] = c; 
	
j bigloop


smallSpaceloop:                        #copy till see any non-space character

          sb $t2, tokenArray($t3)                #tokens[tokens_number][token_c_idx] = c;
          addi $t0, $t0, 1                       #c_idx += 1;
          lb $t2, content($t0)                   #c = content[c_idx];
          bne $t2, $s3, newliner                 #while(c == ' ');
          addi $t3, $t3, 1                       #token_c_idx += 1;
          sb $t2, tokenArray($t3)                #tokens[tokens_number][token_c_idx] = c;
	
j smallSpaceloop

j bigloop

printmyArray:
li $t3, 0
printmyArrayLOOP:
		lb $t8 tokenArray($t3)	#puts element in first index of array into $t8
		beqz  $t8, main_end	#when end of array space is reached, exit loop
	
		addi $t3, $t3, 1	#increments $t3 by 1

		
		li $v0, 11		#prints element in $t8
		move $a0, $t8
		syscall
		
					
	
		
j printmyArrayLOOP

newliner:                              #Adds a newline character when called
          
          addi $t3, $t3, 1                       #token_c_idx += 1;
          lb $t4, newline                        #Loads the newline character into $t4	
          sb $t4, tokenArray($t3)                #Adds the newline character into the tokens array
          addi $t3, $t3, 1                       #token_c_idx += 1;
	
j bigloop
	  
#------------------------------------------------------------------
# Exit, DO NOT MODIFY THIS BLOCK
#------------------------------------------------------------------
main_end:      
        li   $v0, 10          # exit()
        syscall

#----------------------------------------------------------------
# END OF CODE
#----------------------------------------------------------------
