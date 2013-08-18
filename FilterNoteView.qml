import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListIten

Page {
    id: filterNoteViewPage
    height: parent.height
    width: parent.width

    Header {
        id: header
        title: {
            if (mainView.filter == "tag")
                return i18n.tr("Notes with ") + mainView.filter + ": " + mainView.tag
            return i18n.tr("Notes with ") + mainView.filter + ": " + mainView.category
        }
    }

    ListView {
        id: filterNoteView
        height: parent.height - header.height
        width: parent.width
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }

        model: filterNotesModel
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
        }
    }
}
