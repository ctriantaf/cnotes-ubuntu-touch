import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Layouts 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "Storage.js" as Storage

Tabs {
    id: noteViewTabs

    Tab {
        title: i18n.tr("Details")
        page: Page {
            id: noteViewPage
            title: getHtmlText(mainView.title)
        //    Layouts.item: "noteView"

            property variant allNotes

            onVisibleChanged: {
                if (visible == true) {
                    noteTagsModel.clear()
                    for (var i = 0; i < mainView.tag.split(",").length; i++) {
                        noteTagsModel.append({tag: mainView.tag.split(",")[i]})
                    }

                    noteLinksModel.clear()
                    var links = Storage.getLinks(mainView.id)
                    for (var i = 0; i < links.split(",").length; i++) {
                        noteLinksModel.append({'link': links.split(",")[i]})
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

                        iconSource: Qt.resolvedUrl("images/edit.svg")
                        text: i18n.tr("Edit")

                        onTriggered: {
                            pageStack.push(Qt.resolvedUrl("EditNotePage.qml"))
                        }
                    }
                }

                back: ToolbarButton {
                    action: Action {
                        id: back
                        objectName: "back"

                        iconSource: Qt.resolvedUrl("images/back.svg")
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

            function showNotesWithFilter (f) {
                filterNotesModel.clear()
                if (mainView.filter == "Tag") {
                    noteViewPage.allNotes = Storage.fetchAllNotesWithTag(f)
                }
                else {
                    noteViewPage.allNotes = Storage.fetchAllNotesWithCategory(f)
                }

                for (var i = 0; i < noteViewPage.allNotes.length; i++) {
                    var noteId = noteViewPage.allNotes[i]
                    filterNotesModel.append({id:noteId, title:Storage.getTitle(noteId), body:Storage.getBody(noteId),
                                         category:Storage.getCategory(noteId), tag:Storage.getTags(noteId), archive:Storage.getArchive(noteId),
                                         view:Storage.getView(noteId)})
                }
                pageStack.push(Qt.resolvedUrl("FilterNoteView.qml"))
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
