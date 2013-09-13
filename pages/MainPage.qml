import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Layouts 0.1
import "../components"
import "../view"

Page {

//    U1Backend {
//        id: u1Backend
//    }

    id: mainPage
    title: i18n.tr("CNotes")
    visible: false

    tools: MainToolbar {}

    NotesListView {
        id: notesView
    }
}
