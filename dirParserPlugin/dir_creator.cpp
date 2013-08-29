#include "dir_creator.h"
#include <QDir>

DirParser::DirParser(QQuickItem *parent)
    : QQuickItem(parent)
{
}

bool DirParser::createDirectory(const QString &name)
{
    QDir dir;
    return dir.mkpath(name);
}

QStringList DirParser::fetchAllFiles(const QString &name){
    QDir dir(name, QString(""), QDir::Unsorted, QDir::Files);

    QStringList entries = dir.entryList();

    QString dir_absolute_path = dir.absolutePath();

    short entries_count = entries.count();
    for(short i=0;i<entries_count;i++)
        entries.replace(i, dir_absolute_path+"/"+entries.at(i));
    return entries;
}

bool DirParser::dirExists(const QString &name){
    return QDir(name).exists();
}

bool DirParser::removeDir(const QString &dirName){
    QDir dir(dirName);
    return dir.removeRecursively();
}

bool DirParser::remove(const QString &name){
    return QFile(name).remove();
}
