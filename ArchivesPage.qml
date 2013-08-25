import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "Storage.js" as Storage

Page {
    id: archivePage
    title: i18n.tr("Archives")

    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                id: deleteArchiveAction
                objectName: "deleteArchiveAction"

                text: i18n.tr("Remove all")
                iconSource: Qt.resolvedUrl("images/close.svg")

                onTriggered: deleteArchive()
            }
        }
    }

    property string pos

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

    function deleteArchive() {
        for (var i = 0; i < archivesModel.count; i++) {
            Storage.removeNote(archivesModel.get(i).id)
        }
        archivesModel.clear()
    }
}
