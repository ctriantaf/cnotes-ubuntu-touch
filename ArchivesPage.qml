import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "Storage.js" as Storage

Page {
    id: archivePage
    height: parent.height

    property string pos

    Header {
        id: header
        title: i18n.tr("Archives")
    }

    ListView {
        id: archivesView
        height: parent.height - header.height
        width: parent.width
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }

        onCurrentIndexChanged: archivePage.pos = archivesView.currentIndex

        model: archivesModel
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
            _archive: archive

            onPressAndHold: {
                PopupUtils.open(archiveRemoveComponent, null)
            }
        }
    }

    Component {
        id: archiveRemoveComponent

        Popover {
            id: archiveRemovePopover
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
                    Storage.removeNote(archivesModel.get(archivePage.pos).id)
                    archivesModel.remove(archivePage.pos)
                    PopupUtils.close(archiveRemovePopover)
                }
            }
        }
    }
}
