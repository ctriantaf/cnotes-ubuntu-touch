import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import QtMultimedia 5.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Layouts 0.1
import U1db 1.0 as U1db
import DirParser 0.1
import "Storage.js" as Storage
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

    property string idCount : "0"
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
    property string imageLocation
    property string showArchive: 'false'

    property variant notes
    property variant categoriesModel
    property variant archivesModel
    property variant filterNotesModel
    property variant archiveNotes
    property variant allNotes
    property variant noteLinksModel
    property variant imagesModel

    property variant backend
    property variant notesDatabase

    property string focusedEntry: ""

    notesDatabase: U1db.Database {
        id: notesDatabase
        path: "notesU1db"
    }

    U1db.Document {
        id: notesDocument
        database: notesDatabase
        docId: "notes"
        create: true
        defaults: {'notes': [{}] }
    }

    U1db.Document {
        id: archiveDocument
        database: notesDatabase
        docId: "archive"
        create: true
        defaults: {'archive': [{}] }
    }

    U1db.Document {
        id: categoriesDocument
        database: notesDatabase
        docId: "categories"
        create: true
        defaults: {"categories": [{}] }
    }

    U1db.Index {
        database: notesDatabase
        id: allNotesIndex
        expression: ["notes"]
    }

    U1db.Query {
        id: allNotesQuery
        index: allNotesIndex
        query: []
    }

    backend: U1Backend {
        id: backend
        db: notesDatabase
    }

    notes: ListModel {
        onCountChanged: {
            if (count > 0) {
                notesListView.currentIndex = count - 1
            }
        }
    }

    categoriesModel: ListModel {}

    archivesModel: ListModel {
        onCountChanged: {
            if (count > 0) {
                notesListView.currentIndex = count - 1
            }
        }
    }

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

//    function loadNotesU1db() {

//    }

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

    PageStack {
        id: rootPageStack

        Component.onCompleted: {

//            var id = "0"
//            console.debug(backend.getTitle(id))
//            console.debug(notesDatabase.getDoc("notes")[0].title)

//            console.debug(notesDocument.contents.notes.length)
//            console.debug(notesDatabase.getDoc("notes").notes.length)

            Storage.deleteDatabase()
            dirParser.removeDir('./categories')
            Storage.initialize()
//            loadNotesU1db()
//            loadNotes()
//            loadArchiveNotes()

            if (dirParser.dirExists('./categories')) {
                loadCategories()
            }
            else {
                Storage.addCategory("None")
                Storage.addCategory("Things to do")
                Storage.addCategory("Work")
                categoriesModel.append({categoryName: "None"})
                categoriesModel.append({categoryName: "Things to do"})
                categoriesModel.append({categoryName: "Work"})
                dirParser.createDirectory('./categories')
            }

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

//                        console.debug(notesDatabase.getDoc("notes").notes.length)
//                        console.debug("Length: " + notesListView.model.length)
//                        if (notesListView.model.length === 0 && wideAspect) {
//                            noteViewRow.visible = false
//                            return
//                        }

                        console.debug(notesListView.model.length)

                        mainView.title = model.get(currentIndex).title
                        mainView.body = model.get(currentIndex).body
                        mainView.category = model.get(currentIndex).category
                        mainView.tag = model.get(currentIndex).tag
                        mainView.archive = model.get(currentIndex).archive

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

                property variant usedTags: Storage.getUsedTags()

                Component.onCompleted: {
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
                                                Storage.addTag(tagsModel.get(0), tagTextField.text.split(",")[i])
                                                tagsModel.remove(0)
                                            }
                                            else {
                                                Storage.addTag("", tagTextField.text.split(",")[i])
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
