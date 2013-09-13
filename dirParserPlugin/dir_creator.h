#ifndef PIECHART_H
#define PIECHART_H

#include <QtQuick/QQuickItem>

class DirParser : public QQuickItem
{
    Q_OBJECT

public:
    DirParser(QQuickItem *parent = 0);
    Q_INVOKABLE bool createDirectory(const QString &name);
    Q_INVOKABLE QStringList fetchAllFiles(const QString &name);
    Q_INVOKABLE bool dirExists(const QString &name);
    Q_INVOKABLE QString relativeToAbsolute(const QString &name);
    Q_INVOKABLE bool renameDir(const QString &oldName, const QString &newName);
    Q_INVOKABLE bool removeDir(const QString &dirName);
    Q_INVOKABLE bool remove(const QString &name);
    Q_INVOKABLE short getSubdirsNum(const QString &name);
    Q_INVOKABLE short getAllSubdirsNum(const QString &name);
};

#endif
