#include <iostream>
#include <set>
#include <string>

using namespace std;

int main() {
  setlocale(LC_ALL, "ru");
  string s;
  getline(cin, s);
  int size = s.size();
  for (int i = 1; i < size; i++) {
    if (s[i] == ' ' && s[i - 1] == ' ') {
      s.erase(i, 1);
      i--;
      size--;
    }
  }
  set<char> sl_sym = {'(', ')', '=', ';'};
  string op_while = "while";
  string cur = "";
  bool chislo = false;
  bool ident = false;
  bool error = false;
  bool op_sc = false;
  bool sign = true;
  for (int i = 0; i < s.size(); i++) {
    if ((s[i] >= 'a' && s[i] <= 'z') || (s[i] >= 'A' && s[i] <= 'Z')) {
      if (cur.size() == 0) ident = true;
      if (chislo) error = true;
      cur += s[i];
    } else if (s[i] >= '0' && s[i] <= '9') {
      if (cur.size() == 0) chislo = true;
      cur += s[i];
    } else if (s[i] == ' ') {
      if (chislo) {
        std::cout << "Число " << cur << endl;
        chislo = false;
      } else if (ident) {
        std::cout << "Идентификатор " << cur << endl;
        ident = false;
      }
      cur = "";
    } else if (s[i] == '=') {
      if (!ident) {
        error = 1;
        std::cout << "error1" << endl;
      }
      if (ident) {
        std::cout << "Идентификатор " << cur << endl;
        ident = 0;
        cur = "";
      }
      std::cout << "Служебный символ '='" << endl;
      cur = "";
    } else if (s[i] == '(') {
      if (op_sc) error = 1;
      op_sc = true;
      std::cout << "Служебный символ '('" << endl;
    } else if (s[i] == ')') {
      if (!op_sc) error = true;
      if (ident) {
        std::cout << "Идентификатор " << cur << endl;
        ident = 0;
        cur = "";
      }
      std::cout << "Служебный символ ')'" << endl;
      op_sc = false;
    } else if (s[i] == '-') {
      if (sign) error = 1;
      chislo = true;
      if (cur.size() > 0) error = 1;
    } else if (s[i] == ';') {
      if (op_sc) error = 1;
      if (ident) {
        std::cout << "Идентификатор " << cur << endl;
        ident = 0;
        cur = "";
      }
      if (chislo) {
        std::cout << "Число " << cur << endl;
        chislo = 0;
        cur = "";
      }
      std::cout << "Служебный символ ';'" << endl;
    }
  }
  if (op_sc) error = 1;
  if (error) std::cout << "Грамматика нарушена" << endl;
  return 0;
}
