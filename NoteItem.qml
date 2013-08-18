import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1
import "Storage.js" as Storage

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

    text: _title
    subText: _body

    onItemRemoved: {
        if (_view === "main") {
            _archive = 'true'
            _view = "archive"
            Storage.setNote(_id, _title, _body, _category, _tag, _archive, _view)
            archivesModel.append({id:_id, title:_title, body:_body, category:_category, tag:_tag, archive:_archive, view:_view})
        }
        else {
            _archive = 'false'
            _view = "main"
            Storage.setNote(_id, _title, _body, _category, _tag, _archive, _view)
            archivesModel.remove(archivesPage.pos)
            notes.insert(_id, {id:parseInt(_id), title:_title, body:_body, category:_category, tag:_tag, archive:_archive, view:_view})
        }
    }


    onClicked: {
        mainView.id = _id
        mainView.title = _title
        mainView.body = _body
        mainView.category = _category
        mainView.tag = _tag
        mainView.position = model.index

        pageStack.push (noteViewPage)
    }
}
