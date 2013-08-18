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
    headerColor: "#57365E"
    backgroundColor: "#A55263"
    footerColor: "#D75669"

    property string idCount : "0"
    property string id
    property string title
    property string body
    property string category : "None"
    property string tag : "None"
    property string position
    property string filter

    property variant archivesModel
    property variant filterNotesModel
    property variant archiveNotes
    property variant allNotes

    ListModel {
        id: categoriesModel
    }

    archivesModel: ListModel {

    }

    filterNotesModel: ListModel {

    }

    ListModel {
        id: noteTagsModel
    }

    ListModel {
        // Here are stored all the tags
        id: tags
    }


    ListModel {
        // Here are stored the three last used tags (for the gridView)
        id: tagsModel
    }

    function loadNotes() {
        allNotes = Storage.fetchNotes('false')
        idCount = 0
        for (var i = 0; i < allNotes.length; i++) {
            var noteId = allNotes[i]
            notes.append({id:noteId, title:Storage.getTitle(noteId), body:Storage.getBody(noteId),
                                     category:Storage.getCategory(noteId), tag:Storage.getTags(noteId), archive:'false', view:"main"})

            if (noteId > idCount)
                idCount = noteId
        }

    }

    function loadArchiveNotes() {
        archiveNotes = Storage.fetchNotes('true')
        for (var i = 0; i < archiveNotes.length; i++) {
            var noteId = archiveNotes[i]
            archivesModel.append({id:noteId, title:Storage.getTitle(noteId), body:Storage.getBody(noteId),
                                     category:Storage.getCategory(noteId), tag:Storage.getTags(noteId), archive:'true', view:"archive"})
        }
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
                Storage.deleteDatabase()
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

                        onTriggered: pageStack.push(createNotePage)
                    }
                }

                ToolbarButton {
                    action: Action {
                        id: archivesPageAction
                        objectName: "archivesPageAction"

                        iconSource: Qt.resolvedUrl("images/select.svg")
                        text: i18n.tr("Archive")

                        onTriggered: {
//                            loadArchiveNotes();
                            pageStack.push(archivesPage)
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

        ArchivesPage {
            id: archivesPage
            height: parent.height
            visible: false
        }

        NoteView {
            id: noteViewPage
            height: parent.height
            visible: false
        }

        FilterNoteView {
            id: filterNoteView
            height: parent.height
            visible: false
        }

        Component {
            id: tagsComponent

            Popover {
                id: tagsPopover

                Column {
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }

                    ListItem.Empty {
                        id: tagListItem
                        visible: {
                            print (tagsModel.count)
                            if (tagsModel.count == 0) {
                                return false
                            }
                            return true
                        }

                        GridView {
                            id: grid
                            width: parent.width
                            height: parent.height

                            model: tagsModel
                            delegate: Button {
                                id: tagButton
                                text: tag
                                onClicked: {
                                    if (tagTextField.text.length != 0) {
                                        tagTextField.text = tagTextField.text.toString() + "," + tag
                                    }
                                    else {
                                        tagTextField.text = tag
                                    }

                                    tagListItem.visible = true
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

                                    mainView.tag = tagTextField.text
                                    for (var i = 0; i < tagTextField.text.split(",").length; i++) {
                                        // Check if tag already exists!
                                        if (!containTag(tagTextField.text.split(",")[i])) {
                                            if (tagsModel.count == 3) {
                                                tagsModel.remove(0)
                                                print ("removed")
                                            }
                                            tagsModel.append({tag: tagTextField.text.split(",")[i]})
                                            tags.append({tag: tagTextField.text.split(",")[i]})
                                        }
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
            // FIXME make popover filled with a ListModel categories

            Popover {
                id: categoryPopover

                Column {

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }

                    ListItem.Empty {
                        Label {
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                margins: units.gu(2)
                            }

                            text: i18n.tr("None")
                            fontSize: "medium"
                            color: parent.selected ? UbuntuColors.orange : Theme.palette.normal.overlayText
                        }

                        onClicked: {
                            category = "None"
                            PopupUtils.close(categoryPopover)
                        }
                    }

                    ListItem.Empty {
                        Label {
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                margins: units.gu(2)
                            }

                            text: i18n.tr("Thing to do")
                            fontSize: "medium"
                            color: parent.selected ? UbuntuColors.orange : Theme.palette.normal.overlayText
                        }

                        onClicked: {
                            category = "Things to do"
                            PopupUtils.close(categoryPopover)
                        }
                    }

                    ListItem.Empty {
                        Label {
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                margins: units.gu(2)
                            }

                            text: i18n.tr("Work")
                            fontSize: "medium"
                            color: parent.selected ? UbuntuColors.orange : Theme.palette.normal.overlayText
                        }

                        onClicked: {
                            category = "Work"
                            PopupUtils.close(categoryPopover)
                        }
                    }

//                    ListItem.Empty {
//                        ListView {
//                            width: parent.width
//                            model: categoriesModel
//                            delegate: Label {
//                                anchors {
//                                    verticalCenter: parent.verticalCenter
//                                    left: parent.left
//                                    margins: units.gu(2)
//                                }

//                                text: i18n.tr(categoryName)
//                                fontSize: "medium"
//                                color: parent.selected ? UbuntuColors.orange : Theme.palette.normal.overlayText
//                            }
//                        }
//                    }

                    ListItem.Empty {
                        id: newCategoryLabel
                        Label {
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                margins: units.gu(2)
                            }

                            text: i18n.tr("Create category")
                            fontSize: "medium"
                            color: parent.selected ? UbuntuColors.orange : Theme.palette.normal.overlayText
                        }

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
                                }
                                height: newCategoryField.height
                                text: i18n.tr("Create")
                                onClicked: {
                                    categoriesModel.append({categoryName: newCategoryField.text})
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
