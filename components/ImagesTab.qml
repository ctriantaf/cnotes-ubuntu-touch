import QtQuick 2.0
import QtMultimedia 5.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import DirParser 1.0

Tab {
    title: i18n.tr("Images")
    page: Page {

        Component.onCompleted: {
            imagesView.model.clear()
            var loc = "./pictures/" + mainView.id + '/'
            var imgs = dirParser.fetchAllFiles(loc)
            for (var i = 0; i < imgs.length; i++) {
                console.debug(imgs)
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

                onPressAndHold: PopupUtils.open(imagePopoverComponent)
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

            property string path: './pictures/' + mainView.id + '/'
            property string location

            Camera {
                id: camera
                imageCapture {
                    onImageCaptured: photoPreview.source = preview
                }
            }

            VideoOutput {
                source: camera
                focus: visible
                height: units.gu(20)

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (imageTitle.text.length == 0) {
                            imageTitle.focus = true
                            return
                        }

                        if (!dirParser.dirExists(path)) {
                            dirParser.createDirectory(path)
                        }

                        camera.imageCapture.captureToLocation(path + imageTitle.text)
                        location = '../pictures/' + mainView.id + '/' + imageTitle.text
                    }
                }
            }

            Image {
                id: photoPreview
                height: units.gu(20)
            }

            TextField {
                id: imageTitle
                placeholderText: i18n.tr("Give title")
            }

            Row {
                spacing: units.gu(1)
                Button {
                    text: i18n.tr("Close")
                    width: parent.width / 2
                    color: "#A55263"
                    onClicked: {
                        var loc = imagesView.model.get(imagesView.currentIndex).location
                        dirParser.remove(loc.substring(1))
                        imagesView.model.remove(imagesView.currentIndex)
                        PopupUtils.close(cameraDialog)
                    }
                }

                Button {
                    text: i18n.tr("Add")
                    width: parent.width / 2
                    color: "#A55263"

                    onClicked: {
                        mainView.imagesModel.append({'location': location, 'imgTitle': imageTitle.text})
                        PopupUtils.close(cameraDialog)
                    }
                }
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
                    dirParser.remove(loc.substring(1))
                    imagesView.model.remove(imagesView.currentIndex)
                    PopupUtils.close(imagePopover)
                }
            }
        }
    }
}
