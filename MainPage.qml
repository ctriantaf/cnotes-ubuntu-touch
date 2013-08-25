import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Layouts 0.1
import "Storage.js" as Storage
//import "U1Backend.qml" as U1Backend

Page {

    U1Backend {
        id: u1Backend
    }

    id: mainPage
    title: i18n.tr("CNotes")
    visible: false

    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                id: addNoteAction
                objectName: "addNoteAction"

                iconSource: Qt.resolvedUrl("images/add.svg")
                text: i18n.tr("Add")

                onTriggered: pageStack.push(Qt.resolvedUrl("CreateNotePage.qml"))
            }
        }

        ToolbarButton {
            action: Action {
                id: archivesPageAction
                objectName: "archivesPageAction"

                iconSource: Qt.resolvedUrl("images/select.svg")
                text: i18n.tr("Archive")

                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("ArchivesPage.qml"))
                }
            }
        }

        ToolbarButton {
            action: Action {
                id: categoriesPageAction
                objectName: "categoriesPageAction"

                iconSource: Qt.resolvedUrl("images/edit.svg")
                text: i18n.tr("Categories")

                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("CategoriesPage.qml"))
                }
            }
        }
    }

    NotesListView {
        id: notesView
    }
}
