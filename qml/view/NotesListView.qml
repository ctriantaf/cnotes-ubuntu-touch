import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import DirParser 0.1
import "../Storage.js" as Storage
import "../components"
import "../pages"

ListView {
    id: notesView
    anchors {
        fill: parent
        margins: units.gu(2)
    }

    delegate: NoteItem {
        Component.onCompleted: {console.debug(modelData.title); console.debug("A")}
        _id: id
        _title: title
        _body: {
            if (body.length > 80)
                return body.substring(0, 80) + "..."
            return body
        }

        _tag: tag
        _category: category
        _archive: archive
        _view: view

        onPressAndHold: {
            PopupUtils.open(noteRemoveComponent)
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
                    Storage.removeNote(notesView.model.get(notesView.currentIndex).id)
                    notesView.model.remove(notesView.currentIndex)

                    if (dirParser.dirExists('./pictures/' + mainView.id + '/')) {
                        dirParser.removeDir('./pictures/' + mainView.id + '/')
                    }

                    PopupUtils.close(noteRemovePopover)
                }
            }
        }
    }
}
