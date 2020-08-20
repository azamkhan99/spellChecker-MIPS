
#=========================================================================
# Punctuation checker 
#=========================================================================
# Marks misspelled words and punctuation errors in a sentence according to a dictionary
# and punctuation rules
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
dictionary_file_name:   .asciiz  "dictionary.txt"
newline:                .asciiz  "\n"
        
#-------------------------------------------------------------------------
# Global variables in memory
#-------------------------------------------------------------------------
# 
content:                .space 2049     # Maximun size of input_file + NULL
.align 4                                # The next field will be aligned
dictionary:             .space 200001   # Maximum number of words in dictionary *
                                        # maximum size of each word + NULL
tokenArray:		.space 4098
spellingArray:          .space 100000
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
        sb   $0,  content($t0)          # content[idx] = '\0'

        # Close the file 

        li   $v0, 16                    # system call for close file
        move $a0, $s0                   # file descriptor to close
        syscall                         # fclose(input_file)


        # opening file for reading

        li   $v0, 13                    # system call for open file
        la   $a0, dictionary_file_name  # input file name
        li   $a1, 0                     # flag for reading
        li   $a2, 0                     # mode is ignored
        syscall                         # fopen(dictionary_file, "r")
        
        move $s0, $v0                   # save the file descriptor 

        # reading from file just opened

        move $t0, $0                    # idx = 0

READ_LOOP2:                             # do {
        li   $v0, 14                    # system call for reading from file
        move $a0, $s0                   # file descriptor
                                        # dictionary[idx] = c_input
        la   $a1, dictionary($t0)       # address of buffer from which to read
        li   $a2,  1                    # read 1 char
        syscall                         # c_input = fgetc(dictionary_file);
        blez $v0, END_LOOP2             # if(feof(dictionary_file)) { break }
        lb   $t1, dictionary($t0)               
        lb   $t1, dictionary($t0)               
        beq  $t1, $0,  END_LOOP2        # if(c_input == '\n')
        addi $t0, $t0, 1                # idx += 1
        j    READ_LOOP2
END_LOOP2:
        sb   $0,  dictionary($t0)       # dictionary[idx] = '\0'

        # Close the file 

        li   $v0, 16                    # system call for close file
        move $a0, $s0                   # file descriptor to close
        syscall                         # fclose(dictionary_file)
#------------------------------------------------------------------
# End of reading file block.
#------------------------------------------------------------------

li $t0, 0                                        #int c_idx = 0;

bigloop:
          lb $t2, content($t0)	                 #c = content[c_idx];
          beqz  $t2, newTask                     #if(c == '\0'){
	
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


newliner:                              #Adds a newline character when called
          
          addi $t3, $t3, 1                       #token_c_idx += 1;
          lb $t4, newline                        #Loads the newline character into $t4	
          sb $t4, tokenArray($t3)                #Adds the newline character into the tokens array
          addi $t3, $t3, 1                       #token_c_idx += 1;
	
j bigloop


#------------------------------------------------------------------
# End of Tokenizer code
#------------------------------------------------------------------


newTask:
          li $t0, 0
          li $t1, 0
          li $t2, 0
          li $t3, 0
          li $t6, 0
          li $t5, 0

typeOfChar:
          lb $t5, tokenArray($t3)      #loads character of tokenArray into $t5
          lb $t1, dictionary($t0)      #loads character of dictionary into $t1
          add $t8, $zero, $t3
          beq $t5, $zero, print_spellingArray
          bge $t5, $s2, scanVar	       #If character is a letter then compares to dictionary
         
          beq $t5, $s3, print_punc     #if(tokens[i][j] == '!' || tokens[i][j] == '.' || tokens[i][j] == ',' || tokens[i][j] == '?' || tokens[i][j] == ' ')
          beq $t5, $s4, punc
          beq $t5, $s5, punc
          beq $t5, $s6, punc
          beq $t5, $s7, punc
                                                                                    
                                                                                                                                               
scanVar:
          add $t8, $zero, $t3
scan:
          lb $t1, dictionary($t0)                #loads character of dictionary into $t1
          lb $t5, tokenArray($t3)                #loads character of tokenArray into $t5
          beq $t1, $zero, firstUnderscore
          beq $t5, $s0, endoftoken
          beq $t1, $t5, tokenIter
          subi $t1, $t1, 32                      #This and the next two lines of code account for case sensitivity
          beq $t1, $t5, tokenIter
          addi $t1, $t1, 32
         
           j jumpSpell
          

jumpSpell:                             #Jumps to next word in dictionary when called
	
          lb $t1, dictionary($t0)
          addi $t0, $t0, 1
          beq $t1, $s0, jumpIter
          j jumpSpell
          
jumpIter: 
          add $t3, $zero, $t8
          j scan


tokenIter:                             #Adds one to both the pointers for dictionary and token array
         
          addi $t3, $t3, 1
          addi $t0, $t0, 1
          j scan          
                   
endoftoken:
         
          beq $t1, $s0, reset_dict     #if (tokens[i][j] == '\0' && (dictionary[p] == '\n' || dictionary[p] == '\0'))
          j jumpSpell
          
reset_dict:                            #Resets the dictionary pointer
          addi $t0, $zero, 0
          j callTempVar
          
callTempVar:
          add $t3, $zero, $t8
          
          
print_word:                            #Adds the correctly spelled words to the array
                                       #printf("%c", tokens[i][j]);
          lb $t5, tokenArray($t3)
          sb $t5, spellingArray($t6) 
          beq $t5, $s0, print_CharIter
          addi $t3, $t3, 1
          addi $t6, $t6, 1
          j print_word   
          
print_CharIter:
          addi $t3, $t3, 1
          j typeOfChar  

print_punc:                            #Adds the correct punctuation tokens to the array
                                       #printf("%c", tokens[i][j]);
          lb $t5, tokenArray($t3)
          beq $t5, $s0, print_CharIter
          beq $t5, $zero, print_CharIter
          addi $t3, $t3, 1
          sb $t5, spellingArray($t6)
          addi $t6, $t6, 1

          j print_punc

                                
firstUnderscore:                       #Adds an underscore character to the array when called
                                       #printf("%c", '_');
          sb $s1, spellingArray($t6)
          addi $t6, $t6, 1
          add $t3, $zero, $t8
                     
wrongWords:
                                       #printf("%c", tokens[i][j]);
          lb $t5, tokenArray($t3)
          sb $t5, spellingArray($t6)
          beq $t5, $s0, followedUnderscore
          j wrongWordsIter                   
wrongWordsIter:
          addi $t3, $t3, 1
          addi $t6, $t6, 1
          j wrongWords
          
followedUnderscore:                    #Adds another underscore character after the tokens
                                       #printf("%c", '_');
          sb $s1, spellingArray($t6)
          addi $t6, $t6, 1
          addi $t3, $t3, 1
          addi $t0, $zero, 0
          j typeOfChar          
                                   
     
                                         
print_spellingArray:
addi $t6, $zero, 0        
print_spellingArrayLOOP:
          lb $t9 spellingArray($t6)	#puts element in first index of array into $t9
	  beq  $t9, $zero, main_end	#when end of array space is reached, exit loop
	
          addi $t6, $t6, 1	#increments the pointer in spellingArray by 1

          li $v0, 11		#prints element in $t9
          move $a0, $t9
	  syscall
	  
	  j print_spellingArrayLOOP
	  
	  
#------------------------------------------------------------------
# End of Spell Checker code 
#------------------------------------------------------------------        

#I didnt write C code for this task so can't use it as comments for the MIPS code

li $t7, 0
                
punc:
          lb $t5, tokenArray($t3)                #Loads character from token array into $t5
          beq $t5, $s4, puncLeft                 #checks if char is a '!'
          beq $t5, $s5, puncLeft                 #checks if char is a '?'
          beq $t5, $s6, puncLeft                 #checks if char is a ','
          beq $t5, $s7, fullstopJob              #checks if char is a '.'
          
                         
fullstopIter:
          addi $t7, $t7, 1
          j fullstopJob

        
fullstopJob:                           #If the character is a fullstop, checks if the next character is also a fullstop.
          addi $t3, $t3, 1
          lb $t5, tokenArray($t3)
          
          beq $t5, $s7, fullstopIter   #Iterates a variable everytime a fullstop is read in
          beq $t7, 0, nextChar         #Correct punctuation if only one fullstop
          beq $t7, 2, nextChar         #Correct punctuation if 3 fullstops
         
           j firstUnderscore
          

puncLeft:                              #Checks the character preceding the current punctuation mark
	  subi $t3, $t3, 2	
          lb $t5, tokenArray($t3)
          addi $t3, $t3, 2
          beq $t5, $s3, firstUnderscore          #If the character is a space, incorrect punctuation           
          j puncRight
          
                          
puncRight:                             #Checks the character succeeding the current punctuation mark
          addi $t3, $t3, 1
          lb $t5, tokenArray($t3)
          
          bne $t5, $s0, firstUnderscore          #If the character isnt a space, incorrect punctuation
          j nextChar
          
nextChar:
          addi $t3, $t3, 1
          lb $t5, tokenArray($t3)
          add $t3, $zero, $t8
          beqz $t5, print_punc
          bne $t5, $s3, firstUnderscore
          j print_punc           
        
                    
#------------------------------------------------------------------
# Exit, DO NOT MODIFY THIS BLOCK
#------------------------------------------------------------------
main_end:      
        li   $v0, 10          # exit()
        syscall

#----------------------------------------------------------------
# END OF CODE
#----------------------------------------------------------------
