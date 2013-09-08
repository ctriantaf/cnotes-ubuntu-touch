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
    Q_INVOKABLE bool removeDir(const QString &dirName);
    Q_INVOKABLE bool remove(const QString &name);
};

#endif
