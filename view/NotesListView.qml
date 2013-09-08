import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import DirParser 1.0
import "../Storage.js" as Storage
import "../components"
import "../pages"

ListView {
    id: notesView
    anchors {
        fill: parent
        margins: units.gu(2)
    }

//    model: mainView.notes
    delegate: NoteItem {

        Component.onCompleted: {
            console.debug("======================== \n")
//            console.debug(console.debug(mainView.database.getDoc("archive").notes[index].title) + "\n")
            console.debug("Notes length: " + mainView.database.getDoc("notes").notes.length + "\n")
            console.debug("Archive length: " + mainView.database.getDoc("archive").notes.length + "\n")
            console.debug("========================")
        }

//        _id: /*mainView.database.getDoc(doc)*/doc.notes.length
        _id: {
//            if (doc.notes.length > 0) {
//                return doc.notes.length - 1
//            }
//            return 0
//            return doc.notes.length
//            console.debug(mainView.database.getDoc("archive").notes[index].title)
            return index
        }

//        _id: {
//            if (showArchive) {
//                return mainView.database.getDoc("archive").notes.length
//            }
//            return mainView.database.getDoc("notes").notes.length
//        }

        _title: /*mainView.backend.getTitle(_id, doc)*/getCorrectDoc().notes[index].title
//        _title: {
//            if (showArchive) {
//                return mainView.database.getDoc("archive").notes[_id].
//            }
//            return mainView.database.getDoc("notes").notes.length
//        }

        _body: {
            var body = /*mainView.backend.getBody(_id, doc)*/getCorrectDoc().notes[_id].body
            if (body.length > 80)
                return body.substring(0, 80) + "..."
            return body
        }

        _tag: /*mainView.backend.getTag(_id, doc)*/getCorrectDoc().notes[_id].tag
        _category: /*mainView.backend.getCategory(_id, doc)*/getCorrectDoc().notes[_id].category
        _archive: /*mainView.backend.getArchive(_id, doc)*/getCorrectDoc().notes[_id].archive
        _view: /*mainView.backend.getView(_id, doc)*/getCorrectDoc().notes[_id].view

        onPressAndHold: {
            PopupUtils.open(noteRemoveComponent)
        }

        function getCorrectDoc() {
            if (mainView.showArchive) {
                console.debug("Archive docs, " + mainView.showArchive)
                return mainView.database.getDoc("archive")
            }
            else {
                console.debug("Notes docs, " + mainView.showArchive)
                return mainView.database.getDoc("notes")
            }
        }
    }

    DirParser {id: dirParser}

    Component {
        id: noteRemoveComponent

        Popover {
            id: noteRemovePopover
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

                    text: i18n.tr("Remove")
                    fontSize: "medium"
                    color: parent.selected ? UbuntuColors.orange : Theme.palette.normal.overlayText
                }

                onClicked: {
//                    Storage.removeNote(notesView.model.get(notesView.currentIndex).id)
//                    notesView.model.remove(notesView.currentIndex)
                    notesView.model[notesView.currentIndex]

                    if (dirParser.dirExists('./pictures/' + mainView.id + '/')) {
                        dirParser.removeDir('./pictures/' + mainView.id + '/')
                    }

                    PopupUtils.close(noteRemovePopover)
                }
            }
        }
    }
}
