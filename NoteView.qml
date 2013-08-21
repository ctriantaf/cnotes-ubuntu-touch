import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "Storage.js" as Storage

Page {
    id: noteViewPage
    title: getHtmlText(mainView.title)

    property variant allNotes

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
                    pageStack.push(Qt.resolvedUrl("EditNotePage.qml"))
                }
            }
        }

        back: ToolbarButton {
            action: Action {
                id: back
                objectName: "back"

                iconSource: Qt.resolvedUrl("images/back.svg")
                text: i18n.tr("Back")

                onTriggered: {
                    mainView.tag = i18n.tr("None")
                    mainView.category = i18n.tr("None")
                    pageStack.pop()
                }
            }
        }
    }

    Row {
        anchors {
            fill: parent
            margins: units.gu(2)
        }
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
                text: getHtmlText(mainView.body)
                textFormat: TextEdit.RichText
                color: "#A55263"

                onFocusChanged: focus = false
            }

            ListItem.Standard {
                id: noteCategoryLabel
                showDivider: false
                text: i18n.tr("Category: ") + mainView.category

                onClicked: {
                    mainView.filter = "Category"
                    showNotesWithFilter(mainView.category)
                }
            }

            ListItem.Standard {
                showDivider: false
                text: {
                    if (mainView.archive == "true") {
                        return i18n.tr("Archive: Yes")
                    }
                        return i18n.tr("Archive: No")
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
        pageStack.push(Qt.resolvedUrl("FilterNoteView.qml"))
    }
}
