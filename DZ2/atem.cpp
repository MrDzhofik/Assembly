#include <algorithm>
#include <cstring>
#include <initializer_list>
#include <iostream>
using namespace std;

void removeExtraSpaces(char* inputs, char* output) {
  int c = 0, d = 0;
  while (inputs[c] != '\0') {
    if (!(inputs[c] == ' ' && inputs[c + 1] == ' ')) {
      output[d] = inputs[c];
      d++;
    }
    c++;
  }

  output[d] = '\0';
}

void skipSpace(char* string, int* start) {
  if (string[*start] == ' ') {
    *start += 1;
  }
}

void findWord(char* string, char* output) {
  char* space = strchr(string, ' ');
  char* sqBracket = strchr(string, '[');
  char* rBracket = strchr(string, '{');
  char* strEnd = strchr(string, '\0');
  char* comma = strchr(string, ',');
  char* semicolon = strchr(string, ';');
  size_t fSpace = space - string;
  size_t fsqBracket = sqBracket - string;
  size_t frBracket = rBracket - string;
  size_t fstrEnd = strEnd - string;
  size_t fcomma = comma - string;
  size_t fsemicolon = semicolon - string;
  ;
  size_t closest =
      min({fSpace, fsqBracket, frBracket, fstrEnd, fcomma, fsemicolon});
  strncpy(output, string, closest);
}

void findNumber(char* string, char* output) {
  char* sqBracket = strchr(string, ']');
  size_t fsqBracket = sqBracket - string;
  size_t closest = fsqBracket;
  strncpy(output, string, closest);
}

int checkNumber(char* str1) {
  int i, x = 0, p;
  p = strlen(str1);

  for (i = 0; i < p; i++)
    if ((str1[i] >= '0' && str1[i] <= '9')) {
      continue;
    } else
      return 0;

  return 1;
}

int checkWord(char* str1) {
  int i, x = 0, p;
  p = strlen(str1);

  for (i = 0; i < p; i++)
    if ((str1[i] >= 'a' && str1[i] <= 'z') ||
        (str1[i] >= 'A' && str1[i] <= 'Z') || (str1[i] == ' ') ||
        (str1[i] >= '0' && str1[i] <= '9')) {
      continue;
    } else
      return 0;

  return 1;
}

void type(char* string, bool* correct, int* start) {
  char* stringpos = string + *start;
  bool foundType = false;
  if (strncmp(stringpos, "float", 5) == 0) {
    cout << "Detected type float\n";
    foundType = true;
    *start += 5;
  }
  if (strncmp(stringpos, "int", 3) == 0) {
    cout << "Detected type int\n";
    foundType = true;
    *start += 3;
  }
  if (strncmp(stringpos, "char", 4) == 0) {
    cout << "Detected type char\n";
    foundType = true;
    *start += 4;
  }
  if (strncmp(stringpos, "struct", 6) == 0) {
    cout << "Detected type struct\n";
    foundType = true;
    *start += 6;
  }
  if (strncmp(stringpos, "unsigned", 8) == 0) {
    stringpos += 9;
    if (strncmp(stringpos, "char", 4) == 0) {
      cout << "Detected type unsigned char\n";
      foundType = true;
      *start += 13;
    }
  }
  if (foundType) return;
  char output[20] = "";
  findWord(stringpos, output);
  cout << "Incorrect variable type:\"" << output << "\"\n";
  *correct = false;
}

void ident(char* string, bool* correct, int* start) {
  char* stringpos = string + *start;
  char output[20] = "";
  findWord(stringpos, output);
  if (!checkWord(output)) {
    cout << "Incorrect variable name:\"" << output << "\"\n";
    *correct = false;

  } else {
    cout << "Variable name:\"" << output << "\"\n";
    *start += strlen(output);
  }
}

void checksymbol(char* string, bool* correct, int* start, const char* symbol,
                 const char* correctin, const char* incorrectin) {
  if (*correct) {
    char* stringpos = string + *start;
    if (strncmp(stringpos, symbol, 1) == 0) {
      cout << "Detected symbol \"" << symbol << "\"\n";
      *start += 1;
    } else {
      cout << "Incorrect symbol \"" << stringpos[0] << "\", expected \""
           << symbol << "\"\n";
      *correct = false;
    }
  }
}

void findAndCheckNumber(char* string, bool* correct, int* start,
                        const char* correctin, const char* incorrectin) {
  if (*correct) {
    char* stringpos = string + *start;
    char output[20] = "";
    findNumber(stringpos, output);
    if (checkNumber(output)) {
      cout << "Detected count: " << output << "\n";
      *start += strlen(output);
    } else {
      cout << "Incorrect number: " << output << "\n";
      *correct = false;
    }
  }
}

void var(char* string, bool* correct, int* start) {
  skipSpace(string, start);
  type(string, correct, start);
  skipSpace(string, start);
  ident(string, correct, start);
  skipSpace(string, start);
  char* stringpos = string + *start;
  // cout << stringpos[0];
  if (strncmp(stringpos, "[", 1) == 0) {
    checksymbol(string, correct, start, "[", "", "");
    skipSpace(string, start);
    findAndCheckNumber(string, correct, start, "", "");
    skipSpace(string, start);
    checksymbol(string, correct, start, "]", "", "");
  }
  skipSpace(string, start);
  checksymbol(string, correct, start, ";", "", "");
}

void vars(char* string, bool* correct, int* start);

void structtype(char* string, bool* correct, int* start) {
  skipSpace(string, start);
  type(string, correct, start);
  skipSpace(string, start);
  ident(string, correct, start);
  skipSpace(string, start);
  checksymbol(string, correct, start, "{", "", "");
  vars(string, correct, start);
  checksymbol(string, correct, start, "}", "", "");
  skipSpace(string, start);
  ident(string, correct, start);
  skipSpace(string, start);
  char* stringpos = string + *start;
  while (!(strncmp(stringpos, ";", 1) == 0) &&
         !(strncmp(stringpos, "\0", 1) == 0) && *correct) {
    checksymbol(string, correct, start, ",", "", "");
    skipSpace(string, start);
    ident(string, correct, start);
    skipSpace(string, start);
    stringpos = string + *start;
  }
  checksymbol(string, correct, start, ";", "", "");
}

void vars(char* string, bool* correct, int* start) {
  skipSpace(string, start);
  char* stringpos = string + *start;
  while (!(strncmp(stringpos, "\0", 1) == 0) && *correct &&
         !(strncmp(stringpos, "}", 1) == 0)) {
    char output[20] = "";
    findWord(stringpos, output);
    if (strncmp(output, "struct", 6) == 0) {
      structtype(string, correct, start);
    } else {
      var(string, correct, start);
    }
    skipSpace(string, start);
    stringpos = string + *start;
  }
}

int main() {
  // char str[] =  "   unsigned char aer[8]; char record[80]; struct student {
  // char name[22];char family[22];int old; } st1,ft";
  char str[1000] = "";
  cout << "Enter string:"
       << "\n";
  cin.getline(str, sizeof(str));
  char strwspaces[strlen(str)];
  removeExtraSpaces(str, strwspaces);
  bool correct = true;
  int start = 0;
  vars(strwspaces, &correct, &start);

  if (correct) {
    cout << "Yes"
         << "\n";
  } else {
    cout << "No"
         << "\n";
  }

  return 0;
}
