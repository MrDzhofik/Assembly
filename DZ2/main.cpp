#include <algorithm>
#include <cstring>
#include <initializer_list>
#include <iostream>
#include <set>
#include <string>

#include "stdio.h"

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

int main() {
  string s;
  //   char* swscurr;
  int iter = 0;
  getline(cin, s);
  int size = s.size();
  string output;
  set<string> sl_sym = {"typedef", "struct", "{",   "}",    ";", "=",
                        "[",       "]",      "int", "char", ","};
  bool sluj = false;
  bool znachenie = false;
  bool open = false;
  bool ident = false;
  bool error = false;
  bool correct = true;
  bool now_char = false;
  bool now_int = false;
  bool open_brace = false;
  bool spec = false;
  int stroka = 0;
  bool znach = false;
  bool open_sq_brace = false;
  for (int i = 0; i < size; i++) {
    while ((s[i] != ' ') && (i < size)) {
      if (s[i] == '{') {
        if (znach) {
          open = true;
        }
        open_brace = true;
        cout << "Служебный символ " << s[i] << endl;
        i++;
      }
      if (s[i] == '=') {
        znach = true;
      }
      if ((s[i] == '}') && (znach)) {
        znach = false;
      }
      if (s[i] == '"') {
        stroka = (stroka + 1) % 2;
      }
      if (s[i] == '[') {
        cout << "Служебный символ " << s[i] << endl;
        open_sq_brace = true;
      }
      if (s[i] == ']') {
        cout << "Служебный символ " << s[i] << endl;
        open_sq_brace = false;
      }
      if (s[i] == '}') {
        open_brace = false;
      }
      if ((s[i] == ',') || (s[i] == '}') || (s[i] == ';') || (s[i] == '=')) {
        if (s[i] == '[') cout << "Служебный символ " << s[i] << endl;
        spec = true;
        i++;
      }
      output += s[i];
      i++;
      if (spec) {
        spec = false;
        i--;
      }
    }

    if (sl_sym.count(output)) {
      cout << "Распознан служебный символ " << output << endl;
      if (output == "char") {
        now_char = true;
      }
    } else if ((output[0] != ' ') && (znachenie)) {
      cout << "Литерал " << output << endl;
    } else if (output[0] != ' ') {
      cout << "Идентификатор " << output << endl;
    }
    output = "";
    znachenie = znach;
  }
  if (!(open_brace) && (!(open_sq_brace))) {
    cout << "Все верно" << endl;
  } else {
    cout << "Утеряна скобка" << endl;
  }
  return 0;
}