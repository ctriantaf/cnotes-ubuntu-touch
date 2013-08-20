import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.LocalStorage 2.0
import "Storage.js" as Storage

Page {
    id: editNotePage
    title: i18n.tr("Edit note")

    Column {
        spacing: units.gu(2)
        anchors {
            fill: parent
            verticalCenter: parent.verticalCenter
            margins: units.gu(2)
        }

        TextField {
            id: inputTitleEdit
            width: parent.width
            text: mainView.title
            placeholderText: i18n.tr("Title")
        }

        TextArea {
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

        Button {
            text: i18n.tr("Done")
            width: parent.width
            onClicked: {
                Storage.setNote(mainView.id, inputTitleEdit.text, inputBodyEdit.text, category, tag, 'false', 'main')
                mainView.notes.get(mainView.position).title = inputTitleEdit.text
                mainView.notes.get(mainView.position).body = inputBodyEdit.text
                mainView.notes.get(mainView.position).category = category
                mainView.notes.get(mainView.position).tag = tag

                mainView.tag = tag
                pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
        }
    }
}
