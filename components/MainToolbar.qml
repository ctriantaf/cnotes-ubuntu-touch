import QtQuick 2.0
import Ubuntu.Components 0.1

ToolbarItems {
        ToolbarButton {
            action: Action {
                id: addNoteAction
                objectName: "addNoteAction"

                iconSource: Qt.resolvedUrl("../images/add.svg")
                text: i18n.tr("Add")

                onTriggered: rootPageStack.push(Qt.resolvedUrl("../pages/CreateNotePage.qml"))
            }
        }

        ToolbarButton {
            action: Action {
                id: editAction
                objectName: "editAction"

                iconSource: Qt.resolvedUrl("../images/edit.svg")
                text: i18n.tr("Edit")

                onTriggered: rootPageStack.push(Qt.resolvedUrl("../pages/EditNotePage.qml"))
            }

            visible: {
                if (mainView.wideAspect) {
                    return true
                }
                return false
            }
        }

        ToolbarButton {
            action: Action {
                id: archivesPageAction
                objectName: "archivesPageAction"

                iconSource: Qt.resolvedUrl("../images/select.svg")
                text: i18n.tr("Archive")

                onTriggered: {
                    notesListView.model = archivesModel
                    notesListView.update()

//                    if (!mainView.wideAspect) {
//                        rootPageStack.push(Qt.resolvedUrl("ArchivesPage.qml"))
//                    }
                }
            }
        }

        ToolbarButton {
            action: Action {
                id: categoriesPageAction
                objectName: "categoriesPageAction"

                iconSource: Qt.resolvedUrl("../images/edit.svg")
                text: i18n.tr("Categories")

                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("../pages/CategoriesPage.qml"))
                }
            }
        }
}
