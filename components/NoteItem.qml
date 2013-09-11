import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1
import "../Storage.js" as Storage
import "../view"

Subtitled {

    id: root
    removable: true
    backgroundIndicator: Label {
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        text: {
            if (_view === "main")
                return i18n.tr("Note will be moved to archive")
            return i18n.tr("Note will be moved back")
        }
    }

    property string _id
    property string _title
    property string _body
    property string _tag
    property string _category
    property string _archive
    property string _view
    property string _links

    text: getHtmlText(_title)
    subText: getHtmlText(_body)

    onItemRemoved: {
        var id

        mainView.createNote = false
        if (_view === "main") {
            id = _id
            mainView.backend.setNote(_id, _title, _body, _category, _tag, 'true', 'archive', _links, "archive")
            mainView.backend.removeNote(id, "notes")
        }
        else {
            id = _id
            mainView.backend.setNote(_id, _title, _body, _category, _tag, 'false', 'main', _links, "notes")
            mainView.backend.removeNote(id, "archive")
        }
    }

    onClicked: {
        mainView.mode = "view"
        mainView.id = _id
        mainView.title = _title
        mainView.body = _body
        mainView.category = _category
        mainView.tag = _tag
        mainView.position = model.index
        mainView.archive = _archive
        mainView.links = _links

        if (mainView.wideAspect)
            return

        rootPageStack.push (Qt.resolvedUrl("../view/NoteView.qml"))
    }


}
