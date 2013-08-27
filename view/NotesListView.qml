import QtQuick 2.0
import "../components"
import "../pages"

ListView {
    id: notesView
    anchors {
        fill: parent
        margins: units.gu(2)
    }

    model: mainView.notes
    delegate: NoteItem {
        _id: id
        _title: title
        _body: {
            if (body.length > 80)
                return body.substring(0, 80) + "..."
            return body
        }

        _tag: tag
        _category: category
        _archive: archive
        _view: view

        onPressAndHold: {
            PopupUtils.open(archiveRemoveComponent, null)
        }
    }
}
