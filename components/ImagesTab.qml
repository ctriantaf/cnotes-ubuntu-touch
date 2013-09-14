import QtQuick 2.0
import QtMultimedia 5.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import DirParser 1.0

Tab {
    title: i18n.tr("Images")
    page: Page {
        id: page

        property string location: dirParser.getPicturesFolder() + "/.cnotes/"

        Component.onCompleted: {
            imagesView.model.clear()
            var imgs = dirParser.fetchAllFiles(location + mainView.id)
            for (var i = 0; i < imgs.length; i++) {
                imagesView.model.append({'location': imgs[i]})
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

                action: Action {
                    id: cameraAction
                    objectName: "cameraAction"

                    text: i18n.tr("Camera")
                    iconSource: Qt.resolvedUrl("../images/camcorder.svg")

                    onTriggered: {
                        mainView.id = idCount
                        PopupUtils.open(cameraComponent)
                    }
                }
            }
        }

        GridView {
            id: imagesView
            anchors {
                fill: parent
                margins: units.gu(2)
            }

            model: mainView.imagesModel
            delegate: MouseArea {
                width: units.gu(20)
                height: units.gu(20)

                Image {
                    anchors.fill: parent
                    source: location
                }

                onPressAndHold: {
                    if (mainView.mode !== "view") {
                        PopupUtils.open(imagePopoverComponent)
                    }
                }
            }
        }
    }

    DirParser {
        id: dirParser
    }

    Component {
        id: cameraComponent

        Dialog {
            id: cameraDialog
            title: i18n.tr("Take a photo")

            property string path: page.location + mainView.id + "/"

            Camera {
                id: camera

                imageCapture {
                    onImageCaptured: imagePreview.source = preview
                }
            }

            TextField {
                id: imageTitle
                placeholderText: i18n.tr("Give title")
            }

            VideoOutput {
                source: camera
                focus: visible
                height: units.gu(20)
            }

            Image {
                id: imagePreview
                height: units.gu(20)
            }

            Label {
                id: messageLabel
                visible: false
            }

            Row {
                spacing: units.gu(1)
                Button {
                    text: i18n.tr("Close")
                    width: parent.width / 2
                    color: "#A55263"
                    onClicked: {
                        dirParser.remove(location.substring(1))
                        PopupUtils.close(cameraDialog)
                    }
                }

                Button {
                    text: {
                        if (add) {
                            return i18n.tr("Add")
                        }
                        return i18n.tr("Capture")
                    }

                    width: parent.width / 2
                    color: "#A55263"
                    property bool add : false

                    onClicked: {
                        if (!add) {
                        if (imageTitle.text.length == 0) {
                            imageTitle.focus = true
                            messageLabel.text = i18n.tr("You need to add a title")
                            messageLabel.visible = true
                            return
                        }

                        captureImage()
                        add = true
                        }
                        else {
                            mainView.imagesModel.append({'location': path + imageTitle.text, 'imgTitle': imageTitle.text})
                            PopupUtils.close(cameraDialog)
                        }
                    }
                }
            }

            function captureImage() {
                if (!dirParser.dirExists(path)) {
                    dirParser.createDirectory(path)
                }

                camera.imageCapture.captureToLocation(path + imageTitle.text)
//                location = '../pictures/' + mainView.id + '/' + imageTitle.text
            }
        }
    }

    Component {
        id: imagePopoverComponent
        Popover {
            id: imagePopover
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
                    var loc = imagesView.model.get(imagesView.currentIndex).location
                    dirParser.remove(loc)
                    imagesView.model.remove(imagesView.currentIndex)
                    PopupUtils.close(imagePopover)
                }
            }
        }
    }
}
