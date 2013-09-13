/**
 * This file is part of CNotes.
 *
 * Copyright 2013 (C) Mario Guerriero <mefrio.g@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
**/

#include <QtQml>
#include <QtQml/QQmlContext>
#include "Plugin.h"
#include "dir_creator.h"


void CNotesPlugin::registerTypes(const char *uri) {
    Q_ASSERT(uri == QLatin1String("DirParser"));

    qmlRegisterType<DirParser>(uri, 0, 1, "DirParser");
}
