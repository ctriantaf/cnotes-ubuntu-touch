import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.LocalStorage 2.0
import "Storage.js" as Storage

Page {
    id: editNotePage

    Header {
        id: header
        title: i18n.tr("Edit note")
    }

    Column {
        height: parent.height - header.height
        width: parent.width
        spacing: units.gu(2)
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: units.gu(2)
        }

        TextField {
            id: inputTitleEdit
            width: parent.width
            text: mainView.title
            placeholderText: i18n.tr("Title")
        }

        TextField {
            id: inputBodyEdit
            text: mainView.body
            height: units.gu(10)
            width: parent.width
            placeholderText: i18n.tr("Body")
        }

        Button {
            id: editTagsButton
            text: i18n.tr("Tags: ") + tag
            width: parent.width

            onClicked: PopupUtils.open(tagsComponent, editTagsButton.itemHint)
        }

        Button {
            id: editCategoryButton
            text: i18n.tr("Category: ") + category
            width: parent.width

            onClicked: PopupUtils.open(categoryComponent, editCategoryButton.itemHint)
        }

        Row {
            spacing: units.gu(1)
            width: parent.width

            Button {
                text: i18n.tr("Done")
                width: parent.width
                onClicked: {
                    Storage.setNote(mainView.id, inputTitleEdit.text, inputBodyEdit.text, category)
                    notes.get(mainView.position).title = inputTitleEdit.text
                    notes.get(mainView.position).body = inputBodyEdit.text
                    notes.get(editNotePage.position).category = category
                    pageStack.push(mainPage)
                }
            }
        }
    }
}
