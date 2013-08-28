import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "../Storage.js" as Storage
import "../view"


// TODO when archive action is clicked just replace model, don't switch pages

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

    ArchiveListView {
        id: archiveListView
    }

}
