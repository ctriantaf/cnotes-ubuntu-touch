import QtQuick 2.0
import QtMultimedia 5.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Tab {
    title: i18n.tr("Images")
    page: Page {

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
                    iconSource: Qt.resolvedUrl("images/camcorder.svg")

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
                Image {
                    source: location
                }

                onClicked: {mainView.imageLocation=location; PopupUtils.open(imageViewerComponent)}
            }
        }
    }

    Component {
        id: cameraComponent

        Dialog {
            id: cameraDialog
            title: i18n.tr("Take a photo")

            property string path: "./pictures/" + mainView.id + "/"
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

                        print(path)
                        camera.imageCapture.captureToLocation(path + imageTitle.text)
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
                    onClicked: PopupUtils.close(cameraDialog)
                }

                Button {
                    text: i18n.tr("Add")
                    width: parent.width / 2
                    color: "#A55263"
//                        onClicked:
                }
            }
        }
    }

    Component {
        id: imageViewerComponent

        Dialog {
            id: imageViewerDialog

            MouseArea {
                anchors.fill: parent

                Image {
                    source: mainView.imageLocation
                    anchors.fill: parent
                }

                onClicked: PopupUtils.close(imageViewerDialog)
            }
        }
    }
}
