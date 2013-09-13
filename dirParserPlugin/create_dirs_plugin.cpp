#include "create_dirs_plugin.h"
#include "dir_creator.h"
#include <qqml.h>

void CreateDirsPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<DirParser>(uri, 1, 0, "DirParser");
}
