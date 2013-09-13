import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../pages"
import "../view"
import "../Storage.js" as Storage

Row {
    id: notesViewRow
    spacing: units.gu(1)

    property variant allNotes

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

    function showNotesWithFilter (f) {
        filterNotesModel.clear()
        if (mainView.filter == "Tag") {
            allNotes = Storage.fetchAllNotesWithTag(f)
        }
        else {
            allNotes = Storage.fetchAllNotesWithCategory(f)
        }

        for (var i = 0; i < allNotes.length; i++) {
            var noteId = allNotes[i]
            filterNotesModel.append({id:noteId, title:Storage.getTitle(noteId), body:Storage.getBody(noteId),
                                 category:Storage.getCategory(noteId), tag:Storage.getTags(noteId), archive:Storage.getArchive(noteId),
                                 view:Storage.getView(noteId)})
        }
        rootPageStack.push(Qt.resolvedUrl("../view/FilterNoteView.qml"))
    }
}
