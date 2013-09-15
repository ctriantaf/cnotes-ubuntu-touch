import QtQuick 2.0
import Ubuntu.Components 0.1

ToolbarItems {
        ToolbarButton {
            visible: {
                if (mainView.showArchive) {
                    return false
                }
                return true
            }

            action: Action {
                id: addNoteAction
                objectName: "addNoteAction"

                iconSource: Qt.resolvedUrl("../images/add.svg")
                text: i18n.tr("Add")

                onTriggered: {
                    mainView.mode = "add"
                    mainView.id = mainView.idCount
                    rootPageStack.push(Qt.resolvedUrl("../pages/CreateNotePage.qml"))
                }
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
                if (mainView.wideAspect && mainView.notes.count > 0) {
                    return true
                }
                return false
            }
        }

        ToolbarButton {
            action: Action {
                id: imagesViewAction
                objectName: "imagesViewAction"

                iconSource: Qt.resolvedUrl("../images/browser-tabs.svg")
                text: i18n.tr("Images")

                onTriggered: rootPageStack.push(Qt.resolvedUrl("../components/ImagesTab.qml"))
            }

            visible: {
                if (mainView.wideAspect && mainView.notes.count > 0) {
                    return true
                }
                return false
            }
        }

        ToolbarButton {
            action: Action {
                id: linksViewAction
                objectName: "linksViewAction"

                iconSource: Qt.resolvedUrl("../images/browser-tabs.svg")
                text: i18n.tr("Links")

                onTriggered: rootPageStack.push(Qt.resolvedUrl("../components/LinksTab.qml"))
            }

            visible: {
                if (mainView.wideAspect && mainView.notes.count > 0) {
                    return true
                }
                return false
            }
        }

        ToolbarButton {
            action: Action {
                id: deleteArchive
                objectName: "deleteArchive"

                iconSource: Qt.resolvedUrl("../images/close.svg")
                text: i18n.tr("Delete all")

                onTriggered: mainView.backend.deleteArchive()
            }

            visible: {
                if (mainView.showArchive) {
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

                    if (text === i18n.tr("Archive")) {
//                        notesListView.model = archivesModel
                        mainView.showArchive = true
                        notesListView.model = mainView.database.getDoc("archive").notes
                        text = i18n.tr("Notes")
                    }
                    else if (text === i18n.tr("Notes")) {
//                        notesListView.model = notes
                        notesListView.model = mainView.database.getDoc("notes").notes
                        mainView.showArchive = false
                        text = i18n.tr("Archive")
                    }
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
