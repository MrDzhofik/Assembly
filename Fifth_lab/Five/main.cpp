#include <QCoreApplication>
#include <iostream>
extern "C" void modif(char* st, int len);
extern "C" void print(char* output);

int main()
{
    char string[256];
    int length;
    std::cout<< "Input" << std::endl;
    std::cin.getline(string, 256);
    length = strlen(string);
    modif(string, length);
    std::cout << std::endl;
    return 0;
}

void print(char* output){
    std::cout << "Original text: " << output << std::endl;
}
