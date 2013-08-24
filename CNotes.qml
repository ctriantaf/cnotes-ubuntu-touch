import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import QtMultimedia 5.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Layouts 0.1
import U1db 1.0 as U1db
import "Storage.js" as Storage
import "showdown.js" as Showdown

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
    property string archive

    property variant notes
    property variant categoriesModel
    property variant archivesModel
    property variant filterNotesModel
    property variant archiveNotes
    property variant allNotes
    property variant noteLinksModel

    property string focusedEntry: ""

//    U1Backend {
//        id: u1Backend
//    }

    notes: ListModel {}

    categoriesModel: ListModel {}

    archivesModel: ListModel {}

    filterNotesModel: ListModel {}

    noteLinksModel: ListModel {}

    ListModel { id: noteTagsModel }

    ListModel {
        // Here are stored the three last used tags (for the gridView)
        id: tagsModel
    }

    function loadNotes() {
        allNotes = Storage.fetchNotes('false')
        idCount = 0
        for (var i = 0; i < allNotes.length; i++) {
            var noteId = allNotes[i]
            mainView.notes.append({id:noteId, title:Storage.getTitle(noteId), body:Storage.getBody(noteId),
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

    function loadCategories() {
        var cat = Storage.fetchAllCategories()
        for (var i = 0; i < cat.length; i++) {
//            print(cat[i])
            categoriesModel.append({categoryName: cat[i]})
        }
    }

    function containTag(t) {
        for (var i = 0; i < tagsModel.count; i++) {
            if (t === tagsModel.get(i).tag) {
                return true
            }
        }
        return false
    }

    function getHtmlText(text) {
        var converter = new Showdown.Showdown.converter();
        return converter.makeHtml(text)
    }

    function getLinksArray() {
        if (noteLinksModel.length === 0) {
            return []
        }

        var res = new Array()
        for (var i = 0; i < noteLinksModel.length; i++) {
            print (noteLinksModel[i])
            res[i] = noteLinksModel[i]
        }
        return res
    }

    PageStack {
        id: pageStack
        Component.onCompleted: {
//            Storage.deleteDatabase()
            Storage.initialize()
            loadNotes()
            loadArchiveNotes()
            loadCategories()

//            categoriesModel.append({categoryName: "None"})
//            categoriesModel.append({categoryName: "Things to do"})
//            categoriesModel.append({categoryName: "Work"})
//            Storage.addCategory("None")
//            Storage.addCategory("Things to do")
//            Storage.addCategory("Work")

//            pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            pageStack.push(mainConditionalPage)

//            u1Backend.setNote("a", "hello", "world", "a", "work", "false", "main")
        }

        Page {
            id: mainConditionalPage

            Layouts {
                anchors.fill: parent
                layouts: [
                    ConditionalLayout {
                        name:  "tabletMainView"
                        when: mainView.width >= units.gu(80)

                        Row {
                            anchors.fill: parent
                            spacing: units.gu(2)

                            ItemLayout {
                                item: "notesSidebar"
                                width: parent.width / 3
                                height: parent.height
                            }

                            ItemLayout {
                                item: "noteView"
                                width: parent.width * 2 / 3
                                height: parent.height
                            }
                        }
                    },

                    ConditionalLayout {
                        name: "phoneMainView"
                        when: mainView.width < units.gu(80)

                        ItemLayout {
                            item: "notesSidebar"
                            anchors.fill: parent
                        }
                    }

                ]

                MainPage {
                    Layouts.item: "notesSidebar"
                }

                NoteView {
                    Layouts.item: "noteView"
                }
            }
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
                            if (tagsModel.count == 0) {
                                return false
                            }
                            return true
                        }

                        GridView {
                            id: grid

                            anchors {
                                fill: parent
                                margins: units.gu(1)
                            }

                            model: tagsModel
                            delegate: Button {
                                id: tagButton
                                text: tag
                                color: "#A55263"
                                anchors.bottomMargin: units.gu(1)
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
                                color: "#A55263"

                                onClicked: {
                                    if (tagTextField.text == "")
                                        tagTextField.text = i18n.tr("None")

                                    mainView.tag = tagTextField.text
                                    for (var i = 0; i < tagTextField.text.split(",").length; i++) {
                                        // Check if tag already exists!
                                        if (!containTag(tagTextField.text.split(",")[i])) {
                                            if (tagsModel.count == 3) {
                                                tagsModel.remove(0)
                                            }
                                            tagsModel.append({tag: tagTextField.text.split(",")[i]})
//                                            tags.append({tag: tagTextField.text.split(",")[i]})
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

                    ListView {
                        id: categoriesPopoverView
                        model: categoriesModel
                        delegate: ListItem.Empty {
                            Label {
                                id: categoryLabel
                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    margins: units.gu(2)
                                }

                                text: categoryName
                                fontSize: "medium"
                                color: parent.selected ? UbuntuColors.orange : Theme.palette.normal.overlayText
                            }

                            onClicked: {
                                categoryName = categoryLabel.text
                            }
                        }
                    }

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

        Component {
            id: cameraComponent

            Dialog {
                id: cameraDialog
                title: i18n.tr("Take a photo")

                property string path: "./pictures/" + mainView.id + "/"
                property string location

                Camera {
                    id: camera
                    imageCapture {
                        onImageCaptured: photoPreview.source = preview
                    }
                }

                VideoOutput {
                    source: camera
                    focus: visible
                    height: units.gu(20)

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (imageTitle.text.length == 0) {
                                imageTitle.focus = true
                                return
                            }

                            print(path)
                            camera.imageCapture.captureToLocation(path + imageTitle.text)
                        }
                    }
                }

                Image {
                    id: photoPreview
                    height: units.gu(20)
                }

                TextField {
                    id: imageTitle
                    placeholderText: i18n.tr("Give title")
                }

                Row {
                    spacing: units.gu(1)
                    Button {
                        text: i18n.tr("Close")
                        width: parent.width / 2
                        color: "#A55263"
                        onClicked: PopupUtils.close(cameraDialog)
                    }

                    Button {
                        text: i18n.tr("Add")
                        width: parent.width / 2
                        color: "#A55263"
//                        onClicked:
                    }
                }
            }
        }

        Component {
            id: linkComponent

            Dialog {
                id: linkDialog
                title: i18n.tr("Enter link")

                property string mode

                TextField {
                    id: linkTextField
                }

                Button {
                    text: i18n.tr("Enter")
                    color: "#A55263"

                    onClicked: {
                        var link = "<link href='" + linkTextField.text + "'>"
                        print (link)
                        noteLinksModel.append({'link': link})
//                        linksSelector.visible = true
                        CreateNotePage.refreshLinksInCreate()
                        PopupUtils.close(linkDialog)
                    }
                }
            }
        }
    }
}
