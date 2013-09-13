import QtQuick 2.0
import QtMultimedia 5.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Layouts 0.1
import U1db 1.0 as U1db
import DirParser 1.0
import "showdown.js" as Showdown
import "components"
import "view"
import "pages"


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

    property bool wideAspect: width > units.gu(80)

    property string idCount
    property string id
    property string title
    property string body
    property string category : "None"
    property string tag : "None"
    property string position
    property string archivePos
    property string filter
    property string archive
    property string mode
    property string link
    property string links
    property string imageLocation
    property bool showArchive: false
    property bool createNote: false
    property string specificTag

//    property variant notes
//    property variant categoriesModel
//    property variant archivesModel
    property variant filterNotesModel
//    property variant archiveNotes
//    property variant allNotes
    property variant noteLinksModel
    property variant imagesModel

    property variant backend
    property variant notesDatabase

    property string focusedEntry: ""

    property variant database
    property variant backend

    filterNotesModel: ListModel {}

    noteLinksModel: ListModel {}

    imagesModel: ListModel {}

    ListModel { id: noteTagsModel }

    ListModel {
        // Here are stored the three last used tags (for the gridView)
        id: tagsModel
    }

    DirParser {id: dirParser}

    onTagChanged: {
        if (wideAspect) {
            noteTagsModel.clear()
            for (var i = 0; i < mainView.tag.split(",").length; i++) {
                noteTagsModel.append({tag: mainView.tag.split(",")[i]})
            }
        }
    }

    function setIdCount() {
        idCount = 0

        var archive = database.getDoc("archive")

        var all = database.getDoc("notes")
        for (var i = 0; i < archive["notes"].length; i++) {
            all["notes"][all["notes"].length] = archive["notes"][i]
        }

        for (var i = 0; i < all["notes"].length; i++) {
            if (all["notes"][i].id > idCount) {
                idCount = all["notes"][i].id
            }
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

    function tagIsUsed(t, tags) {
        for (var i = 0; i < tags.length; i++) {
            if (t === tags[i]) {
                return true
            }
        }
        return false
    }

    function getHtmlText(text) {
        var converter = new Showdown.Showdown.converter();
        return converter.makeHtml(text)
    }

    function getLinksForStorage() {
        var res = "undefined"
        if (noteLinksModel.count  > 0) {
            res = noteLinksModel.get(0).link
            for (var i = 1; i < noteLinksModel.count; i++) {
                res = res + "," + noteLinksModel.get(i).link
            }
        }

        return res
    }

    function deleteArchive() {
        for (var i = 0; i < archivesModel.count; i++) {
            Storage.removeNote(archivesModel.get(i).id)
        }
        archivesModel.clear()
    }

    database: U1db.Database {
        id: database
        path: "U1Database"
    }

    U1db.Document {
        id: notesDocument
        database: database
        docId: "notes"
        create: true
        defaults: {"notes": []}
    }

    U1db.Document {
        id: archiveDocument
        database: database
        docId: "archive"
        create: true
        defaults: {"notes": []}
    }

    U1db.Document {
        id: categoriesDocument
        database: database
        docId: "categories"
        create: true
        defaults: {"categories": ["None", "Work", "Things to do"] }
    }

    U1db.Document {
        id: tagsDocument
        database: database
        docId: "tags"
        create: true
        defaults: {"tags": []}
    }

    backend: U1Backend {
        id: backend
    }

    PageStack {
        id: rootPageStack

        Component.onCompleted: {
            setIdCount()

            rootPageStack.push(mainConditionalPage)
        }

        Page {
            id: mainConditionalPage
            visible: false
            title: "CNotes"

            tools: MainToolbar {}

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
                                id: itemL
                                item: "notesSidebar"
                                width: parent.width / 3 - units.gu(1)
                                height: parent.height
                            }

                            ItemLayout {
                                id: item
                                item: "noteView"
                                width: parent.width * 2 / 3 - units.gu(1)
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

                NotesListView {
                    id: notesListView
                    Layouts.item: "notesSidebar"
                    model: notesDocument.contents.notes

                    onCurrentIndexChanged: {
                        if (notesDocument.contents.notes.length === 0 && wideAspect) {
                            noteViewRow.visible = false
                            return
                        }

                        if (wideAspect) {
                            noteViewRow.visible = true
                        }
                    }
                }

                NoteViewRow {
                    id: noteViewRow
                    Layouts.item: "noteView"
                    visible: false
                }
            }
        }

        Component {
            id: tagsComponent

            Popover {
                id: tagsPopover


                Component.onCompleted: {
                    var usedTags= database.getDoc("tags").tags
                    var end = usedTags.length - 4
                    if (usedTags.length < 4) {
                        end = 0
                    }

                    for (var i = usedTags.length - 1; i > end; i--) {
                        tagsModel.append({tag: usedTags[i]})
                    }
                }

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
                                        if (!tagIsUsed(tag, tagTextField.text.split(','))) {
                                            tagTextField.text = tagTextField.text.toString() + "," + tag
                                        }
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
                                                mainView.backend.addTag(tagsModel.get(0), tagTextField.text.split(",")[i])
                                            }
                                            else {
                                                mainView.backend.addTag("", tagTextField.text.split(",")[i])
                                            }

                                            tagsModel.append({tag: tagTextField.text.split(",")[i]})
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
    }
}
