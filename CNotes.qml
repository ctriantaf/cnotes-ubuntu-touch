import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "Storage.js" as Storage
import "components"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    
    // Note! applicationName needs to match the .desktop filename
    applicationName: "CNotes"
    
    /* 
     This property enables the application to change orientation 
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true
    
    width: units.gu(50)
    height: units.gu(75)

    property string idCount : "0"
    property string id
    property string title
    property string body
    property string category : "None"
    property string tag : "None"
    property string position

    ListModel {
        id: categoriesModel
    }

    ListModel {
        id: tags
    }

    function containTag(t) {
        for (var i = 0; i < tags.count; i++) {
            if (t === tags.get(i).tag) {
                return true
            }
        }
        return false
    }

    PageStack {
        id: pageStack
        Component.onCompleted: pageStack.push(mainPage)

        Page {
            Component.onCompleted: {
                Storage.initialize()
                loadNotes()
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

//                        onTriggered: PopupUtils.open(newNoteDialogComponent)
                        onTriggered: pageStack.push(createNotePage)
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
                            pageStack.push(categoriesPage)
                        }
                    }
                }
            }

            ListModel {
                id: notes
            }

            ListView {
                id: notesView
                width: parent.width
                height: parent.height
                leftMargin: 5
                rightMargin: 5
                spacing: 2
                model: notes

                delegate: NoteItem {
                    _id: id
                    _title: title
                    _body: body
                    _category: category
                }

            }


            Component {
                id: notePopoverComponent

                Popover {
                    id: notePopover

                    Column {
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }

                        ListItem.Standard {
                            text: i18n.tr("Edit")

                            onClicked:  {
                                PopupUtils.close(notePopover)
                                pageStack.push(editNotePage)
                            }
                        }

                        ListItem.Standard {
                            text: i18n.tr("Remove")

                            onClicked: {
                                notes.remove(notesView.position)
                                Storage.removeNote(mainView.id);
                                PopupUtils.close(notePopover)
                            }
                        }
                    }
                }
            }

            function loadNotes() {
                for (var i; i < parseInt(idCount); i++) {
                    notes.append({title:Storage.getTitle(i), body:Storage.getBody(i), id:i, category:Storage.getCategory(i)})
                }
            }
        }

        CreateNotePage {
            id: createNotePage
            height: parent.height
            visible: false
        }

        EditNotePage {
            id: editNotePage
            height: parent.height
            visible: false
        }

        CategoriesPage {
            id: categoriesPage
            height: parent.height
            visible: false
        }

        Component {
            id: tagsComponent

            Popover {
                id: tagsPopover

                ListModel {
                    id: tagsModel
                }

                Column {
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }

                    ListItem.Empty {

                        GridView {
                            id: grid
                            width: parent.width
                            height: parent.height

                            model: tags
                            delegate: Button {
                                text: tag
                                onClicked: {
                                    mainView.tag = mainView.tag + "," + text
                                }
                            }
                        }
                    }

                    ListItem.Empty {
                        Row {
                            spacing: units.gu(1)
                            anchors {
                                verticalCenter: parent.verticalCenter
                                horizontalCenter: parent.horizontalCenter
                            }

                            TextField {
                                id: tagTextField
                                placeholderText: i18n.tr("Seperate tags with comma")
                                text: {
                                    if (mainView.tag != "None") {
                                        return mainView.tag
                                    }
                                    else {
                                        return ""
                                    }
                                }

                                anchors.leftMargin: units.gu(1)
                            }

                            Button {
                                id: addTagsButton
                                height: tagTextField.height
                                text: i18n.tr("Add tags")

                                onClicked: {
                                    if (tagTextField.text == "")
                                        tagTextField.text = i18n.tr("None")

                                    tag = tagTextField.text
                                    for (var i = 0; i < tagTextField.text.split(",").length; i++) {
                                        // Check if tag already exists!
                                        if (!containTag(tagTextField.text.split(",")[i]))
                                            if (tags.count == 6)
                                                tags.remove(0)
                                            tags.append({tag: tagTextField.text.split(",")[i]})
                                    }

                                    PopupUtils.close(tagsPopover)
                                }
                            }
                        }
                    }
                }
            }
        }

        Component {
            id: categoryComponent

            Popover {
                id: categoryPopover

                Column {

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }

                    ListItem.Standard {
                        text: i18n.tr("None")
                        onClicked: {
                            category = "None"
                            PopupUtils.close(categoryPopover)
                        }
                    }

                    ListItem.Standard {
                        text: i18n.tr("Things to do")
                        onClicked: {
                            category = "Things to do"
                            PopupUtils.close(categoryPopover)
                        }
                    }

                    ListItem.Standard {
                        text: i18n.tr("Work")
                        onClicked: {
                            category = "Work"
                            PopupUtils.close(categoryPopover)
                        }
                    }

                    ListItem.Standard {
                        id: newCategoryLabel
                        text: i18n.tr("New category")
                        onClicked: {
                            newCategoryItem.visible = true
                            newCategoryLabel.visible = false
                        }
                    }

                    ListItem.Empty {
                        id: newCategoryItem
                        visible: false
                        width: parent.width

                        Row {
                            spacing: units.gu(1)
                            anchors {
                                verticalCenter: parent.verticalCenter
                                horizontalCenter: parent.horizontalCenter
                            }

                            TextField {
                                id: newCategoryField
                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    topMargin: units.gu(1)
                                }
                                width: parent.width * 2 / 3
                                placeholderText: i18n.tr("Category name")
                            }

                            Button {
                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    topMargin: units.gu(1)
                                }
                                height: newCategoryField.height
                                text: i18n.tr("Create")
                            }
                        }
                    }
                }
            }
        }
    }
}
