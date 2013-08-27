import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.LocalStorage 2.0
import "../Storage.js" as Storage
import "../components"

Tabs {
    id: createTabs

    Tab {
        title: i18n.tr("Details")
        page: Page {
            id: createNotePage
            title: i18n.tr("Create note")

            Component.onCompleted: mainView.id=idCount

            tools: ToolbarItems {
                id: createNoteToolbar
                opened: true
                locked: true

                ToolbarButton {
                    action: Action {
                        id: createNoteAction
                        objectName: "createNoteAction"

                        text: i18n.tr("Save")
                        iconSource: Qt.resolvedUrl("../images/add.svg")

                        onTriggered: {
                            if (inputTitle.text == "") {
                                inputTitle.placeholderText = i18n.tr("Give a title")
                                return
                            }

                            Storage.setNote(idCount, inputTitle.text, inputBody.text, categoriesSelector.values[categoriesSelector.selectedIndex],
                                            tag, 'false', 'main', mainView.getLinksForStorage())

                            mainView.notes.append({title: inputTitle.text, body: inputBody.text, id: idCount,
                                             category: categoriesSelector.values[categoriesSelector.selectedIndex], tag:tag, archive: 'false', view:"main"})
                            idCount++

                            inputTitle.text = ""
                            inputBody.text = ""

                            if (mainView.wideAspect) {
                                rootPageStack.push(mainConditionalPage)
                            }
                            else {
                                print("Clear")
                                mainView.title = ""
                                mainView.body = ""
                                mainView.category = i18n.tr("None")
                                mainView.tag = i18n.tr("None")

                                rootPageStack.push(Qt.resolvedUrl("../pages/MainPage.qml"))
                            }
                        }
                    }
                }
            }

            Column {
                spacing: units.gu(2)
                anchors {
                    fill: parent
                    verticalCenter: parent.verticalCenter
                    margins: units.gu(2)
                }

                TextField {
                    id: inputTitle
                    width: parent.width
                    placeholderText: i18n.tr("Title")
                }

                TextArea {
                    id: inputBody
                    width: parent.width
                    placeholderText: i18n.tr("Body")
                    height: units.gu(10)
                }

                Button {
                    id: tagsButton
                    text: i18n.tr("Tags: ") + mainView.tag
                    width: parent.width
                    color: "#A55263"

                    onClicked: {
                        PopupUtils.open(tagsComponent, tagsButton.itemHint)
                    }
                }

                ListItem.ValueSelector {
                    id: categoriesSelector
                    property variant categories: Storage.fetchAllCategories()

                    width: parent.width
                    text: i18n.tr("Category")
                    expanded: false
                    values: categories
                }
            }
        }
    }

    ImagesTab {
        id: imagesTab
    }

    LinksTab {
        id: linksTab
    }
}


