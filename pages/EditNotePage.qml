import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.LocalStorage 2.0
import "../Storage.js" as Storage
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
                            // TODO fix it!
//                            Storage.setNote(inputTitleEdit.text, inputBodyEdit.text, categoriesSelectorEdit.values[categoriesSelectorEdit.selectedIndex], tag, 'false', 'main')
//                            mainView.notes.get(mainView.position).title = inputTitleEdit.text
//                            mainView.notes.get(mainView.position).body = inputBodyEdit.text
//                            mainView.notes.get(mainView.position).category = categoriesSelectorEdit.values[categoriesSelectorEdit.selectedIndex]
//                            mainView.notes.get(mainView.position).tag = tag

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
                                                         tag, archive, 'main')

//                            mainView.tag = tag
//                            if (mainView.showArchive) {
//                                mainView.notesListView.model = mainView.database.getDoc("archive").notes
//                            }
//                            else {
//                                mainView.notesListView.model = mainView.database.getDoc("notes").notes
//                            }

                            pageStack.push(mainConditionalPage)
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
                        property variant categories: Storage.fetchAllCategories()

                        width: parent.width
                        text: i18n.tr("Category")
                        expanded: false
//                        values: categories
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
