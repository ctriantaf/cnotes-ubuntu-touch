import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "Storage.js" as Storage

Page {
    id: noteViewPage

    property variant allNotes

    Header {
        id: header
        title: mainView.title
    }

    onVisibleChanged: {
        if (visible == true) {
            noteTagsModel.clear()
            for (var i = 0; i < mainView.tag.split(",").length; i++) {
                noteTagsModel.append({tag: mainView.tag.split(",")[i]})
            }
        }
    }

    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                id: editNoteViewAction
                objectName: "editNoteViewAction"

                iconSource: Qt.resolvedUrl("images/edit.svg")
                text: i18n.tr("Edit")

                onTriggered: {
                    pageStack.push(editNotePage)
                }
            }
        }
    }

    Row {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }
        height: parent.height
        spacing: units.gu(2)

        Column {
            id: bodyColumn
            width: parent.width * 2 / 3
            height: parent.height
            spacing: units.gu(1)

            TextArea {
                id: noteBodyTextArea
                readOnly: true
                activeFocusOnPress: false
                height: parent.height - header.height - noteCategoryLabel.height - units.gu(2)
                width: parent.width
                text: mainView.body

                onFocusChanged: focus = false
            }

            Row {
                spacing: units.gu(1)
                width: parent.width

                ListItem.Standard {
                    id: noteCategoryLabel
                    showDivider: false
                    width: parent.width / 2
                    text: i18n.tr("Category: ") + mainView.category

                    onClicked: {
                        mainView.filter = "Category"
                        showNotesWithFilter(mainView.category)
                    }
                }

                ListItem.Standard {
                    width: parent.width / 2
                    showDivider: false
                    text: {
                        if (mainView.archive == "true") {
                            return i18n.tr("Archive: Yes")
                        }
                            return i18n.tr("Archive: No")
                    }
                }

            }
        }

        ListView {
            id: noteTagView
            width: parent.width / 3
            height: parent.height

            model: noteTagsModel
            delegate: ListItem.Empty {
                Label {
                    text: tag
                }

                onClicked: {
                    mainView.filter = "Tag"
                    showNotesWithFilter (tag)
                }
            }
        }
    }

    function showNotesWithFilter (f) {
        if (mainView.filter == "Tag") {
            noteViewPage.allNotes = Storage.fetchAllNotesWithTag(f)
        }
        else {
            noteViewPage.allNotes = Storage.fetchAllNotesWithCategory(f)
        }

        for (var i = 0; i < noteViewPage.allNotes.length; i++) {
            var noteId = noteViewPage.allNotes[i]
            filterNotesModel.append({id:noteId, title:Storage.getTitle(noteId), body:Storage.getBody(noteId),
                                 category:Storage.getCategory(noteId), tag:Storage.getTags(noteId), archive:Storage.getArchive(noteId),
                                 view:Storage.getView(noteId)})
        }
        pageStack.push(filterNoteView)
    }
}
