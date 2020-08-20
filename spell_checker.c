/***********************************************************************
* File       : <spell_checker.c>
*
* Author     : <Siavash Katebzadeh>
*
* Description:
*
* Date       : 08/10/18
*
***********************************************************************/
// ==========================================================================
// Spell checker
// ==========================================================================
// Marks misspelled words in a sentence according to a dictionary

// Inf2C-CS Coursework 1. Task B/C
// PROVIDED file, to be used as a skeleton.

// Instructor: Boris Grot
// TA: Siavash Katebzadeh
// 08 Oct 2018

#include <stdio.h>

// maximum size of input file
#define MAX_INPUT_SIZE 2048
// maximum number of words in dictionary file
#define MAX_DICTIONARY_WORDS 10000
// maximum size of each word in the dictionary
#define MAX_WORD_SIZE 20

int read_char() { return getchar(); }
int read_int()
{
    int i;
    scanf("%i", &i);
    return i;
}
void read_string(char* s, int size) { fgets(s, size, stdin); }

void print_char(int c)     { putchar(c); }
void print_int(int i)      { printf("%i", i); }
void print_string(char* s) { printf("%s", s); }
void output(char *string)  { print_string(string); }

// dictionary file name
char dictionary_file_name[] = "dictionary.txt";
// input file name
char input_file_name[] = "input.txt";
// content of input file
char content[MAX_INPUT_SIZE + 1];
// valid punctuation marks
char punctuations[] = ",.!?";
// tokens of input file
char tokens[MAX_INPUT_SIZE + 1][MAX_INPUT_SIZE + 1];
// number of tokens in input file
int tokens_number = 0;
// content of dictionary file
char dictionary[MAX_DICTIONARY_WORDS * MAX_WORD_SIZE + 1];
// output string i think?
char myArray[MAX_INPUT_SIZE + 1];
int myArrayi = 0;
char myMatch[MAX_INPUT_SIZE];
int p = 0;
int i = 0;
int j = 0;



///////////////////////////////////////////////////////////////////////////////
/////////////// Do not modify anything above
///////////////////////////////////////////////////////////////////////////////

// You can define your global variables here!

// Task B

int is_punc() {             //checks if the token starts with a punctuation
    if(tokens[i][j] == '!' || tokens[i][j] == '.' || tokens[i][j] == ',' || tokens[i][j] == '?' || tokens[i][j] == ' ') {
    return 1; }
return 0;
}

void jumpSpell () {         //Jumps to the next word in the dictionary
    while (dictionary[p] != '\n') {
    p++;
  }
    p++;
return;
}

int endoftokens() {         //Checks if the end of the tokens array has been reached
    if (tokens[i][0] == '\0') {
      return 1;
    }
return 0;
}

int wordEquality() {        //Checks the case when a full word in the token array is equal to the word in the dictionary
  if (tokens[i][j] == '\0' && (dictionary[p] == '\n' || dictionary[p] == '\0')) {
    return 1; }
  return 0;
}

int characterEquality() {   //Checks if a letter (Caps or uncaps) in the token is equal to a character in the dictionary 
    if ((dictionary[p] == tokens[i][j]) || ((tokens[i][j] + 32) == dictionary[p]) || (tokens[i][j] == (dictionary[p] + 32)) || ((tokens[i][j] + 32) == (dictionary[p] + 32))) {
      return 1;}
      return 0;
}

int endofdictionary() {    //Checks if the end of the dictionary has been reached
  if (dictionary[p] == '\0' && tokens[i][j] != '\n') {
    return 1; }
  return 0;
}




void equality() {

     if (is_punc() == 1) {
       while (tokens[i][j] != '\0') {
         printf("%c", tokens[i][j]);
         j++;
       }
      i++;
      p++;
      }

    if (endoftokens() == 1) {
      return;
    }

    else if (wordEquality() == 1) {
      j =0;
      while (tokens[i][j] != '\0') {
        printf("%c", tokens[i][j]);
        j++;
      }
       j=0;
       i++;
       p = 0;
       equality();

    }
    else if (characterEquality() == 1) {
        j++;
        p++;
        equality();
      }

    else if (endofdictionary() == 1) {
        j=0;
        printf("%c", '_');
        while (tokens[i][j] != '\0') {
          j++;
        }
        j=0;
        while (tokens[i][j] != '\0') {
        printf("%c", tokens[i][j]);
          j++;
        }
        printf("%c", '_');
        i++;
        j=0;
        p = 0;
        equality();
      }

  else {
        j = 0;
        jumpSpell();
        equality();
       }

}

void spell_checker() {
    equality();
    return;
}

// Task B
//void output_tokens() {
  //printf("%s", myArray);
  //return;
//}

//---------------------------------------------------------------------------
// Tokenizer function
// Split content into tokens
//---------------------------------------------------------------------------
void tokenizer(){
  char c;

  // index of content
  int c_idx = 0;
  c = content[c_idx];
  do {

    // end of content
    if(c == '\0'){
      break;
    }

    // if the token starts with an alphabetic character
    if((c >= 'A' && c <= 'Z' )||( c >= 'a' && c <= 'z')) {

      int token_c_idx = 0;
      // copy till see any non-alphabetic character
      do {
        tokens[tokens_number][token_c_idx] = c;

        token_c_idx += 1;
        c_idx += 1;

        c = content[c_idx];
      } while((c >= 'A' && c <= 'Z' )||( c >= 'a' && c <= 'z'));
      tokens[tokens_number][token_c_idx] = '\0';
      tokens_number += 1;

      // if the token starts with one of punctuation marks
    } else if(c == ',' || c == '.' || c == '!' || c == '?') {

      int token_c_idx = 0;
      // copy till see any non-punctuation mark character
      do {
        tokens[tokens_number][token_c_idx] = c;

        token_c_idx += 1;
        c_idx += 1;

        c = content[c_idx];
      } while(c == ',' || c == '.' || c == '!' || c == '?');
      tokens[tokens_number][token_c_idx] = '\0';
      tokens_number += 1;

      // if the token starts with space
    } else if(c == ' ') {

      int token_c_idx = 0;
      // copy till see any non-space character
      do {
        tokens[tokens_number][token_c_idx] = c;

        token_c_idx += 1;
        c_idx += 1;

        c = content[c_idx];
      } while(c == ' ');
      tokens[tokens_number][token_c_idx] = '\0';
      tokens_number += 1;
    }
  } while(1);
}
//---------------------------------------------------------------------------
// MAIN function
//---------------------------------------------------------------------------

int main (void)
{


  /////////////Reading dictionary and input files//////////////
  ///////////////Please DO NOT touch this part/////////////////
  int c_input;
  int idx = 0;

  // open input file
  FILE *input_file = fopen(input_file_name, "r");
  // open dictionary file
  FILE *dictionary_file = fopen(dictionary_file_name, "r");

  // if opening the input file failed
  if(input_file == NULL){
    print_string("Error in opening input file.\n");
    return -1;
  }

  // if opening the dictionary file failed
  if(dictionary_file == NULL){
    print_string("Error in opening dictionary file.\n");
    return -1;
  }

  // reading the input file
  do {
    c_input = fgetc(input_file);
    // indicates the the of file
    if(feof(input_file)) {
      content[idx] = '\0';
      break;
    }

    content[idx] = c_input;

    if(c_input == '\n'){
      content[idx] = '\0';
    }

    idx += 1;

  } while (1);

  // closing the input file
  fclose(input_file);

  idx = 0;

  // reading the dictionary file
  do {
    c_input = fgetc(dictionary_file);
    // indicates the end of file
    if(feof(dictionary_file)) {
      dictionary[idx] = '\0';
      break;
    }

    dictionary[idx] = c_input;
    idx += 1;
  } while (1);

  // closing the dictionary file
  fclose(dictionary_file);
  //////////////////////////End of reading////////////////////////
  ////////////////////////////////////////////////////////////////

  tokenizer();

  spell_checker();

  //output_tokens();

  return 0;
}
