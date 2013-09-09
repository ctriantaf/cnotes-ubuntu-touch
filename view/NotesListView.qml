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

    property int pos

    delegate: NoteItem {

        _id: {
            return index
        }

        _title: getCorrectDoc().notes[index].title

        _body: {
            var body = getCorrectDoc().notes[_id].body
            if (body.length > 80)
                return body.substring(0, 80) + "..."
            return body
        }

        _tag: getCorrectDoc().notes[_id].tag
        _category: getCorrectDoc().notes[_id].category
        _archive: getCorrectDoc().notes[_id].archive
        _view: getCorrectDoc().notes[_id].view

        onPressAndHold: {
            pos = _id
            PopupUtils.open(noteRemoveComponent)
        }

        function getCorrectDoc() {
            if (mainView.showArchive) {
                return mainView.database.getDoc("archive")
            }
            else {
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
//                    notesView.model[notesView.currentIndex]
                    if (mainView.showArchive) {
                        console.debug(pos)
                        mainView.backend.removeNote(pos, "archive")
                        notesView.model = mainView.database.getDoc("archive").notes
                    }
                    else {
                        console.debug(pos)
                        mainView.backend.removeNote(pos, "notes")
                        notesView.model = mainView.database.getDoc("notes").notes
                    }

                    if (dirParser.dirExists('./pictures/' + pos + '/')) {
                        dirParser.removeDir('./pictures/' + pos + '/')
                    }

                    PopupUtils.close(noteRemovePopover)
                }
            }
        }
    }
}
