#include "dir_creator.h"
#include <QDir>
#include <QDirIterator>

DirParser::DirParser(QQuickItem *parent)
    : QQuickItem(parent)
{
}

bool DirParser::createDirectory(const QString &name)
{
    return QDir().mkpath(name);
}

QStringList DirParser::fetchAllFiles(const QString &name){
    QDir dir(name, QString(""), QDir::Unsorted, QDir::Files);

    QStringList entries = dir.entryList();

    short entries_count = entries.count();
    for(short i=0; i<entries_count; i++)
        entries.replace(i, dir.absoluteFilePath(entries.at(i)));

    return entries;
}

bool DirParser::dirExists(const QString &name){
    return QDir(name).exists();
}

bool DirParser::renameDir(const QString &oldName, const QString &newName){
    return QDir().rename(oldName, newName);
}

bool DirParser::removeDir(const QString &dirName){
    return QDir(dirName).removeRecursively();
}

bool DirParser::remove(const QString &name){
    return QFile(name).remove();
}

QString DirParser::relativeToAbsolute(const QString &name){
    return QDir(name).absolutePath();
}

short DirParser::getSubdirsNum(const QString &name){
    QDir dir(name, QString(""), QDir::Unsorted, QDir::NoDotAndDotDot | QDir::Dirs);
    return (short) dir.entryList().count();
}

short DirParser::getAllSubdirsNum(const QString &name){
    QDirIterator directories(name, QDir::Dirs | QDir::NoSymLinks | QDir::NoDotAndDotDot, QDirIterator::Subdirectories);
    short counter=0;
    while(directories.hasNext()){
        directories.next();
        counter++;
    }
    return counter;
}
