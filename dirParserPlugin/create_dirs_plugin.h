#ifndef CREATE_DIRS_PLUGIN_H
#define CREATE_DIRS_PLUGIN_H

#include <QQmlExtensionPlugin>

class CreateDirsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.hakermania.createDirs")

public:
    void registerTypes(const char *uri);
};

#endif
