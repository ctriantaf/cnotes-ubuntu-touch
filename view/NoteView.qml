import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Layouts 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../Storage.js" as Storage
import "../components"
import "../view"
import "../pages"

Tabs {
    id: noteViewTabs

    Tab {
        title: i18n.tr("Details")
        page: Page {
            id: noteViewPage
            title: getHtmlText(mainView.title)

//            property variant allNotes

            onVisibleChanged: {
                if (visible == true) {
                    noteTagsModel.clear()
                    for (var i = 0; i < mainView.tag.split(",").length; i++) {
                        noteTagsModel.append({tag: mainView.tag.split(",")[i]})
                    }
                }
            }

            tools: ToolbarItems {
                visible: {
                    if (mainView.wideAspect) {
                        return false
                    }
                    return true
                }

                ToolbarButton {
                    action: Action {
                        id: editNoteViewAction
                        objectName: "editNoteViewAction"

                        iconSource: Qt.resolvedUrl("../images/edit.svg")
                        text: i18n.tr("Edit")

                        onTriggered: {
                            pageStack.push(Qt.resolvedUrl("../pages/EditNotePage.qml"))
                        }
                    }
                }

                back: ToolbarButton {
                    action: Action {
                        id: back
                        objectName: "back"

                        iconSource: Qt.resolvedUrl("../images/back.svg")
                        text: i18n.tr("Back")

                        onTriggered: {
                            mainView.tag = i18n.tr("None")
                            mainView.category = i18n.tr("None")
                            pageStack.pop()
                        }
                    }
                }
            }

            NoteViewRow {
                anchors {
                    fill: parent
                    margins: units.gu(2)
                }
                spacing: units.gu(2)
            }
        }
    }

    ImagesTab {
        id: noteViewImagesTab
    }

    LinksTab {
        id: noteViewLinksTab
    }
}
