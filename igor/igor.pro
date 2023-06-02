QT -= gui


CONFIG += c++11 console
# консольное приложение
CONFIG -= app_bundle
DEFINES += QT_DEPRECATED_WARNINGS
SOURCES += main.cpp
OBJECTS += igor.o # подключение объектного модуля ассемблерной
# подпрограммы
DISTFILES += igor.asm \ # включение в проект исходного модуля61
# на ассемблере для удобства вызова его
# исходного текста в текстовый редактор
CONFIG ~= s/-O[0123s]//g \ # отключение оптимизации
    five.o
CONFIG += -O0


# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


