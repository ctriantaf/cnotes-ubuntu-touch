import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../pages"
import "../view"

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
                mainView.specificTag = tag
                showNotesWithFilter (tag)
            }
        }
    }

    function showNotesWithFilter (f) {
        filterNotesModel.clear()

        var allNotes
        if (mainView.filter == "Tag") {
            allNotes = mainView.backend.fecthAllNotesWithTag(f)
        }
        else {
            allNotes = mainView.backend.fetchAllNotesWithCategory(f)
        }

        for (var i = 0; i < allNotes["notes"].length; i++) {
            var values = allNotes.notes[i]
            filterNotesModel.append({title:values.title, body:values.body, tag:values.tag, category:values.category,
                                        archive:values.archive, view:values.view, links:values.links})
        }

        rootPageStack.push(Qt.resolvedUrl("../view/FilterNoteView.qml"))
    }
}
