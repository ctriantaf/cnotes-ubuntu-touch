import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.LocalStorage 2.0
import "Storage.js" as Storage

Page {
    id: createNotePage

    Header {
        id: header
        title: i18n.tr("Create note")
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
            id: inputTitle
            width: parent.width
            placeholderText: i18n.tr("Title")
        }

        TextField {
            id: inputBody
            width: parent.width
            placeholderText: i18n.tr("Body")
            height: units.gu(10)
        }

        Button {
            id: tagsButton
            text: i18n.tr("Tags: ") + tag
            width: parent.width

            onClicked: {
                PopupUtils.open(tagsComponent, tagsButton.itemHint)
            }
        }

        Button {
            id: categoryButton
            text: i18n.tr("Category: ") + category
            width: parent.width

            onClicked: PopupUtils.open(categoryComponent, categoryButton.itemHint)
        }

        Row {
            spacing: units.gu(1)
            width: parent.width

            Button {
                text: i18n.tr("Close")
                width: parent.width / 3
                onClicked: PopupUtils.close(dialog)
            }

            ListItem.Empty {
                width: parent.width / 3 - units.gu(2)
                showDivider: false
            }

            Button {
                text: i18n.tr("Create")
                width: parent.width / 3
                onClicked: {
                    if (inputTitle.text == "") {
                        inputTitle.placeholderText = i18n.tr("Give a title")
                        return
                    }

                    Storage.setNote(idCount, inputTitle.text, inputBody.text, category)
                    notes.append({title: inputTitle.text, body: inputBody.text, id: idCount, category: category})
                    idCount++
//                    PopupUtils.close(dialog)
                    pageStack.push(mainPage)
                }
            }
        }
    }
}
