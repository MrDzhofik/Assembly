#include <QCoreApplication>
#include <cstdlib>
#include <iostream>
#include <string>

using namespace std;

extern "C" void input(char* str);
extern "C" void ccmp(char* str1, char* str2, char* res);

int main(){
    char str1[255];
    char str2[255];
    char res[255];
    cout << "Введите первую строку(max 255 симв.)" << endl;
    input(str1);
    cout << "Введите вторую строку(max 255 симв.)" << endl;
    input(str2);
    ccmp(str1, str2, res);
    cout << "Совпавшие фрагменты строк:\n" << res << endl;
    return 0;
}
