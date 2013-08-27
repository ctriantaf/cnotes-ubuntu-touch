import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Tab {
    title: i18n.tr("Links")
    page: Page {
        Component.onCompleted: {
            if (mainView.mode === "edit") {loadLinks()}
        }

        function loadLinks() {
            linksListView.model.clear()
            var links = Storage.getLinks(mainView.id)
            for (var i = 0; i < links.split(",").length; i++) {
                linksListView.model.append({'link': links.split(",")[i]})
            }
        }

        tools: ToolbarItems {
            opened: true
            locked: true

            ToolbarButton {
                visible: {
                    if (mainView.mode !== "view")
                        return true
                    return false
                }

                id: addLinkButton
                objectName: "addLinkbutton"

                text: i18n.tr("Link")
                iconSource: Qt.resolvedUrl("../images/add.svg")

                onTriggered: {mainView.mode = "add"; PopupUtils.open(linkComponent)}
            }
        }

        ListView {
            id: linksListView

            anchors.fill: parent
            anchors.margins: units.gu(2)

            model: mainView.noteLinksModel
            delegate: ListItem.Standard {
                text: link

                //FIXME add url on browser
                onClicked: Qt.openUrlExternally(link)

                onPressAndHold: PopupUtils.open(linkPopoverComponent)
            }
        }
    }

    Component {
        id: linkComponent

        Dialog {
            id: linkDialog
            title: {
                if (mainView.mode === "add") {
                    return i18n.tr("Enter link")
                }
                else {
                    return i18n.tr("Edit link")
                }
            }

            property string mode

            TextField {
                id: linkTextField
                text: {
                    if (mainView.mode === "add") {
                        return ""
                    }
                    else {
                        return mainView.link
                    }
                }

                focus: true
            }

            Button {
                text: i18n.tr("Enter")
                color: "#A55263"

                onClicked:{
                    mainView.noteLinksModel.append({'link': linkTextField.text})
                    PopupUtils.close(linkDialog)
                }
            }
        }
    }

    Component {
        id: linkPopoverComponent

        Popover {
            id: linkPopover
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            ListItem.Standard {
                //FIXME: Hack because of Suru theme!
                Label {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        margins: units.gu(2)
                    }

                    text: i18n.tr("Edit")
                    fontSize: "medium"
                    color: parent.selected ? UbuntuColors.orange : Theme.palette.normal.overlayText
                }

                onClicked: {mainView.mode = "edit"; PopupUtils.open(linkComponent)}
            }

            ListItem.Standard {
                //FIXME: Hack because of Suru theme!
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

                onClicked: {mainView.noteLinksModel.remove(linksListView.currentIndex); PopupUtils.close(linkPopover)}
            }
        }
    }
}
