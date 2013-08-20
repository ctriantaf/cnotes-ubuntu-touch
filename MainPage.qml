import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import "Storage.js" as Storage

Page {
    Component.onCompleted: {
//        Storage.deleteDatabase()
        Storage.initialize()
        loadNotes()
        loadArchiveNotes()
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
                    categoriesModel.append({categoryName: "Things to do"})
                    categoriesModel.append({categoryName: "Work"})
                    pageStack.push(Qt.resolveUrl("CategoriesPage.qml"))
                }
            }
        }
    }

//    ListModel {
//        id: notes
//    }

    ListView {
        id: notesView
        anchors {
            fill: parent
            leftMargin: units.gu(2)
            rightMargin: units.gu(2)
        }

        spacing: 2
        model: mainView.notes

        delegate: NoteItem {
            _id: id
            _title: title
            _body: {
                if (body.length > 80)
                    return body.substring(0, 80) + "..."
                return body
            }

            _tag: tag
            _category: category
            _view: view
        }
    }
}
