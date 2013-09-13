import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "../components"

Tabs {
    Tab {
        title: i18n.tr("Details")
        page: Page {
            id: editNotePage
            title: i18n.tr("Edit note")

            tools: ToolbarItems {
                opened: true
                locked: true

                ToolbarButton {
                    action: Action {
                        id: editDoneAction
                        objectName: "editDoneAction"

                        text: i18n.tr("Apply")
                        iconSource: Qt.resolvedUrl("../images/select.svg")

                        onTriggered: {

                            var doc
                            var archive
                            if (mainView.showArchive) {
                                doc = 'archive'
                                archive = 'true'
                            }
                            else {
                                doc = 'notes'
                                archive = 'false'
                            }

                            mainView.backend.replaceNote(mainView.id, doc, inputTitleEdit.text, inputBodyEdit.text,
                                                         categoriesSelectorEdit.values[categoriesSelectorEdit.selectedIndex],
                                                         tag, archive, 'main', mainView.getLinksForStorage())

                            pageStack.push(mainConditionalPage)
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
                            mainView.mode = "view"
                            pageStack.pop()
                        }
                    }
                }
            }

            Flickable {
                id: flickable
                anchors.fill: parent

                Column {
                    spacing: units.gu(2)
                    anchors {
                        fill: parent
                        verticalCenter: parent.verticalCenter
                        margins: units.gu(2)
                    }

                    TextField {
                        id: inputTitleEdit
                        width: parent.width
                        text: title
                        placeholderText: i18n.tr("Title")
                    }

                    TextArea {
                        id: inputBodyEdit
                        text: body
                        height: units.gu(10)
                        width: parent.width
                        placeholderText: i18n.tr("Body")
                    }

                    Button {
                        id: editTagsButton
                        text: i18n.tr("Tags: ") + tag
                        width: parent.width
                        color: "#A55263"

                        onClicked: PopupUtils.open(tagsComponent, editTagsButton.itemHint)
                    }

                    ListItem.ValueSelector {
                        id: categoriesSelectorEdit

                        width: parent.width
                        text: i18n.tr("Category")
                        expanded: false
                        values: mainView.database.getDoc("categories").categories
                        selectedIndex: getCategoryIndex(mainView.category)

                        function getCategoryIndex(name) {
                            for (var i = 0; i < values.length; i++) {
                                if (values[i] === name) {
                                    return i
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ImagesTab {
        id: imagesTabEdit
    }

    LinksTab {
        id: linksTabEdit
    }
}
