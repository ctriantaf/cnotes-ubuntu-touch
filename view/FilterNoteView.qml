import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../components"

Page {
    id: filterNoteViewPage
    title: {
        if (mainView.filter == "tag")
            return mainView.filter + ": " + mainView.tag
        return mainView.filter + ": " + mainView.category
    }

    ListView {
        id: filterNoteView
        anchors {
            fill: parent
            margins: units.gu(2)
        }

        model: filterNotesModel
        delegate: NoteItem {
            _id: id
            _title: getHtmlText(title)
            _body: {
                if (body.length > 80)
                    return body.substring(0, 80) + "..."
                return body
            }

            _tag: tag
            _category: category
            _archive: archive
            _view: view
        }
    }
}
