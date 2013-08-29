TEMPLATE = lib
CONFIG += plugin
QT += qml quick
DESTDIR = DirParser
TARGET = dirparserplugin
OBJECTS_DIR = tmp
MOC_DIR = tmp

HEADERS += \
    create_dirs_plugin.h \
    dir_creator.h

SOURCES += \
    create_dirs_plugin.cpp \
    dir_creator.cpp

OTHER_FILES += \
    app.qml
