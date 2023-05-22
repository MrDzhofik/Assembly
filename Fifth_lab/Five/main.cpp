#include <QCoreApplication>
#include <iostream>
// прототип подпрограммы на ассемблере:
extern void sum(int x,int y,int *p);
extern char* modif(char* st, int len);
extern void print(char* output);

int main()
{
    char string[256];
    int length;
    std::cout<< "Input" << std::endl;
    std::cin.getline(string, 256);
    length = strlen(string);
    std::cout << length;
    modif(string, length);
    return 0;
}

extern void print(char* output){
    std::cout << "Original text: " << output << std::endl;
}
