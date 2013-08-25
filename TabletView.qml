import QtQuick 2.0
import Ubuntu.Components 0.1

Page {
    id: tabletViewPage
    visible: false
    anchors.fill: parent
    title: "CNotes"

    Row {
        anchors.fill: parent

        NotesListView {
            id: mainPageTablet
            width: parent.width / 3
            height: parent.height
        }

        NoteView {
            id: noteViewTablet
            width: parent.width * 2 / 3
            height: parent.height
        }

    }
}
