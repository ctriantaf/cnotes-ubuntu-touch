import QtQuick 2.0

ListView {
    id: notesView
    anchors {
        fill: parent
        leftMargin: units.gu(2)
        rightMargin: units.gu(2)
    }

    spacing: 2
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
        _view: view
    }
}
